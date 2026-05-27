/area/rogue/outdoors/kingsfield
	name = "Kingsfield"
	icon_state = "town"
	holy_area = TRUE
	converted_type = /area/rogue/indoors/kingsfield
	first_time_text = "KINGSFIELD"

/area/rogue/outdoors/kingsfield/garden_district
	name = "kingsfield garden district"
	holy_area = TRUE
	first_time_text = "KINGSFIELD - GARDEN DISTRICT"

/area/rogue/outdoors/kingsfield/diplomatic_quarter
	name = "kingsfield diplomatic quarter"
	holy_area = TRUE
	first_time_text = "KINGSFIELD - DIPLOMATIC QUARTER"

/area/rogue/outdoors/kingsfield/roofs
	name = "kingsfield roofs"
	icon_state = "roofs"
	holy_area = TRUE
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	converted_type = /area/rogue/indoors/shelter/kingsfield/roofs
	first_time_text = "KINGSFIELD ROOFS"

/area/rogue/indoors/shelter/kingsfield/roofs
	icon_state = "roofs"
	holy_area = TRUE

/area/rogue/indoors/kingsfield
	name = "Kingsfield"
	icon_state = "town"
	holy_area = TRUE
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/outdoors/kingsfield
	first_time_text = "KINGSFIELD"

/area/rogue/indoors/kingsfield/tavern
	name = "Kingsfield Tavern"
	icon_state = "tavern"
	holy_area = TRUE
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	droning_sound = 'sound/silence.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "KINGSFIELD TAVERN"

/area/rogue/indoors/kingsfield/ferentian_hq
	name = "Ferentian Diplomatic Headquarters"
	holy_area = TRUE
	first_time_text = "FERENTIAN DIPLOMATIC HEADQUARTERS"

/area/rogue/under/kingsfield
	name = "Kingsfield Under"
	icon_state = "under"
	holy_area = TRUE
	converted_type = /area/rogue/outdoors/exposed/under
	first_time_text = "KINGSFIELD UNDER"

/area/rogue/under/kingsfield/depths
	name = "Kingsfield Depths"
	icon_state = "basement"
	holy_area = TRUE
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "KINGSFIELD DEPTHS"

/area/rogue/under/kingsfield/arena
	name = "Kingsfield Arena"
	icon_state = "basement"
	holy_area = TRUE
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	pacifismOff = TRUE
	first_time_text = "KINGSFIELD ARENA"

/area/rogue/under/kingsfield/gutter
	name = "The Gutter"
	icon_state = "basement"
	holy_area = TRUE
	ambientsounds = AMB_BASEMENT
	ambientnight = AMB_BASEMENT
	spookysounds = SPOOKY_DUNGEON
	spookynight = SPOOKY_DUNGEON
	droning_sound = 'sound/music/area/catacombs.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	soundproof = TRUE
	first_time_text = "THE GUTTER"
