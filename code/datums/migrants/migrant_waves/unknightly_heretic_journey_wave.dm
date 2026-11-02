/datum/migrant_wave/unknightly_heretic_journey
	name = "The Unknightly Journey"
	max_spawns = 1
	weight = 20
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/ukj_dark_itinerant = 1,
		/datum/migrant_role/ukj_varlet = 1,
	)
	optional_roles = list(
		/datum/migrant_role/ukj_dark_chaplain = 1,
	)
	min_optional_fills = 0
	greet_text = "A knight who broke their oath has come to these lands with their varlet, sworn now to the Ascendants. The tennites and psydonites can pray all they like. It won't save them."
