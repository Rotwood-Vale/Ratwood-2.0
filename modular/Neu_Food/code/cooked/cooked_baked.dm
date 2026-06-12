// Generic baked products. Also includes their intermediary forms (raw) before baking.
// For consistency.

/*	.................   Hardtack   ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw
	name = "生硬饼"
	desc = "软塌塌的生面团，根本不能入口。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raw_tack"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/crackerscooked
	w_class = WEIGHT_CLASS_NORMAL
	eat_effect = null
	dropshrink = 0.8

/*	.................   Hardtack   ................... */
/obj/item/reagent_containers/food/snacks/rogue/crackerscooked
	name = "硬饼"
	desc = "又脆又硬，像在啃石头。不过，这种咸饼干永远不会坏；对穿越普赛多尼亚的旅人来说，仅此一点就足以让它在行囊里占个位置。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "tack6"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_POOR
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("斯佩耳特麦香" = 1)
	bitesize = 6
	rotprocess = null
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/crackerscooked/On_Consume(mob/living/eater)
	..()
	if(bitecount == 1)
		icon_state = "tack5"
	if(bitecount == 2)
		icon_state = "tack4"
	if(bitecount == 3)
		icon_state = "tack3"
	if(bitecount == 4)
		icon_state = "tack2"
	if(bitecount == 5)
		icon_state = "tack1"


/*	.................   Bread   ................... */
/obj/item/reagent_containers/food/snacks/rogue/bread
	name = "面包条"
	desc = "普赛多尼亚的主食之一，由发酵面团制成。从贫民到教廷贵人，没人能否认一条新鲜出炉面包那朴素的美好。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "loaf6"
	slices_num = 6
	bitesize = 6
	eating_slice = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/breadslice
	list_reagents = list(/datum/reagent/consumable/nutriment = DOUGH_NUTRITION)
	faretype = FARE_POOR
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME	

/obj/item/reagent_containers/food/snacks/rogue/bread/update_icon()
	if(slices_num)
		icon_state = "loaf[slices_num]"
	else
		icon_state = "loaf_slice"

/*	.................   Breadslice & Toast   ................... */
/obj/item/reagent_containers/food/snacks/rogue/breadslice
	name = "面包片"
	desc = "一天伊始的小小慰藉。无论夹上一片烟熏香肠、盐腌肥膘、奶酪还是煎培根，都是再合适不过的承载。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "loaf_slice"
	faretype = FARE_POOR
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	bitesize = 2
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/breadslice/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/salami/slice))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
		if(do_after(user,short_cooktime, target = src))
			var/obj/item/reagent_containers/food/snacks/rogue/sandwich/salami/sammich= new(get_turf(user))
			user.put_in_hands(sammich)
			qdel(I)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarslice))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
		if(do_after(user,short_cooktime, target = src))
			var/obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese/sammich= new(get_turf(user))
			user.put_in_hands(sammich)
			qdel(I)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/fat/salo/slice))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
		if(do_after(user,short_cooktime, target = src))
			var/obj/item/reagent_containers/food/snacks/rogue/sandwich/salo/sammich= new(get_turf(user))
			user.put_in_hands(sammich)
			qdel(I)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
		if(do_after(user,short_cooktime, target = src))
			user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
			var/obj/item/reagent_containers/food/snacks/rogue/sandwich/bacon/sammich= new(get_turf(user))
			user.put_in_hands(sammich)
			qdel(I)
			qdel(src)
	else
		return ..()

//this is a child so we can be used in sammies
/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast
	name = "吐司"
	desc = "酥脆爽口却没有烤焦，简直像炼金奇迹。最适合配煎蛋或一块切片黄油一起吃。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "吐司香"
	faretype = FARE_NEUTRAL
	tastes = list("酥脆面包香" = 1)
	mill_result = /obj/item/reagent_containers/food/snacks/rogue/toastcrumbs
	cooked_type = null
	bitesize = 3
	rotprocess = null

