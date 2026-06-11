/datum/migrant_wave/zybantine_noble
	name = "Zybantine埃米尔"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	weight = 40
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_one
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
		/datum/migrant_role/zybantine/janissary = 2,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_one
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_two
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
		/datum/migrant_role/zybantine/janissary = 1,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_two
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_three
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
		/datum/migrant_role/zybantine/janissary = 2,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_three
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_four
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/janissary = 2,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_four
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_five
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/janissary = 1,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_five
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_six
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
		/datum/migrant_role/zybantine/janissary = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_six
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_seven
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_seven
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_eight
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_eight
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_nine
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/janissary = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"

/datum/migrant_wave/zybantine_noble_down_nine
	name = "Zybantine埃米尔"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
	)
	greet_text = "你们奉 Zybantine 帝国之命远离家园而来。"
