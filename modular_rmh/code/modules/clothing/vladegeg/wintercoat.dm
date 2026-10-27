/obj/item/clothing/suit/roguetown/armor/gambeson/winter_coat
	name = "warm winter coat"
	desc = "A thick, well-crafted winter coat designed to retain heat and protect against harsh cold while remaining comfortable for daily wear."
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
	name = "warm winter coat"
	result = /obj/item/clothing/suit/roguetown/armor/gambeson/winter_coat
	reqs = list(/obj/item/natural/hide/cured = 1,/obj/item/natural/fur = 2)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/winter_coat
	name = "warm winter coat"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/winter_coat
	triumph_cost = 3
