//Rain - goes down
/particles/weather/rain
	icon_state             = "drop"
	color                  = "#ccffff"
	position               = generator("box", list(-500,-256,0), list(400,500,0))
	grow			       = list(-0.01,-0.01)
	gravity                = list(0, -10, 0.5)
	drift                  = generator("circle", 0, 1) // Some random movement for variation
	friction               = 0.3  // shed 30% of velocity and drift every 0.1s
	transform 			   = null // Rain is directional - so don't make it "3D"
	//Weather effects, max values
	maxSpawning            = 250
	minSpawning            = 50
	wind                   = 2
	spin                   = 0 // explicitly set spin to 0 - there is a bug that seems to carry generators over from old particle effects

/datum/particle_weather/rain_gentle
	name = "Rain"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/rain
	warning_message = span_greenannounce("Grey clouds gather up above the realm, beholding the gift of life.")
	late_warning_message = span_greenannounce("Heavy drops begin to fall in rapid succession.")
	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/rain)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)

	minSeverity = 1
	maxSeverity = 15
	maxSeverityChange = 2
	severitySteps = 5
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 70
	target_trait = PARTICLEWEATHER_RAIN
	forecast_tag = "rain"

//Makes you a little chilly
/datum/particle_weather/rain_gentle/weather_act(mob/living/L)
	if(L.bodytemperature > BODYTEMP_COLD_LEVEL_ONE_MAX + 3)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_weather_temperature(-rand(1,3))
		else
			L.adjust_bodytemperature(-rand(1,3))
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)
	wash_atom(L,CLEAN_WEAK)

/datum/particle_weather/rain_storm
	name = "Rain Storm"
	desc = "Gentle Rain, la la description."
	particleEffectType = /particles/weather/rain
	warning_message = span_greenannounce("Dark clouds gather up above the realm, sparks arcing between heavenly reaches.")
	late_warning_message = span_greenannounce("The wind shifts and the storm breaks.")
	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/storm)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)

	minSeverity = 4
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 40
	target_trait = PARTICLEWEATHER_RAIN
	forecast_tag = "rain"

	COOLDOWN_DECLARE(thunder)

/datum/particle_weather/rain_storm/tick()
	if(!COOLDOWN_FINISHED(src, thunder))
		return


	var/lightning_strikes = 6
	for(var/i = 1 to lightning_strikes)
		var/atom/lightning_destination
		var/list/viable_players = list()
		for(var/client/client in GLOB.clients)
			if(!isliving(client.mob))
				continue
			var/mob/living/L = client.mob
			viable_players += L
		if(!viable_players.len)
			return

		lightning_destination = pick(viable_players)
		var/mob/living/humann= pick(viable_players)
		var/turf/humann_turf = get_turf(humann)
		var/area/A = get_area(humann)
		if(humann.badluck(4) && istype(A, /area/rogue/outdoors))
			humann.Immobilize(0.5 SECONDS)
			humann.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
			humann.electrocute_act(1, src, 1, SHOCK_NOSTUN)
			humann.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)
			new /obj/effect/temp_visual/lightning/storm(get_turf(humann_turf))
		if(lightning_destination)
			var/list/turfs = list()
			for(var/turf/open/turf in range(lightning_destination, 7))
				if(!turf.outdoor_effect || turf.outdoor_effect.weatherproof)
					continue
				turfs |= turf
			if(!length(turfs))
				return
			lightning_destination = pick(turfs)

		else
			lightning_destination = pick(SSParticleWeather.weathered_turfs)

		new /obj/effect/temp_visual/lightning/storm(get_turf(lightning_destination))
		COOLDOWN_START(src, thunder, rand(5, 40) * 1 SECONDS)


	var/max_tornadoes = 2
	var/min_distance_between = 30
	var/min_spawn_distance = 8
	var/max_spawn_distance = 20
	var/max_attempts = 3
	// Count active rain tornadoes
	var/list/active_tornadoes = GLOB.active_tornadoes.len

	if(active_tornadoes >= max_tornadoes)
		return

	if(!prob(5))	// Small spawn chance for tornadoes
		return

	// Build viable outdoor players
	var/list/viable_players = list()
	for(var/client/C in GLOB.clients)
		if(!isliving(C.mob))
			continue
		var/mob/living/L = C.mob
		var/turf/T = get_turf(L)
		if(!T || !T.outdoor_effect)
			continue
		viable_players += L

	if(!viable_players.len)
		return

	var/mob/living/anchor = pick(viable_players)
	var/turf/center = get_turf(anchor)
	if(!center)
		return

	var/turf/spawn_turf = null

	for(var/i = 1 to max_attempts)

		var/distance = rand(min_spawn_distance, max_spawn_distance)
		var/angle = rand(0, 359)

		var/x_offset = round(distance * cos(angle))
		var/y_offset = round(distance * sin(angle))

		var/turf/T = locate(center.x + x_offset, center.y + y_offset, center.z)
		if(!istype(T, /turf/open))
			continue
		if(!T.outdoor_effect || T.outdoor_effect.weatherproof)
			continue
		if(T.density)
			continue

		var/too_close = FALSE
		for(var/obj/effect/weather/tornado/Other in active_tornadoes)
			if(get_dist(T, Other) < min_distance_between)
				too_close = TRUE
				break

		if(too_close)
			continue

		spawn_turf = T
		break

	if(!spawn_turf)
		return

	new /obj/effect/weather/tornado(spawn_turf)

