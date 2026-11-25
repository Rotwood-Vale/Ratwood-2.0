// Where each limb sits on a humanoid body sprite, for drawing lodged arrows. Measured from the sprite itself the first
// time a limb and facing is asked for, so new or redrawn body sprites need no upkeep.

/// list(left, right, y) for where `zone` sits on body sprite `body_icon` while facing `facing`, or null if it isn't a
/// measurable body sprite. Image coordinates: y counts down from the top of the 32x32 sprite, right is the first clear
/// column. A limb hidden in a facing borrows the chest (arms) or the other leg.
/proc/embedded_arrow_limb_bounds(body_icon, zone, facing)
	var/static/list/bounds_cache = list()
	if(facing != NORTH && facing != EAST && facing != WEST)
		facing = SOUTH
	var/key = "[body_icon]|[zone]|[facing]"
	if(key in bounds_cache)
		return bounds_cache[key]

	var/list/bounds
	if(is_measurable_body_sprite(body_icon))
		bounds = measure_body_sprite_limb(body_icon, zone, facing)
		if(!bounds)
			switch(zone)
				if(BODY_ZONE_R_ARM, BODY_ZONE_L_ARM)
					bounds = measure_body_sprite_limb(body_icon, BODY_ZONE_CHEST, facing)
				if(BODY_ZONE_R_LEG)
					bounds = measure_body_sprite_limb(body_icon, BODY_ZONE_L_LEG, facing)
				if(BODY_ZONE_L_LEG)
					bounds = measure_body_sprite_limb(body_icon, BODY_ZONE_R_LEG, facing)
	bounds_cache[key] = bounds
	return bounds

/// Whether `body_icon` is a whole 32x32 humanoid body with one state per limb. Wildshapes, werewolves and taur bodies aren't.
/proc/is_measurable_body_sprite(body_icon)
	if(!icon_exists(body_icon, BODY_ZONE_HEAD) || !icon_exists(body_icon, BODY_ZONE_CHEST))
		return FALSE
	var/icon/chest = icon(body_icon, BODY_ZONE_CHEST, SOUTH, 1)
	return chest.Width() == 32 && chest.Height() == 32

/// list(left, right, y) around the opaque pixels of `zone`'s state on `body_icon` facing `facing`, or null if there are none.
/// The chest is drawn on its upper part, which reads better than the belly. Other limbs are drawn at their middle.
/proc/measure_body_sprite_limb(body_icon, zone, facing)
	if(!icon_exists(body_icon, zone))
		return null
	var/icon/sprite = icon(body_icon, zone, facing, 1)
	var/left = INFINITY
	var/right = 0
	var/top = INFINITY
	var/bottom = 0
	for(var/x in 1 to 32)
		for(var/y in 1 to 32)
			if(!sprite.GetPixel(x, y))
				continue
			var/row = 32 - y // GetPixel counts up from the bottom; these bounds count down from the top.
			left = min(left, x - 1)
			right = max(right, x)
			top = min(top, row)
			bottom = max(bottom, row + 1)
	if(!right)
		return null
	if(zone == BODY_ZONE_CHEST)
		return list(left, right, top + round((bottom - top) * 0.35, 1))
	return list(left, right, FLOOR((top + bottom - 1) / 2, 1))
