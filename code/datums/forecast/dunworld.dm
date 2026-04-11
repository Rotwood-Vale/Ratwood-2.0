//Dunworld is meant to be wet, leafy, snowy sort of weather. On occasion, ash storms from mountdecap and fireflies.
/datum/forecast/dunworld
	day_weather = list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/snow_storm = 20,
		/datum/particle_weather/rain_storm = 15,
		/datum/particle_weather/ashstorm = 15,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/hail = 15,
		/datum/particle_weather/fog = 5,
	)
	dawn_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/snow_storm = 15,
		/datum/particle_weather/rain_storm = 15,
		/datum/particle_weather/ashstorm = 15,
		/datum/particle_weather/fireflies = 15,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/hail = 15,
		/datum/particle_weather/fog = 10,
	)
	dusk_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/snow_storm = 15,
		/datum/particle_weather/rain_storm = 15,
		/datum/particle_weather/fireflies = 15,
		/datum/particle_weather/ashstorm = 15,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/hail = 15,
		/datum/particle_weather/fog = 10,
	)
	night_weather =  list(
		/datum/particle_weather/snow_gentle = 25,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/snow_storm = 20,
		/datum/particle_weather/rain_storm = 15,
		/datum/particle_weather/ashstorm = 15,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/hail = 15,
		/datum/particle_weather/fog = 5,
	)
