// Split this file into folder and individual food type

/obj/item/reagent_containers/food/snacks/squiresdelight
	name = "侍从之悦"
	desc = "一根油炸黄油条。侍从们爱不释手，也常被骑士顺手偷走。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_deep_fried.dmi'
	icon_state = "squiresdelight"
	list_reagents = list(/datum/reagent/consumable/nutriment = BUTTER_NUTRITION * 2)
	foodtype = DAIRY | GRAIN
	bitesize = 6 // Consistent with butter
	faretype = FARE_FINE // Now you can eat butter as a knight...
	tastes = list("酥脆吐司碎" = 1, "融化黄油香" = 1)
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	rotprocess = SHELFLIFE_DECENT

// Cooked results
/obj/item/reagent_containers/food/snacks/rogue/meat/nitzel
	name = "炸肉排"
	desc = "一份裹着吐司碎的油炸肉排，已经可以开吃了。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_deep_fried.dmi'
	icon_state = "nitzel"
	faretype = FARE_LAVISH
	foodtype = MEAT | GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	bitesize = 5 // If you go through all of the efforts to make this it should have big portion
	tastes = list("酥脆吐司碎" = 1, "嫩猪肉香" = 1)
	cooked_type = null
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	rotprocess = SHELFLIFE_DECENT

// Doesn't matter it was spider meat if you go through the effort it should be as good
/obj/item/reagent_containers/food/snacks/rogue/meat/nitzel/schnitzel
	name = "炸蜘蛛排"
	desc = "一份裹着吐司碎的油炸炸排，已经可以开吃了。"
	icon_state = "schnitzel"
	tastes = list("酥脆吐司碎" = 1, "嫩蜘蛛肉香" = 1)


/obj/item/reagent_containers/food/snacks/rogue/meat/chickentender
	name = "嫩炸鸟排"
	desc = "一份裹着吐司碎的油炸鸟排，已经可以开吃了。"
	icon = 'modular/Neu_Food/icons/cooked/cooked_deep_fried.dmi'
	icon_state = "chickentender"
	faretype = FARE_LAVISH
	foodtype = MEAT | GRAIN
	list_reagents = list(/datum/reagent/consumable/nutriment = MEAL_GOOD)
	bitesize = 5 // If you go through all of the efforts to make this it should have big portion
	tastes = list("酥脆吐司碎" = 1, "嫩鸡肉香" = 1)
	cooked_type = null
	eat_effect = /datum/status_effect/buff/greatsnackbuff
	rotprocess = SHELFLIFE_DECENT
