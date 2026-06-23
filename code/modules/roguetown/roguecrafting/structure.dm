
/datum/crafting_recipe/roguetown/structure
	abstract_type = /datum/crafting_recipe/roguetown/structure
	req_table = FALSE
	subtype_reqs = TRUE
	craftsound = 'sound/foley/Building-01.ogg'
	verbage_simple = "制作"
	verbage = "制作"

/datum/crafting_recipe/roguetown/structure/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return FALSE
	if(istype(T, /turf/open/water))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/structure/handcart
	name = "手推车"
	result = /obj/structure/handcart
	reqs = list(/obj/item/grown/log/tree/small = 3,
				/obj/item/rope = 1)

/datum/crafting_recipe/roguetown/structure/noose
	name = "绞索"
	result = /obj/structure/noose
	reqs = list(/obj/item/rope = 1)
	verbage = "系绑"
	craftsound = 'sound/foley/noose_idle.ogg'
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/noose/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step_multiz(T, UP)
	if(!checking)
		return FALSE
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking,/turf/open/transparent/openspace))
		return FALSE
	return TRUE

/datum/crafting_recipe/roguetown/structure/wooden_horse
	name = "固定木马"
	result = /obj/structure/wooden_horse
	reqs = list(/obj/item/natural/wood/plank = 3)
	verbage_simple = "制作"
	verbage = "制作"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/wooden_horse/small
	name = "固定小木马"
	result = /obj/structure/wooden_horse/small
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/wooden_horse/iron
	name = "固定铁制木马"
	result = /obj/structure/wooden_horse/iron
	reqs = list(
		/obj/item/natural/wood/plank = 2,
		/obj/item/ingot/iron = 1,
	)
	verbage_simple = "制作"
	verbage = "制作"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/wooden_horse/mobile
	name = "活动木马"
	result = /obj/structure/wooden_horse/mobile
	reqs = list(/obj/item/natural/wood/plank = 3)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/torture_table
	name = "拷问台"
	result = /obj/structure/bondage/torture_table
	reqs = list(
		/obj/item/natural/wood/plank = 3,
		/obj/item/ingot/iron = 1,
	)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/torture_table/lever
	name = "拷问台拉杆"
	result = /obj/structure/bondage/torture_table/lever
	reqs = list(
		/obj/item/natural/wood/plank = 3,
		/obj/item/ingot/iron = 1,
	)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/x_pillory
	name = "X 字枷台"
	result = /obj/structure/bondage/x_pillory
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/ingot/iron = 1,
	)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/gloryhole
	name = "窥孔刑架"
	result = /obj/structure/bondage/gloryhole
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/chains
	name = "锁链"
	result = /obj/structure/bondage/chains
	reqs = list(/obj/item/rope/chain = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/psycrss
	name = "木十字架"
	result = /obj/structure/fluff/psycross/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/grown/log/tree/stake = 3)

/datum/crafting_recipe/roguetown/structure/psycruci
	name = "木制 普赛顿 十字架"
	result = /obj/structure/fluff/psycross/psycrucifix
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/grown/log/tree/stake = 3)

/datum/crafting_recipe/roguetown/structure/stonepsycruci
	name = "石制 普赛顿 十字架"
	result = /obj/structure/fluff/psycross/psycrucifix/stone
	reqs =	list(/obj/item/natural/stone = 3)

/datum/crafting_recipe/roguetown/structure/silverpsycruci
	name = "银制 普赛顿 十字架"
	result = /obj/structure/fluff/psycross/psycrucifix/silver
	reqs = list(/obj/item/ingot/silverblessed = 1,
				/obj/item/ingot/steel = 2)
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/stonepsycrss
	name = "石十字架"
	result = /obj/structure/fluff/psycross
	reqs = list(/obj/item/natural/stone = 2)

/datum/crafting_recipe/roguetown/structure/zizo_shrine
	name = "木制倒十字架"
	reqs = list(
		/obj/item/grown/log/tree/small = 1,
		/obj/item/grown/log/tree/stake = 2
	)
	result = /obj/structure/fluff/psycross/zizocross

/datum/crafting_recipe/roguetown/structure/zizo_shrine/stone
	name = "stone inverse cross"
	reqs = list(/obj/item/natural/stone = 3)
	result = /obj/structure/fluff/psycross/zizocross/stone

/datum/crafting_recipe/roguetown/structure/zizo_shrine/gold
	name = "gold inverse cross"
	reqs = list(/obj/item/ingot/gold = 1,
				/obj/item/ingot/steel = 2)
	result = /obj/structure/fluff/psycross/zizocross/golden

/datum/crafting_recipe/roguetown/structures/psycross/graggar
	name = "stone graggarite cross"
	reqs = list(/obj/item/natural/stone = 3)
	result = /obj/structure/fluff/psycross/graggar

/datum/crafting_recipe/roguetown/structures/psycross/matthios
	name = "stone matthios cross"
	reqs = list(/obj/item/natural/stone = 3)
	result = /obj/structure/fluff/psycross/matthios

