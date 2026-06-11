/obj/item/clothing/suit/roguetown/shirt/robe/skyrim_mage
	name = "法师长袍"
	desc = "法师们偏爱的长袍，样式朴素却织工精细。布料轻便、保暖而实用。"
	icon_state = "mage"
	icon = 'modular_rmh/icons/clothing/vladegeg/skyrim_mage.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/skyrim_mage.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/skyrim_mage_sleeves.dmi'
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/skyrim_mage
	name = "法师长袍"
	result = list(/obj/item/clothing/suit/roguetown/shirt/robe/skyrim_mage)
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/skyrim_mage
	name = "法师长袍"
	path = /obj/item/clothing/suit/roguetown/shirt/robe/skyrim_mage
