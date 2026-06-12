//	.................   Cake base   .................
/obj/item/reagent_containers/food/snacks/rogue/cake_base
	name = "蛋糕坯"
	desc = "有了这份甜美，你会让他们唱起歌来。"
	icon = 'modular/Neu_Food/icons/raw/raw_cakes.dmi'
	icon_state = "蛋糕香"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/cake
	cooked_smell = /datum/pollutant/food/cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/cake_base/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/frosting))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在把糖霜厚厚抹在蛋糕上……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frostedcakeuncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在把新鲜奶酪铺到蛋糕上……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/honey))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在把香甜的蜂蜜抹到蛋糕上……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

//	.................   Cooked   .................
/obj/item/reagent_containers/food/snacks/rogue/cake
	name = "蛋糕"
	desc = "柔软细嫩，既能作底，也适合给等不及的人直接吃。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "蛋糕香"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/cakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1)
	foodtype = GRAIN | DAIRY
	faretype = FARE_NEUTRAL
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/cake/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/frosting)) // QoL for those that forgot to put the icing first
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在把糖霜厚厚抹在蛋糕上……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frostedcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/cakeslice
	name = "蛋糕切片"
	desc = "柔软细嫩，一片朴素却可口的蛋糕。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	cooked_type = null
	foodtype = GRAIN | DAIRY
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_LONG

//	.................   Frosted cake   .................
//	.................        Raw       .................
/obj/item/reagent_containers/food/snacks/rogue/frostedcakeuncooked
	name = "糖霜蛋糕坯"
	desc = "有了这份裹着糖霜的甜美，你会让他们又唱又跳。"
	icon = 'modular/Neu_Food/icons/raw/raw_cakes.dmi'
	icon_state = "frostedcake"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/frostedcake
	cooked_smell = /datum/pollutant/food/frosted_cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY | SUGAR
	rotprocess = SHELFLIFE_LONG

//	.................   Cooked   .................
/obj/item/reagent_containers/food/snacks/rogue/frostedcake
	name = "糖霜蛋糕"
	desc = "裹着甜糖霜的蛋糕，既可继续装饰，也可直接享用。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "frostedcake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/frostedcakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_FINE
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/frostedcake/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple)) //apple cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在切碎并拌入[I]……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/applecake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue)) //berry cake (+poison)
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在压碎并拌入剩下的浆果……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
					new /obj/item/reagent_containers/food/snacks/rogue/berrycake/poison(loc)
				else
					new /obj/item/reagent_containers/food/snacks/rogue/berrycake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/blackberry)) //blackberry cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在把多汁的黑莓倒入蛋糕中做夹层……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/blackberrycake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked) || istype(I, /obj/item/reagent_containers/food/snacks/grown/carrot)) //carrot cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在削开并把[I]拌进糖霜和面糊里……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/carrotcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/lemon)) //lemon cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在切碎[I]并拌进蛋糕里……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/lemoncake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/lime)) //lime cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在切碎[I]并拌进蛋糕里……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/limecake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
