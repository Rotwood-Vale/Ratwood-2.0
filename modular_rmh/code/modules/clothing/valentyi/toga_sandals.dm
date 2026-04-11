/obj/item/clothing/shoes/toga_sandals
	name = "fancy sandals"
	desc = "Delicate sandals of gleaming leather, their slender straps rising in graceful spirals to embrace the ankle."
	gender = PLURAL
	icon = 'modular_rmh/icons/clothing/valentyi/toga_sandals.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/valentyi/onmob/toga_sandals.dmi'
	icon_state = "toga_sandals"
	item_state = "toga_sandals"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

//CRAFTING

/datum/crafting_recipe/roguetown/leather/footwear/toga_sandals
	name = "fancy sandals"
	result = /obj/item/clothing/shoes/toga_sandals
	reqs = list(/obj/item/natural/hide/cured = 1)

//SUPPLY PACKS

/datum/supply_pack/rogue/wardrobe/suits/toga_sandals
	name = "Fancy Sandals"
	cost = 15
	contains = list(
					/obj/item/clothing/shoes/toga_sandals,
				)

//LOADOUT

/datum/loadout_item/toga_sandals
	name = "Fancy Sandals"
	path = /obj/item/clothing/shoes/toga_sandals
