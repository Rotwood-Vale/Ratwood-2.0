/datum/brewing_recipe/brandy
	name = "白兰地，苹果"
	category = "烈酒"
	bottle_name = "苹果白兰地"
	bottle_desc = "一瓶本地蒸馏的苹果白兰地。带着淡淡的焦糖风味。"
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy
	pre_reqs = /datum/reagent/consumable/ethanol/cider
	brewed_amount = 6
	brew_time = 4 MINUTES
	sell_value = 90
	heat_required = 360

/datum/brewing_recipe/brandy/pear
	name = "白兰地，梨"
	bottle_name = "梨白兰地"
	bottle_desc = "一瓶本地蒸馏的梨白兰地。带有熟梨的风味，并伴着一丝香料气息。"
	pre_reqs = /datum/reagent/consumable/ethanol/cider/pear
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/pear

/datum/brewing_recipe/brandy/strawberry
	name = "白兰地，草莓"
	bottle_name = "草莓白兰地"
	bottle_desc = "一瓶本地蒸馏的草莓白兰地。甜味浓郁得近乎压倒一切，收口却很柔顺。"
	pre_reqs = /datum/reagent/consumable/ethanol/cider/strawberry
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/strawberry

/datum/brewing_recipe/brandy/tangerine
	name = "白兰地，橘子"
	bottle_name = "橘子白兰地"
	bottle_desc = "一瓶本地蒸馏的橘子白兰地。带着清淡的柑橘风味，并伴着一丝香料气息。"
	pre_reqs = /datum/reagent/consumable/ethanol/tangerine
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/tangerine

/datum/brewing_recipe/brandy/plum
	name = "白兰地，李子"
	bottle_name = "李子白兰地"
	bottle_desc = "一瓶本地蒸馏的李子白兰地。带着甜润的香草风味。"
	pre_reqs = /datum/reagent/consumable/ethanol/plum_wine
	reagent_to_brew = /datum/reagent/consumable/ethanol/brandy/plum
