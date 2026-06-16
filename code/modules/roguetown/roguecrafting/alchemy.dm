/datum/crafting_recipe/roguetown/alchemy
	abstract_type = /datum/crafting_recipe/roguetown/alchemy
	req_table = FALSE
	verbage_simple = "调配"
	skillcraft = /datum/skill/craft/alchemy
	subtype_reqs = TRUE
	structurecraft = /obj/structure/fluff/alch

/datum/crafting_recipe/roguetown/alchemy/bbomb
	name = "瓶装炸弹"
	category = "台面"
	result = list(/obj/item/bomb)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /obj/item/ash = 2, /obj/item/rogueore/coal = 1, /obj/item/natural/cloth = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/ozium
	name = "奥兹姆"
	category = "台面"
	result = list(/obj/item/reagent_containers/powder/ozium)
	reqs = list(/obj/item/ash = 2, /datum/reagent/berrypoison = 2, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/ozium_3x
	name = "奥兹姆 (x3)"
	category = "台面"
	result = list(/obj/item/reagent_containers/powder/ozium,
					/obj/item/reagent_containers/powder/ozium,
					/obj/item/reagent_containers/powder/ozium)
	reqs = list(/obj/item/ash = 3, /datum/reagent/berrypoison = 3, /obj/item/reagent_containers/food/snacks/grown/rogue/swampweeddry = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/moon
	name = "月尘"
	category = "台面"
	result = list(/obj/item/reagent_containers/powder/moondust)
	reqs = list(/obj/item/ash = 2, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 1, /datum/reagent/berrypoison = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/moon_3x
	name = "月尘 (x3)"
	category = "台面"
	result = list(/obj/item/reagent_containers/powder/moondust,
					/obj/item/reagent_containers/powder/moondust,
					/obj/item/reagent_containers/powder/moondust
				)
	reqs = list(/obj/item/ash = 3, /obj/item/reagent_containers/food/snacks/grown/rogue/pipeweeddry = 2, /datum/reagent/berrypoison = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/salt
	name = "盐堆"
	category = "台面"
	result = list(/obj/item/reagent_containers/powder/salt)
	reqs = list(/obj/item/ash = 1, /datum/reagent/water = 10, /obj/item/reagent_containers/food/snacks/fat = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/alchemy/salt_2
	name = "盐堆"
	category = "台面"
	result = list(/obj/item/reagent_containers/powder/salt)
	reqs = list(/obj/item/ash = 1, /datum/reagent/water = 10, /obj/item/reagent_containers/food/snacks/rogue/meat/mince = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/alchemy/quicksilver
	name = "水银"
	category = "台面"
	result = list(/obj/item/quicksilver = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied = 1, /datum/reagent/water/blessed = 45, /obj/item/natural/cloth = 1, /obj/item/alch/silverdust = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/alchemy/qsabsolution
	name = "净罪银"
	category = "转化"
	req_table = FALSE
	result = list(/obj/item/quicksilver/luxinfused = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/fyritius/bloodied = 1, /datum/reagent/water/blessed = 45, /obj/item/natural/cloth = 1, /obj/item/alch/silverdust = 1)
	craftdiff = 0
	verbage_simple = "转化"
	structurecraft = null

/datum/crafting_recipe/roguetown/alchemy/transisdust
	name = "碎晶粉"
	category = "台面"
	result = list(/obj/item/alch/transisdust)
	reqs = list(/obj/item/herbseed/taraxacum = 1, /obj/item/herbseed/euphrasia = 1, /obj/item/herbseed/hypericum = 1, /obj/item/herbseed/salvia = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/alchemy/menthazig
	name = "手工薄荷烟卷"
	category = "台面"
	result = list(/obj/item/clothing/mask/cigarette/rollie/mentha/crafted)
	reqs = list(/obj/item/clothing/mask/cigarette/rollie/nicotine = 1, /obj/item/alch/mentha = 1)
	craftdiff = 1

//Hard to craft but feasable, will give ONE vial but that has 10 units so, enough to cure 2 people if they ration it.
/datum/crafting_recipe/roguetown/alchemy/curerot
	name = "腐烂治疗药剂"
	category = "台面"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/rogue/rotcure = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle/alchemical = 1, /obj/item/reagent_containers/food/snacks/grown/rogue/fyritius = 1, /obj/item/alch/golddust = 1, /obj/item/alch/viscera = 2)
	craftdiff = 5	//Master-level

/datum/crafting_recipe/roguetown/alchemy/paralytic_venom
	name = "麻痹毒液活化"
	category = "台面"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical/spidervenom_paralytic = 1)
	reqs = list(/obj/item/reagent_containers/spidervenom_inert = 2, /obj/item/reagent_containers/powder/moondust, /obj/item/reagent_containers/glass/bottle/alchemical)
	craftdiff = 5
	verbage_simple = "调配"

/datum/crafting_recipe/roguetown/alchemy/revival_potion
	name = "复生药剂"
	category = "台面"
	result = list(/obj/item/reagent_containers/glass/bottle/revival = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/eoran_aril/auric = 1,
				/obj/item/alch/viscera = 2,
				/obj/item/reagent_containers/glass/bottle/alchemical,
				/obj/item/reagent_containers/spidervenom_inert = 1,
				/obj/item/alch/horn = 1)
	craftdiff = 5
	verbage_simple = "调配"

/datum/crafting_recipe/roguetown/alchemy/revival_potion_spider
	name = "复生药剂"
	category = "台面"
	result = list(/obj/item/reagent_containers/glass/bottle/revival = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/eoran_aril/auric = 1,
				/obj/item/alch/viscera = 2,
				/obj/item/reagent_containers/glass/bottle/alchemical,
				/obj/item/reagent_containers/spidervenom_inert = 3)
	craftdiff = 5
	verbage_simple = "调配"

/// bottle craft

/datum/crafting_recipe/roguetown/alchemy/glassbottles
	name = "炼金瓶"
	category = "容器"
	result = list(/obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical, /obj/item/reagent_containers/glass/bottle/alchemical)
	reqs = list(/obj/item/natural/stone = 1, /obj/item/natural/dirtclod = 1)
	craftdiff = 1
	verbage_simple = "制作"

/datum/crafting_recipe/roguetown/alchemy/glassbottles2
	name = "玻璃瓶"
	category = "容器"
	result = list(/obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/bottle, /obj/item/reagent_containers/glass/bottle)
	reqs = list(/obj/item/natural/stone = 1, /obj/item/natural/dirtclod = 1)
	craftdiff = 1
	verbage_simple = "制作"

/// transmutation

/datum/crafting_recipe/roguetown/alchemy/distill
	name = "蒸馏水"
	category = "转化"
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/water = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /datum/reagent/water/gross = 48)
	craftdiff = 1

/datum/crafting_recipe/roguetown/alchemy/w2w
	name = "水转酒"
	category = "转化"
	result = list(/obj/item/reagent_containers/glass/bottle/rogue/wine = 1)
	reqs = list(/obj/item/reagent_containers/glass/bottle = 1, /datum/reagent/water = 48)
	craftdiff = 3 //WHO THE FUCK THOUGHT SETTING THIS AT 2 WAS A GOOD IDEA? MAKE IT MAKE SENSE.
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/g2wes
	name = "谷物→西池烟叶"
	category = "转化"
	result = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 2)
	craftdiff = 3
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/w2swa
	name = "西池烟叶→沼泽烟叶"
	category = "转化"
	result = list(/obj/item/reagent_containers/food/snacks/grown/rogue/swampweed = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/rogue/pipeweed = 2)
	craftdiff = 3
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/f2gra
	name = "纤维转谷物"
	category = "转化"
	result = list(/obj/item/reagent_containers/food/snacks/grown/wheat = 1)
	reqs = list(/obj/item/natural/fibers = 4)
	craftdiff = 3
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/b2app
	name = "浆果转苹果"
	category = "转化"
	result = list(/obj/item/reagent_containers/food/snacks/grown/apple = 1)
	reqs = list(/obj/item/reagent_containers/food/snacks/grown/berries/rogue = 2)
	craftdiff = 3
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/c2sto
	name = "黏土转石料"
	category = "转化"
	result = list(/obj/item/natural/stone = 1)
	reqs = list(/obj/item/natural/clay = 2)
	craftdiff = 2
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/s2cto
	name = "stone to clay"
	category = "Transmutation"
	result = list(/obj/item/natural/clay = 2)
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 2
	verbage_simple = "transmute"

/datum/crafting_recipe/roguetown/alchemy/s2coa
	name = "石料转煤炭"
	category = "转化"
	result = list(/obj/item/rogueore/coal = 1)
	reqs = list(/obj/item/natural/stone = 4)
	craftdiff = 4
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/c2irn
	name = "煤炭转铁矿"
	category = "转化"
	result = list(/obj/item/rogueore/iron = 1)
	reqs = list(/obj/item/rogueore/coal = 2)
	craftdiff = 4
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/i2gol
	name = "铁转黄金"
	category = "转化"
	result = list(/obj/item/rogueore/gold = 1)
	reqs = list(/obj/item/rogueore/iron = 4)
	craftdiff = 5
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/g2top
	name = "黄金转 托珀石"
	category = "转化"
	result = list(/obj/item/roguegem/yellow = 1)
	reqs = list(/obj/item/rogueore/gold = 2, /obj/item/natural/stone = 1)
	craftdiff = 5
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/t2gem
	name = "托珀石 转 翠晶"
	category = "转化"
	result = list(/obj/item/roguegem/green = 1)
	reqs = list(/obj/item/roguegem/yellow = 1, /obj/item/rogueore/gold = 2)
	craftdiff = 5
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/g2saf
	name = "翠晶 转 蓝晶"
	category = "转化"
	result = list(/obj/item/roguegem/violet = 1)
	reqs = list(/obj/item/roguegem/green = 1, /obj/item/rogueore/gold = 2)
	craftdiff = 5
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/s2blo
	name = "蓝晶 转 布洛兹石"
	category = "转化"
	result = list(/obj/item/roguegem/blue = 1)
	reqs = list(/obj/item/roguegem/violet = 1, /obj/item/rogueore/gold = 2)
	craftdiff = 5
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/r2dia
	name = "布洛兹石 转钻石"
	category = "转化"
	result = list(/obj/item/roguegem/diamond = 1)
	reqs = list(/obj/item/roguegem/blue = 2, /obj/item/rogueore/gold = 2)
	craftdiff = 5
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/d2ros
	name = "钻石转 Riddle of Steel" /// holy grail requires legendary. (sell price on average is 350. rontz and diamond worth 100 each. you get to legndary you deserve 150-200 profit)
	category = "转化"
	result = list(/obj/item/riddleofsteel = 1)
	reqs = list(/obj/item/roguegem/diamond = 2, /obj/item/rogueore/iron = 1, /obj/item/rogueore/coal = 1)
	craftdiff = 6
	verbage_simple = "转化"

/datum/crafting_recipe/roguetown/alchemy/frankenbrew
	name = "再生灵药"
	category = "台面"
	result = list(
		/obj/item/reagent_containers/glass/bottle/frankenbrew,
		/obj/item/reagent_containers/glass/bottle/frankenbrew
	)
	reqs = list(
		/obj/item/reagent_containers/glass/bottle = 2,
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 1,
		/obj/item/reagent_containers/lux = 1,
		/obj/item/alch/calendula = 1,
		/datum/reagent/water = 98
	)
	craftdiff = 4
	verbage_simple = "调配"

/datum/crafting_recipe/roguetown/alchemy/frankenbrew_small
	name = "再生灵药 (不纯 Lux)"
	category = "台面"
	result = list(
		/obj/item/reagent_containers/glass/bottle/frankenbrew/third
	)
	reqs = list(
		/obj/item/reagent_containers/glass/bottle = 1,
		/obj/item/reagent_containers/food/snacks/grown/manabloom = 1,
		/obj/item/reagent_containers/lux_impure = 1,
		/obj/item/alch/calendula = 1,
		/datum/reagent/water = 49
	)
	craftdiff = 4
	verbage_simple = "调配"
	required_tech_node = "LUX_FILTRATION"
	tech_unlocked = FALSE

/datum/crafting_recipe/roguetown/alchemy/bandage
	name = "绷带（炼金）"
	result = list(/obj/item/natural/cloth/bandage)
	reqs = list(
		/obj/item/natural/cloth = 1,
		/obj/item/alch/bonemeal = 1,
		)
	craftdiff = 2

/datum/crafting_recipe/roguetown/alchemy/glut
	name = "炼金胶剂（来自豺狼人肉）"
	craftdiff = 4
	result = list(
		/obj/item/roguegem/blood_diamond
		)
	reqs = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll = 2,
		)
	subtype_reqs = TRUE

/datum/crafting_recipe/roguetown/alchemy/gnoll_flesh
	name = "豺狼人肉（来自炼金胶剂）"
	craftdiff = 4
	result = list(
		/obj/item/reagent_containers/food/snacks/rogue/meat/steak/gnoll
		)
	reqs = list(
		/obj/item/roguegem/blood_diamond = 2,
		)
	subtype_reqs = TRUE
