//light blue dress

/obj/item/clothing/suit/roguetown/shirt/dress/skyrim_dress
	name = "浅蓝色长裙"
	desc = "一件简洁的浅蓝色长裙，剪裁用以衬托身形。"
	body_parts_covered = CHEST|GROIN
	icon = 'modular_rmh/icons/clothing/valentyi/skyrim_dress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/valentyi/onmob/skyrim_dress.dmi'

	icon_state = "dress"
	item_state = "dress"
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

//salad green dress

/obj/item/clothing/suit/roguetown/shirt/dress/hw_dress
	name = "浅绿色长裙"
	desc = "一件简洁的浅绿色长裙，剪裁用以衬托身形。"
	body_parts_covered = CHEST|GROIN
	icon = 'modular_rmh/icons/clothing/valentyi/skyrim_dress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/valentyi/onmob/skyrim_dress.dmi'

	icon_state = "hdress"
	item_state = "hdress"
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/skyrim_dress
	name = "浅蓝色长裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/skyrim_dress)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/hw_dress
	name = "浅绿色长裙"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/hw_dress)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

//SUPPLY PACKS

/datum/supply_pack/rogue/wardrobe/suits/skyrim_dress
	name = "浅蓝色长裙"
	cost = 15
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/skyrim_dress,
				)

/datum/supply_pack/rogue/wardrobe/suits/hw_dress
	name = "浅绿色长裙"
	cost = 15
	contains = list(
					/obj/item/clothing/suit/roguetown/shirt/dress/hw_dress,
				)

//LOADOUT

/datum/loadout_item/skyrim_dress
	name = "浅蓝色长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/skyrim_dress

/datum/loadout_item/hw_dress
	name = "浅绿色长裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/hw_dress
