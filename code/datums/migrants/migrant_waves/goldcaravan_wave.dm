/datum/migrant_wave/goldcaravan
	name = "EA-Hasir的黄金商队"
	max_spawns = 1
	weight = 40
	downgrade_wave = /datum/migrant_wave/fablefield_down_one
	roles = list(
		/datum/migrant_role/ea_hasir/merchant = 1,
		/datum/migrant_role/ea_hasir/guard = 2,
	)
	greet_text = "备受尊崇的 EA Hasir 派出了你们这支黄金商队，只承诺提供格里莫里亚中最上乘的黄金。\
	去把你们金光闪闪的财富与奇珍异宝卖出高价吧。"

/datum/migrant_wave/goldcaravan_down_one
	name = "EA-Hasir的黄金商队"
	shared_wave_type = /datum/migrant_wave/goldcaravan
	downgrade_wave = /datum/migrant_wave/goldcaravan_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/ea_hasir/merchant = 1,
		/datum/migrant_role/ea_hasir/guard = 1,
	)
	greet_text = "备受尊崇的 EA Hasir 派出了你们这支黄金商队，只承诺提供格里莫里亚中最上乘的黄金。\
	去把你们金光闪闪的财富与奇珍异宝卖出高价吧。"
/datum/migrant_wave/goldcaravan_down_two
	name = "EA-Hasir的黄金商队"
	shared_wave_type = /datum/migrant_wave/goldcaravan
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/ea_hasir/merchant = 1,
	)
	greet_text = "备受尊崇的 EA Hasir 派出了你们这支黄金商队，只承诺提供格里莫里亚中最上乘的黄金。\
	去把你们金光闪闪的财富与奇珍异宝卖出高价吧。"
