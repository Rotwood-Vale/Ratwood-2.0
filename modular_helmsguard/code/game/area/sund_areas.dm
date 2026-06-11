// Sundmark Areas

/area/rogue/indoors/sund
	name = "桑德马克"
	location_name = "远方"	// Should only occur as a fail condition if child objects lack more specific locations names, or areas are meant to be secret.
	icon = 'modular_helmsguard/icons/turf/sund_areas.dmi'	// Redirect to the modular icons.
	icon_state = "rogue"

/area/rogue/outdoors/sund
	name = "桑德马克"
	location_name = "远方"	// Should only occur as a fail condition if child objects lack more specific locations names, or areas are meant to be secret.
	icon = 'modular_helmsguard/icons/turf/sund_areas.dmi'	// Redirect to the modular icons.
	icon_state = "rogue"

/*	These are all inherited  from the parent /rogue. Leaving in comments as a reference.

	has_gravity = STANDARD_GRAVITY
	ambientsounds = null
	always_unpowered = TRUE
	poweralm = FALSE
	power_environ = TRUE
	power_equip = TRUE
	power_light = TRUE
	dynamic_lighting = DYNAMIC_LIGHTING_FORCED
	requires_power = FALSE
//	var/previous_ambient = ""
	var/town_area = FALSE
	var/keep_area = FALSE
	var/warden_area = FALSE
	var/ceiling_protected = FALSE //Prevents tunneling into these from above
*/


/*		AP's zone-specific buffs for certain classes based on areas. Here for reference until removed. If this is here in 2026, axe it.

/area/rogue/Entered(mob/living/carbon/human/guy)

	. = ..()
	if((src.town_area == TRUE) && HAS_TRAIT(guy, TRAIT_GUARDSMAN) && guy.z == 3 && !guy.has_status_effect(/datum/status_effect/buff/guardbuffone)) //man at arms
		guy.apply_status_effect(/datum/status_effect/buff/guardbuffone)
		if(HAS_TRAIT(guy, TRAIT_KNIGHTSMAN) && guy.has_status_effect(/datum/status_effect/buff/knightbuff))
			guy.remove_status_effect(/datum/status_effect/buff/knightbuff)

/area/rogue/Entered(mob/living/carbon/human/guy)

	. = ..()
	if((src.warden_area == TRUE) && HAS_TRAIT(guy, TRAIT_WOODSMAN) && !guy.has_status_effect(/datum/status_effect/buff/wardenbuff)) // Warden
		guy.apply_status_effect(/datum/status_effect/buff/wardenbuff)

/area/rogue/Entered(mob/living/carbon/human/guy)

	. = ..()
	if((src.keep_area == TRUE) && HAS_TRAIT(guy, TRAIT_KNIGHTSMAN) && !guy.has_status_effect(/datum/status_effect/buff/knightbuff)) //royal guard
		guy.apply_status_effect(/datum/status_effect/buff/knightbuff)
		if(HAS_TRAIT(guy, TRAIT_GUARDSMAN) && guy.has_status_effect(/datum/status_effect/buff/guardbuffone))
			guy.remove_status_effect(/datum/status_effect/buff/guardbuffone)
*/

// Keep
/area/rogue/outdoors/sund/keep // Setting exterior defaults.
	droning_sound = 'sound/music/area/sargoth.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	keep_area = TRUE
	town_area = TRUE

/area/rogue/outdoors/sund/keep/keep_exterior	
	name = "城堡外部"
	location_name = "城堡上方"
	icon_state = "keep_exterior"
	converted_type = /area/rogue/indoors/sund/keep
	soundenv = 16

/area/rogue/indoors/sund/keep	// Setting interior defaults.
	location_name = "城堡内"
	keep_area = TRUE
	town_area = TRUE
	first_time_text = "赫姆卫堡"
	icon_state = "keep"
	droning_sound = 'sound/music/area/sargoth.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/outdoors/sund/keep

/area/rogue/indoors/sund/keep/keep_interior // General purpose area.
	name = "城堡内部"
	location_name = "城堡内部"
	icon_state = "keep"

/area/rogue/indoors/sund/keep/markgrafs_chambers	// Specific subtypes for notable areas.
	name = "城主寝室"
	location_name = "城堡卧房"

/area/rogue/indoors/sund/keep/throne_room
	name = "王座厅"
	location_name = "王座厅"

/area/rogue/indoors/sund/keep/keep_commons
	name = "城堡公共区"
	location_name = "城堡内部"

/area/rogue/indoors/sund/keep/servants_chambers
	name = "仆役区"
	location_name = "城堡仆役住处"

/area/rogue/indoors/sund/keep/keep_cellars
	name = "城堡地窖"
	location_name = "城堡下方"

/area/rogue/indoors/sund/keep/keep_gatehouse
	name = "城堡门楼"
	location_name = "城堡门楼"

/area/rogue/indoors/sund/keep/knights_tower
	name = "骑士塔"
	location_name = "骑士塔"

/area/rogue/indoors/sund/keep/stewards_tower
	name = "总管塔"
	location_name = "总管塔"

// Castle

/area/rogue/outdoors/sund/castle
	location_name = "赫姆卫堡"
	keep_area = TRUE
	town_area = TRUE
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_CROWS
	droning_sound = 'sound/music/area/siege.ogg'
	droning_sound_dusk = 'sound/music/area/siege.ogg'
	droning_sound_night = 'sound/music/area/manor2.ogg'
	icon_state = "castle_exterior"
	converted_type = /area/rogue/indoors/sund/castle

/area/rogue/outdoors/sund/castle/castle_exterior
	name = "城堡外部"
	location_name = "城堡上方"
	icon_state = "castle_exterior"

/area/rogue/outdoors/sund/castle/courtyard
	name = "城堡庭院"
	location_name = "城堡庭院"
	icon_state = "castle_courtyard"
	droning_sound = 'sound/music/area/sargoth.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/manor2.ogg'

/area/rogue/indoors/sund/castle
	converted_type = /area/rogue/outdoors/sund/castle
	keep_area = TRUE
	town_area = TRUE

/area/rogue/indoors/sund/castle/castle_interior
	name = "城堡内部"
	location_name = "城堡内部"
	converted_type = /area/rogue/outdoors/sund/castle/castle_exterior

/area/rogue/indoors/sund/castle/castle_nobles
	name = "贵族之塔"
	location_name = "贵族之塔"
	droning_sound = 'sound/music/area/manor2.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleepingold.ogg'

// Town Walls
/area/rogue/outdoors/sund/walls
	name = "桑德堡城墙"
	location_name = "城墙"
	icon_state = "walls_exterior"
	town_area = TRUE
	converted_type = /area/rogue/indoors/sund/walls

/area/rogue/outdoors/sund/walls/walls_exterior
	name = "桑德堡城墙"
	location_name = "城墙"

/area/rogue/outdoors/sund/walls/gatehouse
	name = "桑德堡门楼"
	location_name = "城门"

/area/rogue/indoors/sund/walls
	name = "桑德堡城墙"
	location_name = "城墙"
	town_area = TRUE
	icon_state = "walls"
	converted_type = /area/rogue/outdoors/sund/walls

/area/rogue/indoors/sund/walls/walls_interior
	name = "桑德堡城墙"
	location_name = "城墙"

/area/rogue/indoors/sund/walls/gatehouse
	name = "桑德堡门楼"
	location_name = "城门"

// Sundmark Streets

/area/rogue/outdoors/sund/streets
	name = "桑德堡街道"
	location_name = "桑德堡的街道"
	first_time_text = "桑德堡"
	icon_state = "streets"
	town_area = TRUE
	ambientrain = RAIN_OUT
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_RATS
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/townstreetsold.ogg'
	soundenv = 16
	converted_type = /area/rogue/outdoors/sund/streets/backways

