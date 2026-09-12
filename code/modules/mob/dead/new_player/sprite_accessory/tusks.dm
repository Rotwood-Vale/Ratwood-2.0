/datum/sprite_accessory/tusks
	abstract_type = /datum/sprite_accessory/tusks
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	color_key_name = "Tusks"
	relevant_layers = list(BODY_FRONT_LAYER)
	default_colors = list("#F4F4BE")

/datum/sprite_accessory/tusks/is_visible(obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	return is_human_part_visible(owner, HIDESNOUT)

/datum/sprite_accessory/tusks/adjust_appearance_list(list/appearance_list, obj/item/organ/organ, obj/item/bodypart/bodypart, mob/living/carbon/owner)
	generic_gender_feature_adjust(appearance_list, organ, bodypart, owner, OFFSET_FACE, OFFSET_FACE_F)

/datum/sprite_accessory/tusks/halforc
	name = "Orc"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "orctusk"

/datum/sprite_accessory/tusks/longtusk
	name = "Long"
	icon = 'icons/mob/sprite_accessory/halforc.dmi'
	icon_state = "longtusk"
