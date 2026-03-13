//Not sure if I'll use this but could be handy.

/datum/supply_pack/rogue/medicine
	group = "Medicine"
	crate_name = "merchant guild's crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
//drugs

/datum/supply_pack/rogue/medicine/ozium
	name = "Ozium"
	cost = 8
	contains = list(/obj/item/reagent_containers/powder/ozium)

/datum/supply_pack/rogue/medicine/suidust
	name = "Dust of Disguise (Gender only)"
	cost = 135
	contains = list(/obj/item/alch/transisdust)

/datum/supply_pack/rogue/medicine/antidote
	name = "Poison Antidote"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/antidote)
	
/datum/supply_pack/rogue/medicine/healthpot
	name = "Healing Potion"
	cost = 25
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpot)
	
/datum/supply_pack/rogue/medicine/healthvial
	name = "Healing Vial"
	cost = 15
	contains = list(/obj/item/reagent_containers/glass/bottle/rogue/healthpotnew)


/datum/supply_pack/rogue/medicine/bandages
	name = "Roll of bandages"
	cost = 25
	contains = list(/obj/item/natural/bundle/cloth/bandage/full)

/datum/supply_pack/rogue/medicine/needles
	name = "Needle"
	cost = 8
	contains = list(/obj/item/needle)

/datum/supply_pack/rogue/medicine/surgeonsbag
	name = "Surgeon's bag, Full"
	cost = 80
	contains = list(/obj/item/storage/belt/rogue/surgery_bag)
