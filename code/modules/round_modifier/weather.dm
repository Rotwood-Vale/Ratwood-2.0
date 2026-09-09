/datum/round_modifier/clear
	name = "Clear Skies"
	desc = "No interesting weather."
	incompatible = list(/datum/round_modifier/fog, /datum/round_modifier/stormy)
	weather_weights = list(
		/datum/particle_weather/rain_storm = 0,
		/datum/particle_weather/snow_storm = 0,
		/datum/particle_weather/dry_thunderstorm = 0,
		/datum/particle_weather/fog = 0,
		/datum/particle_weather/snow_gentle = 0,
		/datum/particle_weather/heat_wave = 0,
	)

/datum/round_modifier/fog
	name = "Fog"
	desc = "It's gonna fog."
	weather_weights = list(/datum/particle_weather/fog = 4)
	incompatible = list(/datum/round_modifier/stormy)

/datum/round_modifier/stormy
	name = "Stormy"
	desc = "It's gonna storm."
	weight = 8
	min_chaos = 2
	weather_weights = list(
		/datum/particle_weather/rain_storm = 4,
		/datum/particle_weather/snow_storm = 3,
		/datum/particle_weather/dry_thunderstorm = 3,
	)
