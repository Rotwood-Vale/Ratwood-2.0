/datum/keybinding/mob
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB


/datum/keybinding/mob/face_north
	hotkey_keys = list("CtrlW", "CtrlNorth")
	classic_keys = list("CtrlNorth")
	name = "face_north"
	full_name = "Face North"
	description = ""

/datum/keybinding/mob/face_north/down(client/user)
	var/mob/M = user.mob
	M.northface()
	return TRUE


/datum/keybinding/mob/face_east
	hotkey_keys = list("CtrlD", "CtrlEast")
	classic_keys = list("CtrlEast")
	name = "face_east"
	full_name = "Face East"
	description = ""

/datum/keybinding/mob/face_east/down(client/user)
	var/mob/M = user.mob
	M.eastface()
	return TRUE


/datum/keybinding/mob/face_south
	hotkey_keys = list("CtrlS", "CtrlSouth")
	classic_keys = list("CtrlSouth")
	name = "face_south"
	full_name = "Face South"
	description = ""

/datum/keybinding/mob/face_south/down(client/user)
	var/mob/M = user.mob
	M.southface()
	return TRUE

/datum/keybinding/mob/face_west
	hotkey_keys = list("CtrlA", "CtrlWest")
	classic_keys = list("CtrlWest")
	name = "face_west"
	full_name = "Face West"
	description = ""

/datum/keybinding/mob/face_west/down(client/user)
	var/mob/M = user.mob
	M.westface()
	return TRUE
/*
/datum/keybinding/mob/stop_pulling
	hotkey_keys = list("Z")
	classic_keys = list("Z")
	name = "stop_pulling"
	full_name = "Stop pulling"
	description = ""

/datum/keybinding/mob/stop_pulling/down(client/user)
	var/mob/M = user.mob
	if(!M.pulling)
		to_chat(user, span_notice("I are not pulling anything."))
	else
		M.stop_pulling()
	return TRUE
*/
/*
/datum/keybinding/mob/toggle_move_intent
	hotkey_keys = list("Alt")
	name = "toggle_move_intent"
	full_name = "Hold to toggle move intent"
	description = "Held down to cycle to the other move intent, release to cycle back"

/datum/keybinding/mob/toggle_move_intent/down(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE

/datum/keybinding/mob/toggle_move_intent/up(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE

/datum/keybinding/mob/toggle_move_intent_alternative
	hotkey_keys = list("Unbound")
	name = "toggle_move_intent_alt"
	full_name = "press to cycle move intent"
	description = "Pressing this cycle to the opposite move intent, does not cycle back"

/datum/keybinding/mob/toggle_move_intent_alternative/down(client/user)
	var/mob/M = user.mob
	M.toggle_move_intent()
	return TRUE
*/
/datum/keybinding/mob/target_head_cycle
	hotkey_keys = list("Numpad8")
	name = "target_head_cycle"
	full_name = "Target: Cycle head"
	description = ""

/datum/keybinding/mob/target_head_cycle/down(client/user)
	user.body_toggle_head()
	return TRUE

/datum/keybinding/mob/target_eye_nose
	hotkey_keys = list("Numpad7")
	name = "target_eye_nose"
	full_name = "Target: Cycle eyes and nose"
	description = ""

/datum/keybinding/mob/target_eye_nose/down(client/user)
	user.body_toggle_eye_nose()
	return TRUE

/datum/keybinding/mob/target_mouth_ears
	hotkey_keys = list("Numpad9")
	name = "target_mouth_ears"
	full_name = "Target: Cycle mouth and ears"
	description = ""

/datum/keybinding/mob/target_mouth_ears/down(client/user)
	user.body_toggle_mouth_ears()
	return TRUE

/datum/keybinding/mob/target_r_arm
	hotkey_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "Target: right arm"
	description = ""

/datum/keybinding/mob/target_r_arm/down(client/user)
	user.body_r_arm()
	return TRUE

/datum/keybinding/mob/target_body_chest
	hotkey_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "Target: Body"
	description = ""

/datum/keybinding/mob/target_body_chest/down(client/user)
	user.body_chest()
	return TRUE

/datum/keybinding/mob/target_left_arm
	hotkey_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "Target: left arm"
	description = ""

/datum/keybinding/mob/target_left_arm/down(client/user)
	user.body_l_arm()
	return TRUE

/datum/keybinding/mob/target_right_leg
	hotkey_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "Target: Right leg"
	description = ""

/datum/keybinding/mob/target_right_leg/down(client/user)
	user.body_r_leg()
	return TRUE

/datum/keybinding/mob/target_body_groin
	hotkey_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "Target: Groin"
	description = ""

/datum/keybinding/mob/target_body_groin/down(client/user)
	user.body_groin()
	return TRUE

/datum/keybinding/mob/target_left_leg
	hotkey_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "Target: left leg"
	description = ""

