/datum/brewing_recipe/voddena
	name = "Voddena"
	category = "谷物"
	bottle_name = "voddena"
	bottle_desc = "一瓶本地酿制的 Voddena。以土豆酿成，口感清冽。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/voddena
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced = 12)
	brewed_amount = 6
	brew_time = 5 MINUTES // Special. Vodden is a bit more time consuming
	sell_value = 60 // But also more expensive.
