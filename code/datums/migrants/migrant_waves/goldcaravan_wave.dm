/datum/migrant_wave/goldcaravan
	name = "EA-Hasir's Gold Caravan"
	max_spawns = 1
	weight = 40
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/ea_hasir/merchant = 1,
	)
	optional_roles = list(
		/datum/migrant_role/ea_hasir/guard = 2,
	)
	min_optional_fills = 0
	greet_text = "The esteemed EA Hasir sent your gold caravan forth, Promising only the finest quality gold in grimoria\
	Sell your golden riches and wonders- at a high price."
