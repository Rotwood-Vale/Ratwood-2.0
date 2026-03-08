/obj/item/clothing/shoes/roguetown/heels
	name = "black heels"	//Goes well with maids, nobles and desert sorceress outfit. I was planning to port the sound system later as well - Gardelin0
	desc = "High heels that lift the wearer above the filth. Don't trip."
	icon = 'modular_rmh/icons/clothing/vladegeg/heels.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/heels.dmi'
	icon_state = "heels"
	item_state = "heels"

/obj/item/clothing/shoes/roguetown/heels/color
	name = "heels"
	icon_state = "heels_color"
	item_state = "heels_color"

//CRAFTING

/datum/crafting_recipe/roguetown/leather/footwear/boots/heels
	name = "black heels"
	result = /obj/item/clothing/shoes/roguetown/heels
	reqs = list(/obj/item/natural/hide/cured = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/leather/footwear/boots/heels_color
	name = "colorable heels"
	result = /obj/item/clothing/shoes/roguetown/heels/color
	reqs = list(/obj/item/natural/hide/cured = 1)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/heels
	name = "black heels"
	path = /obj/item/clothing/shoes/roguetown/heels
	triumph_cost = 2

/datum/loadout_item/heels_color
	name = "colorable heels"
	path = /obj/item/clothing/shoes/roguetown/heels/color
	triumph_cost = 2
