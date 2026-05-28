/datum/roguestock/stockpile/fishmince
	name = "Fish Mince"
	desc = "Descaled and ground fish meat."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/mince/fish
	held_items = list(4, 5) //probably wouldn't be buying fish mince unless someone specifically asks you to
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "Seafood"
	generation_price = 2

/datum/roguestock/stockpile/fishfilet
	name = "Fish Filet"
	desc = "Descaled fish meat."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fish
	held_items = list(4, 6)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1
	category = "Seafood"
	generation_price = 4 
	remote_limit = 8 //same as regular meat!

/datum/roguestock/stockpile/shellfish
	name = "Shellfish Meat"
	desc = "Prepared shellfish meat."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/shellfish
	held_items = list(0, 0)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Seafood"
	generation_price = 4
	remote_limit = 5

/datum/roguestock/stockpile/crabmeat
	name = "Crab Meat"
	desc = "Prepared crab meat."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/crab
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Seafood"
	generation_price = 4
	remote_limit = 5
