/obj/item/clothing/suit/roguetown/armor/leather/druid
	name = "德鲁伊护甲"
	desc = "这件护甲由鞣制皮革、鲜活橡树皮与编织树叶精心叠制而成。柔韧却坚实，承载着森林静谧的力量。"

	icon = 'modular_rmh/icons/clothing/vladegeg/armor/druid.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/armor/onmob/druid.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/armor/onmob/helpers/druid_sleeves.dmi'

	icon_state = "druid"
	item_state = "druid"
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR
	salvage_result = /obj/item/natural/hide/cured

/obj/item/clothing/suit/roguetown/armor/leather/druid/loadout
	name = "德鲁伊护甲"

//CRAFTING

/datum/crafting_recipe/roguetown/leather/druid
	name = "德鲁伊护甲"
	result = /obj/item/clothing/suit/roguetown/armor/leather/druid
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/natural/hide/cured = 2)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/druid
	name = "德鲁伊护甲"
	path = /obj/item/clothing/suit/roguetown/armor/leather/druid/loadout
	triumph_cost = 3
