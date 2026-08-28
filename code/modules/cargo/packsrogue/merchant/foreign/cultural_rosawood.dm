// the woad light helm and maille, the blackoak barbutes, the woad recurve bow and the javelin
// quiver do not exist. Their packs are omitted until those items are ported.
/datum/supply_pack/rogue/rosawood
	group = "Cultural Stock"
	crate_name = "Rosawood crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/rosawood/woad_helm
	name = "Woad Elven Helm"
	cost = 95
	contains = list(/obj/item/clothing/head/roguetown/helmet/heavy/elven_helm)

/datum/supply_pack/rogue/rosawood/woad_plate
	name = "Woad Elven Plate"
	cost = 160
	contains = list(/obj/item/clothing/suit/roguetown/armor/plate/elven_plate)

/datum/supply_pack/rogue/rosawood/elven_boots
	name = "Woad Elven Boots"
	cost = 35
	contains = list(/obj/item/clothing/shoes/roguetown/boots/leather/elven_boots)

/datum/supply_pack/rogue/rosawood/elven_gloves
	name = "Woad Elven Gloves"
	cost = 30
	contains = list(/obj/item/clothing/gloves/roguetown/elven_gloves)

/datum/supply_pack/rogue/rosawood/forrester_cloak
	name = "Forrester Cloak"
	cost = 45
	contains = list(/obj/item/clothing/cloak/forrestercloak)

/datum/supply_pack/rogue/rosawood/woad_furcloak
	name = "Warden's Fur Cloak"
	cost = 55
	contains = list(/obj/item/clothing/cloak/raincloak/furcloak/woad)

// Ranged

/datum/supply_pack/rogue/rosawood/recurve_bow
	name = "Recurve Bow"
	cost = 50
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/recurve)

/datum/supply_pack/rogue/rosawood/yew_longbow
	name = "Yew Longbow"
	cost = 75
	contains = list(/obj/item/gun/ballistic/revolver/grenadelauncher/bow/longbow)

/datum/supply_pack/rogue/rosawood/arrows
	name = "Quiver of Arrows"
	cost = 35
	contains = list(/obj/item/quiver/arrows)

/datum/supply_pack/rogue/rosawood/bodkins
	name = "Quiver of Bodkin Arrows"
	cost = 60
	contains = list(/obj/item/quiver/bodkin)

/datum/supply_pack/rogue/rosawood/honey
	name = "Jars of Honey"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/honey,
		/obj/item/reagent_containers/food/snacks/rogue/honey,
		/obj/item/reagent_containers/food/snacks/rogue/honey,
	)

/datum/supply_pack/rogue/rosawood/raisin_loaf
	name = "Raisin Loaves"
	cost = 40
	contains = list(
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread,
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread,
		/obj/item/reagent_containers/food/snacks/rogue/raisinbread,
	)

/datum/supply_pack/rogue/rosawood/apples
	name = "Rosawood Apples"
	cost = 20
	contains = list(
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
		/obj/item/reagent_containers/food/snacks/grown/apple,
	)

/datum/supply_pack/rogue/rosawood/pears
	name = "Rosawood Pears"
	cost = 20
	contains = list(
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
		/obj/item/reagent_containers/food/snacks/grown/fruit/pear,
	)

/datum/supply_pack/rogue/rosawood/berries
	name = "Rosawood Jacksberries"
	cost = 20
	contains = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue,
	)

/datum/supply_pack/rogue/rosawood/butter
	name = "Butter"
	cost = 30
	contains = list(
		/obj/item/reagent_containers/food/snacks/butter,
		/obj/item/reagent_containers/food/snacks/butter,
		/obj/item/reagent_containers/food/snacks/butter,
	)

//// Elven Blades
/datum/supply_pack/rogue/rosawood/elfsword
	name = "Elven Shortsword"
	cost = 60
	contains = list(/obj/item/rogueweapon/sword/short/elf)
	
/datum/supply_pack/rogue/rosawood/elflongsword
	name = "Elven Longsword"
	cost = 80
	contains = list(/obj/item/rogueweapon/sword/long/elf)

/datum/supply_pack/rogue/rosawood/elfswordspear
	name = "Elven Swordspear"
	cost = 100
	contains = list(/obj/item/rogueweapon/spear/naginata/elf)

/datum/supply_pack/rogue/rosawood/elfcurveblade
	name = "Elven Curveblade"
	cost = 120
	contains = list(/obj/item/rogueweapon/greatsword/elf)

