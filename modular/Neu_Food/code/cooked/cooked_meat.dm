// Simple cooked meat from any animals.
// Only includes simple cooked meat instead of the meal.
// Try to order in the same order as raw meat file ok
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried
	eat_effect = null
	slices_num = 0
	name = "煎牛排"
	desc = "一大块兽肉，煎到了恰到好处的五分熟。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frysteak"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("热牛排香" = 1)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/fried/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/peppermill/mill = I
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	update_cooktime(user)
	if(istype(mill))
		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "黑胡椒不够，做不成任何东西。")
			return TRUE
		mill.icon_state = "peppermill_grind"
		to_chat(user, "你开始把黑胡椒抹到牛排上。")
		playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "黑胡椒不够，做不成任何东西。")
				return TRUE
			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/peppersteak(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)

	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		to_chat(user, span_notice("正在加入洋葱……"))
		if(do_after(user,short_cooktime, target = src))
			new /obj/item/reagent_containers/food/snacks/rogue/onionsteak(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(I)
			qdel(src)
	
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked))
		playsound(get_turf(user), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
		to_chat(user, "<span class='notice'>正在加入胡萝卜……</span>")
		if(do_after(user,short_cooktime, target = src))
			user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
			new /obj/item/reagent_containers/food/snacks/rogue/carrotsteak(loc)
			qdel(I)
			qdel(src)

	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))

/obj/item/reagent_containers/food/snacks/rogue/peppersteak/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/peppersteak/ducal
	tastes = list("牛排香" = 1, "胡椒香" = 1, "蒜香" = 1)
	name = "公爵牛排"
	desc = "烤肉表面厚厚覆着磨碎黑胡椒，又抹上了蒜泥，滋味浓烈。据说这是疯公爵最爱的一餐。"
	faretype = FARE_LAVISH
	icon_state = "ducalsteak"
	eat_effect = /datum/status_effect/buff/greatmealbuff

/* .............   Roast Pork   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/fatty/roast
	name = "烤猪肉"
	desc = "一大块猪肉，烤到了恰到好处的酥脆程度。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	faretype = FARE_FINE
	icon_state = "roastpork"
	tastes = list("酥脆猪肉香" = 1)
	bitesize = 3
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/*	.............   Crispy bacon   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried
	eat_effect = null
	name = "煎培根"
	desc = "这是松露猪的退休归宿。"
	faretype = FARE_FINE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "friedbacon"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/bacon/fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausage))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/sausagebacon(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/friedegg))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/friedegg/bacon(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.............   Fryspider   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/spider/fried
	name = "煎蜘蛛肉"
	desc = "一条去毛烤制的蜘蛛腿。"
	faretype = FARE_POOR
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "friedspider"
	eat_effect = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_POOR)
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/*	.................  Whole Chicken roast   ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked
	desc = "一只肥美的禽鸟，被烤到恰到好处，外皮酥脆。"
	eat_effect = null
	slices_num = 0
	name = "烤禽"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "roastchicken"
	faretype = FARE_FINE
	portable = FALSE
	tastes = list("鲜美禽肉香" = 1)
	cooked_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	rotprocess = SHELFLIFE_DECENT
	

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/attackby(obj/item/I, mob/user, params)
	var/obj/item/reagent_containers/peppermill/mill = I
	if(istype(mill))
		if (!isturf(src.loc) || \
			!(locate(/obj/structure/table) in src.loc) && \
			!(locate(/obj/structure/table/optable) in src.loc) && \
			!(locate(/obj/item/storage/bag/tray) in src.loc))
			to_chat(user, span_warning("我得借助一张桌子。"))
			return FALSE

		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "黑胡椒不够，做不成任何东西。")
			return FALSE

		mill.icon_state = "peppermill_grind"
		to_chat(user, "你开始把黑胡椒抹到烤禽上。")
		playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,3 SECONDS, target = src))
			mill.icon_state = "peppermill"
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "黑胡椒不够，做不成任何东西。")
				return FALSE

			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced(loc)
			qdel(src)
		else
			mill.icon_state = "peppermill"
	else
		var/found_table = locate(/obj/structure/table) in (loc)
		update_cooktime(user)
		if(istype(I, /obj/item/reagent_containers/food/snacks/butter))
			if(isturf(loc)&& (found_table))
				playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
				to_chat(user, "你开始把黄油塞进烤禽里。")
				if(do_after(user,short_cooktime, target = src))
					new /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter(loc)
					qdel(I)
					qdel(src)
		if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked))
			if(isturf(loc)&& (found_table))
				playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
				to_chat(user, "你开始把另一只鸟塞进这只烤禽里，你确定要这么做吗？")
				if(do_after(user,short_cooktime, target = src))
					new /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked(loc)
					qdel(I)
					qdel(src)
		return ..()

/*	.............   Frybird   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried
	eat_effect = null
	slices_num = 0
	name = "炸鸟排"
	desc = "禽肉被炸到了恰到好处的诱人酥脆。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "炸禽肉香"
	faretype = FARE_FINE
	portable = FALSE
	fried_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_DECENT

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frybirdtato(loc)
				qdel(I)
				qdel(src)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/frybirdtato(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.................  Ducal Spiced Baked Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced/ducal
	name = "公爵烤禽"
	desc = "一只肥美禽鸟被烤得恰到好处，再以香料与蒜调味得近乎神赐。很适合在你儿子战死沙场时大快朵颐……"
	faretype = FARE_LAVISH
	icon_state = "ducalchicken"
	tastes = list("辛香禽肉" = 1, "蒜香" = 1)
	eat_effect = /datum/status_effect/buff/greatmealbuff

/* ............. Fried Crab ................*/
/obj/item/reagent_containers/food/snacks/rogue/meat/crab/fried
	eat_effect = null
	slices_num = 0
	name = "炸蟹肉"
	faretype = FARE_NEUTRAL
	portable = FALSE
	desc = "一块炸蟹肉，真香。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "crabmeat"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	desc = ""
	fried_type = null
	cooked_type = null

