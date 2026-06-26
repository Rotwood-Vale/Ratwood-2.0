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
	var/dismantle_dir
	var/obj/item/refund_material = /obj/item/natural/cloth

/obj/structure/roguetent/update_icon()
	icon_state = density ? "[base_state][pick("1","2")]" : "[base_state]0"
	return ..()

/obj/structure/roguetent/OnCrafted(dirin, mob/user)
	. = ..()
	if(user)
		dismantle_dir = get_dir(src, get_turf(user))

/obj/structure/roguetent/ShiftClick(mob/user)
	if(!parent_tent || !parent_tent.assembled)
		return try_dismantle(user)
	
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

/obj/structure/roguetent/proc/try_dismantle(mob/user)
	if(!dismantle_dir)
		dismantle_dir = get_dir(src, get_turf(user))
	if(get_dist(user, src) > 1 || get_dir(src, get_turf(user)) != dismantle_dir)
		to_chat(user, span_warning("I can only take this flap down from the side it was built on."))
		return TRUE
	if(alert(user, "Take down this tent flap?", "Dismantle", "Yes", "No") != "Yes")
		return TRUE
	if(get_dist(user, src) > 1 || get_dir(src, get_turf(user)) != dismantle_dir)
		return TRUE
	user.visible_message(span_notice("[user] begins taking down [src]."))
	if(!do_after(user, 4 SECONDS, target = src))
		return TRUE
	new /obj/item/grown/log/tree/stick(get_turf(user))
	new refund_material(get_turf(user))
	qdel(src)
	return TRUE

/obj/structure/roguetent/leather
	color = "#7a4a2b"
	refund_material = /obj/item/natural/hide/cured

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
