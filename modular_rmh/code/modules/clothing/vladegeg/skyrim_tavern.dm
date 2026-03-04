/obj/item/clothing/shirt/dress/skyrim_taven
	slot_flags = ITEM_SLOT_ARMOR|ITEM_SLOT_SHIRT
	name = "waitress dress"
	desc = "A simple green dress with a corset, its skirt has slits for easy movement."
	body_parts_covered = CHEST|GROIN|VITALS
	icon = 'modular_rmh/icons/clothing/vladegeg/skyrim_tavern.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/skyrim_tavern.dmi'

	icon_state = "tavern"
	item_state = "tavern"
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/skyrim_taven
	name = "waitress dress"
	result = /obj/item/clothing/shirt/dress/skyrim_taven
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 3
	sellprice = 20

//LOADOUT

/datum/loadout_item/dress/skyrim_taven
	name = "waitress dress"
	path = /obj/item/clothing/shirt/dress/skyrim_taven