/* .............   Fried Cabbit   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried
	eat_effect = null
	slices_num = 0
	name = "炸兔肉"
	desc = "一大块兔肉，被炸到了恰到好处的酥脆程度。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "frycabbit"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)	//It's easier and cheaper than normal meat to find.
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("热兔肉香" = 1)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* .............   Fried Volf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried
	eat_effect = null
	slices_num = 0
	name = "煎狼肉"
	desc = "一大块狼肉，煎到了恰到好处的五分熟。略带野味也有些韧，但很好吃。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "fryvolf"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* .............   Seared Gnoll   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll/seared
	eat_effect = null
	slices_num = 0
	name = "炙鬣狗人肉"
	desc = "一团恶心得要命、满是筋的鬣狗人肉。看起来炙烤只让肌肉变得更韧了。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "searedgnoll"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_CHUNKY)
	faretype = FARE_POOR
	rotprocess = SHELFLIFE_EXTREME
	fried_type = null
	cooked_type = null

/* .............   Fried Filet    ................ */
// This is seafood but is one of the "simple cooked meat" so I put it here.
/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried
	eat_effect = null
	slices_num = 0
	name = "炸鱼柳"
	desc = "一大片层层剥落的鱼肉，被煎到一碰就散。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "cooked_filet"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_NEUTRAL
	rotprocess = SHELFLIFE_DECENT
	tastes = list("热鱼香" = 1)
	fried_type = null
	cooked_type = null

/obj/item/reagent_containers/food/snacks/rogue/meat/fish/fried/attackby(obj/item/I, mob/living/user, params)
	var/obj/item/reagent_containers/peppermill/mill = I
	if(!locate(/obj/structure/table) in src.loc)
		to_chat(user, span_warning("我得借助一张桌子。"))
		return FALSE
	update_cooktime(user)
	if(istype(mill))
		if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
			to_chat(user, "黑胡椒不够，做不成任何东西。")
			return TRUE
		mill.icon_state = "peppermill_grind"
		to_chat(user, "你开始把黑胡椒抹到鱼肉上。")
		playsound(get_turf(user), 'modular/Neu_Food/sound/peppermill.ogg', 100, TRUE, -1)
		if(do_after(user,long_cooktime, target = src))
			if(!mill.reagents.has_reagent(/datum/reagent/consumable/blackpepper, 1))
				to_chat(user, "黑胡椒不够，做不成任何东西。")
				return TRUE
			mill.reagents.remove_reagent(/datum/reagent/consumable/blackpepper, 1)
			new /obj/item/reagent_containers/food/snacks/rogue/pepperfish(loc)
			add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
			qdel(src)

	else
		to_chat(user, span_warning("你得把[src]放到桌上才能把香料揉进去。"))

/* .............   Fried Shellfish    ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/shellfish/fried
	eat_effect = null
	slices_num = 0
	name = "炸贝肉"
	desc = "炸熟的贝肉，有点咸，但很好吃。"
	faretype = FARE_NEUTRAL
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "shellfish_meat_cooked"
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	fried_type = null
	cooked_type = null


/*	.............   Sausage & Wiener   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked
	eat_effect = null
	name = "香肠"
	desc = "把美味的肉填进肠衣里制成的食物。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat.dmi'
	icon_state = "wiener"
	faretype = FARE_NEUTRAL
	fried_type = null
	bonus_reagents = list(/datum/reagent/consumable/nutriment = SNACK_DECENT)
	rotprocess = SHELFLIFE_EXTREME

/* .............   Fried Cabbit w/ Garlick  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick
	name = "蒜香兔肉"
	desc = "一大块兔肉，被炸到了恰到好处的酥脆程度，还裹满了蒜瓣。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frycabbit_garlick"
	tastes = list("热兔肉香" = 1, "蒜香" = 1)
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlick/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlickcucumber(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* .............   Fried Cabbit w/ Garlick & Cucumber ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/rabbit/fried/garlickcucumber
	name = "精灵兔肉烤盘"
	desc = "一大块兔肉，被炸到了恰到好处的酥脆程度，裹满蒜瓣并配有黄瓜。游侠们认为这会带来好运！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frycabbit_garlick_cucumber"
	tastes = list("热兔肉香" = 1, "蒜香" = 1, "黄瓜香" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_LAVISH

/* .............  Garlicked Fried Volf   ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick
	name = "蒜香狼肉"
	desc = "一大块狼肉，煎到了恰到好处的五分熟。略带野味也有些韧，但很好吃。这一块还裹满了蒜瓣。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "fryvolf_garlick"
	tastes = list("野味狼肉香" = 1, "蒜香" = 1)
	faretype = FARE_FINE

/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlick/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	update_cooktime(user)
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,short_cooktime, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT * 0.5)
				new /obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlickcucumber(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/* .............  Garlicked Fried Volf w/ Cucumber  ................ */
/obj/item/reagent_containers/food/snacks/rogue/meat/steak/wolf/fried/garlickcucumber
	name = "猎人盛宴"
	desc = "一大块狼肉，煎到了恰到好处的五分熟。略带野味也有些韧，但很好吃。这一块还裹满了蒜瓣，并配有黄瓜。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "fryvolf_garlick_cucumber"
	tastes = list("野味狼肉香" = 1, "蒜香" = 1, "黄瓜香" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff
	faretype = FARE_LAVISH
