//The island is supposed to be hot and wet, with ash storms from the volcano
/datum/forecast/byos
	day_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 30,
		/datum/particle_weather/leaves_gentle = 10,
		/datum/particle_weather/heat_wave = 20,
		/datum/particle_weather/ashstorm = 20,
		/datum/particle_weather/fireflies = 5,
	)
	dawn_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 30,
		/datum/particle_weather/heat_wave = 20,
		/datum/particle_weather/ashstorm = 20,
		/datum/particle_weather/fireflies = 15,
		/datum/particle_weather/fog = 5,
	)
	dusk_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 30,
		/datum/particle_weather/heat_wave = 20,
		/datum/particle_weather/ashstorm = 20,
		/datum/particle_weather/fireflies = 15,
	)
	night_weather =  list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 30,
		/datum/particle_weather/heat_wave = 20,
		/datum/particle_weather/ashstorm = 20,
		/datum/particle_weather/fog = 5,
	)
