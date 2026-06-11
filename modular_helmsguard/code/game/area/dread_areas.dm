/// DREADWOOD FOREST

/area/rogue/outdoors/dread
	icon = 'modular_helmsguard/icons/turf/dreadareas.dmi'

/area/rogue/indoors/dread
	icon = 'modular_helmsguard/icons/turf/dreadareas.dmi'

/area/rogue/outdoors/dread/dreadwoods
	name = "恐惧林"
	discover_sound = 'sound/misc/area_4.ogg'
	icon_state = "dreadwood"
	ambush_types = list(
				/turf/open/floor/rogue/dirt,
				/turf/open/floor/rogue/grass,
				/turf/open/water)
	ambush_mobs = list(
				/mob/living/carbon/human/species/skeleton/npc/ambush = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 60,
				/mob/living/simple_animal/hostile/retaliate/rogue/trollbog = 20,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 40,
				/mob/living/carbon/human/species/skeleton/npc/bogguard = 20,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 30)
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
	location_name = "恐惧林"
	first_time_text = "恐惧林"
	ambush_times = list("night","dawn","dusk","day")
	converted_type = /area/rogue/indoors/dread/shelter/dreadwoods

/area/rogue/indoors/dread/shelter/dreadwoods
	icon_state = "dreadwood"
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	location_name = "恐惧林某处"

/area/rogue/indoors/dread/church
	name = "古老教堂"
	first_time_text = "古老教堂"
	icon_state = "dreadchurch"
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	location_name = "恐惧林教堂"

/area/rogue/indoors/dread/toll
	name = "收费站"
	first_time_text = "收费站"
	icon_state = "tollhouse"
	droning_sound = null
	droning_sound_dusk = null
	droning_sound_night = null
	location_name = "恐惧林收费站"

/area/rogue/outdoors/dread/merc_spawn
	name = "佣兵出生点"
	icon_state = "mercenary_spawn"
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	location_name = "佣兵营地"


//NIGHTKEEP

/area/rogue/indoors/dread/nightkeep
	name = "雾望堡"
	icon_state = "nightkeep"
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	location_name = "雾望堡附近某处"

/area/rogue/outdoors/dread/nightkeep
	name = "雾望堡外部"
	first_time_text = "雾望堡"
	discover_sound = 'sound/misc/area_2.ogg'
	icon_state = "nightkeep_outside"
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	location_name = "雾望堡内某处"


///GOBLIN OUTPOST

/area/rogue/indoors/dread/gobcamp
	name = "地精营地"
	icon_state = "gobcamp"
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	location_name = "地精前哨站深处"

/area/rogue/outdoors/dread/gobcamp_outside
	name = "地精前哨站外部"
	first_time_text = "地精前哨站"
	discover_sound = 'sound/misc/area_3.ogg'
	icon_state = "nightkeep_outside"
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	location_name = "地精前哨站"

/area/rogue/indoors/dread/forgottenkeep
	name = "遗忘堡垒"
	icon_state = "forgottenkeep"
	first_time_text = "遗忘堡垒"
	discover_sound = 'sound/misc/area_2.ogg'
	droning_sound = 'sound/music/area/dreadwood.ogg'
	droning_sound_dusk = 'sound/music/area/dreadwood.ogg'
	droning_sound_night = 'sound/music/area/dreadwood_night.ogg'
	location_name = "遗忘堡垒深处"

// UNDERBOROUGH
/area/rogue/under/cavewet/dreadcave
	name = "地下通道"
	first_time_text = "地下通道"
	location_name = "地下通道某处"
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_GEN
