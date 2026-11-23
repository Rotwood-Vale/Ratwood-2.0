/datum/supply_pack/rogue/gronn
	group = "Cultural Stock"
	crate_name = "Gronn crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/gronn/gronnarmor
	name = "Gronnic Hardened Leather Armor"
	cost = 60
	contains = list (/obj/item/clothing/suit/roguetown/armor/leather/Huus_quyaq)

/datum/supply_pack/rogue/gronn/gronnpants
	name = "Nomad Hardened Leather Pants"
	cost = 50
	contains = list (/obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants)

/datum/supply_pack/rogue/gronn/farhat
	name = "Authentic Bearfurred Hat"
	cost = 150
	contains = list(/obj/item/clothing/head/roguetown/hatfur)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/nomadhelmet
	name = "Nöküd Helmet"
	cost = 90
	contains = list(/obj/item/clothing/head/roguetown/helmet/nomadhelmet)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/nomadscalemail
	name = "Nöküd Scalemail"
	cost = 180
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/scale/steppe)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/kurche
	name = "Nöküd Kurche"
	cost = 180
	contains = list(/obj/item/clothing/suit/roguetown/armor/kurche)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/kite_shield
	name = "Nöküd Roundshield"
	cost = 90
	contains = list(/obj/item/rogueweapon/shield/iron/nomad)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/gronn/warrior_kit
	name = "Ba'atur Nöküd Harness"
	no_name_quantity = TRUE
	cost = 540
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/chargah,
		/obj/item/clothing/suit/roguetown/armor/kurche,
		/obj/item/clothing/head/roguetown/helmet/nomadhelmet,
		/obj/item/clothing/gloves/roguetown/angle,
		/obj/item/clothing/under/roguetown/heavy_leather_pants/nomadpants,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron,
		/obj/item/rogueweapon/stoneaxe/woodcut/pick,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/gronn/spider_honey
	name = "Dreamer's Honey"
	cost = 60
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider,
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider,
		/obj/item/reagent_containers/food/snacks/rogue/honey/spider,
	)
	ship_qty_min = 3
	ship_qty_max = 6

/datum/supply_pack/rogue/gronn/cured_megafauna
	name = "Cured Dusk Horn Meat"
	cost = 50
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
		/obj/item/reagent_containers/food/snacks/rogue/meat/coppiette,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/gronn/gronnic_heavy_plate
	name = "Gronn Kheshig Iron Plate"
	cost = 360
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/full/iron)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/gronn/gronnic_heavy_helm
	name = "Gronn Kheshig Bucket Helm"
	cost = 90
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/gronn/heavy_kit
	name = "Kheshig Heavy Harness"
	no_name_quantity = TRUE
	cost = 620
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson,
		/obj/item/clothing/suit/roguetown/armor/plate/full/iron,
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/iron,
		/obj/item/clothing/neck/roguetown/chaincoif/iron,
		/obj/item/clothing/gloves/roguetown/plate/iron,
		/obj/item/clothing/wrists/roguetown/bracers/splint,
		/obj/item/clothing/under/roguetown/platelegs/iron,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/gronn/ring_courage
	name = "Ring of Courage"
	cost = 450
	contains = list(/obj/item/clothing/ring/statrontz)
	ship_qty_min = 1
	ship_qty_max = 1
	ship_chance = 25
