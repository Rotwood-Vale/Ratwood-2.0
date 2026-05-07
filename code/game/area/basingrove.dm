/area/rogue/outdoors/rtfield
	name = "Rotwood Basin"
	icon_state = "rtfield"
	soundenv = 19
	ambush_times = list("night")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/badger = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/raccoon = 25,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf/bobcat = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/fox = 15,
				/mob/living/carbon/human/species/skeleton/npc/supereasy = 30)
	first_time_text = "ROTWOOD BASIN"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter/rtfield
	deathsight_message = "somewhere in the wilds, next to towering walls"
	warden_area = TRUE
	threat_region = THREAT_REGION_AZURE_BASIN
	// detail_text = DETAIL_TEXT_AZURE_BASIN

/area/rogue/outdoors/rtfield/rockhill
	first_time_text = "Rockhill Basin"
	threat_region = THREAT_REGION_ROCKHILL_BASIN
	town_area = FALSE //might spread out the action a little if townies keep to town.

/area/rogue/outdoors/rtfield/rockhill/above
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	soundenv = 17

/area/rogue/indoors/shelter/rtfield
	icon_state = "rtfield"
	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/indoors/town/grove
	name = "druid's grove indoors"
	color = "#7e799c"
	icon_state = "druidgrove"
	droning_sound = 'sound/music/area/druid.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/forest.ogg'
	converted_type = /area/rogue/indoors/shelter/woods
	deathsight_message = "A sacred place of dendor, beneath the tree of Aeons.."
	first_time_text = "The Grove"
	warden_area = TRUE
	town_area = FALSE
	// detail_text = DETAIL_TEXT_DRUIDS_GROVE

/area/rogue/outdoors/town/grove
	name = "druid's grove"
	icon_state = "druidgrove"
	droning_sound = 'sound/music/area/druid.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	droning_sound_dawn = 'sound/music/area/forest.ogg'
	converted_type = /area/rogue/indoors/town/grove
	deathsight_message = "A sacred place of dendor, near the tree of Aeons.."
	first_time_text = "The Grove"
	droning_sound_dusk = null
	droning_sound_night = null
	warden_area = TRUE
	town_area = FALSE
	// detail_text = DETAIL_TEXT_DRUIDS_GROVE
