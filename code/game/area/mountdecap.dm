// Areas for Mount Decap
/area/rogue/outdoors/mountains/decap
	name = "断首山"
	icon_state = "decap"
	ambush_mobs = list(
				new /datum/ambush_config/pair_of_direbear = 10,
				new /datum/ambush_config/trio_of_highwaymen = 10,
				new /datum/ambush_config/singular_minotaur = 10,
				new /datum/ambush_config/duo_minotaur = 5,
				new /datum/ambush_config/solo_treasure_hunter = 15,
				new /datum/ambush_config/duo_treasure_hunter = 2,
				new /datum/ambush_config/medium_skeleton_party = 10,
				new /datum/ambush_config/heavy_skeleton_party = 5,
				)
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "断首山"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	deathsight_message = "一片高耸群峰交错盘结的险地"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP

/area/rogue/outdoors/mountains/decap/rockhill
	first_time_text = "高处某地……"

/area/rogue/indoors/shelter/mountains/decap
	icon_state = "decap"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	threat_region = THREAT_REGION_MOUNT_DECAP
	deathsight_message = "一片高耸群峰交错盘结的险地"
	detail_text = DETAIL_TEXT_DECAP_TARICHEA

/area/rogue/outdoors/mountains/decap/stepbelow
	name = "塔里凯亚，失落之谷"
	icon_state = "decap"
	ambush_mobs = list(
				new /datum/ambush_config/pair_of_direbear = 10,
				new /datum/ambush_config/trio_of_highwaymen = 10,
				new /datum/ambush_config/singular_minotaur = 10,
				new /datum/ambush_config/duo_minotaur = 5,
				new /datum/ambush_config/solo_treasure_hunter = 5,
				new /datum/ambush_config/duo_treasure_hunter = 1,
				new /datum/ambush_config/medium_skeleton_party = 20,
				new /datum/ambush_config/heavy_skeleton_party = 10,
				)
	droning_sound = 'sound/music/area/decap_deeper.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "塔里凯亚，失落之谷"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_TARICHEA

/area/rogue/outdoors/mountains/decap/gunduzirak
	name = "贡杜-齐拉克"
	icon_state = "decap"
	ambush_mobs = list(
				new /datum/ambush_config/treasure_hunter_posse = 1,
				/mob/living/carbon/human/species/dwarfskeleton/ambush = 30,
				)
	droning_sound = 'sound/music/area/prospector.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "贡杜-齐拉克遗迹"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_GUNDU_ZIRAK

/area/rogue/outdoors/mountains/decap/gunduzirak/bossarena
	name = "女男爵首领战场"
	first_time_text = "女男爵"
	detail_text = DETAIL_TEXT_DECAP_GUNDU_ZIRAK


/area/rogue/outdoors/mountains/decap/gunduzirak/bossarena/can_craft_here()
	return FALSE

/area/rogue/under/cave/dragonden
	name = "群龙之穴"
	icon_state = "under"
	first_time_text = "群龙之穴"
	droning_sound = 'sound/music/area/dragonden.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "一片高耸群峰交错盘结的险地"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_DRAGONDEN

/area/rogue/under/cave/dragonden/can_craft_here()
	return FALSE

/area/rogue/under/cave/goblinfort
	name = "地精堡垒"
	icon_state = "spidercave"
	first_time_text = "地精堡垒"
	droning_sound = 'sound/music/area/dungeon2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "一片高耸群峰交错盘结的险地"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_GOBLIN_FORTRESS

/area/rogue/under/cave/scarymaze
	name = "内克拉迷宫"
	icon_state = "spidercave"
	first_time_text = "内克拉迷宫"
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	droning_sound_dusk = 'sound/music/area/underworlddrone.ogg'
	droning_sound_night = 'sound/music/area/underworlddrone.ogg'
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "一片高耸群峰交错盘结的险地"
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_NECRAN_LABYRINTH

/area/rogue/outdoors/mountains/decap/minotaurfort
	name = "古代矮人熔炉"
	icon_state = "decap"
	droning_sound = 'sound/music/area/prospector.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "古代矮人熔炉"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/shelter/mountains/decap
	ceiling_protected = TRUE
	threat_region = THREAT_REGION_MOUNT_DECAP
	detail_text = DETAIL_TEXT_DECAP_MINOTAUR_FORTRESS

/area/rogue/outdoors/mountains/decap/minotaurfort/can_craft_here()
	return FALSE
