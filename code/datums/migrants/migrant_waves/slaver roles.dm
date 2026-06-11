#define CTAG_SLAVER_MASTER "slaver_master"
#define CTAG_SLAVER_MERC "slaver_mercenary"
#define CTAG_SLAVER_SLAVE "slaver_slave"

/datum/migrant_role/slaver/master
	name = "Zybantynian主奴者"
	greet_text = "你是 Zybantynian 奴隶队伍的首领。你从 Zybantine 西部沙漠来到大陆，希望通过训练并贩卖那些不幸的劳工来聚敛财富。\
	这种行径在某些人看来卑劣可憎，但毫无疑问，它能在你回到 Zybantynian 的沙漠之前高效地装满你的口袋。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	advclass_cat_rolls = list(CTAG_SLAVER_MASTER = 20)

/datum/migrant_role/slaver/slavemerc
	name = "Zybantynian佣兵"
	greet_text = "你是受雇于 Zybantine 奴隶队伍的武装打手。你来自 Zybantine 的沙漠，并受 Zybantynian 主奴者以契约雇佣。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	show_wanderer_examine = TRUE
	advclass_cat_rolls = list(CTAG_SLAVER_MERC = 20)

/datum/migrant_role/slaver/slavez
	name = "奴隶"
	greet_text = "你是个不幸的奴隶，自家园被掳走，带往 Zybantine，长久受训于苦役与服从，以至于你几乎只剩下对从前身份的模糊记忆……如今你正被从沙漠运往更加严酷的土地，等待被出售。"
	allowed_sexes = list(MALE, FEMALE)
	allowed_races = RACES_ALL_KINDS
	grant_lit_torch = TRUE
	show_wanderer_examine = FALSE
	advclass_cat_rolls = list(CTAG_SLAVER_SLAVE = 20)
