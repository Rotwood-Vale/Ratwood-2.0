/datum/supply_pack/rogue/naledi
	group = "Cultural Stock"
	crate_name = "Naledi crate"
	crate_type = /obj/structure/closet/crate/chest/merchant
	not_in_public = TRUE

/datum/supply_pack/rogue/naledi/hierophant_kit
	name = "Naledi Hierophant Vestments"
	no_name_quantity = TRUE
	cost = 290
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant,
		/obj/item/clothing/suit/roguetown/shirt/robe/hierophant,
		/obj/item/clothing/head/roguetown/roguehood/hierophant,
		/obj/item/clothing/cloak/hierophant,
		/obj/item/clothing/mask/rogue/lordmask/naledi,
		/obj/item/clothing/neck/roguetown/psicross/naledi,
		/obj/item/clothing/shoes/roguetown/sandals,
		/obj/item/rogueweapon/woodstaff/naledi,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/naledi/pontifex_kit
	name = "Naledi Pontifex Vestments"
	no_name_quantity = TRUE
	cost = 200
	contains = list(
		/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex,
		/obj/item/clothing/suit/roguetown/shirt/robe/pointfex,
		/obj/item/clothing/head/roguetown/roguehood/pontifex,
		/obj/item/clothing/under/roguetown/trou/leather/pontifex,
		/obj/item/clothing/mask/rogue/lordmask/naledi,
		/obj/item/clothing/neck/roguetown/psicross/naledi,
		/obj/item/clothing/shoes/roguetown/sandals,
		/obj/item/clothing/gloves/roguetown/angle/pontifex,
	)
	ship_qty_min = 1
	ship_qty_max = 1

/datum/supply_pack/rogue/naledi/psicross
	name = "Naledi Psicross"
	cost = 80
	contains = list(/obj/item/clothing/neck/roguetown/psicross/naledi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/lordmask
	name = "Naledi Lordmask"
	cost = 70
	contains = list(/obj/item/clothing/mask/rogue/lordmask/naledi)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/pashmina
	name = "Hierophant's Pashmina"
	cost = 45
	contains = list(/obj/item/clothing/head/roguetown/roguehood/hierophant)
	ship_qty_min = 2
	ship_qty_max = 4

/datum/supply_pack/rogue/naledi/hierophantshawl
	name = "Hierophant Shawl"
	cost = 60
	contains = list(/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/hierophant)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/naleditrou
	name = "Pontifex's Chaqchur"
	cost = 40 
	contains = list (/obj/item/clothing/under/roguetown/trou/leather/pontifex)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/naledigamba
	name = "Pontifex's Kaftan"
	cost = 60 // Base sellprice of 30
	contains = list (/obj/item/clothing/suit/roguetown/armor/gambeson/heavy/pontifex)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/sandals
	name = "Naledi Sandals"
	cost = 25
	contains = list(
		/obj/item/clothing/shoes/roguetown/sandals,
		/obj/item/clothing/shoes/roguetown/sandals,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/naledi/treatise
	name = "Path of the War Scholar Treatise"
	cost = 60
	contains = list(
		/obj/item/book/rogue/naledi1,
		/obj/item/book/rogue/naledi2,
		/obj/item/book/rogue/naledi3,
		/obj/item/book/rogue/naledi4,
	)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/glassen_decanters
	name = "Glassen Decanter Set"
	cost = 30
	contains = list(
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
		/obj/item/reagent_containers/glass/bottle/rogue,
	)
	ship_qty_min = 2
	ship_qty_max = 5

/datum/supply_pack/rogue/naledi/glass_statue
	name = "Glassen Masterwork Statue"
	cost = 110
	contains = list(/obj/item/roguestatue/glass)
	ship_qty_min = 1
	ship_qty_max = 2

/datum/supply_pack/rogue/naledi/gold_finery
	name = "Veralun Gold Finery"
	cost = 180
	contains = list(
		/obj/item/clothing/ring/gold,
		/obj/item/clothing/ring/gold,
	)
	ship_qty_min = 1
	ship_qty_max = 2
