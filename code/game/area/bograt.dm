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
	warden_area = TRUE
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/carbon/human/species/skeleton/npc/ambush = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 60,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 40,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 50,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
				/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,
				new /datum/ambush_config/bog_guard_deserters = 15,
				new /datum/ambush_config/bog_guard_deserters/hard = 2,
				new /datum/ambush_config/mirespiders_ambush = 30,
				new /datum/ambush_config/mirespiders_crawlers = 15,
				new /datum/ambush_config/mirespiders_aragn = 5,
				new /datum/ambush_config/mirespiders_unfair = 1)
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
	threat_region = THREAT_REGION_ROCKHILL_BOG_NORTH

/area/rogue/outdoors/bograt/north
	name = "Northern Terrorbog"
	ambush_mobs = list(
			/mob/living/carbon/human/species/skeleton/npc/ambush = 20,
			/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 60,
			/mob/living/simple_animal/hostile/retaliate/rogue/spider = 30,
			/mob/living/carbon/human/species/goblin/npc/ambush/cave = 50,
			/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 15,
			/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 20,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf_undead = 10,)
			
	threat_region = THREAT_REGION_ROCKHILL_BOG_NORTH

/area/rogue/outdoors/bograt/east
	name = "Eastern Terrorbog"
	threat_region = THREAT_REGION_ROCKHILL_BOG_EAST
	
/area/rogue/outdoors/bograt/south
	name = "Southern Terrorbog"
	threat_region = THREAT_REGION_ROCKHILL_BOG_SOUTH

/area/rogue/outdoors/bograt/west
	name = "Western Terrorbog"
	threat_region = THREAT_REGION_ROCKHILL_BOG_WEST

/area/rogue/outdoors/bograt/safe
	name = "Terrorbog Pass"
	ambush_times = list()
