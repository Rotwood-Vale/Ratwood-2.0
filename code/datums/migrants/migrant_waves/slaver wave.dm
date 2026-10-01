/datum/migrant_wave/slaver
	name = "The Zybantine Slavers"
	max_spawns = 1
	weight = 60
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/slaver/master = 1,
	)
	optional_roles = list(
		/datum/migrant_role/slaver/slavemerc = 6,
		/datum/migrant_role/slaver/slavez = 4,
	)
	min_optional_fills = 1
	greet_text = "A troop of slavers coming to the mainland from the deserts of Zybantine in the hopes of gathering wealth through the trade unfortunate laborers."
