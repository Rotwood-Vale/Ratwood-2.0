/area/rogue/outdoors/bog
	name = "恐惧沼泽"
	icon_state = "bog"
	ambientsounds = AMB_BOGDAY
	ambientnight = AMB_BOGNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	//Minotaurs too strong for the lazy amount of places this area covers
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 40,
				/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30,
				new /datum/ambush_config/bog_guard_deserters = 50,		
				new /datum/ambush_config/bog_guard_deserters/hard = 25,
				new /datum/ambush_config/mirespiders_ambush = 110,
				new /datum/ambush_config/mirespiders_crawlers = 25,
				new /datum/ambush_config/mirespiders_aragn = 10,
				new /datum/ambush_config/mirespiders_unfair = 5)
	first_time_text = "恐惧沼泽"
	converted_type = /area/rogue/indoors/shelter/bog
	threat_region = THREAT_REGION_TERRORBOG
	deathsight_message = "一片腐臭难闻的凄惨沼泽"
	detail_text = DETAIL_TEXT_TERRORBOG

/area/rogue/indoors/shelter/bog
	// icon_state = "indoors"
	// droning_sound = 'sound/music/area/bog.ogg'//nice to have it sound different indoors than out, gives a nice instant feedback
	// droning_sound_dusk = null
	// droning_sound_night = null
	deathsight_message = "一片腐臭难闻的凄惨沼泽"

/area/rogue/outdoors/bog/north
	name = "北部恐惧沼泽"

/area/rogue/outdoors/bog/south
	name = "南部恐惧沼泽"
