/area/rogue/under/dungeon
	name = "dungeon"
	// warden_area = TRUE
	icon_state = "basement"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE
	// ambush_times = list("night","dawn","dusk","day")
	// ambush_mobs = list(
	// 			/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
	// 			/mob/living/carbon/human/species/goblin/npc/ambush/cave = 20,
	// 			/mob/living/carbon/human/species/skeleton/npc/ambush = 10,
	// 			/mob/living/carbon/human/species/human/northern/highwayman/ambush = 5,
	// 			/mob/living/simple_animal/hostile/retaliate/rogue/direbear = 5,
	// 			/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 5)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "A dwelling deep below, a dark recess beyond and beneath."
	ceiling_protected = TRUE

/area/rogue/under/dungeon/sunkenchurch
	name = "Sunken Church"
	icon_state = "sunkenz"
	droning_sound = 'sound/music/area/scroll_of_nihilism.ogg'
	deathsight_message = "a dark and terrible corrupted place of worship, deep within death and murk"
	detail_text = DETAIL_TEXT_SUNKEN_CHURCH

/area/rogue/under/dungeon/tricksntraps
	name = "Tricky Dungeon"
	icon_state = "sunkenz"
	droning_sound = 'sound/music/area/scroll_of_nihilism.ogg'
	deathsight_message = "A swampy stone hideout, hidden many times over."

/area/rogue/under/dungeon/wizarddungeon
	name = "Abandoned Wizard Tower"
	first_time_text = "Crumbling Magician's Tower"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/abandonedwizartorium.ogg'
	deathsight_message = "Where great minds created even greater mistakes."

/area/rogue/under/dungeon/drowfort
	name = "Drow Outpost"
	droning_sound = 'sound/music/area/underdark.ogg'
	deathsight_message = "A deep, dark house of pain and dominance."

/area/rogue/under/dungeon/oldgoblincamp
	name = "goblin encampment"
	first_time_text = "Lost Encampment"
	droning_sound = 'sound/music/area/gobcamp.ogg'
	deathsight_message = "A hidden goblin-stained fortress"

/area/rogue/under/dungeon/inferno
	name = "inferno"
	icon_state = "fire_chamber"
	first_time_text = "Another Place"
	ambientsounds = AMB_CAVELAVA
	ambientnight = AMB_CAVELAVA
	droning_sound = 'sound/music/area/inferno.ogg'
	deathsight_message = "A blistering realm beyond this mortal sphere"
