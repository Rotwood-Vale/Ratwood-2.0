/particles/weather/heat
	icon_state = "heatwave"
	color      = "#453723" // VERY faint brown

	position   = generator("box", list(-600,-256,5), list(600,500,0))

	spin = null

	// Slow vertical lift
	gravity = list(0, 0.02, 0)

	// Gentle wobble drift
	drift = list(
		generator("num", -0.2, 0.2),
		generator("num", 0.2, 0.6),
		0
	)

	fade = 1.5
	fadein = 2

	friction = 0.02

	transform = null

	maxSpawning = 40
	minSpawning = 10
	wind = 2

/datum/particle_weather/heat_wave
	name = "Heatwave"
	desc = "The air ripples with brutal, suffocating heat."

	particleEffectType = /particles/weather/heat

	warning_message = span_greenannounce("A brutal heatwave rolls across the realm, warping the very air.")
	late_warning_message = span_greenannounce("The air becomes stifling and unbearably still.")
	scale_vol_with_severity = TRUE

	weather_sounds = list(/datum/looping_sound/sandstorm)
	indoor_weather_sounds = list(/datum/looping_sound/wind)

	minSeverity = 40
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50


	probability = 1
	COOLDOWN_DECLARE(heat_ripple_spawn)

/datum/particle_weather/heat_wave/weather_act(mob/living/L)
	if(ishuman(L))
		var/mob/living/carbon/human/H = L
		H.apply_weather_temperature(rand(1.5,5))
	else
		L.adjust_bodytemperature(rand(1.5,5))
/datum/particle_weather/heat_wave/tick()

	if(!COOLDOWN_FINISHED(src, heat_ripple_spawn))
		return

	var/ripple_count = clamp(round(severity / 40), 1, 3)

	var/list/viable_players = list()

	for(var/client/C in GLOB.clients)
		if(!C.mob)
			continue
		if(!isliving(C.mob))
			continue
		viable_players += C.mob

	if(!viable_players.len)
		return

	for(var/i = 1 to ripple_count)

		var/mob/M = pick(viable_players)
		if(!M)
			continue

		var/list/valid_turfs = list()

		for(var/turf/T in range(M, 6))
			if(!T)
				continue
			if(!(T in SSParticleWeather.weathered_turfs))
				continue
			if(T.outdoor_effect && T.outdoor_effect.weatherproof)
				continue
			valid_turfs += T

		if(!valid_turfs.len)
			continue

		var/turf/spawn_turf = pick(valid_turfs)
		new /obj/effect/temp_visual/heat_ripple(spawn_turf)

	COOLDOWN_START(src, heat_ripple_spawn, rand(2,6) SECONDS)
/obj/effect/temp_visual/heat_ripple
	name = "heat shimmer"
	icon = 'icons/effects/effects.dmi'
	icon_state = "heatwave"

	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE

	alpha = 0
	duration = 20

/obj/effect/temp_visual/heat_ripple/Initialize(mapload)

	. = ..()

	start_ripple()
	fade_in()

	QDEL_IN(src, duration)
/obj/effect/temp_visual/heat_ripple/proc/start_ripple()

	spawn(rand(0,5))
		while(src)

			var/matrix/M1 = matrix()
			var/matrix/M2 = matrix()

			M1.Scale(1.02, 0.98)
			M1.Translate(rand(-0.3,0.3), rand(0,0.6))

			M2.Scale(0.98, 1.02)
			M2.Translate(rand(-0.3,0.3), rand(0,0.6))

			animate(src,
				transform = M1,
				time = rand(6,10),
				easing = SINE_EASING)

			animate(src,
				transform = M2,
				time = rand(6,10),
				easing = SINE_EASING)

/obj/effect/temp_visual/heat_ripple/proc/fade_in()
	animate(src, alpha = rand(20,40), time = 5)

/obj/effect/temp_visual/heat_ripple/Destroy()
	animate(src, alpha = 0, time = 5)
	return ..()
