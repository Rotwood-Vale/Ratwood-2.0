/datum/customizer/organ/belly
	name = "Belly"
	customizer_choices = list(/datum/customizer_choice/organ/belly)

/datum/customizer/organ/belly/is_allowed(datum/preferences/prefs)
	for(var/datum/charflaw/vice in list(prefs.vice1, prefs.vice2, prefs.vice3, prefs.vice4, prefs.vice5, prefs.vice6, prefs.charflaw))
		if(istype(vice, /datum/charflaw/addiction/corpulent))
			return TRUE
	return FALSE

/datum/customizer_choice/organ/belly
	name = "Belly"
	organ_type = /obj/item/organ/belly
	organ_slot = ORGAN_SLOT_BELLY
	sprite_accessories = list(/datum/sprite_accessory/belly/pair)

/obj/item/organ/belly
	name = "belly"
	icon_state = "severedtail"
	visible_organ = TRUE
	zone = BODY_ZONE_CHEST
	slot = ORGAN_SLOT_BELLY
	accessory_type = /datum/sprite_accessory/belly/pair

/datum/sprite_accessory/belly
	abstract_type = /datum/sprite_accessory/belly
	icon = 'icons/mob/sprite_accessory/genitals/belly.dmi'
	color_key_name = "Belly"
	layer = 44.5
	color_key_defaults = list(KEY_CHEST_COLOR)

/datum/sprite_accessory/belly/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDEBOOB|HIDEJUMPSUIT)

/datum/sprite_accessory/belly/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_BELT, OFFSET_BELT_F)

/datum/sprite_accessory/belly/pair
	name = "Plump"
	icon_state = "belly_pair_1_FRONT"
