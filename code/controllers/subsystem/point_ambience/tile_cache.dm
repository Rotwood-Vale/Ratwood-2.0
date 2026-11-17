/**
 * Returns a same-floor ranking, building missing entries and optionally checking cached ones.
 *
 * null means not cached, TRUE means a known empty ranking, and a list holds packed source records.
 * A normal hit returns the stored entry directly. Verification rebuilds the ranking and compares
 * its fields, replacing a mismatched entry without changing the number of live cache entries.
 */
/datum/controller/subsystem/point_ambience/proc/get_tile_ranking(turf/listener_turf)
	SHOULD_NOT_SLEEP(TRUE)
	var/cached_entry = tile_cache[listener_turf]
	if(isnull(cached_entry))
		metrics.tile_cache_misses++
		var/computed_entry = rank_tile(listener_turf)
		tile_cache[listener_turf] = computed_entry
		tile_cache_entries++
		return computed_entry

	metrics.tile_cache_hits++
	if(!verify_tile_cache)
		return cached_entry

	var/expected_entry = rank_tile(listener_turf)
	var/rankings_match = (cached_entry == expected_entry)
	if(islist(cached_entry) && islist(expected_entry))
		var/list/cached_ranking = cached_entry
		var/list/expected_ranking = expected_entry
		rankings_match = (length(cached_ranking) == length(expected_ranking))
		for(var/field_index = 1, rankings_match && field_index <= length(cached_ranking), field_index++)
			if(cached_ranking[field_index] != expected_ranking[field_index])
				rankings_match = FALSE
	if(rankings_match)
		return cached_entry
	metrics.tile_cache_mismatches++
	tile_cache[listener_turf] = expected_entry
	return expected_entry

/**
 * Builds one immutable same-floor ranking for the tile cache.
 *
 * TRUE represents an empty ranking because null means a missing associative entry. Non-empty
 * rankings are flat runs of category, winner, distance squared, runner-up and its distance squared.
 * record_start addresses the category at the start of each POINT_AMBIENCE_RANK_SIZE record.
 */
/datum/controller/subsystem/point_ambience/proc/rank_tile(turf/listener_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	scratch_tile_best.Cut()
	scratch_best_distsq.Cut()
	runner_up_by_category.Cut()
	runner_up_distsq.Cut()
	rank_nearby_sources(listener_turf.x, listener_turf.y, listener_turf.z, scratch_tile_best, scratch_best_distsq)
	// The entry keeps only its ranking, so release the gathered source references
	scratch_uncached.Cut()
	if(!length(scratch_tile_best))
		return TRUE
	var/list/ranking = new /list(length(scratch_tile_best) * POINT_AMBIENCE_RANK_SIZE)
	var/record_start = 1
	for(var/datum/point_ambience_category/category as anything in scratch_tile_best)
		ranking[record_start] = category
		ranking[record_start + POINT_AMBIENCE_RANK_SOURCE] = scratch_tile_best[category]
		ranking[record_start + POINT_AMBIENCE_RANK_DISTANCE_SQ] = scratch_best_distsq[category]
		ranking[record_start + POINT_AMBIENCE_RANK_RUNNER_UP] = runner_up_by_category[category]
		ranking[record_start + POINT_AMBIENCE_RANK_RUNNER_UP_DISTANCE_SQ] = runner_up_distsq[category]
		record_start += POINT_AMBIENCE_RANK_SIZE
	scratch_tile_best.Cut()
	return ranking

/**
 * Invalidates live rankings in the square extending radius tiles around center, on its floor.
 *
 * The square conservatively covers the source's circular reach. Values become null rather than
 * removing their keys, so tile_cache is never reindexed. tile_cache_entries counts live values,
 * including TRUE entries for known silence. Closing a bulk update clears the whole cache instead.
 */
/datum/controller/subsystem/point_ambience/proc/invalidate_tile_cache(turf/center, radius)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!center || !tile_cache_entries || bulk_depth)
		return
	var/turf/min_turf = locate(max(1, center.x - radius), max(1, center.y - radius), center.z)
	var/turf/max_turf = locate(min(world.maxx, center.x + radius), min(world.maxy, center.y + radius), center.z)
	for(var/turf/affected_turf as anything in block(min_turf, max_turf))
		if(!isnull(tile_cache[affected_turf]))
			tile_cache[affected_turf] = null
			tile_cache_entries--

