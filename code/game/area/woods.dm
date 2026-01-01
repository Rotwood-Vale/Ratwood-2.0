// Rotwood Vale - the areas to the south of the map

/area/rogue/outdoors/woods
	name = "The Vale"
	icon_state = "woods"
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	soundenv = 15
	warden_area = TRUE
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush = 30,
				/mob/living/carbon/human/species/human/northern/militia/deserter = 20,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 10)
	first_time_text = "THE VALE"
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere in the wilds"
	threat_region = THREAT_REGION_AZURE_GROVE
	detail_text = DETAIL_TEXT_AZURE_GROVE

/area/rogue/indoors/shelter/woods
	name = "Rotwood Vale"
	icon_state = "woods"
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	threat_region = THREAT_REGION_AZURE_GROVE
	deathsight_message = "somewhere in the wilds"

/area/rogue/outdoors/woods/north
	name = "Rotwood Vale - North"
	// This section shouldn't have any sea mobs, but is close to the old warden tower
	// So should be relatively easy
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 20,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/woods/northeast
	name = "Rotwood Vale - Northeast"
	// Ambush list here is "easier" with some pirates mob, possibility of sea goblin
	ambush_mobs = list(
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
			/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
			/mob/living/carbon/human/species/skeleton/npc/easy = 10,
			/mob/living/carbon/human/species/skeleton/npc/pirate = 10,
			/mob/living/carbon/human/species/goblin/npc/ambush = 20,
			/mob/living/carbon/human/species/goblin/npc/sea = 10,
			/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
	threat_region = THREAT_REGION_AZURE_GROVE

/area/rogue/outdoors/woods/southeast
	name = "Rotwood Vale - Southeast"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 10,
		/mob/living/carbon/human/species/skeleton/npc/pirate = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 20,
		/mob/living/carbon/human/species/goblin/npc/sea = 10,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)

/area/rogue/outdoors/woods/south
	name = "Rotwood Vale - South"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)

/area/rogue/outdoors/woods/southwest
	name = "Rotwood Vale - Southwest"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)

/area/rogue/outdoors/woods/northwest
	name = "Rotwood Vale - Northwest"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20)

/area/rogue/outdoors/woods/above //to hear the wind whistle throught the trees
	name = "Woods above"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN

/area/rogue/outdoors/woods/vampire_lair
	warden_area = FALSE
	ambush_times = list()
	ambush_mobs = null
	threat_region = ""
