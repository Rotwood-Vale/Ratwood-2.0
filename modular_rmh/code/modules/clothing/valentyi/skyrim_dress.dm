//light blue dress

/obj/item/clothing/shirt/dress/skyrim_dress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "light blue dress"
	desc = "A simple light blue dress, tailored to flatter the figure."
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEBOOB|HIDECROTCH
	icon = 'modular_rmh/icons/clothing/valentyi/skyrim_dress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/valentyi/onmob/skyrim_dress.dmi'

	icon_state = "dress"
	item_state = "dress"
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

//salad green dress

/obj/item/clothing/shirt/dress/hw_dress
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "salad green dress"
	desc = "A simple light green dress, tailored to flatter the figure."
	body_parts_covered = CHEST|GROIN
	flags_inv = HIDEBOOB|HIDECROTCH
	icon = 'modular_rmh/icons/clothing/valentyi/skyrim_dress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/valentyi/onmob/skyrim_dress.dmi'

	icon_state = "hdress"
	item_state = "hdress"
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/skyrim_dress
	name = "light blue dress"
	result = list(/obj/item/clothing/shirt/dress/skyrim_dress)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/hw_dress
	name = "light green dress"
	result = list(/obj/item/clothing/shirt/dress/hw_dress)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

//SUPPLY PACKS

/datum/supply_pack/rogue/wardrobe/suits/skyrim_dress
	name = "Light Blue Dress"
	cost = 15
	contains = list(
					/obj/item/clothing/shirt/dress/skyrim_dress,
				)

/datum/supply_pack/rogue/wardrobe/suits/hw_dress
	name = "Light Green Dress"
	cost = 15
	contains = list(
					/obj/item/clothing/shirt/dress/hw_dress,
				)

//LOADOUT

/datum/loadout_item/skyrim_dress
	name = "Light Blue Dress"
	path = /obj/item/clothing/shirt/dress/skyrim_dress

/datum/loadout_item/hw_dress
	name = "Light Green Dress"
	path = /obj/item/clothing/shirt/dress/hw_dress
