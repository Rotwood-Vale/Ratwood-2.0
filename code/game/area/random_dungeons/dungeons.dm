/area/rogue/under/dungeon
	name = "地牢"
	// warden_area = TRUE
	icon_state = "basement"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE
	// ambush_times = list("night","dawn","dusk","day")
	// ambush_mobs = list(
	// 			/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
	// 			/mob/living/carbon/human/species/goblin/npc/ambush/cave = 20,
	// 			/mob/living/carbon/human/species/skeleton/npc/ambush = 10,
	// 			/mob/living/carbon/human/species/human/northern/highwayman/ambush = 5,
	// 			/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 5,
	// 			/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 5)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "深埋地下的栖居处，是下方更深处的黑暗凹陷。"
	ceiling_protected = TRUE

/area/rogue/under/dungeon/sunkenchurch
	name = "沉没教堂"
	icon_state = "sunkenz"
	droning_sound = 'sound/music/area/scroll_of_nihilism.ogg'
	deathsight_message = "一处黑暗可怖、堕落扭曲的礼拜之地，深陷死亡与泥泞"
	detail_text = DETAIL_TEXT_SUNKEN_CHURCH

/area/rogue/under/dungeon/tricksntraps
	name = "机关地牢"
	icon_state = "sunkenz"
	droning_sound = 'sound/music/area/scroll_of_nihilism.ogg'
	deathsight_message = "一处沼泽中的石砌藏身所，层层隐匿。"

/area/rogue/under/dungeon/wizarddungeon
	name = "废弃巫师塔"
	first_time_text = "倾颓的魔法师高塔"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/abandonedwizartorium.ogg'
	deathsight_message = "伟大头脑铸成更大错误之地。"

/area/rogue/under/dungeon/drowfort
	name = "卓尔前哨"
	droning_sound = 'sound/music/area/underdark.ogg'
	deathsight_message = "一处深邃幽暗、充满痛苦与支配的巢穴。"

/area/rogue/under/dungeon/oldgoblincamp
	name = "地精营地"
	first_time_text = "失落营地"
	droning_sound = 'sound/music/area/gobcamp.ogg'
	deathsight_message = "一座沾满地精痕迹的隐秘堡垒"

/area/rogue/under/dungeon/orcfort
	name = "orc encampment"
	// first_time_text = "idk what a good name is for this"
	droning_sound = 'sound/music/area/gobcamp.ogg'
	deathsight_message = "A hidden orc-stained fortress"

/area/rogue/under/dungeon/inferno
	name = "炼狱"
	icon_state = "fire_chamber"
	first_time_text = "异界之地"
	ambientsounds = AMB_CAVELAVA
	ambientnight = AMB_CAVELAVA
	droning_sound = 'sound/music/area/inferno.ogg'
	deathsight_message = "凡世之外一片灼热炽烈的领域"
