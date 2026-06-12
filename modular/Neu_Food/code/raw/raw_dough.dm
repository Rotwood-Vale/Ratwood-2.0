// Dough, and variants thereof for usage in making various baked food items.
// Doesn't include raw variants of bread and others
/*	.................   Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/dough_base
	name = "未完成的面团"
	desc = "再多费一点心思，它就能大有可为。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi' // I know but we are following Raw as a pre-pender
	icon_state = "dough_base"
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/dough_base/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/powder/flour))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("继续揉入更多面粉……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/dough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能继续揉制。"))
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/dough
	name = "面团"
	desc = "一切烘焙的起点。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "dough"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/doughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bread
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/dough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/butterslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("把黄油揉进面团里……"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/butterdough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("一边揉面，一边拌入葡萄干……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/rbread_half(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/butterdough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团揉成长条形……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]擀成做硬饼的薄面片。"))
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw(loc)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/hardtack_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	else
		return ..()

/*	.................   Smalldough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/doughslice
	name = "小面团"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "doughslice"
	slices_num = 0
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/bun
	cooked_smell = /datum/pollutant/food/bun
	w_class = WEIGHT_CLASS_NORMAL
	tastes = list("生面香" = 1)

/obj/item/reagent_containers/food/snacks/rogue/doughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/cheese))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("加入新鲜奶酪……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/cheesebun_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/doughslice))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团并在一起……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/dough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross/astrata))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("把阿斯特拉塔十字印进面坯里……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/crossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/clothing/neck/roguetown/psicross)) // This is gonna be messy cuz other are subtypes
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading_alt.ogg', 90, TRUE, -1)
			to_chat(user, span_notice("把普赛圣十字压进面坯里……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/psycrossbun_raw(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/dough))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/kneading.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把面团揉成长条形……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/strudeldough(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	else
		return ..()

/*	.................   Butterdough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdough
	name = "黄油面团"
	desc = "比起传承，眼前这点成果又算什么？"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdough"
	color = "#feffc1"
	slices_num = 2
	slice_batch = TRUE
	slice_path = /obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/muffin
	cooked_smell = /datum/pollutant/food/muffin
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE

/obj/item/reagent_containers/food/snacks/rogue/butterdough/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/egg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("把鸡蛋揉进面里，塑成蛋糕坯……"))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			if(do_after(user,long_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/cake_base(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	else
		return ..()

/*	.................   Butterdough piece   ................... */
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice
	name = "黄油面团块"
	desc = "一小块好底子，也能擀出一段好味道。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "butterdoughslice"
	color = "#feffc1"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/frybread
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/pastry
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL

// Dough + rolling pin on table = flat dough. RT got some similar proc for this.
/obj/item/reagent_containers/food/snacks/rogue/butterdoughslice/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/kitchen/rollingpin))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'modular/Neu_Food/sound/rollingpin.ogg', 100, TRUE, -1)
			to_chat(user, span_notice("把[src]擀平……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/piedough(loc)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/raisins))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
			to_chat(user, span_notice("往面团里加入葡萄干……"))
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/foodbase/biscuit_raw(loc)
				qdel(I)
				qdel(src)
		else
			to_chat(user, span_warning("你得先把[src]放到桌上才能擀开！"))
	if(I.get_sharpness())
		if(!isdwarf(user))
			to_chat(user, span_warning("你不懂矮人点心的做法！"))
			return
		else
			if(isturf(loc)&& (found_table))
				playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
				to_chat(user, span_notice("把面团切成细条，拧成椒盐卷饼……"))
				if(do_after(user,short_cooktime, target = src))
					add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
					new /obj/item/reagent_containers/food/snacks/rogue/foodbase/prezzel_raw(loc)
					qdel(src)
			else
				to_chat(user, span_warning("你得先把[src]放到桌上才能切。"))
	else
		..()

/*	.................   Piedough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/piedough
	name = "派皮面团"
	desc = "更丰盛之物的开端。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "piedough"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/foodbase/piebottom
	cooked_smell = /datum/pollutant/food/pie_base
	w_class = WEIGHT_CLASS_NORMAL

/obj/item/reagent_containers/food/snacks/rogue/piedough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/truffles))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/mushroom)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/fish)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/mince))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/meat)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/crab))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/crab)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue/poison))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/poison)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/berries/rogue))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/berry)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/apple)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced))
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/potato)
	else if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced))//This produces 3 instead of 2 so it'd be obvious go to.
		prepare_handpie(I, user, /obj/item/reagent_containers/food/snacks/rogue/foodbase/handpieraw/cabbage)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/piedough/proc/prepare_handpie(obj/item/I, mob/living/user, handpie_path)
	playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 50, TRUE, -1)
	to_chat(user, span_notice("正在包手馅饼……"))
	if(do_after(user,short_cooktime, target = src))
		add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
		var/handpie = new handpie_path(get_turf(user))
		user.put_in_hands(handpie)
		qdel(I)
		qdel(src)

/*	.................   Strudel Dough   ................... */
/obj/item/reagent_containers/food/snacks/rogue/strudeldough
	name = "卷酥面团"
	desc = "尚待填满的美味外壳。"
	icon = 'modular/Neu_Food/icons/raw/raw_dough.dmi'
	icon_state = "strudel_raw"
	cooked_smell = /datum/pollutant/food/pastry
	w_class = WEIGHT_CLASS_NORMAL
	slice_sound = TRUE
	process_step = 1

/obj/item/reagent_containers/food/snacks/rogue/strudeldough/attackby(obj/item/I, mob/living/user, params)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/apple))
		if(process_step != 1)
			return
		to_chat(user, span_notice("往面团里填入苹果……"))
		if(do_after(user, short_cooktime, target = src))
			playsound(get_turf(user), 'modular/Neu_Food/sound/eggbreak.ogg', 100, TRUE, -1)
			name = "半填馅卷酥"
			desc = "这份卷酥大半已经填入苹果，但还缺最后一部分馅料。"
			process_step = 2
			qdel(I)
			return
	if(istype(I, /obj/item/reagent_containers/food/snacks/grown/nut))
		if(process_step != 2)
			return
		to_chat(user, span_notice("再用石果完成最后的馅料……"))
		if(do_after(user, short_cooktime, target = src))
			name = "填满的卷酥"
			desc = "苹果和坚果已经把卷酥塞得满满当当，接下来只差烘烤。"
			cooked_type = /obj/item/reagent_containers/food/snacks/rogue/strudel
			process_step = 3
			qdel(I)
			return
	return ..()
