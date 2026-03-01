/obj/item/clothing/suit/roguetown/armor/corset/colored
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	icon = 'modular_rmh/icons/clothing/armor/corset.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/armor/onmob/corset.dmi'

//CRAFTING

/datum/crafting_recipe/roguetown/leather/corset_colored
	name = "colorable corset"
	result = /obj/item/clothing/suit/roguetown/armor/corset/colored
	reqs = list(/obj/item/natural/hide/cured = 1,
				/obj/item/natural/fibers = 1)
	tools = list(/obj/item/needle)
	sellprice = 15
	craftdiff = 2

//LOADOUT

/datum/loadout_item/corset_colored
	name = "colorable corset"
	path = /obj/item/clothing/suit/roguetown/armor/corset/colored
	triumph_cost = 3
