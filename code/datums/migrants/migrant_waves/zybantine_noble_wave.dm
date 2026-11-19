/datum/migrant_wave/zybantine_noble
	name = "Zybantine Emir"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	weight = 40
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/zybantine/emir = 1,
	)
	optional_roles = list(
		/datum/migrant_role/zybantine/amirah = 1,
		/datum/migrant_role/zybantine/janissary = 2,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	min_optional_fills = 0
	greet_text = "You are far from home on missive from the Zybantine Empire."
