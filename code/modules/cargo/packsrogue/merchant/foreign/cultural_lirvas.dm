/datum/supply_pack/rogue/lirvas
	group = "Cultural Stock"
	crate_name = "Lirvas crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/lirvas/tabard
	name = "Lirvan Tabard"
	cost = 90
	contains = list(/obj/item/clothing/cloak/ordinatorcape)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/lirvas/pauldrons
	name = "Lirvasi Pauldrons"
	cost = 70
	contains = list(/obj/item/clothing/wrists/roguetown/bracers)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/lirvas/gold_gorget
	name = "Gold-Plated Gorget"
	cost = 180
	contains = list(/obj/item/clothing/neck/roguetown/gorget/steel)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/lirvas/gold_kilt
	name = "Gold-Plated Chain Kilt"
	cost = 160
	contains = list(/obj/item/clothing/under/roguetown/chainlegs/kilt)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/lirvas/gold_quarterstaff
	name = "Gold-Plated Quarterstaff"
	cost = 140
	contains = list(/obj/item/rogueweapon/woodstaff/quarterstaff/steel)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/lirvas/sabre
	name = "Lirvan Sabre"
	cost = 110
	contains = list(/obj/item/rogueweapon/sword/sabre)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/lirvas/tithebound_kit
	name = "Lirvan Tithebound Regalia"
	no_name_quantity = TRUE
	cost = 540
	contains = list(
		/obj/item/clothing/cloak/ordinatorcape,
		/obj/item/clothing/wrists/roguetown/bracers,
		/obj/item/clothing/neck/roguetown/gorget/steel,
		/obj/item/clothing/under/roguetown/chainlegs/kilt,
		/obj/item/storage/belt/rogue/leather/plaquegold,
		/obj/item/clothing/gloves/roguetown/angle,
	)
	ship_qty_min = 1
	ship_qty_max = 1
