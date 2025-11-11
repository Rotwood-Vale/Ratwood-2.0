// Rotwood Vale - the areas to the south of the map

/area/rogue/outdoors/woodsrat
	name = "Rockhill Woods"
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
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush = 30,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30)
	first_time_text = "The Murderwood"
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere in the wilds"
	threat_region = THREAT_REGION_ROCKHILL_OUTER_GROVE

/area/rogue/indoors/shelter/woodsrat
	name = "Murderwood Shelter"
	icon_state = "woods"
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	threat_region = THREAT_REGION_ROCKHILL_OUTER_GROVE


/area/rogue/outdoors/woodsrat/north
	name = "Rockhill Woods - North"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/easy = 10,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 30,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 10,)
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere in the wilds"
	threat_region = THREAT_REGION_ROCKHILL_WOODS_NORTH

/area/rogue/outdoors/woodsrat/south
	name = "Rockhill Woods - South"
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 40,
		/mob/living/carbon/human/species/skeleton/npc/medium = 10,
		/mob/living/carbon/human/species/skeleton/npc/hard = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush = 30,
		/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll/axe = 2)
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "somewhere in the wilds"
	threat_region = THREAT_REGION_ROCKHILL_WOODS_SOUTH



/area/rogue/outdoors/woodsrat/above
	name = "Woods above"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

/area/rogue/outdoors/woodsrat/safe
	name = "Woods safe"
	first_time_text = null
	ambush_times = null
	ambush_mobs = null

/area/rogue/outdoors/woodsrat/river
	name = "river"
	icon_state = "river"
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_FOREST
