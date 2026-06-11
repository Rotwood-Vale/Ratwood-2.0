///////////
// WOOD //
//////////

//Master wood crafting - standardizes all wood crafting.
/datum/crafting_recipe/roguetown/turfs/wood
	name = "地板（粗木）（1 根小圆木）"
	result = /turf/open/floor/rogue/ruinedwood
	reqs = list(/obj/item/grown/log/tree/small = 1)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 0

/datum/crafting_recipe/roguetown/turfs/wood/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue))
		return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/wood/floor
	name = "地板（粗木）（1 块木板）"
	result = /turf/open/floor/rogue/ruinedwood
	reqs = list(/obj/item/natural/wood/plank = 1)

/datum/crafting_recipe/roguetown/turfs/wood/floor
	name = "地板（木制）（1 块木板）"
	result = /turf/open/floor/rogue/wood
	reqs = list(/obj/item/natural/wood/plank = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/wood/platform
	name = "平台（木制）（2 块木板）"
	result = /turf/open/floor/rogue/ruinedwood/platform
	reqs = list(/obj/item/natural/wood/plank = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/wood/floorhw
	name = "地板（风化人字纹）"
	result = /turf/open/floor/rogue/ruinedwood/herringbone
	reqs = list(/obj/item/natural/wood/plank = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/turfs/wood/floorhs
	name = "地板（压印人字纹）"
	result = /turf/open/floor/rogue/ruinedwood/chevron
	reqs = list(/obj/item/natural/wood/plank = 1)
	craftdiff = 4

/datum/crafting_recipe/roguetown/turfs/wood/floorslanted
	name = "地板（斜纹）"
	result = /turf/open/floor/rogue/ruinedwood/spiral
	reqs = list(/obj/item/natural/wood/plank = 1)
	craftdiff = 3

//Platform has unique turf-check vs normal turf.
/datum/crafting_recipe/roguetown/turfs/wood/platform/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/transparent/openspace))
		if(!istype(T, /turf/open/water))
			return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/wood/wall
	name = "墙（木制）（2 根小圆木）"
	result = /turf/closed/wall/mineral/rogue/wood
	reqs = list(/obj/item/grown/log/tree/small = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/wood/wall/alt
	reqs = list(/obj/item/natural/wood/plank = 2)

/datum/crafting_recipe/roguetown/turfs/wood/fancy
	name = "华丽木墙（2 块木板）"
	result = /turf/closed/wall/mineral/rogue/decowood
	reqs = list(/obj/item/natural/wood/plank = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/wood/murderhole
	name = "射孔（木制）（2 根小圆木）"
	result = /turf/closed/wall/mineral/rogue/wood/window
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/wood/murderhole/alt
	reqs = list(/obj/item/natural/wood/plank = 2)

/// carpet
/datum/crafting_recipe/roguetown/turfs/carpet
	name = "地毯（旅店）"
	result = /turf/open/floor/carpet/inn
	reqs = list(/obj/item/natural/silk= 2)	
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/carpet/purple
	name = "地毯（紫色）"
	result = /turf/open/floor/carpet/purple
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/carpet/red
	name = "地毯（红色）"
	result = /turf/open/floor/carpet/red
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/carpet/stellar
	name = "地毯（星辉）"
	result = /turf/open/floor/carpet/stellar
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/carpet/royalblack
	name = "地毯（皇家黑）"
	result = /turf/open/floor/carpet/royalblack
	craftdiff = 3

/// STONE

/datum/crafting_recipe/roguetown/turfs/stone
	reqs = list(/obj/item/natural/stoneblock = 1)
	skillcraft = /datum/skill/craft/masonry
	verbage_simple = "建造"
	verbage = "建造"

/datum/crafting_recipe/roguetown/turfs/stone/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue))
		return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/stone/cobblerock
	name = "道路（鹅卵石）（1 块石料）"
	result = /turf/open/floor/rogue/cobblerock
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 0

/datum/crafting_recipe/roguetown/turfs/stone/cobblerock/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue/dirt))
		return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/stone/cobble
	name = "地板（鹅卵石）（1 块石料）"
	result = /turf/open/floor/rogue/cobble
	reqs = list(/obj/item/natural/stone = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/turfs/stone/block
	name = "地板（石砖）（1 块石料）"
	result = /turf/open/floor/rogue/blocks
	craftdiff = 1

/datum/crafting_recipe/roguetown/turfs/stone/newstone
	name = "地板（新石）（2 块石砖）"
	result = /turf/open/floor/rogue/blocks/newstone/alt
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/stone/herringbone
	name = "地板（人字纹）（2 块石砖）"
	result = /turf/open/floor/rogue/herringbone
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/hexstone
	name = "地板（六角石）（2 块石砖）"
	result = /turf/open/floor/rogue/hexstone
	craftdiff = 4

/datum/crafting_recipe/roguetown/turfs/stone/platform
	name = "平台（石制）（2 块石砖）"
	result = /turf/open/floor/rogue/blocks/platform
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/stone/redstone
	name = "地板（红石）"
	result = /turf/open/floor/rogue/blocks/stonered
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/stone/tinyredstone
	name = "地板（细红石）"
	result = /turf/open/floor/rogue/blocks/stonered/tiny
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/stone/marblefloor
	name = "大理石地板（石料）"
	result = /turf/open/floor/rogue/churchmarble
	reqs = list(/obj/item/natural/stoneblock = 4)
	craftdiff = 4

/datum/crafting_recipe/roguetown/turfs/stone/bluestone2
	name = "蓝石板"
	result = /turf/open/floor/rogue/blocks/bluestone
	reqs = list(/obj/item/natural/stoneblock = 3)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/concreteslab
	name = "大型石板"
	result = /turf/open/floor/rogue/concrete
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/stone/masonic
	name = "石匠装饰地板"
	result = /turf/open/floor/rogue/tile/masonic
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/masonicalt
	name = "石匠反纹装饰地板"
	result = /turf/open/floor/rogue/tile/masonic/inverted
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/masonicspiral
	name = "石匠螺旋装饰地板"
	result = /turf/open/floor/rogue/tile/masonic/spiral
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/bluelargetile
	name = "蓝色大砖"
	result = /turf/open/floor/rogue/tile/bfloorz
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/churchredbrick
	name = "大型红色石匠砖"
	result = /turf/open/floor/rogue/churchbrick
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/haremgreenbricks
	name = "后宫绿砖"
	result = /turf/open/floor/rogue/tile/harem1
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/haremredbricks
	name = "后宫红砖"
	result = /turf/open/floor/rogue/tile/harem
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/harempink
	name = "后宫粉砖"
	result = /turf/open/floor/rogue/tile/harem2
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/platform/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/transparent/openspace))
		if(!istype(T, /turf/open/water))
			return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/stone/wall
	name = "墙（石制）（2 块石料）"
	result = /turf/closed/wall/mineral/rogue/stone
	reqs = list(/obj/item/natural/stone = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/stone/brick
	name = "墙（石砖）（2 块石砖）"
	result = /turf/closed/wall/mineral/rogue/stonebrick
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/brick/bricklight
	name = "wall (stonebrick light) (2 stoneblocks, 1 lamptern)"
	result = /turf/closed/wall/mineral/rogue/stonebrick/stonebricklight
	reqs = list(/obj/item/natural/stoneblock = 2, /obj/item/flashlight/flare/torch/lantern = 1)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/decorated
	name = "装饰石墙（2 块石料）"
	result = /turf/closed/wall/mineral/rogue/decostone
	reqs = list(/obj/item/natural/stone = 2)
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/stone/craft
	name = "墙（工艺石）（3 块石砖）"
	result = /turf/closed/wall/mineral/rogue/craftstone
	reqs = list(/obj/item/natural/stoneblock = 3)
	craftdiff = 4

/datum/crafting_recipe/roguetown/turfs/stone/window
	name = "射孔（石制）（2 块石砖）"
	result = /turf/closed/wall/mineral/rogue/stone/window
	reqs = list(/obj/item/natural/stoneblock = 2)
	craftdiff = 2


/// BRICK

/datum/crafting_recipe/roguetown/turfs/brick
	reqs = list(/obj/item/natural/brick = 1)
	skillcraft = /datum/skill/craft/masonry
	verbage_simple = "建造"
	verbage = "建造"

/datum/crafting_recipe/roguetown/turfs/brick/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue))
		return
	return TRUE

