/obj/item/clothing/suit/roguetown/shirt/desert_sorceress
	name = "沙漠女术士上衣"
	desc = "一件由丝绸与亚麻制成的清凉上衣，为沙漠女术士所穿，既能散热，也不妨碍行动与施法。"
	icon = 'modular_rmh/icons/clothing/vladegeg/desert_sorceress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/desert_sorceress.dmi'
	icon_state = "top"
	item_state = "top"
	nodismemsleeves = TRUE
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	sleevetype = null
	sleeved = null

/obj/item/clothing/under/roguetown/loincloth/desert_sorceress
	name = "沙漠女术士裙"
	desc = "一条轻盈飘逸的裹布裙，深受沙漠女术士喜爱，防护有限，但行动极为自如。"
	icon = 'modular_rmh/icons/clothing/vladegeg/desert_sorceress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/desert_sorceress.dmi'
	icon_state = "skirt"
	item_state = "skirt"
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

/obj/item/clothing/head/roguetown/desert_sorceress
	name = "沙漠女术士兜帽"
	desc = "一顶轻薄的沙漠兜帽，供女术士遮挡烈日与风沙，同时不妨碍面部和视线。"
	icon = 'modular_rmh/icons/clothing/vladegeg/desert_sorceress.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/desert_sorceress.dmi'
	flags_inv = HIDEEARS| HIDEFACE | HIDEHAIR
	icon_state = "hood"
	item_state = "hood"

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/deserts_top
	name = "沙漠女术士上衣"
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1)
	result = /obj/item/clothing/suit/roguetown/shirt/desert_sorceress
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/deserts_skirt
	name = "沙漠女术士裙"
	result = /obj/item/clothing/under/roguetown/loincloth/desert_sorceress
	reqs = list(
		/obj/item/natural/cloth = 2,
		/obj/item/natural/fibers = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/sewing/deserts_hood
	name = "沙漠女术士兜帽"
	result = /obj/item/clothing/head/roguetown/desert_sorceress
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 1)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/deserts_top
	name = "沙漠女术士上衣"
	path = /obj/item/clothing/suit/roguetown/shirt/desert_sorceress

/datum/loadout_item/deserts_skirt
	name = "沙漠女术士裙"
	path = /obj/item/clothing/under/roguetown/loincloth/desert_sorceress

/datum/loadout_item/deserts_hood
	name = "沙漠女术士兜帽"
	path = /obj/item/clothing/head/roguetown/desert_sorceress
