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
	name = "陶土杯，可染色"
	result = list(/obj/item/natural/clay/claycup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claybrick
	name = "陶砖 x2"
	result = list(/obj/item/natural/clay/claybrick, /obj/item/natural/clay/claybrick)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/claybottle
	name = "陶土瓶，可染色"
	result = list(/obj/item/natural/clay/claybottle)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
/datum/crafting_recipe/roguetown/ceramics/clay/clayvase
	name = "陶土花瓶，可染色"
	result = list(/obj/item/natural/clay/clayvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0
/datum/crafting_recipe/roguetown/ceramics/clay/clayfancyvase
	name = "精致陶土花瓶，可染色"
	result = list(/obj/item/natural/clay/clayfancyvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/teapot
	name = "茶壶"
	result = list(/obj/item/natural/clay/rawteapot)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/clay/teacup
	name = "茶杯"
	result = list(/obj/item/natural/clay/rawteacup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/ceramics/glassraw
	name = "玻璃陶土"
	tools = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle)
	result = list(/obj/item/natural/clay/glassbatch)
	reqs = list(/obj/item/natural/clay = 2, /obj/item/ash = 2, /obj/item/alch/stonedust = 1)
	craftdiff = 0
	hides_from_books = TRUE

/* Handbook entries organized by category */
/datum/crafting_recipe/roguetown/ceramics/handbook_materials
	name = "陶瓷材料"
	structurecraft = null
	craftdiff = 0
	category = "陶瓷材料"
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/handbook_materials/kneaded_clay
	name = "揉制陶土"
	result = list(/obj/item/natural/clay/kneaded)
	reqs = list(/obj/item/natural/clay = 2)
	tools = list(/obj/item/reagent_containers)
	req_table = TRUE
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_materials/refined_clay
	name = "精制陶土"
	result = list(/obj/item/natural/clay/refined)
	reqs = list(/obj/item/natural/clay/kneaded = 1, /obj/item/ash = 2, /obj/item/natural/dirtclod/sand = 1)
	tools = list(/obj/item/reagent_containers)
	req_table = TRUE
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_materials/glass_clay
	name = "玻璃料团"
	result = list(/obj/item/natural/clay/glassbatch)
	reqs = list(/obj/item/natural/clay = 2, /obj/item/ash = 2, /obj/item/alch/stonedust = 1)
	tools = list(/obj/item/reagent_containers/glass/mortar, /obj/item/pestle)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery
	name = "陶器"
	structurecraft = null
	craftdiff = 0
	category = "陶器"
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claycup
	name = "陶罐"
	result = list(/obj/item/natural/clay/claycup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claybrick
	name = "陶砖 x2"
	result = list(/obj/item/natural/clay/claybrick, /obj/item/natural/clay/claybrick)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claybottle
	name = "陶瓶"
	result = list(/obj/item/natural/clay/claybottle)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/clayvase
	name = "陶花瓶"
	result = list(/obj/item/natural/clay/clayvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/clayfancyvase
	name = "精致陶花瓶"
	result = list(/obj/item/natural/clay/clayfancyvase)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/teapot
	name = "茶壶"
	result = list(/obj/item/natural/clay/rawteapot)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/teacup
	name = "茶杯"
	result = list(/obj/item/natural/clay/rawteacup)
	reqs = list(/obj/item/natural/clay = 1)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_1
	name = "陶像（样式 I）"
	result = list(/obj/item/roguestatue/clay/design1)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_2
	name = "陶像（样式 II）"
	result = list(/obj/item/roguestatue/clay/design2)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_3
	name = "陶像（样式 III）"
	result = list(/obj/item/roguestatue/clay/design3)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_4
	name = "陶像（样式 IV）"
	result = list(/obj/item/roguestatue/clay/design4)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_clay_pottery/claystatue_5
	name = "陶像（样式 V）"
	result = list(/obj/item/roguestatue/clay/design5)
	reqs = list(/obj/item/natural/clay = 3)
	craftdiff = 0
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery
	name = "瓷器"
	structurecraft = null
	craftdiff = 0
	category = "瓷器"
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/cameo
	name = "瓷制浮雕饰牌"
	result = list(/obj/item/natural/clay/porcelain/cameo)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/figurine
	name = "瓷制小雕像"
	result = list(/obj/item/natural/clay/porcelain/figurine)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fish
	name = "瓷制鱼形小雕像"
	result = list(/obj/item/natural/clay/porcelain/fish)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/tablet
	name = "瓷制碑板"
	result = list(/obj/item/natural/clay/porcelain/tablet)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/vase
	name = "瓷制花瓶"
	result = list(/obj/item/natural/clay/porcelain/vase)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fork
	name = "瓷叉"
	result = list(/obj/item/natural/clay/porcelain/fork)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/spoon
	name = "瓷勺"
	result = list(/obj/item/natural/clay/porcelain/spoon)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/bowl
	name = "瓷碗"
	result = list(/obj/item/natural/clay/porcelain/bowl)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/cup
	name = "瓷茶杯"
	result = list(/obj/item/natural/clay/porcelain/cup)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/platter
	name = "瓷大盘"
	result = list(/obj/item/natural/clay/porcelain/platter)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/teapot
	name = "瓷茶壶"
	result = list(/obj/item/natural/clay/porcelain/teapot)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/bust
	name = "瓷制胸像"
	result = list(/obj/item/natural/clay/porcelain/bust)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fancy_vase
	name = "精致瓷花瓶"
	result = list(/obj/item/natural/clay/porcelain/fancyvase)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/comb
	name = "瓷梳"
	result = list(/obj/item/natural/clay/porcelain/comb)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/duck
	name = "瓷鸭摆件"
	result = list(/obj/item/natural/clay/porcelain/duck)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fancy_cup
	name = "精致瓷杯"
	result = list(/obj/item/natural/clay/porcelain/fancycup)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fancy_ceramic_cup
	name = "精致瓷茶杯"
	result = list(/obj/item/natural/clay/porcelain/fancyteacup)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/fancy_ceramic_teapot
	name = "精致瓷茶壶"
	result = list(/obj/item/natural/clay/porcelain/fancyteapot)
	reqs = list(/obj/item/natural/clay/refined = 2)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/decorative_ceramic_teapot
	name = "装饰瓷茶壶"
	result = list(/obj/item/natural/clay/porcelain/decorativeteapot)
	reqs = list(/obj/item/natural/clay/refined = 2)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/mask
	name = "瓷面具"
	result = list(/obj/item/natural/clay/porcelain/mask)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/urn
	name = "瓷骨灰瓮"
	result = list(/obj/item/natural/clay/porcelain/urn)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/statue
	name = "瓷雕像"
	result = list(/obj/item/natural/clay/porcelain/statue)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/obelisk
	name = "瓷方尖碑"
	result = list(/obj/item/natural/clay/porcelain/obelisk)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/turtle
	name = "瓷龟雕刻"
	result = list(/obj/item/natural/clay/porcelain/turtle)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/bauble
	name = "瓷饰球"
	result = list(/obj/item/natural/clay/porcelain/bauble)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_porcelain_pottery/rungu
	name = "瓷隆古棍"
	result = list(/obj/item/natural/clay/porcelain/rungu)
	reqs = list(/obj/item/natural/clay/refined = 1)
	hides_from_books = FALSE

/* Glassware tab — items blown from heated glass using the blowing rod */
/datum/crafting_recipe/roguetown/ceramics/handbook_glassware
	name = "玻璃器皿"
	structurecraft = null
	craftdiff = 0
	category = "玻璃器皿"
	hides_from_books = TRUE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_bottle
	name = "吹制玻璃瓶"
	result = list(/obj/item/reagent_containers/glass/bottle/blown)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_vial
	name = "吹制炼金小瓶（x2）"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/blown)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_1
	name = "玻璃像（样式 I）"
	result = list(/obj/item/roguestatue/glass/design1)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_2
	name = "玻璃像（样式 II）"
	result = list(/obj/item/roguestatue/glass/design2)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_3
	name = "玻璃像（样式 III）"
	result = list(/obj/item/roguestatue/glass/design3)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_4
	name = "玻璃像（样式 IV）"
	result = list(/obj/item/roguestatue/glass/design4)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

/datum/crafting_recipe/roguetown/ceramics/handbook_glassware/glass_statue_5
	name = "玻璃像（样式 V）"
	result = list(/obj/item/roguestatue/glass/design5)
	reqs = list(/obj/item/natural/clay/glassbatch = 1)
	tools = list(/obj/item/rogueweapon/blowrod)
	hides_from_books = FALSE

