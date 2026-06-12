/area/rogue/outdoors/jungle
	name = "恐惧丛林"
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
	first_time_text = "恐惧丛林"
	converted_type = /area/rogue/indoors/shelter/jungle
	threat_region = THREAT_REGION_JUNGLE
	deathsight_message = "一片闷热难耐的凄惨丛林"
	// detail_text = DETAIL_TEXT_TERRORBOG

/area/rogue/indoors/shelter/jungle
	icon_state = "bog"
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "一片闷热难耐的凄惨丛林"


/area/rogue/outdoors/byos
	name = "新王田荒野"
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
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/rtfield
	deathsight_message = "新王田殖民地的郊野，以及那里熙攘往来的众生"
	threat_region = THREAT_REGION_ISLAND
	detail_text = THREAT_REGION_ISLAND

/area/rogue/outdoors/town/byos
	icon_state = "town"
	first_time_text = "新王田殖民地"
	town_area = TRUE
	deathsight_message = "新王田殖民地，以及那里熙攘往来的众生"
	threat_region = THREAT_REGION_ISLAND
	detail_text = THREAT_REGION_ISLAND
	ambush_times = list("night")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/fox = 30,
				/mob/living/carbon/human/species/skeleton/npc/supereasy = 30)
	
// /area/rogue/outdoors/jungle/west
// 	name = "Eastern Dread-Jungle"

// /area/rogue/outdoors/jungle/east
// 	name = "Western Dread-Jungle"

/area/rogue/indoors/banditcamp/byos
	name = "海盗船"
	// droning_sound = 'sound/music/area/banditcamp.ogg'
	// droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	// droning_sound_night = 'sound/music/area/banditcamp.ogg'
	deathsight_message = "一处藏满贪婪秘密的隐秘海湾"

// /area/rogue/outdoors/banditcamp/byos
// 	name = "Pirate's Cove"
// 	// droning_sound = 'sound/music/area/banditcamp.ogg'
// 	// droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
// 	// droning_sound_night = 'sound/music/area/banditcamp.ogg'
// 	first_time_text = "A Gathering of Thieves"
// 	deathsight_message = "a hidden cove of greedy secrets"


/area/rogue/under/cavewet/byos
	name = "地下林泽"
	icon_state = "cavewet"
	// first_time_text = "The Undergrove"
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/carbon/human/species/skeleton/npc/easy = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30,
				/mob/living/carbon/human/species/goblin/npc/sea = 20,
				/mob/living/carbon/human/species/human/northern/highwayman/ambush = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/troll = 15)
	// converted_type = /area/rogue/outdoors/caves
	deathsight_message = "被盐水浸透的洞窟"
	// detail_text = DETAIL_TEXT_UNDERGROVE

	
/area/rogue/under/cavewet/byos/banditcove
	first_time_text = "盗贼聚所"
	deathsight_message = "一处藏满贪婪秘密的隐秘海湾"
	droning_sound = 'sound/music/area/banditcamp.ogg'
	droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	droning_sound_night = 'sound/music/area/banditcamp.ogg'
	ambush_times = null


/area/rogue/indoors/inq/boat
	name = "纯净号"
	icon_state = "chapel"
	first_time_text = "纯净号"
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT

/area/rogue/indoors/inq/boat/office
	name = "审判官办公室"
	icon_state = "chapel"
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT

/area/rogue/indoors/inq/boat/basement
	name = "宗教裁判所地下室"
	icon_state = "chapel"
	ceiling_protected = TRUE
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BOAT
	ambientnight = AMB_BOAT

/area/rogue/outdoors/beach/byos
	name = "岛屿海岸"
	icon_state = "beach"
	first_time_text = null
	deathsight_message = "一片带着咸腥气的海岸"
	detail_text = null
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 30,
		new /datum/ambush_config/triple_deepone = 20,
		new /datum/ambush_config/deepone_party = 10,
	)

/area/rogue/under/cave/tribeden
	name = "部族藏身处"
	icon_state = "under"
	first_time_text = "古老营地"
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	droning_sound = 'sound/music/area/gobcamp.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE
	deathsight_message = "一座隐秘堡垒"
