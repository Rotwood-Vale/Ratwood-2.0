/datum/keybinding/mob
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/mob/prevent_movement
	hotkey_keys = list("Ctrl")
	classic_keys = list("Ctrl")
	name = "block_movement"
	full_name = "锁定移动"
	description = "将我固定在原地，以便原地转向"
	//keybind_signal = COMSIG_KB_MOB_BLOCKMOVEMENT_DOWN

/datum/keybinding/mob/prevent_movement/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	user.movement_locked = TRUE

/datum/keybinding/mob/prevent_movement/up(client/user, turf/target)
	. = ..()
	if(.)
		return
	user.movement_locked = FALSE

/datum/keybinding/mob/block_movement
	hotkey_keys = list("CtrlShift")
	classic_keys = list("CtrlShift")
	name = "prevent_movement"
	full_name = "阻止移动"
	description = "彻底阻止我移动"

/datum/keybinding/mob/block_movement/down(client/user, turf/target, mousepos_x, mousepos_y)
	. = ..()
	if(.)
		return
	user.movement_blocked = TRUE

/datum/keybinding/mob/block_movement/up(client/user, turf/target)
	. = ..()
	if(.)
		return
	user.movement_blocked = FALSE

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
	full_name = "目标：切换头部"
	description = ""

/datum/keybinding/mob/target_head_cycle/down(client/user)
	user.body_toggle_head()
	return TRUE

/datum/keybinding/mob/target_eye_nose
	hotkey_keys = list("Numpad7")
	name = "target_eye_nose"
	full_name = "目标：切换眼鼻"
	description = ""

/datum/keybinding/mob/target_eye_nose/down(client/user)
	user.body_toggle_eye_nose()
	return TRUE

/datum/keybinding/mob/target_mouth_ears
	hotkey_keys = list("Numpad9")
	name = "target_mouth_ears"
	full_name = "目标：切换口耳"
	description = ""

/datum/keybinding/mob/target_mouth_ears/down(client/user)
	user.body_toggle_mouth_ears()
	return TRUE

/datum/keybinding/mob/target_r_arm
	hotkey_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "目标：右臂"
	description = ""

/datum/keybinding/mob/target_r_arm/down(client/user)
	user.body_r_arm()
	return TRUE

/datum/keybinding/mob/target_body_chest
	hotkey_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "目标：身体"
	description = ""

/datum/keybinding/mob/target_body_chest/down(client/user)
	user.body_chest()
	return TRUE

/datum/keybinding/mob/target_left_arm
	hotkey_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "目标：左臂"
	description = ""

/datum/keybinding/mob/target_left_arm/down(client/user)
	user.body_l_arm()
	return TRUE

/datum/keybinding/mob/target_right_leg
	hotkey_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "目标：右腿"
	description = ""

/datum/keybinding/mob/target_right_leg/down(client/user)
	user.body_r_leg()
	return TRUE

/datum/keybinding/mob/target_body_groin
	hotkey_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "目标：裆部"
	description = ""

/datum/keybinding/mob/target_body_groin/down(client/user)
	user.body_groin()
	return TRUE

/datum/keybinding/mob/target_left_leg
	hotkey_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "目标：左腿"
	description = ""

/datum/keybinding/mob/target_left_leg/down(client/user)
	user.body_l_leg()
	return TRUE

/datum/keybinding/mob/fly_up
	hotkey_keys = list("Northeast")
	name = "fly_up"
	full_name = "向上飞行"
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
				var/atom/movable/pulling = C.pulling
				var/time_taken = 1.5 SECONDS
				if(ismob(pulling))
					stamina_cost_final *= 2 //double our stamina cost if we're pulling someone with us
					time_taken *= 2
				if(do_after(C, time_taken))
					if(QDELETED(pulling) || C.pulling != pulling) // our grab could have been broken or the grabbed deleted while taking off
						pulling = null
					if(ismob(pulling))
						ADD_TRAIT(pulling, TRAIT_PREVENT_Z_FALL, "z_transition") // This is given to prevent them falling before we can regrab
						pulling.forceMove(turf_above)
					C.forceMove(turf_above)
					for(var/mob/buckled_living as anything in C.buckled_mobs)
						buckled_living.forceMove(turf_above)
					if(pulling)
						C.start_pulling(pulling, state = 1, supress_message = TRUE)
						if(C.pulling == pulling)
							C.buckle_mob(pulling, TRUE, TRUE, FALSE, 0, 0)
							var/obj/item/grabbing/I = C.get_inactive_held_item()
							if(istype(I, /obj/item/grabbing/))
								I.icon_state = null
						if(ismob(pulling))
							REMOVE_TRAIT(pulling, TRAIT_PREVENT_Z_FALL, "z_transition")
					C.stamina_add(stamina_cost_final)
					to_chat(C, span_notice("我向上飞去。"))
			else
				to_chat(C, span_red("我没法飞到上面去！！"))
		else
			to_chat(C, span_red("我并没有在飞！"))
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
			to_chat(mobius, span_notice("我向上移动了。"))
	else
		return
	return TRUE

/datum/keybinding/mob/fly_down
	hotkey_keys = list("Southeast")
	name = "fly_down"
	full_name = "向下飞行"
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
				var/atom/movable/pulling = C.pulling
				var/time_taken = 1.5 SECONDS
				if(ismob(pulling))
					stamina_cost_final *= 2 //double our stamina cost if we're pulling someone with us
					time_taken *= 2
				if(do_after(C, time_taken))
					if(QDELETED(pulling) || C.pulling != pulling) // our grab could have been broken or the grabbed deleted while taking off
						pulling = null
					if(ismob(pulling))
						ADD_TRAIT(pulling, TRAIT_PREVENT_Z_FALL, "z_transition") // This is given to prevent them falling before we can regrab
						pulling.forceMove(turf_below)
					C.forceMove(turf_below)
					for(var/mob/buckled_living as anything in C.buckled_mobs)
						buckled_living.forceMove(turf_below)
					if(pulling)
						C.start_pulling(pulling, state = 1, supress_message = TRUE)
						if(C.pulling == pulling)
							C.buckle_mob(pulling, TRUE, TRUE, FALSE, 0, 0)
							var/obj/item/grabbing/I = C.get_inactive_held_item()
							if(istype(I, /obj/item/grabbing/))
								I.icon_state = null
						if(ismob(pulling))
							REMOVE_TRAIT(pulling, TRAIT_PREVENT_Z_FALL, "z_transition")
					C.stamina_add(stamina_cost_final)
					to_chat(C, span_notice("我向下飞去。"))
			else
				to_chat(C, span_red("我没法飞到下面去！！"))
		else
			to_chat(C, span_red("我并没有在飞！"))
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
			to_chat(mobius, span_notice("我向下移动了。"))
	else
		return
	return TRUE
