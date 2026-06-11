/obj/item/clothing/suit/roguetown/armor/gambeson/winter_coat
	name = "保暖冬衣"
	desc = "一件厚实且做工精良的冬衣，旨在锁住热量、抵御严寒，同时仍适合日常穿着。"
	icon_state = "wintercoat"
	item_state = "wintercoat"
	icon = 'modular_rmh/icons/clothing/vladegeg/wintercoat.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/wintercoat.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/wintercoat_sleeves.dmi'
	salvage_result = /obj/item/natural/fur
	min_cold_protection_temperature = -40
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR

//CRAFTING

/datum/crafting_recipe/roguetown/leather/winter_coat
	name = "保暖冬衣"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/winter_coat
	reqs = list(/obj/item/natural/hide/cured = 1,/obj/item/natural/fur = 2)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/winter_coat
	name = "保暖冬衣"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/winter_coat
	triumph_cost = 3
