GLOBAL_LIST_EMPTY(chosen_music)

GLOBAL_LIST_INIT(roguetown_areas_typecache, typecacheof(/area/rogue/indoors/town,/area/rogue/outdoors/town,/area/rogue/under/town)) //hey

/area/rogue
	name = "罗格镇"
	icon_state = "rogue"
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
	var/tavern_area = FALSE
	var/warden_area = FALSE
	var/holy_area = FALSE
	var/cell_area = FALSE
	var/viewing_area = FALSE
	var/ceiling_protected = FALSE //Prevents tunneling into these from above
	var/hoardmaster_protected = FALSE//If a player enters, it ashes them. Your greed will consume you.
	var/necra_area = FALSE
	var/no_special_item_retrieval = FALSE//we want in rare cases for loadouts to be inaccessible

/area/rogue/Entered(mob/living/carbon/human/guy)
	. = ..()
	if(!ishuman(guy))
		return
	if((src.town_area == TRUE) && HAS_TRAIT(guy, TRAIT_GUARDSMAN) && !guy.has_status_effect(/datum/status_effect/buff/guardbuffone)) //man at arms
		guy.apply_status_effect(/datum/status_effect/buff/guardbuffone)
	if((src.tavern_area == TRUE) && HAS_TRAIT(guy, TRAIT_TAVERN_FIGHTER) && !guy.has_status_effect(/datum/status_effect/buff/barkeepbuff)) // THE FIGHTER
		guy.apply_status_effect(/datum/status_effect/buff/barkeepbuff)
	if((src.warden_area == TRUE) && HAS_TRAIT(guy, TRAIT_WOODSMAN) && !guy.has_status_effect(/datum/status_effect/buff/wardenbuff)) // Warden
		guy.apply_status_effect(/datum/status_effect/buff/wardenbuff)
	if((src.cell_area == TRUE) && HAS_TRAIT(guy, TRAIT_DUNGEONMASTER) && !guy.has_status_effect(/datum/status_effect/buff/dungeoneerbuff)) // Dungeoneer
		guy.apply_status_effect(/datum/status_effect/buff/dungeoneerbuff)
	if((src.holy_area == TRUE) && HAS_TRAIT(guy, TRAIT_VOTARY))//Top Church guys get a buff. Opposite to overt heretics.
		guy.add_stress(/datum/stressevent/seeblessed)
	if((src.holy_area == TRUE) && HAS_TRAIT(guy, TRAIT_HOLYWARRIOR))
		guy.apply_status_effect(/datum/status_effect/debuff/holy_blessing)
	if((src.necra_area == TRUE) && !(guy.has_status_effect(/datum/status_effect/debuff/necrandeathdoorwilloss)||(guy.has_status_effect(/datum/status_effect/debuff/deathdoorwilloss)))) //Necra saps at wil
		if(HAS_TRAIT(guy, TRAIT_SOUL_EXAMINE))
			guy.apply_status_effect(/datum/status_effect/debuff/necrandeathdoorwilloss)
		else
			guy.apply_status_effect(/datum/status_effect/debuff/deathdoorwilloss)
	if((src.viewing_area == TRUE) && !guy.has_status_effect(/datum/status_effect/buff/viewingbuff)) // unique buff when in an arena so you have a better view
		guy.apply_status_effect(/datum/status_effect/buff/viewingbuff)
	if((src.hoardmaster_protected == TRUE))//Your greed consumes you.
		message_admins("[guy.real_name]([key_name(guy)]) was dusted by the Hoardmaster, at [ADMIN_JMP(src)]")
		log_admin("[guy.real_name]([key_name(guy)]) was dusted by the Hoardmaster")
		playsound(src, 'sound/misc/lava_death.ogg', 100, FALSE)
		guy.dust()
		GLOB.azure_round_stats[STATS_GREED_DUSTED]++

/area/rogue/indoors
	name = "室内"
	icon_state = "indoors"
	ambientrain = RAIN_IN
	ambientsounds = AMB_INGEN
	ambientnight = AMB_INGEN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 2
	plane = INDOOR_PLANE
	converted_type = /area/rogue/outdoors