/datum/crafting_recipe/roguetown/structures/psycross/baotha
	name = "stone baotha cross"
	reqs = list(/obj/item/natural/stone = 3)
	result = /obj/structure/fluff/psycross/baotha

/datum/crafting_recipe/roguetown/structures/psycross/necra
	name = "stone necra cross"
	reqs = list(/obj/item/natural/stone = 3)
	result = /obj/structure/fluff/psycross/crafted/necra

/datum/crafting_recipe/roguetown/structure/swing_door
	name = "摆门"
	result = /obj/structure/mineral_door/swing_door
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/door
	name = "木门"
	result = /obj/structure/mineral_door/wood
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/stonedoor
	name = "石门"
	result = /obj/structure/mineral_door/wood/donjon/stone
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/donjon
	name = "metal door"
	result = /obj/structure/mineral_door/wood/donjon
	reqs = list(/obj/item/grown/log/tree/small = 1, /obj/item/ingot/iron = 2)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/celldoor
	name = "cell door"
	result =  /obj/structure/mineral_door/bars
	reqs = list(/obj/item/ingot/iron = 2)
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/doorbolt
	name = "木门（横闩）"
	result = /obj/structure/mineral_door/wood/deadbolt
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/grown/log/tree/stick = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/fancydoor
	name = "华丽门"
	result = /obj/structure/mineral_door/wood/fancywood
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/glassdoor
	name = "木制玻璃门"
	result = /obj/structure/mineral_door/wood/window
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/glass = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/barrel
	name = "发酵桶"
	result = /obj/structure/fermentation_keg/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	verbage_simple = "制作"
	verbage = "制作"
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/display_stand
	name = "展示架"
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	result = /obj/structure/mannequin
	craftdiff = 2
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/mannequin_female
	name = "人台（女）"
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	result = /obj/structure/mannequin/male/female
	craftdiff = 2
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/mannequin_male
	name = "人台（男）"
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 2)
	result = /obj/structure/mannequin/male
	craftdiff = 2
	skillcraft = /datum/skill/craft/carpentry

/obj/structure/fermentation_keg/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/meathook
	name = "肉钩"
	result = /obj/structure/meathook
	reqs = list(/obj/item/grown/log/tree = 2,
				/obj/item/rope = 1)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 2

/datum/crafting_recipe/roguetown/roguebin
	name = "木箱"
	result = /obj/item/roguebin
	reqs = list(/obj/item/grown/log/tree/small = 2)
	verbage_simple = "制作"
	verbage = "制作"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/chair
	name = "木椅"
	result = /obj/item/chair/rogue/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/chairthrone
	name = "小王座"
	result = /obj/structure/chair/wood/rogue/throne
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry

/obj/item/chair/rogue/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/parkbenchleft
	name = "公园长椅（左）"
	result = /obj/structure/chair/hotspring_bench/left
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/parkbenchmiddle
	name = "公园长椅（中）"
	result = /obj/structure/chair/hotspring_bench
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/parkbenchright
	name = "公园长椅（右）"
	result = /obj/structure/chair/hotspring_bench/right
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/fancychair
	name = "华丽木椅"
	result = /obj/item/chair/rogue/fancy/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry

/obj/item/chair/rogue/fancy/crafted
	sellprice = 12

/datum/crafting_recipe/roguetown/structure/stool
	name = "木凳"
	result = /obj/item/chair/stool/bar/rogue/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry

/obj/item/chair/stool/bar/rogue/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/anvil
	name = "铁砧"
	result = /obj/machinery/anvil
	reqs = list(/obj/item/ingot/iron = 1)
	skillcraft = /datum/skill/craft/blacksmithing
	verbage_simple = "锻炉"
	verbage = "锻造"

/datum/crafting_recipe/roguetown/structure/smelter
	name = "矿石熔炉"
	result = /obj/machinery/light/rogue/smelter
	reqs = list(/obj/item/natural/stone = 4,
			/obj/item/rogueore/coal = 1)
	verbage_simple = "建造"
	verbage = "建造"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/smelterhiron
	name = "炼铁炉"
	result = /obj/machinery/light/rogue/smelter/hiron
	reqs = list(/obj/item/natural/stone = 7,
			/obj/item/rogueore/coal = 2,
			/obj/item/rogueore/iron = 1)
	verbage_simple = "建造"
	verbage = "建造"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/smelterbronze
	name = "青铜熔炉"
	result = /obj/machinery/light/rogue/smelter/bronze
	reqs = list(/obj/item/natural/stone = 6,
			/obj/item/rogueore/coal = 1,
			/obj/item/rogueore/iron = 1)
	verbage_simple = "建造"
	verbage = "建造"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/greatsmelter
	name = "大熔炉"
	result = /obj/machinery/light/rogue/smelter/great
	reqs = list(/obj/item/ingot/iron = 2,
				/obj/item/riddleofsteel = 1,
				/obj/item/rogueore/coal = 1)
	verbage_simple = "建造"
	verbage = "建造"
	craftsound = null
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/forge
	name = "锻炉"
	result = /obj/machinery/light/rogue/forge
	reqs = list(/obj/item/natural/stone = 4,
				/obj/item/rogueore/coal = 1)
	verbage_simple = "建造"
	verbage = "建造"
	craftsound = null

