/datum/roguestock/stockpile/wood
	name = "Wood"
	desc = "Wooden logs cut short for transport."
	item_type = /obj/item/grown/log/tree/small
	held_items = list(5, 7)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 3
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 5
	generation_price = 4
	remote_limit = 20 //sometimes people need a lot of wood! And it's not exactly that hard to store or obtain either

/datum/roguestock/stockpile/coal
	name = "Coal"
	desc = "Chunks of coal used for fuel and alloying."
	item_type = /obj/item/rogueore/coal
	held_items = list(5, 0)
	payout_price = 4
	withdraw_price = 4
	transport_fee = 4
	export_price = 6
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	generation_price = 5

/datum/roguestock/stockpile/cinnabar
	name = "Cinnabar"
	desc = "A red mineral used to make quicksilver."
	item_type = /obj/item/rogueore/cinnabar
	held_items = list(0, 0)
	payout_price = 5
	withdraw_price = 5
	transport_fee = 10
	export_price = 10
	stockpile_limit = 50
	importexport_amt = 5
	passive_generation = 1
	generation_price = 8

/datum/roguestock/stockpile/stone
	name = "Stone"
	desc = "Stones. Used for construction"
	item_type = /obj/item/natural/stone
	held_items = list(10, 0)
	payout_price = 1
	withdraw_price = 1
	transport_fee = 0
	export_price = 1
	importexport_amt = 10
	stockpile_limit = 50 // Allow a small amount of stones to be sold for chiselling
	passive_generation = 10
	remote_limit = 25 //The rocks aren't free anymore!! So at least you get to buy a lot more before wasting money
	generation_price = 1 

/datum/roguestock/stockpile/glass
	name = "Glass Batch"	//'Raw' glass
	desc = "A mixture of finely ground materials that is used to make glass."
	item_type = /obj/item/natural/clay/glassbatch
	held_items = list(5, 0)
	payout_price = 4
	withdraw_price = 4
	transport_fee = 5
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 3
	generation_price = 4

/datum/roguestock/stockpile/glass
	name = "Glass Batch"	//'Raw' glass
	desc = "A mixture of finely ground materials that is used to make glass."
	item_type = /obj/item/natural/clay/glassbatch
	held_items = list(5, 0)
	payout_price = 4
	withdraw_price = 4
	transport_fee = 5
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 3

/datum/roguestock/stockpile/iron
	name = "Raw Iron"
	desc = "Chunks of iron used for smithing."
	item_type = /obj/item/rogueore/iron
	held_items = list(9, 5)
	payout_price = 5
	withdraw_price = 5
	transport_fee = 6
	export_price = 8
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	generation_price = 8 //high demand!

/datum/roguestock/stockpile/copper
	name = "Raw Copper"
	desc = "Chunks of copper used for smithing and alloying."
	item_type = /obj/item/rogueore/copper
	held_items = list(6, 8)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 3
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1
	generation_price = 4

/datum/roguestock/stockpile/tin
	name = "Raw Tin"
	desc = "Chunks of tin used for smithing and alloying."
	item_type = /obj/item/rogueore/tin
	held_items = list(6, 6)
	payout_price = 4
	withdraw_price = 4
	transport_fee = 4
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1
	generation_price = 4

/datum/roguestock/stockpile/gold
	name = "Raw Gold"
	desc = "Chunks of unrefined gold."
	item_type = /obj/item/rogueore/gold
	held_items = list(0, 0)
	payout_price = 50
	withdraw_price = 50
	transport_fee = 10
	export_price = 75
	stockpile_limit = 50
	importexport_amt = 10
	generation_price = 80 //you don't even get to dodge tax with this one, but not blocked just in case the steward strikes a deal with someone 

/datum/roguestock/stockpile/silver
	name = "Raw Silver"
	desc = "Chunks of unrefined silver."
	item_type = /obj/item/rogueore/silver
	held_items = list(0, 0)
	payout_price = 75
	withdraw_price = 75
	transport_fee = 10
	export_price = 100
	export_only = TRUE
	stockpile_limit = 25
	importexport_amt = 5
	no_passive = TRUE

/datum/roguestock/stockpile/cloth
	name = "Cloth"
	desc = "Lengths of cloth for sewing and tailoring."
	item_type = /obj/item/natural/cloth
	held_items = list(0, 2)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 2
	export_price = 5
	importexport_amt = 10
	stockpile_limit = 100
	passive_generation = 2
	generation_price = 3 //tailors kind of rely on this one, and it's also not hard to produce at all, one less mammon
	remote_limit = 15 //not exactly hard to store, and also you usually need loads of it all at once

/datum/roguestock/stockpile/fibers
	name = "Fibers"
	desc = "Strands used to make cloth and other items."
	item_type = /obj/item/natural/fibers
	held_items = list(0, 2)
	payout_price = 1
	withdraw_price = 1
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 4
	generation_price = 1 //same as cloth
	remote_limit = 20

/datum/roguestock/stockpile/silk
	name = "Silk"
	desc = "Strands of spider silk used to make exotic clothes."
	item_type = /obj/item/natural/silk
	held_items = list(0, 2)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 4
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 1
	generation_price = 2
//natural/hide/cured must be defined/populated in sstreasury before natural/hide, for istype stockpile check to work
/datum/roguestock/stockpile/cured
	name = "Cured Leather"
	desc = "Cured Leather ready to be worked."
	item_type = /obj/item/natural/hide/cured
	held_items = list(5, 2)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 3
	export_price = 7
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1
	generation_price = 6 //should probably cure your own leather if you can help it
	remote_limit = 12 //same as cloth! Kind of

/datum/roguestock/stockpile/hide
	name = "Hide"
	desc = "Stripped hide from animals."
	item_type = /obj/item/natural/hide
	held_items = list(4, 2)
	payout_price = 8
	withdraw_price = 8
	transport_fee = 2
	export_price = 12
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 1
	generation_price = 10 

/datum/roguestock/stockpile/fur
	name = "Fur"
	desc = "Hide with a long winter coat from animals."
	item_type = /obj/item/natural/fur
	held_items = list(2, 9) //a bit of a luxury thing, so you get tons at the start but no generation roundstart
	payout_price = 10
	withdraw_price = 10
	transport_fee = 4
	export_price = 15
	importexport_amt = 5
	stockpile_limit = 25
	generation_price = 12

/datum/roguestock/stockpile/viscera
	name = "Viscera"
	desc = "Viscera from animals."
	item_type = /obj/item/alch/viscera
	held_items = list(2, 4) //only a couple of specific uses, and really easy to get. No need for passive
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 4
	importexport_amt = 5
	stockpile_limit = 12
	generation_price = 3 
