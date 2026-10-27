/datum/brewing_recipe/butterhairs
	name = "Butterhairs"
	category = "Grain"
	bottle_name = "butterhairs"
	bottle_desc = "A bottle of dwarven butterhairs brew. Rich and smooth with a buttery warmth."
	reagent_to_brew = /datum/reagent/consumable/ethanol/butterhairs
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/butter = 1, /obj/item/reagent_containers/food/snacks/grown/wheat = 2, /obj/item/reagent_containers/food/snacks/grown/oat = 3)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 60
	req_species = /datum/species/dwarf

/datum/brewing_recipe/stonebeards
	name = "Stonebeard Reserve"
	category = "Grain"
	bottle_name = "stonebeard reserve"
	bottle_desc = "A bottle of dwarven stonebeard reserve. A potent oatlike liquor of dwarven craft."
	reagent_to_brew = /datum/reagent/consumable/ethanol/stonebeards
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/rogue/veg/potato_sliced = 4, /obj/item/reagent_containers/food/snacks/grown/wheat = 2, /obj/item/reagent_containers/food/snacks/grown/oat = 3)
	brewed_amount = 6
	brew_time = 5 MINUTES
	sell_value = 80
	req_species = /datum/species/dwarf
