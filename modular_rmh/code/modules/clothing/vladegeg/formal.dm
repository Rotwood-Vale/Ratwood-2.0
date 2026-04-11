/obj/item/clothing/suit/roguetown/shirt/undershirt/blouse
	name = "blouse"
	desc = "A finely tailored blouse made from soft, lightweight fabric, with delicate buttons and subtly decorated cuffs."
	icon_state = "blouse"
	icon = 'modular_rmh/icons/clothing/vladegeg/formal.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/formal.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/formal_sleeves.dmi'
	slot_flags = ITEM_SLOT_SHIRT|ITEM_SLOT_ARMOR

/obj/item/clothing/under/roguetown/skirt/knee
	name = "knee-high skirt"
	desc = "A fitted skirt tailored to follow the line of the legs, narrowing toward the hem."
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
	name = "blouse"
	result = list(/obj/item/clothing/suit/roguetown/shirt/undershirt/blouse)
	reqs = list(/obj/item/natural/cloth = 3,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/sewing/skirt_knee
	name = "knee-high skirt"
	result = list(/obj/item/clothing/under/roguetown/skirt/knee)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10

/datum/crafting_recipe/roguetown/sewing/skirt_knee_colored
	name = "knee-high skirt (colorable)"
	result = list(/obj/item/clothing/under/roguetown/skirt/knee/colored)
	reqs = list(/obj/item/natural/cloth = 1,
				/obj/item/natural/fibers = 2)
	tools = list(/obj/item/needle)
	craftdiff = 2
	sellprice = 10

//LOADOUT

/datum/loadout_item/blouse
	name = "blouse"
	path = /obj/item/clothing/suit/roguetown/shirt/undershirt/blouse

/datum/loadout_item/skirt_knee
	name = "knee-high skirt"
	path = /obj/item/clothing/under/roguetown/skirt/knee

/datum/loadout_item/skirt_knee_colored
	name = "knee-high skirt (colorable)"
	path = /obj/item/clothing/under/roguetown/skirt/knee/colored
