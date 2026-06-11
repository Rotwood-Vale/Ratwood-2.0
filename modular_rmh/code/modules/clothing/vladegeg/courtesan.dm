/obj/item/clothing/suit/roguetown/shirt/dress/courtesan
	name = "交际花礼裙"
	desc = "一件明艳的黄色丝绸长裙，腰身贴合，裙摆垂坠。轻盈而优雅。"
	body_parts_covered = CHEST|GROIN|ARMS|VITALS
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR
	icon_state = "dress"
	icon = 'modular_rmh/icons/clothing/vladegeg/courtesan.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/courtesan.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/courtesan_sleeves.dmi'
	flags_inv = HIDECROTCH|HIDEBOOB

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/courtesan
	name = "交际花礼裙"
	result = /obj/item/clothing/suit/roguetown/shirt/dress/courtesan
	reqs = list(/obj/item/natural/cloth = 4,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 4
	sellprice = 30

//LOADOUT

/datum/loadout_item/dress/courtesan
	name = "交际花礼裙"
	path = /obj/item/clothing/suit/roguetown/shirt/dress/courtesan
