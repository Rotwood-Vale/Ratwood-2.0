/obj/item/clothing/suit/roguetown/armor/gambeson/explorer
	name = "explorer's vest"
	desc = "A dashing outfit for an experienced tomb raider."
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
	name = "explorer's trousers"
	desc = "Hardy yet comfortable leather pants, suited even for hardest field work."
	icon = 'modular_rmh/icons/clothing/vladegeg/explorer.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/explorer.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/explorer_sleeves.dmi'
	icon_state = "pants"
	item_state = "pants"

/obj/item/clothing/head/roguetown/explorer
	name = "explorer's hat"
	desc = "The perfect protection both from heat and things falling on your head."
	icon = 'modular_rmh/icons/clothing/vladegeg/explorer.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/explorer.dmi'
	icon_state = "hat"
	item_state = "hat"
	armor = ARMOR_LEATHER
	sewrepair = TRUE
	salvage_result = /obj/item/natural/hide/cured

//CRAFTING

/datum/crafting_recipe/roguetown/leather/armor/explorer_vest
	name = "explorer's vest"
	result = list(/obj/item/clothing/suit/roguetown/armor/gambeson/explorer)
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 10
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/explorer_pants
	name = "explorer's trousers"
	result = list(/obj/item/clothing/under/roguetown/trou/leather/explorer)
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 10
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/armor/explorer_helmet
	name = "explorer's hat"
	result = list(/obj/item/clothing/head/roguetown/explorer)
	reqs = list(/obj/item/natural/hide/cured = 2)
	sellprice = 10
	craftdiff = 2

//LOADOUT

/datum/loadout_item/explorer_vest
	name = "explorer's vest"
	path = /obj/item/clothing/suit/roguetown/armor/gambeson/explorer
	triumph_cost = 3

/datum/loadout_item/explorer_pants
	name = "explorer's trousers"
	path = /obj/item/clothing/under/roguetown/trou/leather/explorer
	triumph_cost = 3

/datum/loadout_item/explorer_helmet
	name = "explorer's hat"
	path = /obj/item/clothing/head/roguetown/explorer
	triumph_cost = 3
