/obj/item/clothing/gloves/roguetown/blacksteel/modern/plategloves
	name = "黑钢板甲护手"
	desc = "以黑钢锻造、采用现代设计的一套板甲护手。"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplategloves"
	item_state = "bplategloves"
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = list(BCLASS_CHOP, BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel

/obj/item/clothing/gloves/roguetown/blacksteel/plategloves
	name = "远古黑钢板甲护手"
	desc = "一套以黑钢锻造的板甲护手。"
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bkgloves"
	item_state = "bkgloves"
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = list(BCLASS_CHOP, BCLASS_CUT, BCLASS_BLUNT, BCLASS_TWIST)
	resistance_flags = FIRE_PROOF
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_SIDE_BLACKSTEEL
	break_sound = 'sound/foley/breaksound.ogg'
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	sewrepair = FALSE
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel
