/datum/brewing_recipe/liquor
	name = "金酒"
	category = "烈酒"
	bottle_name = "金酒"
	bottle_desc = "一瓶本地蒸馏的金酒。风味强烈，带有松针般的清香。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/gin
	pre_reqs = /datum/reagent/consumable/ethanol/voddena
	needed_items = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	brewed_amount = 4
	brew_time = 5 MINUTES
	sell_value = 100
	heat_required = 370

/datum/brewing_recipe/liquor/ricespirit
	name = "米烧酒"
	bottle_name = "米烧酒"
	bottle_desc = "一瓶本地蒸馏的米烧酒。口感清冽，收尾干爽。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/ricespirit
	pre_reqs = /datum/reagent/consumable/ethanol/ricewine
	needed_items = null
	brewed_amount = 4
	sell_value = 90
