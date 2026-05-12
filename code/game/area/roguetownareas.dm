GLOBAL_LIST_EMPTY(chosen_music)

GLOBAL_LIST_INIT(roguetown_areas_typecache, typecacheof(/area/rogue/indoors/town,/area/rogue/outdoors/town,/area/rogue/under/town)) //hey

/area/rogue
	name = "roguetown"
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
	name = "indoors"
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
	name = "Bandit Camp"
	droning_sound = 'sound/music/area/banditcamp.ogg'
	droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	droning_sound_night = 'sound/music/area/banditcamp.ogg'

/area/rogue/indoors/banditcamp/hoardmaster
	name = "The Hoard"
	icon_state = "rogue"
	first_time_text = "A MISTAKE"
	deathsight_message = "a place of greed and excess"
	hoardmaster_protected = TRUE

/area/rogue/indoors/vampire_manor
	name = "Vampire Manor"
	first_time_text = "The House of Blood"
	droning_sound = 'sound/music/area/manor2.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "an ancient dread-manor, home of a great and terrible evil. Red eyes look back at you, warning you not to pry further."

/area/rogue/outdoors/woods/vampire_lair
	warden_area = FALSE
	ambush_times = null
	ambush_mobs = null
	threat_region = ""
	droning_sound = 'sound/music/area/gloom.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	deathsight_message = "the foot of an ancient dread-manor, before the home of a great and terrible evil."



/area/rogue/indoors/ravoxarena
	name = "Ravox's Arena"
	deathsight_message = "an arena of justice"

/area/rogue/indoors/ravoxarena/can_craft_here()
	return FALSE

/area/rogue/indoors/ravoxarena/proc/cleanthearena(turf/returnzone)
	for(var/obj/item/trash in src)
		do_teleport(trash, returnzone)
	GLOB.arenafolks.len = list()

/area/rogue/indoors/deathsedge
	name = "Death's Precipice"
	deathsight_message = "an place bordering necra's grasp"
	necra_area = TRUE
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "DEATHS PRECIPICE"

/area/rogue/indoors/eventarea
	name = "Event Area"
	deathsight_message = "a place shielded from mortal eyes"

///// OUTDOORS AREAS //////

/area/rogue/outdoors
	name = "Outdoors Roguetown"
	icon_state = "outdoors"
	outdoors = TRUE
	ambientrain = RAIN_OUT
//	ambientsounds = list('sound/ambience/wamb.ogg')
	ambientsounds = AMB_TOWNDAY
	ambientnight = AMB_TOWNNIGHT
	spookysounds = SPOOKY_CROWS
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	converted_type = /area/rogue/indoors/shelter
	soundenv = 16
	deathsight_message = "somewhere in the wilds"

/area/rogue/outdoors/banditcamp
	name = "Bandit Camp"
	droning_sound = 'sound/music/area/banditcamp.ogg'
	droning_sound_dusk = 'sound/music/area/banditcamp.ogg'
	droning_sound_night = 'sound/music/area/banditcamp.ogg'
	first_time_text = "A Gathering of Thieves"
	deathsight_message = "somewhere in the wilds"

/area/rogue/outdoors/banditcamp/exterior // Only use these around traveltiles - Constantine
	name = "bandit camp outdoors"

/area/rogue/outdoors/banditcamp/exterior/can_craft_here() //Made to prevent killboxes - Constantine
	return FALSE

/area/rogue/indoors/shelter
	icon_state = "shelter"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	deathsight_message = "somewhere in the wilds, under a roof"

/area/rogue/outdoors/mountains
	name = "Mountains"
	icon_state = "mountains"
	ambientsounds = AMB_MOUNTAIN
	ambientnight = AMB_MOUNTAIN
	spookysounds = SPOOKY_GEN
	spookynight = SPOOKY_GEN
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	warden_area = TRUE
	soundenv = 17
	converted_type = /area/rogue/indoors/shelter/mountains
	deathsight_message = "a twisted tangle of soaring peaks"
	// I SURE HOPE NO ONE USE THIS HUH

/area/rogue/indoors/shelter/mountains
	icon_state = "mountains"
	droning_sound = 'sound/music/area/townstreets.ogg'
	droning_sound_dusk = 'sound/music/area/septimus.ogg'
	droning_sound_night = 'sound/music/area/sleeping.ogg'
	deathsight_message = "a twisted tangle of soaring peaks"

/area/rogue/outdoors/mountains/deception
	name = "deception"
	icon_state = "deception"
	first_time_text = "THE CANYON OF DECEPTION"

//// UNDER AREAS (no indoor rain sound usually)

// these don't get a rain sound because they're underground
/area/rogue/under
	name = "basement"
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
	name = "cavelava"
	icon_state = "cavelava"
	first_time_text = "MOUNT DECAPITATION"
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
	name = "underground lake"
	icon_state = "lake"
	ambientsounds = AMB_BEACH
	ambientnight = AMB_BEACH
	spookysounds = SPOOKY_CAVE
	spookynight = SPOOKY_GEN

/area/rogue/under/cave/dungeon1
	name = "smalldungeon1"
	icon_state = "spider"
	droning_sound = 'sound/music/area/dungeon.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1

/area/rogue/under/cave/licharena
	name = "lich's domain"
	icon_state = "under"
	first_time_text = "LICH'S DOMAIN"
	droning_sound = 'sound/music/area/dragonden.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE
	detail_text = DETAIL_TEXT_LICH_DOMAIN

/area/rogue/under/cave/licharena/bossroom
	name = "the lich's lair"
	first_time_text = "THE LICH"

/area/rogue/under/cave/licharena/bossroom/can_craft_here()
	return FALSE


/area/rogue/under/cave/inferno
	name = "inferno"
	icon_state = "fire_chamber"
	first_time_text = "Somewhere Else..."
	droning_sound = 'sound/music/area/inferno.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	converted_type = /area/rogue/outdoors/dungeon1
	ceiling_protected = TRUE

/area/rogue/outdoors/dungeon1
	name = "smalldungeonoutdoors"
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



// underworld
/area/rogue/underworld
	name = "underworld"
	icon_state = "underworld"
	droning_sound = 'sound/music/area/underworlddrone.ogg'
	droning_sound_dusk = null
	droning_sound_night = null
	first_time_text = "The Forest of Repentence"

/area/rogue/underworld/dream
	name = "dream realm"
	icon_state = "dream"
	first_time_text = "Abyssal Dream"

/area/rogue/underworld/adventurespawn
	name = "wayfarer's dream"
	icon_state = "dream"
	first_time_text = "A Wayfarer's Dream"

#define SOUND_ENV_INDOOR = 2
#define SOUND_ENV_OUTDOOR = 16
#define SOUND_ENV_WINDY = 17
#define SOUND_ENV_CAVES = 8
