/datum/supply_pack/rogue/hammerhold
	group = "Cultural Stock"
	crate_name = "Hammerhold crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/hammerhold/dwarven_maul
	name = "Dwarvish Maul"
	cost = 240
	contains = list(/obj/item/rogueweapon/mace/maul/steel)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/spiked_maul
	name = "Spiked Maul"
	cost = 260
	contains = list(/obj/item/rogueweapon/mace/maul/spiked)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/battleaxe
	name = "Varangian Battleaxe"
	cost = 130
	contains = list(/obj/item/rogueweapon/stoneaxe/woodcut/steel/atgervi)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/hammerhold/owl_helmet
	name = "Owl Helmet"
	cost = 150
	contains = list(/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/moose_hood
	name = "Moose Hood"
	cost = 90
	contains = list(/obj/item/clothing/head/roguetown/helmet/leather/saiga/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/varangian_hauberk
	name = "Varangian Hauberk"
	cost = 180
	contains = list(/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/shamanic_coat
	name = "Shamanic Coat"
	cost = 110
	contains = list(/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/kite_shield
	name = "Varangian Kite Shield"
	cost = 90
	contains = list(/obj/item/rogueweapon/shield/atgervi)
	ship_qty_min = 1
	ship_qty_max = 3

/datum/supply_pack/rogue/hammerhold/fur_gloves
	name = "Fur-Lined Leather Gloves"
	cost = 40
	contains = list(/obj/item/clothing/gloves/roguetown/angle/atgervi)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/hammerhold/bone_gloves
	name = "Fur-Lined Bone Gloves"
	cost = 50
	contains = list(/obj/item/clothing/gloves/roguetown/angle/hammerholdfur)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/hammerhold/beast_claws
	name = "Beast Claws Gauntlets"
	cost = 140
	contains = list(/obj/item/clothing/gloves/roguetown/plate/atgervi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/fur_pants
	name = "Hammerholdian Fur Pants"
	cost = 50
	contains = list(/obj/item/clothing/under/roguetown/trou/leather/atgervi)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/hammerhold/leather_boots
	name = "Atgervi Leather Boots"
	cost = 45
	contains = list(/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/atgervi)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/hammerhold/atgervi_kit
	name = "Atgervi Varangian Harness"
	no_name_quantity = TRUE
	cost = 540
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/chainmail/hauberk/atgervi,
		/obj/item/clothing/suit/roguetown/armor/brigandine/hammerhold,
		/obj/item/clothing/head/roguetown/helmet/bascinet/atgervi,
		/obj/item/clothing/gloves/roguetown/angle/atgervi,
		/obj/item/clothing/under/roguetown/trou/leather/atgervi,
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/atgervi,
		/obj/item/rogueweapon/shield/atgervi,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/iskarn_kit
	name = "Iskarn Shaman Kit"
	no_name_quantity = TRUE
	cost = 380
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/leather/heavy/coat/atgervi,
		/obj/item/clothing/head/roguetown/helmet/leather/saiga/atgervi,
		/obj/item/clothing/gloves/roguetown/angle/hammerholdfur,
		/obj/item/clothing/under/roguetown/trou/leather/atgervi,
		/obj/item/clothing/shoes/roguetown/boots/leather/reinforced/atgervi,
	)
	ship_qty_min = 1
	ship_qty_max = 1


/datum/supply_pack/rogue/hammerhold/smoked_sausage
	name = "Smoked Highland Sausage"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage/cooked,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/hammerhold/bacon
	name = "Mountainhome Bacon"
	cost = 35
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
		/obj/item/reagent_containers/food/snacks/rogue/meat/bacon,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/hammerhold/grudgebearer_smith_kit
	name = "Grudgebearer Smith Harness"
	no_name_quantity = TRUE
	cost = 720
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven/smith,
		/obj/item/clothing/head/roguetown/helmet/heavy/dwarven/smith,
		/obj/item/clothing/gloves/roguetown/plate/dwarven,
		/obj/item/clothing/shoes/roguetown/boots/armor/dwarven,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/grudgebearer_soldier_kit
	name = "Grudgebearer Soldier Harness"
	no_name_quantity = TRUE
	cost = 1000
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/plate/full/dwarven,
		/obj/item/clothing/head/roguetown/helmet/heavy/dwarven,
		/obj/item/clothing/gloves/roguetown/plate/dwarven,
		/obj/item/clothing/shoes/roguetown/boots/armor/dwarven,
		/obj/item/rogueweapon/shield/tower/metal,
	)
	ship_qty_min = 1
	ship_qty_max = 1
/datum/supply_pack/rogue/hammerhold/hammerholdian_norsii_plate
	name = "Norsii Iron Plate"
	cost = 360
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/iron/hammerhold)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/hammerhold/hammerholdian_norsii_helm
	name = "Norsii Horned Helm"
	cost = 90
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/bucket/hammerhold)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/hammerholdian_brigandine
	name = "Hammerholdian Brigandine"
	cost = 200
	contains = list(/obj/item/clothing/suit/roguetown/armor/brigandine/hammerhold)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/hammerhold/norsii_kit
	name = "Norsii Heavy Harness"
	no_name_quantity = TRUE
	cost = 620
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/plate/iron/hammerhold,
		/obj/item/clothing/head/roguetown/helmet/heavy/bucket/hammerhold,
		/obj/item/clothing/gloves/roguetown/plate/iron/hammerhold,
		/obj/item/clothing/under/roguetown/platelegs/iron/hammerhold,
		/obj/item/clothing/shoes/roguetown/boots/armor/iron/hammerhold,
	)
	ship_qty_min = 1
	ship_qty_max = 1
