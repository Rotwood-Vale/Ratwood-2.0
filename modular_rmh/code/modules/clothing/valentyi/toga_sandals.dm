/obj/item/clothing/shoes/roguetown/sandals/toga_sandals
	name = "精致凉鞋"
	desc = "一双以闪亮皮革制成的精致凉鞋，纤细鞋带优雅盘绕，贴合脚踝。"
	icon = 'modular_rmh/icons/clothing/valentyi/toga_sandals.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/valentyi/onmob/toga_sandals.dmi'
	icon_state = "toga_sandals"
	item_state = "toga_sandals"
	salvage_result = /obj/item/natural/hide/cured
	salvage_amount = 1

//CRAFTING

/datum/crafting_recipe/roguetown/leather/footwear/toga_sandals
	name = "精致凉鞋"
	result = /obj/item/clothing/shoes/roguetown/sandals/toga_sandals
	reqs = list(/obj/item/natural/hide/cured = 1)

//SUPPLY PACKS

/datum/supply_pack/rogue/wardrobe/suits/toga_sandals
	name = "精致凉鞋"
	cost = 15
	contains = list(
					/obj/item/clothing/shoes/roguetown/sandals/toga_sandals,
				)

//LOADOUT

/datum/loadout_item/toga_sandals
	name = "精致凉鞋"
	path = /obj/item/clothing/shoes/roguetown/sandals/toga_sandals
