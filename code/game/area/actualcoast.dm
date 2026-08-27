// Actual coastal coastal area
/area/rogue/outdoors/beach
	name = "Central Coast"
	icon_state = "beach"
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
	droning_sound = 'sound/music/area/harbor.ogg'
	first_time_text = "Rockhill Harbor"
	deathsight_message = "a bustling, windswept harbor"
	town_area = TRUE
	//warden_area = FALSE //eh it's probably fine

/area/rogue/outdoors/beach/ocean
	name = "Sea of Yelman"
	icon_state = "yelmen"
	ambientsounds = AMB_ABISLAND
	ambientnight = AMB_ABISLAND
	droning_sound = 'sound/music/area/harbor.ogg'
	first_time_text = "The Sea of Yelmen"
	deathsight_message = "A rough and deep ocean"
	town_area = FALSE

/area/rogue/outdoors/beach/rockycoast
	name = "Coast of Rockhill"
	icon_state = "rocky"
	ambientsounds = AMB_ABISLAND
	ambientnight = AMB_ABISLAND
	droning_sound = 'sound/music/area/harbor.ogg'
	first_time_text = "The Coast of Rockhill"
	deathsight_message = "A rocky coast lapping at a rough sea"
	town_area = FALSE

/area/rogue/outdoors/beach/isleokbutan
	name = "Isle Okbutan"
	icon_state = "okbutan"
	ambientsounds = AMB_ABISLAND
	ambientnight = AMB_ABISLAND
	droning_sound = 'sound/music/area/harbor.ogg'
	first_time_text = "The Island of Okbutan"
	deathsight_message = "A long forgotten island in the far north of the Sea of Yelmen"
	town_area = FALSE

area/rogue/outdoors/beach/okbutanmanor
	name = "Manor on Okbutan"
	icon_state = "manorisle"
	droning_sound = list('sound/music/area/manor.ogg', 'sound/music/area/manor2.ogg')
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "The Manor on Isle Okbutan"
	deathsight_message = "A manor on the forgotten island of Okbutan"
	town_area = TRUE

area/rogue/outdoors/beach/mounteclisium
	name = "Mount Eclisium"
	icon_state = "eclesium"
	droning_sound = 'sound/music/area/prospector.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "The Volcano Mount Eclisium"
	deathsight_message = "A massive volcano on the island of Okbutan"
	town_area = FALSE

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
