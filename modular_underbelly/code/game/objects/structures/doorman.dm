/*
	THE DOORMAN
	A two-part gate system for the Underbelly.

	The machine (obj/structure/doorman) handles access logic:
	  - Scum (TRAIT_UNDERBELLY_SCUM): touch it for flavor, then click the pipe
	  - Token (scum_pass coin): consumed on contact, grants single-mob clearance
	  - Lockpick: skill-gated, high failure rate, loud on miss, grants clearance on success
	  - Force breach: 110-second bash with confirmation, alerts all Scum on start, opens pipe to anyone for 60s

	The pipe (obj/structure/fluff/traveltile/underbelly/pipe) is the actual transit point.
	It checks clearance before letting anyone through.

	Mapper setup:
	  - Place the doorman with a unique doorman_id string (e.g. "east_gate")
	  - Place the pipe adjacent to it with matching doorman_id, aportalgoesto set to the destination tile's aportalid
	  - Place destination traveltiles underground as normal
*/

GLOBAL_LIST_EMPTY(doormen)

#define DOORMAN_CLEARANCE_DURATION (30 SECONDS)
#define DOORMAN_BREACH_OPEN_DURATION (60 SECONDS)

// ——————————————————————————————————
// DOORMAN MACHINE
// ——————————————————————————————————

/obj/structure/doorman
	name = "The Doorman"
	desc = "A heavy golden panel machine set flush into the wall. Cold to the touch, slick with condensation."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "camera"
	density = TRUE
	anchored = TRUE
	max_integrity = 999
	/// Paired to the pipe with the same doorman_id. Set this in the map editor.
	var/doorman_id = "REPLACETHIS"
	/// The one mob currently cleared for single entry
	var/datum/weakref/cleared_ref = null
	var/cleared_until = 0
	/// Nonzero while a force breach is in progress, prevents stacking
	var/being_breached = FALSE
	/// world.time deadline while breached open
	var/breached_until = 0

/obj/structure/doorman/Initialize(mapload)
	. = ..()
	GLOB.doormen += src

/obj/structure/doorman/Destroy()
	GLOB.doormen -= src
	return ..()

/obj/structure/doorman/attack_hand(mob/user)
	if(!isliving(user))
		return
	var/mob/living/L = user

	if(HAS_TRAIT(L, TRAIT_UNDERBELLY_SCUM))
		L.visible_message(
			span_notice("[L] places a palm on [src]. The machine gives a short, dry click."),
			span_notice("I touch [src]. It knows me.")
		)
		grant_clearance(L)
		return

	to_chat(L, span_warning("The panel is cold and unresponsive."))
	. = ..()

/obj/structure/doorman/attackby(obj/item/I, mob/user, params)
	if(istype(I, /obj/item/roguecoin/scum_pass))
		qdel(I)
		playsound(loc, 'sound/foley/coinphy (1).ogg', 50, TRUE)
		to_chat(user, span_notice("The coin slots into a groove on the panel. Something inside clicks."))
		grant_clearance(user)
		return

	if(istype(I, /obj/item/lockpick) || istype(I, /obj/item/lockpick/goldpin))
		attempt_lockpick(I, user)
		return

	if(I.force > 0)
		if(being_breached)
			to_chat(user, span_warning("Someone's already working on it."))
			return
		var/confirm = alert(user, "Forcing the gate open will alert every member of the Underbelly. Are you sure?", "Force Breach", "Yes", "No")
		if(confirm != "Yes" || QDELETED(src))
			return
		attempt_force_breach(I, user)
		return

	. = ..()

/obj/structure/doorman/proc/grant_clearance(mob/living/user)
	cleared_ref = WEAKREF(user)
	cleared_until = world.time + DOORMAN_CLEARANCE_DURATION

/obj/structure/doorman/proc/has_clearance(mob/living/user)
	if(!cleared_ref || world.time > cleared_until)
		cleared_ref = null
		return FALSE
	return cleared_ref.resolve() == user

/obj/structure/doorman/proc/consume_clearance()
	cleared_ref = null
	cleared_until = 0

/obj/structure/doorman/proc/is_breached()
	return world.time < breached_until

