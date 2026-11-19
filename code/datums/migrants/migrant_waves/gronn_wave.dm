/datum/migrant_wave/gronn
	name = "Gronn Raiding Party"
	max_spawns = 1
	weight = 40
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/gronn/chieftain = 1,
	)
	optional_roles = list(
		/datum/migrant_role/gronn/shaman = 1,
		/datum/migrant_role/gronn/warrior = 3,
		/datum/migrant_role/gronn/tribal = 4,
		/datum/migrant_role/gronn/slave = 4,
	)
	min_optional_fills = 0
	greet_text = "You're a scouting party sent directly from the steppes of Gronn itself. Without the main support of your warband, on this odd place, could you hope to survive, and, perhaps, thrive?"
