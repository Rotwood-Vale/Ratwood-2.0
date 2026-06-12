/* .............   RICE   ................ */
/obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked
	name = "熟米饭"
	desc = "朴素的熟米饭，是许多文化中的主食。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "米饭香"
	faretype = FARE_POOR
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/preserved/rice_cooked/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在准备一份牛肉盖饭……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/ricebeef(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在准备一份猪肉盖饭……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/ricepork(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/fryfish/shrimp))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在准备一份虾仁盖饭……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/riceshrimp(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在准备一份禽肉盖饭……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/ricebird(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在把奶酪铺到米饭上……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/ricecheese(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在把鸡蛋打到米饭上……")
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/riceegg(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()



/*	.................   Rice & pork  ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricepork
	name = "猪肉拌饭"
	tastes = list("米饭香" = 1, "猪肉香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "米饭拌着肥猪肉。"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricepork"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/ricepork/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在准备一份猪肉饭套餐……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/riceporkcuc(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/*	.................   Rice & pork & cucumbers ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceporkcuc
	name = "猪肉饭套餐"
	tastes = list("米饭香" = 1, "猪肉香" = 1, "鲜黄瓜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	desc = "米饭拌着肥猪肉和新鲜黄瓜。"
	bitesize = 5
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceporkmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & beef ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebeef
	name = "牛肉拌饭"
	tastes = list("米饭香" = 1, "牛排香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "米饭拌着牛排肉。"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebeef"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/ricebeef/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在准备一份牛肉饭套餐……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/ricebeefcar(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/*	.................   Rice & beef & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebeefcar
	name = "牛肉饭套餐"
	tastes = list("米饭香" = 1, "牛排香" = 1, "胡萝卜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	desc = "米饭拌着牛排肉和胡萝卜。"
	bitesize = 5
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebeefmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & shrimp ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceshrimp
	name = "虾仁拌饭"
	tastes = list("米饭香" = 1, "虾仁香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "米饭拌着虾仁。"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceshrimp"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/riceshrimp/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在准备一份虾仁饭套餐……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/*	.................   Rice & shrimp & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceshrimpcar
	name = "虾仁饭套餐"
	tastes = list("米饭香" = 1, "虾仁香" = 1, "胡萝卜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	desc = "米饭拌着虾仁和胡萝卜。"
	bitesize = 5
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceshrimpmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & bird ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebird
	name = "禽肉拌饭"
	tastes = list("米饭香" = 1, "鲜美禽肉香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "米饭拌着炸禽肉。"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebird"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/ricebird/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在准备一份禽肉饭套餐……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/ricebirdcar(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/*	.................   Rice & bird & carrots ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricebirdcar
	name = "禽肉饭套餐"
	tastes = list("米饭香" = 1, "鲜美禽肉香" = 1, "胡萝卜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	desc = "米饭拌着炸禽肉和胡萝卜。"
	bitesize = 5
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricebirdmeal"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Rice & egg ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceegg
	name = "蛋拌饭"
	tastes = list("米饭香" = 1, "鸡蛋香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "米饭拌着鸡蛋。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceegg"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/riceegg/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在把奶酪铺到米饭上……")
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/*	.................   Rice & cheese ................... */
/obj/item/reagent_containers/food/snacks/rogue/ricecheese
	name = "奶酪拌饭"
	tastes = list("米饭香" = 1, "奶酪香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	desc = "米饭上覆着一层融化奶酪。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "ricecheese"
	faretype = FARE_FINE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff

/obj/item/reagent_containers/food/snacks/rogue/ricecheese/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			to_chat(user, "正在把鸡蛋打到奶酪米饭上……")
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/riceeggcheese(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/*	.................   Rice & egg & cheese ................... */
/obj/item/reagent_containers/food/snacks/rogue/riceeggcheese
	name = "鸡蛋奶酪饭"
	tastes = list("米饭香" = 1, "奶酪香" = 1, "鸡蛋香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	desc = "米饭拌着鸡蛋，上面覆着一层融化奶酪。"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_rice.dmi'
	icon_state = "riceeggcheese"
	faretype = FARE_LAVISH
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatmealbuff
