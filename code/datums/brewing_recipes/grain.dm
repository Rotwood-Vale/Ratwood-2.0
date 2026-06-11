/datum/brewing_recipe/beer
	name = "小麦啤酒"
	category = "谷物"
	bottle_name = "小麦啤酒"
	bottle_desc = "一瓶本地酿造的小麦啤酒。口感清淡，是西境的常见饮品。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/beer
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 6)
	brewed_amount = 6
	brew_time = 2 MINUTES
	sell_value = 30

/datum/brewing_recipe/beer/oat
	name = "燕麦艾尔"
	bottle_name = "燕麦艾尔"
	bottle_desc = "一瓶本地酿造的燕麦艾尔。风味浓郁而饱满。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/ale
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/oat = 6)

/datum/brewing_recipe/beer/rice
	name = "米酒"
	bottle_name = "米酒"
	bottle_desc = "一瓶本地酿造的米酒。带有甘甜而鲜美的风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/ricewine
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/rice = 6)
