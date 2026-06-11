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
	name = "干燥阵风"
	desc = "干燥的风裹挟着沙尘穿空而过。"
	particleEffectType = /particles/weather/sand/gentle
	warning_message = span_greenannounce("干燥的阵风掠过大地，卷起地表松散的沙土。")
	late_warning_message = span_greenannounce("风声低沉呜咽，夹带着细碎的沙尘。")
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
	name = "沙暴"
	desc = "呼啸的沙墙横扫着整片大地。"
	particleEffectType = /particles/weather/sand
	warning_message = span_greenannounce("凶猛的狂风呼啸着席卷大地，在地面卷起厚重的沙幕。")
	late_warning_message = span_greenannounce("狂风尖啸，裹挟着足以遮蔽视线的沙尘。")
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
