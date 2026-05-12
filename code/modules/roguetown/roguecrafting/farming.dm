/datum/crafting_recipe/roguetown/farming
	req_table = FALSE
	verbage_simple = "mix"
	skillcraft = /datum/skill/labor/farming
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/farming/fertilizer
	name = "fertilizer"
	result = /obj/item/fertilizer
	reqs = list(/obj/item/compost = 1, /obj/item/natural/bone = 1, /obj/item/natural/poo = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/farming/fertilizer/druidic
	name = "fertilizer (druidic)"
	result = list(/obj/item/fertilizer, /obj/item/fertilizer)
	reqs = list(/obj/item/compost = 2, /obj/item/alch/blessedseedpowder = 1)
	tools = list(TOOL_DRUIDIC_CATALYST = 1)
	skillcraft = /datum/skill/magic/druidic
	craftdiff = SKILL_LEVEL_MASTER

/datum/crafting_recipe/roguetown/farming/zizobane_spores
	name = "zizobane spore extraction"
	result = /obj/item/herbseed/zizobane
	reqs = list(/obj/item/reagent_containers/food/snacks/zizo_bane = 1, /obj/item/alch/blessedseedpowder = 1)
	tools = list(/obj/item/reagent_containers/glass/mortar = 1)
	skillcraft = /datum/skill/magic/druidic
	craftdiff = SKILL_LEVEL_LEGENDARY
