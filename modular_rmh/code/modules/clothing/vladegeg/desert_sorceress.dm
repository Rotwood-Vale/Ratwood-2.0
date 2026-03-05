/obj/item/clothing/shirt/undershirt/desert_sorceress
	name = "desert sorceress top"
	desc = "A revealing silk-and-linen top worn by desert sorceresses, designed to keep the body cool while allowing unrestricted movement and spellcasting."
	icon = 'modular_rmh/icons/clothing/vladegeg/desert_sorceress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/desert_sorceress.dmi'
	icon_state = "top"
	item_state = "top"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	sleevetype = null
	sleeved = null

/obj/item/clothing/under/roguetown/loincloth/desert_sorceress
	name = "desert sorceress skirt"
	desc = "A light, flowing skirt of wrapped cloth favored by desert sorceresses, offering minimal protection but excellent freedom of movement."
	icon = 'modular_rmh/icons/clothing/vladegeg/desert_sorceress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/desert_sorceress.dmi'
	icon_state = "skirt"
	item_state = "skirt"
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

/obj/item/clothing/head/roguetown/desert_sorceress
	name = "desert sorceress hood"
	desc = "A thin desert hood worn by sorceresses to shield against sun and sand while leaving the face and eyes unobstructed."
	icon = 'modular_rmh/icons/clothing/vladegeg/desert_sorceress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/desert_sorceress.dmi'
	flags_inv = HIDEEARS| HIDEFACE | HIDEHAIR
	icon_state = "hood"
	item_state = "hood"

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/deserts_top
	name = "desert sorceress top"
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1)
	result = /obj/item/clothing/shirt/undershirt/desert_sorceress
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/deserts_skirt
	name = "desert sorceress skirt"
	result = /obj/item/clothing/under/roguetown/loincloth/desert_sorceress
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/deserts_hood
	name = "desert sorceress hood"
	result = /obj/item/clothing/head/roguetown/desert_sorceress
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/deserts_top
	name = "desert sorceress top"
	path = /obj/item/clothing/shirt/undershirt/desert_sorceress

/datum/loadout_item/deserts_skirt
	name = "desert sorceress skirt"
	path = /obj/item/clothing/under/roguetown/loincloth/desert_sorceress

/datum/loadout_item/deserts_hood
	name = "desert sorceress hood"
	path = /obj/item/clothing/head/roguetown/desert_sorceress
