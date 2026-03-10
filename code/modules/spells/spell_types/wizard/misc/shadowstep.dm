/obj/effect/proc_holder/spell/invoked/shadowstep
	name = "Shadowstep"
	desc = "Project your shadow to swap places with it, teleporting several feet away."
	cost = 3
	xp_gain = TRUE
	releasedrain = 30
	warnie = "spellwarning"
	movement_interrupt = TRUE
	associated_skill = /datum/skill/magic/arcane
	overlay_state = "shadowstep"
	chargedrain = 1
	chargetime = 0 SECONDS
	recharge_time = 15 SECONDS
	hide_charge_effect = TRUE
	gesture_required = TRUE // Mobility spell
	spell_tier = 2
	req_items = list(/obj/item/clothing/mask/rogue/lordmask/naledi)
	// This is super telegraphed so it shouldn't need any whisper. It can stay silent as a unique.
	var/area_of_effect = 1
	var/max_range = 7
	var/turf/destination_turf
	var/turf/user_turf
	var/mutable_appearance/tile_effect
	var/mutable_appearance/target_effect
	var/datum/looping_sound/invokeshadow/shadowloop

//Resets the tile and turf effects.
/obj/effect/proc_holder/spell/invoked/shadowstep/proc/reset(silent = FALSE)
	if(tile_effect && destination_turf)
		destination_turf.cut_overlay(tile_effect)
		qdel(tile_effect)
		destination_turf = null
	if(user_turf && target_effect)
		user_turf.cut_overlay(target_effect)
		qdel(target_effect)
		user_turf = null
	update_icon()

/obj/effect/proc_holder/spell/invoked/shadowstep/proc/check_path(turf/Tu, turf/Tt)
	var/dist = get_dist(Tt, Tu)
	var/last_dir
	var/turf/last_step
	if(Tu.z > Tt.z)
		last_step = get_step_multiz(Tu, DOWN)
	else if(Tu.z < Tt.z)
		last_step = get_step_multiz(Tu, UP)
	else
		last_step = locate(Tu.x, Tu.y, Tu.z)
	var/success = FALSE
	for(var/i = 0, i <= dist, i++)
		last_dir = get_dir(last_step, Tt)
		var/turf/Tstep = get_step(last_step, last_dir)
		if(!Tstep.density)
			success = TRUE
			var/list/cont = Tstep.GetAllContents(/obj/structure/roguewindow)
			for(var/obj/structure/roguewindow/W in cont)
				if(W.climbable && !W.opacity)	//It's climbable and can be seen through
					success = TRUE
					continue
				else if(!W.climbable)
					success = FALSE
					return success
		else
			success = FALSE
			return success
		last_step = Tstep
	return success

//Successful teleport, complete reset.
/obj/effect/proc_holder/spell/invoked/shadowstep/proc/tp(mob/user)
	if(destination_turf)
		if(do_teleport(user, destination_turf, no_effects=TRUE))
			log_admin("[user.real_name]([key_name(user)] Shadowstepped from X:[user_turf.x] Y:[user_turf.y] Z:[user_turf.z] to X:[destination_turf.x] Y:[destination_turf.y] Z:[destination_turf.z] in area: [get_area(destination_turf)]")
			if(user.m_intent == MOVE_INTENT_SNEAK)
				playsound(user_turf, 'sound/magic/shadowstep.ogg', 20, FALSE)
				playsound(destination_turf, 'sound/magic/shadowstep.ogg', 20, FALSE)
			else
				playsound(user_turf, 'sound/magic/shadowstep.ogg', 100, FALSE)
				playsound(destination_turf, 'sound/magic/shadowstep.ogg', 100, FALSE)
			reset(silent = TRUE)

/obj/effect/proc_holder/spell/invoked/shadowstep/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])
	if(!istransparentturf(T))
		var/reason
		if(max_range >= get_dist(user, T) && !T.density)
			if(check_path(get_turf(user), T))	//We check for opaque turfs or non-climbable windows in the way via a simple pathfind.
				if(get_dist(user, T) < 2 && user.z == T.z)
					to_chat(user, span_info("Too close!"))
					revert_cast()
					return

				//Hacky LoS borrowed from blinks.
				var/turf/start = get_turf(user)
				var/list/turf_list = getline(start, T)
				// Remove the last turf (target location) from the check
				if(length(turf_list) > 0)
					turf_list.len--
				for(var/turf/turf in turf_list)
					if(turf.density)
						to_chat(user, span_warning("There's something in the way!"))//A check before the other checks, for hacky LoS, without including doors.
						revert_cast()
						return

				to_chat(user, span_info("I begin to meld with the shadows.."))
				lockon(T, user)
				if(do_after(user, 5 SECONDS))
					tp(user)
				else
					reset(silent = TRUE)
					revert_cast()
				return
			else
				to_chat(user, span_info("The path is blocked!"))
				revert_cast()
				return
		else if(get_dist(user, T) > max_range)
			reason = "It's too far."
			revert_cast()
		else if (T.density)
			reason = "It's a wall!"
			revert_cast()
		to_chat(user, span_info("I cannot shadowstep there! "+"[reason]"))
	else
		to_chat(user, span_info("I cannot shadowstep there!"))
		revert_cast()
	. = ..()

//Plays affects at target Turf
/obj/effect/proc_holder/spell/invoked/shadowstep/proc/lockon(turf/T, mob/user)
	if(user.m_intent == MOVE_INTENT_SNEAK)
		playsound(T, 'sound/magic/shadowstep_destination.ogg', 20, FALSE, 5)
	else
		playsound(T, 'sound/magic/shadowstep_destination.ogg', 100, FALSE, 5)
	tile_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "curse", layer = 18)
	target_effect = mutable_appearance(icon = 'icons/effects/effects.dmi', icon_state = "curse", layer = 18)
	user_turf = get_turf(user)
	destination_turf = T
	user_turf.add_overlay(target_effect)
	destination_turf.add_overlay(tile_effect)
