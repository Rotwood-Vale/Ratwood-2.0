// Raw veggies. Sliced variant or something please just put the rest in produce.dm
// Don't define the same shit twice holy shit.
// please don't include fruits that's in raw_fruits.dm

/obj/item/reagent_containers/food/snacks/rogue/veg/onion_sliced
	name = "洋葱片"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "onion_sliced"
	slices_num = 0
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/onion_fried
	cooked_smell = /datum/pollutant/food/fried_onion
	dropshrink = 0.75

/obj/item/reagent_containers/food/snacks/rogue/veg/cabbage_sliced
	name = "卷心菜丝"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "cabbage_sliced"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/cabbage_fried
	cooked_smell = /datum/pollutant/food/fried_cabbage
	dropshrink = 0.9

/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced
	name = "土豆块"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "potato_sliced"
	fried_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cooked_type = /obj/item/reagent_containers/food/snacks/rogue/preserved/potato_fried
	cooked_smell = /datum/pollutant/food/baked_potato
	dropshrink = 0.9

/obj/item/reagent_containers/food/snacks/rogue/veg/cucumber_sliced
	name = "黄瓜片"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "cucumber_slices" // TG Sprite, replace it
	desc = ""
	tastes = list("清脆鲜爽" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/rogue/veg/garlick_clove
	name = "蒜瓣"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "garlic_clove"
	faretype = FARE_POOR
	desc = "一瓣大蒜。最好别直接生吃。"
	tastes = list("辛辣鲜香" = 1)
	list_reagents = list(/datum/reagent/consumable/nutriment = 1)

/obj/item/reagent_containers/food/snacks/veg/turnip_sliced
	name = "处理好的芜菁"
	icon = 'modular/Neu_Food/icons/raw/raw_veggies.dmi'
	icon_state = "turnip_sliced"