/*
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/manabloom)) //manabloom cake
		if(isturf(loc)&& (found_table))
			if(user.get_skill_level(/datum/skill/magic/arcane) < 1)
				to_chat(user, span_notice("我不知道该如何把法绽花与蛋糕之间的奥术力量结合起来。"))
			else
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_notice("我小心地把法绽花放到蛋糕上，并将它的精华与蛋糕结合起来……"))
				if(do_after(user,long_cooktime, target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/manacake(loc)
					qdel(I)
					qdel(src)
					playsound(get_turf(user), 'sound/magic/charged.ogg', 100, TRUE, -1)
					user.say("无上的甘甜！")
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
*/
	if(istype(I, /obj/item/alch/mentha)) //mentha cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在切碎并把[I]拌进蛋糕糖霜里……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/menthacake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/clothing/head/peaceflower)) //peace cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在小心地把[I]加进蛋糕里……"))
			if(do_after(user,long_cooktime, target = src))
				user.visible_message(span_notice("[user]把[I]加进了[src]。糖霜的颜色变了！"))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/peacecake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/raspberry)) //raspberry cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在把多汁的覆盆子倒入蛋糕中做夹层……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/raspberrycake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/nut)) //rocknut cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在用[I]围饰蛋糕……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/rocknutcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/strawberry)) //strawberry cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在用[I]围饰蛋糕……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strawberrycake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/fruit/tangerine)) //tangerine cake
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在切碎[I]并拌进蛋糕里……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/tangerinecake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	//(We could add generic cakes here, using the filling overlays)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/frostedcakeslice
	name = "糖霜蛋糕切片"
	desc = "裹着甜糖霜的切片，已经可以入口品尝了。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "frostedcake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Apple cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/applecake
	name = "苹果蛋糕"
	desc = "覆着甜糖霜、夹着多汁苹果的蛋糕，甜中带酸。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "applecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/applecakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"苹果香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/applecake/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/nut))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在用石果围饰蛋糕……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/applenutcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/applecakeslice
	name = "苹果蛋糕切片"
	desc = "覆着甜糖霜、夹着多汁苹果的蛋糕切片，甜中带酸。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "applecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"苹果香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Applenut cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/applenutcake
	name = "苹果坚果蛋糕"
	desc = "覆着糖霜、夹着苹果并裹满坚果的蛋糕，风味与口感都很出彩，还带有轻微提神效果。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "applenutcake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/applenutcakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 1)
	eating_slice = TRUE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"苹果香"=1,"坚果香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/applenutcakeslice
	name = "苹果坚果蛋糕切片"
	desc = "覆着糖霜、夹着苹果并裹满坚果的蛋糕切片，风味与口感都很出彩，还带有轻微提神效果。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "applenutcake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/consumable/acorn_powder = 1)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"苹果香"=1,"坚果香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Berry cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/berrycake
	name = "浆果蛋糕"
	desc = "蛋糕里铺满了多汁浆果，汁水渗进糖霜之中。常见于解毒剂旁边。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "berrycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/berrycakeslice
	list_reagents = list(/datum/reagent/consumable/nutriment = 48, /datum/reagent/water = 5)
	eating_slice = TRUE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"浆果香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/berrycake/poison
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/berrycakeslice/poison
	list_reagents = list(/datum/reagent/berrypoison = 5, /datum/reagent/consumable/nutriment = 48, /datum/reagent/water = 5)

/obj/item/reagent_containers/food/snacks/rogue/berrycakeslice
	name = "浆果蛋糕切片"
	desc = "一片蛋糕，上面铺着多汁浆果，汁水渗进了糖霜里。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "berrycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"浆果香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/berrycakeslice/poison
	list_reagents = list(/datum/reagent/berrypoison = 1, /datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/water = 1)

//	..................   Blackberry cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/blackberrycake
	name = "黑莓蛋糕"
	desc = "一只覆着深色糖霜、点缀黑莓的蛋糕。常与覆盆子蛋糕成对出现的果味甜点。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "blackberrycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/blackberrycakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"黑莓香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/blackberrycakeslice
	name = "黑莓蛋糕切片"
	desc = "一片覆着深色糖霜、点缀黑莓的蛋糕。常与覆盆子蛋糕成对出现的果味甜点。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "blackberrycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"黑莓香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Carrot cake   ..................
//         This could've been a berry cake too.
/obj/item/reagent_containers/food/snacks/rogue/carrotcake
	name = "胡萝卜蛋糕"
	desc = "这款覆着糖霜的蛋糕甜得出人意料，柔软内部还夹着烤熟的胡萝卜皮。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "carrotcake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/carrotcakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"胡萝卜香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | VEGETABLES
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/carrotcakeslice
	name = "胡萝卜蛋糕切片"
	desc = "这片覆着糖霜的蛋糕甜得出人意料，柔软内部还夹着烤熟的胡萝卜皮。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "carrotcake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"胡萝卜香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | VEGETABLES
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Lemon cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/lemoncake
	name = "柠檬蛋糕"
	desc = "一款有着浓郁柑橘风味的糖霜蛋糕。厚厚的柠檬夹层赋予它甜、酸与清新的滋味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "lemoncake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/lemoncakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"柠檬香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/lemoncakeslice
	name = "柠檬蛋糕切片"
	desc = "一片有着浓郁柑橘风味的糖霜蛋糕。厚厚的柠檬夹层赋予它甜、酸与清新的滋味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "lemoncake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"柠檬香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Lime cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/limecake
	name = "青柠蛋糕"
	desc = "一款有着浓郁柑橘风味的糖霜蛋糕。厚厚的青柠夹层赋予它甜、酸与清新的滋味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "limecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/limecakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"青柠香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/limecakeslice
	name = "青柠蛋糕切片"
	desc = "一片有着浓郁柑橘风味的糖霜蛋糕。厚厚的青柠夹层赋予它甜、酸与清新的滋味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "limecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"青柠香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

