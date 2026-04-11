/obj/item/clothing/shirt/dress/courtesan
	name = "courtesan dress"
	desc = "A radiant yellow silk dress, fitted at the waist and flowing below. Light and elegant."
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "dress"
	icon = 'modular_rmh/icons/clothing/vladegeg/courtesan.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/courtesan.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/courtesan_sleeves.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/courtesan
	name = "courtesan dress"
	result = /obj/item/clothing/shirt/dress/courtesan
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 30

//LOADOUT

/datum/loadout_item/dress/courtesan
	name = "Courtesan Dress"
	path = /obj/item/clothing/shirt/dress/courtesan
