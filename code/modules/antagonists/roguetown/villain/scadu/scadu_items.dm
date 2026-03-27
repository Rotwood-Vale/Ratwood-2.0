/obj/structure/scadu_monument
	name = "scadu stone"
	desc = "A jagged column of dark stone, slick with bog water. Runes pulse faintly in its surface."
	icon = 'icons/roguetown/mob/misc.dmi'
	icon_state = "hollow"
	density = TRUE
	anchored = TRUE
	max_integrity = 150
	light_system = STATIC_LIGHT
	light_outer_range = 3

	var/datum/antagonist/scadu/owner_datum = null
	var/standing = TRUE
	var/dormant = FALSE

/obj/structure/scadu_monument/Initialize(mapload)
	. = ..()

/obj/structure/scadu_monument/proc/start_lux_loop()
	dormant = FALSE
	name = initial(name)
	obj_integrity = max_integrity
	spawn(0)
		while(!QDELETED(src) && standing && !dormant)
			sleep(100)
			if(QDELETED(src) || !standing || dormant || !owner_datum || QDELETED(owner_datum))
				break
			owner_datum.add_lux(1)
			obj_integrity = min(obj_integrity + 10, max_integrity)
			var/mob/dead/observer/rogue/scadu/SM = owner_datum.scadu_mob
			for(var/mob/living/carbon/human/H in range(7, src))
				if(!H.client || !H.mind || HAS_TRAIT(H, TRAIT_ANTISCRYING))
					continue
				if(get_dist(H, src) <= 5)
					H.apply_status_effect(/datum/status_effect/buff/scadu_presence)
				if(!SM?.client)
					continue
				var/area/A = get_area(H)
				to_chat(SM, span_warning("A soul lingers near your monument. <b>[H.real_name]</b> in [A.name]. <a href='byond://?src=[REF(SM)];scadu_tp=[REF(src)]'>Go</a>"))
				break

/obj/structure/scadu_monument/proc/go_dormant()
	dormant = TRUE
	name = "dormant scadu stone"
	obj_integrity = 999999

/obj/structure/scadu_monument/attack_hand(mob/living/user)
	to_chat(user, span_warning("The stone is cold and slick. Dark runes shift under your touch."))

/obj/structure/scadu_monument/take_damage(damage_amount, damage_type, damage_flag, sound_effect, attack_dir)
	if(dormant)
		return
	var/mob/dead/observer/rogue/scadu/SM = owner_datum?.scadu_mob
	if(SM?.client)
		to_chat(SM, span_danger("A monument is under attack! <a href='byond://?src=[REF(SM)];scadu_tp=[REF(src)]'>Go</a>"))
	. = ..()

/obj/structure/scadu_monument/deconstruct(disassembled)
	if(standing)
		standing = FALSE
		visible_message(span_danger("The scadu stone cracks and collapses into the bog with a sickening groan!"))
		playsound(src, 'sound/magic/antimagic.ogg', 80, TRUE)
		var/turf/drop_turf = get_turf(src)
		new /obj/item/roguecoin/gold/pile(drop_turf)
		var/loot_type = pick(
			/obj/item/book/granter/spell_points,
			/obj/item/scadu_stat_potion/str,
			/obj/item/scadu_stat_potion/per,
			/obj/item/scadu_stat_potion/int,
			/obj/item/scadu_stat_potion/con,
			/obj/item/scadu_stat_potion/wil,
			/obj/item/scadu_stat_potion/spd,
			/obj/item/scadu_stat_potion/lck,
		)
		new loot_type(drop_turf)
		if(owner_datum && !QDELETED(owner_datum))
			owner_datum.on_monument_destroyed(src)
	qdel(src)

/obj/structure/scadu_monument/Destroy()
	if(owner_datum && !QDELETED(owner_datum))
		owner_datum.monuments -= src
	owner_datum = null
	return ..()

/obj/effect/scadu_miasma
	name = "bog miasma"
	desc = "A thick, foul mist that clings to the ground."
	icon = 'icons/effects/effects.dmi'
	icon_state = "smoke"
	color = "#3a5c2a"
	alpha = 180
	var/duration = 40 SECONDS
	var/pulse_rate = 1 SECONDS
	var/damage_per_pulse = 4

/obj/effect/scadu_miasma/Initialize(mapload)
	. = ..()
	addtimer(CALLBACK(src, PROC_REF(dissipate)), duration)
	INVOKE_ASYNC(src, PROC_REF(damage_loop))

