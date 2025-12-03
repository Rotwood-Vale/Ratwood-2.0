//Frost Stacks
/proc/add_frost_stacks(var/mob/living/target)
	if(target.has_status_effect(/datum/status_effect/buff/frost/one)) // 1 >> 2
		target.remove_status_effect(/datum/status_effect/buff/frost/one)
		target.apply_status_effect(/datum/status_effect/buff/frost/two)

	else if(target.has_status_effect(/datum/status_effect/buff/frost/two)) // 2 >> 3 
		target.remove_status_effect(/datum/status_effect/buff/frost/two)
		target.apply_status_effect(/datum/status_effect/buff/frost/three)

	else if(target.has_status_effect(/datum/status_effect/buff/frost/three)) // 3 >> 4
		target.remove_status_effect(/datum/status_effect/buff/frost/three)
		target.apply_status_effect(/datum/status_effect/buff/frost/four)

	else if(target.has_status_effect(/datum/status_effect/buff/frost/four)) // 4+ burst damage and end debuff
		target.remove_status_effect(/datum/status_effect/buff/frost/four)
		target.adjustFireLoss(12)
		target.adjustBruteLoss(12)
		playsound(get_turf(target), 'sound/combat/fracture/fracturedry (2).ogg', 80, TRUE, soundping = TRUE)
		new /obj/effect/temp_visual/snap_freeze(get_turf(target))

	else // 0 >> 1
		target.apply_status_effect(/datum/status_effect/buff/frost/one)

/proc/remove_frost_stacks(var/mob/living/target)
	var/damage = 0
	if(target.has_status_effect(/datum/status_effect/buff/frost/one))
		target.remove_status_effect(/datum/status_effect/buff/frost/one)
		damage = 2
	if(target.has_status_effect(/datum/status_effect/buff/frost/two))
		target.remove_status_effect(/datum/status_effect/buff/frost/two)
		damage = 4
	if(target.has_status_effect(/datum/status_effect/buff/frost/three))
		target.remove_status_effect(/datum/status_effect/buff/frost/three)
		damage = 8
	if(target.has_status_effect(/datum/status_effect/buff/frost/four))
		target.remove_status_effect(/datum/status_effect/buff/frost/four)
		damage = 16
	
	if(damage > 0)	
		playsound(get_turf(target), 'sound/combat/fracture/fracturewet (1).ogg', 80, TRUE, soundping = TRUE)
		playsound(get_turf(target), 'sound/items/firesnuff.ogg', 100)
		new /obj/effect/temp_visual/snap_freeze(get_turf(target))
		target.adjustFireLoss(damage)
		target.adjustBruteLoss(damage)
		target.visible_message(span_warning("[target] is rapidly defrosted!"))

/datum/status_effect/buff/frost
	id = "frost"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frost
	duration = 20 SECONDS
	effectedstats = list("speed" = -1)
	var/init_stam_loss = 0
	var/gradual_stam_loss = 4
	var/apply_color = FALSE
	var/apply_breath = FALSE
	var/slowdown = 0
	var/shiver_prob = 10
	var/static/mutable_appearance/breath = mutable_appearance('icons/roguetown/mob/coldbreath.dmi', "breath_m", ABOVE_ALL_MOB_LAYER)
	var/sound = 'sound/combat/fracture/fracturedry (1).ogg'
	var/newcolor = rgb(136, 191, 255)

/datum/status_effect/buff/frost/one
	id = "chilly"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frost/one
	duration = 20 SECONDS
	effectedstats = list("speed" = -1)
	shiver_prob = 10

/datum/status_effect/buff/frost/two
	id = "shivering"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frost/two
	duration = 10 SECONDS
	effectedstats = list("speed" = -2)
	init_stam_loss = 5
	apply_color = FALSE
	apply_breath = TRUE
	slowdown = 2
	shiver_prob = 20
	sound = 'sound/combat/fracture/fracturedry (2).ogg'

/datum/status_effect/buff/frost/three
	id = "frostbitten"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frost/three
	duration = 5 SECONDS
	effectedstats = list("speed" = -3)
	init_stam_loss = 10
	apply_color = TRUE
	apply_breath = TRUE
	slowdown = 4
	shiver_prob = 30
	sound = 'sound/combat/fracture/fracturedry (3).ogg'

