/datum/migrant_wave/czwarteki_noble
	name = "Czwarteki Retinue"
	max_spawns = 1
	weight = 50
	track = MIGRANT_TRACK_SPECIAL
	required_roles = list(
		/datum/migrant_role/czwarteki/lord = 1,
	)
	optional_roles = list(
		/datum/migrant_role/czwarteki/heir = 1,
		/datum/migrant_role/czwarteki/hussar = 2,
		/datum/migrant_role/czwarteki/retainer = 4,
		/datum/migrant_role/czwarteki/servant = 2,
	)
	min_optional_fills = 0
	greet_text = "You are a Retinue under a Czwarteki Lord, be it diplomacy, war, or simple passing through the realm to see or assist an old alliance."
