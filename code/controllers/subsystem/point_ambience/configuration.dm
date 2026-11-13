/**
 * Loads point-ambience settings before live servicing begins.
 *
 * Map initialization may already have registered sources, so configured category silencing must
 * unregister existing entries as well as reject future registrations. Initial fallback setup also
 * runs here because it creates a separate timer loop for every eligible source.
 */
/datum/controller/subsystem/point_ambience/proc/seed_settings()
	PRIVATE_PROC(TRUE)
	settings_seeded = TRUE
	move_service_interval = CONFIG_GET(number/point_ambience_move_interval)
	move_service_interval_running_override = CONFIG_GET(number/point_ambience_move_interval_running_override)
	move_service_steps = CONFIG_GET(number/point_ambience_move_steps)
	speed_cutoff = CONFIG_GET(number/point_ambience_speed_cutoff)
	max_services_per_tick = CONFIG_GET(number/point_ambience_max_services_per_tick)
	use_queue = CONFIG_GET(number/point_ambience_queue)
	standing_skip = CONFIG_GET(number/point_ambience_standing_skip)
	set_falloff_hardness(CONFIG_GET(number/point_ambience_falloff_hardness))
	pan_depth_floor = CONFIG_GET(number/point_ambience_pan_depth_floor)
	set_mode(CONFIG_GET(number/point_ambience_mode))
	var/list/silenced_names = CONFIG_GET(keyed_list/silence_point_ambience)
	var/any_silenced = FALSE
	for(var/datum/point_ambience_category/category as anything in categories)
		category.silenced = !!silenced_names[category.config_name]
		if(category.silenced)
			any_silenced = TRUE
	if(any_silenced)
		begin_bulk_source_update("config silencing")
		// Copied because unregister_source mutates the list it walks
		for(var/atom/source as anything in source_categories.Copy())
			var/datum/point_ambience_category/category = source_categories[source]
			if(category?.silenced)
				unregister_source(source, category.type)
		end_bulk_source_update()
	refresh_audible_mask()
	static_version++

/datum/controller/subsystem/point_ambience/vv_edit_var(var_name, var_value)
	var/old_mode = mode
	. = ..()
	if(!.)
		return
	switch(var_name)
		// Let set_mode() compare against the old mode before changing playback
		if("mode")
			var/new_mode = mode
			mode = old_mode
			set_mode(new_mode)
		if("pan_depth_floor")
			invalidate_listener_cache()
		// Door policy invalidates listener selections. Shared rankings contain no occlusion state
		if("door_mode")
			invalidate_listener_cache()
			if(door_mode == SOUND_DOORS_NONE)
				changed_doors.Cut()
		if("door_recheck")
			if(!door_recheck)
				changed_doors.Cut()
		if("falloff_hardness")
			set_falloff_hardness(var_value)
		if("send_cutoff")
			set_send_cutoff(var_value)
		if("use_tile_cache", "verify_tile_cache", "max_range")
			clear_tile_cache()
/**
 * Switches mode, silencing what the old one had playing and starting what the new one needs.
 *
 * The index keeps updating in every mode, so switching back is immediate.
 *
 * Arguments:
 * * new_mode - POINT_AMBIENCE_LIVE, POINT_AMBIENCE_FALLBACK or POINT_AMBIENCE_OFF
 */
/datum/controller/subsystem/point_ambience/proc/set_mode(new_mode)
	if(new_mode == mode)
		return
	clear_tile_cache()
	var/old_mode = mode
	mode = new_mode
	if(old_mode == POINT_AMBIENCE_LIVE)
		finish_fades()
		for(var/client/listener_client as anything in GLOB.clients)
			stop_all_for(listener_client)
		dirty_clients.Cut()
	if(old_mode == POINT_AMBIENCE_FALLBACK)
		for(var/atom/source as anything in fallback_loops)
			qdel(fallback_loops[source])
		fallback_loops = list()
	if(mode == POINT_AMBIENCE_FALLBACK)
		for(var/atom/source as anything in source_categories)
			start_fallback(source)

/// Per-source fallback loop using its category's file, volume, pitch and range. Replays at each
/// file boundary
/datum/looping_sound/point_ambience_fallback

/// Gives one source its fallback loop, if its category takes one and it has none already
/datum/controller/subsystem/point_ambience/proc/start_fallback(atom/source)
	PRIVATE_PROC(TRUE)
	var/datum/point_ambience_category/category = source_categories[source]
	if(!category?.fallback || fallback_loops[source])
		return
	// A category with a set of clips gets one of them. The plain loop cannot advance through a set
	var/sound_file = category.source_sounds[source] || (category.files ? pick(category.files) : category.sound_file)
	var/datum/looping_sound/point_ambience_fallback/loop = new(source)
	loop.mid_sounds = sound_file
	loop.volume = category.volume * (category.source_volumes[source] || 1)
	loop.vary = category.vary_pitch
	// playsound's reach is SOUND_RANGE + extra_range
	loop.extra_range = category.range - SOUND_RANGE
	loop.mid_length = SSsounds.get_sound_length(sound_file) || 35
	fallback_loops[source] = loop
	loop.start()

/// Ends and forgets one source's fallback loop
/datum/controller/subsystem/point_ambience/proc/stop_fallback(atom/source)
	PRIVATE_PROC(TRUE)
	var/datum/looping_sound/loop = fallback_loops[source]
	if(!loop)
		return
	fallback_loops -= source
	qdel(loop)

/**
 * Changes the minimum transmitted volume and refreshes listener mute eligibility.
 *
 * Cached selections are invalidated. A listener becomes muted if even the loudest source cannot
 * reach the new cutoff at their effective volume.
 */
/datum/controller/subsystem/point_ambience/proc/set_send_cutoff(value)
	send_cutoff = clamp(value, 0, 100)
	invalidate_listener_cache()
	for(var/client/listener_client as anything in GLOB.clients)
		listener_prefs_changed(listener_client)

/**
 * Updates decay hardness for every unpinned category and invalidates listener caches.
 *
 * Null restores category defaults. Derived curve values are stored on each category and used on the
 * next send.
 */
/datum/controller/subsystem/point_ambience/proc/set_falloff_hardness(value)
	falloff_hardness = value
	for(var/datum/point_ambience_category/category as anything in categories)
		if(category.hardness_pinned)
			continue
		category.falloff_hardness = isnull(value) ? initial(category.falloff_hardness) : value
		category.resolve_derived()
	invalidate_listener_cache()
