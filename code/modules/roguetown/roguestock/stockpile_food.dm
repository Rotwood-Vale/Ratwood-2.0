// Withdraw Price used to be designed to match export price. 
// However this meant that food were often too expensive to buy as raw materials
// Now for food the withdraw price is set to be the same as the payout price
// Theoretically this does create a perverse incentive to export food instead of selling it locally
// But I live for the consequences of stewards deciding to neglect their local economy.
/datum/roguestock/stockpile/salt
	name = "Salt"
	desc = "Rock salt useful for curing and cooking."
	item_type = /obj/item/reagent_containers/powder/salt
	held_items = list(4,6)
	payout_price = 4
	withdraw_price = 4
	export_price = 8
	importexport_amt = 5
	passive_generation = 2
	stockpile_limit = 25
	category = "Foodstuffs"
	generation_price = 6

/datum/roguestock/stockpile/grain
	name = "Grain"
	desc = "Spelt grain."
	item_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	passive_generation = 3
	stockpile_limit = 50
	category = "Foodstuffs"
	generation_price = 3
	remote_limit = 15 //Just in case there is litterally nobody else making food

/datum/roguestock/stockpile/oat
	name = "Oats"
	desc = "A cereal grain."
	item_type = /obj/item/reagent_containers/food/snacks/grown/oat
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	passive_generation = 1 //fancy, unused grain
	stockpile_limit = 50
	category = "Foodstuffs"
	generation_price = 3
	remote_limit = 15

/datum/roguestock/stockpile/garlick
	name = "Garlick"
	desc = "A pungent root vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	held_items = list(3, 5) //Just one is enough to flavor five dishes, have some for the roundstart, but no passive
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "Foodstuffs"
	generation_price = 2

/datum/roguestock/stockpile/meat
	name = "Meat"
	desc = "Edible flesh harvested from animals."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	held_items = list(9, 6) //lots of local hunters
	payout_price = 4
	withdraw_price = 4
	transport_fee = 2
	export_price = 8
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1
	category = "Foodstuffs"
	generation_price = 8 //getting meat consistently every day is hard!
	remote_limit = 8 //storing it is also a problem

/datum/roguestock/stockpile/poultry
	name = "Bird Meat"
	desc = "Edible flesh harvested from birds."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	held_items = list(8, 4)
	payout_price = 4
	withdraw_price = 4
	transport_fee = 2
	export_price = 8
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 1
	category = "Foodstuffs"
	generation_price = 8
	remote_limit = 8

/datum/roguestock/stockpile/rabbit
	name = "Cabbit Meat"
	desc = "Edible flesh harvested from cabbits."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	held_items = list(4, 9)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	category = "Foodstuffs"
	generation_price = 5
	remote_limit = 8

/datum/roguestock/stockpile/pork
	name = "Pig meat"
	desc = "Piggy meat"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty
	held_items = list(0, 3)
	payout_price = 4
	withdraw_price = 4
	transport_fee = 1
	export_price = 10
	importexport_amt = 5
	stockpile_limit = 25
	category = "Foodstuffs"
	generation_price = 10 //luxury meat
	remote_limit = 8

/datum/roguestock/stockpile/egg
	name = "Egg"
	desc = "Egg laid by a hen."
	item_type = /obj/item/reagent_containers/food/snacks/egg
	held_items = list(4, 2) //used on a lot of stuff roundstart
	payout_price = 3
	withdraw_price = 3
	transport_fee = 2
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 2
	category = "Foodstuffs"
	generation_price = 4
	remote_limit = 8 //also rots, and you can easily get tons from buying one chicken or soilsons

/datum/roguestock/stockpile/fat
	name = "Fat"
	desc = "Greasy flesh from an animal."
	item_type = /obj/item/reagent_containers/food/snacks/fat
	held_items = list(2, 4)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 1 //not really used that much, and also only comes from certain animals, but good tallow source, so it keeps a generation
	category = "Foodstuffs"
	generation_price = 4

/datum/roguestock/stockpile/tallow
	name = "Tallow"
	desc = "Shelf-stabilized fatty tissue."
	item_type = /obj/item/reagent_containers/food/snacks/tallow
	held_items = list(4, 1)
	payout_price = 1
	withdraw_price = 1
	transport_fee = 1
	export_price = 2
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 2
	category = "Foodstuffs"
	generation_price = 2 //should probably just process fat

/datum/roguestock/stockpile/butter
	name = "Butter"
	desc = "The product of milk and salt."
	item_type = /obj/item/reagent_containers/food/snacks/butter
	held_items = list(0, 2) //one stick covers 5 things, should be good for roundstart
	payout_price = 9
	withdraw_price = 9
	transport_fee = 3
	export_price = 13
	importexport_amt = 5
	stockpile_limit = 25
	category = "Foodstuffs"
	generation_price = 12 //high-ish price, no initial generation, buttered stuff is a good sign that the economy's doing good!

