/obj/item/organ/butt
	name = "butt"
	icon_state = "breasts" //that file is cursed
	visible_organ = TRUE
	zone = BODY_ZONE_PRECISE_GROIN
	slot = ORGAN_SLOT_BUTT
	organ_dna_type = /datum/organ_dna/butt
	accessory_type = /datum/sprite_accessory/butt/plainthighs
	var/butt_size = DEFAULT_BUTT_SIZE

/obj/item/organ/butt/get_icon_cache_key(obj/item/bodypart/bodypart)
	return "[..()]-[butt_size]"

/datum/organ_dna/butt
	var/butt_size = DEFAULT_BUTT_SIZE

/datum/organ_dna/butt/imprint_organ(obj/item/organ/organ)
	..()
	var/obj/item/organ/butt/butt_organ = organ
	butt_organ.butt_size = butt_size
