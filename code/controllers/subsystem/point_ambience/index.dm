/**
 * Registers an active source or updates its category, position and playback overrides.
 *
 * Moving callers must register again, including when a carrier moves a contained source. The index
 * stores coordinates but does not subscribe to carrier movement. A move invalidates old and new
 * coverage and advances static_version even within one bucket, so stationary listeners refresh
 * their volume and pan.
 *
 * Overrides are applied before the bucket update. The completed change is recorded for
 * listener-cache validation, then fallback playback starts if required. Silenced categories reject
 * registration and remove any existing entry.
 *
 * Arguments:
 * * category_path - category type path, not a category datum
 * * sound_override - source recording instead of the category default
 * * volume_scale - category-volume multiplier. 1 clears the override and null preserves it
 */
/datum/controller/subsystem/point_ambience/proc/register_source(atom/source, category_path, sound_override, volume_scale)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/point_ambience_category/category = categories_by_path[category_path]
	if(!category)
		CRASH("register_source(): [category_path] is not a point ambience category")
	if(category.silenced)
		if(source_keys[source])
			unregister_source(source, category_path)
		return
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		unregister_source(source, category_path)
		return
	var/turf/previous_turf = source_turfs[source]
	var/datum/point_ambience_category/previous_category = source_categories[source]
	var/version_before = static_version
	var/previous_range = previous_category?.range
	if(previous_turf != source_turf || previous_category != category)
		// A move or category change can alter every tile reached from either endpoint
		if(previous_turf && previous_category)
			invalidate_tile_cache(previous_turf, previous_category.range)
		invalidate_tile_cache(source_turf, category.range)
	source_turfs[source] = source_turf
	apply_source_overrides(source, category, source_turf, sound_override, volume_scale)

	if(!cell_stride)
		cell_stride = (world.maxy >> POINT_AMBIENCE_CELL_SHIFT) + 2
	var/bucket_index = POINT_AMBIENCE_CELL_INDEX(source_turf.x, source_turf.y, cell_stride)
	var/source_z = source_turf.z
	var/previous_bucket_index = source_keys[source]
	var/previous_z = source_zs[source]
	if(previous_bucket_index == bucket_index && previous_z == source_z && previous_category == category)
		if(previous_turf != source_turf)
			var/list/bucket = buckets_by_z[source_z][bucket_index]
			var/source_entry = bucket ? bucket.Find(source) : 0
			if(source_entry)
				// Find returns the last field of [x, y, category, source], so x and y are 3 and 2 entries back
				bucket[source_entry - 3] = source_turf.x
				bucket[source_entry - 2] = source_turf.y
			static_version++
			metrics.index_changes++
		record_source_change(version_before, previous_turf, previous_range, source_turf, category.range)
		return

	if(previous_bucket_index)
		remove_from_bucket(source, previous_z, previous_bucket_index)
	if(previous_category != category)
		move_between_categories(source, previous_category, category)
	source_keys[source] = bucket_index
	source_zs[source] = source_z
	source_categories[source] = category
	append_to_bucket(source, source_turf, category.index, bucket_index)
	static_version++
	metrics.index_changes++
	record_source_change(version_before, previous_turf, previous_range, source_turf, category.range)
	if(mode == POINT_AMBIENCE_FALLBACK)
		start_fallback(source)

/**
 * Applies a source's recording and effective volume overrides, versioning any playback change.
 *
 * For categories with alternate recordings, position selects a stable outdoor or indoor take when
 * sound_override is omitted. Selection runs on every registration so the take follows a moved source.
 *
 * source_base_volumes retains the caller's multiplier before indoor adjustment. source_volumes
 * holds the effective multiplier used for playback. Keeping both prevents repeated registrations
 * from compounding the indoor adjustment. An explicit scale of 1 resets the base multiplier,
 * while null preserves it. An effective scale of 1 removes the playback override.
 */
/datum/controller/subsystem/point_ambience/proc/apply_source_overrides(atom/source, datum/point_ambience_category/category, turf/source_turf, sound_override, volume_scale)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!sound_override && category.voices)
		var/list/recordings = category.voices
		if(category.voices_indoors)
			var/area/recording_area = source_turf.loc
			if(!recording_area?.outdoors)
				recordings = category.voices_indoors
		sound_override = recordings[1 + POINT_AMBIENCE_VOICE_SEED(source_turf) % length(recordings)]
	if(sound_override && category.source_sounds[source] != sound_override)
		category.source_sounds[source] = sound_override
		static_version++
		metrics.index_changes++

	if(!isnull(category.indoor_volume))
		if(isnull(volume_scale))
			volume_scale = category.source_base_volumes[source] || 1
		else if(volume_scale == 1)
			category.source_base_volumes -= source
		else if(volume_scale)
			category.source_base_volumes[source] = volume_scale
		var/area/source_area = source_turf.loc
		if(!source_area?.outdoors && category.volume)
			volume_scale *= category.indoor_volume / category.volume
	var/current_volume_scale = category.source_volumes[source]
	if(volume_scale == 1)
		if(isnull(current_volume_scale))
			return
		category.source_volumes -= source
		static_version++
		metrics.index_changes++
		return
	if(volume_scale && current_volume_scale != volume_scale)
		category.source_volumes[source] = volume_scale
		loudest_volume = max(loudest_volume, category.volume * volume_scale)
		static_version++
		metrics.index_changes++

/**
 * Transfers source counts and releases the old category's overrides and fallback playback.
 *
 * First registration only increments the destination count. A category change also drops the old
 * category's source references, which it could no longer clean up after the move. During a bulk
 * update, finish_bulk() checks listeners still playing the source under its former category.
 */
