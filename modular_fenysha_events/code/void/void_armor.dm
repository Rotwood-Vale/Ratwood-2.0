/obj/item/clothing/suit/roguetown/armor/plate/voidarmor 
	slot_flags = ITEM_SLOT_ARMOR
	name = "Modular combat spacesuit"
	desc = "A super-durable combat suit made from adaptive materials. \ 
			Violium fibers and energy fabric allow it to absorb kinetic energy. Ultratech technology"
	body_parts_covered = FULL_BODY
	icon_state = "voidcombat"
	item_state = "voidcombat"
	armor = ARMOR_VOIDCOMBAT
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST, BCLASS_PUNCH, BCLASS_BURN, BCLASS_PUNISH, BCLASS_SUNDER)
	resistance_flags = FIRE_PROOF|LAVA_PROOF|ACID_PROOF|FREEZE_PROOF
	nodismemsleeves = FALSE
	max_integrity = 999999
	allowed_sex = list(MALE, FEMALE)
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	pickup_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	equip_sound = 'sound/foley/equip/equip_armor_plate.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/steel
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_HEAVY
	peel_threshold = 4
	smelt_bar_num = 3