/obj/structure/doorman/proc/attempt_lockpick(obj/item/lockpick/pick, mob/living/user)
	var/pickskill = user.get_skill_level(/datum/skill/misc/lockpicking)
	var/chance
	switch(pickskill)
		if(0 to 1)
			chance = 1
		if(2 to 3)
			chance = 15
		if(4 to 5)
			chance = 25
		else
			chance = 35

	to_chat(user, span_warning("I work the pick against the mechanism..."))

	if(!do_after(user, 5 SECONDS, target = src) || QDELETED(src))
		return

	if(prob(chance))
		playsound(loc, pick('sound/items/pickgood1.ogg', 'sound/items/pickgood2.ogg'), 35, TRUE)
		to_chat(user, span_notice("Something shifts. You feel the mechanism give."))
		grant_clearance(user)
		if(user.mind)
			add_sleep_experience(user, /datum/skill/misc/lockpicking, user.STAINT / 2)
	else
		playsound(loc, 'sound/items/pickbad.ogg', 80, TRUE)
		to_chat(user, span_warning("The pick slips with a clatter."))
		pick.take_damage(ceil(pick.max_integrity * 0.4), BRUTE, "blunt")
		if(user.mind)
			add_sleep_experience(user, /datum/skill/misc/lockpicking, user.STAINT / 4)

