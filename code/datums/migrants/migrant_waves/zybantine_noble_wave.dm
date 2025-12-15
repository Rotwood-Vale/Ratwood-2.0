/datum/migrant_wave/zybantine_noble
	name = "Zybantine Emir"
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
	greet_text = "You are far from home on missive from the Zybantine Empire."

/datum/migrant_wave/zybantine_noble_down_one
	name = "Zybantine Emir"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_two
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
		/datum/migrant_role/zybantine/janissary = 1,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "You are far from home on missive from the Zybantine Empire."

/datum/migrant_wave/zybantine_noble_down_two
	name = "Zybantine Emir"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_three
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
		/datum/migrant_role/zybantine/janissary = 2,
	)
	greet_text = "You are far from home on missive from the Zybantine Empire."

/datum/migrant_wave/zybantine_noble_down_three
	name = "Zybantine Emir"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_four
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/janissary = 2,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "You are far from home on missive from the Zybantine Empire."

/datum/migrant_wave/zybantine_noble_down_four
	name = "Zybantine Emir"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_five
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/janissary = 1,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "You are far from home on missive from the Zybantine Empire."

/datum/migrant_wave/zybantine_noble_down_five
	name = "Zybantine Emir"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_six
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
		/datum/migrant_role/zybantine/janissary = 1,
	)
	greet_text = "You are far from home on missive from the Zybantine Empire."

/datum/migrant_wave/zybantine_noble_down_six
	name = "Zybantine Emir"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_seven
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/amirah = 1,
	)
	greet_text = "You are far from home on missive from the Zybantine Empire."

/datum/migrant_wave/zybantine_noble_down_seven
	name = "Zybantine Emir"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/zybantine_noble_down_eight
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/advisor = 1,
	)
	greet_text = "You are far from home on missive from the Zybantine Empire."

/datum/migrant_wave/zybantine_noble_down_eight
	name = "Zybantine Emir"
	shared_wave_type = /datum/migrant_wave/zybantine_noble
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/zybantine/emir = 1,
		/datum/migrant_role/zybantine/janissary = 1,
	)
	greet_text = "You are far from home on missive from the Zybantine Empire."