//Makes you a bit chilly
/datum/particle_weather/rain_storm/weather_act(mob/living/L)
	if(L.bodytemperature > BODYTEMP_COLD_LEVEL_ONE_MAX + 5)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_weather_temperature(-rand(3,5))
		else
			L.adjust_bodytemperature(-rand(3,5))
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)
	wash_atom(L,CLEAN_STRONG)

/obj/effect/temp_visual/lightning/storm
	icon = 'icons/effects/32x200.dmi'

	light_system = MOVABLE_LIGHT
	light_color = COLOR_PALE_BLUE_GRAY
	light_outer_range = 15
	light_power = 25
	duration = 12

/obj/effect/temp_visual/lightning/storm/Initialize(mapload, list/flame_hit)
	. = ..()
	playsound(get_turf(src),'sound/weather/rain/thunder_1.ogg', 80, TRUE)

/datum/particle_weather/hurricane
	name = "Hurricane"
	desc = "Abyssors wrath."
	particleEffectType = /particles/weather/rain
	warning_message = span_danger("The sky's clouds turn dark as night and form lengthy bands, a spinning wheel far to large for the eye to properly witness.")
	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/hurricane)
	indoor_weather_sounds = list(/datum/looping_sound/indoor_rain)
	weather_duration_lower = 5 MINUTES
	weather_duration_upper = 10 MINUTES
	minSeverity = 100
	maxSeverity = 150
	maxSeverityChange = 50
	severitySteps = 50
	immunity_type = TRAIT_RAINSTORM_IMMUNE
	probability = 40
	target_trait = PARTICLEWEATHER_RAIN
	forecast_tag = "rain"

	COOLDOWN_DECLARE(thunder)

/datum/particle_weather/hurricane/tick()
	if(!COOLDOWN_FINISHED(src, thunder))
		return


	var/lightning_strikes = 6
	for(var/i = 1 to lightning_strikes)
		var/atom/lightning_destination
		var/list/viable_players = list()
		for(var/client/client in GLOB.clients)
			if(!isliving(client.mob))
				continue
			var/mob/living/L = client.mob
			viable_players += L
		if(!viable_players.len)
			return

		lightning_destination = pick(viable_players)
		var/mob/living/humann= pick(viable_players)
		var/turf/humann_turf = get_turf(humann)
		var/area/A = get_area(humann)
		if(humann.badluck(4) && istype(A, /area/rogue/outdoors))
			humann.Immobilize(0.5 SECONDS)
			humann.apply_status_effect(/datum/status_effect/debuff/clickcd, 6 SECONDS)
			humann.electrocute_act(1, src, 1, SHOCK_NOSTUN)
			humann.apply_status_effect(/datum/status_effect/buff/lightningstruck, 6 SECONDS)
			new /obj/effect/temp_visual/lightning/storm(get_turf(humann_turf))
		if(lightning_destination)
			var/list/turfs = list()
			for(var/turf/open/turf in range(lightning_destination, 7))
				if(!turf.outdoor_effect || turf.outdoor_effect.weatherproof)
					continue
				turfs |= turf
			if(!length(turfs))
				return
			lightning_destination = pick(turfs)

		else
			lightning_destination = pick(SSParticleWeather.weathered_turfs)

		new /obj/effect/temp_visual/lightning/storm(get_turf(lightning_destination))
		COOLDOWN_START(src, thunder, rand(5, 40) * 1 SECONDS)

	var/max_tornadoes = 2
	var/min_distance_between = 30
	var/min_spawn_distance = 8
	var/max_spawn_distance = 20
	var/max_attempts = 5
	// Count active rain tornadoes
	var/list/active_tornadoes = GLOB.active_abyssors_rage.len

	if(active_tornadoes >= max_tornadoes)
		return

	// Small spawn chance each tick (prevents instant double spawn)
	if(!prob(40))
		return

	// Build viable outdoor players
	var/list/viable_players = list()
	for(var/client/C in GLOB.clients)
		if(!isliving(C.mob))
			continue
		var/mob/living/L = C.mob
		var/turf/T = get_turf(L)
		if(!T || !T.outdoor_effect)
			continue
		viable_players += L

	if(!viable_players.len)
		return

	var/mob/living/anchor = pick(viable_players)
	var/turf/center = get_turf(anchor)
	if(!center)
		return

	var/turf/spawn_turf = null

	for(var/i = 1 to max_attempts)

		var/distance = rand(min_spawn_distance, max_spawn_distance)
		var/angle = rand(0, 359)

		var/x_offset = round(distance * cos(angle))
		var/y_offset = round(distance * sin(angle))

		var/turf/T = locate(center.x + x_offset, center.y + y_offset, center.z)
		if(!istype(T, /turf/open))
			continue
		if(!T.outdoor_effect || T.outdoor_effect.weatherproof)
			continue
		if(T.density)
			continue

		var/too_close = FALSE
		for(var/obj/effect/weather/tornado/abyssors_rage/Other in active_tornadoes)
			if(get_dist(T, Other) < min_distance_between)
				too_close = TRUE
				break

		if(too_close)
			continue

		spawn_turf = T
		break

	if(!spawn_turf)
		return

	new /obj/effect/weather/tornado/abyssors_rage(spawn_turf)
//Makes you a bit chilly
/datum/particle_weather/rain_storm/weather_act(mob/living/L)
	if(L.bodytemperature > BODYTEMP_COLD_LEVEL_ONE_MAX + 5)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_weather_temperature(-rand(3,5))
		else
			L.adjust_bodytemperature(-rand(3,5))
	L.adjust_fire_stacks(-100)
	L.SoakMob(FULL_BODY)
	wash_atom(L,CLEAN_STRONG)
