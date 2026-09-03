/datum/crafting_recipe/roguetown/naledi // meant to be only avaliable to naledi and their mages
	always_availible = FALSE
	req_table = TRUE
	tools = list()
	category = "Naledi"
	abstract_type = /datum/crafting_recipe/roguetown/arcana
	skillcraft = /datum/skill/magic/arcane
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/naledi/warstaffore
	name = "Naledi Warstaff - (2 amethysts, 1 woden staff, 1 gold ore)"
	result = /obj/item/rogueweapon/woodstaff/naledi
	reqs = list(/obj/item/roguegem/amethyst = 2,
				/obj/item/rogueweapon/woodstaff = 1
				/obj/item/rogueore/gold = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/naledi/warstaffingot
	name = "Naledi Warstaff - (2 amethysts, 1 woden staff, 1 gold ingot)"
	result = /obj/item/rogueweapon/woodstaff/naledi
	reqs = list(/obj/item/roguegem/amethyst = 2,
				/obj/item/rogueweapon/woodstaff = 1
				/obj/item/ingot/gold = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/naledi/maskore
	name = "Naledi Mask - (1 gold ore)"
	result = /obj/item/roguearmor/helmet/mask/naledi
	reqs = list(/obj/item/rogueore/gold = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/naledi/maskingot
	name = "Naledi Mask - (1 gold ingot)"
	result = /obj/item/roguearmor/helmet/mask/naledi
	reqs = list(/obj/item/ingot/gold = 1)
	craftdiff = 1
