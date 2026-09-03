/datum/crafting_recipe/roguetown/naziby // meant to be only avaliable to nazibi and their mages
	always_availible = FALSE
	req_table = TRUE
	tools = list()
	category = "Arcana"
	abstract_type = /datum/crafting_recipe/roguetown/arcana
	skillcraft = /datum/skill/magic/arcane
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/naziby/warstaffore
	name = "heartwood core - (2 iridescent scales, 1 small log)"
	result = /obj/item/magic/fae/core
	reqs = list(/obj/item/magic/fae/scale = 2,
				/obj/item/grown/log/tree/small = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/naziby/warstaffingot

/datum/crafting_recipe/roguetown/naziby/maskore

/datum/crafting_recipe/roguetown/naziby/maskingot
