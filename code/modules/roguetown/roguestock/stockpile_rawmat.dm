/datum/roguestock/stockpile/wood
	name = "木材"
	desc = "截短后便于运输的木料。"
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
	name = "煤炭"
	desc = "用于燃料和合金冶炼的煤块。"
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
	name = "朱砂"
	desc = "一种可用于制取水银的红色矿物。"
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
	name = "石头"
	desc = "石头。可用于建造。"
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
	name = "玻璃料"	//'Raw' glass
	desc = "一种由细磨材料混合而成、用于制玻璃的原料。"
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
	name = "玻璃料"	//'Raw' glass
	desc = "一种由细磨材料混合而成、用于制玻璃的原料。"
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
	name = "粗铁"
	desc = "用于锻造的铁块。"
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
	name = "粗铜"
	desc = "用于锻造和合金冶炼的铜块。"
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
	name = "粗锡"
	desc = "用于锻造和合金冶炼的锡块。"
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
	name = "粗金"
	desc = "未经提炼的金块。"
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
	name = "粗银"
	desc = "未经提炼的银块。"
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
	name = "布料"
	desc = "用于缝纫和裁缝工作的布匹。"
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
	name = "纤维"
	desc = "用于制作布料和其他物品的纤维。"
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
	name = "丝绸"
	desc = "用于制作异域服饰的蜘蛛丝。"
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
	name = "鞣制皮革"
	desc = "已经鞣制完成、可直接加工的皮革。"
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
	name = "兽皮"
	desc = "从动物身上剥下的皮。"
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
	name = "毛皮"
	desc = "带有厚实冬毛的动物皮。"
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
	name = "内脏"
	desc = "取自动物的内脏。"
	item_type = /obj/item/alch/viscera
	held_items = list(2, 4) //only a couple of specific uses, and really easy to get. No need for passive
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 4
	importexport_amt = 5
	stockpile_limit = 12
	generation_price = 3 