/area/rogue/outdoors/sund/streets/backways
	name = "后巷"
	location_name = "后巷"
	town_area = FALSE
	droning_sound = 'sound/music/area/towngenold.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/townstreetsold.ogg'
	converted_type = /area/rogue/outdoors/sund/streets


// Guild House

/area/rogue/outdoors/sund/guild
	name = "公会大厅"
	location_name = "公会大厅"
	icon_state = "guild_exterior"
	town_area = TRUE
	converted_type = /area/rogue/indoors/sund/guild

/area/rogue/outdoors/sund/guild/guild_exterior
	name = "公会大厅外部"
	location_name = "公会大厅上方"
	outdoors = TRUE
	ambientrain = RAIN_OUT
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/indoors/sund/guild
	name = "公会大厅"
	location_name = "公会大厅"
	icon_state = "guild"
	town_area = TRUE
	converted_type = /area/rogue/outdoors/sund/guild

/area/rogue/indoors/sund/guild/interior
	name = "公会大厅"
	location_name = "公会大厅内"
	icon_state = "guild"

/area/rogue/indoors/sund/guild/interior/merchant
	name = "商人铺"

/area/rogue/indoors/sund/guild/interior/smith
	name = "铁匠铺"
	location_name = "铁匠铺内"

/area/rogue/indoors/sund/guild/interior/tailor
	name = "裁缝铺"
	location_name = "裁缝铺内"

// Public House - Watch-house Complex

/area/rogue/outdoors/sund/public
	name = "公共酒馆"
	location_name = "公共酒馆"
	icon_state = "inn"
	town_area = TRUE
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/sund/public

/area/rogue/outdoors/sund/public/exterior
	name = "公共酒馆外部"
	location_name = "公共酒馆上方"
	outdoors = TRUE

/area/rogue/outdoors/sund/public/exterior/inn
	name = "旅店外部"
	location_name = "旅店上方"
	icon_state = "inn_exterior"

/area/rogue/outdoors/sund/public/exterior/watch
	name = "卫所外部"
	location_name = "卫所上方"
	icon_state = "watch_exterior"

/area/rogue/indoors/sund/public
	name = "公共酒馆"
	location_name = "公共酒馆"
	converted_type = /area/rogue/outdoors/sund/public

/area/rogue/indoors/sund/public/interior
	name = "公共酒馆"
	location_name = "公共酒馆"

/area/rogue/indoors/sund/public/inn
	name = "金酒杯"
	location_name = "旅店"
	first_time_text = "金酒杯"
	icon_state = "inn"

/area/rogue/indoors/sund/public/watch
	name = "卫所"
	location_name = "卫所"
	icon_state = "watch"
	droning_sound = 'sound/music/area/manorgarri.ogg'

/area/rogue/indoors/sund/public/gaol
	name = "监牢"
	location_name = "监牢"
	icon_state = "watch_gaol"
	droning_sound = 'sound/music/area/dungeon2.ogg'

// Church

/area/rogue/outdoors/sund/church
	name = "教堂"
	location_name = "教堂"
	icon_state = "church"
	town_area = TRUE
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = 'sound/music/area/churchdawn.ogg'
	droning_sound_night = 'sound/music/area/towngen.ogg'

/area/rogue/outdoors/sund/church/exterior
	name = "教堂外部"
	location_name = "教堂上方"
	icon_state = "church_exterior"
	spookysounds = SPOOKY_CROWS
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 16

/area/rogue/outdoors/sund/church/covered	// The 'breezeways' under elevated walkways.
	name = "教堂步道"
	location_name = "教堂内"
	ambientrain = RAIN_OUT
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN

	soundenv = 16
	plane = INDOOR_PLANE					// Although outside, its not rained on.