/*
//	..................   Manabloom cake   ..................
// For whatever reason, this considerably dull the taste in favor of revitalizing the eater's energy.
// It is intended only for characters with the ability to tap into the arcane to make this cake.

/obj/item/reagent_containers/food/snacks/rogue/manacake
	name = "法力蛋糕"
	desc = "覆着糖霜的蛋糕，蕴含着奥术潜能。它比看上去更轻盈，而且很少有人是冲着味道专门去做它的。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "manacake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/manacakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/medicine/manapot = 32, /datum/reagent/consumable/nutriment = 24)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("空泛甜味"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_POOR
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	//eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 16

/obj/item/reagent_containers/food/snacks/rogue/manacakeslice
	name = "法力蛋糕切片"
	desc = "覆着糖霜的蛋糕切片，其中的奥术潜能正在消散。它比看上去更轻盈，而且很少有人是冲着味道吃它的。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "manacake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("空泛甜味"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	//eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG
*/

//	..................   Mentha cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/menthacake
	name = "薄荷蛋糕"
	desc = "一款覆着糖霜的蛋糕，带着薄荷与荒野森林般的清新气息。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "menthacake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/menthacakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"清新草本香"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/menthacakeslice
	name = "薄荷蛋糕切片"
	desc = "一片覆着糖霜的蛋糕，带着薄荷与荒野森林般的清新气息。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "menthacake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"清新草本香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Peace cake   ..................
// Peaceflower cake has the drawback of turning its eater into a pacifist for a few minutes.
/obj/item/reagent_containers/food/snacks/rogue/peacecake
	name = "和平蛋糕"
	desc = "这款覆着糖霜的蛋糕因装饰花苞而带有奇迹般的力量，据说适合恋人分享，或在哀悼之后食用。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "peacecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/peacecakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"宁和花香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/peacecake/On_Consume(mob/living/eater)
	if(iscarbon(eater))
		eater.apply_status_effect(/datum/status_effect/buff/peacecake)
	return ..()

/obj/item/reagent_containers/food/snacks/rogue/peacecakeslice
	name = "和平蛋糕切片"
	desc = "这片覆着糖霜的蛋糕仍残留着装饰花苞的力量，据说适合恋人分享，或在哀悼之后食用。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "peacecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"宁和花香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

/obj/item/reagent_containers/food/snacks/rogue/peacecakeslice/On_Consume(mob/living/eater)
	if(iscarbon(eater))
		eater.apply_status_effect(/datum/status_effect/buff/peacecake)
	return ..()

//	..................   Raspberry cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/raspberrycake
	name = "覆盆子蛋糕"
	desc = "一款点缀着漂亮覆盆子的糖霜蛋糕。常与黑莓蛋糕成对出现的果味甜点。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "raspberrycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/raspberrycakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"覆盆子香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/raspberrycakeslice
	name = "覆盆子蛋糕切片"
	desc = "一片点缀着漂亮覆盆子的糖霜蛋糕。常与黑莓蛋糕成对出现的果味甜点。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "raspberrycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"覆盆子香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Rocknut cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/rocknutcake
	name = "石果蛋糕"
	desc = "一款简单的糖霜坚果蛋糕。它受欢迎的主要原因在于那轻微的提神效果。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "rocknutcake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/rocknutcakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48, /datum/reagent/consumable/acorn_powder = 4, /datum/reagent/drug/nicotine = 1)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"坚果香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/rocknutcake/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("正在切碎并拌入[I]……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/applenutcake(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得把[src]放到桌上才能处理。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/rocknutcakeslice
	name = "石果蛋糕切片"
	desc = "一片简单的糖霜坚果蛋糕。它受欢迎的主要原因在于那轻微的提神效果。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "rocknutcake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT, /datum/reagent/consumable/acorn_powder = 1)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"坚果香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Strawberry cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/strawberrycake
	name = "草莓蛋糕"
	desc = "柔嫩的糖霜蛋糕上铺着糖渍草莓与草莓夹层，简单而优雅。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "strawberrycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/strawberrycakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"草莓香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/strawberrycakeslice
	name = "草莓蛋糕切片"
	desc = "一片柔嫩的糖霜蛋糕，上面铺着糖渍草莓与草莓夹层，简单而优雅。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "strawberrycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"草莓香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Tangerine cake   ..................
