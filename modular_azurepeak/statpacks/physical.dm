// Martial/warrior archetypes

/datum/statpack/physical/trained
	name = "受训有素"
	desc = "多年打磨体魄让你在身体素质上占得优势，但你的其他能力也因此略有荒废。"
	stat_array = list(STAT_STRENGTH = 1, STAT_CONSTITUTION = 1, STAT_WILLPOWER = 1, STAT_PERCEPTION = -1, STAT_INTELLIGENCE = -1)

/datum/statpack/physical/muscular
	name = "健硕"
	desc = "繁重劳作将你锤炼成一团筋骨结实的血肉，这在一个强权即公理的世界里是极宝贵的特质。"
	stat_array = list(STAT_STRENGTH = 2, STAT_CONSTITUTION = 1, STAT_PERCEPTION = -1, STAT_SPEED = -2)

/datum/statpack/physical/tactician
	name = "警醒"
	desc = "你尽己所能同时磨炼身躯与头脑，而警觉便是你的回报。"
	stat_array = list(STAT_STRENGTH = 1, STAT_PERCEPTION = 1, STAT_INTELLIGENCE = 1, STAT_CONSTITUTION = -1, STAT_WILLPOWER = -1)

/datum/statpack/physical/taut
	name = "绷紧"
	desc = "你的身体像时计的发条般绷得极紧，随时准备出击，或在瞬息之间抽身而退。"
	stat_array = list(STAT_STRENGTH = 1, STAT_WILLPOWER = 1, STAT_SPEED = 1, STAT_PERCEPTION = -2, STAT_CONSTITUTION = -1)

/datum/statpack/physical/toil
	name = "劳苦成钢"
	desc = "艰辛一生只教会了你一句话：无论如何都要撑下去。于是你便坚持至今。"
	stat_array = list(STAT_WILLPOWER = 2, STAT_CONSTITUTION = 1, STAT_PERCEPTION = -1, STAT_INTELLIGENCE = -1)

/datum/statpack/physical/struggler
	name = "挣扎者"
	desc = "命运发给你一手烂牌，于是你干脆选择把牌桌掀了。"
	stat_array = list(STAT_STRENGTH = 2, STAT_CONSTITUTION = 2, STAT_WILLPOWER = 2, STAT_INTELLIGENCE = -3, STAT_PERCEPTION = -3, STAT_FORTUNE = -2)

/datum/statpack/physical/enduring
	name = "坚忍"
	desc = "多年来，你甘愿让自己的身体经受极端凶险的磨砺。你对信仰坚定不移，并已发誓绝不再逃。"
	stat_array = list(STAT_CONSTITUTION = 3, STAT_WILLPOWER = 3, STAT_SPEED = -4)
