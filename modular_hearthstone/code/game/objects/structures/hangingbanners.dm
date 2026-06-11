
/obj/structure/fluff/littlebanners
	name = "悬挂小旗"
	desc = ""
	icon = 'modular_hearthstone/icons/obj/decor.dmi'
	icon_state = "hangingbanners_wr"
	density = FALSE
	anchored = TRUE
	layer = ABOVE_MOB_LAYER
	plane = GAME_PLANE_UPPER
	blade_dulling = DULLING_BASH
	resistance_flags = FLAMMABLE
	max_integrity = 20
	integrity_failure = 0.33
	dir = SOUTH
	destroy_sound = 'sound/combat/hits/onwood/destroyfurniture.ogg'
	attacked_sound = list('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')


/obj/structure/fluff/littlebanners/greenblue
	icon_state = "hangingbanners_gb"

/obj/structure/fluff/littlebanners/greenred
	icon_state = "hangingbanners_gr"

/obj/structure/fluff/littlebanners/bluewhite
	icon_state = "hangingbanners_bw"

/obj/structure/fluff/littlebanners/greenwhite
	icon_state = "hangingbanners_gw"

/obj/structure/fluff/littlebanners/bluered
	icon_state = "hangingbanners_br"

/obj/structure/fluff/littlebanners/MouseDrop(over_object, src_location, over_location)
	. = ..()
	if(over_object == usr && Adjacent(usr) && (in_range(src, usr) || usr.contents.Find(src)))
		if(!ishuman(usr))
			return
		visible_message(span_notice("[usr]拆除了[src]。"))
		if(do_after(usr, 30, target = src))
			playsound(src,'sound/foley/dropsound/cloth_drop.ogg', 100, FALSE)
			new /obj/item/natural/cloth (get_turf(src))
			new /obj/item/natural/cloth (get_turf(src))
			new /obj/item/natural/cloth (get_turf(src))
			new /obj/item/natural/cloth (get_turf(src))
			qdel(src)

///Crafting

/datum/crafting_recipe/roguetown/structure/littlebanners
	name = "集市旗帜 红白"
	result = list(/obj/structure/fluff/littlebanners)
	reqs = list(/obj/item/natural/cloth = 4, /obj/item/natural/fibers)
	verbage_simple = "搭建"
	verbage = "搭建"
	craftdiff = 0

/datum/crafting_recipe/roguetown/structure/littlebanners/greenblue
	name = "集市旗帜 绿蓝"
	result = list(/obj/structure/fluff/littlebanners/greenblue)

/datum/crafting_recipe/roguetown/structure/littlebanners/greenred
	name = "集市旗帜 绿红"
	result = list(/obj/structure/fluff/littlebanners/greenred)

/datum/crafting_recipe/roguetown/structure/littlebanners/bluewhite
	name = "集市旗帜 蓝白"
	result = list(/obj/structure/fluff/littlebanners/bluewhite)

/datum/crafting_recipe/roguetown/structure/littlebanners/greenwhite
	name = "集市旗帜 绿白"
	result = list(/obj/structure/fluff/littlebanners/greenwhite)

/datum/crafting_recipe/roguetown/structure/littlebanners/bluered
	name = "集市旗帜 蓝红"
	result = list(/obj/structure/fluff/littlebanners/bluered)