/datum/crafting_recipe/roguetown/structure/sharpwheel
	name = "砂轮"
	result = /obj/structure/fluff/grindwheel
	reqs = list(/obj/item/ingot/iron = 1,
				/obj/item/natural/stone = 1)
	skillcraft = /datum/skill/craft/blacksmithing
	verbage_simple = "建造"
	verbage = "建造"
	craftsound = null


/datum/crafting_recipe/roguetown/structure/art_table
	name = "工艺师工作台"
	result = /obj/machinery/artificer_table
	reqs = list(/obj/item/natural/wood/plank = 1)
	skillcraft = /datum/skill/craft/engineering
	verbage_simple = "制作"
	verbage = "制作"

/datum/crafting_recipe/roguetown/structure/loom
	name = "织机"
	result = /obj/machinery/loom
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/grown/log/tree/stick = 2,
				/obj/item/natural/fibers = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/alch
	name = "炼金台"
	result = /obj/structure/fluff/alch
	reqs = list(/obj/item/natural/cloth = 2,
				/obj/item/natural/stone = 4,
				/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 0
	verbage_simple = "组装"
	verbage = "组装"

/datum/crafting_recipe/roguetown/structure/dyestation
	name = "染色台"
	result = /obj/machinery/gear_painter
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "制作"
	verbage = "制作"
	craftdiff = 0
/*
/datum/crafting_recipe/roguetown/structure/stairs
	name = "楼梯（上）"
	result = /obj/structure/stairs
	reqs = list(/obj/item/grown/log/tree/small = 1)

	verbage = "制作"
	craftsound = 'sound/foley/Building-01.ogg'
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/stairs/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step_multiz(T, UP)
	if(!checking)
		return FALSE
	if(!istype(checking,/turf/open/transparent/openspace))
		return FALSE
	checking = get_step(checking, user.dir)
	if(!checking)
		return FALSE
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking,/turf/open/transparent/openspace))
		return FALSE
	for(var/obj/structure/S in checking)
		if(istype(S, /obj/structure/stairs))
			return FALSE
		if(S.density)
			return FALSE
	return TRUE
*/
/datum/crafting_recipe/roguetown/structure/stairsd
	name = "木楼梯（下）"
	result = /obj/structure/stairs/d
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/stairsd/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step(T, user.dir)
	if(!checking)
		return FALSE
	if(!istype(checking,/turf/open/transparent/openspace))
		return FALSE
	checking = get_step_multiz(checking, DOWN)
	if(!checking)
		return FALSE
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking,/turf/open/transparent/openspace))
		return FALSE
	for(var/obj/structure/S in checking)
		if(istype(S, /obj/structure/stairs))
			return FALSE
		if(S.density)
			return FALSE
	return TRUE

/datum/crafting_recipe/roguetown/structure/stonestairsd
	name = "石楼梯（下）"
	result = /obj/structure/stairs/stone/d
	reqs = list(/obj/item/natural/stone = 2)
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 2
	verbage_simple = "建造"
	verbage = "建造"
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/stonestairsd/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step(T, user.dir)
	if(!checking)
		return FALSE
	if(!istype(checking,/turf/open/transparent/openspace))
		return FALSE
	checking = get_step_multiz(checking, DOWN)
	if(!checking)
		return FALSE
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking,/turf/open/transparent/openspace))
		return FALSE
	for(var/obj/structure/S in checking)
		if(istype(S, /obj/structure/stairs))
			return FALSE
		if(S.density)
			return FALSE
	return TRUE

/datum/crafting_recipe/roguetown/structure/bordercorner
	name = "边框角件"
	result = /obj/structure/fluff/railing/corner
	reqs = list(/obj/item/natural/wood/plank = 1)
	ontile = TRUE
	skillcraft = /datum/skill/craft/carpentry
	buildsame = TRUE
	diagonal = TRUE
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/border
	name = "边框"
	result = /obj/structure/fluff/railing/border
	reqs = list(/obj/item/natural/wood/plank = 1)
	ontile = TRUE
	skillcraft = /datum/skill/craft/carpentry
	buildsame = TRUE
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/railing
	name = "栏杆"
	result = /obj/structure/fluff/railing/wood
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	ontile = TRUE
	skillcraft = /datum/skill/craft/carpentry
	buildsame = TRUE

/datum/crafting_recipe/roguetown/structure/wallshelf
	name = "壁架（1 块木板）"
	result = /obj/structure/rack/rogue/shelf
	reqs = list(/obj/item/natural/wood/plank = 1)
	wallcraft = TRUE
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/mineshaft_support
	name = "矿井支架"
	result = /obj/structure/barricade/mineshaft
	reqs = list(/obj/item/grown/log/tree/small = 1)
	ontile = TRUE
	verbage_simple = "架设"
	verbage = "架设"
	buildsame = TRUE

