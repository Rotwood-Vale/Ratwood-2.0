/area/rogue/under/dungeon
	name = "dungeon"
	// warden_area = TRUE
	icon_state = "basement"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/catacombs.ogg'
	// droning_sound_dusk = null
	// droning_sound_night = null
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

/area/rogue/under/dungeon/sunkenchurch
	name = "Sunken Church"
	icon_state = "sunkenz"
	droning_sound = 'sound/music/area/scroll_of_nihilism.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "a dark and terrible corrupted place of worship, deep within death and murk"
	detail_text = DETAIL_TEXT_SUNKEN_CHURCH

/area/rogue/under/dungeon/tricksntraps
	name = "Tricky Dungeon"
	icon_state = "sunkenz"
	droning_sound = 'sound/music/area/scroll_of_nihilism.ogg'
	// droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "A swampy stone hideout, hidden many times over"
	// detail_text = DETAIL_TEXT_SUNKEN_CHURCH
