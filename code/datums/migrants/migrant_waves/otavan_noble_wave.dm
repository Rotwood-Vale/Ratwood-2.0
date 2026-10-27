/datum/migrant_wave/otavan_envoy
	name = "Otavan Emissary"
	max_spawns = 1
	weight = 50
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/otavan/envoy = 1,
	)
	optional_roles = list(
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
		/datum/migrant_role/otavan/scribe = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	min_optional_fills = 0
	greet_text = "You are part of an Otavan diplomatic mission: a small retinue and a Psydonite preacher, ready to represent your homeland."