/datum/crafting_recipe/roguetown/structure/fence
	name = "栅栏（木桩）"
	result = /obj/structure/fluff/railing/fence
	reqs = list(/obj/item/grown/log/tree/stake = 2)
	ontile = TRUE
	verbage_simple = "架设"
	verbage = "架设"
	buildsame = TRUE

/datum/crafting_recipe/roguetown/structure/headstake
	name = "头颅木桩"
	result = /obj/structure/fluff/headstake
	reqs = list(/obj/item/grown/log/tree/stake = 1,
				/obj/item/bodypart/head = 1)
	parts = list(/obj/item/bodypart/head = 1,
			/obj/item/grown/log/tree/stake = 1)
	verbage_simple = "架设"
	verbage = "架设"
	craftdiff = 0


/datum/crafting_recipe/roguetown/structure/fencealt
	name = "栅栏（圆木）"
	result = /obj/structure/fluff/railing/fence
	reqs = list(/obj/item/grown/log/tree/small = 1)
	ontile = TRUE
	verbage_simple = "架设"
	verbage = "架设"
	buildsame = TRUE

/datum/crafting_recipe/roguetown/structure/rack
	name = "架子"
	result = /obj/structure/rack/rogue
	reqs = list(/obj/item/grown/log/tree/stick = 3)
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/chest
	name = "箱子"
	result = /obj/structure/closet/crate/chest/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/obj/structure/closet/crate/chest/crafted
	keylock = FALSE
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/closet
	name = "柜子"
	result = /obj/structure/closet/crate/roguecloset
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/coffin
	name = "木棺"
	result = /obj/structure/closet/crate/coffin
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sleepcoffin
	name = "睡棺"
	result = /obj/structure/closet/crate/coffin/vampire
	reqs = list(/obj/item/natural/wood/plank = 2, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0 // I don't like lickers or wretches. but they cannot make this by default to even level up. I guess fair is fair. changed to 0

/obj/structure/closet/crate/roguecloset/crafted
	sellprice = 6

/datum/crafting_recipe/roguetown/structure/campfire
	name = "营火"
	result = /obj/machinery/light/rogue/campfire
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/densefire
	name = "大营火"
	result = /obj/machinery/light/rogue/campfire/densefire
	reqs = list(/obj/item/grown/log/tree/stick = 2,
				/obj/item/natural/stone = 2)
	verbage_simple = "建造"
	verbage = "建造"

/datum/crafting_recipe/roguetown/structure/cookpit
	name = "壁炉"
	result = /obj/machinery/light/rogue/hearth
	reqs = list(/obj/item/grown/log/tree/stick = 1,
				/obj/item/natural/stone = 3)
	verbage_simple = "建造"
	verbage = "建造"

/datum/crafting_recipe/roguetown/structure/brazier
	name = "火盆"
	result = /obj/machinery/light/rogue/firebowl/stump
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/rogueore/coal = 1)
	verbage_simple = "组装"
	verbage = "组装"

/datum/crafting_recipe/roguetown/structure/standing
	name = "立式火盆"
	result = /obj/machinery/light/rogue/firebowl/standing
	reqs = list(/obj/item/natural/stone = 1,
				/obj/item/rogueore/coal = 1)

/datum/crafting_recipe/roguetown/structure/standingblue
	name = "立式蓝火"
	result = /obj/machinery/light/rogue/firebowl/standing/blue
	reqs = list(/obj/item/natural/stone = 1,
				/obj/item/rogueore/coal = 1,
				/obj/item/ash = 1)

/datum/crafting_recipe/roguetown/structure/oven
	name = "烤炉"
	result = /obj/machinery/light/rogue/oven
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/stone = 3)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE

/datum/crafting_recipe/roguetown/structure/tanningrack
	name = "晾架(3 木棍)"
	result = /obj/machinery/tanningrack
	reqs = list(/obj/item/grown/log/tree/stick = 3)
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/strawbed
	name = "稻草床"
	result = /obj/structure/bed/rogue/shit
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/fibers = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/bed
	name = "舒适床"
	result = /obj/structure/bed/rogue/inn
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/natural/cloth = 2)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/woolbed
	name = "木床"
	result = /obj/structure/bed/rogue/inn/wool
	reqs = list(/obj/item/grown/log/tree/small = 2,
				/obj/item/natural/cloth = 1)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/doublebed
	name = "双人舒适床"
	result = /obj/structure/bed/rogue/inn/double
	reqs = list(/obj/item/grown/log/tree/small = 3,
				/obj/item/natural/cloth = 4)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2


