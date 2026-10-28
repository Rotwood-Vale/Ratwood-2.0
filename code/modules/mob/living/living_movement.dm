/mob/living/Moved(atom/OldLoc, Dir, Forced = FALSE)
	. = ..()
	stop_looking()
	update_turf_movespeed(loc)
	update_pixel_shifting(TRUE)
//	if(m_intent == MOVE_INTENT_RUN)
//		consider_ambush()

	if(!client)
		return
	var/turf/old_turf = get_turf(OldLoc)
	var/turf/new_turf = get_turf(src)
	if(Forced || !old_turf || !new_turf || (old_turf.z != new_turf.z) || get_dist(old_turf, new_turf) > 1)
		shadow_glide_id++
		update_dynamic_shadows()
		return

	var/ticks_to_move = 1
	if(glide_size > 0)
		ticks_to_move = round(world.icon_size / glide_size)

	var/total_points = clamp(ticks_to_move, 1, 5)

	if(total_points <= 1)
		shadow_glide_id++
		update_dynamic_shadows()
		return

	var/start_px = old_turf.x + 0.5 + (pixel_x / 32.0)
	var/start_py = old_turf.y + 0.5 + (pixel_y / 32.0)
	var/end_px = new_turf.x + 0.5 + (pixel_x / 32.0)
	var/end_py = new_turf.y + 0.5 + (pixel_y / 32.0)

	shadow_glide_id++
	smooth_shadow_glide(start_px, start_py, end_px, end_py, shadow_glide_id, total_points)


/mob/living/proc/smooth_shadow_glide(start_px, start_py, end_px, end_py, this_id, total_points)
	set waitfor = FALSE
	var/sleep_delay = world.tick_lag

	for(var/i in 1 to total_points)
		if(this_id != shadow_glide_id || !client)
			return

		var/progress = i / total_points
		var/curr_px = start_px + (end_px - start_px) * progress
		var/curr_py = start_py + (end_py - start_py) * progress

		update_dynamic_shadows(curr_px, curr_py)

		if(i < total_points)
			sleep(sleep_delay)

/mob/living/setDir(newdir, ismousemovement)
	. = ..()
	if(ismousemovement)
		update_pixel_shifting()

/mob/living/proc/update_pixel_shifting(moved = FALSE)
	if(moved)
		unpixel_shift()

/mob/living/CanPass(atom/movable/mover, turf/target)
	if(!mover)
		return ..()
	if((mover.pass_flags & PASSMOB))
		return TRUE
	if(istype(mover, /obj/projectile))
		var/obj/projectile/P = mover
		return !P.can_hit_target(src, P.permutated, src == P.original, TRUE)
	if(mover?.throwing)
		return (!density || !(mobility_flags & MOBILITY_STAND) || wallpressed || (mover.throwing.thrower == src && !ismob(mover)))
	if(buckled == mover)
		return TRUE
	if(ismob(mover))
		if(mover in buckled_mobs)
			return TRUE
		if(isliving(mover))
			var/mob/living/M = mover
			if(M.wallpressed)
				return !wallpressed
	return (!density || wallpressed || !(mobility_flags & MOBILITY_STAND))

/mob/living/toggle_move_intent()
	. = ..()
	update_move_intent_slowdown()

/mob/living/toggle_rogmove_intent()
	. = ..()
	update_move_intent_slowdown()
/*
/mob/living/update_sneak_invis()
	if(m_intent = MOVE_INTENT_SNEAK)
*/
/mob/living/def_intent_change()
	. = ..()
	update_move_intent_slowdown()

/mob/living/update_config_movespeed()
	update_move_intent_slowdown()
	return ..()

