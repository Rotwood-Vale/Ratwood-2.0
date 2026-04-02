/datum/brewing_recipe/fermentedcrab
	name = "Crab, Fermented"
	category = "Other"
	bottle_name = "fermented crab" // magical penis wine
	bottle_desc = "Fermented. Crab. One barrel of this triples the brothel's earnings for the week. A man thinks he's done, drinks a mouthful of this. Five minutes later he's back in the race."
	reagent_to_brew = /datum/reagent/fermented_crab
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/crab = 1, 
		/obj/item/reagent_containers/food/snacks/sugar = 2,
		/obj/item/alch/viscera = 1,
		/obj/item/alch/valeriana = 1,
	)
	brewed_amount = 2
	brew_time = 5 MINUTES
	sell_value = 50

/datum/brewing_recipe/chum
	name = "Chum"
	category = "Other"
	bottle_name = "chum"
	bottle_desc = "A barrel of chum slurry. Best splashed on water to stir fish into a frenzy."
	reagent_to_brew = /datum/reagent/chum
	needed_reagents = list(/datum/reagent/water = 198)
	needed_items = list(/obj/item/reagent_containers/food/snacks/rogue/meat/mince = 10,
		/obj/item/alch/viscera = 1,)
	brewed_amount = 6
	brew_time = 2 MINUTES
	sell_value = 30
