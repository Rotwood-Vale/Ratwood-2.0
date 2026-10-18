/datum/migrant_wave/hammerhold
	name = "Hammerholdian Reavers"
	max_spawns = 1
	weight = 40
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/hammerhold/jarl = 1,
	)
	optional_roles = list(
		/datum/migrant_role/hammerhold/tideweaver = 1,
		/datum/migrant_role/hammerhold/volfskin = 1,
		/datum/migrant_role/hammerhold/huscarl = 4,
		/datum/migrant_role/hammerhold/thrall = 4,
	)
	min_optional_fills = 0
	greet_text = "You're a scouting party from Hammerhold, sworn to your jarl and the Ringbearer. Establish a foothold in this foreign land for raids to come and, perhaps, acquire some riches, converts and slaves before anyone else."
