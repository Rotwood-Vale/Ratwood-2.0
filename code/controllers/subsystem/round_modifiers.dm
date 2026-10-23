#define ANTAG_TIER_MINOR 1
#define ANTAG_TIER_MEDIUM 2
#define ANTAG_TIER_MAJOR 3
#define ANTAG_WAVES_PER_CHECKPOINT 2
#define ANTAG_DEPLETED_RATIO 0.5

/datum/controller/subsystem/gamemode
	var/level = 2
	var/budget = 0
	var/list/active_modifiers = list()
	var/modifiers_rolled = FALSE
	var/list/draw_flags
	var/list/pending_antag_waves = list()
	/// Migrant waves that can answer a deficit, indexed by ANTAG_TIER_* (1 minor, 2 medium, 3 major). type = weight
	var/list/antag_wave_pools = list(
		list(), // minor
		list(/datum/migrant_wave/gnolls = 10, /datum/migrant_wave/assassin = 10, /datum/migrant_wave/wretches = 10),	//moderate
		list(/datum/migrant_wave/bandit = 10),	//major
	)
/datum/controller/subsystem/gamemode/proc/chaos_vote_result(winner)
	switch(winner)
		if("Adventure")
			level = 0
		if("Chaos")
			var/players = length(GLOB.new_player_list)
			if(players >= 140)
				level = 3
			else if(players >= 120)
				level = 2
			else
				level = 1
	if(level >= 3 && SSpersistence.last_chaos_level >= 3)
		level = 2
	SSpersistence.SaveChaosLevel(level)
	to_chat(world, span_notice("<b>[winner]!</b>"))
	roll_round_modifiers()

/datum/controller/subsystem/gamemode/proc/roll_round_modifiers()
	if(modifiers_rolled)
		return
	modifiers_rolled = TRUE

	if(istype(SSvote.current_vote, /datum/vote/chaos))
		SSvote.end_vote()

	switch(level)
		if(0)
			active_modifiers += new /datum/round_modifier/adventure
		if(1)
			budget = rand(2, 5)
		if(2)
			budget = rand(6, 8)
		if(3)
			budget = rand(6, 12)

	var/list/pool = list()
	for(var/T in subtypesof(/datum/round_modifier))
		var/datum/round_modifier/M = new T
		if(level < M.min_chaos || level > M.max_chaos)
			continue
		if(!M.tier && (length(M.job_slots) || length(M.villain_events) || length(M.trigger_events)))
			stack_trace("[M.type] has antag content but no tier")
		if(M.tier)
			continue
		pool[M] = M.weight

	while(budget > 0 && length(pool))
		var/datum/round_modifier/M = pickweight(pool)
		pool -= M
		if(M.cost > budget)
			continue
		var/blocked = FALSE
		for(var/datum/round_modifier/other in active_modifiers)
			if((other.type in M.incompatible) || (M.type in other.incompatible))
				blocked = TRUE
				break
		if(blocked)
			continue
		budget -= M.cost
		active_modifiers += M

	var/list/slots = list()
	var/datum/forecast/forecast = SSParticleWeather?.selected_forecast

	for(var/datum/round_modifier/M in active_modifiers)
		for(var/job_title in M.job_slots)
			slots[job_title] += M.job_slots[job_title]
		for(var/event_type in M.villain_events)
			var/datum/round_event_control/event = locate(event_type) in control
			if(event)
				rolled_villain_events |= event
		if(forecast && length(M.weather_weights))
			for(var/list/weather_list in list(forecast.day_weather, forecast.dawn_weather, forecast.dusk_weather, forecast.night_weather))
				for(var/weather_type in M.weather_weights)
					if(weather_type in weather_list)
						weather_list[weather_type] = round(weather_list[weather_type] * M.weather_weights[weather_type])

	for(var/job_title in slots)
		var/datum/job/J = SSjob.GetJob(job_title)
		if(!J)
			continue
		J.total_positions += slots[job_title]
		J.spawn_positions += slots[job_title]

	apply_modifier_effects(active_modifiers.Copy())
	announce_modifiers(active_modifiers)

/datum/controller/subsystem/gamemode/proc/is_modifier_blocked(datum/round_modifier/M)
	for(var/datum/round_modifier/other as anything in active_modifiers)
		if((other.type in M.incompatible) || (M.type in other.incompatible))
			return TRUE
	return FALSE

