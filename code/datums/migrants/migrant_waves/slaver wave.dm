/datum/migrant_wave/slaver
	name = "Zybantine奴隶贩子"
	max_spawns = 1
	weight = 60
	downgrade_wave = /datum/migrant_wave/slaver_down_one
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/slavemerc = 6,
		/datum/migrant_role/slaver/slavez = 2,
	)
	greet_text = "一支从 Zybantine 沙漠来到大陆的奴隶贩子队伍，希望通过买卖那些不幸劳工来聚敛财富。"

/datum/migrant_wave/slaver_down_one
	name = "Zybantine奴隶贩子"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_two
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/slavemerc = 5,
		/datum/migrant_role/slaver/slavez = 2,
	)
	greet_text = "一支从 Zybantine 沙漠来到大陆的奴隶贩子队伍，希望通过买卖那些不幸劳工来聚敛财富。"

/datum/migrant_wave/slaver_down_two
	name = "Zybantine奴隶贩子"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_three
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/slavemerc = 4,
		/datum/migrant_role/slaver/slavez = 1,
	)
	greet_text = "一支从 Zybantine 沙漠来到大陆的奴隶贩子队伍，希望通过买卖那些不幸劳工来聚敛财富。"

/datum/migrant_wave/slaver_down_three
	name = "Zybantine奴隶贩子"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_four
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/slavemerc = 3,
		/datum/migrant_role/slaver/slavez = 1,
	)
	greet_text = "一支从 Zybantine 沙漠来到大陆的奴隶贩子队伍，希望通过买卖那些不幸劳工来聚敛财富。"

/datum/migrant_wave/slaver_down_four
	name = "Zybantine奴隶贩子"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_five
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/slavemerc = 2,
		/datum/migrant_role/slaver/slavez = 2,
	)
	greet_text = "一支从 Zybantine 沙漠来到大陆的奴隶贩子队伍，希望通过买卖那些不幸劳工来聚敛财富。你手上的货逃掉了，所以你得弄到新的肉票。"

/datum/migrant_wave/slaver_down_five
	name = "Zybantine奴隶贩子"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_six
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/slavemerc = 2,
		/datum/migrant_role/slaver/slavez = 1,
	)
	greet_text = "一支从 Zybantine 沙漠来到大陆的奴隶贩子队伍，希望通过买卖那些不幸劳工来聚敛财富。"

/datum/migrant_wave/slaver_down_six
	name = "Zybantine奴隶贩子"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_seven
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/slavemerc = 1,
		/datum/migrant_role/slaver/slavez = 1,
	)
	greet_text = "一对从 Zybantine 沙漠来到大陆的奴隶贩子，希望通过买卖那些不幸劳工来聚敛财富。"

/datum/migrant_wave/slaver_down_seven
	name = "Zybantine奴隶贩子"
	shared_wave_type = /datum/migrant_wave/slaver
	downgrade_wave = /datum/migrant_wave/slaver_down_eight
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1,
		/datum/migrant_role/slaver/slavez = 1
	)
	greet_text = "一名从 Zybantine 沙漠来到大陆的奴隶主，希望通过买卖那些不幸劳工来聚敛财富。"

/datum/migrant_wave/slaver_down_eight
	name = "Zybantine奴隶贩子"
	shared_wave_type = /datum/migrant_wave/slaver
	can_roll = FALSE
	roles = list(
		/datum/migrant_role/slaver/master = 1
	)
	greet_text = "一名从 Zybantine 沙漠来到大陆的奴隶主，希望通过买卖那些不幸劳工来聚敛财富。"
