
//desert areas

/area/rogue/outdoors/desert
	name = "内沙丘"
	icon_state = "desert"
	soundenv = 19
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	ambush_times = list("night")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 25,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/fox = 30,
				/mob/living/carbon/human/species/skeleton/npc/supereasy = 30)
	first_time_text = "阿尔-阿舒尔沙丘"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	deathsight_message = "沙丘某处，高墙之旁"
	threat_region = THREAT_REGION_DESERT_NEAR
	
/area/rogue/outdoors/desert/river
	name = "河流"
	icon_state = "river"
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_FOREST

/area/rogue/outdoors/desertdeep
	name = "深沙丘"
	icon_state = "desertdeep"
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	first_time_text = "深沙丘"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	ambush_times = list("night","dawn","dusk","day")	
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/ambush = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 60,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 50,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 10,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,)
	converted_type = /area/rogue/indoors/shelter/desertdeep
	deathsight_message = "一片空旷干涸的沙漠"
	threat_region = THREAT_REGION_DESERT_DEEP

/area/rogue/indoors/shelter/desertdeep
	name = "深沙漠（掩体）"
	icon_state = "desertdeep"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'

/area/rogue/outdoors/desertdeep/safe
	name = "沙漠隘口"
	ambush_times = null
	ambush_mobs = null

/area/rogue/outdoors/desertdeep/above
	name = "深沙漠上层"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

/area/rogue/outdoors/desert/above
	name = "沙漠上层"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

//

/area/rogue/outdoors/town/desert
	name = "沙漠城镇户外"
	icon_state = "town"
	soundenv = 16
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	first_time_text = "阿尔-阿舒尔城"
	town_area = TRUE

/area/rogue/outdoors/town/roofs/desert
	name = "沙漠屋顶"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	first_time_text = null

/area/rogue/outdoors/town/roofs/desert/church
	name = "教堂屋顶"
	holy_area = TRUE

/area/rogue/outdoors/town/roofs/desert/arena
	name = "竞技场屋顶"
	warden_area = TRUE

/area/rogue/outdoors/town/roofs/desert/tavern
	name = "酒馆屋顶"
	tavern_area = TRUE


/area/rogue/indoors/shelter/town/desert
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'

/area/rogue/outdoors/town/manor/desert
	name = "阿尔-阿舒尔宫殿外部"
	icon_state = "manor"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/desert/Iberia2.ogg'
	first_time_text = "阿尔-阿舒尔宫殿"
	keep_area = TRUE

/area/rogue/outdoors/town/manor/roofs/desert
	name = "宫殿屋顶"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	first_time_text = null
///

/area/rogue/indoors/town/desert/warden
	name = "守林人堡垒"
	warden_area = TRUE

/area/rogue/outdoors/banditcamp/desert
	name = "强盗营地"
	droning_sound = 'sound/music/area/desert/stronghold.ogg'
	droning_sound_dusk = 'sound/music/area/desert/stronghold.ogg'
	droning_sound_night = 'sound/music/area/desert/stronghold.ogg'
	first_time_text = "盗贼聚集地"
	deathsight_message = "藏身盗贼之中，匿于巨龙宝库"

/area/rogue/indoors/banditcamp/desert
	name = "强盗营地"
	droning_sound = 'sound/music/area/desert/stronghold.ogg'
	droning_sound_dusk = 'sound/music/area/desert/stronghold.ogg'
	droning_sound_night = 'sound/music/area/desert/stronghold.ogg'
	deathsight_message = "藏身盗贼之中，匿于巨龙宝库"

/area/rogue/outdoors/town/desert
	name = "沙漠城镇户外"
	icon_state = "town"
	soundenv = 16
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	first_time_text = "阿尔-阿舒尔城"
	town_area = TRUE

/area/rogue/outdoors/town/roofs/desert
	name = "沙漠屋顶"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	first_time_text = null
//////////////////////////////////////////////////////////////////

/area/rogue/indoors/shelter/town/desert
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'

/area/rogue/outdoors/town/manor/desert
	name = "阿尔-阿舒尔宫殿外部"
	icon_state = "manor"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/desert/Iberia2.ogg'
	first_time_text = "阿尔-阿舒尔宫殿"
	keep_area = TRUE

