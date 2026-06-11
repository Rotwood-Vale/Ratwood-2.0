/obj/item/clothing/under/roguetown/platelegs/blacksteel/modern
	name = "黑钢板甲腿铠"
	desc = "以耐用黑钢锻造、采用现代设计的加固腿甲。"
	gender = PLURAL
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	sleeved = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bplatelegs"
	item_state = "bplatelegs"
	sewrepair = FALSE
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_LEG_BLACKSTEEL
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel
	smelt_bar_num = 2
	dropshrink = 0.7

/obj/item/clothing/under/roguetown/platelegs/blacksteel
	name = "远古黑钢板甲腿铠"
	desc = "以耐用黑钢锻造的加固腿甲。"
	gender = PLURAL
	icon = 'icons/roguetown/clothing/special/blkknight.dmi'
	mob_overlay_icon = 'icons/roguetown/clothing/special/onmob/blkknight.dmi'
	icon_state = "bklegs"
	item_state = "bklegs"
	sewrepair = FALSE
	armor = ARMOR_PLATE_BSTEEL
	prevent_crits = list(BCLASS_CUT, BCLASS_STAB, BCLASS_CHOP, BCLASS_BLUNT)
	blocksound = PLATEHIT
	max_integrity = ARMOR_INT_LEG_BLACKSTEEL
	drop_sound = 'sound/foley/dropsound/armor_drop.ogg'
	anvilrepair = /datum/skill/craft/armorsmithing
	smeltresult = /obj/item/ingot/blacksteel
	smelt_bar_num = 2
	dropshrink = null
