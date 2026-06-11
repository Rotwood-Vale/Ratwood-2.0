/*	........   Drying Rack recipes   ................ */
/datum/crafting_recipe/roguetown/cooking/salami
	name = "烟熏香肠"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/sausage = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/salami
	req_table = FALSE
	skillcraft = /datum/skill/craft/cooking
	verbage_simple = "dry"
	verbage = "drys"
	structurecraft = /obj/machinery/tanningrack
	craftdiff = 0

/datum/crafting_recipe/roguetown/cooking/coppiette
	name = "风干肉条"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/coppiette
	req_table = FALSE
	skillcraft = /datum/skill/craft/cooking
	verbage_simple = "dry"
	verbage = "drys"
	craftdiff = 0
	structurecraft = /obj/machinery/tanningrack

/datum/crafting_recipe/roguetown/cooking/salo
	name = "盐腌肥膘"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/fat = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/fat/salo
	craftdiff = 0
	skillcraft = /datum/skill/craft/cooking
	verbage_simple = "dry"
	verbage = "drys"
	structurecraft = /obj/machinery/tanningrack
	req_table = FALSE

/datum/crafting_recipe/roguetown/cooking/raisins
	name = "葡萄干"
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	parts = list(
		/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/raisins
	structurecraft = /obj/machinery/tanningrack
	req_table = FALSE
	skillcraft = /datum/skill/craft/cooking
	verbage_simple = "dry"
	verbage = "drys"
	craftdiff = 0
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/cooking/fish
	name = "风干鱼片"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/fish = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/meat/driedfishfilet
	craftdiff = 0
	skillcraft = /datum/skill/craft/cooking
	verbage_simple = "dry"
	verbage = "drys"	
	structurecraft = /obj/machinery/tanningrack
	req_table = FALSE

/datum/crafting_recipe/roguetown/cooking/frybirdbucket
	name = "炸鸟桶"
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/poultry/cutlet/fried = 3,
		/obj/item/reagent_containers/glass/bucket = 1,
		/obj/item/reagent_containers/powder/salt = 1)
	result = /obj/item/reagent_containers/food/snacks/rogue/frybirdbucket
	craftdiff = 0
