/obj/item/clothing/armor/gambeson/sophisticated_jacket
	name = "sophisticated jacket"
	desc = "A finely tailored jacket of sophisticated design, favored by those who value refinement, status, and impeccable presentation."
	icon_state = "jacket"
	item_state = "jacket"
	icon = 'modular_rmh/icons/clothing/vladegeg/sophisticated.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/sophisticated.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/sophisticated_sleeves.dmi'
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR

/obj/item/clothing/armor/gambeson/sophisticated_coat
	name = "sophisticated coat"
	desc = "A sophisticated coat of fine tailoring and subtle elegance, worn to project refinement, confidence, and social standing."
	icon_state = "coat"
	item_state = "coat"
	icon = 'modular_rmh/icons/clothing/vladegeg/sophisticated.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/sophisticated.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/sophisticated_sleeves.dmi'
	slot_flags = ITEM_SLOT_ARMOR | ITEM_SLOT_CLOAK

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/sophisticated_jacket
	name = "sophisticated jacket"
	result = list(/obj/item/clothing/armor/gambeson/sophisticated_jacket)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/leather/sophisticated_coat
	name = "sophisticated coat"
	result = /obj/item/clothing/armor/gambeson/sophisticated_coat
	reqs = list(/obj/item/natural/hide/cured = 1,/obj/item/natural/fur = 2)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/sophisticated_jacket
	name = "sophisticated jacket"
	path = /obj/item/clothing/armor/gambeson/sophisticated_jacket

/datum/loadout_item/sophisticated_coat
	name = "sophisticated coat"
	path = /obj/item/clothing/armor/gambeson/sophisticated_coat