/datum/keybinding/mob/target_left_leg/down(client/user)
	user.body_l_leg()
	return TRUE

/datum/keybinding/mob/fly_up
	hotkey_keys = list("Northeast")
	name = "fly_up"
	full_name = "Fly Up"
	description = ""
	category = CATEGORY_HUMAN

/datum/keybinding/mob/fly_up/down(client/user)
	if(iscarbon(user.mob))
		var/mob/living/carbon/C = user.mob
		if(C.flying)
			var/turf/open/transparent/openspace/turf_above = get_step_multiz(C, UP)
			if(C.canZMove(UP, turf_above))
				var/athletics_skill = max(C.get_skill_level(/datum/skill/misc/athletics), SKILL_LEVEL_NOVICE)
				var/stamina_cost_final = round((10 - athletics_skill), 1)
				var/mob/living/carbon/human/pulling = C.pulling
				var/time_taken = 1.5 SECONDS
				if(ismob(pulling))
					stamina_cost_final *= 2 //double our stamina cost if we're pulling someone with us
					time_taken *= 2
				if(do_after(C, time_taken))
					if(ismob(C.pulling))
						C.pulling.forceMove(turf_above)
					C.forceMove(turf_above)
					C.start_pulling(pulling, state = 1, supress_message = TRUE)
					if(C.pulling)
						C.buckle_mob(pulling, TRUE, TRUE, FALSE, 0, 0)
						var/obj/item/grabbing/I = C.get_inactive_held_item()
						if(istype(I, /obj/item/grabbing/))
							I.icon_state = null
					C.stamina_add(stamina_cost_final)
					to_chat(C, span_notice("I fly upwards."))
			else
				to_chat(C, span_red("I can't fly up there!!"))
		else
			to_chat(C, span_red("I'm not flying!"))
	else if(istype(user.mob, /mob/living/simple_animal/hostile/retaliate/bat))
		var/mob/living/simple_animal/hostile/retaliate/bat/mobius = user.mob
		var/turf/open/transparent/openspace/turf_above = get_step_multiz(mobius, UP)
		if(mobius.canZMove(UP, turf_above))
			if(!do_after(mobius, mobius.fly_time))
				return
			mobius.forceMove(turf_above)
	else if(user.mob.flying)
		var/mob/mobius = user.mob
		if(mobius.zMove(UP, TRUE))
			to_chat(mobius, span_notice("I move upwards."))
	else
		return
	return TRUE

/datum/keybinding/mob/fly_down
	hotkey_keys = list("Southeast")
	name = "fly_down"
	full_name = "Fly Down"
	description = ""
	category = CATEGORY_HUMAN

/datum/keybinding/mob/fly_down/down(client/user)
	if(iscarbon(user.mob))
		var/mob/living/carbon/C = user.mob
		if(C.flying)
			var/turf/open/transparent/openspace/turf_below = get_step_multiz(C, DOWN)
			if(C.canZMove(DOWN, turf_below))
				var/athletics_skill = max(C.get_skill_level(/datum/skill/misc/athletics), SKILL_LEVEL_NOVICE)
				var/stamina_cost_final = round((10 - athletics_skill), 1)
				var/mob/living/carbon/human/pulling = C.pulling
				var/time_taken = 1.5 SECONDS
				if(ismob(pulling))
					stamina_cost_final *= 2 //double our stamina cost if we're pulling someone with us
					time_taken *= 2
				if(do_after(C, time_taken))
					if(ismob(C.pulling))
						C.pulling.forceMove(turf_below)
					C.forceMove(turf_below)
					C.start_pulling(pulling, state = 1, supress_message = TRUE)
					if(C.pulling)
						C.buckle_mob(pulling, TRUE, TRUE, FALSE, 0, 0)
						var/obj/item/grabbing/I = C.get_inactive_held_item()
						if(istype(I, /obj/item/grabbing/))
							I.icon_state = null
					C.stamina_add(stamina_cost_final)
					to_chat(C, span_notice("I fly downwards."))
			else
				to_chat(C, span_red("I can't fly down there!!"))
		else
			to_chat(C, span_red("I'm not flying!"))
	else if(istype(user.mob, /mob/living/simple_animal/hostile/retaliate/bat))
		var/mob/living/simple_animal/hostile/retaliate/bat/mobius = user.mob
		var/turf/open/transparent/openspace/turf_below = get_step_multiz(mobius, DOWN)
		if(mobius.canZMove(DOWN, turf_below))
			if(!do_after(mobius, mobius.fly_time))
				return
			mobius.forceMove(turf_below)
	else if(user.mob.flying)
		var/mob/mobius = user.mob
		if(mobius.zMove(DOWN, TRUE))
			to_chat(mobius, span_notice("I move downwards."))
	else
		return
	return TRUE