/datum/crafting_recipe/roguetown/structure/wooldoublebed
	name = "双人羊毛床"
	result = /obj/structure/bed/rogue/inn/wooldouble
	reqs = list(/obj/item/grown/log/tree/small = 3,
				/obj/item/natural/cloth = 3)
	tools = list(/obj/item/needle)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/table
	name = "木桌 (1 小原木)"
	result = /obj/structure/table/wood/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry

/datum/crafting_recipe/roguetown/structure/fancytableblack
	name = "华丽木桌（黑色）"
	result = /obj/structure/table/wood/fancy/black
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytableblue
	name = "华丽木桌（蓝色）"
	result = /obj/structure/table/wood/fancy/blue
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytablecyan
	name = "华丽木桌（青色）"
	result = /obj/structure/table/wood/fancy/cyan
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytablegreen
	name = "华丽木桌（绿色）"
	result = /obj/structure/table/wood/fancy/green
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytableorange
	name = "华丽木桌（橙色）"
	result = /obj/structure/table/wood/fancy/orange
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytablepurple
	name = "华丽木桌（紫色）"
	result = /obj/structure/table/wood/fancy/purple
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytablered
	name = "华丽木桌（红色）"
	result = /obj/structure/table/wood/fancy/red
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/fancytableroyalblack
	name = "华丽木桌（皇家黑）"
	result = /obj/structure/table/wood/fancy/royalblack
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/fancytableroyalblue
	name = "华丽木桌（皇家蓝）"
	result = /obj/structure/table/wood/fancy/royalblue
	reqs = list(/obj/item/natural/wood/plank = 1, /obj/item/natural/silk = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/longtable
	name = "精致长桌 (2 块木板)"
	result = /obj/structure/table/wood/long_table
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/longtablealt
	name = "精致长桌（中） (2 块木板)"
	result = /obj/structure/table/wood/long_table/mid/alt
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/largetable
	name = "大桌 (2 块木板)"
	result = /obj/structure/table/wood/large_table
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/operatingtable
	name = "手术台 (2 小原木)"
	result = /obj/structure/table/optable
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/stonetable
	name = "石桌 (1 石头)"
	result = /obj/structure/table/church
	reqs = list(/obj/item/natural/stone = 1)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/finestonetable
	name = "精致石桌 (1 石砖)"
	result = /obj/structure/table/finestone
	reqs = list(/obj/item/natural/stoneblock = 1)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/millstone
	name = "磨盘"
	result = /obj/item/millstone
	reqs = list(/obj/item/natural/stone = 3)
	verbage = "组装"
	craftsound = null
	skillcraft = /datum/skill/craft/masonry


/datum/crafting_recipe/roguetown/structure/trapdoor/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return TRUE
	if(istype(T,/turf/open/lava))
		return FALSE
	return ..()

/datum/crafting_recipe/roguetown/structure/floorgrille
	name = "地格栅"
	result = /obj/structure/bars/grille
	reqs = list(/obj/item/ingot/iron = 1,
					/obj/item/roguegear/bronze = 1)
	verbage_simple = "装配"
	verbage = "装配"
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/floorgrille/TurfCheck(mob/user, turf/T)
	if(istype(T,/turf/open/transparent/openspace))
		return TRUE
	if(istype(T,/turf/open/lava))
		return FALSE
	return ..()


/datum/crafting_recipe/roguetown/structure/sign
	name = "定制招牌"
	result = /obj/structure/fluff/customsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

//icon signs

/datum/crafting_recipe/roguetown/structure/sign/zizoiconsign
	name = "wooden zizo sign (1 small log)"
	result = /obj/structure/fluff/iconsign/zizosign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sign/psydoniconsign
	name = "wooden psydon sign (1 small log)"
	result = /obj/structure/fluff/iconsign/psycrosssign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sign/eaglesign
	name = "wooden eagle sign (1 small log)"
	result = /obj/structure/fluff/iconsign/eaglesign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sign/spidersign
	name = "wooden spider sign (1 small log)"
	result = /obj/structure/fluff/iconsign/spidersign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sign/smithsign
	name = "wooden smith sign (1 small log)"
	result = /obj/structure/fluff/iconsign/smithsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sign/innsign
	name = "wooden inn sign (1 small log)"
	result = /obj/structure/fluff/iconsign/innsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sign/elksign
	name = "wooden elk sign (1 small log)"
	result = /obj/structure/fluff/iconsign/elksign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/sign/skullsign
	name = "wooden skull sign (1 small log)"
	result = /obj/structure/fluff/iconsign/skullsign
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1

// end of icon signs

/datum/crafting_recipe/roguetown/structure/dummy
	name = "训练假人"
	result = /obj/structure/fluff/statue/tdummy
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/grown/log/tree/stick = 1,
				/obj/item/natural/fibers = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 1



/datum/crafting_recipe/roguetown/structure/wallladder
	name = "壁梯"
	result = /obj/structure/wallladder
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	wallcraft = TRUE
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/torchholder
	name = "壁灯"
	result = /obj/machinery/light/rogue/torchholder
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/stonelantern
	name = "落地石灯"
	result = /obj/machinery/light/rogue/torchholder/hotspring
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "建造"
	verbage = "建造"
	wallcraft = FALSE
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/stonelanternstanding
	name = "立式石灯"
	result = /obj/machinery/light/rogue/torchholder/hotspring/standing
	reqs = list(/obj/item/natural/stone = 2)
	verbage_simple = "建造"
	verbage = "建造"
	wallcraft = FALSE
	skillcraft = /datum/skill/craft/masonry

/datum/crafting_recipe/roguetown/structure/wallcandle
	name = "壁式蜡烛"
	result = /obj/machinery/light/rogue/candle
	reqs = list(/obj/item/natural/stone = 1, /obj/item/candle/yellow = 1)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/wallcandleblue
	name = "蓝色壁式蜡烛"
	result = /obj/machinery/light/rogue/candle/blue
	reqs = list(/obj/item/natural/stone = 1, /obj/item/candle/yellow = 1, /obj/item/ash = 1)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/stonewalldeco
	name = "石墙装饰"
	result = /obj/structure/fluff/walldeco/stone
	reqs = list(/obj/item/natural/stone = 1)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE
	craftdiff = 2

// SCOM is not constructable, only the receive only version is constructable to prevent unactionable sneeding.
/datum/crafting_recipe/roguetown/structure/rcom
	name = "RCOM传讯网"
	result = /obj/structure/roguemachine/scomm/receive_only
	reqs = list(/obj/item/ingot/iron = 1,
					/obj/item/reagent_containers/food/snacks/smallrat = 1)
	verbage_simple = "组装"
	verbage = "组装"
	skillcraft = /datum/skill/magic/arcane
	craftdiff = 3
	wallcraft = TRUE
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/cauldronalchemy
	name = "炼金坩埚"
	result = /obj/machinery/light/rogue/cauldron
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/natural/stone = 3, /obj/item/reagent_containers/glass/bucket/pot/stone = 1) // changed to ore because this can be bought or mined. witches or even doctors who dont get a house get badly screwed over not having this.
	verbage_simple = "组装"
	verbage = "组装"
	skillcraft = /datum/skill/craft/alchemy
	craftdiff = 1

