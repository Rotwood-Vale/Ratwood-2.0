/obj/item/clothing/suit/roguetown/shirt/undershirt/blouse
	name = "女式衬衫"
	desc = "一件剪裁精致的女式衬衫，由柔软轻盈的布料制成，配有精巧纽扣与低调装饰的袖口。"
	icon_state = "blouse"
	icon = 'modular_rmh/icons/clothing/vladegeg/formal.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/formal.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/formal_sleeves.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR

/obj/item/clothing/under/roguetown/skirt/knee
	name = "及膝裙"
	desc = "一条贴合腿部线条裁制的合身裙摆，向下逐渐收窄至裙边。"
	icon = 'modular_rmh/icons/clothing/vladegeg/formal.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/formal.dmi'
	icon_state = "skirt"
	item_state = "skirt"
	nodismemsleeves = TRUE
	sleevetype = null
	sleeved = null

/obj/item/clothing/under/roguetown/skirt/knee/colored
	icon_state = "skirt_color"
	item_state = "skirt_color"

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/blouse
	name = "女式衬衫"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/blouse)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/skirt_knee
	name = "及膝裙"
	result = list(/obj/item/clothing/under/roguetown/skirt/knee)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/skirt_knee_colored
	name = "及膝裙（可染色）"
	result = list(/obj/item/clothing/under/roguetown/skirt/knee/colored)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10

//LOADOUT

/datum/loadout_item/blouse
	name = "女式衬衫"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/blouse

/datum/loadout_item/skirt_knee
	name = "及膝裙"
	path = /obj/item/clothing/under/roguetown/skirt/knee

/datum/loadout_item/skirt_knee_colored
	name = "及膝裙（可染色）"
	path = /obj/item/clothing/under/roguetown/skirt/knee/colored