/area/rogue/indoors/sund/church
	name = "教堂内部"
	location_name = "教堂内"
	droning_sound = 'sound/music/area/church.ogg'
	droning_sound_dusk = 'sound/music/area/churchdawn.ogg'
	droning_sound_night = 'sound/music/area/towngen.ogg'

/area/rogue/indoors/sund/church/interior/cathedral
	name = "大教堂"
	location_name = "大教堂内"

/area/rogue/indoors/sund/church/interior/chapterhouse
	name = "礼拜堂会议室"
	location_name = "礼拜堂会议室内"

/area/rogue/indoors/sund/church/interior/monastery
	name = "修道院"
	location_name = "修道院内"

// Town Houses

/area/rogue/outdoors/sund/houses
	name = "桑德堡民居"
	location_name = "桑德马克的一间屋舍"
	icon_state = "houses"
	town_area = TRUE

/area/rogue/outdoors/sund/houses/exterior
	name = "桑德堡屋顶"
	location_name = "桑德堡屋舍上方"
	icon_state = "houses_exterior"
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 16

/area/rogue/indoors/sund/houses
	name = "桑德堡民居"
	location_name = "桑德马克的一间屋舍"
	icon_state = "houses"
	town_area = TRUE

/area/rogue/indoors/sund/houses/interior
	name = "桑德堡室内"
	location_name = "桑德堡的屋舍内"
	ambientrain = RAIN_IN
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/sleeping.ogg'
	soundenv = 2
	plane = INDOOR_PLANE

// Bath and Bawdy Werks		I will not apologize.

/area/rogue/outdoors/sund/bawdy
	name = "风月馆"
	location_name = "风月馆"
	icon_state = "bawdy"

/area/rogue/outdoors/sund/bawdy/exterior
	name = "桑德堡屋顶"
	location_name = "桑德堡屋舍上方"	// Deliberate obfuscation with other town houses.
	icon_state = "bawdy_exterior"
	outdoors = TRUE
	ambientrain = RAIN_OUT
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 16

/area/rogue/indoors/sund/bawdy/interior
	name = "桑德堡风月馆"
	location_name = "风月馆内"
	ambientrain = RAIN_IN
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bath.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	soundenv = 2
	plane = INDOOR_PLANE

/area/rogue/indoors/sund/bath/interior/baths
	name = "桑德堡浴场"
	location_name = "风月馆内"	// Deliberate obfuscation with the upstairs.
	icon_state = "baths"
	ambientsounds = AMB_CAVEWATER
	ambientnight = AMB_CAVEWATER
	spookysounds = SPOOKY_RATS
	spookynight = SPOOKY_RATS
	droning_sound_dusk = null
	droning_sound_night = null
	ambientrain = RAIN_SEWER
	soundenv = 21

// Sundburg Outskirts		No-ambush, safe areas around Sundburg's walls.

/area/rogue/outdoors/sund/outskirts
	name = "桑德堡郊外"
	icon_state = "outskirts"
	location_name = "桑德堡郊外"
	outdoors = TRUE
	ambientrain = RAIN_OUT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_night = 'sound/music/area/field.ogg'

/area/rogue/outdoors/sund/outskirts/farmlands
	name = "桑德堡农田"
	location_name = "桑德堡的农田"
	icon_state = "outskirts_road"

/area/rogue/outdoors/sund/outskirts/gateroad
	name = "桑德堡门外大道"
	location_name = "桑德堡城门外"
	icon_state = "outskirts_road"

/area/rogue/outdoors/sund/outskirts/wallroad
	name = "桑德堡城外大道"
	location_name = "桑德堡城墙外"
	icon_state = "outskirts_road"

/area/rogue/outdoors/sund/outskirts/bridge
	name = "桑德堡大桥"
	location_name = "桑德堡城墙外"
	icon_state = "outskirts_road"
	first_time_text = "桑德堡大桥"
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = 'sound/music/area/bog.ogg'
	droning_sound_night = 'sound/music/area/bog.ogg'