//Needs brick walls, windows, and platforms added at some point but need sprites for this.
/datum/crafting_recipe/roguetown/turfs/brick/floor
	name = "地板（砖）（1 块砖）"
	result = /turf/open/floor/rogue/tile/brick
	reqs = list(/obj/item/natural/brick = 1)
	craftdiff = 1

/datum/crafting_recipe/roguetown/turfs/brick/wall
	name = "墙（砖）（1 块砖）"
	result = /turf/closed/wall/mineral/rogue/brick
	reqs = list(/obj/item/natural/brick = 1)
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/brick/window
	name = "射孔（砖）（2 块砖）"
	result = /turf/closed/wall/mineral/rogue/brick/window
	reqs = list(/obj/item/natural/brick = 2)
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/brick/window/openclose
	name = "加固窗（砖）（2 块砖，1 份铁，1 块玻璃，1 团泥土）"
	result = /obj/structure/roguewindow/openclose/reinforced/brick
	reqs = list(
	  /obj/item/natural/brick = 2,
	  /obj/item/ingot/iron = 1,
	  /obj/item/natural/glass = 1,
	  /obj/item/natural/dirtclod = 1,
	)
	skillcraft = /datum/skill/craft/blacksmithing
	craftsound = 'sound/items/bsmith1.ogg'
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 2

