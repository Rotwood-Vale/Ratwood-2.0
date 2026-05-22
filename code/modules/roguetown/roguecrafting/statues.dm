
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
	verbage_simple = "build"
	verbage = "builds"
	skillcraft = /datum/skill/craft/masonry
	craftdiff = 4

/datum/crafting_recipe/roguetown/structure/statue/woman
	name = "statue (lady)"
	result = /obj/structure/fluff/statue/femalestatue

/datum/crafting_recipe/roguetown/structure/statue/woman
	name = "statue (lady sitting)"
	result = /obj/structure/fluff/statue/femalestatue2

/datum/crafting_recipe/roguetown/structure/statue/aasimar
	name = "statue (aasimar)"
	result = /obj/structure/fluff/statue/aasimar

/datum/crafting_recipe/roguetown/structure/statue/tiefling
	name = "statue (tiefling)"
	result = /obj/structure/fluff/statue/small
	reqs = list(/obj/item/natural/stone = 2)

/datum/crafting_recipe/roguetown/structure/statue/gargoyle
	name = "statue (gargoyle)"
	result = /obj/structure/fluff/statue/gargoyle
	reqs = list(/obj/item/natural/stone = 2)

/datum/crafting_recipe/roguetown/structure/statue/knight
	name = "statue (knight, facing left)"
	result = /obj/structure/fluff/statue/knight

/datum/crafting_recipe/roguetown/structure/statue/knightr
	name = "statue (knight, facing right)"
	result = /obj/structure/fluff/statue/knight/r

/datum/crafting_recipe/roguetown/structure/statue/knightalt
	name = "statue (knight, tall, facing left)"
	result = /obj/structure/fluff/statue/knightalt

/datum/crafting_recipe/roguetown/structure/statue/knightaltr
	name = "statue (knight, tall, facing right)"
	result = /obj/structure/fluff/statue/knightalt/r

/datum/crafting_recipe/roguetown/structure/statue/hooded
	name = "statue (hooded)"
	result = /obj/structure/fluff/statue
	reqs = list(/obj/item/natural/stone = 3)

/datum/crafting_recipe/roguetown/structure/statue/grand
	reqs = list(/obj/item/natural/stone = 4, /obj/item/ingot/gold)
	craftdiff = 5

/datum/crafting_recipe/roguetown/structure/statue/grand/zizo
	name = "statue (grand, Zizo)"
	result = /obj/structure/fluff/statue/zizo

/datum/crafting_recipe/roguetown/structure/statue/grand/astrata
	name = "statue (grand, Astrata)"
	result = /obj/structure/fluff/statue/astrata/gold

/datum/crafting_recipe/roguetown/structure/statue/grand/eora
	name = "statue (grand, Eora)"
	result = /obj/structure/fluff/statue/eora

/datum/crafting_recipe/roguetown/structure/statue/grand/noc
	name = "statue (grand, Noc)"
	result = /obj/structure/fluff/statue/noc

/datum/crafting_recipe/roguetown/structure/statue/grand/abyssor
	name = "statue (grand, Abyssor)"
	result = /obj/structure/fluff/statue/abyssor
	reqs = list(/obj/item/natural/stone = 5)
	craftdiff = 5

/datum/crafting_recipe/roguetown/structure/statue/grand/abyssor/dolomite
	name = "statue (grand, Abyssor (dolomite))"
	result = /obj/structure/fluff/statue/abyssor/dolomite

