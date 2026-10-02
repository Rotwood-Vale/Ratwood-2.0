/**
 * Puts an active source into the index, or moves one already in it.
 *
 * Repeated registration is safe. Moving sources must call register_source() again when their turf
 * changes. Rogue lights and clocks do this in Moved(), while a rotting body uses its component.
 * get_turf() can place a contained source at its carrier's turf, but this index does not follow
 * that carrier. A caller that moves it must register it again.
 *
 * A category silenced by config is refused before its sources add work to every ranking. The
 * unregister on this path also removes a source left indexed by a route other than seed_settings(),
 * which clears mapload sources itself.
 *
 * A move bumps static_version even within one bucket. Otherwise a standing listener can keep the
 * old volume and pan until the source crosses a cell boundary. The person dragging a corpse or
 * brazier moves and gets fresh answers, which can hide this error during testing.
 *
 * Arguments:
 * * category_path - the category's type path, not its datum
 * * sound_override - a file this source plays instead of the category's, so it can ride a category
 *   it does not sound like
 * * volume_scale - multiplier of category volume. 1 removes an override, while null keeps the
 *   current scale. Range belongs to the category because it gates the walk
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
	var/turf/old_turf = source_turfs[source]
	var/datum/point_ambience_category/old_category = source_categories[source]
	var/version_before = static_version
	var/old_range = old_category?.range
	if(old_turf != source_turf || old_category != category)
		// A move or category change can alter every tile reached from either endpoint
		if(old_turf && old_category)
			invalidate_tile_cache(old_turf, old_category.range)
		invalidate_tile_cache(source_turf, category.range)
	source_turfs[source] = source_turf
	apply_source_overrides(source, category, source_turf, sound_override, volume_scale)
	if(!cell_stride)
		cell_stride = (world.maxy >> POINT_AMBIENCE_CELL_SHIFT) + 2
	var/cell = POINT_AMBIENCE_CELL_INDEX(source_turf.x, source_turf.y, cell_stride)
	var/z = source_turf.z
	var/old_cell = source_keys[source]
	var/old_z = source_zs[source]
	if(old_cell == cell && old_z == z && old_category == category)
		// Same bucket, but the bucket carries the position, and a dragged source moves inside its
		// bucket on most steps
		if(old_turf != source_turf)
			var/list/bucket = buckets_by_z[z][cell]
			var/at = bucket ? bucket.Find(source) : 0
			if(at)
				bucket[at - 3] = source_turf.x
				bucket[at - 2] = source_turf.y
			static_version++
			index_changes++
		record_source_change(version_before, old_turf, old_range, source_turf, category.range)
		return
	if(old_cell)
		remove_from_bucket(source, old_z, old_cell)
	// A source can move BETWEEN categories, so both counts follow it
	if(old_category != category)
		move_between_categories(source, old_category, category)
	source_keys[source] = cell
	source_zs[source] = z
	source_categories[source] = category
	append_to_bucket(source, source_turf, category.index, cell)
	static_version++
	index_changes++
	record_source_change(version_before, old_turf, old_range, source_turf, category.range)
	if(mode == POINT_AMBIENCE_FALLBACK)
		start_fallback(source)

/// The file and volume one source plays at in place of its category's. Any change bumps
/// static_version
/datum/controller/subsystem/point_ambience/proc/apply_source_overrides(atom/source, datum/point_ambience_category/category, turf/source_turf, sound_override, volume_scale)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// Takes are handed out by position, so a fixed source always draws the same one. Under a roof
	// a source draws from the indoor set, read off the area's own outdoors flag
	if(!sound_override && category.voices)
		var/list/takes = category.voices
		if(category.voices_indoors)
			var/area/here = source_turf.loc
			if(!here?.outdoors)
				takes = category.voices_indoors
		sound_override = takes[1 + ((source_turf.x * 73 + source_turf.y * 179 + source_turf.z * 283) % 97) % length(takes)]
	// Reapplied on every call, so a category change carries them to the new category and a take
	// follows its source's position
	if(sound_override && category.source_sounds[source] != sound_override)
		category.source_sounds[source] = sound_override
		static_version++
		index_changes++
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
		if(!isnull(current_volume_scale))
			category.source_volumes -= source
			static_version++
			index_changes++
	else if(volume_scale && current_volume_scale != volume_scale)
		category.source_volumes[source] = volume_scale
		loudest_volume = max(loudest_volume, category.volume * volume_scale)
		static_version++
		index_changes++

/// Moves a source's tallies from the category it leaves, if any, to the one it joins
/datum/controller/subsystem/point_ambience/proc/move_between_categories(atom/source, datum/point_ambience_category/old_category, datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	if(old_category)
		// Checked at the close against listeners still playing it under the old category
		if(bulk_depth)
			bulk_affected[source] = TRUE
		decrement_source_count(old_category)
		// The overrides live on the category, so a move leaves them behind holding a hard
		// reference the old category can no longer reach to clear
		old_category.forget_source(source)
		stop_fallback(source)
	increment_source_count(category)

/// Adds a source's four-entry quad to the end of its bucket, growing the floor and bucket lists
/// as needed. The counterpart of remove_from_bucket
/datum/controller/subsystem/point_ambience/proc/append_to_bucket(atom/source, turf/source_turf, category_index, cell)
	PRIVATE_PROC(TRUE)
	var/z = source_turf.z
	if(length(buckets_by_z) < z)
		buckets_by_z.len = z
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets)
		floor_buckets = list()
		buckets_by_z[z] = floor_buckets
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
 * Takes a source out of the index and silences it for anyone currently hearing it.
 *
 * Safe on something never registered, the common case for a mapped emitter that was never lit.
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
	var/old_cell = source_keys[source]
	if(!old_cell)
		// Never registered, so it cannot be anyone's current source: skips the client walk for a
		// mapped emitter that was never lit
		return
	var/turf/old_turf = source_turfs[source]
	var/version_before = static_version
	invalidate_tile_cache(old_turf, category.range)
	remove_from_bucket(source, source_zs[source], old_cell)
	static_version++
	index_changes++
	record_source_change(version_before, old_turf, category.range, null, 0)
	source_keys -= source
	source_zs -= source
	source_turfs -= source
	source_categories -= source
	stop_fallback(source)
	decrement_source_count(category)
	category.forget_source(source)
	// Inside a bulk update the close makes this walk once for every source the scope changed
	if(bulk_depth)
		bulk_affected[source] = TRUE
		return
	// The last walk's scratch may still hold the removed source, and nothing is due to overwrite it
	scratch_uncached.Cut()
	runner_up_by_category.Cut()
	// The channel is the stop handle: a snuffed source goes silent now, not at each listener's next
	// service. One client walk per deactivation
	for(var/client/listener_client in GLOB.clients)
		if(listener_client.point_ambience_sources[category] == source)
			stop_for(listener_client, category)

/datum/controller/subsystem/point_ambience/proc/increment_source_count(datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	source_counts[category] = (source_counts[category] || 0) + 1

/// Guarded against going negative, so an unbalanced removal cannot leave a category owing a source
/datum/controller/subsystem/point_ambience/proc/decrement_source_count(datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	source_counts[category] = max(0, (source_counts[category] || 0) - 1)

/**
 * Cuts a source's four-entry quad out of one bucket. The rare path, so a linear Find is fine.
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
	// The source is the last of its four entries
	var/at = bucket.Find(source)
	if(at)
		bucket.Cut(at - 3, at + 1)
	if(!length(bucket))
		floor_buckets[cell] = null

/// Recomputes every category's squared reach and the subsystem bounds, then invalidates all rankings
/datum/controller/subsystem/point_ambience/proc/refresh_category_ranges()
	max_range = 0
	for(var/datum/point_ambience_category/category as anything in categories)
		category.resolve_derived()
		if(category != river_category)
			max_range = max(max_range, category.range)
	max_range_sq = max_range * max_range
	clear_tile_cache()

/**
 * Finds the nearest and second-nearest source per category for this listener position.
 *
 * Ranks the listener's own floor only, since ambience does not carry between floors. Selection may
 * load an immutable turf ranking. The returned winner table belongs to the client and may be changed
 * by live occlusion after this proc returns. Volume and preferences are applied per listener
 */
