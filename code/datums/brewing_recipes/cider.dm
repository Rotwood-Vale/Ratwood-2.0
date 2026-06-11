/datum/brewing_recipe/cider
	name = "苹果西打酒"
	category = "果酒"
	bottle_name = "苹果西打酒"
	bottle_desc = "一瓶本地酿造的苹果西打酒。带着香甜清爽的苹果风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider
	needed_reagents = list(/datum/reagent/water = 198)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/apple = 6)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 50

/datum/brewing_recipe/cider/pear
	name = "梨西打酒"
	bottle_name = "梨西打酒"
	bottle_desc = "一瓶本地酿造的梨西打酒。带着香甜而细腻的梨子风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider/pear
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/fruit/pear = 6)

/datum/brewing_recipe/cider/strawberry
	name = "草莓西打酒"
	bottle_name = "草莓西打酒"
	bottle_desc = "一瓶本地酿造的草莓西打酒。带着香甜而细腻的草莓风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/cider/strawberry
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/fruit/strawberry = 6)
