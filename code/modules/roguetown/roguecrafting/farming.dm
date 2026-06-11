/datum/crafting_recipe/roguetown/farming
	req_table = FALSE
	verbage_simple = "调配"
	skillcraft = /datum/skill/labor/farming
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/farming/fertilizer
	name = "肥料"
	result = /obj/item/fertilizer
	reqs = list(/obj/item/compost = 1, /obj/item/natural/bone = 1, /obj/item/natural/poo = 1)
	craftdiff = 3
