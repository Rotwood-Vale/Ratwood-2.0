/obj/item/storage/fancy/shhig
	name = "嘘蛇牌香烟"
	desc = "嘘蛇牌香烟，以顺滑入口与复杂风味闻名。来吧……试一根。反正你的寿命本来也不算长。"
	icon = 'icons/roguetown/items/smokebox.dmi'
	icon_state = "smokebox"
	item_state = "smokebox"
	icon_type = "smoke"
	dropshrink = 0.7

	w_class = WEIGHT_CLASS_TINY
	throwforce = 0
	slot_flags = null
	component_type = /datum/component/storage/concrete/grid/zigbox
	populate_contents = list(
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
		/obj/item/clothing/mask/cigarette/rollie/shhig,
	)



/obj/item/storage/fancy/shhig/attack_self(mob_user)
	return

/obj/item/clothing/mask/cigarette/rollie/shhig
	name = "嘘蛇香烟"
	desc = "这支香烟上压着一道小小的蛇形印痕。"
	list_reagents = list(/datum/reagent/drug/nicotine = 30, /datum/reagent/consumable/shhig = 10)

/datum/reagent/consumable/shhig
	name = "嘘蛇特调配方"
	color = "#d3a308"
	taste_description = "层次复杂的辛锐感，以及蜂蜜与毒液的余韵"