/obj/effect/scadu_miasma/proc/damage_loop()
	while(!QDELETED(src))
		sleep(pulse_rate)
		if(QDELETED(src))
			break
		for(var/mob/living/carbon/human/H in loc)
			if(H.mob_biotypes & MOB_UNDEAD)
				continue
			H.adjustToxLoss(damage_per_pulse)
			to_chat(H, span_danger("You inhale the foul miasma. It burns your lungs!"))
			H.add_stress(/datum/stressevent/miasmagas)
		var/turf/next_turf = get_step(src, pick(GLOB.cardinals))
		if(next_turf && istype(get_area(next_turf), /area/rogue/outdoors/bograt))
			forceMove(next_turf)

/obj/effect/scadu_miasma/proc/dissipate()
	visible_message(span_notice("The bog mist slowly thins and fades."))
	qdel(src)

/datum/status_effect/buff/scadu_snared
	id = "scadu_snared"
	alert_type = /atom/movable/screen/alert/status_effect/buff/scadu_snared
	duration = 8 SECONDS
	status_type = STATUS_EFFECT_UNIQUE

/atom/movable/screen/alert/status_effect/buff/scadu_snared
	name = "Snared"
	desc = "My ankle is caught fast!"
	icon_state = "debuff"

/datum/status_effect/buff/scadu_snared/on_apply(mob/living/target)
	. = ..()
	target.add_movespeed_modifier("scadu_snared", update = TRUE, priority = 100, multiplicative_slowdown = 5, movetypes = GROUND)
	to_chat(target, span_userdanger("Your leg is caught fast!"))

/datum/status_effect/buff/scadu_snared/on_remove()
	owner.remove_movespeed_modifier("scadu_snared", TRUE)
	to_chat(owner, span_notice("You wrench yourself free."))
	. = ..()


/datum/status_effect/buff/scadu_terrored
	id = "scadu_terrored"
	alert_type = /atom/movable/screen/alert/status_effect/buff/scadu_terrored
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REPLACE

/atom/movable/screen/alert/status_effect/buff/scadu_terrored
	name = "Terrored"
	desc = "An unseen horror grips my mind."
	icon_state = "debuff"
	color = "#1a0a2e"

/datum/status_effect/buff/scadu_terrored/on_apply(mob/living/target)
	. = ..()
	owner.add_movespeed_modifier("scadu_terrored", update = TRUE, priority = 100, multiplicative_slowdown = 0.4, movetypes = GROUND)
	owner.confused = 15
	ADD_TRAIT(owner, TRAIT_PSYCHOSIS, "scadu_terrored")

/datum/status_effect/buff/scadu_terrored/on_remove()
	owner.remove_movespeed_modifier("scadu_terrored", TRUE)
	REMOVE_TRAIT(owner, TRAIT_PSYCHOSIS, "scadu_terrored")
	. = ..()

/datum/stressevent/scadu_terror
	timer = 3 MINUTES
	stressadd = 8
	desc = span_boldred("An unseen darkness watches me from the bog.")


/obj/item/scadu_stat_potion
	icon = 'icons/obj/structures/heart_items.dmi'
	icon_state = "blood_vial_empty"
	w_class = WEIGHT_CLASS_SMALL

/obj/item/scadu_stat_potion/attack_self(mob/living/carbon/human/user)
	if(!ishuman(user))
		return
	to_chat(user, span_notice("You drink [name]. A warmth spreads through you."))
	apply_stat(user)
	qdel(src)

/obj/item/scadu_stat_potion/proc/apply_stat(mob/living/carbon/human/user)
	return

/obj/item/scadu_stat_potion/str
	name = "murky vial of strength"
	desc = "A vial of dark bog water. It smells of iron and earth."
	color = "#cc3300"
/obj/item/scadu_stat_potion/str/apply_stat(mob/living/carbon/human/user)
	user.change_stat(STATKEY_STR, 1)

/obj/item/scadu_stat_potion/per
	name = "murky vial of perception"
	desc = "A vial of dark bog water. Something stares back from within."
	color = "#33aacc"
/obj/item/scadu_stat_potion/per/apply_stat(mob/living/carbon/human/user)
	user.change_stat(STATKEY_PER, 1)

/obj/item/scadu_stat_potion/int
	name = "murky vial of intellect"
	desc = "A vial of dark bog water. The liquid seems to shift on its own."
	color = "#9933ff"