/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/attackby(obj/item/I, mob/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
		if(do_after(user,short_cooktime, target = src))
			var/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/buttered/sammich= new(get_turf(user))
			user.put_in_hands(sammich)
			qdel(I)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/friedegg)) //This actually creates a toast out of regular bread so we put it here.
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
		if(do_after(user,short_cooktime, target = src))
			var/obj/item/reagent_containers/food/snacks/rogue/sandwich/egg/sammich= new(get_turf(user))
			user.put_in_hands(sammich)
			qdel(I)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon))
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
		if(do_after(user,short_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/friedegg/hammerhold(loc)
			qdel(I)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/tartar))
		playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
		if(do_after(user,short_cooktime, target = src))
			var/obj/item/reagent_containers/food/snacks/rogue/sandwich/tartar/sammich= new(get_turf(user))
			user.put_in_hands(sammich)
			qdel(I)
			qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/breadslice/toast/buttered
	name = "黄油吐司"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "toast_butter"
	faretype = FARE_NEUTRAL
	tastes = list("黄油香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)

/obj/item/reagent_containers/food/snacks/rogue/toastcrumbs
	name = "吐司碎"
	desc = "非常适合给油炸食物增加一点酥脆口感。"
	icon = 'modular/Neu_Food/icons/raw/raw_deep_fried.dmi'
	icon_state = "toastcrumbs"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = 6)
	w_class = WEIGHT_CLASS_TINY
	tastes = list("酥脆口感" = 1)
	cooked_type = null
	foodtype = GRAIN
	bitesize = 1
	rotprocess = SHELFLIFE_DECENT

// -------------- BREAD WITH FOOD ON IT (not american sandwich) -----------------
/obj/item/reagent_containers/food/snacks/rogue/sandwich
	desc = "每一片都像是令人愉悦的天赐美味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	bitesize = 4
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/snackbuff

/obj/item/reagent_containers/food/snacks/rogue/sandwich/salami
	tastes = list("烟熏香肠" = 1,"面包香" = 1)
	name = "烟熏香肠面包"
	desc = "一片吐司上铺着薄薄一片烟熏香肠。常是行军士兵的口粮。咸香十足！"
	faretype = FARE_NEUTRAL
	icon_state = "bread_salami"
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/rogue/sandwich/cheese
	tastes = list("奶酪香" = 1,"面包香" = 1)
	name = "奶酪面包"
	desc = "一片吐司，上面融进了相当厚的一块奶酪。"
	faretype = FARE_NEUTRAL
	icon_state = "bread_cheese"
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/sandwich/egg
	tastes = list("奶酪香" = 1,"鸡蛋香" = 1)
	name = "鸡蛋吐司"
	desc = "一片吐司上放着煎蛋，轻轻一碰就会微微晃动。"
	faretype = FARE_NEUTRAL
	icon_state = "bread_egg"
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/rogue/sandwich/salo
	tastes = list("咸脂香" = 1)
	name = "盐腌肥膘面包"
	desc = "盐腌肥膘细腻柔滑的口感能很好地中和粗糙的谷物面包。"
	faretype = FARE_POOR
	icon_state = "bread_salo"
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/rogue/sandwich/bacon
	tastes = list("培根香" = 1)
	name = "培根面包"
	desc = "一片面包上放着酥脆培根，是理想的早餐。为什么它看起来有点像盐腌肥膘？"
	icon_state = "toast_bacon"
	foodtype = GRAIN | MEAT

/obj/item/reagent_containers/food/snacks/rogue/sandwich/tartar
	tastes = list("失望味道" = 1)
	name = "鞑靼面包"
	desc = "一片面包上放着鞑靼生肉，堪称完美早餐。那股味道又是怎么回事？"
	faretype = FARE_FINE
	icon_state = "toast_tartar"
	foodtype = GRAIN | MEAT

/*	.................   Bread bun   ................... */
/obj/item/reagent_containers/food/snacks/rogue/bun
	name = "圆面包"
	desc = "便于携带，小巧朴实，而且整只都能吃下去。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "bun"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	faretype = FARE_POOR
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/bun/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
		to_chat(user, span_notice("正在把香肠塞进面包里……"))
		if(do_after(user,short_cooktime, target = src))
			var/obj/item/reagent_containers/food/snacks/rogue/bun_grenz/hotdog= new(get_turf(user))
			user.put_in_hands(hotdog)
			qdel(I)
			qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheddarwedge))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 100, TRUE, -1)
		to_chat(user, "<span class='notice'>正在往面包里塞奶酪……</span>")
		if(do_after(user,short_cooktime, target = src))
			user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
			new /obj/item/reagent_containers/food/snacks/rogue/bun_raston(loc)
			qdel(I)
			qdel(src)
	else
		return ..()


/* 	.................   Crossbuns   ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw
	name = "生十字面包"
	desc = "一块生面团，上面压出了阿斯特拉塔十字的形状。沐于她的光辉之下。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "crossbun_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/crossbun

// Psydon variant
/obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw
	name = "生普赛圣十字面包"
	desc = "一块生面团，上面压出了普赛圣十字的形状。祂长存不灭。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "psycrossbun_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/psycrossbun

/* 	.................   Crossbuns   ................... */
// Astrata variant

