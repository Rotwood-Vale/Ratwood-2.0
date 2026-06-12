// Actual coastal coastal area
/area/rogue/outdoors/beach
	name = "中央海岸"
	icon_state = "beach"
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	droning_sound = 'sound/music/area/harbor.ogg'
	converted_type = /area/rogue/under/lake
	first_time_text = "中央海岸"
	deathsight_message = "一处风沙劲吹的海岸"
	detail_text = DETAIL_TEXT_ACTUAL_COAST

/area/rogue/outdoors/beach/harbor
	name = "港口"
	icon_state = "harbor"
	droning_sound = 'sound/music/area/harbor.ogg'
	first_time_text = "岩丘港"
	deathsight_message = "一座繁忙而风势强劲的港口"
	town_area = TRUE
	//warden_area = FALSE //eh it's probably fine

/area/rogue/outdoors/beach/north
	name = "北部海岸"
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/carbon/human/species/orc/npc/berserker = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 40
	)
	first_time_text = "北部海岸"

/area/rogue/outdoors/beach/south
	name = "南部海岸"
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 5,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 10,
		new /datum/ambush_config/triple_deepone = 30,
		new /datum/ambush_config/deepone_party = 20,
	)
	first_time_text = "南部海岸"
	detail_text = DETAIL_TEXT_CITY_COAST
