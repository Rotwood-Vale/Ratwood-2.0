
// /datum/crafting_recipe/roguetown/structure
// 	abstract_type = /datum/crafting_recipe/roguetown/structure
// 	req_table = FALSE
// 	subtype_reqs = TRUE
// 	craftsound = 'sound/foley/Building-01.ogg'
// 	verbage_simple = "construct"
// 	verbage = "constructs"

// /datum/crafting_recipe/roguetown/structure/TurfCheck(mob/user, turf/T)
// 	if(istype(T,/turf/open/transparent/openspace))
// 		return FALSE
// 	if(istype(T, /turf/open/water))
// 		return FALSE
// 	return ..()

/datum/crafting_recipe/roguetown/structure/statue
	reqs = list(/obj/item/natural/stone = 4)
	verbage_simple = "建造"
	verbage = "建造"
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/statue/woman
	name = "雕像（女士）"
	result = /obj/structure/fluff/statue/femalestatue

/datum/crafting_recipe/roguetown/structure/statue/woman
	name = "雕像（坐姿女士）"
	result = /obj/structure/fluff/statue/femalestatue2

/datum/crafting_recipe/roguetown/structure/statue/aasimar
	name = "雕像（亚斯玛）"
	result = /obj/structure/fluff/statue/aasimar

/datum/crafting_recipe/roguetown/structure/statue/tiefling
	name = "雕像（提夫林）"
	result = /obj/structure/fluff/statue/small
	reqs = list(/obj/item/natural/stone = 2)

/datum/crafting_recipe/roguetown/structure/statue/gargoyle
	name = "雕像（石像鬼）"
	result = /obj/structure/fluff/statue/gargoyle
	reqs = list(/obj/item/natural/stone = 2)

/datum/crafting_recipe/roguetown/structure/statue/knight
	name = "雕像（骑士，朝左）"
	result = /obj/structure/fluff/statue/knight

/datum/crafting_recipe/roguetown/structure/statue/knightr
	name = "雕像（骑士，朝右）"
	result = /obj/structure/fluff/statue/knight/r

/datum/crafting_recipe/roguetown/structure/statue/knightalt
	name = "雕像（高大骑士，朝左）"
	result = /obj/structure/fluff/statue/knightalt

/datum/crafting_recipe/roguetown/structure/statue/knightaltr
	name = "雕像（高大骑士，朝右）"
	result = /obj/structure/fluff/statue/knightalt/r

/datum/crafting_recipe/roguetown/structure/statue/hooded
	name = "雕像（兜帽）"
	result = /obj/structure/fluff/statue
	reqs = list(/obj/item/natural/stone = 3)

/datum/crafting_recipe/roguetown/structure/statue/grand
	reqs = list(/obj/item/natural/stone = 4, /obj/item/ingot/gold)
	craftdiff = 5

/datum/crafting_recipe/roguetown/structure/statue/grand/valmora
	name = "雕像（宏伟，瓦莫拉）"
	result = /obj/structure/fluff/statue/valmora

/datum/crafting_recipe/roguetown/structure/statue/grand/astrata
	name = "雕像（宏伟，阿斯特拉塔）"
	result = /obj/structure/fluff/statue/astrata/gold

/datum/crafting_recipe/roguetown/structure/statue/grand/eora
	name = "雕像（宏伟，伊欧拉）"
	result = /obj/structure/fluff/statue/eora

/datum/crafting_recipe/roguetown/structure/statue/grand/noc
	name = "雕像（宏伟，诺克）"
	result = /obj/structure/fluff/statue/noc

/datum/crafting_recipe/roguetown/structure/statue/grand/abyssor
	name = "雕像（宏伟，阿比索尔）"
	result = /obj/structure/fluff/statue/abyssor
	reqs = list(/obj/item/natural/stone = 5)
	craftdiff = 5

/datum/crafting_recipe/roguetown/structure/statue/grand/abyssor/dolomite
	name = "雕像（宏伟，阿比索尔，白云石）"
	result = /obj/structure/fluff/statue/abyssor/dolomite