/datum/controller/subsystem/gamemode/proc/apply_modifier_effects(list/mods)
	var/list/slots = list()
	var/datum/forecast/forecast = SSParticleWeather?.selected_forecast
	for(var/datum/round_modifier/M as anything in mods)
		for(var/job_title in M.job_slots)
			slots[job_title] += M.job_slots[job_title]
		for(var/event_type in M.villain_events)
			var/datum/round_event_control/event = locate(event_type) in control
			if(event)
				rolled_villain_events |= event
		if(forecast && length(M.weather_weights))
			for(var/list/weather_list in list(forecast.day_weather, forecast.dawn_weather, forecast.dusk_weather, forecast.night_weather))
				for(var/weather_type in M.weather_weights)
					if(weather_type in weather_list)
						weather_list[weather_type] = round(weather_list[weather_type] * M.weather_weights[weather_type])
	for(var/job_title in slots)
		var/datum/job/J = SSjob.GetJob(job_title)
		if(!J)
			continue
		J.total_positions = max(0, J.total_positions + slots[job_title])
		J.spawn_positions = max(0, J.spawn_positions + slots[job_title])

/datum/controller/subsystem/gamemode/proc/announce_modifiers(list/mods)
	var/list/visible = list()
	for(var/datum/round_modifier/M as anything in mods)
		if(!M.hidden && !M.tier)
			visible += M
	if(!length(visible)) // no more "Nothing.": antags may still roll later, so it would be a lie
		return
	to_chat(world, span_boldnotice("Modifiers:"))
	for(var/datum/round_modifier/M as anything in visible)
		to_chat(world, span_notice("<b>[M.name]</b> - [M.desc]"))

/datum/controller/subsystem/gamemode/proc/get_antag_recipe()
	var/minor = 0
	var/medium = 0
	var/major = 0
	switch(level)
		if(1) // low: only happens under 120 players
			minor = rand(0,1)
			medium = rand(0,1)
			major = 1
		if(2) // medium
			minor = 2
			medium = rand(2,3)
			major = 1
		if(3) // high
			minor = 1
			medium = 2
			major = 2
	return list(minor, medium, major) // order matters: ANTAG_TIER (1 minor, 2 medium, 3 major)

/datum/controller/subsystem/gamemode/proc/roll_antag_modifiers()
	var/list/recipe = get_antag_recipe()
	var/list/before = active_modifiers.Copy()
	var/list/all_mods = list()
	for(var/T in subtypesof(/datum/round_modifier))
		all_mods += new T
	for(var/tier in list(ANTAG_TIER_MAJOR, ANTAG_TIER_MEDIUM, ANTAG_TIER_MINOR))
		var/want = recipe[tier]
		for(var/pass in 1 to 2) // pass 2 relaxes min_candidates to 1
			if(want <= 0)
				break
			var/list/pool = list()
			for(var/datum/round_modifier/M as anything in all_mods)
				if(M.tier != tier || level < M.min_chaos || level > M.max_chaos || (M in active_modifiers))
					continue
				if(M.count_optin_candidates() < (pass == 1 ? M.min_candidates : 1))
					continue
				pool[M] = M.weight
			while(want > 0 && length(pool))
				var/datum/round_modifier/M = pickweight(pool)
				pool -= M
				if(is_modifier_blocked(M))
					continue
				active_modifiers += M
				want--
		antag_unfilled[tier] = max(0, want)
		if(want > 0 && tier == ANTAG_TIER_MAJOR)
			message_admins("Antag roll: couldn't fill [want] major slot(s), not enough opted-in candidates.")
	var/list/rolled = active_modifiers - before
	apply_modifier_effects(rolled)
	var/list/names = list()
	for(var/datum/round_modifier/M as anything in rolled)
		names += M.name
	message_admins("Antag draw: [length(antag_optins)] opted in. Rolled: [length(names) ? names.Join(", ") : "none"]")
	log_game("ANTAG DRAW: [names.Join(", ")]")

/datum/controller/subsystem/gamemode/proc/build_draw_roles()
	if(draw_flags)
		return
	draw_flags = list()
	for(var/T in subtypesof(/datum/round_modifier))
		var/datum/round_modifier/M = new T
		if(M.tier)
			for(var/job_title in M.job_slots)
				draw_flags |= job_title // job-based roles use the be_special flag named after the job
			for(var/event_type in M.villain_events)
				var/datum/round_event_control/antagonist/solo/E = locate(event_type) in control
				if(E?.antag_flag)
					draw_flags |= E.antag_flag
		qdel(M)

