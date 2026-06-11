/datum/migrant_wave/gronn
	name = "Gronn劫掠队"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/gronn
	weight = 40
	downgrade_wave = /datum/migrant_wave/gronn_down_one
	roles = list(
		/datum/migrant_role/gronn/chieftain = 1,
		/datum/migrant_role/gronn/shaman = 1,
		/datum/migrant_role/gronn/warrior = 2,
		/datum/migrant_role/gronn/tribal = 4,
		/datum/migrant_role/gronn/slave = 4
	)
	greet_text = "你们是一支直接从 Gronn 草原派出的侦察队。失去了主力战帮的支援，在这片陌生之地，你们还能活下去，甚至兴旺起来吗？"

/datum/migrant_wave/gronn_down_one
	name = "Gronn劫掠队"
	shared_wave_type = /datum/migrant_wave/gronn
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/gronn_down_two
	roles = list(
		/datum/migrant_role/gronn/chieftain = 1,
		/datum/migrant_role/gronn/shaman = 1,
		/datum/migrant_role/gronn/warrior = 2,
		/datum/migrant_role/gronn/tribal = 2,
		/datum/migrant_role/gronn/slave = 2
	)
	greet_text = "你们是一支直接从 Gronn 草原派出的侦察队。失去了主力战帮的支援，在这片陌生之地，你们已经折损了几名同伴，局势开始变得不妙。"

/datum/migrant_wave/gronn_down_two
	name = "Gronn劫掠队"
	shared_wave_type = /datum/migrant_wave/gronn
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/gronn_down_three
	roles = list(
		/datum/migrant_role/gronn/chieftain = 1,
		/datum/migrant_role/gronn/shaman = 1,
		/datum/migrant_role/gronn/warrior = 1,
		/datum/migrant_role/gronn/tribal = 1,
		/datum/migrant_role/gronn/slave = 1
	)
	greet_text = "你们是一支直接从 Gronn 草原派出的侦察队。失去了主力战帮的支援，在这片陌生之地，你们已经失去了许多人。你们还能活下来吗？"

/datum/migrant_wave/gronn_down_three
	name = "Gronn劫掠队"
	shared_wave_type = /datum/migrant_wave/gronn
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/gronn_down_four
	roles = list(
		/datum/migrant_role/gronn/chieftain = 1,
		/datum/migrant_role/gronn/shaman = 1,
		/datum/migrant_role/gronn/warrior = 1,
		/datum/migrant_role/gronn/slave = 1
	)
	greet_text = "你们是一支直接从 Gronn 草原派出的侦察队。失去了主力战帮的支援，在这片陌生之地，你们已失去大半同伴。你们还剩下多少希望？"

/datum/migrant_wave/gronn_down_four
	name = "Gronn劫掠队"
	shared_wave_type = /datum/migrant_wave/gronn
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/gronn_down_five
	roles = list(
		/datum/migrant_role/gronn/chieftain = 1,
		/datum/migrant_role/gronn/shaman = 1,
		/datum/migrant_role/gronn/warrior = 1
	)
	greet_text = "你们是一支直接从 Gronn 草原派出的侦察队。失去了主力战帮的支援，在这片陌生之地，你们已失去大半同伴。如今，只剩你们三人了。"

/datum/migrant_wave/gronn_down_five
	name = "Gronn劫掠队"
	shared_wave_type = /datum/migrant_wave/gronn
	can_roll = FALSE
	downgrade_wave = /datum/migrant_wave/gronn_down_six
	roles = list(
		/datum/migrant_role/gronn/chieftain = 1,
		/datum/migrant_role/gronn/shaman = 1
	)
	greet_text = "你们是一支直接从 Gronn 草原派出的侦察队。失去了主力战帮的支援，在这片陌生之地，你们已失去大半同伴。如今，只剩你们两人了。"

/datum/migrant_wave/gronn_down_six
	name = "Gronn劫掠队"
	shared_wave_type = /datum/migrant_wave/gronn
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/gronn/chieftain = 1
	)
	greet_text = "你们曾是一支直接从 Gronn 草原派出的侦察队。失去了主力战帮的支援后，除你之外其余人都已倒下。仅存的那一点希望，也许只有 Graggah 本人才能指引你。"