/mob/living/proc/update_move_intent_slowdown()
	var/mod = 0
	switch(m_intent)
		if(MOVE_INTENT_WALK)
			mod = CONFIG_GET(number/movedelay/walk_delay)
		if(MOVE_INTENT_RUN)
			mod = CONFIG_GET(number/movedelay/run_delay)
		if(MOVE_INTENT_SNEAK)
			if(HAS_TRAIT(src, TRAIT_LIGHT_STEP))
				mod = CONFIG_GET(number/movedelay/walk_delay) * 1.3
			else
				mod = 6

		if(MOVE_INTENT_SNEAK)
			var/base_walk = CONFIG_GET(number/movedelay/walk_delay)
			var/default_delay = 6
			if(HAS_TRAIT(src, TRAIT_LIGHT_STEP))
				default_delay = base_walk * 1.3
			var/skill = get_skill_level(/datum/skill/misc/sneaking)
			var/skill_mod = 1.6 - (skill * 0.1)
			var/skill_delay = base_walk * skill_mod
			mod = min(default_delay, skill_delay)


	var/spdchange = (10-STASPD)*0.1
	var/speed_limit = HAS_TRAIT(src, TRAIT_UNCAPPED_SPEED) ? -2 : -0.5
	spdchange = clamp(spdchange, speed_limit, 1)  //if this is not clamped, maniacs will run at unfathomable speed
	mod = max(mod+spdchange, 0.1)
	//maximum speed is achieved at 15spd, everything else results in insanity
	add_movespeed_modifier(MOVESPEED_ID_MOB_WALK_RUN_CONFIG_SPEED, TRUE, 100, override = TRUE, multiplicative_slowdown = mod)

/mob/living/proc/update_turf_movespeed(turf/open/T)
	if(!isopenturf(T))
		remove_movespeed_modifier(MOVESPEED_ID_LIVING_TURF_SPEEDMOD)
		return
	if((movement_type & (FLYING|FLOATING)) || flying)
		remove_movespeed_modifier(MOVESPEED_ID_LIVING_TURF_SPEEDMOD)
		return
	if(SEND_SIGNAL(src, COMSIG_LIVING_UPDATE_TURF_MOVESPEED) & TURF_MOVESPEED_BLOCKED)
		return
	var/usedslow = 0
	if(!HAS_TRAIT(src, TRAIT_TRAM_MOVER))
		usedslow = T.get_slowdown(src)
	if(usedslow != 0)
		add_movespeed_modifier(MOVESPEED_ID_LIVING_TURF_SPEEDMOD, update=TRUE, priority=100, multiplicative_slowdown=usedslow, movetypes=GROUND)
	else
		remove_movespeed_modifier(MOVESPEED_ID_LIVING_TURF_SPEEDMOD)

/turf/open
	var/mob_overlay

/turf/open/proc/get_mob_overlay()
	return mob_overlay

/mob/living/proc/update_charging_movespeed(datum/intent/I)
	if(I)
		add_movespeed_modifier(MOVESPEED_ID_CHARGING, update=TRUE, priority=100, override=TRUE, multiplicative_slowdown=I.charging_slowdown, movetypes=GROUND)
	else
		remove_movespeed_modifier(MOVESPEED_ID_CHARGING)

/mob/living/proc/update_pull_movespeed()
	if(pulling)
		if(pulling != src)
			if(isliving(pulling))
				var/mob/living/L = pulling
				if(!slowed_by_drag || (L.mobility_flags & MOBILITY_STAND) || L.buckled || grab_state >= GRAB_AGGRESSIVE)
					remove_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING)
					return
				add_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING, multiplicative_slowdown = PULL_PRONE_SLOWDOWN)
				return
			if(isobj(pulling))
				var/obj/structure/S = pulling
				if(!slowed_by_drag || !S.drag_slowdown)
					remove_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING)
					return
				add_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING, multiplicative_slowdown = S.drag_slowdown)
				return

	remove_movespeed_modifier(MOVESPEED_ID_BULKY_DRAGGING)

/mob/living/can_zFall(turf/T, levels)
	if(HAS_TRAIT(src, TRAIT_WOODWALKER))
		for(var/leaf in T.contents)
			if(istype(leaf, /obj/structure/flora/newleaf))
				return FALSE
	return ..()

/mob/living/canZMove(dir, turf/target)
	return can_zTravel(target, dir) && (movement_type & FLYING)
