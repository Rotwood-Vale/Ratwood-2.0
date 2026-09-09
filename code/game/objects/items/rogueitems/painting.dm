
/obj/item/rogue/painting
	name = "painting"
	icon_state = "painting"
	desc = ""
	w_class = WEIGHT_CLASS_NORMAL
	static_price = TRUE
	sellprice = 100
	icon = 'icons/roguetown/items/misc.dmi'
	var/deployed_structure = /obj/structure/fluff/walldeco/painting

/obj/item/rogue/painting/attack_turf(turf/T, mob/living/user)
	if(isclosedturf(T))
		if(get_dir(T,user) in GLOB.cardinals)
			to_chat(user, span_warning("I place [src] on the wall."))
			var/obj/structure/S = new deployed_structure(user.loc)
			switch(get_dir(T,user))
				if(NORTH)
					S.pixel_y = -32
				if(SOUTH)
					S.pixel_y = 32
				if(WEST)
					S.pixel_x = 32
				if(EAST)
					S.pixel_x = -32
			qdel(src)
			return
	..()

/obj/structure/fluff/walldeco/painting
	name = "vague painting"
	desc = "The artist is unknown. The subject is unknown. Maybe a memorial to a corpse that was trampled on the trail to this reality."
	icon = 'icons/roguetown/items/misc.dmi'
	icon_state = "painting_deployed"
	anchored = TRUE
	density = FALSE
	max_integrity = 0
	layer = ABOVE_MOB_LAYER
	var/stolen_painting = /obj/item/rogue/painting

/obj/structure/fluff/walldeco/painting/attack_hand(mob/user)
	if(do_after(user, 30, target = src))
		var/obj/item/I = new stolen_painting(user.loc)
		user.put_in_hands(I)
		qdel(src)
		return
	..()

/obj/structure/fluff/walldeco/painting/queen
	name = "queen alexia painting"
	desc = "It's Queen Alexia I 'the Righteous' Valmont of Ferentia. Twenty years ago she rebelled against her father, King Mattimeo, and had him burned on a cross for heresy after he was seduced by a Baothan succubus."
	icon_state = "queenpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/queen

/obj/item/rogue/painting/queen
	icon_state = "queenpainting"
	name = "queen alexia painting"
	desc = "It's Queen Alexia I 'the Righteous' Valmont of Ferentia. Twenty years ago she rebelled against her father, King Mattimeo, and had him burned on a cross for heresy after he was seduced by a Baothan succubus. These mass-reproduced paintings are devalued."
	dropshrink = 0.5
	sellprice = 200
	deployed_structure = /obj/structure/fluff/walldeco/painting/queen

/obj/item/rogue/painting/seraphina
	icon_state = "seraphinapainting"
	name = "holy priest seraphina painting"
	desc = "The holy priest Seraphina, first leader of the Sun Cult of Astrata, who unified the ten sects of the gods after the disappearance of PSYDON. Seen as the great unifier of faith as the Age of Rot began a thousand years past."
	dropshrink = 0.5
	sellprice = 200
	deployed_structure = /obj/structure/fluff/walldeco/painting/seraphina

/obj/structure/fluff/walldeco/painting/seraphina
	name = "holy priest seraphina painting"
	desc = "The holy priest Seraphina, first leader of the Sun Cult of Astrata, who unified the ten sects of the gods after the disappearance of PSYDON. Seen as the great unifier of faith as the Age of Rot began a thousand years past."
	icon_state = "seraphinapainting_deployed"
	stolen_painting = /obj/item/rogue/painting/seraphina

/obj/item/rogue/painting/skullzhg
	icon_state = "skullpainting"
	name = "morbid painting"
	desc = "A painting of a candelabra and human skull on a covered table, it is a modestly grim yet tasteful piece of art. Memento mori."
	sellprice = 200
	deployed_structure = /obj/structure/fluff/walldeco/painting/skull

/obj/structure/fluff/walldeco/painting/skull
	name = "morbid painting"
	desc = "A painting of a candelabra and human skull on a covered table, it is a modestly grim yet tasteful piece of art. Memento mori."
	icon_state = "skullpainting_deployed"
	stolen_painting = /obj/item/rogue/painting/skullzhg
