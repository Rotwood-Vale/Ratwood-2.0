// Sandstorm particles - fast, horizontal, abrasive
/particles/weather/sand
	icon_state = "dot"
	color      = "#c2b280" // sandy tan
	position   = generator("box", list(-600,-256,5), list(600,500,0))
	spin       = null

	// Mostly horizontal movement
	gravity = list(0.3, 0, 0)
	drift = list( generator("num", 2, 4), generator("num", -0.5, 0.5), 0)
	fade = 0.5
	fadein = 1
	friction   = 0.05 //
	transform = null
	// Weather tuning
	maxSpawning = 80
	minSpawning = 20
	wind        = 20

/particles/weather/sand/gentle
	wind        = 5
	count                  = 150 // 15 particles
/datum/particle_weather/sand_gentle
	name = "Dry gusts"
	desc = "A dry wind kicks sand through the air."
	particleEffectType = /particles/weather/sand/gentle
	warning_message = span_greenannounce("Dry gusts winds their way across the realm, pulling at loose ground.")
	late_warning_message = span_greenannounce("The wind groans lowly, carrying specs of sand and dust.")
	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/sandstorm)
	indoor_weather_sounds = list(/datum/looping_sound/wind)
	minSeverity = 5
	maxSeverity = 25
	maxSeverityChange = 10
	severitySteps = 5
	immunity_type = TRAIT_SANDSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_SAND
	COOLDOWN_DECLARE(dustdevil)

/datum/particle_weather/sand_gentle/weather_act(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_SANDSTORM_IMMUNE))
		return

	if(!HAS_TRAIT(L, TRAIT_SANDSTORM_GOGGLES) && prob(5))
		L.adjust_blurriness(rand(1,3))
	if(L.bodytemperature < BODYTEMP_HEAT_LEVEL_ONE_MAX - 3)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_weather_temperature(rand(1,3))
		else
			L.adjust_bodytemperature(rand(1,3))

/datum/particle_weather/sand_gentle/tick()
	if(!COOLDOWN_FINISHED(src, dustdevil))
		return

	var/max_devils = 5

	// Count active dust devils
	var/current_devils = GLOB.active_dust_devils.len

	if(current_devils >= max_devils)
		return

	if(!prob(30))	// average chance for dust devils
		return
	// Build viable player list
	var/list/viable_players = list()
	for(var/client/C in GLOB.clients)
		if(!isliving(C.mob))
			continue
		var/mob/living/L = C.mob
		var/turf/T = get_turf(L)
		if(!T)
			continue
		if(!T.outdoor_effect)
			continue
		viable_players += L

	if(!viable_players.len)
		return

	var/spawn_attempts = 2

	for(var/i = 1 to spawn_attempts)
		if(current_devils >= max_devils)
			break

		var/mob/living/target = pick(viable_players)
		if(!target)
			continue

		var/turf/center = get_turf(target)
		if(!center)
			continue

		// Count devils near this player
		var/nearby = 0
		for(var/obj/effect/weather/tornado/dust_devil/D in range(center, 7))
			nearby++

		if(nearby >= 2)
			continue

		// Pick a valid outdoor turf near them
		var/list/turfs = list()
		for(var/turf/open/T in range(center, 7))
			if(!T.outdoor_effect || T.outdoor_effect.weatherproof)
				continue
			if(T.density)
				continue
			turfs += T

		if(!turfs.len)
			continue

		var/turf/spawn_turf = pick(turfs)

		new /obj/effect/weather/tornado/dust_devil(spawn_turf)

		current_devils++

	COOLDOWN_START(src, dustdevil, rand(15, 40) * 1 SECONDS)


/datum/particle_weather/sand_gentle/stop_weather_sound_effect(mob/living/L)
	..() // stop sounds normally

/datum/particle_weather/sand_gentle/end()
	running = FALSE
	for(var/mob/living/M in currentSounds)
		if(M.client)
			stop_weather_sound_effect(M)
		if(HAS_TRAIT(M, TRAIT_SANDSTORMED))
			REMOVE_TRAIT(M, TRAIT_SANDSTORMED, TRAIT_GENERIC)
	SSParticleWeather.stopWeather()

