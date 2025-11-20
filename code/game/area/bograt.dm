//bog for rockhill - milder spawns than in dunworld

/area/rogue/outdoors/bograt
	name = "Rockhill Bog"
	icon_state = "bog"
	warden_area = TRUE
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
	first_time_text = "THE TERRORBOG"
	converted_type = /area/rogue/indoors/shelter/bograt
	deathsight_message = "a wretched, fetid bog"
	threat_region = THREAT_REGION_ROCKHILL_BOG_NORTH

/area/rogue/indoors/shelter/bograt
	name = "Rockhill Bog"
	icon_state = "bog"
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/outdoors/bograt/north
	name = "Northern Terrorbog"
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
	
/area/rogue/outdoors/bograt/south
	name = "Southern Terrorbog"
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

/area/rogue/outdoors/bograt/west
	name = "Western Terrorbog"
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
	
/area/rogue/outdoors/bograt/sunken
	name = "Sunken Mire"
	first_time_text = "THE SUNKEN MIRE"
	threat_region = THREAT_REGION_ROCKHILL_BOG_WEST
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/rock = 40,
		/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
		/mob/living/carbon/human/species/skeleton/npc/rockhill = 15,
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 15,
		new /datum/ambush_config/mirespiders_ambush = 110,
		new /datum/ambush_config/mirespiders_crawlers = 25,
		new /datum/ambush_config/mirespiders_aragn = 10,
		new /datum/ambush_config/mirespiders_unfair = 5)

/area/rogue/outdoors/bograt/safe
	name = "Terrorbog Pass"
	ambush_times = null
	ambush_mobs = null

/area/rogue/outdoors/bograt/above
	name = "Terrorbog Above"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null
