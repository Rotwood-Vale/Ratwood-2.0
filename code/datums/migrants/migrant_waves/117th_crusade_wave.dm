/datum/migrant_wave/crusade
	name = "第117次神圣十字军东征"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_one
	weight = 20
	max_spawns = 1
	roles = list(
		/datum/migrant_role/crusader = 5)
	greet_text = "必须找到 Psydon 的圣杯！Rockhill，虔信之地？呸，这可妨碍不了一场正经的十字军东征！尽情去掠夺与洗劫吧，一切皆为 Astrata 效力。"

/datum/migrant_wave/crusade_down_one
	name = "第117次神圣十字军东征"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/crusader = 4)
	greet_text = "必须找到 Psydon 的圣杯！Rockhill，虔信之地？呸，这可妨碍不了一场正经的十字军东征！尽情去掠夺与洗劫吧，一切皆为 Astrata 效力。"

/datum/migrant_wave/crusade_down_two
	name = "第117次神圣十字军东征"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/crusader = 3)
	greet_text = "必须找到 Psydon 的圣杯！Rockhill，虔信之地？呸，这可妨碍不了一场正经的十字军东征！尽情去掠夺与洗劫吧，一切皆为 Astrata 效力。"

/datum/migrant_wave/crusade_down_three
	name = "第117次神圣十字军东征"
	shared_wave_type = /datum/migrant_wave/crusade
	downgrade_wave = /datum/migrant_wave/crusade_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/crusader = 2)
	greet_text = "必须找到 Psydon 的圣杯！Rockhill，虔信之地？呸，这可妨碍不了一场正经的十字军东征！尽情去掠夺与洗劫吧，一切皆为 Astrata 效力。"

/datum/migrant_wave/crusade_down_four
	name = "第117次独行十字军东征"
	shared_wave_type = /datum/migrant_wave/crusade
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/crusader = 1)
	greet_text = "必须找到 Psydon 的圣杯！Rockhill，虔信之地？呸，这可妨碍不了一场正经的十字军东征！尽情去掠夺与洗劫吧，一切皆为 Astrata 效力。"