/datum/particle_weather/sand_storm
	name = "Sandstorm"
	desc = "A howling wall of sand scours the land."
	particleEffectType = /particles/weather/sand
	warning_message = span_greenannounce("Ferocious winds howl their way across the realm, building thick clouds close to the earth.")
	late_warning_message = span_greenannounce("The wind screams, carrying blinding dust.")
	scale_vol_with_severity = TRUE
	weather_sounds = list(/datum/looping_sound/sandstorm)
	indoor_weather_sounds = list(/datum/looping_sound/wind)
	minSeverity = 40
	maxSeverity = 100
	maxSeverityChange = 50
	severitySteps = 50

	immunity_type = TRAIT_SANDSTORM_IMMUNE
	probability = 1
	target_trait = PARTICLEWEATHER_SAND
	COOLDOWN_DECLARE(dustdevil)

/datum/particle_weather/sand_storm/weather_act(mob/living/L)
	if(HAS_TRAIT(L, TRAIT_SANDSTORM_IMMUNE))
		return
	if(!HAS_TRAIT(L, TRAIT_SANDSTORMED))
		ADD_TRAIT(L, TRAIT_SANDSTORMED, TRAIT_GENERIC)
	// Heat + abrasion
	if(!HAS_TRAIT(L, TRAIT_SANDSTORM_GOGGLES) && prob(25))
		L.adjust_blurriness(rand(1,3))
	if(L.bodytemperature < BODYTEMP_HEAT_LEVEL_ONE_MAX - 3)
		if(ishuman(L))
			var/mob/living/carbon/human/H = L
			H.apply_weather_temperature(rand(3,5))
		else
			L.adjust_bodytemperature(rand(3,5))
	if(!L.has_sandstorm_hood())
		if(prob(33))
			L.energy_add(-10)

/datum/particle_weather/sand_storm/tick()
	if(!COOLDOWN_FINISHED(src, dustdevil))
		return

	var/max_devils = 10

	// Count active dust devils
	var/current_devils = GLOB.active_dust_devils.len

	if(current_devils >= max_devils)
		return

	if(!prob(50))	// high chance for dust devils
		return
	// Build viable player list
	var/list/viable_players = list()
	for(var/client/C in GLOB.clients)
		if(!isliving(C.mob))
			continue
		var/mob/living/L = C.mob
		var/turf/T = get_turf(L)
		if(!T)
			continue
		if(!T.outdoor_effect)
			continue
		viable_players += L

	if(!viable_players.len)
		return

	var/spawn_attempts = 2

	for(var/i = 1 to spawn_attempts)
		if(current_devils >= max_devils)
			break

		var/mob/living/target = pick(viable_players)
		if(!target)
			continue

		var/turf/center = get_turf(target)
		if(!center)
			continue

		// Count devils near this player
		var/nearby = 0
		for(var/obj/effect/weather/tornado/dust_devil/D in range(center, 7))
			nearby++

		if(nearby >= 2)
			continue

		// Pick a valid outdoor turf near them
		var/list/turfs = list()
		for(var/turf/open/T in range(center, 7))
			if(!T.outdoor_effect || T.outdoor_effect.weatherproof)
				continue
			if(T.density)
				continue
			turfs += T

		if(!turfs.len)
			continue

		var/turf/spawn_turf = pick(turfs)

		new /obj/effect/weather/tornado/dust_devil(spawn_turf)

		current_devils++

	COOLDOWN_START(src, dustdevil, rand(15, 40) * 1 SECONDS)

/datum/particle_weather/sand_storm/stop_weather_sound_effect(mob/living/L)
	..() // stop sounds normally

	if(HAS_TRAIT(L, TRAIT_SANDSTORMED))
		REMOVE_TRAIT(L, TRAIT_SANDSTORMED, TRAIT_GENERIC)

/datum/particle_weather/sand_storm/end()
	running = FALSE
	for(var/mob/living/M in currentSounds)
		if(M.client)
			stop_weather_sound_effect(M)
		if(HAS_TRAIT(M, TRAIT_SANDSTORMED))
			REMOVE_TRAIT(M, TRAIT_SANDSTORMED, TRAIT_GENERIC)
	SSParticleWeather.stopWeather()


/mob/living/proc/has_sandstorm_hood()
	var/obj/item/clothing/head/H = get_item_by_slot(ITEM_SLOT_HEAD)
	if(!H)
		return FALSE

	// Generic hood subtype
	if(istype(H, /obj/item/clothing/head/roguetown/roguehood))
		return TRUE

	// Specific exceptions
	switch(H.type)
		if(
			/obj/item/clothing/head/roguetown/menacing,
			/obj/item/clothing/head/roguetown/necromhood,
			/obj/item/clothing/head/roguetown/nochood,
			/obj/item/clothing/head/roguetown/necrahood,

		)
			return TRUE

	return FALSE
