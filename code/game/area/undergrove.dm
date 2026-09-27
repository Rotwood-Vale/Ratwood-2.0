/area/rogue/under/cavewet
	name = "The Undergrove"
	icon_state = "cavewet"
	warden_area = TRUE
	first_time_text = "The Undergrove"
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
	converted_type = /area/rogue/outdoors/caves
	deathsight_message = "wet root-bound caverns"
	detail_text = DETAIL_TEXT_UNDERGROVE

/area/rogue/under/cavewet/bogcaves
	name = "The Undergrove"
	first_time_text = "The Undergrove"

/area/rogue/under/cavewet/bogcaves/west
	name = "Western Undergrove"
	first_time_text = "Western Undergrove"

/area/rogue/under/cavewet/bogcaves/central
	name = "Central Undergrove"
	first_time_text = "Central Undergrove"

/area/rogue/under/cavewet/bogcaves/camp
	name = "Undergrove Camp"
	first_time_text = "Undergrove Camp"
	detail_text = DETAIL_TEXT_UNDERGROVE_CAMP

/area/rogue/under/cavewet/bogcaves/south
	name = "Southern Undergrove"
	first_time_text = "Southern Undergrove"

/area/rogue/under/cavewet/bogcaves/north
	name = "Northern Undergrove"
	first_time_text = "Northern Undergrove"

/area/rogue/under/cavewet/bogcaves/coastcaves
	name = "South Coast Caves"
	first_time_text = "South Coast Caves"

/area/rogue/under/cave/goblindungeon
	name = "Goblin Camp"
	icon_state = "under"
	first_time_text = "GOBLIN CAMP"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "root-bound caverns"
	detail_text = DETAIL_TEXT_GOBLIN_CAMP

/area/rogue/under/cave/skeletoncrypt
	name = "Skeleton Crypt"
	icon_state = "under"
	first_time_text = "SKELETON CRYPT"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	deathsight_message = "root-bound caverns"
	detail_text = DETAIL_TEXT_SKELETON_CRYPT

/**
 * Cave river, heard through the parent's AMB_CAVEWATER alone.
 *
 * No ambientsounds of its own: AMB_RIVERDAY and AMB_RIVERNIGHT are surface recordings, birds
 * included. /area/rogue/under sets river_ambience = FALSE, so the river turfs here register no point
 * sources either. Point sources would attenuate where the area layer does not, but would need a
 * category of their own carrying cave water, since the clip set lives on the category and the
 * surface one is wrong down here. Not worth a category and a channel for a sound the area layer
 * already covers.
 */
/area/rogue/under/cavewet/river
	name = "Cave River"
	icon_state = "river"
	first_time_text = null
