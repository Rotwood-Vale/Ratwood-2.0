//Rockhill is meant to be wet, foggy sort of weather. On occasion, snow, leafs and fireflies.
/datum/forecast/rockhill
	dawn_prob = 20
	day_prob = 15
	night_prob = 20
	dusk_prob = 20
	day_weather = list(
		/datum/particle_weather/rain_gentle = 25,
		/datum/particle_weather/leaves_gentle = 20,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/heat_wave = 10,
		/datum/particle_weather/fog = 5,
		/datum/particle_weather/rain_storm = 5,
		/datum/particle_weather/dry_thunderstorm = 3,
	)
	dawn_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 10,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/heat_wave = 5,
		/datum/particle_weather/rain_storm = 3,
		/datum/particle_weather/dry_thunderstorm = 2,
		/datum/particle_weather/snow_storm = 2,
	)
	dusk_weather = list(
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fog = 10,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/rain_storm = 5,
		/datum/particle_weather/heat_wave = 5,
		/datum/particle_weather/dry_thunderstorm = 2,
		/datum/particle_weather/snow_storm = 2,
	)
	night_weather =  list(
		/datum/particle_weather/rain_gentle = 25,
		/datum/particle_weather/fireflies = 25,
		/datum/particle_weather/fog = 15,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/leaves_gentle = 10,
		/datum/particle_weather/rain_storm = 5,
		/datum/particle_weather/snow_storm = 2,
		/datum/particle_weather/heat_wave = 2,
		/datum/particle_weather/dry_thunderstorm = 2,
	)
