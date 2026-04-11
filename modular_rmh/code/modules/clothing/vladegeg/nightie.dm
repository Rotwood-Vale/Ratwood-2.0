/obj/item/clothing/suit/roguetown/shirt/dress/gen/nightgown
	name = "nightgown"
	desc = "An elegant and enticing nightgown, made for comfort and allure."
	body_parts_covered = null
	flags_inv = HIDECROTCH|HIDEBOOB
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR
	icon = 'modular_rmh/icons/clothing/vladegeg/nightie.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/nightie.dmi'
	sleeved = null
	sleevetype = null
	icon_state = "dress"
	item_state = "dress"

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/nightgown
	name = "nightgown"
	result = list(/obj/item/clothing/suit/roguetown/shirt/dress/gen/nightgown)
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	craftdiff = 3
	sellprice = 15

//LOADOUT

/datum/loadout_item/nightgown
	name = "nightgown"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/gen/nightgown
