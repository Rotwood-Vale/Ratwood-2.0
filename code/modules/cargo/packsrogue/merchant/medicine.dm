//Not sure if I'll use this but could be handy.

/datum/supply_pack/rogue/medicine
	group = "Medicine"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
//drugs

/datum/supply_pack/rogue/medicine/ozium
	name = "奥兹姆"
	cost = 8
	contains = list(/obj/item/reagent_containers/powder/ozium)

/datum/supply_pack/rogue/medicine/suidust
	name = "易容之尘（仅性别）"
	cost = 135
	contains = list(/obj/item/alch/transisdust)

/datum/supply_pack/rogue/medicine/antidote
	name = "解毒剂"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/antidote)
	
/datum/supply_pack/rogue/medicine/healthpot
	name = "治疗药水"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot)
	
/datum/supply_pack/rogue/medicine/healthvial
	name = "治疗药剂"
	cost = 15
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew)


/datum/supply_pack/rogue/medicine/bandages
	name = "一卷绷带"
	cost = 25
	contains = list(/obj/item/natural/bundle/cloth/bandage/full)

/datum/supply_pack/rogue/medicine/needles
	name = "针"
	cost = 8
	contains = list(/obj/item/needle)

/datum/supply_pack/rogue/medicine/surgeonsbag
	name = "满配外科包"
	cost = 80
	contains = list(/obj/item/storage/belt/rogue/surgery_bag)
