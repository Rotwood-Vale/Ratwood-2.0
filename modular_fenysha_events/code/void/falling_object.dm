/proc/xy2dir(x, y)
	if(x)
		x = x / abs(x)
	if(y)
		y = y / abs(y)

	switch(x)
		if(1)
			switch(y)
				if(1)
					return NORTHEAST
				if(-1)
					return SOUTHEAST
				else
					return EAST
		if(-1)
			switch(y)
				if(1)
					return NORTHWEST
				if(-1)
					return SOUTHWEST
				else
					return WEST
		else
			switch(y)
				if(1)
					return NORTH
				if(-1)
					return SOUTH

	return 0

/obj/effect/falling_object
	name = "Falling Object"
	desc = ""
	icon_state = "mist"
	alpha = 200

	var/fall_time = 10 SECONDS
	var/atom/movable/fallen_type = null
	var/fractal = FALSE

	var/start_x = 1200
	var/start_y = 1200
	var/scale_factor = 3

	var/fall_timer = null

/obj/effect/falling_object/Initialize(mapload, ...)
	. = ..()
	fall_effect()
	fall_timer = addtimer(CALLBACK(src, PROC_REF(hit)), fall_time + 0.5 SECONDS, TIMER_STOPPABLE | TIMER_UNIQUE)

/obj/effect/falling_object/Destroy()
	if(fall_timer)
		deltimer(fall_timer)
		fall_timer = null
	return ..()

/obj/effect/falling_object/proc/fall_effect()
	var/matrix/initial_matrix = matrix()
	initial_matrix.Scale(0.1, 0.1)

	var/matrix/final_matrix = matrix()
	final_matrix.Scale(scale_factor, scale_factor)

	transform = initial_matrix
	pixel_y = start_y
	pixel_x = start_x
	alpha = 20

	animate(src, pixel_y = 0, pixel_x = 0, time = fall_time, flags = ANIMATION_PARALLEL)
	animate(src, transform = final_matrix, time = fall_time, flags = ANIMATION_PARALLEL)
	animate(src, alpha = 255, time = fall_time, flags = ANIMATION_PARALLEL)

	if(fractal)
		add_filter("fractal_wave", 1, list("type" = "wave", "size" = 2, "x" = 10, "y" = 10, "offset" = 0))

		var/filter = get_filter("fractal_wave")
		animate(filter, offset = 100, time = 30, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = 15, time = 30)

/obj/effect/falling_object/proc/hit()
	var/turf/hit_turf = get_turf(src)
	if(hit_turf)
		explosion(hit_turf, 0, 3, 4, 7, FALSE, FALSE, 3, smoke = TRUE)
		visible_message(span_userdanger("Ball of fire hits [hit_turf]!"))
		shockwave(hit_turf, 9, 1, 1, FALSE, null, TRUE, list(
			"amplitude base" = 80,
			"amplitude gain" = 80,
		))
		if(fallen_type)
			new fallen_type(hit_turf)

	qdel(src)


/obj/effect/falling_object/capsule
	icon = 'modular_fenysha_events/icons/obj/falling_capsule.dmi'
	icon_state = "base"
	fallen_type = /obj/structure/void_capsule
	scale_factor = 0.7
	fall_time = 4 SECONDS

/obj/effect/falling_object/capsule/hit()
	var/turf/epicenter = get_turf(src)

	if(epicenter)
		INVOKE_ASYNC(src, PROC_REF(create_impact_wave), epicenter)

	return ..()

/obj/effect/falling_object/capsule/proc/create_impact_wave(turf/epicenter)
	if(!epicenter)
		return
	outdoor_light_strobe(3, 10, 4, COLOR_ASSEMBLY_BEIGE)
	var/impact_radius = 4
	for(var/r = 1 to impact_radius)
		for(var/turf/T in circle_range(epicenter, r))
			if(get_dist(epicenter, T) != r)
				continue

			destroy_and_change_turf(T)

		sleep(1)


	var/dir_x = (start_x > 0) ? 1 : ((start_x < 0) ? -1 : 0)
	var/dir_y = (start_y > 0) ? 1 : ((start_y < 0) ? -1 : 0)

	var/trail_length = 6
	var/trail_width = 3

	var/turf/current_trail_center = epicenter

	for(var/i = 1 to trail_length)
		current_trail_center = get_step(current_trail_center, xy2dir(dir_x, dir_y))
		if(!current_trail_center)
			break

		for(var/turf/T in circle_range(current_trail_center, trail_width))
			destroy_and_change_turf(T)

		sleep(1)
/obj/effect/falling_object/capsule/proc/destroy_and_change_turf(turf/T)
	if(!T)
		return

	for(var/atom/movable/AM in T)
		if(AM == src || istype(AM, fallen_type))
			continue
		if(isstructure(AM) || ismachinery(AM))
			qdel(AM)
		else if(ismob(AM))
			var/mob/living/L = AM
			L.take_overall_damage(15, 15)
			L.Paralyze(10)

	if(T.density)
		T.ScrapeAway()

	T.ChangeTurf(/turf/open/floor/rogue/grassgrey)

	if(prob(30))
		new /obj/effect/particle_effect/smoke(T)

/obj/effect/falling_object/capsule/gas 
	fallen_type = /obj/structure/void_capsule/gas

/obj/effect/falling_object/capsule/fractal
	fallen_type = /obj/structure/void_capsule/fractal_mutants/generic

/obj/effect/falling_object/capsule/fractal_forcer
	fallen_type = /obj/structure/void_capsule/fractal_mutants/forcer
