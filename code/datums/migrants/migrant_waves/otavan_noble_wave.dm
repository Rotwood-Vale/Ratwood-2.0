/datum/migrant_wave/otavan_envoy
	name = "Otava使团"
	max_spawns = 1
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	weight = 50
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_one
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
		/datum/migrant_role/otavan/scribe = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	greet_text = "你们是 Otava 外交使团的一员，带着一小队随员与一位 Psydonite 传教士，准备代表自己的祖国。"

/datum/migrant_wave/otavan_envoy_down_one
	name = "Otava使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_two
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
		/datum/migrant_role/otavan/scribe = 1,
	)
	greet_text = "你们是 Otava 外交使团的一员，带着一小队随员与一位 Psydonite 传教士，准备代表自己的祖国。那位 Psydonite 已经死了，你们必须继续前行。"

/datum/migrant_wave/otavan_envoy_down_two
	name = "Otava使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_three
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	greet_text = "你们是 Otava 外交使团的一员，带着一小队随员与一位 Psydonite 传教士，准备代表自己的祖国。书记官被巨魔一口吞下，什么都没剩。"

/datum/migrant_wave/otavan_envoy_down_three
	name = "Otava使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_four
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/guard = 1,
	)
	greet_text = "你们是 Otava 外交使团的一员，带着一小队随员与一位 Psydonite 传教士，准备代表自己的祖国。书记官病逝了，而那位 Psydonite 留下来为其下葬。"

/datum/migrant_wave/otavan_envoy_down_four
	name = "Otava使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_five
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	greet_text = "你们是 Otava 外交使团的一员，带着一小队随员与一位 Psydonite 传教士，准备代表自己的祖国。书记官与重弩手都死于强盗之手，你们就快到了！"

/datum/migrant_wave/otavan_envoy_down_five
	name = "Otava使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_six
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/preacher = 1,
	)
	greet_text = "你们是 Otava 外交使团的一员，带着一小队随员与一位 Psydonite 传教士，准备代表自己的祖国。你的骑士与重弩手在试图从一群死徒手中救出书记官时死去，你必须忍耐下去。"

/datum/migrant_wave/otavan_envoy_down_six
	name = "Otava使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	downgrade_wave = /datum/migrant_wave/otavan_envoy_down_seven
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
		/datum/migrant_role/otavan/knight = 1,
	)
	greet_text = "你们是 Otava 外交使团的一员，带着一小队随员与一位 Psydonite 传教士，准备代表自己的祖国。重弩手和书记官死于可怕的车祸，而那位 Psydonite 也把自己喝死了。让你们高贵的使命继续活下去。"

/datum/migrant_wave/otavan_envoy_down_seven
	name = "Otava使团"
	can_roll = FALSE
	shared_wave_type = /datum/migrant_wave/otavan_envoy
	roles = list(
		/datum/migrant_role/otavan/envoy = 1,
	)
	greet_text = "你们是 Otava 外交使团的一员，带着一小队随员与一位 Psydonite 传教士，准备代表自己的祖国。骑士溺死了，重弩手饿死了，书记官摔断了脖子，而 Psydonite 转向了 Zizo 后也死了，如今只剩下你。"