/datum/controller/subsystem/point_ambience/proc/nearest_sources(turf/listener_turf, client/listener_client)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list)
	var/z = listener_turf.z
	// Ranked straight into the list the client keeps, so a walk allocates nothing
	var/list/best = listener_client.point_ambience_cache_static
	if(best)
		best.Cut()
	else
		best = list()
	if(use_tile_cache)
		// Tile hits never refresh the per-client candidate lists. Release their source references and
		// force a rebuild if selection returns to the cell path
		if(listener_client.point_ambience_cell_candidates)
			listener_client.point_ambience_cell_candidates = null
			listener_client.point_ambience_cell_version = null
		var/entry = get_tile_ranking(listener_turf)
		if(islist(entry))
			var/list/ranking = entry
			for(var/i = 1, i <= length(ranking), i += 5)
				var/datum/point_ambience_category/category = ranking[i]
				best[category] = ranking[i + 1]
				if(ranking[i + 3])
					runner_up_by_category[category] = ranking[i + 3]
		listener_client.point_ambience_cache_static = best
		return best
	var/list/best_distsq = scratch_best_distsq
	best_distsq.Cut()
	runner_up_distsq.Cut()
	if(!use_cell_cache)
		collect_nearest_on_z(listener_turf.x, listener_turf.y, z, best, best_distsq)
		ranked_candidates_this_service = round(length(scratch_uncached) / 4)
	else
		var/cell = POINT_AMBIENCE_CELL_INDEX(listener_turf.x, listener_turf.y, cell_stride)
		if(listener_client.point_ambience_cell_index != cell \
			|| listener_client.point_ambience_cell_z != z \
			|| listener_client.point_ambience_cell_version != static_version)
			rebuilt_this_service = TRUE
			listener_client.point_ambience_cell_index = cell
			listener_client.point_ambience_cell_z = z
			listener_client.point_ambience_cell_version = static_version
			var/list/candidates = listener_client.point_ambience_cell_candidates
			if(candidates)
				candidates.Cut()
			else
				candidates = list()
				listener_client.point_ambience_cell_candidates = candidates
			collect_candidates(listener_turf.x, listener_turf.y, z, candidates)
		rank_candidates(listener_turf.x, listener_turf.y, listener_client.point_ambience_cell_candidates, best, best_distsq)
		ranked_candidates_this_service = round(length(listener_client.point_ambience_cell_candidates) / 4)

	listener_client.point_ambience_cache_static = best
	return best

