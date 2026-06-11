/datum/brewing_recipe/cabbage
	name = "Fireleaf"
	category = "其他"
	bottle_name = "fireleaf"
	bottle_desc = "一瓶本地酿造的 Fireleaf。它以卷心菜酿成，味道糟得惊人。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/fireleaf
	needed_reagents = list(/datum/reagent/water = 198)
	needed_crops = list(/obj/item/reagent_containers/food/snacks/grown/cabbage/rogue = 6)
	brewed_amount = 6
	brew_time = 1 MINUTES
	sell_value = 30 // You get to be special for being bad. 
