//Chain link fences
//Sprites ported from /VG/


#define CUT_TIME 100
#define CLIMB_TIME 150

#define NO_HOLE 0 //section is intact
#define MEDIUM_HOLE 1 //medium hole in the section - can climb through
#define LARGE_HOLE 2 //large hole in the section - can walk through
#define MAX_HOLE_SIZE LARGE_HOLE

/obj/structure/fence
	name = "栅栏"
	desc = ""
	density = TRUE
	anchored = TRUE

	icon_state = "straight"

	var/cuttable = TRUE
	var/hole_size= NO_HOLE
	var/invulnerable = FALSE

/obj/structure/fence/Initialize(mapload)
	. = ..()

	update_cut_status()

/obj/structure/fence/examine(mob/user)
	. = ..()

	switch(hole_size)
		if(MEDIUM_HOLE)
			. += "[src]上有一个大洞。"
		if(LARGE_HOLE)
			. += "[src]已经被彻底剪穿了。"

/obj/structure/fence/end
	icon_state = "end"
	cuttable = FALSE

/obj/structure/fence/corner
	icon_state = "corner"
	cuttable = FALSE

/obj/structure/fence/post
	icon_state = "post"
	cuttable = FALSE

/obj/structure/fence/cut/medium
	icon_state = "straight_cut2"
	hole_size = MEDIUM_HOLE

/obj/structure/fence/cut/large
	icon_state = "straight_cut3"
	hole_size = LARGE_HOLE

/obj/structure/fence/attackby(obj/item/W, mob/user)
	if(W.tool_behaviour == TOOL_WIRECUTTER)
		if(!cuttable)
			to_chat(user, span_warning("这段栅栏没法剪开！"))
			return
		if(invulnerable)
			to_chat(user, span_warning("这道栅栏太坚固了，切不开！"))
			return
		var/current_stage = hole_size
		if(current_stage >= MAX_HOLE_SIZE)
			to_chat(user, span_warning("这道栅栏已经被剪开太多了！"))
			return

		user.visible_message(span_danger("[user]开始用[W]剪开[src]。"),\
		span_danger("我开始用[W]剪开[src]。"))

		if(do_after(user, CUT_TIME*W.toolspeed, target = src))
			if(current_stage == hole_size)
				switch(++hole_size)
					if(MEDIUM_HOLE)
						visible_message(span_notice("[user]又把[src]剪开了一些。"))
						to_chat(user, span_info("现在这个洞我大概能钻过去了。不过要是再大一点，翻过去会快得多。"))
						set_climbable(TRUE)
					if(LARGE_HOLE)
						visible_message(span_notice("[user]把[src]彻底剪穿了。"))
						to_chat(user, span_info("[src]上的洞现在已经大到可以直接走过去了。"))
						set_climbable(FALSE)

				update_cut_status()

	return TRUE

/obj/structure/fence/proc/update_cut_status()
	if(!cuttable)
		return
	density = TRUE
	switch(hole_size)
		if(NO_HOLE)
			icon_state = initial(icon_state)
		if(MEDIUM_HOLE)
			icon_state = "straight_cut2"
		if(LARGE_HOLE)
			icon_state = "straight_cut3"
			density = FALSE

//FENCE DOORS

/obj/structure/fence/door
	name = "栅栏门"
	desc = ""
	icon_state = "door_closed"
	cuttable = FALSE
	var/open = FALSE

/obj/structure/fence/door/Initialize(mapload)
	. = ..()

	update_door_status()

/obj/structure/fence/door/opened
	icon_state = "door_opened"
	open = TRUE
	density = TRUE

/obj/structure/fence/door/attack_hand(mob/user)
	if(can_open(user))
		toggle(user)

	return TRUE

/obj/structure/fence/door/proc/toggle(mob/user)
	switch(open)
		if(FALSE)
			visible_message(span_notice("[user]打开了[src]。"))
			open = TRUE
		if(TRUE)
			visible_message(span_notice("[user]关上了[src]。"))
			open = FALSE

	update_door_status()
	playsound(src, 'sound/blank.ogg', 100, TRUE)

/obj/structure/fence/door/proc/update_door_status()
	switch(open)
		if(FALSE)
			density = TRUE
			icon_state = "door_closed"
		if(TRUE)
			density = FALSE
			icon_state = "door_opened"

/obj/structure/fence/door/proc/can_open(mob/user)
	return TRUE

#undef CUT_TIME
#undef CLIMB_TIME

#undef NO_HOLE
#undef MEDIUM_HOLE
#undef LARGE_HOLE
#undef MAX_HOLE_SIZE
