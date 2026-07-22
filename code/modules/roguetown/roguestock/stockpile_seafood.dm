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

/datum/roguestock/stockpile/salmon // Most of the ones below here have a very low limit since it's a SPECIFIC fish, so it gets to keep low price
	name = "Salmon"
	desc = "Whole slab of salmon."
	item_type = /obj/item/reagent_containers/food/snacks/fish/salmon
	held_items = list(0, 0)
	payout_price = 4
	withdraw_price = 15
	transport_fee = 10
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 10
	category = "Seafood"
	generation_price = 4 
	remote_limit = 5

/datum/roguestock/stockpile/bass
	name = "Seabass"
	desc = "Whole slab of bass."
	item_type = /obj/item/reagent_containers/food/snacks/fish/bass
	held_items = list(1, 3) //I know it's needed for revives, but if you need a lot or consider asking the steward for some
	payout_price = 4
	withdraw_price = 15
	transport_fee = 10
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 10
	category = "Seafood"
	generation_price = 4
	remote_limit = 5

/datum/roguestock/stockpile/carp
	name = "Carp"
	desc = "Whole slab of carp."
	item_type = /obj/item/reagent_containers/food/snacks/fish/carp
	held_items = list(0, 0)
	payout_price = 4
	withdraw_price = 12
	transport_fee = 8
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 15
	category = "Seafood"
	generation_price = 4 
	remote_limit = 5

/datum/roguestock/stockpile/sole
	name = "Sole"
	desc = "Whole slab of sole."
	item_type = /obj/item/reagent_containers/food/snacks/fish/sole
	held_items = list(1, 3) //I know it's needed for revives, but if you need a lot or consider asking the steward for some
	payout_price = 4
	withdraw_price = 15
	transport_fee = 10
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 10
	category = "Seafood"
	generation_price = 4
	remote_limit = 5

/datum/roguestock/stockpile/cod
	name = "Cod"
	desc = "Whole slab of cod."
	item_type = /obj/item/reagent_containers/food/snacks/fish/cod
	held_items = list(1, 3) //I know it's needed for revives, but if you need a lot or consider asking the steward for some
	payout_price = 4
	withdraw_price = 12
	transport_fee = 8
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 10
	category = "Seafood"
	generation_price = 4
	remote_limit = 5

/datum/roguestock/stockpile/crab
	name = "Crab"
	desc = "Whole slab of crab."
	item_type = /obj/item/reagent_containers/food/snacks/fish/crab
	held_items = list(0, 0)
	
	payout_price = 4
	withdraw_price = 30
	transport_fee = 20
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 10
	category = "Seafood"
	generation_price = 4
	remote_limit = 5

/datum/roguestock/stockpile/clam
	name = "Clam"
	desc = "Whole slab of clam."
	item_type = /obj/item/reagent_containers/food/snacks/fish/clam
	held_items = list(0, 0)
	
	payout_price = 4
	withdraw_price = 12
	transport_fee = 8
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 10
	category = "Seafood"
	generation_price = 4
	remote_limit = 5

/datum/roguestock/stockpile/lobster
	name = "Lobster"
	desc = "Whole slab of lobster."
	item_type = /obj/item/reagent_containers/food/snacks/fish/lobster
	held_items = list(0, 3) //I know it's needed for revives, but if you need a lot or consider asking the steward for some
	
	payout_price = 4
	withdraw_price = 15
	transport_fee = 10
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 10
	category = "Seafood"
	generation_price = 4
	remote_limit = 5

/datum/roguestock/stockpile/shrimp
	name = "Shrimp"
	desc = "Whole slab of shrimp."
	item_type = /obj/item/reagent_containers/food/snacks/fish/shrimp
	held_items = list(0, 0)
	
	payout_price = 4
	withdraw_price = 12
	transport_fee = 8
	export_price = 4
	importexport_amt = 10
	stockpile_limit = 10
	category = "Seafood"
	generation_price = 4
	remote_limit = 5