/// WINDOWS

/datum/crafting_recipe/roguetown/turfs/roguewindow
	name = "窗（木制）（2 根小圆木）"
	result = /obj/structure/roguewindow
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry
	craftsound = 'sound/foley/Building-01.ogg'
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 2

/datum/crafting_recipe/roguetown/turfs/fancywindow/openclose
	name = "华丽窗（2 根小圆木，1 块石料，1 块玻璃，1 团泥土）"
	result = /obj/structure/roguewindow/openclose
	reqs = list(
	  /obj/item/grown/log/tree/small = 2,
	  /obj/item/natural/stone = 1,
	  /obj/item/natural/glass = 1,
	  /obj/item/natural/dirtclod = 1,
	)
	skillcraft = /datum/skill/craft/carpentry
	craftsound = 'sound/foley/Building-01.ogg'
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/reinforcedwindow/openclose
	name = "加固窗（2 根小圆木，1 份铁，1 块玻璃，1 团泥土）"
	result = /obj/structure/roguewindow/openclose/reinforced
	reqs = list(
		/obj/item/grown/log/tree/small = 2,
		/obj/item/ingot/iron = 1,
		/obj/item/natural/glass = 1,
		/obj/item/natural/dirtclod = 1,
	)
	skillcraft = /datum/skill/craft/blacksmithing
	craftsound = 'sound/items/bsmith1.ogg'
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 2
	
/// HAY, TWIG AND TENT

/datum/crafting_recipe/roguetown/turfs/hay
	name = "地板（干草）（2 根麦秆）"
	result = /turf/open/floor/rogue/hay
	reqs = list(/obj/item/natural/chaff/wheat = 2)
	skillcraft = /datum/skill/craft/crafting
	verbage_simple = "组装"
	verbage = "组装"
	craftdiff = 0

/datum/crafting_recipe/roguetown/turfs/twig
	name = "地板（树枝）（2 根木棍）"
	result = /turf/open/floor/rogue/twig
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	skillcraft = /datum/skill/craft/crafting
	verbage_simple = "组装"
	verbage = "组装"
	craftdiff = 0
	loud = TRUE

/datum/crafting_recipe/roguetown/turfs/twig/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue/dirt))
		if(!(istype(T, /turf/open/floor/rogue/grass) || istype(T, /turf/open/floor/rogue/grassred) || istype(T, /turf/open/floor/rogue/grassyel) || istype(T, /turf/open/floor/rogue/grasscold)))
			return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/twigplatform
	name = "平台（树枝）（2 根木棍）" //no more cursed single stick left over
	result = /turf/open/floor/rogue/twig/platform
	reqs = list(/obj/item/grown/log/tree/stick = 2)
	skillcraft = /datum/skill/craft/crafting
	verbage_simple = "组装"
	verbage = "组装"
	craftdiff = 1
	loud = TRUE

/datum/crafting_recipe/roguetown/turfs/twigplatform/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/transparent/openspace))
		if(!istype(T, /turf/open/water))
			return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/tentwall
	name = "帐篷墙（1 根木棍，1 块布）"
	result = /turf/closed/wall/mineral/rogue/tent
	reqs = list(/obj/item/grown/log/tree/stick = 1,
				/obj/item/natural/cloth = 1)
	skillcraft = /datum/skill/craft/crafting
	verbage_simple = "搭建"	
	verbage = "搭建"
	craftdiff = 1

/datum/crafting_recipe/roguetown/turfs/tentwall/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue))
		return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/tentdoor
	name = "帐篷门（1 根木棍，1 块布）"
	result = /obj/structure/roguetent
	reqs = list(/obj/item/grown/log/tree/stick = 1,
				/obj/item/natural/cloth = 1)
	skillcraft = /datum/skill/craft/crafting
	verbage_simple = "搭建"
	verbage = "搭建"
	craftdiff = 1

