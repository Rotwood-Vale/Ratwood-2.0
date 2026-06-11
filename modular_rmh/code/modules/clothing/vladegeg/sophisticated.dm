/obj/item/clothing/armor/gambeson/sophisticated_jacket
	name = "雅致夹克"
	desc = "一件设计雅致、剪裁精良的夹克，深受重视品位、身份与得体仪容之人喜爱。"
	icon_state = "jacket"
	item_state = "jacket"
	icon = 'modular_rmh/icons/clothing/vladegeg/sophisticated.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/sophisticated.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/sophisticated_sleeves.dmi'
	slot_flags = ITEM_SLOT_SHIRT | ITEM_SLOT_ARMOR
	dropshrink = null

/obj/item/clothing/armor/gambeson/sophisticated_coat
	name = "雅致大衣"
	desc = "一件剪裁考究、气质内敛优雅的大衣，用以彰显修养、自信与社会地位。"
	icon_state = "coat"
	item_state = "coat"
	icon = 'modular_rmh/icons/clothing/vladegeg/sophisticated.dmi'
	mob_overlay_icon = 'modular_rmh/icons/clothing/vladegeg/onmob/sophisticated.dmi'
	sleeved = 'modular_rmh/icons/clothing/vladegeg/onmob/helpers/sophisticated_sleeves.dmi'
	slot_flags = ITEM_SLOT_ARMOR | ITEM_SLOT_CLOAK
	dropshrink = null

//CRAFTING

/datum/crafting_recipe/roguetown/sewing/sophisticated_jacket
	name = "雅致夹克"
	result = list(/obj/item/clothing/armor/gambeson/sophisticated_jacket)
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/fibers = 2,
				/obj/item/natural/silk = 1)
	tools = list(/obj/item/needle)
	craftdiff = 5
	sellprice = 30

/datum/crafting_recipe/roguetown/leather/sophisticated_coat
	name = "雅致大衣"
	result = /obj/item/clothing/armor/gambeson/sophisticated_coat
	reqs = list(/obj/item/natural/hide/cured = 1,/obj/item/natural/fur = 2)
	craftdiff = 2

//LOADOUT

/datum/loadout_item/sophisticated_jacket
	name = "雅致夹克"
	path = /obj/item/clothing/armor/gambeson/sophisticated_jacket

/datum/loadout_item/sophisticated_coat
	name = "雅致大衣"
	path = /obj/item/clothing/armor/gambeson/sophisticated_coat
