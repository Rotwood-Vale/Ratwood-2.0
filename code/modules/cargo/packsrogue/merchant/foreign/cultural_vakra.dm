/datum/supply_pack/rogue/vakra
	group = "Cultural Stock"
	crate_name = "Vakra crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/vakra/vreccale
	name = "Vakran Vreccale"
	cost = 50
	contains = list(/obj/item/clothing/neck/roguetown/gorget/forlorncollar)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/vakra/helmet
	name = "Vakran Volf Helm"
	cost = 70
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/volfplate)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/vakra/warhammer
	name = "Silvered Warhammer"
	cost = 220
	contains = list(/obj/item/rogueweapon/mace/warhammer/steel/silver)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/vakra/shield
	name = "Vakran Shield"
	cost = 50
	contains = list(/obj/item/rogueweapon/shield/heater)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/vakra/siegebow
	name = "Vakra Siegebow"
	cost = 220
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/crossbow/heavy)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/vakra/siegebolts
	name = "Quiver of Heavy Bolts"
	cost = 60
	contains = list(/obj/item/quiver/heavybolts)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/vakra/forlorn_hope_regalia
	name = "Vakran Forlorn Hope Regalia"
	no_name_quantity = TRUE
	cost = 200
	contains = list(
		/obj/item/clothing/neck/roguetown/gorget/forlorncollar,
		/obj/item/clothing/wrists/roguetown/splintarms,
		/obj/item/clothing/head/roguetown/helmet/heavy/volfplate,
		/obj/item/clothing/under/roguetown/splintlegs,
		/obj/item/clothing/suit/roguetown/armor/brigandine/light,
	)
	ship_qty_min = 1
	ship_qty_max = 1