/obj/item/reagent_containers/food/snacks/rogue/tangerinecake
	name = "橘子蛋糕"
	desc = "一款有着浓郁柑橘风味的糖霜蛋糕。厚厚的橘子夹层赋予它甜、酸与清新的滋味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "tangerinecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/tangerinecakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"橘香"=1)
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/tangerinecakeslice
	name = "橘子蛋糕切片"
	desc = "一片有着浓郁柑橘风味的糖霜蛋糕。厚厚的橘子夹层赋予它甜、酸与清新的滋味。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "tangerinecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"甜糖霜"=1,"橘香"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR | FRUIT
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG

//	..................   Honey cake (Zybantu)   ..................
//	..................           Raw            ..................
/obj/item/reagent_containers/food/snacks/rogue/hcakeuncooked
	name = "未烤蛋糕"
	icon = 'modular/Neu_Food/icons/raw/raw_cakes.dmi'
	icon_state = "honeycake"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/hcake
	cooked_smell = /datum/pollutant/food/honey_cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY | SUGAR
	rotprocess = SHELFLIFE_DECENT

//	.................   Cooked   .................
/obj/item/reagent_containers/food/snacks/rogue/hcake
	name = "兹班图蛋糕"
	desc = "以著名的兹班图风格覆上蜂蜜糖衣的蛋糕，是一款香甜可口的点心。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "honeycake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/hcakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"香甜蜜糖霜"=1)
	foodtype = GRAIN | DAIRY | SUGAR
	faretype = FARE_LAVISH
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/hcakeslice
	name = "兹班图蛋糕切片"
	desc = "一片以著名兹班图风格覆上蜂蜜糖衣的蛋糕，是一款香甜可口的点心。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "honeycake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"香甜蜜糖霜"=1)
	cooked_type = null
	foodtype = GRAIN | DAIRY | SUGAR
	bitesize = 3
	eat_effect = /datum/status_effect/buff/snackbuff
	extra_eat_effect = /datum/status_effect/buff/sweet
	rotprocess = SHELFLIFE_LONG
	
//	..................   Cheesecake   ..................
//	..................      Raw       ..................
/obj/item/reagent_containers/food/snacks/rogue/ccakeuncooked
	name = "未烤奶酪蛋糕"
	icon = 'modular/Neu_Food/icons/raw/raw_cakes.dmi'
	icon_state = "cheesecake"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/ccake
	cooked_smell = /datum/pollutant/food/cheese_cake
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	w_class = WEIGHT_CLASS_NORMAL
	foodtype = GRAIN | DAIRY
	rotprocess = SHELFLIFE_DECENT

//	.................   Cooked   .................
/obj/item/reagent_containers/food/snacks/rogue/ccake
	name = "芝士蛋糕"
	desc = "人们钟爱的杰作。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cheesecake"
	slices_num = 8
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/ccakeslice
	eating_slice = TRUE
	list_reagents = list(/datum/reagent/consumable/nutriment = 48)
	faretype = FARE_FINE
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"奶香芝士"=1)
	foodtype = GRAIN | DAIRY
	slice_batch = TRUE
	slice_sound = TRUE
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/snackbuff
	bitesize = 8

/obj/item/reagent_containers/food/snacks/rogue/ccakeslice
	name = "芝士蛋糕切片"
	desc = "一片简单却深受人们喜爱的杰作。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_cakes.dmi'
	icon_state = "cheesecake_slice"
	slices_num = 0
	list_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("蛋糕香"=1,"奶香芝士"=1)
	faretype = FARE_FINE
	cooked_type = null
	foodtype = GRAIN | DAIRY
	bitesize = 2
	eat_effect = /datum/status_effect/buff/snackbuff
	rotprocess = SHELFLIFE_LONG
