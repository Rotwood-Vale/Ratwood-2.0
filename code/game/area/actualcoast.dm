// Actual coastal coastal area
/area/rogue/outdoors/beach
	name = "Central Coast"
	icon_state = "beach"
	warden_area = TRUE
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	droning_sound = 'sound/music/area/harbor.ogg'
	converted_type = /area/rogue/under/lake
	first_time_text = "CENTRAL COAST"
	deathsight_message = "a windswept shore"
	detail_text = DETAIL_TEXT_ACTUAL_COAST

/area/rogue/outdoors/beach/harbor
	name = "harbor"
	icon_state = "harbor"
	warden_area = TRUE
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	ambush_times = null
	ambush_mobs = null
	droning_sound = 'sound/music/area/harbor.ogg'
	converted_type = /area/rogue/under/lake
	first_time_text = "Rockhill Harbor"

/area/rogue/outdoors/beach/north
	name = "Northern Coast"
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 10,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/carbon/human/species/orc/npc/berserker = 10,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 40
	)
	first_time_text = "NORTHERN COAST"

/area/rogue/outdoors/beach/south
	name = "Southern Coast"
	ambush_mobs = list(
		/mob/living/carbon/human/species/human/northern/searaider/ambush = 5,
		/mob/living/carbon/human/species/goblin/npc/ambush/sea = 20,
		/mob/living/simple_animal/hostile/retaliate/rogue/mossback = 10,
		new /datum/ambush_config/triple_deepone = 30,
		new /datum/ambush_config/deepone_party = 20,
	)
	first_time_text = "SOUTHERN COAST"
	detail_text = DETAIL_TEXT_CITY_COAST