/obj/structure/doorman/proc/attempt_force_breach(obj/item/weapon, mob/living/user)
	being_breached = TRUE

	var/area/A = get_area(src)
	for(var/mob/living/carbon/human/M in GLOB.player_list)
		if(!HAS_TRAIT(M, TRAIT_UNDERBELLY_SCUM))
			continue
		if(!M.client)
			continue
		to_chat(M, span_danger("<b>The Doorman at [A] is being assailed!</b>"))

	playsound(loc, pick('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
	user.visible_message(
		span_warning("[user] starts hammering at [src]!"),
		span_warning("I put my weight into [src]...")
	)

	// Each successful hit adds to breach progress. Threshold is 10 hits worth.
	// Hit chance = STR * 4, clamped 10-85. At 14 STR: 56%. Requires multiple successes.
	var/progress = 0
	var/threshold = 10
	while(progress < threshold)
		if(!do_after(user, 11 SECONDS, target = src) || QDELETED(src))
			being_breached = FALSE
			to_chat(user, span_warning("I back off."))
			return
		var/str_chance = clamp(user.STASTR * 4, 10, 85)
		if(prob(str_chance))
			progress++
			playsound(loc, pick('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
			to_chat(user, span_warning("It buckles slightly. ([progress]/[threshold])"))
		else
			playsound(loc, 'sound/items/pickbad.ogg', 80, TRUE)
			to_chat(user, span_warning("The gate holds. My blow glances off."))

	being_breached = FALSE
	breached_until = world.time + DOORMAN_BREACH_OPEN_DURATION
	playsound(loc, pick('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg', 'sound/combat/hits/onmetal/grille (3).ogg'), 100, TRUE)
	user.visible_message(
		span_warning("[user] forces [src] open with a crash!"),
		span_notice("The gate gives. I'm through.")
	)

	for(var/mob/living/carbon/human/M in GLOB.player_list)
		if(!HAS_TRAIT(M, TRAIT_UNDERBELLY_SCUM))
			continue
		if(!M.client)
			continue
		to_chat(M, span_danger("<b>The Doorman at [A] has been breached! It will reseal in [DOORMAN_BREACH_OPEN_DURATION / 10] seconds!</b>"))

// ——————————————————————————————————
// UNDERBELLY PIPE (transit tile)
// ——————————————————————————————————

/obj/structure/fluff/traveltile/underbelly/pipe
	name = "iron pipe"
	desc = "A large iron pipe with a heavy gate fitted across its mouth."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pipe"
	density = TRUE
	layer = TABLE_LAYER
	plane = GAME_PLANE_LOWER
	/// Must match the doorman_id of the paired doorman machine.
	var/doorman_id = "REPLACETHIS"

/obj/structure/fluff/traveltile/underbelly/pipe/Crossed(atom/movable/AM)
	return // no auto-transit; must click

/obj/structure/fluff/traveltile/underbelly/pipe/attack_hand(mob/user)
	if(!isliving(user))
		return
	var/mob/living/L = user

	if(L.recent_travel && world.time < L.recent_travel + 15 SECONDS)
		return

	if(HAS_TRAIT(L, TRAIT_UNDERBELLY_SCUM))
		_do_travel(L)
		return

	var/obj/structure/doorman/D = _get_doorman()
	if(!D)
		to_chat(L, span_warning("The gate is sealed tight."))
		return

	if(D.is_breached())
		_do_travel(L)
		return

	if(D.has_clearance(L))
		D.consume_clearance()
		_do_travel(L)
		return

	to_chat(L, span_warning("The gate is sealed. You have no business below."))

/obj/structure/fluff/traveltile/underbelly/pipe/proc/_get_doorman()
	for(var/obj/structure/doorman/D in GLOB.doormen)
		if(D.doorman_id == doorman_id)
			return D
	return null

/obj/structure/fluff/traveltile/underbelly/pipe/examine(mob/user)
	. = ..()
	var/list/nearby = list()
	for(var/mob/living/M in range(4, src))
		if(M == user || M.stat == DEAD)
			continue
		nearby += M.name
	if(length(nearby))
		. += span_warning("You can make out movement on this side of the gate: [english_list(nearby)].")
	else
		. += span_notice("The area around the gate seems quiet.")

/obj/structure/fluff/traveltile/underbelly/pipe/proc/_do_travel(mob/living/L)
	L.visible_message(
		span_notice("[L] slips through the pipe gate and hauls it shut with a heavy clank, locking it behind them."),
		span_notice("I squeeze through and drag the gate shut. It locks with a thud.")
	)
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			perform_travel(T, L)
			return
	to_chat(L, span_warning("It is a dead end."))

// ——————————————————————————————————
// UNDERGROUND EXIT TILE
// Place this on the underground side, aportalgoesto pointing back to the surface pipe's aportalid.
// doorman_id must match the paired surface pipe so examine shows who's waiting Flipside.
// ——————————————————————————————————

/obj/structure/fluff/traveltile/underbelly_pipe_exit
	name = "pipe exit"
	desc = "A heavy gate fitted to the pipe mouth. Leads back to the surface."
	icon = 'icons/roguetown/misc/structure.dmi'
	icon_state = "pipe"
	density = TRUE
	anchored = TRUE
	layer = TABLE_LAYER
	plane = GAME_PLANE_LOWER
	max_integrity = 0
	/// Must match the doorman_id of the paired surface pipe.
	var/doorman_id = "REPLACETHIS"

/obj/structure/fluff/traveltile/underbelly_pipe_exit/Initialize(mapload)
	GLOB.traveltiles += src
	. = ..()

/obj/structure/fluff/traveltile/underbelly_pipe_exit/Destroy()
	GLOB.traveltiles -= src
	. = ..()

/obj/structure/fluff/traveltile/underbelly_pipe_exit/Crossed(atom/movable/AM)
	return // click only

/obj/structure/fluff/traveltile/underbelly_pipe_exit/examine(mob/user)
	. = ..()
	var/obj/structure/fluff/traveltile/underbelly/pipe/P = _get_surface_pipe()
	if(!P)
		return
	var/list/nearby = list()
	for(var/mob/living/M in range(4, P))
		if(M.stat == DEAD)
			continue
		nearby += M.name
	if(length(nearby))
		. += span_warning("Peering through the grate, you can make out figures on the other side: [english_list(nearby)].")
	else
		. += span_notice("The other side looks clear.")

/obj/structure/fluff/traveltile/underbelly_pipe_exit/attack_hand(mob/user)
	if(!isliving(user))
		return
	var/mob/living/L = user
	if(L.recent_travel && world.time < L.recent_travel + 15 SECONDS)
		return
	_attempt_exit(L)

/obj/structure/fluff/traveltile/underbelly_pipe_exit/proc/_attempt_exit(mob/living/L)
	var/obj/structure/fluff/traveltile/underbelly/pipe/P = _get_surface_pipe()
	if(P)
		for(var/mob/living/M in range(4, P))
			to_chat(M, span_warning("You hear clattering through the pipe -- someone is coming through."))
	to_chat(L, span_notice("I push on the gate..."))
	if(!do_after(L, 5 SECONDS, target = src) || QDELETED(src))
		return
	for(var/obj/structure/fluff/traveltile/T in shuffle(GLOB.traveltiles))
		if(T.aportalid == aportalgoesto)
			if(T == src)
				continue
			L.visible_message(
				span_notice("[L] hauls open the pipe gate and steps out, pulling it shut behind them."),
				span_notice("I shoulder through and pull the gate closed.")
			)
			perform_travel(T, L)
			return
	to_chat(L, span_warning("It is a dead end."))

/obj/structure/fluff/traveltile/underbelly_pipe_exit/proc/_get_surface_pipe()
	for(var/obj/structure/fluff/traveltile/underbelly/pipe/P in GLOB.traveltiles)
		if(P.doorman_id == doorman_id)
			return P
	return null

#undef DOORMAN_CLEARANCE_DURATION
#undef DOORMAN_BREACH_OPEN_DURATION
