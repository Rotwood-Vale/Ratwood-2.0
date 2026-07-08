// This is a list of turf types we dont want to assign to baseturfs unless through initialization or explicitly
GLOBAL_LIST_INIT(blacklisted_automated_baseturfs, typecacheof(list(
	/turf/baseturf_bottom,
	)))

/turf/proc/empty(turf_type=/turf/open/floor/rogue/naturalstone, baseturf_type, list/ignore_typecache, flags)
	// Remove all atoms except observers, landmarks, docking ports
	var/static/list/ignored_atoms = typecacheof(list(/mob/dead, /obj/effect/landmark))
	var/list/allowed_contents = typecache_filter_list_reverse(GetAllContentsIgnoring(ignore_typecache), ignored_atoms)
	allowed_contents -= src
	for(var/i in 1 to allowed_contents.len)
		var/thing = allowed_contents[i]
		qdel(thing, force=TRUE)

	if(turf_type)
		var/turf/newT = ChangeTurf(turf_type, baseturf_type, flags)
		CALCULATE_ADJACENT_TURFS(newT)

/turf/proc/copyTurf(turf/T)
	if(T.type != type)
		var/obj/O
		if(underlays.len)	//we have underlays, which implies some sort of transparency, so we want to a snapshot of the previous turf as an underlay
			O = new()
			O.underlays.Add(T)
		T.ChangeTurf(type)
		if(underlays.len)
			T.underlays = O.underlays
	if(T.icon_state != icon_state)
		T.icon_state = icon_state
	if(T.icon != icon)
		T.icon = icon
	if(color)
		T.atom_colours = atom_colours.Copy()
		T.update_atom_colour()
	if(T.dir != dir)
		T.setDir(dir)
	return T

/turf/open/copyTurf(turf/T, copy_air = FALSE)
	. = ..()
	if (isopenturf(T))
		var/datum/component/wet_floor/slip = GetComponent(/datum/component/wet_floor)
		if(slip)
			var/datum/component/wet_floor/WF = T.AddComponent(/datum/component/wet_floor)
			WF.InheritComponent(slip)

//wrapper for ChangeTurf()s that you want to prevent/affect without overriding ChangeTurf() itself
/turf/proc/TerraformTurf(path, new_baseturf, flags)
	return ChangeTurf(path, new_baseturf, flags)

