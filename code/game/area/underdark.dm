/area/rogue/under/underdark
	name = "中央幽暗地域" // Northern is Sunken City
	icon_state = "cavewet"
	warden_area = FALSE
	first_time_text = "幽暗地域" // This is where most people will enter Underdark
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 20,
				/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 25,
				/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15,
				/mob/living/simple_animal/hostile/retaliate/rogue/drider = 10,
	)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "一片被酸蚀侵蚀的深层地带"
	detail_text = DETAIL_TEXT_UNDERDARK

/area/rogue/under/underdark/south
	name = "南部幽暗地域"
	first_time_text = "南部幽暗地域"
	detail_text = DETAIL_TEXT_SOUTHERN_UNDERDARK

/area/rogue/under/underdark/north
	name = "熔毁地下城"
	first_time_text = "熔毁地下城"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	detail_text = DETAIL_TEXT_MELTED_UNDERCITY

/area/rogue/under/underdark/rockhill
	name = "中央幽暗地域"
	first_time_text = "幽深地渊"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	ambush_mobs = list(
		/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/spider = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/mole = 15,
		/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 15,
		/mob/living/carbon/human/species/goblin/npc/ambush/moon = 40,
		/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15)
	deathsight_message = "深邃黑暗、长满蘑菇的洞窟"
	
/area/rogue/under/underdark/rockhill/east
	name = "东部幽暗地域"

/area/rogue/under/underdark/rockhill/west
	name = "西部幽暗地域"

/area/rogue/under/underdarker
	name = "中央幽暗地域" // Northern is Sunken City
	icon_state = "cavewet"
	warden_area = FALSE
	first_time_text = "幽暗地域" // This is where most people will enter Underdark
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 20,
				/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 25,
				/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15,
				/mob/living/simple_animal/hostile/retaliate/rogue/drider = 10,
	)
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "一片被酸蚀侵蚀的深层地带"
	detail_text = DETAIL_TEXT_UNDERDARK
//This version will use a different terraingen that spawns unhappy shrooms instead of happy shrooms, for scarier and eviler underdarks

/area/rogue/under/underdarker/dunsouth
	name = "南部幽暗地域"
	first_time_text = "南部幽暗地域"
	detail_text = DETAIL_TEXT_SOUTHERN_UNDERDARK

/area/rogue/under/underdarker/rockhill
	name = "东部幽暗地域"
	first_time_text = "恐惧深渊"
	spookysounds = SPOOKY_MYSTICAL
	spookynight = SPOOKY_MYSTICAL
	droning_sound = 'sound/music/area/underdark.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/spider/mutated = 20,
				/mob/living/carbon/human/species/elf/dark/drowraider/ambush = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 25,
				/mob/living/carbon/human/species/goblin/npc/ambush/moon = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15,
				/mob/living/simple_animal/hostile/retaliate/rogue/drider = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/ooze_blob = 20
	)
	deathsight_message = "深邃黑暗、长满蘑菇的洞窟"
