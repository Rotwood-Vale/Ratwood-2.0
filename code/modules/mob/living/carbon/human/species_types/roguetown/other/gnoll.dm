/mob/living/carbon/human/species/gnoll
	race = /datum/species/gnoll
	footstep_type = FOOTSTEP_MOB_HEAVY

/mob/living/carbon/human/species/gnoll/updatehealth()
	..()

	remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN)
	remove_movespeed_modifier(MOVESPEED_ID_DAMAGE_SLOWDOWN_FLYING)

/mob/living/carbon/human/species/gnoll/male
	gender = MALE

/mob/living/carbon/human/species/gnoll/female
	gender = FEMALE

/datum/species/gnoll
	name = "gnoll"
	id = "gnoll"
	custom_rotation_icon = TRUE
	custom_base_icon = "firepelt"
	species_traits = list(NO_UNDERWEAR, NO_ORGAN_FEATURES, NO_BODYPART_FEATURES)
	inherent_traits = list(
		TRAIT_LONGSTRIDER,
		TRAIT_IGNORESLOWDOWN,
		TRAIT_IGNOREDAMAGESLOWDOWN,
		TRAIT_CRITICAL_RESISTANCE,
		TRAIT_NOFALLDAMAGE1,
		TRAIT_STRENGTH_UNCAPPED,
		TRAIT_PIERCEIMMUNE,
		TRAIT_HARDDISMEMBER,
		TRAIT_NOSTINK,
		TRAIT_NASTY_EATER,
		TRAIT_ORGAN_EATER,
		TRAIT_BREADY,
		TRAIT_STEELHEARTED,
		TRAIT_BASHDOORS,
		TRAIT_STRONGBITE,
		TRAIT_GNARLYDIGITS,
		TRAIT_ZJUMP,
		TRAIT_NUDIST,
		TRAIT_HERESIARCH, //Just because I'm putting their spawns here, that's all.
		TRAIT_ZURCH,
		TRAIT_EXTREME_TEMPERATURE_IMMUNE,
		TRAIT_UNLYCKERABLE //Just stop
	)
	inherent_biotypes = MOB_HUMANOID
	armor = 30
	no_equip = list(SLOT_SHIRT, SLOT_HEAD, SLOT_WEAR_MASK, SLOT_ARMOR, SLOT_GLOVES, SLOT_SHOES, SLOT_PANTS, SLOT_CLOAK, SLOT_BELT, SLOT_BACK_R, SLOT_BACK_L, SLOT_S_STORE)
	nojumpsuit = 1
	sexes = 1
	offset_features = list(OFFSET_HANDS = list(0,2), OFFSET_HANDS_F = list(0,2))
	soundpack_m = /datum/voicepack/gnoll
	soundpack_f = /datum/voicepack/gnoll
	enflamed_icon = "widefire"
	organs = list(
		ORGAN_SLOT_BRAIN = /obj/item/organ/brain,
		ORGAN_SLOT_HEART = /obj/item/organ/heart,
		ORGAN_SLOT_LUNGS = /obj/item/organ/lungs,
		ORGAN_SLOT_EYES = /obj/item/organ/eyes/night_vision/werewolf,
		ORGAN_SLOT_EARS = /obj/item/organ/ears,
		ORGAN_SLOT_TONGUE = /obj/item/organ/tongue/wild_tongue,
		ORGAN_SLOT_LIVER = /obj/item/organ/liver,
		ORGAN_SLOT_STOMACH = /obj/item/organ/stomach,
		ORGAN_SLOT_APPENDIX = /obj/item/organ/appendix,
	)
	languages = list(
		/datum/language/common,
		/datum/language/gronnic,
		/datum/language/beast,
	)
	stress_examine = TRUE
	stress_desc = span_red("Gods above... a Gnoll!!")
	examine_stress_event = /datum/stressevent/gnoll_examine
	examine_stress_event_xenophobic = /datum/stressevent/gnoll_examine
	examine_stress_always = TRUE
	examine_stress_ignores_tolerant = TRUE
	examine_relief_patron = /datum/patron/inhumen/graggar
	examine_relief_event = /datum/stressevent/gnoll_graggar

