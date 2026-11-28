/obj/item/organ/soul
	name = "soul"
	desc = "You're holding their soul, somehow."
	icon_state = ""
	visible_organ = TRUE
	slot = ORGAN_SLOT_SOUL
	organ_flags = ORGAN_SURGERY_HIDDEN | ORGAN_INTERNAL_ONLY

/obj/item/organ/soul/get_icon_cache_key(obj/item/bodypart/bodypart)
	var/datum/sprite_accessory/accessory = SPRITE_ACCESSORY(accessory_type)
	return "[..()]-[accessory?.is_visible(src, bodypart, owner)]"

/obj/item/organ/soul/fire
	name = "soul fire"
	accessory_type =  /datum/sprite_accessory/soul/fire
