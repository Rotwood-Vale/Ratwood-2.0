
/// Returns a list of turfs in a circle of given radius around center turf. i need this bruh.
/proc/circle(radius, turf/center)
	var/list/turfs = list()
	for(var/x = -radius to radius)
		for(var/y = -radius to radius)
			if(x*x + y*y <= radius*radius)
				var/turf/T = locate(center.x + x, center.y + y, center.z)
				if(isturf(T))
					turfs += T
	return turfs

/obj/effect/proc_holder/spell/invoked/motivated_slash
	name = "Motivated Slash"
	desc = "A powerful line slash. Is three tiles long and is unblockable."
	warnie = "spellwarning"
	cost = 1
	range = 1
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Hmph!")
	invocation_type = "shout"
	gesture_required = FALSE
	sound = 'sound/motivation/hm1.ogg'
	var/delay = 2
	var/damage = 150 
	var/area_of_effect = 3 


/obj/effect/temp_visual/trap
	icon = 'icons/effects/effects.dmi'
	icon_state = "trap"
	light_outer_range = 2
	duration = 8
	layer = MASSIVE_OBJ_LAYER

/obj/effect/temp_visual/motivated_slash
	icon = 'icons/effects/effects.dmi'
	icon_state = "cut"
	dir = EAST
	name = "a motivated slash"
	desc = "A powerful slash of energy."
	randomdir = FALSE
	duration = 1 SECONDS
	layer = MASSIVE_OBJ_LAYER


/obj/effect/proc_holder/spell/invoked/motivated_slash/cast(list/targets, mob/user)
	var/turf/source_turf = get_turf(user)
	var/turf/T = get_turf(targets[1])
	var/dir = get_dir(source_turf, T)
	var/turf/current_turf = source_turf
	var/list/slash_turfs = list()
	for(var/i = 0; i < area_of_effect; i++)
		current_turf = get_step(current_turf, dir)
		if(!current_turf)
			break
		if(current_turf.density)
			break
		new /obj/effect/temp_visual/trap(current_turf)
		slash_turfs += current_turf
	playsound(T, 'sound/motivation/swordswing.ogg', 75, TRUE, soundping = TRUE)

	// i love callbacks they're so nice
	for(var/i = 1, i <= slash_turfs.len; i++)
		var/turf/target_turf = slash_turfs[i]
		addtimer(CALLBACK(src, PROC_REF(do_motivated_slash_effect), target_turf, damage), 0)
		addtimer(CALLBACK(src, PROC_REF(play_swordswing), target_turf), 0)
/obj/effect/proc_holder/spell/invoked/motivated_slash/proc/play_swordswing(turf/affected_turf)
	playsound(affected_turf, 'sound/motivation/swordswing.ogg', 80, TRUE)

// ok so i think this works
/obj/effect/proc_holder/spell/invoked/motivated_slash/proc/do_motivated_slash_effect(turf/target_turf, damage)
	if(!target_turf || target_turf.density)
		return
	new /obj/effect/temp_visual/motivated_slash(target_turf)
	for(var/mob/living/L in target_turf.contents)
		L.adjustBruteLoss(damage)
		playsound(target_turf, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword!</span>")

/obj/effect/proc_holder/spell/invoked/motivated_omnislash
	name = "Motivated Omni Slash"
	desc = "A powerful omni slash, swings three times, once one tile around you, then two tiles around you, then three tiles around you. Is unblockable."
	warnie = "spellwarning"
	cost = 2
	range = 1
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Pathetic.")
	invocation_type = "shout"
	sound = 'sound/motivation/pathetic.ogg'
	var/delay = 2
	var/slashing = FALSE
	var/damage = 100
	var/area_of_effect = 1

/obj/effect/proc_holder/spell/invoked/motivated_omnislash/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])
	var/turf/source_turf = get_turf(user)
	if(T.z > user.z)
		source_turf = get_step_multiz(source_turf, UP)
	if(T.z < user.z)
		source_turf = get_step_multiz(source_turf, DOWN)


	src.slashing = TRUE
	var/list/all_turfs = list()
	for(var/radius = 1; radius <= 3; radius++)
		var/grunt_sound
		if(radius == 1 || radius == 2)
			grunt_sound = pick('sound/motivation/grunt1.ogg', 'sound/motivation/grunt2.ogg')
		else if(radius == 3)
			grunt_sound = pick('sound/motivation/gruntbig1.ogg', 'sound/motivation/gruntbig2.ogg', 'sound/motivation/gruntbig3.ogg')
		playsound(user, grunt_sound, 75, TRUE)

		for(var/turf/affected_turf in circle(radius, source_turf))
			if(!affected_turf)
				continue
			if(affected_turf.density)
				continue
			new /obj/effect/temp_visual/trap(affected_turf)
			all_turfs += affected_turf
		playsound(T, 'sound/motivation/swordswing.ogg', 55, TRUE, soundping = TRUE)

	var/total_delay = delay * all_turfs.len
	// user.do_after(total_delay, CALLBACK(src, PROC_REF(end_omnislash), user)) // Commented out for movement blocking logic

	for(var/i = 1, i <= all_turfs.len, i++)
		var/turf/current_turf = all_turfs[i]
		var/swing_delay = delay * (i - 1)
		addtimer(CALLBACK(src, PROC_REF(do_omnislash_effect), current_turf, user, damage), swing_delay)
		playsound(current_turf, 'sound/motivation/swordswing.ogg', 80, TRUE)