/datum/species/gnoll/send_voice(mob/living/carbon/human/H)
	playsound(get_turf(H), pick('sound/vo/mobs/wwolf/wolftalk1.ogg','sound/vo/mobs/wwolf/wolftalk2.ogg'), 100, TRUE, -1)

/datum/species/gnoll/proc/cancel_default_bark(datum/source, list/hearers, distance, volume, pitch)
	SIGNAL_HANDLER
	return TRUE

/datum/species/gnoll/regenerate_icons(mob/living/carbon/human/H)
	var/static/list/gnoll_base_intents = list(INTENT_HELP, INTENT_DISARM, INTENT_GRAB)
	H.icon = 'icons/roguetown/mob/monster/gnoll.dmi'
	H.base_intents = gnoll_base_intents
	H.update_damage_overlays()
	H.update_inv_armor_special()
	return TRUE

/datum/species/gnoll/on_species_gain(mob/living/carbon/C, datum/species/old_species)
	. = ..()
	C.remove_status_effect(/datum/status_effect/buff/adrenaline_rush)
	REMOVE_TRAIT(C, TRAIT_ADRENALINE_RUSH, INNATE_TRAIT)
	RegisterSignal(C, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(C, COMSIG_MOVABLE_BARK, PROC_REF(cancel_default_bark))
	C.ambushable = FALSE
	var/mob/living/carbon/human/H = C
	H.reset_gnoll_sprite_scale()
	var/pelt_type = "firepelt" // default
	if(H.client?.prefs?.gnoll_prefs)
		pelt_type = H.client.prefs.gnoll_prefs.pelt_type || "firepelt"
	C.icon_state = pelt_type
	C.base_pixel_x = -8
	C.pixel_x = -8
	C.base_pixel_y = -4
	C.pixel_y = -4

/datum/species/gnoll/on_species_loss(mob/living/carbon/C)
	. = ..()
	UnregisterSignal(C, COMSIG_MOB_SAY)
	UnregisterSignal(C, COMSIG_MOVABLE_BARK)

/datum/species/gnoll/update_damage_overlays(mob/living/carbon/human/H)
	clear_extremity_overlays(H, FALSE)
	clear_layer_overlay(H, DAMAGE_LAYER, TRUE)
	clear_layer_overlay(H, LEG_DAMAGE_LAYER, TRUE)
	clear_layer_overlay(H, ARM_DAMAGE_LAYER, TRUE)
	H.overlays_standing[DAMAGE_LAYER] = list()
	H.overlays_standing[LEG_DAMAGE_LAYER] = list()
	H.overlays_standing[ARM_DAMAGE_LAYER] = list()
	if(H.client)
		H.update_vision_cone()
	return TRUE

/datum/species/gnoll/proc/clear_layer_overlay(mob/living/carbon/human/H, layer_index, set_empty = FALSE)
	var/I = H.overlays_standing[layer_index]
	if(I)
		H.cut_overlay(I)
	if(set_empty)
		H.overlays_standing[layer_index] = list()
	else
		H.overlays_standing[layer_index] = null

/datum/species/gnoll/proc/clear_extremity_overlays(mob/living/carbon/human/H, update_vision = TRUE)
	// Gnolls do not use humanoid hand/foot worn layers; clear them so bloodied extremity sprites never appear.
	clear_layer_overlay(H, SHOES_LAYER)
	clear_layer_overlay(H, SHOESLEEVE_LAYER)
	clear_layer_overlay(H, LEGSLEEVE_LAYER)
	clear_layer_overlay(H, GLOVES_LAYER)
	clear_layer_overlay(H, GLOVESLEEVE_LAYER)
	if(update_vision && H.client)
		H.update_vision_cone()

/datum/species/gnoll/random_name(gender,unique,lastname)
	return "[pick(GLOB.wolf_prefixes)] [pick(GLOB.wolf_suffixes)]"