/obj/item/scadu_stat_potion/int/apply_stat(mob/living/carbon/human/user)
	user.change_stat(STATKEY_INT, 1)

/obj/item/scadu_stat_potion/con
	name = "murky vial of constitution"
	desc = "A vial of dark bog water. Dense and foul-smelling."
	color = "#336600"
/obj/item/scadu_stat_potion/con/apply_stat(mob/living/carbon/human/user)
	user.change_stat(STATKEY_CON, 1)

/obj/item/scadu_stat_potion/wil
	name = "murky vial of willpower"
	desc = "A vial of dark bog water. It seems to resist being opened."
	color = "#cc9900"
/obj/item/scadu_stat_potion/wil/apply_stat(mob/living/carbon/human/user)
	user.change_stat(STATKEY_WIL, 1)

/obj/item/scadu_stat_potion/spd
	name = "murky vial of speed"
	desc = "A vial of dark bog water. It swirls constantly."
	color = "#00ccaa"
/obj/item/scadu_stat_potion/spd/apply_stat(mob/living/carbon/human/user)
	user.change_stat(STATKEY_SPD, 1)

/obj/item/scadu_stat_potion/lck
	name = "murky vial of fortune"
	desc = "A vial of dark bog water. Feel lucky?"
	color = "#ffcc00"
/obj/item/scadu_stat_potion/lck/apply_stat(mob/living/carbon/human/user)
	user.change_stat(STATKEY_LCK, 1)

/obj/item/divination_rod
	name = "divination rod"
	desc = "A gnarled stick of bog-wood. It twitches when pointed toward a scadu stone."
	icon = 'icons/roguetown/items/natural.dmi'
	icon_state = "stick1"
	grid_width = 32
	grid_height = 32
	color = "#fffcef"
	w_class = WEIGHT_CLASS_SMALL

	var/obj/structure/scadu_monument/target = null

/obj/item/divination_rod/attack_self(mob/living/carbon/human/user)
	if(!target || QDELETED(target))
		var/datum/antagonist/scadu/antag = GLOB.scadu_persistent_datum
		if(!antag || QDELETED(antag) || !antag.monuments.len)
			to_chat(user, span_warning("The rod finds no monument to seek."))
			return
		var/list/found = list()
		for(var/obj/structure/scadu_monument/M in antag.monuments)
			if(!QDELETED(M) && M.standing)
				found += M
		if(!found.len)
			to_chat(user, span_warning("The rod finds no monument to seek."))
			return
		target = pick(found)
		to_chat(user, span_notice("The rod quivers and locks onto something."))
		return

	var/turf/T = get_turf(target)
	if(!T)
		to_chat(user, span_warning("The rod goes still. Its mark is lost."))
		target = null
		return

	var/skill_level = user.get_skill_level(/datum/skill/magic/holy)
	var/chance = min(50 + skill_level * 10, 95)

	var/dir_text
	if(prob(chance))
		dir_text = dir2text(get_dir(user, target))
	else
		var/turf/random_target = locate(rand(1, world.maxx), rand(1, world.maxy), user.z)
		dir_text = dir2text(get_dir(user, random_target))

	to_chat(user, span_notice("The rod strains toward the [dir_text]."))

/atom/movable/screen/fullscreen/scadu_presence
	icon_state = "oxydamageoverlay2"
	layer = UI_DAMAGE_LAYER
	plane = FULLSCREEN_PLANE

/datum/status_effect/buff/scadu_presence
	id = "scadu_presence"
	alert_type = /atom/movable/screen/alert/status_effect/buff/scadu_presence
	duration = 15 SECONDS
	status_type = STATUS_EFFECT_REPLACE

/atom/movable/screen/alert/status_effect/buff/scadu_presence
	name = "Watched"
	desc = "Something unseen presses close."
	icon_state = "debuff"
	color = "#2a1a3e"

/datum/status_effect/buff/scadu_presence/on_apply(mob/living/target)
	. = ..()
	if(!.)
		return
	owner.overlay_fullscreen("scadu_presence", /atom/movable/screen/fullscreen/scadu_presence)
	owner.playsound_local(get_turf(owner), pick('sound/vo/mobs/ghost/whisper (1).ogg','sound/vo/mobs/ghost/whisper (2).ogg','sound/vo/mobs/ghost/whisper (3).ogg'), 3, TRUE)

/datum/status_effect/buff/scadu_presence/on_remove()
	owner.clear_fullscreen("scadu_presence")
	. = ..()
