GLOBAL_LIST_EMPTY(active_dust_devils)
GLOBAL_LIST_EMPTY(active_tornadoes)
GLOBAL_LIST_EMPTY(active_abyssors_rage)

/obj/effect/weather/tornado	//standard tornado, throws people a distance
	name = "tornado"
	desc = "A violently spinning column of air."
	icon = 'icons/effects/224x224.dmi'
	icon_state = "Tornado"
	pixel_x = -100
	pixel_y = -32
	plane = -2
	alpha = 150
	anchored = FALSE
	density = FALSE
	movement_type = FLYING
	var/radius = 5
	var/spin_strength = 15
	var/z_throw_chance = 0	//Used for dustdevils
	var/drift_delay = 10
	var/next_drift_time
	var/current_drift_dir = SOUTH
	var/next_dir_change = 0
	var/sound/tornado_loop = 'sound/weather/tornado/tornado.ogg'
	var/sound_volume = 75
	var/sound_range = 20
	var/sound_loop_delay = 450   // ticks (5 seconds default)
	var/lifetime = 180 SECONDS

/obj/effect/weather/tornado/Initialize(mapload)
	. = ..()
	GLOB.active_tornadoes += src

	addtimer(CALLBACK(src, PROC_REF(expire)), lifetime)
	start_tornado_sound()
	visible_message(span_danger("[src] forms from violent winds!"))
	START_PROCESSING(SSobj, src)

/obj/effect/weather/tornado/Destroy()
	GLOB.active_tornadoes -= src
	return ..()

/obj/effect/weather/tornado/proc/expire()
	visible_message(span_danger("[src] runs out of steam!"))
	qdel(src)

/obj/effect/weather/tornado/proc/start_tornado_sound()
	loop_tornado_sound()

/obj/effect/weather/tornado/proc/loop_tornado_sound()
	if(QDELETED(src))
		return

	for(var/mob/M in hearers(sound_range, src))
		M.playsound_local(src, tornado_loop, sound_volume, FALSE)

	addtimer(CALLBACK(src, PROC_REF(loop_tornado_sound)), sound_loop_delay)

/obj/effect/weather/tornado/process()
	do_spin_pull()
	do_drift()


/obj/effect/weather/tornado/proc/do_spin_pull()
	for(var/atom/movable/A in view(radius, src))
		if(A.anchored)
			continue

		// Optional: Skip very heavy things
		if(A.move_resist > MOVE_FORCE_EXTREMELY_STRONG)
			continue

		apply_tornado_force(A)


/obj/effect/weather/tornado/proc/apply_tornado_force(atom/movable/A)
	var/dx = A.x - src.x
	var/dy = A.y - src.y

	if(!dx && !dy)
		return

	// Normalize to -1 / 0 / 1
	dx = SIGN(dx)
	dy = SIGN(dy)

	// Counter-clockwise rotation transform:
	// (x,y) -> (-y, x)
	var/spin_dx = -dy
	var/spin_dy = dx

	var/target_x = A.x + spin_dx * spin_strength
	var/target_y = A.y + spin_dy * spin_strength

	var/turf/T = locate(target_x, target_y, A.z)

	if(T)
		A.throw_at(T, spin_strength, 10)

	try_z_throw(A)
	if(ishuman(A))
		var/mob/living/carbon/human/H = A
		to_chat(H, span_extremelybig("You are thrown about by [src]!"))
		H.set_resting(TRUE, TRUE)
		H.Immobilize(2 SECONDS)

/obj/effect/weather/tornado/proc/try_z_throw(atom/movable/A)
	if(!prob(z_throw_chance))
		return

	var/turf/above = GET_TURF_ABOVE(get_turf(A))

	if(above && !above.density)
		A.forceMove(above)

/obj/effect/weather/tornado/proc/do_drift()
	if(world.time < next_drift_time)
		return

	next_drift_time = world.time + drift_delay


	if(world.time >= next_dir_change)
		current_drift_dir = pick(GLOB.alldirs)
		next_dir_change = world.time + rand(30, 80)

	step(src, current_drift_dir)

/obj/effect/weather/tornado/abyssors_rage	//Hurricane tornado, destroys turfs and structures
	name = "Abbyssor's wrath"
	desc = "Blessed be the sleeping one, for their wrath knows no bounds. A violently spinning column of water and air."
	color = "#00d8d8"
	var/destruction_radius = 4
	var/destruction_cooldown = 5
	var/next_destruction = 0
	lifetime = 240 SECONDS

/obj/effect/weather/tornado/abyssors_rage/Initialize(mapload)
	. = ..()
	GLOB.active_abyssors_rage += src
	transform = transform.Scale(1.2, 1.2)

/obj/effect/weather/tornado/abyssors_rage/Destroy()
	GLOB.active_abyssors_rage -= src
	return ..()

/obj/effect/weather/tornado/abyssors_rage/process()
	..()
	do_destruction()

/obj/effect/weather/tornado/abyssors_rage/proc/do_destruction()
	if(world.time < next_destruction)
		return

	next_destruction = world.time + destruction_cooldown

	for(var/turf/closed/wall/Wall in range(destruction_radius, src))
		if(Wall.sheet_type && Wall.sheet_amount)
			new Wall.sheet_type(get_step(src, turn(dir, 180)), Wall.sheet_amount)

		Wall.turf_destruction()
			// Fallback salvage

	for(var/obj/structure/Structure in range(destruction_radius, src))
		damage_structure(Structure)

/obj/effect/weather/tornado/abyssors_rage/proc/damage_structure(obj/structure/S)
	if(S.anchored && prob(40))
		return

	if(hascall(S, "deconstruct"))
		S.deconstruct(FALSE)
		return

	qdel(S)

/obj/effect/weather/tornado/dust_devil	//sand based dustdevils, smaller, shorter range, flings people z levels up
	name = "Dust Devil"
	desc = "A violently spinning column of dust and sand."
	color= "#5F4B37"
	radius = 2
	z_throw_chance = 60
	drift_delay = 3
	spin_strength = 3
	lifetime = 360 SECONDS
	sound_volume = 10

/obj/effect/weather/tornado/dust_devil/loop_tornado_sound()
	if(QDELETED(src))
		return

	for(var/mob/M in hearers(sound_range, src))
		M.playsound_local(src, tornado_loop, 10, FALSE)

	addtimer(CALLBACK(src, PROC_REF(loop_tornado_sound)), sound_loop_delay)

/obj/effect/weather/tornado/dust_devil/Initialize(mapload)
	. = ..()
	GLOB.active_dust_devils += src
	transform = transform.Scale(0.55, 0.55)

/obj/effect/weather/tornado/dust_devil/Destroy()
	GLOB.active_dust_devils -= src
	return ..()
