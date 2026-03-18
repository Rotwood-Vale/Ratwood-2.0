//Rockhill is meant to be wet, foggy sort of weather. On occasion, snow, leafs and fireflies.
/datum/forecast/rockhill
	day_weather = list(
		/datum/particle_weather/rain_gentle = 25,
		/datum/particle_weather/rain_storm = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/heat_wave = 10,
		/datum/particle_weather/dry_thunderstorm = 10,
		/datum/particle_weather/fog = 10,
	)
	dawn_weather = list(
		/datum/particle_weather/fog = 20,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/fireflies = 15,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/dry_thunderstorm = 5,
		/datum/particle_weather/heat_wave = 5,
		/datum/particle_weather/snow_storm = 5,
		/datum/particle_weather/rain_storm = 5,
	)
	dusk_weather = list(
		/datum/particle_weather/fog = 20,
		/datum/particle_weather/rain_gentle = 20,
		/datum/particle_weather/rain_storm = 20,
		/datum/particle_weather/leaves_gentle = 15,
		/datum/particle_weather/fireflies = 15,
		/datum/particle_weather/snow_gentle = 10,
		/datum/particle_weather/dry_thunderstorm = 5,
		/datum/particle_weather/heat_wave = 5,
		/datum/particle_weather/snow_storm = 5,
	)
	night_weather =  list(
		/datum/particle_weather/fog = 25,
		/datum/particle_weather/rain_gentle = 25,
		/datum/particle_weather/rain_storm = 20,
		/datum/particle_weather/fireflies = 20,
		/datum/particle_weather/snow_gentle = 15,
		/datum/particle_weather/leaves_gentle = 10,
		/datum/particle_weather/snow_storm = 5,
		/datum/particle_weather/heat_wave = 5,
		/datum/particle_weather/dry_thunderstorm = 5,
	)
