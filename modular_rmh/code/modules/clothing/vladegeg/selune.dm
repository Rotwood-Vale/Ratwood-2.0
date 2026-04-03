/obj/item/clothing/suit/roguetown/shirt/robe/selune
	name = "moon robe"
	desc = "A moon-silver robe."
	icon_state = "selune"
	icon = 'modular_rmh/icons/clothing/vladegeg/selune.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/selune.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/selune_sleeves.dmi'
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/selune
	name = "moon robe"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/selune)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/selune
	name = "moon robe"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/selune
