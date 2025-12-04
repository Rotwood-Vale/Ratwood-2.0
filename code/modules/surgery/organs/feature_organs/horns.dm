/obj/item/organ/horns
	name = "horns"
	desc = "A severed pair of horns. What did you cut this off of?"
	icon_state = "severedtail" //placeholder
	visible_organ = TRUE
	zone = BODY_ZONE_HEAD
	slot = ORGAN_SLOT_HORNS
	alchemy_effects = list(EFFECT_FORTIFY_STRENGTH, EFFECT_DAMAGE_BRUTE, EFFECT_FORTIFY_ENDURANCE, EFFECT_WEAKEN_PERCEPTION)

/obj/item/organ/horns/humanoid

/obj/item/organ/horns/halforc
	name = "halforc horns"
	accessory_type = /datum/sprite_accessory/horns/halforc