/datum/controller/subsystem/point_ambience/proc/move_between_categories(atom/source, datum/point_ambience_category/old_category, datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	if(old_category)
		if(bulk_depth)
			bulk_affected[source] = TRUE
		decrement_source_count(old_category)
		old_category.forget_source(source)
		stop_fallback(source)
	increment_source_count(category)

/**
 * Appends [x, y, category index, source] to a bucket, growing its floor and bucket lists as needed.
 *
 * buckets_by_z selects a floor. Cell selects a bucket within that floor. Each bucket is a flat
 * sequence of four-field source records. remove_from_bucket() removes the same four fields.
 */
/datum/controller/subsystem/point_ambience/proc/append_to_bucket(atom/source, turf/source_turf, category_index, cell)
	PRIVATE_PROC(TRUE)
	var/source_z = source_turf.z
	if(length(buckets_by_z) < source_z)
		buckets_by_z.len = source_z
	var/list/floor_buckets = buckets_by_z[source_z]
	if(!floor_buckets)
		floor_buckets = list()
		buckets_by_z[source_z] = floor_buckets
	if(length(floor_buckets) < cell)
		floor_buckets.len = cell
	var/list/bucket = floor_buckets[cell]
	if(!bucket)
		bucket = list()
		floor_buckets[cell] = bucket
	bucket += source_turf.x
	bucket += source_turf.y
	bucket += category_index
	bucket += source

/**
 * Registers a source only while active, on a turf and not being deleted. Otherwise unregisters it.
 *
 * Safe to call from repeated state changes and Moved(), including movement during deletion.
 */
/atom/movable/proc/update_point_ambience_source(category_path, active, volume_scale)
	if(active && !QDELETED(src) && isturf(loc))
		SSpoint_ambience.register_source(src, category_path, volume_scale = volume_scale)
	else
		SSpoint_ambience.unregister_source(src, category_path)

/**
 * Takes a source out of the index and silences it for anyone currently hearing it.
 *
 * Safe on something never registered, the common case for a mapped emitter that was never lit.
 *
 * Removal invalidates the old reach and records the version change before dropping the registry
 * entries, fallback loop, count and overrides. Normally it then releases shared scratch references
 * and stops listeners playing this source. A bulk update defers that cleanup to finish_bulk(),
 * avoiding a separate client walk for each removal.
 *
 * Arguments:
 * * category_path - read only when the index holds no category for the source. The index wins,
 *   since a caller passing the wrong path would decrement the wrong tally and leave the sound
 *   playing.
 */
/datum/controller/subsystem/point_ambience/proc/unregister_source(atom/source, category_path)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/point_ambience_category/category = source_categories[source] || categories_by_path[category_path]
	if(!category)
		return
	var/previous_bucket_index = source_keys[source]
	if(!previous_bucket_index)
		return
	var/turf/previous_turf = source_turfs[source]
	var/version_before = static_version
	invalidate_tile_cache(previous_turf, category.range)
	remove_from_bucket(source, source_zs[source], previous_bucket_index)
	static_version++
	metrics.index_changes++
	record_source_change(version_before, previous_turf, category.range, null, 0)
	source_keys -= source
	source_zs -= source
	source_turfs -= source
	source_categories -= source
	stop_fallback(source)
	decrement_source_count(category)
	category.forget_source(source)
	if(bulk_depth)
		bulk_affected[source] = TRUE
		return
	// The last walk's scratch may still hold the removed source, and nothing is due to overwrite it
	scratch_uncached.Cut()
	runner_up_by_category.Cut()
	// Stop active channels immediately rather than waiting for listeners' next services
	for(var/client/listener_client in GLOB.clients)
		if(listener_client.point_ambience.sources[category] == source)
			stop_for(listener_client, category)

/datum/controller/subsystem/point_ambience/proc/increment_source_count(datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	source_counts[category] = (source_counts[category] || 0) + 1

/// Decrements the category's indexed-source count without allowing a negative count
/datum/controller/subsystem/point_ambience/proc/decrement_source_count(datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	source_counts[category] = max(0, (source_counts[category] || 0) - 1)

/**
 * Removes a source's four-field record and releases the bucket if it becomes empty.
 *
 * Find() locates the source field at the end of the record. Cut() starts three entries earlier
 * and ends just past the source, removing [x, y, category index, source] together.
 *
 * Arguments:
 * * cell - the bucket index, from POINT_AMBIENCE_CELL_INDEX
 */
/datum/controller/subsystem/point_ambience/proc/remove_from_bucket(atom/source, z, cell)
	PRIVATE_PROC(TRUE)
	if(isnull(z) || length(buckets_by_z) < z)
		return
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets || length(floor_buckets) < cell)
		return
	var/list/bucket = floor_buckets[cell]
	if(!bucket)
		return
	var/source_entry = bucket.Find(source)
	if(source_entry)
		bucket.Cut(source_entry - POINT_AMBIENCE_QUAD_SOURCE, source_entry + 1)
	if(!length(bucket))
		floor_buckets[cell] = null

/// Recomputes every category's squared reach and the subsystem bounds, then invalidates all rankings
/datum/controller/subsystem/point_ambience/proc/refresh_category_ranges()
	max_range = 0
	for(var/datum/point_ambience_category/category as anything in categories)
		category.resolve_derived()
		if(category != river_category)
			max_range = max(max_range, category.range)
	clear_tile_cache()