/**
 * Records a completed source change for listener-cache validation and burst diagnostics.
 *
 * Stores the before/after version and both source positions and ranges. Bulk updates count changes
 * without retaining individual history. Closing the batch clears cached selections.
 */
/datum/controller/subsystem/point_ambience/proc/record_source_change(version_before, turf/old_turf, old_range, turf/new_turf, new_range)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(version_before == static_version)
		return
	if(bulk_depth)
		bulk_changes++
		return
	// Exclude expected map-initialization registration bursts from live burst reporting
	if(SSatoms.initialized == INITIALIZATION_INNEW_REGULAR)
		if(burst_time != world.time)
			burst_time = world.time
			burst_changes = 0
		burst_changes++
		if(burst_changes == POINT_AMBIENCE_BULK_BURST)
			report_unbatched_burst()
	if(!use_tile_cache)
		return
	// Packed fields follow the POINT_AMBIENCE_SOURCE_CHANGE_* offsets
	source_change_history.Add(version_before, static_version, old_turf?.x, old_turf?.y, old_turf?.z, old_range, new_turf?.x, new_turf?.y, new_turf?.z, new_range)
	var/excess_fields = length(source_change_history) - POINT_AMBIENCE_SOURCE_CHANGE_FIELDS * POINT_AMBIENCE_SOURCE_CHANGE_LIMIT
	if(excess_fields > 0)
		source_change_history.Cut(1, excess_fields + 1)

/// Whether one end of a recorded change, where the source was or where it went, reached the turf:
/// the same floor, and within its range on both axes
#define CHANGE_END_REACHES(history, end_x, turf) ((turf).z == history[(end_x) + POINT_AMBIENCE_SOURCE_CHANGE_Z] \
	&& abs((turf).x - history[(end_x)]) <= history[(end_x) + POINT_AMBIENCE_SOURCE_CHANGE_RANGE] \
	&& abs((turf).y - history[(end_x) + POINT_AMBIENCE_SOURCE_CHANGE_Y]) <= history[(end_x) + POINT_AMBIENCE_SOURCE_CHANGE_RANGE])

/**
 * Returns whether recorded source changes leave a listener's cached ranking valid.
 *
 * Requires complete history back to cached_version and rejects changes whose old or new square
 * reach covers listener_turf. History is traversed newest first. expected_version links records and
 * detects missing or partial history.
 *
 * This validates source selection only. Hearing, walls, preferences and enclosure still need their
 * own checks before a service can be skipped.
 */
/datum/controller/subsystem/point_ambience/proc/can_reuse_tile_listener(turf/listener_turf, cached_version)
	SHOULD_NOT_SLEEP(TRUE)
	if(!use_tile_cache || !listener_turf || isnull(cached_version))
		return FALSE
	if(cached_version == static_version)
		return TRUE
	var/list/history = source_change_history
	if(length(history) && cached_version < history[1])
		return FALSE
	var/expected_version = static_version
	for(var/record_start = length(history) - POINT_AMBIENCE_SOURCE_CHANGE_FIELDS + 1, record_start >= 1, record_start -= POINT_AMBIENCE_SOURCE_CHANGE_FIELDS)
		if(history[record_start + POINT_AMBIENCE_SOURCE_CHANGE_VERSION_AFTER] != expected_version)
			return FALSE
		if(CHANGE_END_REACHES(history, record_start + POINT_AMBIENCE_SOURCE_CHANGE_FROM, listener_turf))
			return FALSE
		if(CHANGE_END_REACHES(history, record_start + POINT_AMBIENCE_SOURCE_CHANGE_TO, listener_turf))
			return FALSE
		expected_version = history[record_start]
		if(cached_version == expected_version)
			return TRUE
		if(cached_version > expected_version)
			return FALSE
	return FALSE

#undef CHANGE_END_REACHES

/// Clears all shared tile rankings and invalidates every client's static-version cache
/datum/controller/subsystem/point_ambience/proc/clear_tile_cache()
	SHOULD_NOT_SLEEP(TRUE)
	tile_cache.Cut()
	tile_cache_entries = 0
	scratch_tile_best.Cut()
	scratch_uncached.Cut()
	runner_up_by_category.Cut()
	invalidate_listener_cache()

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
