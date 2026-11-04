/proc/getviewsize(view = world.view)
	SHOULD_BE_PURE(TRUE)

	if(isnum(view))
		//resetting back to 0- this is the same as just checking !view but we want to be clear the point of the check.
		if(view == 0)
			return list(0, 0)
		var/totalviewrange = (view < 0 ? -1 : 1) + 2 * view
		return list(totalviewrange, totalviewrange)
	else
		var/list/viewrangelist = splittext(view, "x")
		return list(text2num(viewrangelist[1]), text2num(viewrangelist[2]))

/proc/in_view_range(mob/user, atom/A)
	var/list/view_range = getviewsize(user.client.view)
	var/turf/source = get_turf(user)
	var/turf/target = get_turf(A)
	return ISINRANGE(target.x, source.x - view_range[1], source.x + view_range[1]) && ISINRANGE(target.y, source.y - view_range[1], source.y + view_range[1])

/// Takes a string or num view, and converts it to pixel width/height in a list(pixel_width, pixel_height)
/proc/view_to_pixels(view)
	if(!view)
		return list(0, 0)
	var/list/view_info = getviewsize(view)
	view_info[1] *= ICON_SIZE_X
	view_info[2] *= ICON_SIZE_Y
	return view_info
