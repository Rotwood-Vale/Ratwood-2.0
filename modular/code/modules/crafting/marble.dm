#define MARBLE_ICON 'icons/roguetown/misc/marble.dmi'

/obj/structure/roguetown/marble
	name = "marble structure"
	desc = "A structure carved from cold white marble."
	icon = MARBLE_ICON
	anchored = TRUE
	density = TRUE
	max_integrity = 500

/obj/structure/roguetown/marble/wall
	name = "marble wall"
	desc = "A heavy wall of white marble blocks."
	icon_state = "marblewall"
	density = TRUE
	opacity = TRUE
	max_integrity = 1200

/obj/structure/roguetown/marble/wall/alt
	icon_state = "marblewall_2"

/obj/structure/roguetown/marble/door
	name = "marble door"
	desc = "A heavy marble door."
	icon_state = "marbledoor"
	density = TRUE
	opacity = TRUE
	max_integrity = 900
	var/opened = FALSE
	var/busy = FALSE

/obj/structure/roguetown/marble/door/attack_hand(mob/user)
	. = ..()
	if(.)
		return
	toggle(user)

/obj/structure/roguetown/marble/door/verb/toggle_open()
	set name = "Open/Close"
	set category = "Object"
	set src in oview(1)
	toggle(usr)

/obj/structure/roguetown/marble/door/proc/toggle(mob/user)
	if(busy)
		return FALSE
	if(opened)
		return close(user)
	return open(user)

/obj/structure/roguetown/marble/door/proc/open(mob/user)
	if(opened || busy)
		return FALSE
	busy = TRUE
	icon_state = "marbledooropenin"
	sleep(3)
	density = FALSE
	opacity = FALSE
	opened = TRUE
	busy = FALSE
	return TRUE

/obj/structure/roguetown/marble/door/proc/close(mob/user)
	if(!opened || busy)
		return FALSE
	busy = TRUE
	icon_state = "marbledoorclosing"
	sleep(3)
	density = TRUE
	opacity = TRUE
	opened = FALSE
	icon_state = "marbledoor"
	busy = FALSE
	return TRUE

/obj/structure/roguetown/marble/stairs
	name = "marble stairs"
	desc = "A short run of worn marble stairs."
	icon_state = "marblestairs"
	density = FALSE
	opacity = FALSE
	max_integrity = 800

/obj/structure/roguetown/marble/block
	name = "marble block"
	desc = "A small block of white marble."
	icon_state = "marbleblock"
	density = TRUE
	opacity = FALSE
	max_integrity = 700

/obj/structure/roguetown/marble/table
	name = "marble table"
	desc = "A solid table carved from white marble."
	icon_state = "marbletable"
	density = TRUE
	opacity = FALSE
	max_integrity = 700

/obj/structure/roguetown/marble/table/side
	icon_state = "marbletable2"

/obj/structure/roguetown/marble/bookshelf
	name = "empty marble bookshelf"
	desc = "An empty bookshelf framed in white marble."
	icon_state = "marblebook"
	density = TRUE
	opacity = FALSE
	max_integrity = 700

/obj/structure/roguetown/marble/bed
	name = "marble bed"
	desc = "A cold bed with a white marble frame."
	icon_state = "marblebed"
	density = TRUE
	opacity = FALSE
	max_integrity = 700

#undef MARBLE_ICON
