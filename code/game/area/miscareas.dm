// Misc Areas for things I cannot be bothered to categorize elsewhere
/area/rogue/outdoors/abisland
	name = "阿比索尔之握"
	icon_state = "island"
	ambientsounds = AMB_ABISLAND
	ambientnight = AMB_ABISLAND
	droning_sound = 'sound/music/area/morosewaters.ogg'
	droning_sound_dusk = 'sound/music/area/morosewaters.ogg'
	droning_sound_night = 'sound/music/area/angrywaters.ogg'
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/rogue/deepone = 50,
		/mob/living/simple_animal/hostile/rogue/deepone/spit = 30
	)
	first_time_text = "阿比索尔之握"
	deathsight_message = "身处阿比索尔之握中"
	detail_text = DETAIL_TEXT_ABYSSORS_GRASP