// Creates a new turf
// new_baseturfs can be either a single type or list of types, formated the same as baseturfs. see turf.dm
/turf/proc/ChangeTurf(path, list/new_baseturfs, flags)
	switch(path)
		if(null)
			return
		if(/turf/baseturf_openspace)
			// GET_TURF_BELOW can runtime on world.maxz increase if some idiot makes the world turf go through this path
			// i was gonna be nice and add bounds checking but if you're that stupid you need the runtime to warn you
			var/has_turf_below = GET_TURF_BELOW(src)
			if(has_turf_below)
				path = /turf/open/transparent/openspace
			else
				path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || /turf/open/floor/rogue/naturalstone
				if (!ispath(path))
					path = text2path(path)
					if (!ispath(path))
						warning("Z-level [z] has invalid baseturf '[SSmapping.level_trait(z, ZTRAIT_BASETURF)]'")
						path = /turf/open/floor/rogue/naturalstone
		if(/turf/baseturf_bottom)
			path = SSmapping.level_trait(z, ZTRAIT_BASETURF) || /turf/open/floor/rogue/naturalstone
			if (!ispath(path))
				path = text2path(path)
				if (!ispath(path))
					warning("Z-level [z] has invalid baseturf '[SSmapping.level_trait(z, ZTRAIT_BASETURF)]'")
					path = /turf/open/floor/rogue/naturalstone

	if(!GLOB.use_preloader && path == type && !(flags & CHANGETURF_FORCEOP) && (baseturfs == new_baseturfs)) // Don't no-op if the map loader requires it to be reconstructed
		return src
	if(flags & CHANGETURF_SKIP)
		testing("fuck3")
		return new path(src)

	var/isopenspa = FALSE
	if(istype(src, /turf/open/transparent/openspace))
		isopenspa = TRUE
	else
		if(path == /turf/open/transparent/openspace)
			isopenspa = TRUE

	var/old_opacity = opacity
	var/old_dynamic_lighting = dynamic_lighting
	var/old_lighting_object = lighting_object
	var/old_outdoor_effect = outdoor_effect
	var/old_corners = corners

	var/old_exl = explosion_level
	var/old_exi = explosion_id
	var/old_bp = blueprint_data
	blueprint_data = null

	var/oldPA = primary_area

	STOP_PROCESSING(SSweather,src)

	var/list/old_baseturfs = baseturfs

	var/list/post_change_callbacks = list()
	SEND_SIGNAL(src, COMSIG_TURF_CHANGE, path, new_baseturfs, flags, post_change_callbacks)

	changing_turf = TRUE
	qdel(src)	//Just get the side effects and call Destroy
	//We do this here so anything that doesn't want to persist can clear itself
	var/list/old_comp_lookup = comp_lookup?.Copy()
	var/list/old_signal_procs = signal_procs?.Copy()
	var/turf/W = new path(src)

	// WARNING WARNING
	// Turfs DO NOT lose their signals when they get replaced, REMEMBER THIS
	// It's possible because turfs are fucked, and if you have one in a list and it's replaced with another one, the list ref points to the new turf
	if(old_comp_lookup)
		LAZYOR(W.comp_lookup, old_comp_lookup)
	if(old_signal_procs)
		LAZYOR(W.signal_procs, old_signal_procs)

	for(var/datum/callback/callback as anything in post_change_callbacks)
		callback.InvokeAsync(W)

	if(new_baseturfs)
		W.baseturfs = baseturfs_string_list(new_baseturfs, W)
	else
		W.baseturfs = baseturfs_string_list(old_baseturfs, W) // Just to be safe


	W.explosion_id = old_exi
	W.explosion_level = old_exl

	if(!(flags & CHANGETURF_DEFER_CHANGE))
		W.AfterChange(flags)

	W.blueprint_data = old_bp

	W.primary_area = oldPA

	START_PROCESSING(SSweather,W)
	if(isopenspa)
		var/turf/belo = get_step_multiz(W, DOWN)
		for(var/x in 1 to 5)
			if(belo)
				belo.update_see_sky()
				START_PROCESSING(SSweather,belo)
				belo = get_step_multiz(belo, DOWN)
			else
				break

	if(SSlighting.initialized)
		if(SSoutdoor_effects.initialized)
			outdoor_effect = old_outdoor_effect
			outdoor_effect?.reset_applied_overlays()
			get_sky_and_weather_states()

		recalc_atom_opacity()
		lighting_object = old_lighting_object
		corners = old_corners

		if(lighting_object && !lighting_object.needs_update)
			lighting_object.update()
		else if(!lighting_object && has_dynamic_lighting())
			underlays += GLOB.lighting_underlay_dark
			luminosity = 0

		if (old_opacity != opacity || dynamic_lighting != old_dynamic_lighting)
			reconsider_lights()

		if (dynamic_lighting != old_dynamic_lighting)
			if (IS_DYNAMIC_LIGHTING(src))
				lighting_build_overlay()
			else
				lighting_clear_overlay()

	return W

/turf/open/ChangeTurf(path, list/new_baseturfs, flags) //Resist the temptation to make this default to keeping air.
	if ((flags & CHANGETURF_INHERIT_AIR) && ispath(path, /turf/open))
		. = ..()
		if (!.) // changeturf failed or didn't do anything
			return
	else
		if(ispath(path,/turf/closed))
			flags |= CHANGETURF_RECALC_ADJACENT
		return ..()

/// Take off the top layer turf and replace it with the next baseturf down
/turf/proc/ScrapeAway(amount=1, flags)
	if(!amount)
		return
	if(length(baseturfs))
		var/list/new_baseturfs = baseturfs.Copy()
		var/turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		while(ispath(turf_type, /turf/baseturf_skipover))
			amount++
			if(amount > new_baseturfs.len)
				CRASH("The bottommost baseturf of a turf is a skipover [src]([type])")
			turf_type = new_baseturfs[max(1, new_baseturfs.len - amount + 1)]
		new_baseturfs.len -= min(amount, new_baseturfs.len - 1) // No removing the very bottom
		if(new_baseturfs.len == 1)
			new_baseturfs = new_baseturfs[1]
		return ChangeTurf(turf_type, new_baseturfs, flags)

	if(baseturfs == type)
		return src

	return ChangeTurf(baseturfs, baseturfs, flags) // The bottom baseturf will never go away

// Take the input turf type and put it underneath the current baseturfs
/turf/proc/PlaceOnBottom(turf/bottom_turf)
	baseturfs = baseturfs_string_list(
		list(initial(bottom_turf.baseturfs), bottom_turf) + baseturfs,
		src
	)