/// The uncached walk: the buckets within max_range of the POSITION, gathered and ranked
/datum/controller/subsystem/point_ambience/proc/collect_nearest_on_z(x, y, z, list/best, list/best_distsq)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/gathered = scratch_uncached
	gathered.Cut()
	gather_buckets(x - max_range, x + max_range, y - max_range, y + max_range, z, gathered)
	rank_candidates(x, y, gathered, best, best_distsq)

/// Appends every quad in the buckets whose cells the box touches, straight out of the buckets as
/// they are stored: one native append per bucket, no lookups
/datum/controller/subsystem/point_ambience/proc/gather_buckets(min_x, max_x, min_y, max_y, z, list/out)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(length(buckets_by_z) < z)
		return
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets)
		return
	var/cells = length(floor_buckets)
	var/by_lo = max(1, min_y) >> POINT_AMBIENCE_CELL_SHIFT
	var/by_hi = max_y >> POINT_AMBIENCE_CELL_SHIFT
	for(var/bx in (max(1, min_x) >> POINT_AMBIENCE_CELL_SHIFT) to (max_x >> POINT_AMBIENCE_CELL_SHIFT))
		var/row = bx * cell_stride + 1
		for(var/by in by_lo to by_hi)
			var/cell = row + by
			if(cell > cells)
				break
			var/list/bucket = floor_buckets[cell]
			if(bucket)
				out += bucket

