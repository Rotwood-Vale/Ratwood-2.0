/// Returns a turf's cached same-floor ranking, optionally verifying and repairing a hit
/datum/controller/subsystem/point_ambience/proc/get_tile_ranking(turf/listener_turf)
	SHOULD_NOT_SLEEP(TRUE)
	var/cached = tile_cache[listener_turf]
	if(isnull(cached))
		tile_cache_misses++
		var/computed = rank_tile(listener_turf)
		tile_cache[listener_turf] = computed
		tile_cache_entries++
		return computed
	tile_cache_hits++
	if(!verify_tile_cache)
		return cached
	tile_cache_checks++
	var/expected = rank_tile(listener_turf)
	var/matches = (cached == expected)
	if(islist(cached) && islist(expected))
		var/list/cached_ranking = cached
		var/list/expected_ranking = expected
		matches = (length(cached_ranking) == length(expected_ranking))
		for(var/i = 1, matches && i <= length(cached_ranking), i++)
			if(cached_ranking[i] != expected_ranking[i])
				matches = FALSE
	if(matches)
		return cached
	tile_cache_mismatches++
	tile_cache[listener_turf] = expected
	return expected

/**
 * Builds one immutable same-floor ranking for the tile cache.
 *
 * TRUE represents an empty ranking because null means a missing associative entry. Non-empty
 * rankings are flat runs of category, winner, distance squared, runner-up and its distance squared
 */
