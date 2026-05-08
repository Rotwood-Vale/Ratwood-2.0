/datum/crafting_recipe/roguetown/ceramics
	abstract_type = /datum/crafting_recipe/roguetown/ceramics
	skillcraft = /datum/skill/craft/ceramics
	hides_from_crafting_menu = TRUE

/datum/crafting_recipe/roguetown/ceramics/clay
	structurecraft = /obj/structure/fluff/ceramicswheel
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/glass
	tools = list(/obj/item/rogueweapon/blowrod)
	structurecraft = /obj/machinery/light/rogue/smelter

/datum/crafting_recipe/roguetown/ceramics/clay/claycup
	name = "clay cup, dyeable"
	result = list(/obj/item/natural/clay/claycup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claybrick
	name = "clay brick x2"
	result = list(/obj/item/natural/clay/claybrick, /obj/item/natural/clay/claybrick)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claybottle
	name = "clay bottle, dyeable"
	result = list(/obj/item/natural/clay/claybottle)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
/datum/crafting_recipe/roguetown/ceramics/clay/clayvase
	name = "clay vase, dyeable"
	result = list(/obj/item/natural/clay/clayvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0
/datum/crafting_recipe/roguetown/ceramics/clay/clayfancyvase
	name = "fancy clay vase, dyeable"
	result = list(/obj/item/natural/clay/clayfancyvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/teapot
	name = "teapot"
	result = list(/obj/item/natural/clay/rawteapot)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/teacup
	name = "teacup"
	result = list(/obj/item/natural/clay/rawteacup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/glassraw
	name = "glass clay"
	tools = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle)
	result = list(/obj/item/natural/clay/glassbatch)
	reqs = list(/obj/item/natural/clay = 2, /obj/item/ash = 2, /obj/item/alch/stonedust = 1)
	craftdiff = 0
	hides_from_books = TRUE

/* Handbook entries organized by category */
/datum/crafting_recipe/roguetown/ceramics/handbook_materials
	name = "ceramic materials"
	structurecraft = null
	craftdiff = 0
	category = "Ceramic Materials"
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/handbook_materials/kneaded_clay
	name = "kneaded clay"
	result = list(/obj/item/natural/clay/kneaded)
	reqs = list(/obj/item/natural/clay = 2)
	tools = list(/obj/item/reagent_containers)
	req_table = TRUE
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_materials/refined_clay
	name = "refined clay"
	result = list(/obj/item/natural/clay/refined)
	reqs = list(/obj/item/natural/clay/kneaded = 1, /obj/item/ash = 2, /obj/item/natural/dirtclod/sand = 1)
	tools = list(/obj/item/reagent_containers)
	req_table = TRUE
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_materials/glass_clay
	name = "glass batch"
	result = list(/obj/item/natural/clay/glassbatch)
	reqs = list(/obj/item/natural/clay = 2, /obj/item/ash = 2, /obj/item/alch/stonedust = 1)
	tools = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery
	name = "clay pottery"
	structurecraft = null
	craftdiff = 0
	category = "Clay Pottery"
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claycup
	name = "clay canister"
	result = list(/obj/item/natural/clay/claycup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claybrick
	name = "clay brick x2"
	result = list(/obj/item/natural/clay/claybrick, /obj/item/natural/clay/claybrick)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claybottle
	name = "clay bottle"
	result = list(/obj/item/natural/clay/claybottle)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/clayvase
	name = "clay vase"
	result = list(/obj/item/natural/clay/clayvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/clayfancyvase
	name = "fancy clay vase"
	result = list(/obj/item/natural/clay/clayfancyvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/teapot
	name = "teapot"
	result = list(/obj/item/natural/clay/rawteapot)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/teacup
	name = "teacup"
	result = list(/obj/item/natural/clay/rawteacup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_1
	name = "clay statue (style I)"
	result = list(/obj/item/roguestatue/clay/design1)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_2
	name = "clay statue (style II)"
	result = list(/obj/item/roguestatue/clay/design2)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_3
	name = "clay statue (style III)"
	result = list(/obj/item/roguestatue/clay/design3)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_4
	name = "clay statue (style IV)"
	result = list(/obj/item/roguestatue/clay/design4)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_5
	name = "clay statue (style V)"
	result = list(/obj/item/roguestatue/clay/design5)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery
	name = "porcelain pottery"
	structurecraft = null
	craftdiff = 0
	category = "Porcelain Pottery"
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/cameo
	name = "porcelain cameo"
	result = list(/obj/item/natural/clay/porcelain/cameo)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/figurine
	name = "porcelain figurine"
	result = list(/obj/item/natural/clay/porcelain/figurine)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fish
	name = "porcelain fish figurine"
	result = list(/obj/item/natural/clay/porcelain/fish)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/tablet
	name = "porcelain tablet"
	result = list(/obj/item/natural/clay/porcelain/tablet)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/vase
	name = "porcelain vase"
	result = list(/obj/item/natural/clay/porcelain/vase)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fork
	name = "porcelain fork"
	result = list(/obj/item/natural/clay/porcelain/fork)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/spoon
	name = "porcelain spoon"
	result = list(/obj/item/natural/clay/porcelain/spoon)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/bowl
	name = "porcelain bowl"
	result = list(/obj/item/natural/clay/porcelain/bowl)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/cup
	name = "porcelain teacup"
	result = list(/obj/item/natural/clay/porcelain/cup)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/platter
	name = "porcelain platter"
	result = list(/obj/item/natural/clay/porcelain/platter)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/teapot
	name = "porcelain teapot"
	result = list(/obj/item/natural/clay/porcelain/teapot)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/bust
	name = "porcelain bust"
	result = list(/obj/item/natural/clay/porcelain/bust)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fancy_vase
	name = "fancy porcelain vase"
	result = list(/obj/item/natural/clay/porcelain/fancyvase)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/comb
	name = "porcelain comb"
	result = list(/obj/item/natural/clay/porcelain/comb)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/duck
	name = "porcelain duck"
	result = list(/obj/item/natural/clay/porcelain/duck)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fancy_cup
	name = "fancy porcelain cup"
	result = list(/obj/item/natural/clay/porcelain/fancycup)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fancy_ceramic_cup
	name = "fancy porcelain teacup"
	result = list(/obj/item/natural/clay/porcelain/fancyteacup)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fancy_ceramic_teapot
	name = "fancy porcelain teapot"
	result = list(/obj/item/natural/clay/porcelain/fancyteapot)
	reqs = list(/obj/item/natural/clay/refined = 2)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/decorative_ceramic_teapot
	name = "decorative porcelain teapot"
	result = list(/obj/item/natural/clay/porcelain/decorativeteapot)
	reqs = list(/obj/item/natural/clay/refined = 2)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/mask
	name = "porcelain mask"
	result = list(/obj/item/natural/clay/porcelain/mask)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/urn
	name = "porcelain urn"
	result = list(/obj/item/natural/clay/porcelain/urn)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/statue
	name = "porcelain statue"
	result = list(/obj/item/natural/clay/porcelain/statue)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/obelisk
	name = "porcelain obelisk"
	result = list(/obj/item/natural/clay/porcelain/obelisk)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/turtle
	name = "porcelain turtle carving"
	result = list(/obj/item/natural/clay/porcelain/turtle)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/bauble
	name = "porcelain bauble"
	result = list(/obj/item/natural/clay/porcelain/bauble)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/rungu
	name = "porcelain rungu"
	result = list(/obj/item/natural/clay/porcelain/rungu)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/* Glassware tab — items blown from heated glass using the blowing rod */
/datum/crafting_recipe/roguetown/ceramics/handbook_glassware
	name = "glassware"
	structurecraft = null
	craftdiff = 0
	category = "Glassware"
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_bottle
	name = "blown glass bottle"
	result = list(/obj/item/reagent_containers/glass/bottle/blown)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_vial
	name = "blown alchemical vial (x2)"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/blown)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_1
	name = "glass statue (style I)"
	result = list(/obj/item/roguestatue/glass/design1)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_2
	name = "glass statue (style II)"
	result = list(/obj/item/roguestatue/glass/design2)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_3
	name = "glass statue (style III)"
	result = list(/obj/item/roguestatue/glass/design3)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_4
	name = "glass statue (style IV)"
	result = list(/obj/item/roguestatue/glass/design4)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_5
	name = "glass statue (style V)"
	result = list(/obj/item/roguestatue/glass/design5)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