/datum/crafting_recipe/roguetown/structure/ceramicswheel
	name = "陶轮"
	result = /obj/structure/fluff/ceramicswheel
	reqs = list(/obj/item/natural/stone = 2, /obj/item/grown/log/tree/small = 2, /obj/item/cooking/platter = 1) // changed to platter. not always artificer to make cogs or anyone to even make bronze.
	verbage_simple = "制作"
	craftdiff = 2
	verbage = "制作"

/datum/crafting_recipe/roguetown/structure/bearrug
	name = "熊皮地毯"
	result = /obj/structure/bearpelt
	reqs = list(/obj/item/natural/fur/direbear = 2, /obj/item/natural/head/direbear = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/foxrug
	name = "狐皮地毯"
	result = /obj/structure/foxpelt
	reqs = list(/obj/item/natural/fur/fox = 2, /obj/item/natural/head/fox = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/bobcatrug
	name = "猞猁皮地毯"
	result = /obj/structure/bobcatpelt
	reqs = list(/obj/item/natural/fur/bobcat = 2)	//Gives no head for lynx, plus it's the smallest rug anyway.
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/curtain
	name = "窗帘"
	result = /obj/structure/curtain
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 0
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtaindirectional
	name = "定向窗帘"
	result = /obj/structure/curtain/directional/crafted
	reqs = list(/obj/item/natural/cloth = 2)
	craftdiff = 1
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainblack
	name = "窗帘（黑色）"
	result = /obj/structure/curtain/black
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainblue
	name = "窗帘（蓝色）"
	result = /obj/structure/curtain/blue
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainbrown
	name = "窗帘（棕色）"
	result = /obj/structure/curtain/brown
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtaingreen
	name = "窗帘（绿色）"
	result = /obj/structure/curtain/green
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainmagenta
	name = "窗帘（洋红色）"
	result = /obj/structure/curtain/magenta
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainpurple
	name = "窗帘（紫色）"
	result = /obj/structure/curtain/purple
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/curtainred
	name = "窗帘（红色）"
	result = /obj/structure/curtain/red
	reqs = list(/obj/item/natural/cloth = 2, /obj/item/natural/silk= 1 )
	craftdiff = 3
	ignoredensity = TRUE

/datum/crafting_recipe/roguetown/structure/apiary
	name = "蜂箱"
	result = /obj/structure/apiary
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/grown/log/tree/stick = 4)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

// Here for now until we get a new file for anything trap related.
/datum/crafting_recipe/roguetown/structure/spike_pit
	name = "尖刺坑（需要泥土地板）"
	result = list(/obj/structure/spike_pit)
	tools = list(/obj/item/rogueweapon/shovel = 1)
	reqs = list(/obj/item/grown/log/tree/stake = 3)
	skillcraft = /datum/skill/craft/crafting
	craftdiff = 1	//Low skill, but at least some. Kinda decently strong after all w/ combat.

/datum/crafting_recipe/roguetown/structure/spike_pit/TurfCheck(mob/user, turf/T)
	var/turf/to_check = get_step(user.loc, user.dir)
	if(!istype(to_check, /turf/open/floor/rogue/dirt))
		to_chat(user, span_info("我需要泥土地板才能这么做。"))
		return FALSE
	for(var/obj/O in T.contents)
		if(istype(O, /obj/structure/spike_pit))
			to_chat(user, span_info("这里已经有一个尖刺坑了。"))
			return FALSE
	return TRUE

/datum/crafting_recipe/roguetown/structure/wicker
	name = "藤篮"
	result = /obj/structure/closet/crate/chest/wicker
	reqs = list(/obj/item/grown/log/tree/stick = 4,
				/obj/item/natural/fibers = 3)
	verbage_simple = "编织"
	verbage = "编织"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/noose
	name = "绞索"
	result = /obj/structure/noose
	reqs = list(/obj/item/rope = 1)
	craftdiff = 1
	verbage = "系绑"
	craftsound = 'sound/foley/noose_idle.ogg'
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/noose/TurfCheck(mob/user, turf/T)
	var/turf/checking = get_step_multiz(T, UP)
	if(!checking)
		return TRUE // Letting you craft in centcom Z-level (bandit/vampire/wretch camps)
	if(!isopenturf(checking))
		return FALSE
	if(istype(checking, /turf/open/transparent/openspace))
		return FALSE
	return TRUE

/datum/crafting_recipe/roguetown/structure/gallows
	name = "绞刑架"
	result = /obj/structure/noose/gallows
	reqs = list(/obj/item/rope = 1, /obj/item/grown/log/tree/small = 2)
	craftdiff = 2
	craftsound = 'sound/foley/Building-01.ogg'
	ontile = TRUE

/datum/crafting_recipe/roguetown/structure/pillory
	name = "枷台"
	result = /obj/structure/pillory
	reqs = list(/obj/item/ingot/iron = 1, /obj/item/grown/log/tree/small = 1)
	craftdiff = 2
	craftsound = 'sound/foley/Building-01.ogg'
	ontile = TRUE

// Sofas and other furnishing

/datum/crafting_recipe/roguetown/structure/couchleft
	name = "沙发（左）"
	result = /obj/structure/chair/bench/couch
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/couchright
	name = "沙发（右）"
	result = /obj/structure/chair/bench/couch/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/blackcouchleft
	name = "黑色沙发（左）"
	result = /obj/structure/chair/bench/couchablack
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/blackcouchright
	name = "黑色沙发（右）"
	result = /obj/structure/chair/bench/couchablack/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/ultimacouchleft
	name = "终极沙发（左）"
	result = /obj/structure/chair/bench/ultimacouch
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/ultimacouchright
	name = "终极沙发（右）"
	result = /obj/structure/chair/bench/ultimacouch/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/altcouchleft
	name = "备用沙发（左）"
	result = /obj/structure/chair/bench/coucha
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/altcouchright
	name = "备用沙发（右）"
	result = /obj/structure/chair/bench/coucha/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/magentacouchleft
	name = "洋红沙发（左）"
	result = /obj/structure/chair/bench/couchamagenta
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/magentacouchright
	name = "洋红沙发（右）"
	result = /obj/structure/chair/bench/couchamagenta/r
	reqs = list(/obj/item/natural/wood/plank = 3,
				/obj/item/natural/silk = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/fireplace
	name = "壁炉（北）"
	result = /obj/machinery/light/rogue/campfire/fireplace/crafted
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/stoneblock = 3)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = TRUE

/datum/crafting_recipe/roguetown/structure/fireplace/blue
	name = "blue fireplace (north)"
	result = /obj/machinery/light/rogue/campfire/fireplace/crafted/blue
	reqs = list(/obj/item/grown/log/tree/small = 1,
				/obj/item/natural/stoneblock = 3,
				/obj/item/rogueore/copper = 1) //did you know that copper not only can produce green fire but blue too in high concentration?

/datum/crafting_recipe/roguetown/structure/mirror
	name = "镜子（北）"
	result = /obj/structure/mirror
	reqs = list(/obj/item/natural/wood/plank = 2,
				/obj/item/ingot/iron = 1,
				/obj/item/natural/glass = 1)
	skillcraft = /datum/skill/craft/carpentry
	verbage = "制作"
	wallcraft = TRUE
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/fancymirror
	name = "华丽镜子（北）"
	result = /obj/structure/mirror/fancy
	reqs = list(/obj/item/natural/wood/plank = 1,
				/obj/item/ingot/silver = 1,
				/obj/item/ingot/gold = 1,
				/obj/item/natural/glass = 1)
	skillcraft = /datum/skill/craft/carpentry
	wallcraft = TRUE
	craftdiff = 5

/datum/crafting_recipe/roguetown/structure/floorclock
	name = "落地钟 (固定)"
	result = /obj/structure/fluff/clock
	reqs = list(/obj/item/natural/wood/plank = 2,/obj/item/roguegear/bronze = 1, /obj/item/ingot/iron = 1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/wallclock
	name = "挂钟（北）"
	result = /obj/structure/fluff/wallclock
	reqs = list(/obj/item/natural/wood/plank = 2,/obj/item/roguegear/bronze = 1, /obj/item/ingot/iron = 1)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 2
	wallcraft = TRUE

/datum/crafting_recipe/roguetown/structure/drawer1// oh boy time to add drawers for all five of them, drawers are randomized and theres five different sprites that are all unique enough
	name = "长梳妆柜 （2 块木板）"
	result = /obj/structure/closet/crate/drawer/drawer2
	reqs= list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/drawer2
	name = "长梳妆柜（备用款）（2 块木板）"
	result = /obj/structure/closet/crate/drawer/drawer2
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/drawer3
	name = "高长梳妆柜（2 块木板）"
	result = /obj/structure/closet/crate/drawer/drawer3
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/drawer4
	name = "高窄梳妆柜（2 块木板）"
	result = /obj/structure/closet/crate/drawer/drawer4
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/drawer5
	name = "床头柜（2 块木板）"
	result = /obj/structure/closet/crate/drawer
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/telescope
	name = "望远镜"
	result = /obj/structure/telescope
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/ingot/iron = 1, /obj/item/natural/glass = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/globe
	name = "地球仪"
	result = /obj/structure/globe
	reqs = list(/obj/item/grown/log/tree/stick = 2, /obj/item/natural/wood/plank = 3)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/tablewood3
	name = "木桌（备用款）（1 块木板）"
	result = /obj/structure/table/wood/poor/alt_alt
	reqs = list(/obj/item/natural/wood/plank = 1)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/actualfancytable
	name = "metallic wooden table (2 planks)"
	result = /obj/structure/table/wood
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

/datum/crafting_recipe/roguetown/structure/ornatetable
	name = "华饰木桌（2 块木板）"
	result = /obj/structure/table/fine
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftdiff = 3

// hanging chains

/datum/crafting_recipe/roguetown/structure/hangingchains
	name = "悬挂锁链（2 锁链）"
	result = /obj/structure/fluff/walldeco/chains
	reqs = list(/obj/item/rope/chain = 2)
	skillcraft = /datum/skill/craft/engineering
	craftdiff = 1

// floor candles

/datum/crafting_recipe/roguetown/structure/floorcandle
	name = "落地蜡烛（2 蜡烛）"
	result = /obj/machinery/light/rogue/candle/floorcandle
	reqs = list(/obj/item/candle/yellow = 2)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = FALSE
	craftdiff = 0


/datum/crafting_recipe/roguetown/structure/floorcandlealt
	name = "备用落地蜡烛（2 蜡烛）"
	result = /obj/machinery/light/rogue/candle/floorcandle/alt
	reqs = list(/obj/item/candle/yellow = 2)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = FALSE
	craftdiff = 0


/datum/crafting_recipe/roguetown/structure/floorcandlepink
	name = "伊欧拉 落地蜡烛"
	result = /obj/machinery/light/rogue/candle/floorcandle/pink
	reqs = list(/obj/item/candle/eora = 2)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = FALSE
	craftdiff = 0


/datum/crafting_recipe/roguetown/structure/floorcandlealtpink
	name = "备用 伊欧拉 落地蜡烛"
	result = /obj/machinery/light/rogue/candle/floorcandle/alt/pink
	reqs = list(/obj/item/candle/eora = 2)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	wallcraft = FALSE
	craftdiff = 0

// floor pillows

/datum/crafting_recipe/roguetown/structure/redpillows
	name = "红色靠枕（2 块布）"
	result = /obj/structure/fluff/pillow/red
	reqs = list(/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/bluepillows
	name = "蓝色靠枕（2 块布）"
	result = /obj/structure/fluff/pillow/blue
	reqs = list(/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/greenpillows
	name = "绿色靠枕（2 块布）"
	result = /obj/structure/fluff/pillow/green
	reqs = list(/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/brownpillows
	name = "棕色靠枕（2 块布）"
	result = /obj/structure/fluff/pillow/brown
	reqs = list(/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/magentapillows
	name = "洋红靠枕（2 块布）"
	result = /obj/structure/fluff/pillow/magenta
	reqs = list(/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/purplepillows
	name = "紫色靠枕（2 块布）"
	result = /obj/structure/fluff/pillow/purple
	reqs = list(/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2

/datum/crafting_recipe/roguetown/structure/blackpillows
	name = "黑色靠枕（2 块布）"
	result = /obj/structure/fluff/pillow/black
	reqs = list(/obj/item/natural/cloth = 2)
	skillcraft = /datum/skill/craft/sewing
	craftdiff = 2