/datum/status_effect/buff/frost/four
	id = "frozen"
	alert_type = /atom/movable/screen/alert/status_effect/buff/frost/four
	duration = 2 SECONDS
	effectedstats = list("speed" = -4)
	init_stam_loss = 25
	apply_color = TRUE
	apply_breath = TRUE
	slowdown = 8
	shiver_prob = 40
	sound = 'sound/combat/fracture/fracturewet (3).ogg'

/atom/movable/screen/alert/status_effect/buff/frost
	name = "Shivering"
	desc = "My body can't stop shaking."
	icon_state = "debuff"

/atom/movable/screen/alert/status_effect/buff/frost/one
	name = "Chilly"
	desc = "I feel a bit cold"

/atom/movable/screen/alert/status_effect/buff/frost/two
	name = "Shivering"
	desc = "My body can't stop shaking."

/atom/movable/screen/alert/status_effect/buff/frost/three
	name = "Frostbitten"
	desc = "My limbs are frozen stiff!"

/atom/movable/screen/alert/status_effect/buff/frost/four
	name = "Frozen"
	desc = "I am so cold I can't move!"

/datum/status_effect/buff/frost/on_apply()
	. = ..()
	var/mob/living/target = owner
	playsound(get_turf(target), sound, 80, TRUE, soundping = TRUE)
	target.add_overlay(breath)
	
	target.stamina_add(init_stam_loss)
	if (apply_color)
		target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
		addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), duration)
	if(slowdown > 0)
		target.add_movespeed_modifier(MOVESPEED_ID_ADMIN_VAREDIT, update=TRUE, priority=100, multiplicative_slowdown=slowdown, movetypes=GROUND)
	target.update_vision_cone()

/datum/status_effect/buff/frost/tick()
	var/mob/living/target = owner
	if(prob(shiver_prob))
		target.emote(pick("shiver"))
		target.stamina_add(gradual_stam_loss)

/datum/status_effect/buff/frost/on_remove()
	var/mob/living/target = owner
	target.cut_overlay(breath)
	target.remove_movespeed_modifier(MOVESPEED_ID_ADMIN_VAREDIT, TRUE)
	target.update_vision_cone()
	. = ..()

/datum/status_effect/buff/witherd
	id = "withered"
	alert_type = /atom/movable/screen/alert/status_effect/buff/witherd
	duration = 30 SECONDS
	effectedstats = list(STATKEY_SPD = -2,STATKEY_STR = -2,STATKEY_CON= -2,STATKEY_WIL = -2)

/atom/movable/screen/alert/status_effect/buff/witherd
	name = "Withering"
	desc = "I can feel my physical prowess waning."
	icon_state = "debuff"
	color = "#b884f8" //talk about a coder sprite x2


/datum/status_effect/buff/witherd/on_apply()
	. = ..()
	to_chat(owner, span_warning("I feel sapped of vitality!"))
	var/mob/living/target = owner
	target.update_vision_cone()
	var/newcolor = rgb(207, 135, 255)
	target.add_atom_colour(newcolor, TEMPORARY_COLOUR_PRIORITY)
	addtimer(CALLBACK(target, TYPE_PROC_REF(/atom, remove_atom_colour), TEMPORARY_COLOUR_PRIORITY, newcolor), 30 SECONDS)

/datum/status_effect/buff/witherd/on_remove()
	. = ..()
	to_chat(owner, span_warning("I feel my physical prowess returning."))

/datum/status_effect/buff/lightningstruck
	id = "lightningstruck"
	alert_type = /atom/movable/screen/alert/status_effect/buff/lightningstruck
	duration = 6 SECONDS
	effectedstats = list(STATKEY_SPD = -2)

/atom/movable/screen/alert/status_effect/buff/lightningstruck
	name = "Lightning Struck"
	desc = "I can feel the electricity coursing through me."
	icon_state = "debuff"
	color = "#ffff00"

/datum/status_effect/buff/lightningstruck/on_apply()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.add_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, update=TRUE, priority=100, multiplicative_slowdown=4, movetypes=GROUND)

/datum/status_effect/buff/lightningstruck/on_remove()
	. = ..()
	var/mob/living/target = owner
	target.update_vision_cone()
	target.remove_movespeed_modifier(MOVESPEED_ID_LIGHTNINGSTRUCK, TRUE)
