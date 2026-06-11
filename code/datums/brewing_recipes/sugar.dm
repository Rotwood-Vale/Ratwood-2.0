/datum/brewing_recipe/molasses
	name = "糖蜜"
	category = "其他"
	bottle_name = "糖蜜"
	bottle_desc = "一瓶糖蜜。由糖制成的浓稠深色糖浆。"
	reagent_to_brew = /datum/reagent/consumable/sugar/molasses
	needed_items = list(/obj/item/reagent_containers/food/snacks/sugar = 6)
	brewed_amount = 6
	brew_time = 3 MINUTES
	sell_value = 30

/datum/brewing_recipe/rum
	name = "朗姆酒"
	category = "烈酒"
	bottle_name = "朗姆酒"
	bottle_desc = "一瓶本地蒸馏的朗姆酒。口感香甜，带着些许焦糖与香草的气息。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/rum
	pre_reqs = /datum/reagent/consumable/sugar/molasses
	brewed_amount = 4
	brew_time = 4 MINUTES
	sell_value = 90
	heat_required = 380
