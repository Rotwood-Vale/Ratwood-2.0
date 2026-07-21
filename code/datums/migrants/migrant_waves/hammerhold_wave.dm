/datum/migrant_wave/hammerhold
	name = "Hammerholdian Reavers"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/hammerhold
	weight = 40
	downgrade_wave = /datum/migrant_wave/hammerhold_down_one
	roles = list(
		/datum/migrant_role/hammerhold/jarl = 1,
		/datum/migrant_role/hammerhold/tideweaver = 1,
		/datum/migrant_role/hammerhold/volfskin = 1,
		/datum/migrant_role/hammerhold/huscarl = 4,
		/datum/migrant_role/hammerhold/thrall = 4
	)
	greet_text = "You're a scouting party from Hammerhold, sworn to your jarl and the Ringbearer. Establish a foothold in this foreign land for raids to come and, perhaps, acquire some riches, converts and slaves before anyone else."

/datum/migrant_wave/hammerhold_down_one
	name = "Hammerholdian Reavers"
	shared_wave_type = /datum/migrant_wave/hammerhold
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/hammerhold_down_two
	roles = list(
		/datum/migrant_role/hammerhold/jarl = 1,
		/datum/migrant_role/hammerhold/tideweaver = 1,
		/datum/migrant_role/hammerhold/volfskin = 1,
		/datum/migrant_role/hammerhold/huscarl = 2,
		/datum/migrant_role/hammerhold/thrall = 2
	)
	greet_text = "You're a scouting party from Hammerhold, sworn to your jarl and the Ringbearer. You have already lost some good men, but your goal remains: establish a foothold in this foreign land for raids to come."

/datum/migrant_wave/hammerhold_down_two
	name = "Hammerholdian Reavers"
	shared_wave_type = /datum/migrant_wave/hammerhold
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/hammerhold_down_three
	roles = list(
		/datum/migrant_role/hammerhold/jarl = 1,
		/datum/migrant_role/hammerhold/tideweaver = 1,
		/datum/migrant_role/hammerhold/volfskin = 1,
		/datum/migrant_role/hammerhold/huscarl = 1,
		/datum/migrant_role/hammerhold/thrall = 1
	)
	greet_text = "You're a scouting party from Hammerhold, sworn to your jarl and the Ringbearer. You have already lost many good men. Your goal of establishing a foothold in this land begins to seem unrealistic."

/datum/migrant_wave/hammerhold_down_three
	name = "Hammerholdian Reavers"
	shared_wave_type = /datum/migrant_wave/hammerhold
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/hammerhold_down_four
	roles = list(
		/datum/migrant_role/hammerhold/jarl = 1,
		/datum/migrant_role/hammerhold/tideweaver = 1,
		/datum/migrant_role/hammerhold/volfskin = 1,
		/datum/migrant_role/hammerhold/huscarl = 1
	)
	greet_text = "You're a scouting party from Hammerhold, sworn to your jarl and the Ringbearer. Most of your party is dead. Your goal of establishing a foothold in this land is more than a little unrealistic now."

/datum/migrant_wave/hammerhold_down_four
	name = "Hammerholdian Reavers"
	shared_wave_type = /datum/migrant_wave/hammerhold
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/hammerhold_down_five
	roles = list(
		/datum/migrant_role/hammerhold/jarl = 1,
		/datum/migrant_role/hammerhold/tideweaver = 1,
		/datum/migrant_role/hammerhold/volfskin = 1
	)
	greet_text = "You're a scouting party from Hammerhold, sworn to your jarl and the Ringbearer. Most of your party is dead, it's just three of you now. Survive, the Lord of Abyss still needs you."

/datum/migrant_wave/hammerhold_down_five
	name = "Hammerholdian Reavers"
	shared_wave_type = /datum/migrant_wave/hammerhold
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/hammerhold_down_six
	roles = list(
		/datum/migrant_role/hammerhold/jarl = 1,
		/datum/migrant_role/hammerhold/tideweaver = 1
	)
	greet_text = "You're a scouting party from Hammerhold, sworn to your jarl and the Ringbearer. Most of your party is dead, it's just two of you now. Survive."

/datum/migrant_wave/hammerhold_down_six
	name = "Hammerholdian Reavers"
	shared_wave_type = /datum/migrant_wave/hammerhold
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/hammerhold/jarl = 1
	)
	greet_text = "You were a scouting party from Hammerhold. You are the sole survivor, your warband gave up their lives to save yours. Now you can rely only on Abyssor and your own might."