// If there's ever more than 10 drinks maybe split this file OK?
/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals
	name = "新鲜玫瑰花瓣"
	desc = "碾碎的玫瑰花瓣，可以食用。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter"
	tastes = list("淡淡甜香" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/rosa_petals_dried
	name = "干玫瑰花瓣"
	desc = "风干的玫瑰花瓣，可用于泡茶。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "rosamatter_dried"
	tastes = list("淡淡甜香" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/coffeebeans
	name = "咖啡豆"
	desc = "刚取出的咖啡豆，质地坚硬，最好先烘焙。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans"
	tastes = list("生涩苦味" = 1)
	bitesize = 1
	seed = /obj/item/seeds/coffee
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	cooked_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/coffeebeansroasted
	name = "烘焙咖啡豆"
	desc = "烘焙后的咖啡豆，风味深得多，可用于煮咖啡。本地种出的品种甚至不磨碎也能直接冲煮。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "coffeebeans_roasted"
	tastes = list("醇厚焦糖香" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY

/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	name = "干茶叶"
	desc = "风干的茶叶，可以食用，也能从中取出种子。还需要用磨盘进一步加工。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teadry"
	tastes = list("苦味" = 1)
	seed = /obj/item/seeds/tea
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
	mill_result = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground

/obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_ground
	name = "磨碎茶叶"
	desc = "磨碎后的茶叶，可用于泡茶。"
	icon = 'modular/Neu_Food/icons/drinks.dmi'
	icon_state = "teaground"
	tastes = list("苦味" = 1)
	bitesize = 1
	list_reagents = list(/datum/reagent/consumable/nutriment = 2)
	rotprocess = null
	w_class = WEIGHT_CLASS_TINY
