// Adventuring Supplies. General category for random stuffs useful for adventurers
// Like container, bedrolls etc.

/datum/supply_pack/rogue/adventure_supplies
	group = "Adventuring Supplies"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant

/datum/supply_pack/rogue/adventure_supplies/bedroll
	name = "卷铺"
	cost = 13
	contains = list(/obj/item/bedroll)

/datum/supply_pack/rogue/adventure_supplies/waterskin
	name = "水囊"
	cost = 13
	contains = list(/obj/item/reagent_containers/glass/bottle/waterskin)

/datum/supply_pack/rogue/adventure_supplies/saddle
	name = "鞍具"
	cost = 15
	contains = list(/obj/item/natural/saddle)

/datum/supply_pack/rogue/adventure_supplies/satchel
	name = "挎包"
	cost = 13
	contains = list(/obj/item/storage/backpack/rogue/satchel)

/datum/supply_pack/rogue/adventure_supplies/satchelshort
	name = "短款挎包"
	cost = 13
	contains = list(/obj/item/storage/backpack/rogue/satchel/short)

/datum/supply_pack/rogue/adventure_supplies/backpack
	name = "背包"
	cost = 18
	contains = list(/obj/item/storage/backpack/rogue/backpack)

/datum/supply_pack/rogue/adventure_supplies/pouches
	name = "小袋"
	cost = 8
	contains = list(
					/obj/item/storage/belt/rogue/pouch,
					/obj/item/storage/belt/rogue/pouch,
					/obj/item/storage/belt/rogue/pouch)

/datum/supply_pack/rogue/adventure_supplies/belts
	name = "腰带"
	cost = 14
	contains = list(
					/obj/item/storage/belt/rogue/leather,
					/obj/item/storage/belt/rogue/leather,
					/obj/item/storage/belt/rogue/leather,
				)

/datum/supply_pack/rogue/adventure_supplies/sheath
	name = "刀鞘"
	cost = 12
	contains = list(
					/obj/item/rogueweapon/scabbard/sheath
				)

/datum/supply_pack/rogue/adventure_supplies/scabbard
	name = "剑鞘"
	cost = 15
	contains = list(
					/obj/item/rogueweapon/scabbard/sword
				)

/datum/supply_pack/rogue/adventure_supplies/gwstrap
	name = "巨兵背带"
	cost = 25
	contains = list(
					/obj/item/rogueweapon/scabbard/gwstrap
				)

/datum/supply_pack/rogue/adventure_supplies/ropes
	name = "绳索"
	cost = 10
	contains = list(
					/obj/item/rope,
					/obj/item/rope,
					/obj/item/rope,
				)

/datum/supply_pack/rogue/adventure_supplies/woodstaff
	name = "六尺长杆（木杖）"
	cost = 6
	contains = list(/obj/item/rogueweapon/woodstaff)

/datum/supply_pack/rogue/adventure_supplies/quarterstaff
	name = "八尺长杆"
	cost = 12
	contains = list(/obj/item/rogueweapon/woodstaff/quarterstaff)

/datum/supply_pack/rogue/adventure_supplies/lamptern
	name = "灯笼"
	cost = 15
	contains = list(/obj/item/flashlight/flare/torch/lantern)

/datum/supply_pack/rogue/adventure_supplies/folding_table
	name = "折叠桌"
	cost = 35
	contains = list(/obj/item/folding_table_stored)

/datum/supply_pack/rogue/adventure_supplies/folding_alchstation
	name = "炼金台套件"
	cost = 45
	contains = list(/obj/item/folding_table_stored/alchstation)

/datum/supply_pack/rogue/adventure_supplies/folding_alchcauldron
	name = "折叠坩埚"
	cost = 45
	contains = list(/obj/item/folding_table_stored/alchcauldron)


/datum/supply_pack/rogue/adventure_supplies/mess_kit
	name = "行军餐具"
	cost = 60
	contains = list(/obj/item/storage/gadget/messkit)

/datum/supply_pack/rogue/adventure_supplies/needles
	name = "针具"
	cost = 15
	contains = list(/obj/item/needle,
					/obj/item/needle,
					/obj/item/needle)

/datum/supply_pack/rogue/adventure_supplies/rationpaper
	name = "口粮包"
	cost = 20
	contains = list(
					/obj/item/ration,
					/obj/item/ration,
				)

/datum/supply_pack/rogue/adventure_supplies/rollofbandages
	name = "一卷绷带"
	cost = 25
	contains = list(/obj/item/natural/bundle/cloth/bandage/full)

/datum/supply_pack/rogue/adventure_supplies/small_tent
	name = "小型帐篷套件"
	cost = 50
	contains = list(/obj/item/tent_kit)

/datum/supply_pack/rogue/adventure_supplies/ger
	name = "格尔毡帐套件"
	cost = 100
	contains = list(/obj/item/tent_kit/ger)

/datum/supply_pack/rogue/adventure_supplies/yurt
	name = "尤尔特毡帐套件"
	cost = 200
	contains = list(/obj/item/tent_kit/yurt)
