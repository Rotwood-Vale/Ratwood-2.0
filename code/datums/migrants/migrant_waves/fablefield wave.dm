/datum/migrant_wave/fablefield
	name = "Fablefield剧团"
	max_spawns = 1
	weight = 20
	downgrade_wave = /datum/migrant_wave/fablefield_down_one
	roles = list(
		/datum/migrant_role/fablefield/goliard = 1,
		/datum/migrant_role/fablefield/troubadour = 3,
	)
	greet_text = "你们是一支来自美丽 Fablefield 的吟游艺人剧团，为寻求灵感而来到谷地，仿佛每一步都受 Xylix 的奇思所牵引。这里的人们看起来正需要一场精彩演出，那就给他们留下一场永生难忘的表演吧！"

/datum/migrant_wave/fablefield_down_one
	name = "Fablefield剧团"
	shared_wave_type = /datum/migrant_wave/fablefield
	downgrade_wave = /datum/migrant_wave/fablefield_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/fablefield/goliard = 1,
		/datum/migrant_role/fablefield/troubadour = 2,
	)
	greet_text = "你们是一支来自美丽 Fablefield 的吟游艺人剧团，为寻求灵感而来到谷地，仿佛每一步都受 Xylix 的奇思所牵引。这里的人们看起来正需要一场精彩演出，那就给他们留下一场永生难忘的表演吧！"

/datum/migrant_wave/fablefield_down_two
	name = "Fablefield剧团"
	shared_wave_type = /datum/migrant_wave/fablefield
	downgrade_wave = /datum/migrant_wave/fablefield_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/fablefield/goliard = 1,
		/datum/migrant_role/fablefield/troubadour = 1,
	)
	greet_text = "你们是一支来自美丽 Fablefield 的吟游艺人剧团，为寻求灵感而来到谷地，仿佛每一步都受 Xylix 的奇思所牵引。这里的人们看起来正需要一场精彩演出，那就给他们留下一场永生难忘的表演吧！"

/datum/migrant_wave/fablefield_down_three
	name = "Fablefield游艺诗人"
	shared_wave_type = /datum/migrant_wave/fablefield
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/fablefield/goliard = 1
	)
	greet_text = "你的同伴已经离你而去，如 Xylix 所教导的那样，迷失在人生无常的奇思之中。但你仍继续迈入谷地。这里的人们看起来正需要一场精彩演出，那就为了你的同伴，给他们留下一场永生难忘的表演吧！"
