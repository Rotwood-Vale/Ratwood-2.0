GLOBAL_LIST_INIT(vanderlin_weather, list(PARTICLEWEATHER_RAIN, PARTICLEWEATHER_BLOODRAIN, PARTICLEWEATHER_LEAVES))
SUBSYSTEM_DEF(ParticleWeather)
	name = "Particle Weather"
	flags = SS_BACKGROUND
	wait = 10
	runlevels = RUNLEVEL_GAME
	var/list/elligble_weather = list()
	var/datum/particle_weather/runningWeather
	var/datum/weather_effect/weather_special_effect
	var/queued_weather_start_time  //Used by barometers to know when the next storm is coming
	var/datum/particle_weather/queued_weather
	var/particles/weather/particleEffect
	var/obj/weatherEffect

	var/list/turfs_to_process = list()
	var/list/weathered_turfs = list()

	var/datum/forecast/selected_forecast
/datum/controller/subsystem/ParticleWeather/fire()
	// process active weather
	if(runningWeather)
		if(runningWeather.running)
			runningWeather.tick()
			for(var/mob/act_on as anything in GLOB.mob_living_list) //yikes. this should probably be a client scan not all mobs. it already checks for minds
				runningWeather.try_weather_act(act_on)
			if(runningWeather.target_trait == PARTICLEWEATHER_RAIN)	//also a bit of a yikes- but none of our other weather needs to affect objects. No sense in running the for loop every single weather that doesn't even use it
				for(var/obj/act_on as anything in GLOB.weather_act_upon_list)
					runningWeather.weather_obj_act(act_on)


//This has been mangled - currently only supports 1 weather effect serverwide so I can finish this
/datum/controller/subsystem/ParticleWeather/Initialize(start_timeofday)
	for(var/V in subtypesof(/datum/particle_weather))
		var/datum/particle_weather/W = V
		var/probability = initial(W.probability)
		var/target_trait = initial(W.target_trait)

		// any weather with a probability set may occur at random
		if (prob(probability) && (target_trait in GLOB.vanderlin_weather)) //TODO VANDERLIN: Map trait this.
			LAZYINITLIST(elligble_weather)
			elligble_weather[W] = probability
	switch(SSmapping.config.map_name)
		if("Rockhill")
			selected_forecast = new /datum/forecast/rockhill()
		if("Dun World")
			selected_forecast = new /datum/forecast/dunworld()

		if("Desert Town")//placeholder, update with desertmap
			selected_forecast = new /datum/forecast/alashur()
		else
			selected_forecast = new /datum/forecast/rockhill()	//Default to rockhill if no configs match so we have some weather
	return ..()

/datum/controller/subsystem/ParticleWeather/proc/run_weather(datum/particle_weather/weather_datum_type, force = 0, color)

	if(runningWeather || queued_weather)
		if(!force)
			return
		if(runningWeather)
			runningWeather.end()
	if (istext(weather_datum_type))
		for (var/V in subtypesof(/datum/particle_weather))
			var/datum/particle_weather/W = V
			if (initial(W.name) == weather_datum_type)
				weather_datum_type = V
				break
	if (!ispath(weather_datum_type, /datum/particle_weather))
		CRASH("run_weather called with invalid weather_datum_type: [weather_datum_type || "null"]")

	runningWeather = new weather_datum_type()

	if(force)
		runningWeather.start(color)
	else
		var/randTime = rand(0, 6000) + initial(runningWeather.weather_duration_upper)

		queued_weather = runningWeather
		queued_weather_start_time = world.time + randTime

		// Early forecast warning
		runningWeather.send_warning()

		// Schedule late warning 30 seconds before start
		if(randTime > 30 SECONDS)
			addtimer(CALLBACK(runningWeather, /datum/particle_weather/proc/send_late_warning),randTime - (30 SECONDS),TIMER_UNIQUE|TIMER_STOPPABLE)
		// Schedule actual start
		addtimer(CALLBACK(runningWeather, /datum/particle_weather/proc/start),randTime,TIMER_UNIQUE|TIMER_STOPPABLE)


/datum/controller/subsystem/ParticleWeather/proc/make_eligible(possible_weather)
	elligble_weather = possible_weather
// 	next_hit = null

/datum/controller/subsystem/ParticleWeather/proc/getweatherEffect()
	if(!weatherEffect)
		weatherEffect = new /obj()
		weatherEffect.particles = particleEffect
		weatherEffect.filters += filter(type="alpha", render_source=WEATHER_RENDER_TARGET)
		weatherEffect.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	return weatherEffect

/datum/controller/subsystem/ParticleWeather/proc/SetparticleEffect(particles/P, blend_type, filter_type, color, secondary_filter_type)
	particleEffect = P
	weatherEffect.particles = particleEffect
	if(color)
		weatherEffect.color = color
	if(!blend_type)
		weatherEffect.blend_mode = BLEND_DEFAULT
	else
		weatherEffect.blend_mode = blend_type
	weatherEffect.filters = list()
	weatherEffect.filters += filter(type="alpha", render_source=WEATHER_RENDER_TARGET)
	if(filter_type)
		weatherEffect.filters += filter_type
	if(secondary_filter_type)
		weatherEffect.filters += secondary_filter_type

/datum/controller/subsystem/ParticleWeather/proc/stopWeather()
	for(var/obj/act_on as anything in GLOB.weather_act_upon_list)
		if(!act_on)	//guard against nulls from deletions
			continue
		act_on.weather = FALSE
	weatherEffect.particles = null
	QDEL_NULL(runningWeather)
	QDEL_NULL(particleEffect)

/datum/controller/subsystem/ParticleWeather/proc/check_forecast(time_of_day)

	// Do not roll new forecast if weather is active or queued
	if(runningWeather || queued_weather)
		return

	if(!selected_forecast)
		log_game("No selected_forecast set!")
		return

	var/datum/particle_weather/weather_type = selected_forecast.pick_weather(time_of_day)

	if(!weather_type)
		log_game("Forecast roll produced no weather for [time_of_day]")
		return

	GLOB.forecast = initial(weather_type.forecast_tag)

	log_game("Forecast picked [weather_type] for [time_of_day]")

	run_weather(weather_type)