/datum/roguestock/stockpile/honey
	name = "Honey"
	desc = "Sweet sweet honey that decays into sugar. Has antibacterial and natural healing properties."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/honey
	held_items = list(0, 3)
	payout_price = 6
	withdraw_price = 6
	transport_fee = 3
	export_price = 9
	importexport_amt = 5
	stockpile_limit = 25
	category = "Foodstuffs"
	generation_price = 8 //mostly a luxury, no generation, still decent price though

/datum/roguestock/stockpile/cheese
	name = "Cheese"
	desc = "The product of milk and salt."
	item_type = /obj/item/reagent_containers/food/snacks/rogue/cheese
	held_items = list(0, 3)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 2
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 1
	category = "Foodstuffs"
	generation_price = 4 

/datum/roguestock/stockpile/onion
	name = "Onion"
	desc = "A bulb vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/onion/rogue
	held_items = list(4, 2)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Foodstuffs"
	generation_price = 2

/datum/roguestock/stockpile/turnip
	name = "Turnip"
	desc = "A hardy root vegetable suitable for soups. Favored by the poor"
	item_type = /obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	held_items = list(4, 2)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //almost never used outside of soups
	category = "Foodstuffs"
	generation_price = 2

/datum/roguestock/stockpile/cabbage
	name = "Cabbage"
	desc = "A leafy vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	held_items = list(4, 2)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //almost never used outside of soups
	category = "Foodstuffs"
	generation_price = 2

/datum/roguestock/stockpile/potato
	name = "Potato"
	desc = "An interesting tuber."
	item_type = /obj/item/reagent_containers/food/snacks/grown/potato/rogue
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Foodstuffs"
	generation_price = 2

/datum/roguestock/stockpile/rice
	name = "Rice"
	desc = "A grain used for cooking."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rice
	held_items = list(2, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "Foodstuffs"
	generation_price = 2
	remote_limit = 15 //grain

/datum/roguestock/stockpile/cucumber
	name = "Cucumber"
	desc = "A refreshing, long and green vegetable."
	item_type = /obj/item/reagent_containers/food/snacks/grown/cucumber
	held_items = list(1, 5)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //still used on some recipes, rarely, so no removal
	category = "Foodstuffs"

/datum/roguestock/stockpile/eggplant
	name = "Eggplant"
	desc = "A large, purple vegetable with a mild taste."
	item_type = /obj/item/reagent_containers/food/snacks/grown/eggplant
	held_items = list(1, 5)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //same as above
	category = "Foodstuffs"
	generation_price = 2

/datum/roguestock/stockpile/carrot
	name = "Carrot"
	desc = "A long vegetable said to help with eyesight."
	item_type = /obj/item/reagent_containers/food/snacks/grown/carrot
	held_items = list(2, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //used on more recipes than the above two, but those recipes are usually full meals
	category = "Foodstuffs"
	generation_price = 2

/datum/roguestock/stockpile/poppy
	name = "Poppy"
	desc = "A seed with a sedative effect."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	held_items = list(0, 3) //rarely if ever used to my knowledge, no natural imports, have some on storage
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 4
	importexport_amt = 10
	stockpile_limit = 50
	category = "Foodstuffs"
	generation_price = 3

/datum/roguestock/stockpile/rocknut
	name = "Rocknut"
	desc = "A nut with mild stimulant properties."
	item_type = /obj/item/reagent_containers/food/snacks/grown/nut
	held_items = list(0, 3) //same as above
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 4
	importexport_amt = 10
	stockpile_limit = 50
	category = "Foodstuffs"
	generation_price = 3

/datum/roguestock/stockpile/sugarcane
	name = "Sugarcane"
	desc = "A plant that can be milled into sugar."
	item_type = /obj/item/reagent_containers/food/snacks/grown/sugarcane
	held_items = list(2, 3)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1
	category = "Foodstuffs"
	generation_price = 3 //should be 2 considering the export price but... everything's the same for some reason? Not touching the others just in case

/datum/roguestock/stockpile/coffee
	name = "Coffee Beans"
	desc = "The seed of the coffee plant, used to make a stimulating drink."
	item_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	held_items = list(0, 3) //luxury, no generation
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "Foodstuffs"
	generation_price = 3 //same as sugarcane

/datum/roguestock/stockpile/tea
	name = "Dried Tea Leaves"
	desc = "Dried tea leaves from the tea plant. Can be grounded and brewed to make tea."
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	held_items = list(0, 5) //same as coffee, but more popular, you can also buy a pack of 8 at the merchant
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "Foodstuffs"
	generation_price = 3 //same as sugarcane
