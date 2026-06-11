/datum/brewing_recipe/limoncello
	name = "柠檬酒"
	category = "烈酒"
	bottle_name = "柠檬酒"
	bottle_desc = "一瓶本地蒸馏的柠檬酒。口感甜润、带有柑橘清香与灼热余韵。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/limoncello
	pre_reqs = /datum/reagent/consumable/ethanol/voddena
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/fruit/lemon = 2, /obj/item/reagent_containers/food/snacks/sugar = 1)
	brewed_amount = 4
	brew_time = 4 MINUTES
	sell_value = 90
	heat_required = 360
