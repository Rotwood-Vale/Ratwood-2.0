/obj/structure/roguetent
	parent_type = /obj/structure/tent_component
	name = "tent flap"
	icon = 'icons/turf/roguewall.dmi'
	icon_state = "tent_door1"
	layer = WALL_OBJ_LAYER
	plane = GAME_PLANE
	density = TRUE
	opacity = TRUE
	var/base_state = "tent_door"

/obj/structure/roguetent/update_icon()
	icon_state = density ? "[base_state][pick("1","2")]" : "[base_state]0"
	return ..()

/obj/structure/roguetent/ShiftClick(mob/user)
	if(!parent_tent || !parent_tent.assembled) return ..()
	
	var/turf/T = get_turf(user)
	if(!T || !T.pseudo_roof)
		to_chat(user, span_warning("You can only dismantle the tent from the inside!"))
		return TRUE

	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("You are too far away!"))
		return TRUE

	var/confirm = alert(user, "Are you sure you want to pack up the [parent_tent.name]?", "Dismantle", "Yes", "No")
	if(confirm == "Yes" && get_dist(user, src) <= 1)
		parent_tent.disassemble_tent(user)
	return TRUE

/obj/structure/roguetent/proc/open_up(mob/user)
	visible_message(span_info("[user] opens [src]."))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = FALSE
	opacity = FALSE
	update_icon()

/obj/structure/roguetent/proc/close_up(mob/user)
	visible_message(span_info("[user] closes [src]."))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = TRUE
	opacity = TRUE
	update_icon()

/obj/structure/roguetent/attack_paw(mob/living/user)
	attack_hand(user)

/obj/structure/roguetent/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!density)
		close_up(user)
	else
		open_up(user)
