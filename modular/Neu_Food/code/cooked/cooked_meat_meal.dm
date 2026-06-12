// High efforts (i.e. spiced / buttered / onioned or whatever) meal where meat
// Is the main ingredient.
/*	..................   Pepper steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/peppersteak
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	tastes = list("牛排香" = 1, "胡椒香" = 1)
	name = "胡椒牛排"
	desc = "烤肉表面厚厚覆着磨碎黑胡椒，滋味浓烈。"
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "peppersteak"
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/*	..................   Onion steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/onionsteak
	name = "洋葱牛排"
	desc = "烤肉配上香气四溢的炸洋葱，再浇上两者交融出的肉汁，成就一份令人垂涎的酱汁。"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "onionsteak"
	tastes = list("牛排香" = 1, "洋葱香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	foodtype = MEAT
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/obj/item/reagent_containers/food/snacks/rogue/onionsteak/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/carrot_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	..................   Carrot Steak   ................... */
/obj/item/reagent_containers/food/snacks/rogue/carrotsteak
	name = "胡萝卜牛排"
	desc = "烤肉配上咸香烤胡萝卜，再浇上两者交融出的肉汁，成就一份令人垂涎的酱汁。"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "carrotsteak"
	tastes = list("牛排香" = 1, "胡萝卜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	faretype = FARE_NEUTRAL
	foodtype = MEAT
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/obj/item/reagent_containers/food/snacks/rogue/carrotsteak/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				user.adjust_experience(/datum/skill/craft/cooking, user.STAINT * 0.8)
				new /obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.................   Steak & carrot & onion   ................... */
/obj/item/reagent_containers/food/snacks/rogue/steakcarrotonion
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	tastes = list("牛排香" = 1, "洋葱香" = 1, "胡萝卜香" = 1)
	name = "牛排餐"
	desc = ""
	bitesize = 5
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "steakmeal"
	faretype = FARE_FINE
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Wiener Cabbage   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienercabbage
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("咸香香肠" = 1, "卷心菜香" = 1)
	name = "卷心菜香肠"
	desc = "丰盛扎实的一餐，最适合行军中的士兵。"
	bitesize = 4
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wienercabbage"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff
	

/*	.................   Wiener & Fried potato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotato
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("咸香香肠" = 1, "土豆香" = 1)
	name = "土豆香肠"
	desc = "扎实又顶饱。"
	bitesize = 4
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wienerpotato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff
	

/obj/item/reagent_containers/food/snacks/rogue/wienerpotato/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.................  Spiced Baked Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/spiced
	name = "香料烤禽"
	desc = "一只肥美禽鸟被烤得恰到好处，再以香料调味得近乎神赐。"
	bitesize = 4
	faretype = FARE_LAVISH
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "pepperchicken"
	tastes = list("辛香禽肉" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................  Baked Butter Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/butter
	name = "黄油烤禽"
	desc = "一只肥美禽鸟被烤得恰到好处，内部满是融化黄油。"
	bitesize = 4
	faretype = FARE_LAVISH
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "butterchicken"
	tastes = list("黄油禽肉香" = 1)
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................  Baked Double Poultry  ................... */
/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/baked/doublestacked
	name = "禽中禽烤禽"
	desc = "一只肥美禽鸟被烤得恰到好处……里面还塞着另一只鸟。到底是什么驱使你做出这东西？普赛顿都会为你的狂妄落泪。"
	bitesize = 6
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "stuffedchicken"
	eat_effect = /datum/status_effect/buff/mealbuff
	bonus_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE*2)

/*	.................   Wiener & Fried onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wieneronions
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("咸香香肠" = 1, "炸洋葱香" = 1)
	name = "香肠洋葱"
	desc = "扎实又有滋味。"
	bitesize = 4
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wieneronion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_LONG
	eat_effect = /datum/status_effect/buff/mealbuff
	

/obj/item/reagent_containers/food/snacks/rogue/wieneronions/attackby(obj/item/I, mob/living/user, params)
	var/found_table = locate(/obj/structure/table) in (loc)
	if(!experimental_inhand)
		return
	if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_baked))
		if(isturf(loc)&& (found_table))
			playsound(get_turf(user), 'sound/foley/dropsound/gen_drop.ogg', 30, TRUE, -1)
			if(do_after(user,3 SECONDS, target = src))
				add_sleep_experience(user, /datum/skill/craft/cooking, user.STAINT)
				new /obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions(loc)
				qdel(I)
				qdel(src)
	else
		return ..()

/*	.................   Wiener & potato & onions   ................... */
/obj/item/reagent_containers/food/snacks/rogue/wienerpotatonions
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	tastes = list("咸香香肠" = 1, "土豆香" = 1)
	name = "香肠餐"
	desc = "扎实又顶饱。"
	bitesize = 5
	faretype = FARE_NEUTRAL
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "wpotonion"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/greatmealbuff

/*	.................   Frybird & Tato   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdtato
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	tastes = list("炸禽肉香" = 1, "土豆香" = 1)
	name = "炸鸟排配土豆"
	desc = "扎实、慰藉而丰盛。有人说这是拉沃克斯最喜欢的一餐。"
	bitesize = 4
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frybirdtato"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff

/*	.................   Frybird Bucket   ................... */
/obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE*3)
	tastes = list("炸禽肉香" = 1)
	name = "炸鸟排桶"
	desc = "扎实、慰藉而丰盛。谷地的炸鸟排是全大陆最棒的！现在还装在方便的桶里！"
	bitesize = 9 //ITS AN ENTIRE BUCKET!!
	faretype = FARE_FINE
	portable = FALSE
	icon = 'modular/Neu_Food/icons/cooked/cooked_meat_meal.dmi'
	icon_state = "frybirdbucket"
	foodtype = VEGETABLES | MEAT
	warming = 3 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	trash = /obj/item/reagent_containers/glass/bucket
