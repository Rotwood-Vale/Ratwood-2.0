/datum/migrant_wave/goldcaravan
	name = "EA-Hasir's Gold Caravan"
	max_spawns = 1
	weight = 40
	downgrade_wave = /datum/migrant_wave/fablefield_down_one
	roles = list(
		/datum/migrant_role/ea_hasir/merchant = 1,
		/datum/migrant_role/ea_hasir/guard = 2,
	)
	greet_text = "The esteemed EA Hasir sent your gold caravan forth, Promising only the finest quality gold in grimoria\
	 Sell your golden riches and wonders- at a high price."

/datum/migrant_wave/goldcaravan_down_one
	name = "EA-Hasir's Gold Caravan"
	shared_wave_type = /datum/migrant_wave/goldcaravan
	downgrade_wave = /datum/migrant_wave/goldcaravan_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/ea_hasir/merchant = 1,
		/datum/migrant_role/ea_hasir/guard = 1,
	)
	greet_text = "The esteemed EA Hasir sent your gold caravan forth, Promising only the finest quality gold in grimoria\
	 Sell your golden riches and wonders- at a high price."
/datum/migrant_wave/goldcaravan_down_two
	name = "EA-Hasir's Gold Caravan"
	shared_wave_type = /datum/migrant_wave/goldcaravan
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/ea_hasir/merchant = 1,
	)
	greet_text = "The esteemed EA Hasir sent your gold caravan forth, Promising only the finest quality gold in grimoria\
	 Sell your golden riches and wonders- at a high price."