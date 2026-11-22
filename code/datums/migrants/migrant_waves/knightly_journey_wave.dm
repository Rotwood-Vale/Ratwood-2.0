/datum/migrant_wave/knightly_journey
	name = "The Knightly Journey"
	max_spawns = 1
	weight = 50
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/kj_knight = 1,
		/datum/migrant_role/kj_squire = 1,
	)
	optional_roles = list(
		/datum/migrant_role/kj_chaplain = 1,
		/datum/migrant_role/kj_follower = 2,
	)
	min_optional_fills = 0
	greet_text = "A veteran knight errant rides into these lands, their squire a few yils into the trade and no longer green. There are battles ahead, and deeds worth the telling."
