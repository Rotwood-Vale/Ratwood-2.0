/datum/brewing_recipe/spidermead
	name = "蛛蜜蜜酒"
	category = "其他"
	bottle_name = "蛛蜜蜜酒"
	bottle_desc = "一瓶本地酿造的蛛蜜蜜酒。喝起来与普通蜜酒同样甘甜，但通常被认为更加上乘、也更精致。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/mead/spider
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/rogue/honey/spider = 6)
	brewed_amount = 6
	brew_time = 3 MINUTES
	sell_value = 75

/datum/brewing_recipe/mead
	name = "蜜酒"
	category = "其他"
	bottle_name = "蜜酒"
	bottle_desc = "一瓶本地酿造的蜜酒。带有甜美的蜂蜜风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/mead
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/rogue/honey = 6)
	brewed_amount = 6
	brew_time = 3 MINUTES
	sell_value = 50