/turf/proc/LoadOnTop(turf/added_turf, flags)
	var/area/turf_area = loc
	flags = turf_area.PlaceOnTopReact(list(baseturfs), added_turf, flags) // A hook so areas can modify the incoming args
	if(flags & CHANGETURF_SKIP) // We haven't been initialized
		if(flags_1 & INITIALIZED_1)
			stack_trace("CHANGETURF_SKIP was used in a PlaceOnTop call for a turf that's initialized. This is a mistake. [src]([type])")
		assemble_baseturfs()
	var/turf/newT
	if(!length(baseturfs))
		baseturfs = list(baseturfs)
	
	var/list/old_baseturfs = baseturfs.Copy()
	if(!isclosedturf(src))
		old_baseturfs += type

	newT = ChangeTurf(added_turf, null, flags)
	newT.assemble_baseturfs(initial(added_turf.baseturfs)) // The baseturfs list is created like roundstart
	if(!length(newT.baseturfs))
		newT.baseturfs = list(baseturfs)
	// The old baseturfs are put underneath, and we sort out the unwanted ones
	newT.baseturfs = baseturfs_string_list(old_baseturfs + (newT.baseturfs - GLOB.blacklisted_automated_baseturfs), newT)
	return newT

// Make a new turf and put it on top
// The args behave identical to PlaceOnBottom except they go on top
// Things placed on top of closed turfs will ignore the topmost closed turf
// Returns the new turf
/turf/proc/PlaceOnTop(turf/added_turf, flags)
	var/list/turf/new_baseturfs = list()
	new_baseturfs.Add(baseturfs)
	if(isopenturf(src))
		new_baseturfs.Add(type)
	var/area/turf_area = loc
	flags = turf_area.PlaceOnTopReact(new_baseturfs, added_turf, flags) // A hook so areas can modify the incoming args
	return ChangeTurf(added_turf, new_baseturfs, flags)

// Copy an existing turf and put it on top
// Returns the new turf
/turf/proc/CopyOnTop(turf/copytarget, ignore_bottom=1, depth=INFINITY, copy_air = FALSE)
	var/list/new_baseturfs = list()
	new_baseturfs += baseturfs
	new_baseturfs += type

	if(depth)
		var/list/target_baseturfs
		if(length(copytarget.baseturfs))
			// with default inputs this would be Copy(CLAMP(2, -INFINITY, baseturfs.len))
			// Don't forget a lower index is lower in the baseturfs stack, the bottom is baseturfs[1]
			target_baseturfs = copytarget.baseturfs.Copy(CLAMP(1 + ignore_bottom, 1 + copytarget.baseturfs.len - depth, copytarget.baseturfs.len))
		else if(!ignore_bottom)
			target_baseturfs = list(copytarget.baseturfs)
		if(target_baseturfs)
			target_baseturfs -= new_baseturfs & GLOB.blacklisted_automated_baseturfs
			new_baseturfs += target_baseturfs

	var/turf/newT = copytarget.copyTurf(src, copy_air)
	newT.baseturfs = baseturfs_string_list(new_baseturfs, newT)
	return newT


//If you modify this function, ensure it works correctly with lateloaded map templates.
/turf/proc/AfterChange(flags) //called after a turf has been replaced in ChangeTurf()
	levelupdate()
	if(flags & CHANGETURF_RECALC_ADJACENT)
		ImmediateCalculateAdjacentTurfs()
	else
		CALCULATE_ADJACENT_TURFS(src)

	queue_smooth_neighbors(src)

	HandleTurfChange(src)

/turf/open/AfterChange(flags)
	..()

/turf/proc/ReplaceWithLattice()
	ScrapeAway(flags = CHANGETURF_INHERIT_AIR)
//	new /obj/structure/lattice(locate(x, y, z))

/turf/open/proc/try_respawn_mined_chunks(chance = 150, list/weighted_rocks)
	if(!prob(chance))
		return

	var/turf/closed/mineral/random/rogue/picked = pickweight(weighted_rocks)
	GLOB.mined_resource_loc -= src

	ChangeTurf(picked)

	for(var/direction in GLOB.cardinals)
		var/turf/open/turf = get_step(src, direction)
		if(!istype(turf))
			continue
		if(!(turf in GLOB.mined_resource_loc))
			continue
		try_respawn_mined_chunks(chance-25, list(picked = 10))
		if(!prob(chance))
			return
