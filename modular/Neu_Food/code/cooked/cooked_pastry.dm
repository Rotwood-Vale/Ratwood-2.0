// For definition - any non-bread premium product dough that is also not a cake.
/*	.................   Pastry   ................... */
/obj/item/reagent_containers/food/snacks/rogue/pastry
	name = "酥点"
	desc = "酥脆、黄油香浓、层层起酥，令人愉悦。深受孩子和嗜甜者喜爱。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "pastry"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	tastes = list("酥脆黄油面皮" = 1)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw
	name = "生葡萄干饼干"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "biscuit_raw"
	color = "#ecce61"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/biscuit
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/biscuit
	name = "葡萄干饼干"
	desc = "一块酥脆的黄油酥点，里面有有嚼劲的葡萄干。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "biscuit"
	faretype = FARE_POOR
	filling_color = "#F0E68C"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION + SNACK_POOR)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	tastes = list("酥脆黄油面皮" = 1, "葡萄干香" = 1)
	eat_effect = /datum/status_effect/buff/snackbuff

// MISSING RECIPE
/obj/item/reagent_containers/food/snacks/rogue/cookie		//It's a biscuit.......
	name = "微笑饼干"
	desc = "看起来不像开心的笑脸，更像痛苦扭曲的表情。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "cookie"
	color = "#ecce61"
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw
	name = "生椒盐卷饼"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "prezzel_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/prezzel
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null