/obj/item/reagent_containers/food/snacks/rogue/crossbun
	name = "十字面包"
	desc = "传统上作为早餐食用。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "crossbun"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	faretype = FARE_NEUTRAL // Having nobles vomit from eating holy buns is not a good idea
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/psycrossbun
	name = "普赛圣十字面包"
	desc = "你还能忍受多久，才会屈服于把它吃掉的诱惑？"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "psycrossbun"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION)
	faretype = FARE_NEUTRAL // Having nobles vomit from eating holy buns is not a good idea
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_EXTREME

/*	.................   Cheese bun   ................... */
/obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesebun_raw
	name = "生奶酪面包"
	desc = "该进烤炉了！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "cheesebun_raw"
	color = "#ecce61"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cheesebun
	list_reagents = list(/datum/reagent/consumable/nutriment = 4)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY

/obj/item/reagent_containers/food/snacks/rogue/cheesebun
	name = "新鲜奶酪面包"
	desc = "格伦泽尔霍夫特厨房出品的一款朴素小点心。"
	faretype = FARE_FINE
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "cheesebun"
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION+FRESHCHEESE_NUTRITION)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("酥脆面包与鲜奶酪香" = 1)
	foodtype = GRAIN | DAIRY
	bitesize = 3
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/obj/item/reagent_containers/food/snacks/rogue/frybread
	name = "煎面饼"
	desc = "用黄油煎到酥脆的扁面饼，是精灵厨房的主食之一。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "frybread"
	faretype = FARE_FINE
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTERDOUGHSLICE_NUTRITION)
	tastes = list("外酥内软的面包香" = 1)
	w_class = WEIGHT_CLASS_NORMAL
	bitesize = 4
	eat_effect = /datum/status_effect/buff/snackbuff

/*	.................   Raisin bread   ................... */
/obj/item/reagent_containers/food/snacks/rogue/rbread_half
	name = "半成品葡萄干面团"
	desc = "它还需要更多葡萄干！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "dough_raisin"
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/rbread_half/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("加入最后一点葡萄干，让面团发起来准备烘烤。"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/rbreaduncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/rbreaduncooked
	name = "生葡萄干面包条"
	desc = "进烤炉吧！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raisinbreaduncooked"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/raisinbread
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/raisinbread
	name = "葡萄干面包条"
	desc = "这是平民间很受欢迎的甜点，甜面包里点缀着果干惊喜。近些年它也更受教会青睐：岩丘的修道院甚至给一种覆着糖衣的变体起了名字。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raisinbread6"
	bitesize = 6
	slices_num = 6
	eating_slice = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_NEUTRAL
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("面包香" = 1,"果干香" = 1)
	slice_batch = FALSE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_EXTREME

/obj/item/reagent_containers/food/snacks/rogue/raisinbread/update_icon()
	if(slices_num)
		icon_state = "raisinbread[slices_num]"
	else
		icon_state = "raisinbread_slice"

/obj/item/reagent_containers/food/snacks/rogue/raisinbreadslice
	name = "葡萄干面包片"
	desc = "柔软有嚼劲，能填肚子，也颇有营养。简单而体面。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raisinbread_slice"
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT-1)
	w_class = WEIGHT_CLASS_NORMAL
	faretype = FARE_NEUTRAL
	cooked_type = null
	tastes = list("斯佩耳特麦香" = 1,"果干香" = 1)
	bitesize = 3
	rotprocess = SHELFLIFE_LONG
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/bun_grenz
	list_reagents = list(/datum/reagent/consumable/nutriment = SAUSAGE_NUTRITION+SMALLDOUGH_NUTRITION)
	tastes = list("咸香香肠" = 1, "面包香" = 1)
	name = "格伦泽尔面包肠"
	desc = "经典的面包夹香肠，如今已是格伦泽尔霍夫特菜肴的常客。据说很久以前是精灵最先发明了它，那时他们还会吃别的人……"
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "grenzbun"
	foodtype = GRAIN | MEAT
	faretype = FARE_NEUTRAL
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/greatsnackbuff

/*	.............   Raston   ................ */
/obj/item/reagent_containers/food/snacks/rogue/bun_raston
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_NUTRITIOUS)
	tastes = list("奶酪香" = 1, "面包香" = 1)
	icon = 'modular/Neu_Food/icons/cooked/cooked_baked.dmi'
	icon_state = "raston"
	name = "拉斯顿面包"
	faretype = FARE_NEUTRAL
	desc = "两片轻烤过的面包之间夹着一片融化的奶酪。"
	rotprocess = SHELFLIFE_EXTREME
	eat_effect = /datum/status_effect/buff/greatsnackbuff
