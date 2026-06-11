// Design wise, I want to gate this behind high cooking skills role who can wrap their food and provide a convenient source of
// Stats-boosting food for adventurers / other alike. Currently there's very few good preserved food items that also give foodbuffs.
// This is a flavorful way to provide more reasons for adventurers to buy from innkeep instead of doing their own raisins.
// FOR GODS SAKE DO NOT GIVE THIS ROUNDSTART TO ANYONE BUT INNKEEP ON MAP.
/obj/item/ration // Ration. Sprites and Concept by Pintlewaiver.
	name = "口粮包裹纸"
	desc = "一张涂有薄薄油脂的纸，用于包裹食物，以便在长途旅行中保存食物。\
	最终的口粮大小取决于原始食物的体积。只要食物被包裹着，就能保持新鲜。"
	icon = 'modular/Neu_food/icons/cookware/ration.dmi'
	icon_state = "ration_wrapper"
	w_class = WEIGHT_CLASS_TINY
	grid_height = 32
	grid_width = 32
	dropshrink = 0.6
	var/obj/item/reagent_containers/food/snacks/food = null // The food item wrapped in the ration

/obj/item/ration/attackby(obj/item/I, mob/user)
	. = ..()
	if(istype(I, /obj/item/reagent_containers/food/snacks))
		var/obj/item/reagent_containers/food/snacks/F = I
		if(food)
			to_chat(user, span_warning("[src]中已经包裹了其他物品。"))
			return
		if(do_after(user, 2 SECONDS, target = src))
			user.transferItemToLoc(F, src)
			food = I
			to_chat(user, span_notice("你用口粮包装纸包裹了[F]。"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			F.rotprocess = null
			if(I.w_class >= WEIGHT_CLASS_NORMAL)
				name = "大型口粮包（[food.name]）"
				desc = "一个包含[food.name]的大型口粮包。"
				icon_state = "ration_large"
				dropshrink = 1
				// No need to change grid size cuz cakes are 1x1 huh??
			else
				name = "小型口粮包（[food.name]）"
				desc = "一个包含[food.name]的小型口粮包。"
				icon_state = "ration_small"
				dropshrink = 1
			update_icon()

/obj/item/ration/attack_self(mob/user)
	. = ..()
	if(food)
		if(do_after(user, 2 SECONDS, target = src))
			to_chat(user, span_notice("你从口粮包装中拆开了[food]。"))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			var/obj/item/reagent_containers/food/snacks/F = food
			user.put_in_hands(F)
			F.update_icon()
			F.rotprocess = initial(F.rotprocess)
			food = null
			qdel(src) // No reusing wrapper
