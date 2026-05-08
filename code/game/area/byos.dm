/area/rogue/outdoors/jungle
	name = "The Jungle of Dread"
	icon_state = "bog"
	warden_area = TRUE
	ambientsounds = AMB_BOGDAY
	ambientnight = AMB_BOGNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/byos/bog_day.ogg'
	droning_sound_dawn = 'sound/music/area/byos/bog_day.ogg'
	droning_sound_dusk = 'sound/music/area/byos/bog_night.ogg'
	droning_sound_dusk = 'sound/music/area/byos/bog_night.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 40,
				/mob/living/carbon/human/species/npc/deadite = 20,
				/mob/living/carbon/human/species/skeleton/npc/hardspread = 40,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur/axe = 15,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30,
				new /datum/ambush_config/mirespiders_ambush = 110,
				new /datum/ambush_config/mirespiders_crawlers = 25,
				new /datum/ambush_config/mirespiders_aragn = 10,
				new /datum/ambush_config/mirespiders_unfair = 5)
	first_time_text = "THE DREAD JUNGLE"
	converted_type = /area/rogue/indoors/shelter/jungle
	threat_region = THREAT_REGION_JUNGLE
	deathsight_message = "a wretched, sweltering jungle"
	// detail_text = DETAIL_TEXT_TERRORBOG

/area/rogue/indoors/shelter/jungle
	icon_state = "bog"
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "a wretched, sweltering jungle"


/area/rogue/outdoors/byos
	name = "New-Kingsfield wilderness"
	first_time_text = null
	town_area = TRUE
	icon_state = "rtfield"
	soundenv = 19
	ambush_times = list("night")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/fox = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll/bog = 5,
				/mob/living/carbon/human/species/npc/deadite = 5,
				/mob/living/carbon/human/species/skeleton/npc/supereasy = 10,
				/mob/living/carbon/human/species/skeleton/npc/pirate = 30)
	droning_sound = 'sound/music/area/byos/outskirts.ogg'
	droning_sound_dawn = 'sound/music/area/byos/outskirts.ogg'
	droning_sound_dusk = 'sound/music/area/byos/outskirts_night.ogg'
	droning_sound_night = 'sound/music/area/byos/outskirts_night.ogg'
	converted_type = /area/rogue/indoors/shelter/rtfield
	deathsight_message = "the outskirts of the colony of New Kingsfield and all its bustling souls"
	warden_area = TRUE
	threat_region = THREAT_REGION_ISLAND
	detail_text = THREAT_REGION_ISLAND

/area/rogue/outdoors/town/byos
	icon_state = "town"
	first_time_text = "The Colony of New Kingsfield"
	town_area = TRUE
	deathsight_message = "the colony of New Kingsfield and all its bustling souls"
	threat_region = THREAT_REGION_ISLAND
	detail_text = THREAT_REGION_ISLAND
	ambush_times = list("night")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 15,
				/mob/living/simple_animal/hostile/retaliate/rogue/fox = 15,
				/mob/living/carbon/human/species/skeleton/npc/supereasy = 15)
	droning_sound = 'sound/music/area/byos/settlement_day.ogg'
	droning_sound_night = 'sound/music/area/byos/settlement_night.ogg'
	droning_sound_dusk = 'sound/music/area/byos/settlement_night.ogg'
	droning_sound_dawn = 'sound/music/area/byos/settlement_day.ogg'
// 	name = "Eastern Dread-Jungle"

// /area/rogue/outdoors/jungle/east
// 	name = "Western Dread-Jungle"

/area/rogue/indoors/banditcamp/byos
	name = "Pirate's Ship"
	// droning_sound = 'sound/music/area/banditcamp.ogg'
	// droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	// droning_sound_night = 'sound/music/area/banditcamp.ogg'
	deathsight_message = "a hidden cove of greedy secrets"

// /area/rogue/outdoors/banditcamp/byos
// 	name = "Pirate's Cove"
// 	// droning_sound = 'sound/music/area/banditcamp.ogg'
// 	// droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
// 	// droning_sound_night = 'sound/music/area/banditcamp.ogg'
// 	first_time_text = "A Gathering of Thieves"
// 	deathsight_message = "a hidden cove of greedy secrets"


/area/rogue/under/cavewet/byos
	name = "The Undergrove"
	icon_state = "cavewet"
	warden_area = TRUE
	// first_time_text = "The Undergrove"
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
	// converted_type = /area/rogue/outdoors/caves
	deathsight_message = "salt-soaked caverns"
	// detail_text = DETAIL_TEXT_UNDERGROVE

	
/area/rogue/under/cavewet/byos/banditcove
	first_time_text = "A Gathering of Thieves"
	deathsight_message = "a hidden cove of greedy secrets"
	droning_sound = 'sound/music/area/banditcamp.ogg'
	droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	droning_sound_night = 'sound/music/area/banditcamp.ogg'
	ambush_times = null


/area/rogue/indoors/inq/boat
	name = "The Purity"
	icon_state = "chapel"
	first_time_text = "THE PURITY"
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT

/area/rogue/indoors/inq/boat/office
	name = "The Inquisitor's Office"
	icon_state = "chapel"
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT

/area/rogue/indoors/inq/boat/basement
	name = "The Inquisition's Basement"
	icon_state = "chapel"
	ceiling_protected = TRUE
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT

/area/rogue/outdoors/beach/byos
	name = "Island Coast"
	icon_state = "beach"
	warden_area = TRUE
	ambientsounds = AMB_ABISLAND
	ambientnight = AMB_ABISLAND
	droning_sound = 'sound/music/area/morosewaters.ogg'
	droning_sound_dusk = 'sound/music/area/morosewaters.ogg'
	droning_sound_night = 'sound/music/area/byos/beach_night.ogg'
	converted_type = /area/rogue/under/lake
	first_time_text = null
	deathsight_message = "a brackish shore"
	detail_text = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 30,
		new /datum/ambush_config/triple_deepone = 20,
		new /datum/ambush_config/deepone_party = 10,
	)

/area/rogue/under/cavelava/byos/volcanic
	name = "The Crater"
	first_time_text = null
	icon_state = "cavelava"
	ambientsounds = AMB_CAVELAVA
	droning_sound = 'sound/music/area/byos/volcano.ogg'
	deathsight_message = "A fiery crater"

/area/rogue/under/cave/tribeden
	name = "tribal hideout"
	icon_state = "tribal"
	first_time_text = "Ancient Encampment"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	droning_sound = 'sound/music/area/gobcamp.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE
	deathsight_message = "A hidden fortress"

/area/rogue/indoors/byos/ship
	name = "The Ship"
	icon_state = "ship"
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT
	droning_sound = 'sound/music/area/byos/ship.ogg'
	droning_sound_dawn = 'sound/music/area/byos/ship.ogg'
	deathsight_message = "A large ship"
	ambush_mobs = null
	ambush_times = null
	detail_text = null
	threat_region = null

/area/rogue/outdoors/byos/ship
	name = "The Ship"
	icon_state = "ship"
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT
	droning_sound = 'sound/music/area/byos/ship.ogg'
	droning_sound_dawn = 'sound/music/area/byos/ship.ogg'
	deathsight_message = "A large ship"

/area/rogue/indoors/town/manor/byos
	name = "The Ruined Keep"
	icon_state = "manor"
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/music/area/byos/keep.ogg'
	deathsight_message = "A crumbling keep"

/area/rogue/under/cave/byos/wiztower
	name = "The Wizard's Tower"
	icon_state = "magician"
	ambientsounds = AMB_CAVEWATER
	droning_sound = 'sound/music/area/byos/abandoned_magic.ogg'
	deathsight_message = "A crumbling arcyne tower"


/// Key dungeon areas
/area/rogue/under/cave/byos/pride
	name = "Pride"
	icon_state = "pride"
	ambientsounds = AMB_CAVELAVA
	droning_sound = 'sound/music/area/byos/pride.ogg'
	deathsight_message = "A prideful tower"

/area/rogue/under/cave/byos/envy
	name = "Envy"
	icon_state = "envy"
	ambientsounds = AMB_GENCAVE
	droning_sound = 'sound/music/area/byos/envy.ogg'
	deathsight_message = "An envious spider's lair"

/area/rogue/under/cave/byos/wrath
	name = "Wrath"
	icon_state = "wrath"
	ambientsounds = AMB_CAVELAVA
	droning_sound = 'sound/music/area/inferno.ogg'
	deathsight_message = "A wrathful prison"

/area/rogue/under/cave/byos/lust
	name = "Lust"
	icon_state = "lust"
	ambientsounds = AMB_CAVEWATER
	droning_sound = 'sound/music/area/byos/lust.ogg'
	deathsight_message = "A lustful goblin camp"

/area/rogue/under/cave/byos/gluttony
	name = "Gluttony"
	icon_state = "gluttony"
	ambientsounds = AMB_CAVEWATER
	droning_sound = 'sound/music/area/byos/gluttony.ogg'
	deathsight_message = "A gluttonous feeding ground"

/area/rogue/under/cave/byos/greed
	name = "Greed"
	icon_state = "greed"
	ambientsounds = AMB_GENCAVE
	droning_sound = 'sound/music/area/byos/greed.ogg'
	deathsight_message = "A greedy king's maze"

/area/rogue/under/cave/byos/sloth
	name = "Sloth"
	icon_state = "sloth"
	ambientsounds = AMB_CAVEWATER
	droning_sound = 'sound/music/area/byos/sloth.ogg'
	deathsight_message = "A slothful den"