/area/rogue/indoors/sund/outskirts/interior
	name = "桑德堡农舍"
	location_name = "桑德堡周边的农舍"
	icon_state = "outskirts_interior"
	ambientrain = RAIN_IN
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 2
	plane = INDOOR_PLANE

/area/rogue/indoors/sund/outskirts/interior/barge
	name = "桑德堡附属建筑"
	icon_state = "outskirts_interior"
	ambientrain = RAIN_IN
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = 'sound/music/area/bog.ogg'
	droning_sound_night = 'sound/music/area/bog.ogg'

/area/rogue/indoors/town/warehouse		// Unless or until we touch import code, use this path.
	name = "码头进口仓库"
	icon_state = "warehouse"
	ambientrain = RAIN_IN
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	droning_sound = 'sound/music/area/bog.ogg'
	droning_sound_dusk = 'sound/music/area/bog.ogg'
	droning_sound_night = 'sound/music/area/bog.ogg'

// Ambush Wilderness (All Ambush Zones Within, Please!!!)

/area/rogue/outdoors/sund/wilderness
	name = "桑德马克荒野"
	location_name = "桑德马克的荒野"
	icon_state = "wilderness"
	soundenv = 19

/area/rogue/outdoors/sund/wilderness/field
	name = "桑德马克原野"
	location_name = "桑德马克的原野"
	icon_state = "wilderness_field"
	ambush_times = list("night")
	ambush_types = list(
				/turf/open/floor/rogue/dirt,
				/turf/open/floor/rogue/grass)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 30)

	droning_sound = 'sound/music/area/field.ogg'
	droning_sound_night = 'sound/music/area/bog.ogg'

/area/rogue/outdoors/sund/wilderness/river
	name = "阿森河"	// The deepest of lore. Actual Pre-Tacitus cut.
	location_name = "阿森河"
	icon_state = "river"
	warden_area = TRUE
	ambientsounds = AMB_RIVERDAY
	ambientnight = AMB_RIVERNIGHT
	spookysounds = SPOOKY_FROG
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/bog.ogg'
	converted_type = /area/rogue/indoors/shelter/woods

/area/rogue/outdoors/sund/wilderness/woods
	name = "阿森森林"
	location_name = "桑德马克的森林"
	first_time_text = "阿森森林"
	icon_state = "wilderness_woods"
	ambientsounds = AMB_FORESTDAY
	ambientnight = AMB_FORESTNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_FOREST
	droning_sound = 'sound/music/area/forest.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	soundenv = 15
	warden_area = TRUE
	ambush_times = list("night","dawn","dusk","day")
	ambush_types = list(
				/turf/open/floor/rogue/dirt,
				/turf/open/floor/rogue/grass)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/saiga = 40,
				/mob/living/simple_animal/hostile/retaliate/rogue/spider = 10,
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30)

/area/rogue/outdoors/sund/wilderness/mountain
	name = "桑德马克山脉"
	location_name = "桑德马克的群山"
	first_time_text = "桑德马克山脉"
	icon_state = "wilderness_mountain"
	ambush_types = list(
				/turf/open/floor/rogue/dirt)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
				/mob/living/carbon/human/species/goblin/npc/ambush = 20,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 10)
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/dwarf.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/forestnight.ogg'
	warden_area = TRUE
	soundenv = 17

/area/rogue/outdoors/sund/wilderness/mountain/danger
	name = "桑德马克山巅"
	icon_state = "wilderness_mountains"
	ambush_types = list(
				/turf/open/floor/rogue/dirt)
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/wolf = 30,
				/mob/living/simple_animal/hostile/retaliate/rogue/orc = 10,
				/mob/living/carbon/human/species/goblin/npc/ambush/cave = 20)
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = 'sound/music/area/caves.ogg'
	ambush_times = list("night","dawn","dusk","day")

// The Author was here, but now he is dead.
