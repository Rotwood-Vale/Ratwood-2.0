//This file describes functionality of a fake wall (or a false wall, as they were described in TG)
//This wall however reacts to a message
/obj/structure/falsewall
	plane = WALL_PLANE
	density = TRUE
	opacity = TRUE
	smooth = SMOOTH_MORE
	smooth_diag = FALSE
	climbable = FALSE
	can_be_unanchored = FALSE
	layer = 2.05
	var/smooth_icon = null
	var/in_motion = FALSE
	var/original_layer = 2.05
	var/slide_direction = null
	var/slide_distance = 24
	var/open_message = ""
	var/close_message = ""
	var/is_closed = TRUE

/obj/structure/falsewall/stone
	name = "stone wall"
	desc = "A wall of smooth unyielding stone."
	icon = 'icons/turf/walls/stone_wall.dmi'
	icon_state = "stone"
	max_integrity = 1800
	break_sound = 'sound/combat/hits/onstone/stonedeath.ogg'
	attacked_sound = list('sound/combat/hits/onstone/wallhit.ogg', 'sound/combat/hits/onstone/wallhit2.ogg', 'sound/combat/hits/onstone/wallhit3.ogg')
	canSmoothWith = list(/obj/structure/falsewall/stone, /turf/closed/wall/mineral/rogue/stone)
	var/fake_icon = 'icons/turf/walls/wall.dmi'
	var/mineral_amount = 2
	var/walltype = /turf/closed/wall
	var/opening = FALSE
	damage_deflection = 10

/obj/structure/falsewall/Initialize()
	. = ..()
	if(smooth_icon)
		icon = smooth_icon
	find_smoothing_dir()
	become_hearing_sensitive()

/obj/structure/falsewall/proc/find_smoothing_dir()
	for (var/direction in GLOB.cardinals)
		for(var/allowed_type in canSmoothWith)
			if (allowed_type == src.type)
				continue
			if (find_type_in_direction(src, direction))
				slide_direction = direction
				return

/obj/structure/falsewall/proc/open()
	if(QDELETED(src) || in_motion || !is_closed)
		return
	in_motion = TRUE
	density = FALSE
	opacity = FALSE
	if (isnull(slide_direction))
		animate(src, transform = matrix().Scale(1, 0.1), pixel_y = -14, time = 5)
		spawn(6)
			in_motion = FALSE
			is_closed = FALSE
	else
		layer = layer - 0.01
		var/target_x = pixel_x
		var/target_y = pixel_y
		switch(slide_direction)
			if(NORTH)
				target_y += slide_distance
			if(SOUTH)
				target_y -= slide_distance
			if(EAST)
				target_x += slide_distance
			if(WEST)
				target_x -= slide_distance
		animate(src, pixel_x = target_x, pixel_y = target_y, time = 5)
		spawn(6)
			in_motion = FALSE
			is_closed = FALSE
			update_icon()


/obj/structure/falsewall/proc/close()
	if(QDELETED(src) || in_motion || is_closed)
		return
	in_motion = TRUE
	if(isnull(slide_direction))
		animate(src, transform = matrix().Scale(1, 1), pixel_y = 0, time = 5)
		spawn(6)
			density = TRUE
			opacity = TRUE
			in_motion = FALSE
			is_closed = TRUE
	else
		animate(src, pixel_x = 0, pixel_y = 0, time = 5)
		spawn(6)
			density = TRUE
			opacity = TRUE
			layer = original_layer
			in_motion = FALSE
			is_closed = TRUE
			update_icon()


/obj/structure/falsewall/Hear(message, atom/movable/speaker, message_language, raw_message, radio_freq, list/spans, message_mode)
	. = ..()
	if(speaker == src)
		return
	if(obj_broken)
		return
	if(!ishuman(speaker))
		return
	if(open_message != "" && findtext(message, open_message))
		open()
	if(close_message != "" && findtext(message, close_message))
		close()

/obj/structure/falsewall/handle_mouseover(location, control, params)
	.=..()
	usr.client.mouseovertext.maptext = {"<span style='font-size:8pt;font-family:"Pterra";color:#607d65;text-shadow:0 0 10px #fff, 0 0 20px #fff, 0 0 30px #e60073, 0 0 40px #e60073, 0 0 50px #e60073, 0 0 60px #e60073, 0 0 70px #e60073;' class='center maptext '>[name]"}
	return
