/obj/structure/roguetent
	parent_type = /obj/structure/tent_component
	name = "帐篷门帘"
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
		to_chat(user, span_warning("只能从帐篷里面拆掉它！"))
		return TRUE

	if(get_dist(user, src) > 1)
		to_chat(user, span_warning("我离得太远了！"))
		return TRUE

	var/confirm = alert(user, "你确定要收起[parent_tent.name]吗？", "拆除", "是", "否")
	if(confirm == "是" && get_dist(user, src) <= 1)
		parent_tent.disassemble_tent(user)
	return TRUE

/obj/structure/roguetent/proc/open_up(mob/user)
	visible_message(span_info("[user]打开了[src]。"))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = FALSE
	opacity = FALSE
	update_icon()

/obj/structure/roguetent/proc/close_up(mob/user)
	visible_message(span_info("[user]关上了[src]。"))
	playsound(src, 'sound/foley/equip/rummaging-02.ogg', 100, FALSE)
	density = TRUE
	opacity = TRUE
	update_icon()

/obj/structure/roguetent/attack_hand(mob/living/user)
	. = ..()
	if(.)
		return
	if(!density)
		close_up(user)
	else
		open_up(user)
