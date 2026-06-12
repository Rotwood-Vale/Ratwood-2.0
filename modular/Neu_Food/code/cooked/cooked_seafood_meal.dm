// File for all cooked seafood meals, not including those that count as pastries.

/*........... Pepperfilet */
/obj/item/reagent_containers/food/snacks/rogue/pepperfish
	name = "胡椒鱼柳"
	desc = "烤鱼对折在一起，外面裹满胡椒。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "pepperfish"
	tastes = list("热鱼香" = 1, "胡椒香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEATSLAB_NUTRITION)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/* salmon st dendor*/
/obj/item/reagent_containers/food/snacks/rogue/dendorsalmon
	name = "圣登多尔鲑鱼"
	desc = "这道菜起源于奥塔瓦，用脂肪与香草制成的绿色酱汁覆在鲑鱼上。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "salmon_st_columbia"
	tastes = list("热鱼香" = 1, "油润草本香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/* salmon wit the berry on it */
/obj/item/reagent_containers/food/snacks/rogue/berrysalmon
	name = "浆果酱鲑鱼"
	desc = "一份把杰克莓果泥铺在胡椒鲑鱼上的菜肴，十分扎实。"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "salmon_berry"
	tastes = list("胡椒鱼香" = 1, "清爽果香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/* lobsta with the pepper all over it*/
/obj/item/reagent_containers/food/snacks/rogue/pepperlobsta
	name = "胡椒龙虾尾"
	desc = "在这愚蠢野兽的尾肉上撒些胡椒，好让它不只是平民也吃得下去。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "pepper_tail"
	tastes = list("胡椒甲壳鲜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/*garlick seabass*/
/obj/item/reagent_containers/food/snacks/rogue/garlickbass
	name = "蒜香海鲈鱼"
	desc = "海鲈鱼上抹满蒜瓣。美味极了。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "garlick_seabass"
	tastes = list("辛香草本" = 1, "松软鱼肉香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/*milk clam*/
/obj/item/reagent_containers/food/snacks/rogue/milkclam
	name = "奶炖蛤蜊"
	desc = "蛤蜊，用牛奶炖煮……真古怪。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "milk_clams"
	tastes = list("奶香贝鲜" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/*ale cod*/
/obj/item/reagent_containers/food/snacks/rogue/alecod
	name = "麦酒鳕鱼"
	desc = "鳕鱼刚出锅就浇上麦酒。嗯……真是个独特的选择。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "ale_cod"
	tastes = list("麦酒浸润鱼香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_NEUTRAL
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/*onion plaice*/
/obj/item/reagent_containers/food/snacks/rogue/onionplaice
	name = "洋葱鲽鱼"
	desc = "一大块鲽鱼配炸洋葱。真香！"
	bitesize = 4
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "onion_plaice"
	tastes = list("洋葱鱼香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_FINE
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/*buttery soles*/
/obj/item/reagent_containers/food/snacks/rogue/buttersole
	name = "黄油鳎鱼"
	desc = "一大片鳎鱼，抹了黄油，边缘煎得酥脆。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "butter_sole"
	tastes = list("油润鱼香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_POOR
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'
	

/*jellied eel*/
/obj/item/reagent_containers/food/snacks/rogue/jelliedeel
	name = "鳗鱼冻"
	desc = "鳗鱼冻！用鳗鱼做成胶质，再把鳗鱼封进鳗鱼胶里！我的天啊！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "jellied_eel"
	tastes = list("滑溜鱼香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_MEAGRE)
	faretype = FARE_LAVISH
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
	drop_sound = 'sound/foley/dropsound/gen_drop.ogg'

/* ............ Shellfish ................... */
/obj/item/reagent_containers/food/snacks/rogue/fryfish/lobster/meal
	name = "黄油龙虾"
	desc = "一只裹满黄油的龙虾。真香！"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "lobster_meal"
	tastes = list("龙虾香" = 1, "黄油香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_AVERAGE)
	faretype = FARE_FINE // Idc lobster is not considered fine dining back then it is now since it use butter + rare fish.
	portable = FALSE
	warming = 5 MINUTES
	rotprocess = SHELFLIFE_DECENT
	eat_effect = /datum/status_effect/buff/mealbuff
// Close enough crab cake has two steps but it is a whatever
/obj/item/reagent_containers/food/snacks/rogue/foodbase/crabcakeraw
	name = "生蟹饼"
	desc = "一种手馅饼变体，里面塞满咸香的黄油贝肉，用抹了黄油的面片制成。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "crab_cake_raw"
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/crabcake
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/crabcake
	cooked_smell = /datum/pollutant/food/pie_base
	w_class = WEIGHT_CLASS_NORMAL
	dropshrink = 0.8

/obj/item/reagent_containers/food/snacks/rogue/crabcake
	name = "蟹饼"
	desc = "一种手馅饼变体，里面塞满咸香的黄油贝肉，用抹了黄油的面片制成。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_seafood_meal.dmi'
	icon_state = "crab_cake"
	eat_effect = /datum/status_effect/buff/greatmealbuff
	bitesize = 4
	list_reagents = list(/datum/reagent/consumable/nutriment = SMALLDOUGH_NUTRITION + MEATSLAB_NUTRITION)
	tastes = list("酥脆黄油面皮与贝肉鲜香" = 1)
	faretype = FARE_LAVISH
	rotprocess = null
	dropshrink = 0.8
