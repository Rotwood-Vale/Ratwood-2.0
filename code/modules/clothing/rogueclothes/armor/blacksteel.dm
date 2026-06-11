//--------------- BLACKSTEEL ---------------------

/obj/item/clothing/suit/roguetown/armor/plate/modern/blacksteel_full_plate
	name = "黑钢板甲"
	desc = "以坚固黑钢锻造的全身板甲。采用现代设计，在穿刺与钝击防护上仍凌驾于同类重甲之上。"
	body_parts_covered = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplate"
	item_state = "bplate"
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	armor = ARMOR_PLATE_BSTEEL
	allowed_race = CLOTHED_RACES_TYPES
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	equip_delay_self = 12 SECONDS
	unequip_delay_self = 12 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	smelt_bar_num = 4

/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_full_plate
	name = "远古黑钢板甲"
	desc = "以坚固黑钢锻造的全身板甲，内里衬有分层绗缝护甲衣，在穿刺与钝击防护上无与伦比。"
	body_parts_covered = COVERAGE_FULL
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkarmor"
	item_state = "bkarmor"
	armor = ARMOR_PLATE_BSTEEL
	allowed_race = CLOTHED_RACES_TYPES
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	equip_delay_self = 12 SECONDS
	unequip_delay_self = 12 SECONDS
	equip_delay_other = 3 SECONDS
	strip_delay = 6 SECONDS
	smelt_bar_num = 4

/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_half_plate	//This is a cuirass
	name = "黑钢胸甲"
	desc = "由黑钢锻造的基础胸甲。它比普通钢材稍微耐用一些。"
	body_parts_covered = COVERAGE_TORSO
	icon_state = "grenzelcuirass"
	item_state = "grenzelcuirass"
	sleeved = 'icons/roguetown/clothing/onmob/helpers/stonekeep_merc.dmi'
	allowed_race = CLOTHED_RACES_TYPES
	blocking_behavior = null
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	smeltresult = /obj/item/ingot/blacksteel
	armor_class = ARMOR_CLASS_MEDIUM
	smelt_bar_num = 2

/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_halfplate
	slot_flags = ITEM_SLOT_ARMOR
	name = "黑钢半身板甲"
	desc = "一套异常坚固的黑钢护甲，配有肩甲，可保护胸部、手臂与腹股沟。"
	body_parts_covered = COVERAGE_ALL_BUT_LEGS
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT, BCLASS_TWIST)
	icon = 'icons/roguetown/clothing/armor.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/onmob/armor.dmi'
	icon_state = "bhalfplate"
	item_state = "bhalfplate"
	armor = ARMOR_PLATE_BSTEEL
	max_integrity = ARMOR_INT_CHEST_PLATE_BLACKSTEEL
	allowed_race = CLOTHED_RACES_TYPES
	nodismemsleeves = TRUE
	blocking_behavior = null
	smeltresult = /obj/item/ingot/blacksteel
	equip_delay_self = 4 SECONDS
	unequip_delay_self = 4 SECONDS
	armor_class = ARMOR_CLASS_HEAVY

/obj/item/clothing/suit/roguetown/armor/plate/blacksteel_halfplate/ancient
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bs_halfplate"
	item_state = "bs_halfplate"