/obj/effect/proc_holder/spell/invoked/motivated_omnislash/proc/play_swordswing(turf/affected_turf)
	playsound(affected_turf, 'sound/motivation/swordswing.ogg', 80, TRUE)

/obj/effect/proc_holder/spell/invoked/motivated_omnislash/proc/do_omnislash_effect(turf/affected_turf, mob/user, damage, initial_loc)
	if(!src.slashing)
		return
	if(!affected_turf || affected_turf.density)
		return
	new /obj/effect/temp_visual/blade_burst(affected_turf)
	for(var/mob/living/L in affected_turf.contents)
		L.adjustBruteLoss(damage)
		playsound(affected_turf, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword!</span>")
		var/knock_dir = get_dir(user, L)
		if(knock_dir)
			step(L, knock_dir)
			to_chat(L, "<span class='userdanger'>You're knocked back by the force of the slash!</span>")

/obj/effect/proc_holder/spell/invoked/motivated_omnislash/proc/end_omnislash(mob/user)
	src.slashing = FALSE
	if(!isnull(user.do_after))
		user.do_after = FALSE


/obj/effect/proc_holder/spell/invoked/motivated_xslash
	name = "Motivated X Slash"
	desc = "A powerful X slash, slashes in an X shape at the target location. Is unblockable."
	warnie = "spellwarning"
	cost = 2
	range = 3
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("Cut off!")
	invocation_type = "shout"
	sound = 'sound/motivation/cutoff.ogg'
	var/delay = 2
	var/slashing = FALSE
	var/damage = 120
	var/area_of_effect = 1 

/obj/effect/proc_holder/spell/invoked/motivated_xslash/cast(list/targets, mob/user)
	var/turf/T = get_turf(targets[1])
	src.slashing = TRUE
	var/list/x_turfs = list()
	var/dirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
	for(var/dir in dirs)
		var/turf/current_turf = T
		for(var/i = 1; i <= area_of_effect; i++)
			current_turf = get_step(current_turf, dir)
			if(!current_turf)
				break
			if(current_turf.density)
				break
			new /obj/effect/temp_visual/trap(current_turf)
			x_turfs += current_turf
	playsound(T, 'sound/motivation/swordswing.ogg', 75, TRUE, soundping = TRUE)

	// no walkies.
	var/total_delay = delay * x_turfs.len
	// user.do_after(total_delay, CALLBACK(src, PROC_REF(end_xslash), user)) // Commented out for movement blocking logic

	// i fucking hate this shit bruh.
	for(var/i = 1, i <= x_turfs.len, i++)
		var/turf/current_turf = x_turfs[i]
		var/swing_delay = delay * (i - 1)
		addtimer(CALLBACK(src, PROC_REF(do_xslash_effect), current_turf, user, damage), swing_delay)
		playsound(current_turf, 'sound/motivation/swordswing.ogg', 80, TRUE)
/obj/effect/proc_holder/spell/invoked/motivated_xslash/proc/play_swordswing(turf/affected_turf)
	playsound(affected_turf, 'sound/motivation/swordswing.ogg', 80, TRUE)

/obj/effect/proc_holder/spell/invoked/motivated_xslash/proc/do_xslash_effect(turf/affected_turf, mob/user, damage)
	if(!src.slashing)
		return
	if(!affected_turf || affected_turf.density)
		return
	new /obj/effect/temp_visual/blade_burst(affected_turf)
	for(var/mob/living/L in affected_turf.contents)
		L.adjustBruteLoss(damage)
		playsound(affected_turf, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword!")
		var/knock_dir = get_dir(user, L)
		if(knock_dir)
			step(L, knock_dir)
			to_chat(L, "<span class='userdanger'>You're knocked back by the force of the slash!")

/obj/effect/proc_holder/spell/invoked/motivated_xslash/proc/end_xslash(mob/user)
	src.slashing = FALSE

/obj/effect/proc_holder/spell/invoked/motivated_finale
	name = "Motivated Final Slash"
	desc = "A devastating finale slash that hits around you in a very large radius."
	cost = 3
	range = 1
	chargetime = 0
	no_early_release = FALSE
	movement_interrupt = FALSE
	charging_slowdown = 1
	chargedloop = /datum/looping_sound/invokegen
	invocations = list("You shall die.") // https://youtu.be/GEZON93hV-s?si=KkcoxDQxGcyd0kfY&t=25
	invocation_type = "shout"
	gesture_required = FALSE
	ignore_los = FALSE
	sound = 'sound/motivation/youshalldie.ogg'
	var/delay = 2
	var/slashing = FALSE
	var/damage = 200 
	var/area_of_effect = 9 

/obj/effect/proc_holder/spell/invoked/motivated_finale/cast(list/targets, mob/user)
	var/turf/source_turf = get_turf(user)
	src.slashing = TRUE
	var/list/finale_turfs = list()
	for(var/turf/affected_turf in circle(area_of_effect, source_turf))
		if(!affected_turf)
			continue
		if(affected_turf == source_turf)
			continue // Exclude the center tile
		if(affected_turf.density)
			continue
		new /obj/effect/temp_visual/trap(affected_turf)
		finale_turfs += affected_turf
	playsound(source_turf, 'sound/motivation/swordswing.ogg', 80, TRUE, soundping = TRUE)

	// Block movement for the total duration
	var/total_delay = delay * finale_turfs.len
	user.do_after(total_delay, CALLBACK(src, PROC_REF(end_finale), user))


	// Schedule each slash effect
	for(var/i = 1; i <= finale_turfs.len; i++)
		var/turf/current_turf = finale_turfs[i]
		var/swing_delay = delay * (i - 1)
		addtimer(CALLBACK(src, PROC_REF(do_finale_effect), current_turf, user, damage), swing_delay)
		addtimer(CALLBACK(src, PROC_REF(play_swordswing), current_turf), swing_delay)

	// Play swordswing sound for each swing
	// After all circle slashes, cast four X slashes around the user, two tiles away
	var/xslash_start_delay = delay * finale_turfs.len
	var/list/xslash_centers = list()
	var/dirs = list(NORTH, SOUTH, EAST, WEST)
	for(var/dir in dirs)
		var/turf/xcenter = get_step(get_step(get_turf(user), dir), dir) // two tiles away
		if(xcenter && !xcenter.density)
			xslash_centers += xcenter
	for(var/turf/xcenter in xslash_centers)
		// X pattern: NE, NW, SE, SW from center
		var/xslash_area = 1 // one tile out from center
		var/xslash_damage = damage // use same damage as finale
		var/xslash_delay = 0 // instant
		var/xslash_dirs = list(NORTHEAST, NORTHWEST, SOUTHEAST, SOUTHWEST)
		for(var/xdir in xslash_dirs)
			var/turf/current_turf = xcenter
			for(var/j = 1; j <= xslash_area; j++)
				current_turf = get_step(current_turf, xdir)
				if(!current_turf || current_turf.density)
					break
				new /obj/effect/temp_visual/trap(current_turf)
				addtimer(CALLBACK(src, PROC_REF(do_finale_effect), current_turf, user, xslash_damage), xslash_start_delay)

/obj/effect/proc_holder/spell/invoked/motivated_finale/proc/do_finale_effect(turf/affected_turf, mob/user, damage)
	if(!src.slashing)
		return
	if(!affected_turf || affected_turf.density)
		return
	new /obj/effect/temp_visual/motivated_slash(affected_turf)
	for(var/mob/living/L in affected_turf.contents)
		L.adjustBruteLoss(damage)
		playsound(affected_turf, "genslash", 80, TRUE)
		to_chat(L, "<span class='userdanger'>You're cut by the sword! (Finale)")
		var/knock_dir = get_dir(user, L)
		if(knock_dir)
			step(L, knock_dir)
			to_chat(L, "<span class='userdanger'>You're knocked back by the force of the finale!")

/obj/effect/proc_holder/spell/invoked/motivated_finale/proc/end_finale(mob/user)
	src.slashing = FALSE






