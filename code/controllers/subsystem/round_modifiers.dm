/datum/controller/subsystem/gamemode
	var/level = 2
	var/budget = 0
	var/list/active_modifiers = list()
	var/modifiers_rolled = FALSE

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

	if(!length(active_modifiers))
		to_chat(world, span_notice("<b>Nothing.</b>"))
		return
	to_chat(world, span_boldnotice("Modifiers:"))
	for(var/datum/round_modifier/M in active_modifiers)
		if(!M.hidden)
			to_chat(world, span_notice("<b>[M.name]</b> - [M.desc]"))
