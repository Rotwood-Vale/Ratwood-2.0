/area/rogue/under/cavewet
	name = "地下林泽"
	icon_state = "cavewet"
	warden_area = TRUE
	first_time_text = "地下林泽"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/caves.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
				/mob/living/carbon/human/species/goblin/npc/sea = 20,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "被湿根缠绕的潮湿洞窟"
	detail_text = DETAIL_TEXT_UNDERGROVE

/area/rogue/under/cavewet/bogcaves
	name = "地下林泽"
	first_time_text = "地下林泽"

/area/rogue/under/cavewet/bogcaves/west
	name = "西部地下林泽"
	first_time_text = "西部地下林泽"

/area/rogue/under/cavewet/bogcaves/central
	name = "中央地下林泽"
	first_time_text = "中央地下林泽"

/area/rogue/under/cavewet/bogcaves/camp
	name = "地下林泽营地"
	first_time_text = "地下林泽营地"
	detail_text = DETAIL_TEXT_UNDERGROVE_CAMP

/area/rogue/under/cavewet/bogcaves/south
	name = "南部地下林泽"
	first_time_text = "南部地下林泽"

/area/rogue/under/cavewet/bogcaves/north
	name = "北部地下林泽"
	first_time_text = "北部地下林泽"

/area/rogue/under/cavewet/bogcaves/coastcaves
	name = "南岸洞窟"
	first_time_text = "南岸洞窟"

/area/rogue/under/cave/goblindungeon
	name = "地精营地"
	icon_state = "under"
	first_time_text = "地精营地"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "被树根缠绕的洞窟"
	detail_text = DETAIL_TEXT_GOBLIN_CAMP

/area/rogue/under/cave/skeletoncrypt
	name = "骷髅墓穴"
	icon_state = "under"
	first_time_text = "骷髅墓穴"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "被树根缠绕的洞窟"
	detail_text = DETAIL_TEXT_SKELETON_CRYPT

/area/rogue/under/cavewet/river
	name = "洞窟河流"
	icon_state = "river"
	first_time_text = null
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
