//bog for rockhill - milder spawns than in dunworld

/area/rogue/outdoors/bograt
	name = "岩丘沼泽"
	icon_state = "bog"
	ambientsounds = AMB_BOGDAY
	ambientnight = AMB_BOGNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
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
	first_time_text = "恐惧沼泽"
	converted_type = /area/rogue/indoors/shelter/bog
	deathsight_message = "一片腐臭难闻的凄惨沼泽"
	threat_region = THREAT_REGION_ROCKHILL_BOG_NORTH

// /area/rogue/indoors/shelter/bograt//can just share the normal shelter
// 	name = "Rockhill Bog"
// 	icon_state = "bog"
// 	// droning_sound = 'sound/music/area/bog.ogg'//nice to have it sound different indoors than out, gives a nice instant feedback
// 	droning_sound_dusk = null
// 	droning_sound_night = null
// 	deathsight_message = "a wretched, fetid bog"
// 	warden_area = TRUE

/area/rogue/outdoors/bograt/north
	name = "北部恐惧沼泽"
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

	threat_region = THREAT_REGION_ROCKHILL_BOG_NORTH
	deathsight_message = "一片连通文明地带与腐臭恶沼的积水泥潭"

/area/rogue/outdoors/bograt/south
	name = "中央恐惧沼泽"
	threat_region = THREAT_REGION_ROCKHILL_BOG_SOUTH
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/ambush = 30,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 40,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 40,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 50,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,
		new /datum/ambush_config/bog_guard_deserters = 15,
		new /datum/ambush_config/bog_guard_deserters/hard = 2,
		new /datum/ambush_config/mirespiders_ambush = 30,
		new /datum/ambush_config/mirespiders_crawlers = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 10,)
	deathsight_message = "恶沼深处，既有古老魔法，也回荡着齐佐祈祷"

/area/rogue/outdoors/bograt/west
	name = "西部恐惧沼泽"
	first_time_text = "恐惧泥沼"
	threat_region = THREAT_REGION_ROCKHILL_BOG_WEST
	ambush_mobs = list(
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 5,
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 5,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 30,
		new /datum/ambush_config/triple_deepone = 30,
		new /datum/ambush_config/deepone_party = 20,)
	deathsight_message = "朝向落日方向的可怖泥沼"

/area/rogue/outdoors/bograt/sunken
	name = "诅咒泥沼"
	first_time_text = "诅咒泥沼"
	threat_region = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 30,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/carbon/human/species/npc/deadite = 30,
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 15,
		new /datum/ambush_config/mirespiders_ambush = 110,
		new /datum/ambush_config/mirespiders_crawlers = 25,
		new /datum/ambush_config/mirespiders_aragn = 10,
		new /datum/ambush_config/mirespiders_unfair = 5)
	deathsight_message = "泥沼最深之处，既深陷难行，也危机四伏"

/area/rogue/outdoors/bograt/safe
	name = "恐惧沼泽关道"
	ambush_times = null
	ambush_mobs = null
	deathsight_message = "一条遥远陌生的关道，通往那片腐臭沼泽"

/area/rogue/outdoors/bograt/above
	name = "恐惧沼泽高地"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

//Making it a separate type and not a subtype makes it play nicer with the terrain generator
/area/rogue/outdoors/bogsafe
	name = "恐惧沼泽关道"
	ambush_times = null
	ambush_mobs = null
	deathsight_message = "一条遥远陌生的关道，通往那片腐臭沼泽"
	icon_state = "bog"
	ambientsounds = AMB_BOGDAY
	ambientnight = AMB_BOGNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/indoors/shelter/bog