/proc/get_job_antag_datum(job_title)
	for(var/role_type in GLOB.migrant_roles)
		var/datum/migrant_role/R = GLOB.migrant_roles[role_type]
		if(R.antag_datum && R.name == job_title)
			return R.antag_datum

/datum/round_modifier/proc/get_antag_datum_types()
	. = list()
	for(var/job_title in job_slots)
		var/datum_type = get_job_antag_datum(job_title)
		if(datum_type)
			. |= datum_type
	for(var/event_type in villain_events)
		var/datum/round_event_control/antagonist/solo/E = locate(event_type) in SSgamemode.control
		if(E?.antag_datum)
			. |= E.antag_datum

/datum/round_modifier/proc/count_alive()
	. = 0
	var/list/types = get_antag_datum_types()
	if(!length(types))
		return
	var/list/counted = list()
	for(var/datum/antagonist/A as anything in GLOB.antagonists)
		if(QDELETED(A) || QDELETED(A.owner) || counted[A.owner])
			continue
		var/mob/M = A.owner.current
		if(QDELETED(M) || !M.key || M.stat == DEAD)
			continue
		for(var/datum_type in types)
			if(istype(A, datum_type))
				counted[A.owner] = TRUE
				.++
				break

/datum/controller/subsystem/gamemode/proc/get_depleted_modifiers()
	. = list()
	for(var/datum/round_modifier/M as anything in antag_baselines)
		if(M.count_alive() <= antag_baselines[M] * ANTAG_DEPLETED_RATIO)
			. += M

/datum/controller/subsystem/gamemode/proc/run_antag_checkpoint(forced = FALSE)
	if(level <= 0 || !antag_baseline_taken)
		return
	var/hours = round((world.time - SSticker.round_start_time) / (1 HOURS), 0.1)
	var/list/depleted = get_depleted_modifiers()
	var/list/deficits = antag_unfilled.Copy()
	for(var/datum/round_modifier/M as anything in depleted)
		deficits[M.tier]++
	if(forced && !(deficits[1] || deficits[2] || deficits[3]))
		deficits[ANTAG_TIER_MEDIUM] = 1 // testing: pretend one medium antagonist went missing
	var/summary = "minor [deficits[ANTAG_TIER_MINOR]], medium [deficits[ANTAG_TIER_MEDIUM]], major [deficits[ANTAG_TIER_MAJOR]]"
	if(!(deficits[1] || deficits[2] || deficits[3]))
		message_admins("Antag checkpoint ([hours]h): all tiers healthy.")
		return
	if(!forced && !can_inject_antags())
		message_admins("Antag checkpoint ([hours]h): deficits ([summary]) but the antag cap is full, no wave.")
		return
	if(!forced && get_active_player_count(alive_check = TRUE, afk_check = TRUE, human_check = TRUE) < CHARACTER_INJECTION_MIN_POP)
		message_admins("Antag checkpoint ([hours]h): deficits ([summary]) but pop is too low, no wave.")
		return
	message_admins("Antag checkpoint ([hours]h): deficits [summary].")
	request_antag_wave(deficits)

/datum/controller/subsystem/gamemode/proc/request_antag_wave(list/deficits)
	var/list/queued = list()
	for(var/tier in list(ANTAG_TIER_MAJOR, ANTAG_TIER_MEDIUM, ANTAG_TIER_MINOR))
		var/list/pool = antag_wave_pools[tier].Copy()
		for(var/i in 1 to deficits[tier])
			if(!length(pool) || length(queued) >= ANTAG_WAVES_PER_CHECKPOINT)
				break
			var/wave_type = pickweight(pool)
			pool -= wave_type
			queued += wave_type
	if(!length(queued))
		message_admins("Antag checkpoint: no migrant wave can answer those deficits.")
		return FALSE
	pending_antag_waves += queued
	return TRUE

/// Polled from fire(): starts the next queued wave once the Event track is free.
/datum/controller/subsystem/gamemode/proc/process_pending_antag_waves()
	if(!length(pending_antag_waves) || SSmigrants.track_forming[MIGRANT_TRACK_EVENT])
		return
	var/wave_type = pending_antag_waves[1]
	pending_antag_waves.Cut(1, 2)
	var/datum/migrant_wave/wave = MIGRANT_WAVE(wave_type)
	SSmigrants.last_ooc_ping = 0 // our waves bypass the 5 minute ping throttle
	SSmigrants.begin_forming(MIGRANT_TRACK_EVENT, wave_type)
	SSmigrants.announce_special_wave(wave_type)
	message_admins("Antag checkpoint: forming migrant wave [wave.name] on the Event track.")