/area/rogue/outdoors/town/manor/desert/roofs
	name = "宫殿屋顶"
	icon_state = "roofs"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	first_time_text = null
///

/area/rogue/indoors/town/desert
	name = "沙漠城镇室内"
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	converted_type = /area/rogue/outdoors/exposed/town
	deathsight_message = "阿尔-阿舒尔城及其所有熙攘生灵"

/area/rogue/indoors/town/manor/desert
	name = "阿尔-阿舒尔宫殿内部"
	droning_sound = 'sound/music/area/desert/Iberia1.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/desert/Iberia2.ogg'
	first_time_text = "阿尔-阿舒尔宫殿"
	keep_area = TRUE

/area/rogue/indoors/town/magician/desert
	name = "巫师塔"
	// spookysounds = SPOOKY_MYSTICAL
	// spookynight = SPOOKY_MYSTICAL
	// droning_sound = 'sound/music/area/magiciantower.ogg'
	// droning_sound_dusk = null
	// droning_sound_night = null
	// keep_area = TRUE

/area/rogue/indoors/town/shop/desert
	name = "集市"
	droning_sound = 'sound/music/area/desert/Caravan.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/dwarfin/desert
	name = "行会铁匠铺"
	droning_sound = 'sound/music/area/desert/Sandal.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/physician/desert
	name = "医师"
	droning_sound = 'sound/music/area/academy.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/academy/desert

/area/rogue/indoors/town/bath/desert
	name = "浴场"
	droning_sound = 'sound/music/area/desert/TenThousandDelights.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/garrison/desert
	name = "阿尔-阿舒尔卫戍营"
	droning_sound = 'sound/music/area/desert/DarMeshq.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	
/area/rogue/indoors/town/garrison/desert/cell
	name = "地牢牢房"
	icon_state = "cell"
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/town/garrison/desert/cell/outdoor
	name = "地牢牢房"
	icon_state = "cell"
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/desert/TheRoad.ogg'
	droning_sound_dusk = 'sound/music/area/desert/NightPrayer.ogg'
	droning_sound_night = 'sound/music/area/desert/Moonrise.ogg'
	ceiling_protected = FALSE
	keep_area = TRUE
	cell_area = TRUE

/area/rogue/indoors/town/tavern/desert
	name = "酒馆"
	icon_state = "tavern"
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	tavern_area = TRUE

/area/rogue/indoors/town/desert/warden
	name = "阿塞卜堡垒"
	warden_area = TRUE

/area/rogue/under/town/basement/desert
	name = "地下室"
	town_area = FALSE
	ceiling_protected = TRUE

/area/rogue/under/town/basement/desert/town
	town_area = TRUE

/area/rogue/under/town/basement/desert/keep
	name = "宫殿地下室"
	keep_area = TRUE
	town_area = TRUE

/area/rogue/indoors/town/desert/arenaview
	name = "大竞技场"
	viewing_area = TRUE

/area/rogue/indoors/town/church/cavebasement
	icon_state = "church"
	first_time_text = "十神墓穴"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark2.ogg'

/area/rogue/indoors/town/church/psy
	name = "教堂"
	icon_state = "church"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	holy_area = TRUE
	droning_sound_dawn = 'sound/music/area/churchdawn.ogg'
	converted_type = /area/rogue/outdoors/exposed/church
	deathsight_message = "一片圣地，誓奉独一者"
	first_time_text = "独一者之殿"

/area/rogue/under/dungeon/desert

/area/rogue/under/dungeon/bizbaz
	name = "奇异集市"
	icon_state = "under"
	first_time_text = "奇异集市"
	droning_sound = 'sound/music/area/desert/freedive_2.ogg'

/area/rogue/under/dungeon/desert_pyramid
	name = "金字塔"
	icon_state = "under"
	first_time_text = "古代陵墓"
	droning_sound = 'sound/music/area/tombs.ogg'

/area/rogue/under/underdesert
	name = "深地渊"
	icon_state = "cavewet"
	first_time_text = "深地渊"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 20,
				/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 25,
				/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15,
				/mob/living/simple_animal/hostile/retaliate/rogue/drider = 10,
	)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "葱郁隐蔽的深层"
	// detail_text = DETAIL_TEXT_UNDERDARK
//This version will use a different terraingen that spawns unhappy shrooms instead of happy shrooms, for scarier and eviler underdarks
