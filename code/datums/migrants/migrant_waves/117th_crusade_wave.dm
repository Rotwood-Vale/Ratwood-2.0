/datum/migrant_wave/crusade
	name = "The 117th Holy Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_one
	weight = 20
	max_spawns = 1
	roles = list(
		/datum/migrant_role/crusader = 5)
	greet_text = "Psydon's holy chalice must be found! Rockhill, a faithful land? Bah, Why let that get in the way of a good crusade! Plenty of looting and pillaging to be done- all in service to Astrata."

/datum/migrant_wave/crusade_down_one
	name = "The 117th Holy Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/crusader = 4)
	greet_text = "Psydon's holy chalice must be found! Rockhill, a faithful land? Bah, Why let that get in the way of a good crusade! Plenty of looting and pillaging to be done- all in service to Astrata."

/datum/migrant_wave/crusade_down_two
	name = "The 117th Holy Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/crusader = 3)
	greet_text = "Psydon's holy chalice must be found! Rockhill, a faithful land? Bah, Why let that get in the way of a good crusade! Plenty of looting and pillaging to be done- all in service to Astrata."

/datum/migrant_wave/crusade_down_three
	name = "The 117th Holy Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/crusader = 2)
	greet_text = "Psydon's holy chalice must be found! Rockhill, a faithful land? Bah, Why let that get in the way of a good crusade! Plenty of looting and pillaging to be done- all in service to Astrata."

/datum/migrant_wave/crusade_down_four
	name = "The 117th One-Man Crusade"
	shared_wave_type = /datum/migrant_wave/crusade
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/crusader = 1)
	greet_text = "Psydon's holy chalice must be found! Rockhill, a faithful land? Bah, Why let that get in the way of a good crusade! Plenty of looting and pillaging to be done- all in service to Astrata."