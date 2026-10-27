//Dunworld is meant to be wet, leafy, snowy sort of weather. On occasion, ash storms from mountdecap and fireflies.
/datum/forecast/dunworld
	dawn_prob = 20
	day_prob = 15
	night_prob = 20
	dusk_prob = 20
	day_weather = list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/leaves_gentle = 20,
		/datum/particle_weather/snow_storm = 5,
		/datum/particle_weather/rain_storm = 4,
		/datum/particle_weather/hail = 3,
		/datum/particle_weather/ashstorm = 3,
		/datum/particle_weather/fog = 3,
	)
	dawn_weather = list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 5,
		/datum/particle_weather/snow_storm = 4,
		/datum/particle_weather/rain_storm = 3,
		/datum/particle_weather/hail = 3,
		/datum/particle_weather/ashstorm = 3,
	)
	dusk_weather = list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 5,
		/datum/particle_weather/snow_storm = 4,
		/datum/particle_weather/rain_storm = 3,
		/datum/particle_weather/hail = 3,
		/datum/particle_weather/ashstorm = 3,
	)
	night_weather =  list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 3,
		/datum/particle_weather/snow_storm = 5,
		/datum/particle_weather/rain_storm = 4,
		/datum/particle_weather/hail = 3,
		/datum/particle_weather/ashstorm = 3,
	)