/**
 * Everything the own-floor walk could reach from anywhere in the caller's CELL, gathered once per
 * cell rather than probed on every step.
 *
 * Bounded by the CELL expanded by max_range, NEVER by the caller's position. The list is kept for
 * every step taken inside the cell, and a box computed from one tile in it drops the sources a
 * listener walks toward from the far side. Dropping sources is fast, so a timing will not catch that.
 */
/datum/controller/subsystem/point_ambience/proc/collect_candidates(x, y, z, list/out)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/cell_min_x = (x >> POINT_AMBIENCE_CELL_SHIFT) << POINT_AMBIENCE_CELL_SHIFT
	var/cell_min_y = (y >> POINT_AMBIENCE_CELL_SHIFT) << POINT_AMBIENCE_CELL_SHIFT
	var/cell_max_x = cell_min_x + (1 << POINT_AMBIENCE_CELL_SHIFT) - 1
	var/cell_max_y = cell_min_y + (1 << POINT_AMBIENCE_CELL_SHIFT) - 1
	gather_buckets(cell_min_x - max_range, cell_max_x + max_range, cell_min_y - max_range, cell_max_y + max_range, z, out)

/**
 * Ranks a flat list of quads into the nearest per category and its runner-up.
 *
 * The uncached walk, the cell cache and the tile cache all rank through here, so each reaches the
 * same answer.
 */
/datum/controller/subsystem/point_ambience/proc/rank_candidates(x, y, list/candidates, list/best, list/best_distsq)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/count = length(candidates)
	for(var/i = 1, i <= count, i += 4)
		// EUCLIDEAN, unlike playsound()'s chebyshev get_dist: a square admits corners past the
		// falloff's range, which pin at min volume and hold the channel inaudibly
		var/dx = candidates[i] - x
		var/dy = candidates[i + 1] - y
		var/distsq = dx * dx + dy * dy
		if(distsq > max_range_sq)
			continue
		var/datum/point_ambience_category/category = categories[candidates[i + 2]]
		if(distsq > category.range_sq)
			continue
		var/existing = best_distsq[category]
		if(isnull(existing) || distsq < existing)
			// The displaced winner becomes the runner-up. Only sources already inside the category's
			// range reach here, a handful a service
			if(!isnull(existing))
				runner_up_distsq[category] = existing
				runner_up_by_category[category] = best[category]
			best_distsq[category] = distsq
			best[category] = candidates[i + 3]
		else
			var/runner_up = runner_up_distsq[category]
			if(isnull(runner_up) || distsq < runner_up)
				runner_up_distsq[category] = distsq
				runner_up_by_category[category] = candidates[i + 3]

/// How many sources a walk from a turf would rank, and per category name when a list is given.
/// Counts what the cells the walk probes hold, without ranking any of it. For the verbs
/datum/controller/subsystem/point_ambience/proc/count_walked(turf/from, list/by_category)
	. = 0
	if(!from || length(buckets_by_z) < from.z)
		return
	var/list/floor_buckets = buckets_by_z[from.z]
	if(!floor_buckets)
		return
	var/cells = length(floor_buckets)
	var/by_lo = max(1, from.y - max_range) >> POINT_AMBIENCE_CELL_SHIFT
	var/by_hi = (from.y + max_range) >> POINT_AMBIENCE_CELL_SHIFT
	for(var/bx in (max(1, from.x - max_range) >> POINT_AMBIENCE_CELL_SHIFT) to ((from.x + max_range) >> POINT_AMBIENCE_CELL_SHIFT))
		var/row = bx * cell_stride + 1
		for(var/by in by_lo to by_hi)
			var/cell = row + by
			if(cell > cells)
				break
			var/list/bucket = floor_buckets[cell]
			if(!bucket)
				continue
			. += length(bucket) / 4
			if(by_category)
				for(var/i = 3, i <= length(bucket), i += 4)
					var/datum/point_ambience_category/category = categories[bucket[i]]
					by_category[category.config_name] += 1
