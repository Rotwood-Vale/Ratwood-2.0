// Previously cooking.dm, this is just so that I can include it in subcategories for
// Class where they need tallow (Survival + Leatherworking)

/datum/crafting_recipe/roguetown/tallow
	abstract_type = /datum/crafting_recipe/roguetown/tallow
	subtype_reqs = FALSE
	skillcraft = /datum/skill/craft/cooking

/datum/crafting_recipe/roguetown/tallow/hearth_tallow
	name = "在壁炉上熬炼兽脂（x4）（1 份脂肪）"
	result = list(
				/obj/item/reagent_containers/food/snacks/tallow,
				/obj/item/reagent_containers/food/snacks/tallow,
				/obj/item/reagent_containers/food/snacks/tallow,
				/obj/item/reagent_containers/food/snacks/tallow,
				)
	reqs = list(/obj/item/reagent_containers/food/snacks/fat = 1)
	tools = list(/obj/item/cooking/pan,)
	structurecraft = /obj/machinery/light/rogue/hearth
	craftdiff = 0
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "熬炼"
	verbage = "熬炼"

/datum/crafting_recipe/roguetown/tallow/campfire_tallow
	name = "在营火上熬炼兽脂（x3）（1 份脂肪）"
	result = list(
				/obj/item/reagent_containers/food/snacks/tallow,
				/obj/item/reagent_containers/food/snacks/tallow,
				/obj/item/reagent_containers/food/snacks/tallow,
				)
	reqs = list(/obj/item/reagent_containers/food/snacks/fat = 1)
	tools = list(/obj/item/cooking/pan,)
	structurecraft = /obj/machinery/light/rogue/campfire
	craftdiff = 0
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "熬炼"
	verbage = "熬炼"

/datum/crafting_recipe/roguetown/cooking/mobilestove_tallow
	name = "在便携炉上熬炼兽脂（x3）（1 份脂肪）"
	result = list(
				/obj/item/reagent_containers/food/snacks/tallow,
				/obj/item/reagent_containers/food/snacks/tallow,
				/obj/item/reagent_containers/food/snacks/tallow,
				)
	reqs = list(/obj/item/reagent_containers/food/snacks/fat = 1)
	tools = list(/obj/item/cooking/pan,)
	structurecraft = /obj/machinery/light/rogue/hearth/mobilestove
	craftdiff = 0
	craftsound = 'sound/misc/frying.ogg'
	req_table = FALSE
	verbage_simple = "熬炼"
	verbage = "熬炼"

/datum/crafting_recipe/roguetown/tallow/hearth_soft_tallow
	name = "在壁炉上熬炼软兽脂（1 份兽脂，1 份脂肪）"
	result = list(
				/obj/item/reagent_containers/food/snacks/tallow/soft,
				)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
	)
	tools = list(/obj/item/cooking/pan,)
	structurecraft = /obj/machinery/light/rogue/hearth
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "熬炼"
	verbage = "熬炼"

/datum/crafting_recipe/roguetown/tallow/campfire_soft_tallow
	name = "在营火上熬炼软兽脂（1 份兽脂，1 份脂肪）"
	result = list(
				/obj/item/reagent_containers/food/snacks/tallow/soft,
				)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
	)
	tools = list(/obj/item/cooking/pan,)
	structurecraft = /obj/machinery/light/rogue/campfire
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	craftsound = 'sound/misc/frying.ogg'
	verbage_simple = "熬炼"
	verbage = "熬炼"

/datum/crafting_recipe/roguetown/cooking/mobilestove_soft_tallow
	name = "在便携炉上熬炼软兽脂（1 份兽脂，1 份脂肪）"
	result = list(
				/obj/item/reagent_containers/food/snacks/tallow/soft,
				)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/tallow = 1,
		/obj/item/reagent_containers/food/snacks/fat = 1,
	)
	tools = list(/obj/item/cooking/pan,)
	structurecraft = /obj/machinery/light/rogue/hearth/mobilestove
	craftdiff = SKILL_LEVEL_JOURNEYMAN
	craftsound = 'sound/misc/frying.ogg'
	req_table = FALSE
	verbage_simple = "熬炼"
	verbage = "熬炼"
