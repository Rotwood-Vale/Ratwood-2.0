/obj/item/clothing/suit/roguetown/armor/gambeson/explorer
	name = "探险者背心"
	desc = "一件适合老练墓穴探险者的潇洒装束。"
	armor = ARMOR_LEATHER
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "vest"
	item_state = "vest"
	icon = 'modular_rmh/icons/clothing/vladegeg/explorer.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/explorer.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/explorer_sleeves.dmi'

/obj/item/clothing/armor/gambeson/explorer/update_icon()
	. = ..()

/obj/item/clothing/under/roguetown/trou/leather/explorer
	name = "探险者长裤"
	desc = "结实却舒适的皮裤，即使最艰苦的野外工作也能胜任。"
	icon = 'modular_rmh/icons/clothing/vladegeg/explorer.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/explorer.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/explorer_sleeves.dmi'
	icon_state = "pants"
	item_state = "pants"

/obj/item/clothing/head/roguetown/explorer
	name = "探险者帽"
	desc = "既能遮阳，又能防止东西砸到头上的理想防护。"
	icon = 'modular_rmh/icons/clothing/vladegeg/explorer.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/explorer.dmi'
	icon_state = "hat"
	item_state = "hat"
	armor = ARMOR_LEATHER
	sewrepair = TRUE
	salvage_result = /obj/item/natural/hide/cured

//CRAFTING

/datum/crafting_recipe/roguetown/leather/armor/explorer_vest
	name = "探险者背心"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/explorer)
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 10
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/explorer_pants
	name = "探险者长裤"
	result = list(/obj/item/clothing/under/roguetown/trou/leather/explorer)
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 10
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/explorer_helmet
	name = "探险者帽"
	result = list(/obj/item/clothing/head/roguetown/explorer)
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 10
	craftdiff = 2

//LOADOUT

/datum/loadout_item/explorer_vest
	name = "探险者背心"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/explorer
	triumph_cost = 3

/datum/loadout_item/explorer_pants
	name = "探险者长裤"
	path = /obj/item/clothing/under/roguetown/trou/leather/explorer
	triumph_cost = 3

/datum/loadout_item/explorer_helmet
	name = "探险者帽"
	path = /obj/item/clothing/head/roguetown/explorer
	triumph_cost = 3
