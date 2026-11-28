// Where each limb sits on each species' body sprite, for drawing lodged arrows. Measured from the sprites once, at server
// start: reading pixels is far too slow to do mid-round, so during play this is a lookup only.

/// "[body icon]|[zone]" => list(SOUTH, NORTH, EAST, WEST) of list(left, right, y), or null for a facing with nothing to measure.
GLOBAL_LIST_INIT(embedded_arrow_limb_bounds, measure_species_body_sprites())

/// list(left, right, y) for where `zone` sits on body sprite `body_icon` while facing `facing`, or null if it wasn't measured.
/// Image coordinates: y counts down from the top of the 32x32 sprite, right is the first clear column.
/proc/embedded_arrow_limb_bounds(body_icon, zone, facing)
	var/list/by_facing = GLOB.embedded_arrow_limb_bounds["[body_icon]|[zone]"]
	if(!by_facing)
		return null
	switch(facing)
		if(NORTH)
			return by_facing[2]
		if(EAST)
			return by_facing[3]
		if(WEST)
			return by_facing[4]
	return by_facing[1]

/// Measures the limbs of every species' body sprites. Only whole 32x32 humanoid bodies with a state per limb are measured,
/// so wildshapes, werewolves and taur bodies get nothing. A limb hidden in a facing borrows the chest (arms) or the other leg.
/proc/measure_species_body_sprites()
	var/list/body_icons = list()
	for(var/species_type in subtypesof(/datum/species))
		var/datum/species/species = species_type
		for(var/body_icon in list(initial(species.limbs_icon_m), initial(species.limbs_icon_f)))
			if(body_icon)
				body_icons |= body_icon

	var/list/zones = list(BODY_ZONE_HEAD, BODY_ZONE_CHEST, BODY_ZONE_R_ARM, BODY_ZONE_L_ARM, BODY_ZONE_R_LEG, BODY_ZONE_L_LEG)
	var/list/stand_ins = list(
		BODY_ZONE_R_ARM = BODY_ZONE_CHEST,
		BODY_ZONE_L_ARM = BODY_ZONE_CHEST,
		BODY_ZONE_R_LEG = BODY_ZONE_L_LEG,
		BODY_ZONE_L_LEG = BODY_ZONE_R_LEG,
	)
	var/list/bounds = list()
	for(var/body_icon in body_icons)
		var/list/states = icon_states(body_icon)
		if(!(BODY_ZONE_HEAD in states) || !(BODY_ZONE_CHEST in states))
			continue
		var/icon/chest = icon(body_icon, BODY_ZONE_CHEST, SOUTH, 1)
		if(chest.Width() != 32 || chest.Height() != 32)
			continue
		for(var/zone in zones)
			var/list/by_facing = list()
			var/found = FALSE
			for(var/facing in list(SOUTH, NORTH, EAST, WEST))
				var/list/limb = measure_body_sprite_limb(body_icon, states, zone, facing)
				if(!limb && stand_ins[zone])
					limb = measure_body_sprite_limb(body_icon, states, stand_ins[zone], facing)
				by_facing += list(limb)
				if(limb)
					found = TRUE
			if(found)
				bounds["[body_icon]|[zone]"] = by_facing
	return bounds

/// list(left, right, y) around the opaque pixels of `zone`'s state on `body_icon` facing `facing`, or null if there are none.
/// The chest is drawn on its upper part, which reads better than the belly. Other limbs are drawn at their middle.
/proc/measure_body_sprite_limb(body_icon, list/states, zone, facing)
	if(!(zone in states))
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