/datum/controller/subsystem/point_ambience/proc/rank_tile(turf/listener_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	scratch_tile_best.Cut()
	scratch_best_distsq.Cut()
	runner_up_by_category.Cut()
	runner_up_distsq.Cut()
	collect_nearest_on_z(listener_turf.x, listener_turf.y, listener_turf.z, scratch_tile_best, scratch_best_distsq)
	ranked_candidates_this_service = round(length(scratch_uncached) / 4)
	// The entry keeps only its ranking, so release the gathered source references after counting them
	scratch_uncached.Cut()
	if(!length(scratch_tile_best))
		return TRUE
	var/list/ranking = new /list(length(scratch_tile_best) * 5)
	var/i = 1
	for(var/datum/point_ambience_category/category as anything in scratch_tile_best)
		ranking[i] = category
		ranking[i + 1] = scratch_tile_best[category]
		ranking[i + 2] = scratch_best_distsq[category]
		ranking[i + 3] = runner_up_by_category[category]
		ranking[i + 4] = runner_up_distsq[category]
		i += 5
	scratch_tile_best.Cut()
	return ranking

/**
 * Invalidates the live ranking entries within radius of a turf, on that turf's floor.
 *
 * Values become null rather than removing their keys, so tile_cache is never reindexed.
 * tile_cache_entries counts the live ones
 */
/datum/controller/subsystem/point_ambience/proc/invalidate_tile_cache(turf/center, radius)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// Inside a bulk update the close flushes every entry at once
	if(!center || !tile_cache_entries || bulk_depth)
		return
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_tile_invalidate")
	var/turf/lower = locate(max(1, center.x - radius), max(1, center.y - radius), center.z)
	var/turf/upper = locate(min(world.maxx, center.x + radius), min(world.maxy, center.y + radius), center.z)
	for(var/turf/affected as anything in block(lower, upper))
		if(!isnull(tile_cache[affected]))
			tile_cache[affected] = null
			tile_cache_entries--
			tile_cache_cleared++
	if(timing)
		tile_cache_invalidation_ms += rustg_time_microseconds("pa_tile_invalidate") / 1000

/**
 * Counts one index change and records it for can_reuse_tile_listener().
 *
 * Every register and unregister that changes the index ends here exactly once, so this is where an
 * actual change is known and counted. A change inside a bulk update is counted but not recorded,
 * since the close empties that history
 */
/datum/controller/subsystem/point_ambience/proc/record_source_change(version_before, turf/old_turf, old_range, turf/new_turf, new_range)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(version_before == static_version)
		return
	if(bulk_depth)
		bulk_changes++
		return
	// Mapload registers every mapped source within a few ticks by design, so only live play counts
	if(SSatoms.initialized == INITIALIZATION_INNEW_REGULAR)
		if(burst_time != world.time)
			burst_time = world.time
			burst_changes = 0
		burst_changes++
		if(burst_changes == POINT_AMBIENCE_BULK_BURST)
			report_unbatched_burst()
	if(!use_tile_cache)
		return
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_source_history")
	source_change_history.Add(version_before, static_version, old_turf?.x, old_turf?.y, old_turf?.z, old_range, new_turf?.x, new_turf?.y, new_turf?.z, new_range)
	var/overflow = length(source_change_history) - POINT_AMBIENCE_SOURCE_CHANGE_FIELDS * POINT_AMBIENCE_SOURCE_CHANGE_LIMIT
	if(overflow > 0)
		source_change_history.Cut(1, overflow + 1)
	if(timing)
		tile_cache_invalidation_ms += rustg_time_microseconds("pa_source_history") / 1000

/**
 * Whether recorded source changes leave a same-floor listener's ranking reusable.
 *
 * Requires complete history back to cached_version and rejects a change whose old or new reach
 * covers listener_turf. This establishes only source-history validity. It does not check hearing,
 * walls, preferences or the ear's enclosure, and is not sufficient on its own to skip a service.
 */
/datum/controller/subsystem/point_ambience/proc/can_reuse_tile_listener(turf/listener_turf, cached_version)
	SHOULD_NOT_SLEEP(TRUE)
	if(!use_tile_cache || !listener_turf || isnull(cached_version))
		return FALSE
	if(cached_version == static_version)
		return TRUE
	if(length(source_change_history) && cached_version < source_change_history[1])
		return FALSE
	var/expected_version = static_version
	for(var/i = length(source_change_history) - POINT_AMBIENCE_SOURCE_CHANGE_FIELDS + 1, i >= 1, i -= POINT_AMBIENCE_SOURCE_CHANGE_FIELDS)
		if(source_change_history[i + 1] != expected_version)
			return FALSE
		if(listener_turf.z == source_change_history[i + 4] \
			&& abs(listener_turf.x - source_change_history[i + 2]) <= source_change_history[i + 5] \
			&& abs(listener_turf.y - source_change_history[i + 3]) <= source_change_history[i + 5])
			return FALSE
		if(listener_turf.z == source_change_history[i + 8] \
			&& abs(listener_turf.x - source_change_history[i + 6]) <= source_change_history[i + 9] \
			&& abs(listener_turf.y - source_change_history[i + 7]) <= source_change_history[i + 9])
			return FALSE
		expected_version = source_change_history[i]
		if(cached_version == expected_version)
			return TRUE
		if(cached_version > expected_version)
			return FALSE
	return FALSE

/// Clears all shared tile rankings and invalidates every client's static-version cache
/datum/controller/subsystem/point_ambience/proc/clear_tile_cache()
	SHOULD_NOT_SLEEP(TRUE)
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_tile_invalidate")
	tile_cache_cleared += tile_cache_entries
	tile_cache.Cut()
	tile_cache_entries = 0
	scratch_tile_best.Cut()
	scratch_uncached.Cut()
	runner_up_by_category.Cut()
	invalidate_listener_cache()
	if(timing)
		tile_cache_invalidation_ms += rustg_time_microseconds("pa_tile_invalidate") / 1000

/// Changes tile-cache and verification modes after clearing all cached rankings
/datum/controller/subsystem/point_ambience/proc/set_tile_cache(enabled, verify = FALSE)
	clear_tile_cache()
	use_tile_cache = !!enabled
	verify_tile_cache = !!verify

/// Invalidates per-listener answers while preserving shared tile rankings
/datum/controller/subsystem/point_ambience/proc/invalidate_listener_cache()
	SHOULD_NOT_SLEEP(TRUE)
	source_change_history.Cut()
	static_version++
