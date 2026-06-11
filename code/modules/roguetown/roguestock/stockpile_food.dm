// Withdraw Price used to be designed to match export price. 
// However this meant that food were often too expensive to buy as raw materials
// Now for food the withdraw price is set to be the same as the payout price
// Theoretically this does create a perverse incentive to export food instead of selling it locally
// But I live for the consequences of stewards deciding to neglect their local economy.
/datum/roguestock/stockpile/salt
	name = "盐"
	desc = "可用于腌制和烹饪的岩盐。"
	item_type = /obj/item/reagent_containers/powder/salt
	held_items = list(4,6)
	payout_price = 4
	withdraw_price = 4
	export_price = 8
	importexport_amt = 5
	passive_generation = 2
	stockpile_limit = 25
	category = "食材"
	generation_price = 6

/datum/roguestock/stockpile/grain
	name = "谷物"
	desc = "斯佩耳特小麦。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/wheat
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	passive_generation = 3
	stockpile_limit = 50
	category = "食材"
	generation_price = 3
	remote_limit = 15 //Just in case there is litterally nobody else making food

/datum/roguestock/stockpile/oat
	name = "燕麦"
	desc = "一种谷物。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/oat
	held_items = list(0, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	passive_generation = 1 //fancy, unused grain
	stockpile_limit = 50
	category = "食材"
	generation_price = 3
	remote_limit = 15

/datum/roguestock/stockpile/garlick
	name = "大蒜"
	desc = "一种气味辛烈的根茎蔬菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/garlick/rogue
	held_items = list(3, 5) //Just one is enough to flavor five dishes, have some for the roundstart, but no passive
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "食材"
	generation_price = 2

/datum/roguestock/stockpile/meat
	name = "肉"
	desc = "从动物身上获取的可食用肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/steak
	held_items = list(9, 6) //lots of local hunters
	payout_price = 4
	withdraw_price = 4
	transport_fee = 2
	export_price = 8
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1
	category = "食材"
	generation_price = 8 //getting meat consistently every day is hard!
	remote_limit = 8 //storing it is also a problem

/datum/roguestock/stockpile/poultry
	name = "禽肉"
	desc = "从鸟类身上获取的可食用肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/poultry
	held_items = list(8, 4)
	payout_price = 4
	withdraw_price = 4
	transport_fee = 2
	export_price = 8
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 1
	category = "食材"
	generation_price = 8
	remote_limit = 8

/datum/roguestock/stockpile/rabbit
	name = "卡比特肉"
	desc = "从卡比特身上获取的可食用肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/rabbit
	held_items = list(4, 9)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	category = "食材"
	generation_price = 5
	remote_limit = 8

/datum/roguestock/stockpile/pork
	name = "猪肉"
	desc = "猪肉。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/meat/fatty
	held_items = list(0, 3)
	payout_price = 4
	withdraw_price = 4
	transport_fee = 1
	export_price = 10
	importexport_amt = 5
	stockpile_limit = 25
	category = "食材"
	generation_price = 10 //luxury meat
	remote_limit = 8

/datum/roguestock/stockpile/egg
	name = "蛋"
	desc = "母鸡下的蛋。"
	item_type = /obj/item/reagent_containers/food/snacks/egg
	held_items = list(4, 2) //used on a lot of stuff roundstart
	payout_price = 3
	withdraw_price = 3
	transport_fee = 2
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 2
	category = "食材"
	generation_price = 4
	remote_limit = 8 //also rots, and you can easily get tons from buying one chicken or soilsons

/datum/roguestock/stockpile/fat
	name = "脂肪"
	desc = "动物身上的油脂。"
	item_type = /obj/item/reagent_containers/food/snacks/fat
	held_items = list(2, 4)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 1 //not really used that much, and also only comes from certain animals, but good tallow source, so it keeps a generation
	category = "食材"
	generation_price = 4

/datum/roguestock/stockpile/tallow
	name = "动物脂"
	desc = "可长期保存的脂肪组织。"
	item_type = /obj/item/reagent_containers/food/snacks/tallow
	held_items = list(4, 1)
	payout_price = 1
	withdraw_price = 1
	transport_fee = 1
	export_price = 2
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 2
	category = "食材"
	generation_price = 2 //should probably just process fat

/datum/roguestock/stockpile/butter
	name = "黄油"
	desc = "牛奶与盐制成的产物。"
	item_type = /obj/item/reagent_containers/food/snacks/butter
	held_items = list(0, 2) //one stick covers 5 things, should be good for roundstart
	payout_price = 9
	withdraw_price = 9
	transport_fee = 3
	export_price = 13
	importexport_amt = 5
	stockpile_limit = 25
	category = "食材"
	generation_price = 12 //high-ish price, no initial generation, buttered stuff is a good sign that the economy's doing good!

/datum/roguestock/stockpile/honey
	name = "蜂蜜"
	desc = "甜美的蜂蜜，最终会分解成糖。具有抗菌和天然疗愈特性。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/honey
	held_items = list(0, 3)
	payout_price = 6
	withdraw_price = 6
	transport_fee = 3
	export_price = 9
	importexport_amt = 5
	stockpile_limit = 25
	category = "食材"
	generation_price = 8 //mostly a luxury, no generation, still decent price though

/datum/roguestock/stockpile/cheese
	name = "奶酪"
	desc = "牛奶与盐制成的产物。"
	item_type = /obj/item/reagent_containers/food/snacks/rogue/cheese
	held_items = list(0, 3)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 2
	export_price = 5
	importexport_amt = 5
	stockpile_limit = 25
	passive_generation = 1
	category = "食材"
	generation_price = 4 

/datum/roguestock/stockpile/onion
	name = "洋葱"
	desc = "一种鳞茎蔬菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/onion/rogue
	held_items = list(4, 2)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "食材"
	generation_price = 2

/datum/roguestock/stockpile/turnip
	name = "芜菁"
	desc = "一种耐寒的根茎蔬菜，适合煮汤，深受穷人喜爱。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/vegetable/turnip
	held_items = list(4, 2)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //almost never used outside of soups
	category = "食材"
	generation_price = 2

/datum/roguestock/stockpile/cabbage
	name = "卷心菜"
	desc = "一种叶菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/cabbage/rogue
	held_items = list(4, 2)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //almost never used outside of soups
	category = "食材"
	generation_price = 2

/datum/roguestock/stockpile/potato
	name = "土豆"
	desc = "一种有意思的块茎。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/potato/rogue
	held_items = list(0, 0)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "食材"
	generation_price = 2

/datum/roguestock/stockpile/rice
	name = "大米"
	desc = "一种用于烹饪的谷物。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/rice
	held_items = list(2, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 2
	category = "食材"
	generation_price = 2
	remote_limit = 15 //grain

/datum/roguestock/stockpile/cucumber
	name = "黄瓜"
	desc = "一种清爽、细长且绿色的蔬菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/cucumber
	held_items = list(1, 5)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //still used on some recipes, rarely, so no removal
	category = "食材"

/datum/roguestock/stockpile/eggplant
	name = "茄子"
	desc = "一种个头较大、呈紫色且味道温和的蔬菜。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/eggplant
	held_items = list(1, 5)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //same as above
	category = "食材"
	generation_price = 2

/datum/roguestock/stockpile/carrot
	name = "胡萝卜"
	desc = "一种细长的蔬菜，据说有助于视力。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/carrot
	held_items = list(2, 4)
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1 //used on more recipes than the above two, but those recipes are usually full meals
	category = "食材"
	generation_price = 2

/datum/roguestock/stockpile/poppy
	name = "罂粟"
	desc = "具有镇静效果的种子。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/poppy
	held_items = list(0, 3) //rarely if ever used to my knowledge, no natural imports, have some on storage
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 4
	importexport_amt = 10
	stockpile_limit = 50
	category = "食材"
	generation_price = 3

/datum/roguestock/stockpile/rocknut
	name = "石果"
	desc = "具有轻微提神效果的坚果。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/nut
	held_items = list(0, 3) //same as above
	payout_price = 2
	withdraw_price = 2
	transport_fee = 1
	export_price = 4
	importexport_amt = 10
	stockpile_limit = 50
	category = "食材"
	generation_price = 3

/datum/roguestock/stockpile/sugarcane
	name = "甘蔗"
	desc = "一种可以碾磨制糖的植物。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/sugarcane
	held_items = list(2, 3)
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	passive_generation = 1
	category = "食材"
	generation_price = 3 //should be 2 considering the export price but... everything's the same for some reason? Not touching the others just in case

/datum/roguestock/stockpile/coffee
	name = "咖啡豆"
	desc = "咖啡植物的种子，可用来制作提神饮品。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/coffeebeans
	held_items = list(0, 3) //luxury, no generation
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "食材"
	generation_price = 3 //same as sugarcane

/datum/roguestock/stockpile/tea
	name = "干茶叶"
	desc = "茶树上采下并晒干的茶叶，可研磨后冲泡成茶。"
	item_type = /obj/item/reagent_containers/food/snacks/grown/rogue/tealeaves_dry
	held_items = list(0, 5) //same as coffee, but more popular, you can also buy a pack of 8 at the merchant
	payout_price = 3
	withdraw_price = 3
	transport_fee = 1
	export_price = 3
	importexport_amt = 10
	stockpile_limit = 50
	category = "食材"
	generation_price = 3 //same as sugarcane
