/datum/migrant_wave/crusade
	name = "The 117th Holy Crusade"
	weight = 20
	max_spawns = 1
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/crusader = 1,
	)
	optional_roles = list(
		/datum/migrant_role/crusader = 4
	)
	min_optional_fills = 0
	greet_text = "Psydon's holy chalice must be found! Rockhill, a faithful land? Bah, Why let that get in the way of a good crusade! Plenty of looting and pillaging to be done- all in service to Astrata."
