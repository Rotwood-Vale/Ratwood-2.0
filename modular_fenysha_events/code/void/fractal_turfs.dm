/turf/open/floor/rogue/void_floor
	name = "strange floor"
	desc = "The ground does not feel entirely present."
	// optional light — turn off if the area is already lit
	// light_range = 1
	// light_power = 0.3
	// light_color = "#6b3fa0"

/turf/open/floor/rogue/void_floor/Initialize(mapload)
	. = ..()
	color = pick("#1a1a2e", "#0d0d1a", "#1f0f2f", "#2e1a3a")
	// Floor can host a light FX obj if you want wave on the ground too:
	// new /obj/effect/abstract/void_turf_fx/floor(src)

/turf/closed/wall/mineral/rogue/void_wall
	name = "Strange wall"
	desc = "The surface refuses a single colour. Looking at it too long makes the edges of the room disagree with each other."
	icon = 'modular_fenysha_events/icons/turf/voidwall_grayscale.dmi'
	icon_state = "stone"
	smooth = SMOOTH_MORE
	blade_dulling = DULLING_BASH
	max_integrity = 9999
	sheet_type = /obj/item/natural/stone
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list(
		'sound/combat/hits/onstone/wallhit.ogg',
		'sound/combat/hits/onstone/wallhit2.ogg',
		'sound/combat/hits/onstone/wallhit3.ogg'
	)
	canSmoothWith = list(/turf/closed/wall/mineral/rogue/void_wall)
	above_floor = /turf/open/floor/rogue/void_floor
	baseturfs = /turf/open/floor/rogue/void_floor
	neighborlay = "dirtedge"
	climbdiff = 3
	damage_deflection = 300

	light_power = 0.45
	light_color = "#6b3fa0"

	/// Movable FX holder (filters live here — turfs cannot use add_filter).
	var/obj/effect/abstract/void_turf_fx/wall/void_fx

/turf/closed/wall/mineral/rogue/void_wall/Initialize(mapload)
	. = ..()
	// Colour is an /atom var — safe on turfs.
	color = pick("#3a1a4a", "#1a1a2e", "#2e1a3a", "#1f0f2f", "#0d0d1a")

	void_fx = new /obj/effect/abstract/void_turf_fx/wall(src)
	// vis_contents keeps FX glued to the turf visually without blocking clicks on the wall.
	vis_contents += void_fx

	// Stagger colour breathing so a hallway is not in lockstep.
	addtimer(CALLBACK(src, PROC_REF(void_wall_color_cycle)), rand(0, 40))

/turf/closed/wall/mineral/rogue/void_wall/Destroy()
	if(void_fx)
		vis_contents -= void_fx
		QDEL_NULL(void_fx)
	return ..()

/turf/closed/wall/mineral/rogue/void_wall/proc/void_wall_color_cycle()
	if(QDELETED(src))
		return

	var/list/palette = list(
		"#3a1a4a",
		"#1a1a2e",
		"#2e1a3a",
		"#4a2060",
		"#1f0f2f",
		"#0d1528",
		"#2a1040"
	)
	animate(src, color = pick(palette), time = rand(40, 70), easing = SINE_EASING)
	addtimer(CALLBACK(src, PROC_REF(void_wall_color_cycle)), rand(40, 70))

/turf/closed/wall/mineral/rogue/void_wall/attackby(obj/item/I, mob/user, params)
	. = ..()
	if(void_fx)
		void_fx.glitch_pulse(short = TRUE)

// =============================================================================
// FX atom — ONLY place filters are applied (atom/movable API from your ref)
// =============================================================================

/obj/effect/abstract/void_turf_fx
	name = null
	desc = null
	icon = 'modular_fenysha_events/icons/turf/voidwall_grayscale.dmi'
	icon_state = "stone"
	anchored = TRUE
	density = FALSE
	opacity = FALSE
	mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	layer = ABOVE_NORMAL_TURF_LAYER
	plane = GAME_PLANE
	// Do not show in examine / not a real object
	invisibility = 0

