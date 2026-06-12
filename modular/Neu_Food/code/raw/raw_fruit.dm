/obj/item/reagent_containers/food/snacks/rogue/fruit/apple_sliced
	name = "苹果片"
	icon = 'modular/Neu_Food/icons/raw/raw_fruit.dmi'
	icon_state = "apple_sliced"
	desc = "切得整整齐齐的苹果片，吃起来更方便，甚至还显得挺讲究。"
	faretype = FARE_FINE
	tastes = list("清甜苹果味" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/rogue/fruit/pumpkin_sliced
	name = "南瓜片"
	icon = 'modular/Neu_Food/icons/raw/raw_fruit.dmi'
	icon_state = "pumpkin_sliced"
	desc = "切得整整齐齐的南瓜片，通常还是先煮熟再吃比较好。"
	faretype = FARE_POOR
	tastes = list("生南瓜味" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)
	rotprocess = SHELFLIFE_LONG