/area/rogue/indoors/banditcamp
	name = "强盗营地"
	droning_sound = 'sound/music/area/banditcamp.ogg'
	droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	droning_sound_night = 'sound/music/area/banditcamp.ogg'

/area/rogue/indoors/banditcamp/hoardmaster
	name = "藏宝窟"
	icon_state = "rogue"
	first_time_text = "误入歧途"
	deathsight_message = "一处充满贪欲与放纵之地"
	hoardmaster_protected = TRUE

/area/rogue/indoors/vampire_manor
	name = "吸血鬼庄园"
	first_time_text = "血之家"
	droning_sound = 'sound/music/area/manor2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "一座古老阴森的庄园，可怖大恶盘踞其中，猩红双眼正警告你莫再深入。"

/area/rogue/outdoors/woods/vampire_lair
	ambush_times = null
	ambush_mobs = null
	threat_region = ""
	droning_sound = 'sound/music/area/gloom.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "古老阴森庄园的脚下，一处可怖大恶盘踞的宅邸之前。"



/area/rogue/indoors/ravoxarena
	name = "拉沃克斯竞技场"
	deathsight_message = "一座裁决公正的竞技场"

/area/rogue/indoors/ravoxarena/can_craft_here()
	return FALSE

/area/rogue/indoors/ravoxarena/proc/cleanthearena(turf/returnzone)
	for(var/obj/item/trash in src)
		do_teleport(trash, returnzone)
	GLOB.arenafolks.len = list()

/area/rogue/indoors/deathsedge
	name = "死之绝壁"
	deathsight_message = "一处紧邻内克拉之握的地带"
	necra_area = TRUE
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "死之绝壁"

/area/rogue/indoors/eventarea
	name = "活动区域"
	deathsight_message = "一处隔绝凡人视线之地"

///// OUTDOORS AREAS //////

/area/rogue/outdoors
	name = "罗格镇室外"
	icon_state = "outdoors"
	outdoors = TRUE
	ambientrain = RAIN_OUT
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter
	soundenv = 16
	deathsight_message = "荒野中的某处"
	warden_area = TRUE

/area/rogue/outdoors/banditcamp
	name = "强盗营地"
	droning_sound = 'sound/music/area/banditcamp.ogg'
	droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	droning_sound_night = 'sound/music/area/banditcamp.ogg'
	first_time_text = "盗贼聚所"
	deathsight_message = "荒野中的某处"

/area/rogue/outdoors/banditcamp/exterior // Only use these around traveltiles - Constantine
	name = "强盗营地室外"

/area/rogue/outdoors/banditcamp/exterior/can_craft_here() //Made to prevent killboxes - Constantine
	return FALSE

/area/rogue/indoors/shelter
	icon_state = "shelter"
	deathsight_message = "荒野中的某处，头顶有屋顶遮蔽"
	warden_area = TRUE

/area/rogue/outdoors/mountains
	name = "群山"
	icon_state = "mountains"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	soundenv = 17
	converted_type = /area/rogue/indoors/shelter/mountains
	deathsight_message = "一片高耸群峰交错盘结的险地"
	// I SURE HOPE NO ONE USE THIS HUH

/area/rogue/indoors/shelter/mountains
	icon_state = "mountains"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	deathsight_message = "一片高耸群峰交错盘结的险地"

/area/rogue/outdoors/mountains/deception
	name = "欺瞒峡谷"
	icon_state = "deception"
	first_time_text = "欺瞒峡谷"

//// UNDER AREAS (no indoor rain sound usually)

// these don't get a rain sound because they're underground
/area/rogue/under
	name = "地下室"
	icon_state = "under"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	soundenv = 8
	plane = INDOOR_PLANE
	converted_type = /area/rogue/outdoors/exposed

/area/rogue/outdoors/exposed
	icon_state = "exposed"
	droning_sound = 'sound/music/area/towngen.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'

