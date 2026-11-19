/**
 * Restores source indexing and live settings after subsystem replacement.
 *
 * Existing emitters may not register again until their state changes. Retain their buckets, remap
 * category references to the new singletons and rebuild source counts. Listener playback is stopped
 * through the old categories and refreshed against the replacement.
 */
/datum/controller/subsystem/point_ambience/Recover()
	var/datum/controller/subsystem/point_ambience/old = SSpoint_ambience
	// An open bulk update is not carried. This flush and the stops in reset_listener_state cover
	// all it deferred
	old.clear_tile_cache()
	// Finish fades before replacing their categories and clearing the old slots
	old.finish_fades()
	reset_listener_state(old)
	carry_settings(old)
	buckets_by_z = old.buckets_by_z
	cell_stride = old.cell_stride
	source_keys = old.source_keys
	source_turfs = old.source_turfs
	// Discard pending requests. The standing sweep refreshes listeners against the replacement
	// subsystem
	fallback_loops = old.fallback_loops
	source_zs = old.source_zs
	// Reuse the completed fill. Initialize() builds it only when none exists
	river_fill = old.river_fill
	static_version = old.static_version + 1
	recount_sources(old)
	carry_category_tuning(old)
	refresh_audible_mask()
	// The buckets carry each source's category as its index into categories, which the new datums
	// were built with in the same subtypesof order, so the copied buckets stay right
	refresh_category_ranges()

/// Stops every client's playback through the old categories and clears what each one cached, so
/// its first service against the new datum walks afresh
/datum/controller/subsystem/point_ambience/proc/reset_listener_state(datum/controller/subsystem/point_ambience/old)
	PRIVATE_PROC(TRUE)
	// Stop through the old keys before playback is rebuilt against the replacement categories
	for(var/client/listener_client as anything in GLOB.clients)
		old.stop_all_for(listener_client)
		listener_client.point_ambience.profile_until = 0
		listener_client.point_ambience.next_service = 0
		listener_client.point_ambience.last_service = world.time - old.standing_skip
		listener_client.point_ambience.speed_moved = null
		listener_client.point_ambience.speed_silenced = FALSE
		listener_client.point_ambience.jump_next = 0

/// Every setting the config, the Mode verb or VV can change, so a rebuild keeps what was chosen
/datum/controller/subsystem/point_ambience/proc/carry_settings(datum/controller/subsystem/point_ambience/old)
	PRIVATE_PROC(TRUE)
	// Carried WITH settings_seeded, or the first fire() reads config over the top of them
	settings_seeded = old.settings_seeded
	mode = old.mode
	move_service_interval = old.move_service_interval
	move_service_interval_running_override = old.move_service_interval_running_override
	move_service_steps = old.move_service_steps
	speed_cutoff = old.speed_cutoff
	natural_run_step = old.natural_run_step
	max_services_per_tick = old.max_services_per_tick
	use_queue = old.use_queue
	use_tile_cache = old.use_tile_cache
	verify_tile_cache = old.verify_tile_cache
	standing_skip = old.standing_skip
	standing_walk_interval = old.standing_walk_interval
	clip_coalesce_window = old.clip_coalesce_window
	door_mode = old.door_mode
	door_recheck = old.door_recheck
	door_recheck_period = old.door_recheck_period
	send_cutoff = old.send_cutoff
	falloff_hardness = old.falloff_hardness
	pan_depth_floor = old.pan_depth_floor
	fade_steps = old.fade_steps
	fade_in_steps = old.fade_in_steps
	fade_ratio = old.fade_ratio
	fade_skip = old.fade_skip
	fade_budget = old.fade_budget
	voice_pitch = old.voice_pitch
	voice_offset = old.voice_offset

/// Points every indexed source at its replacement category and rebuilds the tallies from them
/datum/controller/subsystem/point_ambience/proc/recount_sources(datum/controller/subsystem/point_ambience/old)
	PRIVATE_PROC(TRUE)
	for(var/atom/source as anything in old.source_categories)
		var/datum/point_ambience_category/old_category = old.source_categories[source]
		var/datum/point_ambience_category/category = old_category ? categories_by_path[old_category.type] : null
		if(!category)
			continue
		source_categories[source] = category
		increment_source_count(category)

/// Copies each category's live tuning and per source overrides onto its replacement
/datum/controller/subsystem/point_ambience/proc/carry_category_tuning(datum/controller/subsystem/point_ambience/old)
	PRIVATE_PROC(TRUE)
	for(var/datum/point_ambience_category/old_category as anything in old.categories)
		var/datum/point_ambience_category/category = categories_by_path[old_category.type]
		if(!category)
			continue
		category.silenced = old_category.silenced
		category.range = old_category.range
		category.falloff_hardness = old_category.falloff_hardness
		if(category == river_category)
			category.falloff_exponent = old_category.falloff_exponent
		category.min_volume = old_category.min_volume
		category.floor_ratio = old_category.floor_ratio
		category.volume = old_category.volume
		category.indoor_volume = old_category.indoor_volume
		loudest_volume = max(loudest_volume, category.volume)
		category.hardness_pinned = old_category.hardness_pinned
		category.occlude = old_category.occlude
		category.centre_handoff = old_category.centre_handoff
		category.resolve_derived()
		for(var/overridden in old_category.source_volumes)
			loudest_volume = max(loudest_volume, category.volume * old_category.source_volumes[overridden])
		category.source_sounds = old_category.source_sounds
		category.source_volumes = old_category.source_volumes
		category.source_base_volumes = old_category.source_base_volumes
		category.files = old_category.files
