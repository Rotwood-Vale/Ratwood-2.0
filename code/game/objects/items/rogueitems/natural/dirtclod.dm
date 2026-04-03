/obj/item/natural/dirtclod
	name = "clod"
	desc = "A handful of earth."
	icon_state = "clod1"
	dropshrink = 0
	throwforce = 0
	w_class = WEIGHT_CLASS_TINY

/obj/item/natural/dirtclod/snow
	name = "packed snow"
	desc = "A handful of snow"
	icon_state = "snow1"

/obj/item/natural/dirtclod/snow/Initialize(mapload)
	..()
	icon_state = "snow[rand(1,2)]"

/obj/item/natural/dirtclod/sand
	name = "sand"
	desc = "A handful of loose sand."
	icon_state = "sand1"

/obj/item/natural/dirtclod/sand/Initialize(mapload)
	. = ..()
	icon_state = "sand[rand(1,2)]"

/obj/item/natural/dirtclod/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/rogueweapon/shovel))
		var/obj/item/rogueweapon/shovel/S = W
		if(!S.heldclod && user.used_intent.type == /datum/intent/shovelscoop)
			playsound(loc,'sound/items/dig_shovel.ogg', 100, TRUE)
			src.forceMove(S)
			S.heldclod = src
			W.update_icon()
			return
	..()

/obj/item/natural/dirtclod/Moved(oldLoc, dir)
	if(QDELETED(src))
		return
	..()
	if(istype(src, /obj/item/natural/dirtclod/sand))
		if(isturf(loc))
			var/turf/T_sand = loc
			for(var/obj/structure/fluff/sandpile/SP in T_sand)
				SP.sandamt = min(SP.sandamt + 1, 5)
				qdel(src)
				return
			var/sandcount = 1
			var/list/sands = list()
			for(var/obj/item/natural/dirtclod/sand/S in T_sand)
				sandcount++
				sands += S
			if(sandcount >= 5)
				for(var/obj/item/I_sand in sands)
					qdel(I_sand)
				qdel(src)
				new /obj/structure/fluff/sandpile(T_sand)
		return
	if(isturf(loc))
		var/turf/T = loc
		for(var/obj/structure/fluff/clodpile/C in T)
			C.dirtamt = min(C.dirtamt+1, 5)
			qdel(src)
			return
		var/dirtcount = 1
		var/list/dirts = list()
		for(var/obj/item/natural/dirtclod/D in T)
			dirtcount++
			dirts += D
		if(dirtcount >=5)
			for(var/obj/item/I in dirts)
				qdel(I)
			qdel(src)
			new /obj/structure/fluff/clodpile(T)

/obj/item/natural/dirtclod/attack_self(mob/living/user)
	user.visible_message(span_warning("[user] scatters [src]."))
	qdel(src)

/obj/item/natural/dirtclod/Initialize(mapload)
	icon_state = "clod[rand(1,2)]"
	..()
	var/static/list/slapcraft_recipe_list = list(
		/datum/crafting_recipe/roguetown/survival/wickercloak,
		)

	AddElement(
		/datum/element/slapcrafting,\
		slapcraft_recipes = slapcraft_recipe_list,\
		)

/obj/structure/fluff/clodpile
	name = "dirt pile"
	desc = "A pile of dirt."
	icon_state = "clodpile"
	var/dirtamt = 5
	icon = 'icons/roguetown/items/natural.dmi'
	climbable = FALSE
	density = FALSE
	climb_offset = 10

/obj/structure/fluff/clodpile/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/rogueweapon/shovel))
		var/obj/item/rogueweapon/shovel/S = W
		if(user.used_intent.type == /datum/intent/shovelscoop)
			if(!S.heldclod)
				playsound(loc,'sound/items/dig_shovel.ogg', 100, TRUE)
				var/obj/item/J = new /obj/item/natural/dirtclod(S)
				S.heldclod = J
				W.update_icon()
				dirtamt--
				if(dirtamt <= 0)
					qdel(src)
				return
			else
				playsound(loc,'sound/items/empty_shovel.ogg', 100, TRUE)
				var/obj/item/I = S.heldclod
				S.heldclod = null
				qdel(I)
				W.update_icon()
				dirtamt++
				if(dirtamt > 5)
					dirtamt = 5
				return
	..()

/obj/structure/fluff/clodpile/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	..()

/obj/structure/fluff/sandpile
	name = "sand pile"
	desc = "A pile of loose sand."
	icon_state = "sandpile"
	var/sandamt = 5
	icon = 'icons/roguetown/items/natural.dmi'
	climbable = FALSE
	density = FALSE
	climb_offset = 10

/obj/structure/fluff/sandpile/attackby(obj/item/W, mob/user, params)
	if(istype(W, /obj/item/rogueweapon/shovel))
		var/obj/item/rogueweapon/shovel/S = W
		if(user.used_intent.type == /datum/intent/shovelscoop)
			if(!S.heldclod)
				playsound(loc,'sound/items/dig_shovel.ogg', 100, TRUE)
				var/obj/item/J = new /obj/item/natural/dirtclod/sand(S)
				S.heldclod = J
				W.update_icon()
				sandamt--
				if(sandamt <= 0)
					qdel(src)
				return
			else
				playsound(loc,'sound/items/empty_shovel.ogg', 100, TRUE)
				var/obj/item/I = S.heldclod
				if(!istype(I, /obj/item/natural/dirtclod/sand))
					return ..()
				S.heldclod = null
				qdel(I)
				W.update_icon()
				sandamt++
				if(sandamt > 5)
					sandamt = 5
				return
	..()

/obj/structure/fluff/sandpile/Initialize(mapload)
	dir = pick(GLOB.cardinals)
	..()