/area/rogue/under/cavelava
	name = "熔岩洞窟"
	icon_state = "cavelava"
	first_time_text = "断首山"
	ambientsounds = AMB_CAVELAVA
	ambientnight = AMB_CAVELAVA
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_CAVE
	ambush_times = list("night","dawn","dusk","day")
	ambush_mobs = list(
				/mob/living/simple_animal/hostile/retaliate/rogue/bigrat = 10,
				/mob/living/carbon/human/species/skeleton/npc/ambush = 20,
				/mob/living/carbon/human/species/goblin/npc/hell = 25,
				/mob/living/simple_animal/hostile/retaliate/rogue/minotaur = 15)
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/exposed/decap

/area/rogue/outdoors/exposed/decap
	icon_state = "decap"
	droning_sound = 'sound/music/area/decap.ogg'
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/under/lake
	name = "地下湖"
	icon_state = "lake"
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_GEN

/area/rogue/under/cave/dungeon1
	name = "小地牢"
	icon_state = "spider"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1

/area/rogue/under/cave/licharena
	name = "巫妖领域"
	icon_state = "under"
	first_time_text = "巫妖领域"
	droning_sound = 'sound/music/area/dragonden.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	detail_text = DETAIL_TEXT_LICH_DOMAIN

/area/rogue/under/cave/licharena/bossroom
	name = "巫妖巢穴"
	first_time_text = "巫妖"

/area/rogue/under/cave/licharena/bossroom/can_craft_here()
	return FALSE


/area/rogue/under/cave/inferno
	name = "炼狱"
	icon_state = "fire_chamber"
	first_time_text = "彼界某处……"
	droning_sound = 'sound/music/area/inferno.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE

/area/rogue/outdoors/dungeon1
	name = "小地牢外部"
	icon_state = "spidercave"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	ceiling_protected = TRUE

//////
/////
////     TOWN AREAS are in town.dm
////
///
//

///// outside town areas are in town.dm

// /area/rogue/outdoors/town/sargoth
// 	name = "outdoors"
// 	icon_state = "sargoth"
// 	soundenv = 16
// 	droning_sound = 'sound/music/area/sargoth.ogg'
// 	droning_sound_dusk = null
// 	droning_sound_night = null
// 	converted_type = /area/rogue/indoors/shelter/town/sargoth
// 	first_time_text = "SARGOTH"

// /area/rogue/indoors/shelter/town/sargoth
// 	icon_state = "sargoth"
// 	droning_sound = 'sound/music/area/sargoth.ogg'
// 	droning_sound_dusk = null
// 	droning_sound_night = null
// 	first_time_text = "SARGOTH"


/area/rogue/indoors/lich_start //Quieter so our droning noise doesn't cut out the on-spawn stinger, not yet. I want this experience to be thematic
	name = "巫妖巢穴"
	droning_sound = 'sound/ambience/creepywind.ogg' //Ominiously quiet starting room, let them build up a bit.
	droning_sound_dusk = null
	droning_sound_night = null

/area/rogue/indoors/lich_start/lich_lair //Sovlnuke with a unique track we didn't use previous I think?
	first_time_text = "被遗忘的堡垒"
	droning_sound = 'sound/music/area/underworlddrone.ogg'

// underworld
/area/rogue/underworld
	name = "冥界"
	icon_state = "underworld"
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "忏悔之林"

/area/rogue/underworld/dream
	name = "梦境领域"
	icon_state = "dream"
	first_time_text = "深渊之梦"

/area/rogue/underworld/adventurespawn
	name = "旅者之梦"
	icon_state = "dream"
	first_time_text = "旅者之梦"

/area/rogue/underworld/adventurespawn/start
	first_time_text = "null"
	droning_sound = null
	droning_sound_dusk = null
	droning_sound_night = null

#define SOUND_ENV_INDOOR = 2
#define SOUND_ENV_OUTDOOR = 16
#define SOUND_ENV_WINDY = 17
#define SOUND_ENV_CAVES = 8