/datum/crafting_recipe/roguetown/turfs/tentdoor/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue))
		return
	return ..()

// Normal, non-openable window
/datum/crafting_recipe/roguetown/turfs/roguewindow
	name = "固定玻璃窗（2 根小圆木）"
	result = /obj/structure/roguewindow
	reqs = list(/obj/item/grown/log/tree/small = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 4

	/*
	By the way, glass windows needing Masonry and Carpentry instead of Ceramics isn't an oversight.
	The Mason and the Carpenter are the ones who will build the window itself from wood and
	an already prepared pane of glass. The potter has nothing to do with this part of the process.
	*/// - SunriseOYH
	// Glass requirement removed from the wooden windows due to the sheer annoyance of actually getting glass - annikaRU

/datum/crafting_recipe/roguetown/turfs/roguewindow/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue))
		return
	return TRUE

// The windows you can open and close
/datum/crafting_recipe/roguetown/turfs/roguewindow/dynamic
	name = "可开启玻璃窗（2 根小圆木）"
	result = /obj/structure/roguewindow/openclose
	reqs = list(/obj/item/grown/log/tree/small = 2)
	craftdiff = 4

// The 'windows' of the church that almost no one knows exists.
/datum/crafting_recipe/roguetown/turfs/roguewindow/stone
	name = "固定玻璃窗（2 块石料，1 块玻璃）"
	result = /obj/structure/roguewindow/stained/silver
	reqs = list(/obj/item/natural/stone = 2, /obj/item/natural/glass = 1)
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 3

// Reinfored windows
/datum/crafting_recipe/roguetown/turfs/roguewindow/reinforced
	name = "加固玻璃窗（2 根小圆木，1 份铁，1 块玻璃）"
	result = /obj/structure/roguewindow/openclose/reinforced
	reqs = list(/obj/item/grown/log/tree/small = 2, /obj/item/natural/glass = 1, /obj/item/ingot/iron = 1)
	craftdiff = 3

// Dark Wood Walls

/datum/crafting_recipe/roguetown/turfs/wood/darkwoodwall
	name = "深木墙(2 wood planks)"
	result = /turf/closed/wall/mineral/rogue/wooddark
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/wood/darkwoodwindow
	name =	"深木射孔（2 块木板）"
	result = /turf/closed/wall/mineral/rogue/wooddark/window
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "建造"
	verbage = "建造"
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/wood/darkwoodwall/vertical
	name = "dark wood wall vertical (2 wood planks)"
	result = /turf/closed/wall/mineral/rogue/wooddark/vertical
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

/datum/crafting_recipe/roguetown/turfs/wood/darkwoodwall/horizontal
	name = "dark wood wall horizontal (2 wood planks)"
	result = /turf/closed/wall/mineral/rogue/wooddark/horizontal
	reqs = list(/obj/item/natural/wood/plank = 2)
	skillcraft = /datum/skill/craft/carpentry
	verbage_simple = "construct"
	verbage = "constructs"
	craftdiff = 3

// Druidic Grass Turfs

/datum/crafting_recipe/roguetown/turfs/druidic_grass
	abstract_type = /datum/crafting_recipe/roguetown/turfs/druidic_grass
	req_table = FALSE
	always_availible = TRUE
	skillcraft = /datum/skill/magic/druidic
	craftdiff = SKILL_LEVEL_MASTER
	reqs = list(
		/obj/item/fertilizer = 1,
		/obj/item/natural/fibers = 3,
	)
	tools = list(/obj/item/alch/bloomstone = 1)
	verbage_simple = "种植"
	verbage = "种植"

/datum/crafting_recipe/roguetown/turfs/druidic_grass/TurfCheck(mob/user, turf/T)
	if(isclosedturf(T))
		return
	if(!istype(T, /turf/open/floor/rogue))
		return
	return TRUE

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grass
	name = "草地"
	result = /turf/open/floor/rogue/grass

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grassred
	name = "红草地"
	result = /turf/open/floor/rogue/grassred

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grassyel
	name = "黄草地"
	result = /turf/open/floor/rogue/grassyel

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grasscold
	name = "寒地草皮"
	result = /turf/open/floor/rogue/grasscold

/datum/crafting_recipe/roguetown/turfs/druidic_grass/desert_grass
	name = "沙地草皮"
	result = /turf/open/floor/rogue/desert_grass

/datum/crafting_recipe/roguetown/turfs/druidic_grass/grasspurple
	name = "紫草地"
	result = /turf/open/floor/rogue/grasspurple
