/obj/item/organ/soul
	name = "soul"
	desc = "You're holding their soul, somehow."
	icon_state = ""
	visible_organ = TRUE
	slot = ORGAN_SLOT_SOUL
	organ_flags = ORGAN_SURGERY_HIDDEN | ORGAN_INTERNAL_ONLY
	alchemy_effects = list(EFFECT_RESTORE_DEVOTION, EFFECT_MAGIC_RESIST, EFFECT_RESTORE_MANA, EFFECT_DRAIN_DEVOTION)

/obj/item/organ/soul/fire
	name = "soul fire"
	accessory_type =  /datum/sprite_accessory/soul/fire