/obj/effect/abstract/void_turf_fx/Initialize(mapload)
	. = ..()
	setup_filters()
	addtimer(CALLBACK(src, PROC_REF(start_pulse)), rand(0, 30))

/obj/effect/abstract/void_turf_fx/Destroy()
	clear_filters()
	return ..()

/obj/effect/abstract/void_turf_fx/proc/setup_filters()
	return

/obj/effect/abstract/void_turf_fx/proc/start_pulse()
	return

/obj/effect/abstract/void_turf_fx/proc/glitch_pulse(short = FALSE)
	return

// ----- Wall FX -----

/obj/effect/abstract/void_turf_fx/wall
	alpha = 180

/obj/effect/abstract/void_turf_fx/wall/setup_filters()
	// Matches your API: add_filter(name, priority, list/params)
	add_filter("void_wall_wave", 1, list(
		"type" = "wave",
		"size" = 1.4,
		"x" = 7,
		"y" = 2,
		"offset" = rand(0, 20)
	))
	add_filter("void_wall_ripple", 2, list(
		"type" = "wave",
		"size" = 0.8,
		"x" = 2,
		"y" = 9,
		"offset" = rand(0, 30)
	))
	add_filter("void_wall_rays", 3, list(
		"type" = "rays",
		"color" = "#9b59b655",
		"size" = 14,
		"density" = 8,
		"factor" = 0.4,
		"offset" = rand(0, 100)
	))
	add_filter("void_wall_outline", 4, list(
		"type" = "outline",
		"color" = "#6b3fa088",
		"size" = 1
	))
	if(prob(30))
		add_filter("void_wall_bloom", 5, list(
			"type" = "bloom",
			"color" = "#c39bd335",
			"size" = 2,
			"offset" = 0.15
		))

/obj/effect/abstract/void_turf_fx/wall/start_pulse()
	if(QDELETED(src))
		return

	var/wave = get_filter("void_wall_wave")
	if(wave)
		animate(wave, offset = 70, time = 90, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = 0, time = 90)

	var/ripple = get_filter("void_wall_ripple")
	if(ripple)
		animate(ripple, offset = 50, time = 120, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = 5, time = 120)

	var/rays = get_filter("void_wall_rays")
	if(rays)
		animate(rays, offset = 360, time = 220, loop = -1, flags = ANIMATION_PARALLEL)

	addtimer(CALLBACK(src, PROC_REF(glitch_pulse)), rand(20 SECONDS, 50 SECONDS))

/obj/effect/abstract/void_turf_fx/wall/glitch_pulse(short = FALSE)
	if(QDELETED(src))
		return

	var/wave = get_filter("void_wall_wave")
	if(wave)
		// transition_filter exists on movable in your ref — use it when possible
		animate(wave, size = short ? 2.5 : 4.5, offset = 100, time = 3, flags = ANIMATION_PARALLEL)
		animate(size = 1.4, offset = 20, time = short ? 6 : 12)

	if(!short)
		animate(src, color = "#9b59b6", time = 3, flags = ANIMATION_PARALLEL)
		animate(color = null, time = 12)
		if(prob(35))
			new /obj/effect/temp_visual/void_spark(loc)
		if(prob(15))
			new /obj/effect/temp_visual/fractal_crack(loc)
		addtimer(CALLBACK(src, PROC_REF(glitch_pulse)), rand(25 SECONDS, 70 SECONDS))

// ----- Optional floor FX (lighter) -----

/obj/effect/abstract/void_turf_fx/floor
	alpha = 120
	layer = TURF_LAYER + 0.1

/obj/effect/abstract/void_turf_fx/floor/setup_filters()
	add_filter("void_floor_wave", 1, list(
		"type" = "wave",
		"size" = 0.5,
		"x" = 4,
		"y" = 4,
		"offset" = rand(0, 20)
	))

/obj/effect/abstract/void_turf_fx/floor/start_pulse()
	var/f = get_filter("void_floor_wave")
	if(f)
		animate(f, offset = 40, time = 100, loop = -1, flags = ANIMATION_PARALLEL)
		animate(offset = 0, time = 100)