/obj/item/reagent_containers/food/snacks/rogue/prezzel
	name = "椒盐卷饼"
	desc = "仅次于切片面包的好东西。它的配方在矮人间是严守的秘密；他们对此执着到就连审判庭最痛苦的手段也撬不开口。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "prezzel"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	faretype = FARE_FINE
	tastes = list("酥脆黄油面皮" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw
	name = "生手馅饼"
	desc = "进烤炉吧！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "handpie_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	w_class = WEIGHT_CLASS_NORMAL
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/mushroom
	name = "生蘑菇手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	foodtype = GRAIN | VEGETABLES
	tastes = list("蘑菇香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish
	name = "生鱼肉手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	foodtype = GRAIN | MEAT
	tastes = list("鱼肉香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat
	name = "生肉手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	foodtype = GRAIN | MEAT
	tastes = list("肉香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/crab
	name = "生蟹肉手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	foodtype = GRAIN | MEAT
	tastes = list("蟹肉香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry
	name = "生浆果手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	foodtype = GRAIN | FRUIT
	tastes = list("浆果香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/poison
	name = "生浆果手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	list_reagents = list(/datum/reagent/berrypoison = 5)
	foodtype = GRAIN | FRUIT
	tastes = list("苦涩浆果香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/apple
	name = "生苹果手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	foodtype = GRAIN | FRUIT
	tastes = list("苹果香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/potato
	name = "生土豆手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	foodtype = GRAIN | VEGETABLES
	tastes = list("土豆香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/cabbage//These two are classics no idea how it didn't already exist.
	name = "生卷心菜手馅饼"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	foodtype = GRAIN | VEGETABLES
	tastes = list("卷心菜香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/handpie
	name = "手馅饼"
	desc = "矮人在自己的方言里也把它叫作“手馅饼”。在外皮被咬开之前，它能长久保持新鲜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "handpie"
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	bitesize = 4
	faretype = FARE_FINE
	bonus_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION+MINCE_NUTRITION)
	tastes = list("酥脆面皮" = 1)
	rotprocess = null
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/handpie/mushroom
	name = "蘑菇手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/fish
	name = "鱼肉手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/meat
	name = "肉手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/potato
	name = "土豆手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/cabbage
	name = "卷心菜手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/crab
	name = "蟹肉手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/berry
	name = "浆果手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/poison
	name = "浆果手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/apple
	name = "苹果手馅饼"

/obj/item/reagent_containers/food/snacks/rogue/handpie/On_Consume(mob/living/eater)
	..()
	icon_state = "handpie[bitecount]"
	if(bitecount == 1)
		rotprocess = SHELFLIFE_DECENT
		addtimer(CALLBACK(src, PROC_REF(begin_rotting)), 20, TIMER_CLIENT_TIME)

/*	.................   Muffins   ................... */
/obj/item/reagent_containers/food/snacks/rogue/muffin
	name = "松饼"
	desc = "制作简单，人人都爱。像蘑菇一样的小点心，再加点配料会更好。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "muffin"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	tastes = list("酥脆黄油面皮" = 1)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 3
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/muffin/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("你开始给松饼抹上奶酪……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("你开始给松饼抹上蜂蜜……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/muffin/honey(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理！"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/muffin/cheese
	name = "生奶酪松饼"
	desc = "一只蘑菇形的小点心，上面覆着奶酪。还需要继续烘烤！"
	icon_state = "muffin_cheese_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	cooked_smell = /datum/pollutant/food/muffin

/obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	name = "奶酪松饼"
	desc = "一只蘑菇形的小点心，上面覆着奶酪。很适合殷实农民享用。"
	icon_state = "muffin_cheese"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION)
	tastes = list("酥脆黄油面皮" = 1, "奶酪香" = 1)
	faretype = FARE_FINE
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/muffin/honey
	name = "生蜂蜜松饼"
	desc = "一只蘑菇形的小点心，上面覆着蜂蜜。还需要继续烘烤！"
	icon_state = "muffin_honey_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/honey/baked
	cooked_smell = /datum/pollutant/food/muffin

/obj/item/reagent_containers/food/snacks/rogue/muffin/honey/baked
	name = "蜂蜜松饼"
	desc = "一只蘑菇形的小点心，上面覆着蜂蜜。很适合市民享用。"
	icon_state = "muffin_honey"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin/cheese/baked
	cooked_smell = /datum/pollutant/food/muffin
	faretype = FARE_FINE
	cooked_type = null

/*	.................   Strudel   ................... */
/obj/item/reagent_containers/food/snacks/rogue/strudel
	name = "果馅卷"
	desc = "格伦泽尔霍夫特农家食物的巅峰。一条填满苹果酱和坚果的长酥卷，足以驱走饥饿的绞痛。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "strudel"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGH_NUTRITION*2)
	tastes = list("酥苹果香" = 1, "石果" = 1)
	foodtype = GRAIN | FRUIT
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 6
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/snackbuff
	slices_num = 6
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/strudelslice
	slice_batch = TRUE
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/strudelslice
	name = "果馅卷切片"
	desc = "一片满是苹果香甜的美味，只看着就让人口水直流。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_pastry.dmi'
	icon_state = "strudel_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	tastes = list("酥苹果香" = 1, "石果" = 1)
	foodtype = GRAIN | FRUIT
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = null
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/strudel/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I,  /obj/item/reagent_containers/food/snacks/sugar))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("你开始给果馅卷裹上糖……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudel/sugar(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理！"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/strudel/sugar
	name = "糖衣果馅卷"
	desc = "格伦泽尔霍夫特农家食物的巅峰。一条填满苹果酱和坚果的长酥卷，足以驱走饥饿的绞痛。这一份甚至还裹了糖衣！"
	icon_state = "strudel_sugar"
	tastes = list("酥苹果香" = 1, "石果" = 1 ,"糖香" = 1)
	faretype = FARE_LAVISH
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/strudelslice/sugar

/obj/item/reagent_containers/food/snacks/rogue/strudelslice/sugar
	name = "糖衣果馅卷切片"
	desc = "一片满是苹果香甜的美味，只看着就让人口水直流。要是再配点奶油，这就是送给审判官的完美礼物了。"
	icon_state = "strudel_sugar_slice"
	tastes = list("酥苹果香" = 1, "石果" = 1 ,"糖香" = 1)
	faretype = FARE_LAVISH
