#define RHYTHM_NONE 0
#define RHYTHM_RESONATING 1
#define RHYTHM_CONCUSSIVE 2
#define RHYTHM_REGENERATING 3
#define RHYTHM_MALAISE 4

#define RHYTHM_COOLDOWN 9 SECONDS
#define RHYTHM_WINDOW 8 SECONDS
#define RHYTHM_RESONATING_DAMAGE 20
#define RHYTHM_REGEN_DURATION 10 SECONDS
#define RHYTHM_REGEN_TICK 0.5
#define RHYTHM_MALAISE_DURATION 3 SECONDS
#define RHYTHM_MALAISE_SLOWDOWN 0.2

#define CRESCENDO_STACKS 3
#define CRESCENDO_DECAY 20 SECONDS
#define CRESCENDO_RESONATING_DAMAGE 55
#define CRESCENDO_CONCUSSIVE_DAMAGE 25
#define CRESCENDO_MENDING_DURATION 30 SECONDS
#define CRESCENDO_MENDING_TICK 1

#define RHYTHM_FILTER "rhythm_glow"
#define CRESCENDO_FILTER "crescendo_glow"
#define BARDIC_RHYTHM_COLOR "#c77dff"

/proc/rhythm_name(rhythm_type)
	switch(rhythm_type)
		if(RHYTHM_RESONATING)
			return "Resonating"
		if(RHYTHM_CONCUSSIVE)
			return "Concussive"
		if(RHYTHM_REGENERATING)
			return "Regenerating"
		if(RHYTHM_MALAISE)
			return "Malaise"
	return "Unknown"

/proc/bardic_get_frontal_turfs(mob/living/user)
	var/list/turfs = list()
	var/facing = user.dir
	var/left = turn(facing, 90)
	var/right = turn(facing, -90)
	var/turf/center = get_turf(user)
	for(var/i in 1 to 3)
		center = get_step(center, facing)
		if(!center)
			break
		turfs += center
		var/turf/L = get_step(center, left)
		if(L)
			turfs += L
		var/turf/R = get_step(center, right)
		if(R)
			turfs += R
	return turfs

/proc/bardic_clear_primed_rhythms(mob/living/carbon/human/user, obj/effect/proc_holder/spell/self/rhythm/except)
	if(!user?.mind)
		return
	for(var/obj/effect/proc_holder/spell/self/rhythm/known_rhythm in user.mind.spell_list)
		if(known_rhythm == except || !known_rhythm.primed)
			continue
		known_rhythm.clear_prime(user)

/datum/rhythm_tracker
	var/greater_stacks = 0
	var/last_rhythm_type = RHYTHM_NONE
	var/last_proc_time = 0
	var/decay_timer_id = null

/datum/rhythm_tracker/proc/on_rhythm_proc(rhythm_type)
	check_decay()
	last_rhythm_type = rhythm_type
	last_proc_time = world.time
	greater_stacks = min(greater_stacks + 1, CRESCENDO_STACKS)
	if(decay_timer_id)
		deltimer(decay_timer_id)
	decay_timer_id = addtimer(CALLBACK(src, PROC_REF(decay_stacks)), CRESCENDO_DECAY, TIMER_STOPPABLE)

/datum/rhythm_tracker/proc/check_decay()
	if(greater_stacks > 0 && (world.time - last_proc_time) >= CRESCENDO_DECAY)
		decay_stacks()

/datum/rhythm_tracker/proc/decay_stacks()
	if(decay_timer_id)
		deltimer(decay_timer_id)
		decay_timer_id = null
	if(greater_stacks > 0)
		greater_stacks = 0
		last_rhythm_type = RHYTHM_NONE

/datum/rhythm_tracker/Destroy()
	if(decay_timer_id)
		deltimer(decay_timer_id)
		decay_timer_id = null
	return ..()

/obj/effect/proc_holder/spell/self/rhythm
	name = "Rhythm"
	desc = "Attune your weapon to a rhythm. Your next melee hit within 8 seconds triggers its effect."
	action_icon = 'icons/mob/actions/bardsongs.dmi'
	action_icon_state = "rhythm_resonating"
	action_background_icon_state = "spell"
	sound = list('sound/magic/buffrollaccent.ogg')
	recharge_time = RHYTHM_COOLDOWN
	releasedrain = 10
	associated_skill = /datum/skill/misc/music
	human_req = TRUE
	stat_allowed = FALSE
	invocation_type = "none"
	var/rhythm_type = RHYTHM_NONE
	var/primed = FALSE
	var/prime_timer_id = null

/obj/effect/proc_holder/spell/self/rhythm/update_icon()
	if(!action)
		return
	action.icon_icon = action_icon
	action.button_icon_state = action_icon_state
	action.background_icon_state = action_background_icon_state
	action.name = name
	action.UpdateButtonIcon(force = TRUE)

/obj/effect/proc_holder/spell/self/rhythm/cast(list/targets, mob/living/carbon/human/user)
	if(!user?.inspiration || user.inspiration.level < BARD_T2)
		to_chat(user, span_warning("I do not know how to hold a battle rhythm."))
		return FALSE
	if(!has_instrument(user))
		to_chat(user, span_warning("I need an instrument in hand to perform!"))
		return FALSE
	prime_rhythm(user)
	return TRUE

/obj/effect/proc_holder/spell/self/rhythm/proc/has_instrument(mob/living/carbon/human/user)
	for(var/obj/item/held in user.held_items)
		if(istype(held, /obj/item/rogue/instrument))
			return TRUE
	return FALSE

/obj/effect/proc_holder/spell/self/rhythm/proc/clear_prime(mob/living/user, cancel_timer = TRUE)
	primed = FALSE
	UnregisterSignal(user, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	if(cancel_timer && prime_timer_id)
		deltimer(prime_timer_id)
	prime_timer_id = null
	user.remove_filter(RHYTHM_FILTER)

/obj/effect/proc_holder/spell/self/rhythm/proc/prime_rhythm(mob/living/carbon/human/user)
	bardic_clear_primed_rhythms(user, src)
	primed = TRUE
	user.add_filter(RHYTHM_FILTER, 2, list("type" = "outline", "color" = BARDIC_RHYTHM_COLOR, "alpha" = 100, "size" = 1))
	to_chat(user, span_info("I attune my weapon to a [name] rhythm."))
	user.visible_message(span_warning("[user]'s weapon resonates with a [name] rhythm."))
	RegisterSignal(user, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(on_melee_hit))
	prime_timer_id = addtimer(CALLBACK(src, PROC_REF(rhythm_fizzle), user), RHYTHM_WINDOW, TIMER_STOPPABLE)

/obj/effect/proc_holder/spell/self/rhythm/proc/on_melee_hit(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	if(!primed)
		return
	if(!isliving(target) || target == user || target.stat == DEAD)
		return
	if(check_rhythm_defense(target, user))
		clear_prime(user)
		return COMPONENT_ITEM_NO_ATTACK
	clear_prime(user)
	apply_rhythm(target, user)
	var/mob/living/carbon/human/H = user
	if(istype(H) && H.inspiration?.rhythm_tracker)
		H.inspiration.rhythm_tracker.on_rhythm_proc(rhythm_type)
		if(H.inspiration.level >= BARD_T3)
			if(H.inspiration.rhythm_tracker.greater_stacks >= CRESCENDO_STACKS)
				H.balloon_alert_to_viewers("Crescendo ready!")
			else
				H.balloon_alert_to_viewers("Crescendo [H.inspiration.rhythm_tracker.greater_stacks]/[CRESCENDO_STACKS]")
	return COMPONENT_ITEM_NO_DEFENSE

/obj/effect/proc_holder/spell/self/rhythm/proc/rhythm_fizzle(mob/living/user)
	if(!primed)
		return
	clear_prime(user, FALSE)
	to_chat(user, span_warning("I failed to strike in time. My rhythm fades."))

/obj/effect/proc_holder/spell/self/rhythm/Destroy()
	if(primed && action?.owner)
		var/mob/living/user = action.owner
		clear_prime(user)
	if(prime_timer_id)
		deltimer(prime_timer_id)
		prime_timer_id = null
	return ..()

/obj/effect/proc_holder/spell/self/rhythm/proc/apply_rhythm(mob/living/target, mob/living/user)
	return

/obj/effect/proc_holder/spell/self/rhythm/proc/check_rhythm_defense(mob/living/target, mob/living/user)
	if(rhythm_type == RHYTHM_RESONATING && target.d_intent == INTENT_PARRY)
		return FALSE
	return target.checkdefense(user.used_intent, user)

/obj/effect/proc_holder/spell/self/rhythm/resonating
	name = "Resonating Rhythm"
	desc = "Prime a parry-bypassing strike for 20 brute damage to your aimed location. Armor still applies."
	action_icon_state = "rhythm_resonating"
	rhythm_type = RHYTHM_RESONATING

/obj/effect/proc_holder/spell/self/rhythm/resonating/apply_rhythm(mob/living/target, mob/living/user)
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	var/armor_block = target.run_armor_check(def_zone, "slash", damage = RHYTHM_RESONATING_DAMAGE)
	target.apply_damage(RHYTHM_RESONATING_DAMAGE, BRUTE, def_zone, armor_block)
	new /obj/effect/temp_visual/kinetic_blast(get_turf(target))
	target.visible_message(span_danger("Rhythmic force reverberates through [target]!"), span_userdanger("Rhythmic force reverberates through my body!"))
	playsound(target, 'sound/magic/blade_burst.ogg', 50, TRUE)

/obj/effect/proc_holder/spell/self/rhythm/concussive
	name = "Concussive Rhythm"
	desc = "Prime a strike that repels the target by 1 tile."
	action_icon_state = "rhythm_concussive"
	rhythm_type = RHYTHM_CONCUSSIVE

/obj/effect/proc_holder/spell/self/rhythm/concussive/apply_rhythm(mob/living/target, mob/living/user)
	new /obj/effect/temp_visual/kinetic_blast(get_turf(target))
	if(!(target.move_resist >= MOVE_FORCE_STRONG || target.anchored))
		var/push_dir = get_dir(user, target)
		if(!push_dir)
			push_dir = user.dir
		target.safe_throw_at(get_ranged_target_turf(target, push_dir, 1), 1, 1, user, force = MOVE_FORCE_STRONG)
	target.visible_message(span_danger("[user]'s strike repels [target] backward!"), span_userdanger("[user]'s strike repels me backward!"))
	playsound(target, 'sound/magic/repulse.ogg', 50, TRUE)

/obj/effect/proc_holder/spell/self/rhythm/regenerating
	name = "Regenerating Rhythm"
	desc = "Prime a strike that heals you for 0.5 per tick for 10 seconds."
	action_icon_state = "rhythm_regenerating"
	rhythm_type = RHYTHM_REGENERATING

/obj/effect/proc_holder/spell/self/rhythm/regenerating/apply_rhythm(mob/living/target, mob/living/user)
	user.apply_status_effect(/datum/status_effect/buff/healing/rhythm_regen)
	new /obj/effect/temp_visual/heal_rogue(get_turf(user))
	to_chat(user, span_info("A soothing rhythm mends my wounds."))
	playsound(user, 'sound/magic/heal.ogg', 40, TRUE)

/obj/effect/proc_holder/spell/self/rhythm/malaise
	name = "Malaise Rhythm"
	desc = "Prime a strike that leaves the target sluggish for a short time."
	action_icon_state = "rhythm_frigid"
	rhythm_type = RHYTHM_MALAISE

/obj/effect/proc_holder/spell/self/rhythm/malaise/apply_rhythm(mob/living/target, mob/living/user)
	target.apply_status_effect(/datum/status_effect/debuff/bardic_malaise)
	target.visible_message(span_danger("[target] staggers under a draining malaise!"), span_userdanger("A draining malaise makes my limbs heavy!"))
	playsound(target, 'sound/magic/debuffroll.ogg', 40, TRUE)

/datum/status_effect/debuff/bardic_malaise
	id = "bardic_malaise"
	alert_type = /atom/movable/screen/alert/status_effect/debuff/bardic_malaise
	duration = RHYTHM_MALAISE_DURATION

/atom/movable/screen/alert/status_effect/debuff/bardic_malaise
	name = "Malaise"
	desc = "A cold, draining rhythm weighs down your limbs."
	icon_state = "chilled"

/datum/status_effect/debuff/bardic_malaise/on_apply()
	. = ..()
	var/mob/living/carbon/C = owner
	if(istype(C))
		C.add_movespeed_modifier("bardic_malaise", multiplicative_slowdown = RHYTHM_MALAISE_SLOWDOWN)

/datum/status_effect/debuff/bardic_malaise/on_remove()
	var/mob/living/carbon/C = owner
	if(istype(C))
		C.remove_movespeed_modifier("bardic_malaise")
	return ..()

/datum/status_effect/buff/healing/rhythm_regen
	id = "rhythm_regen"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = RHYTHM_REGEN_DURATION
	healing_on_tick = RHYTHM_REGEN_TICK
	outline_colour = BARDIC_RHYTHM_COLOR

/datum/status_effect/buff/healing/rhythm_regen/on_creation(mob/living/new_owner, new_healing_on_tick = healing_on_tick, is_inhumen = FALSE)
	return ..(new_owner, new_healing_on_tick, is_inhumen)

/obj/effect/proc_holder/spell/self/crescendo
	name = "Crescendo"
	desc = "Prime your next melee strike to unleash a 3x3 blast based on your last rhythm. Build 3 rhythm procs to unlock."
	action_icon = 'icons/mob/actions/bardsongs.dmi'
	action_icon_state = "crescendo"
	action_background_icon_state = "spell"
	sound = list('sound/magic/charged.ogg')
	recharge_time = 2 SECONDS
	releasedrain = 0
	associated_skill = /datum/skill/misc/music
	human_req = TRUE
	stat_allowed = FALSE
	invocation_type = "none"
	var/primed = FALSE
	var/prime_timer_id = null

/obj/effect/proc_holder/spell/self/crescendo/update_icon()
	if(!action)
		return
	action.icon_icon = action_icon
	action.button_icon_state = action_icon_state
	action.background_icon_state = action_background_icon_state
	action.name = name
	action.UpdateButtonIcon(force = TRUE)

/obj/effect/proc_holder/spell/self/crescendo/cast(list/targets, mob/living/carbon/human/user)
	if(!user?.inspiration || user.inspiration.level < BARD_T3)
		to_chat(user, span_warning("I cannot build a crescendo yet."))
		return FALSE
	if(!user.inspiration.rhythm_tracker)
		user.inspiration.rhythm_tracker = new
	user.inspiration.rhythm_tracker.check_decay()
	if(user.inspiration.rhythm_tracker.greater_stacks < CRESCENDO_STACKS)
		to_chat(user, span_warning("I haven't built enough rhythm yet! ([user.inspiration.rhythm_tracker.greater_stacks]/[CRESCENDO_STACKS])"))
		return FALSE
	if(user.inspiration.rhythm_tracker.last_rhythm_type == RHYTHM_NONE)
		return FALSE
	primed = TRUE
	user.add_filter(CRESCENDO_FILTER, 2, list("type" = "outline", "color" = BARDIC_RHYTHM_COLOR, "alpha" = 180, "size" = 2))
	user.visible_message(span_warning("[user]'s weapon surges with building power!"))
	to_chat(user, span_info("I channel my crescendo.. the moment is fleeting!"))
	user.balloon_alert_to_viewers("Crescendo primed!")
	RegisterSignal(user, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY, PROC_REF(on_melee_hit))
	prime_timer_id = addtimer(CALLBACK(src, PROC_REF(crescendo_fizzle), user), RHYTHM_WINDOW, TIMER_STOPPABLE)
	return TRUE

/obj/effect/proc_holder/spell/self/crescendo/proc/on_melee_hit(mob/living/source, mob/living/target, mob/living/user, obj/item/weapon)
	SIGNAL_HANDLER
	if(!primed)
		return
	if(!isliving(target) || target == user || target.stat == DEAD)
		return
	primed = FALSE
	UnregisterSignal(user, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	if(prime_timer_id)
		deltimer(prime_timer_id)
		prime_timer_id = null
	user.remove_filter(CRESCENDO_FILTER)
	var/mob/living/carbon/human/H = user
	if(!istype(H) || !H.inspiration?.rhythm_tracker)
		return
	var/tname = rhythm_name(H.inspiration.rhythm_tracker.last_rhythm_type)
	H.visible_message(span_danger("[H] unleashes a [tname] Crescendo!"))
	playsound(H, 'sound/magic/antimagic.ogg', 60, TRUE)
	switch(H.inspiration.rhythm_tracker.last_rhythm_type)
		if(RHYTHM_RESONATING)
			crescendo_resonating(H)
		if(RHYTHM_CONCUSSIVE)
			crescendo_concussive(H)
		if(RHYTHM_REGENERATING)
			crescendo_regenerating(H)
		if(RHYTHM_MALAISE)
			crescendo_malaise(H)
	H.inspiration.rhythm_tracker.greater_stacks = 0
	H.inspiration.rhythm_tracker.last_rhythm_type = RHYTHM_NONE

/obj/effect/proc_holder/spell/self/crescendo/proc/crescendo_fizzle(mob/living/user)
	if(!primed)
		return
	primed = FALSE
	prime_timer_id = null
	UnregisterSignal(user, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
	user.remove_filter(CRESCENDO_FILTER)
	to_chat(user, span_warning("My crescendo fades, the resonance is gone..."))

/obj/effect/proc_holder/spell/self/crescendo/Destroy()
	if(primed && action?.owner)
		var/mob/living/user = action.owner
		UnregisterSignal(user, COMSIG_MOB_ITEM_ATTACK_POST_SWINGDELAY)
		user.remove_filter(CRESCENDO_FILTER)
	if(prime_timer_id)
		deltimer(prime_timer_id)
		prime_timer_id = null
	return ..()

/obj/effect/proc_holder/spell/self/crescendo/proc/crescendo_resonating(mob/living/carbon/human/user)
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	for(var/turf/T in bardic_get_frontal_turfs(user))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/mob/living/L in T)
			if(L == user || L.stat == DEAD)
				continue
			var/armor_block = L.run_armor_check(def_zone, "slash", damage = CRESCENDO_RESONATING_DAMAGE)
			L.apply_damage(CRESCENDO_RESONATING_DAMAGE, BRUTE, def_zone, armor_block)
			L.visible_message(span_danger("A wave of rhythmic force reverberates through [L]!"))

/obj/effect/proc_holder/spell/self/crescendo/proc/crescendo_concussive(mob/living/carbon/human/user)
	var/def_zone = user.zone_selected || BODY_ZONE_CHEST
	for(var/turf/T in bardic_get_frontal_turfs(user))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/mob/living/L in T)
			if(L == user || L.stat == DEAD)
				continue
			var/armor_block = L.run_armor_check(def_zone, "blunt", damage = CRESCENDO_CONCUSSIVE_DAMAGE)
			L.apply_damage(CRESCENDO_CONCUSSIVE_DAMAGE, BRUTE, def_zone, armor_block)
			if(!(L.anchored || L.move_resist >= MOVE_FORCE_STRONG))
				var/push_dir = get_dir(user, L)
				if(!push_dir)
					push_dir = user.dir
				L.safe_throw_at(get_ranged_target_turf(L, push_dir, 3), 3, 2, user, force = MOVE_FORCE_STRONG)
			L.visible_message(span_danger("[L] is repelled by the concussive blast!"))

/obj/effect/proc_holder/spell/self/crescendo/proc/crescendo_regenerating(mob/living/carbon/human/user)
	if(!user.inspiration)
		return
	for(var/mob/living/carbon/human/ally in user.inspiration.audience)
		if(ally.stat == DEAD)
			continue
		if(!(ally in hearers(10, user)))
			continue
		ally.apply_status_effect(/datum/status_effect/buff/healing/crescendo_mending)
		new /obj/effect/temp_visual/heal_rogue(get_turf(ally))
		to_chat(ally, span_info("A mending melody washes over me."))

/obj/effect/proc_holder/spell/self/crescendo/proc/crescendo_malaise(mob/living/carbon/human/user)
	for(var/turf/T in bardic_get_frontal_turfs(user))
		new /obj/effect/temp_visual/kinetic_blast(T)
		for(var/mob/living/L in T)
			if(L == user || L.stat == DEAD)
				continue
			L.apply_status_effect(/datum/status_effect/debuff/bardic_malaise)
			L.visible_message(span_danger("[L] is overcome by a draining malaise!"))

/datum/status_effect/buff/healing/crescendo_mending
	id = "crescendo_mending"
	alert_type = /atom/movable/screen/alert/status_effect/buff/healing
	duration = CRESCENDO_MENDING_DURATION
	healing_on_tick = CRESCENDO_MENDING_TICK
	outline_colour = BARDIC_RHYTHM_COLOR

/datum/status_effect/buff/healing/crescendo_mending/on_creation(mob/living/new_owner, new_healing_on_tick = healing_on_tick, is_inhumen = FALSE)
	return ..(new_owner, new_healing_on_tick, is_inhumen)

#undef RHYTHM_FILTER
#undef CRESCENDO_FILTER
#undef BARDIC_RHYTHM_COLOR
