/**
 * Prepares a listener's nearest source per category and each category's runner-up.
 *
 * With caching, get_tile_ranking() reuses or builds a shared ranking. Only its source references
 * are copied into listener-owned storage and runner-up scratch. Its stored distances are not needed.
 * Without caching, rank_nearby_sources() writes the selection directly.
 * Both builds follow gather_source_candidates() -> rank_candidates(): gather nearby buckets, then
 * select the nearest two sources per category on the listener's floor.
 *
 * Live occlusion may change the returned selection without changing the shared tile ranking.
 * Volume and preferences are applied per listener. The caller clears runner_up_by_category first.
 */
/datum/controller/subsystem/point_ambience/proc/nearest_sources(turf/listener_turf, client/listener_client)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list)
	var/z = listener_turf.z
	var/datum/point_ambience_listener/listener_state = listener_client.point_ambience
	var/list/nearest_by_category = listener_state.cache_static
	if(nearest_by_category)
		nearest_by_category.Cut()
	else
		nearest_by_category = list()

	if(!use_tile_cache)
		var/list/nearest_distances_sq = scratch_best_distsq
		nearest_distances_sq.Cut()
		runner_up_distsq.Cut()
		rank_nearby_sources(listener_turf.x, listener_turf.y, z, nearest_by_category, nearest_distances_sq)
		listener_state.cache_static = nearest_by_category
		return nearest_by_category

	var/entry = get_tile_ranking(listener_turf)
	if(!islist(entry))
		listener_state.cache_static = nearest_by_category
		return nearest_by_category
	var/list/ranking = entry
	for(var/i = 1, i <= length(ranking), i += POINT_AMBIENCE_RANK_SIZE)
		var/datum/point_ambience_category/category = ranking[i]
		nearest_by_category[category] = ranking[i + POINT_AMBIENCE_RANK_SOURCE]
		if(ranking[i + POINT_AMBIENCE_RANK_RUNNER_UP])
			runner_up_by_category[category] = ranking[i + POINT_AMBIENCE_RANK_RUNNER_UP]
	listener_state.cache_static = nearest_by_category
	return nearest_by_category

/// Gathers nearby sources on one floor and ranks them into the supplied category lists
/datum/controller/subsystem/point_ambience/proc/rank_nearby_sources(x, y, z, list/nearest_by_category, list/nearest_distances_sq)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/candidate_sources = scratch_uncached
	candidate_sources.Cut()
	gather_source_candidates(x - max_range, x + max_range, y - max_range, y + max_range, z, candidate_sources)
	rank_candidates(x, y, candidate_sources, nearest_by_category, nearest_distances_sq)

/**
 * Appends source records from every spatial bucket touched by the search box.
 *
 * Each bucket is appended as stored, with no per-source lookups. Candidates can lie outside the
 * box or their category's range. rank_candidates() applies the exact distance checks afterward.
 *
 * floor_buckets stores the grid as a flat list. cell_stride separates X columns. Y selects a bucket
 * within a column. The +1 converts zero-based cell coordinates to a DM list index. bucket_count
 * bounds the stored extent. Keep X then Y traversal order: equal-distance sources retain the first winner.
 */
/datum/controller/subsystem/point_ambience/proc/gather_source_candidates(min_x, max_x, min_y, max_y, z, list/candidate_sources)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(length(buckets_by_z) < z)
		return
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets)
		return
	var/bucket_count = length(floor_buckets)
	var/min_cell_x = max(1, min_x) >> POINT_AMBIENCE_CELL_SHIFT
	var/max_cell_x = max_x >> POINT_AMBIENCE_CELL_SHIFT
	var/min_cell_y = max(1, min_y) >> POINT_AMBIENCE_CELL_SHIFT
	var/max_cell_y = max_y >> POINT_AMBIENCE_CELL_SHIFT
	for(var/cell_x in min_cell_x to max_cell_x)
		var/column_start = cell_x * cell_stride + 1
		for(var/cell_y in min_cell_y to max_cell_y)
			var/bucket_index = column_start + cell_y
			if(bucket_index > bucket_count)
				break
			var/list/bucket = floor_buckets[bucket_index]
			if(!bucket)
				continue
			candidate_sources += bucket

/**
 * Selects the nearest two in-range sources per category in one pass through candidate records.
 *
 * Each POINT_AMBIENCE_QUAD_SIZE record holds x, y, category index and source. Winners and their
 * squared distances go into the supplied lists. Runner-ups go into the subsystem's scratch lists.
 * Callers clear these output lists before starting a new ranking.
 *
 * Squared Euclidean distance avoids square roots and excludes the corners admitted by get_dist().
 * Those corners lie beyond the falloff's range and would hold a channel at its minimum volume.
 * Equal distances retain the earlier winner. Null means no source has been ranked. Zero is a
 * valid distance for a source on the listener's tile.
 */
/datum/controller/subsystem/point_ambience/proc/rank_candidates(x, y, list/candidate_sources, list/nearest_by_category, list/nearest_distances_sq)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/entry_count = length(candidate_sources)
	var/max_range_sq = max_range * max_range
	for(var/candidate_index = 1, candidate_index <= entry_count, candidate_index += POINT_AMBIENCE_QUAD_SIZE)
		var/dx = candidate_sources[candidate_index] - x
		var/dy = candidate_sources[candidate_index + POINT_AMBIENCE_QUAD_Y] - y
		var/candidate_distance_sq = dx * dx + dy * dy
		if(candidate_distance_sq > max_range_sq)
			continue
		var/datum/point_ambience_category/category = categories[candidate_sources[candidate_index + POINT_AMBIENCE_QUAD_CATEGORY]]
		if(candidate_distance_sq > category.range_sq)
			continue

		var/nearest_distance_sq = nearest_distances_sq[category]
		if(isnull(nearest_distance_sq))
			nearest_distances_sq[category] = candidate_distance_sq
			nearest_by_category[category] = candidate_sources[candidate_index + POINT_AMBIENCE_QUAD_SOURCE]
			continue

		if(candidate_distance_sq < nearest_distance_sq)
			runner_up_distsq[category] = nearest_distance_sq
			runner_up_by_category[category] = nearest_by_category[category]
			nearest_distances_sq[category] = candidate_distance_sq
			nearest_by_category[category] = candidate_sources[candidate_index + POINT_AMBIENCE_QUAD_SOURCE]
			continue

		var/runner_up_distance_sq = runner_up_distsq[category]
		if(isnull(runner_up_distance_sq) || candidate_distance_sq < runner_up_distance_sq)
			runner_up_distsq[category] = candidate_distance_sq
			runner_up_by_category[category] = candidate_sources[candidate_index + POINT_AMBIENCE_QUAD_SOURCE]

/**
 * Counts source records in the buckets a ranking search would visit from this turf.
 *
 * Diagnostics use this to report candidate work, not audible sources: distance checks and ranking
 * are not performed. If supplied, by_category accumulates counts keyed by category config name.
 */
/datum/controller/subsystem/point_ambience/proc/count_walked(turf/from, list/by_category)
	. = 0
	if(!from || length(buckets_by_z) < from.z)
		return
	var/list/floor_buckets = buckets_by_z[from.z]
	if(!floor_buckets)
		return
	var/bucket_count = length(floor_buckets)
	var/min_cell_x = max(1, from.x - max_range) >> POINT_AMBIENCE_CELL_SHIFT
	var/max_cell_x = (from.x + max_range) >> POINT_AMBIENCE_CELL_SHIFT
	var/min_cell_y = max(1, from.y - max_range) >> POINT_AMBIENCE_CELL_SHIFT
	var/max_cell_y = (from.y + max_range) >> POINT_AMBIENCE_CELL_SHIFT
	for(var/cell_x in min_cell_x to max_cell_x)
		. += count_column_sources(floor_buckets, cell_x, min_cell_y, max_cell_y, bucket_count, by_category)

/**
 * Counts source records across one grid column and optionally adds them to a category tally.
 *
 * Uses the same flat-grid traversal as gather_source_candidates(), without collecting source records.
 * Each bucket's length gives its total. Individual records are read only for the category tally.
 */
/datum/controller/subsystem/point_ambience/proc/count_column_sources(list/floor_buckets, cell_x, min_cell_y, max_cell_y, bucket_count, list/by_category)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	. = 0
	var/column_start = cell_x * cell_stride + 1
	for(var/cell_y in min_cell_y to max_cell_y)
		var/bucket_index = column_start + cell_y
		if(bucket_index > bucket_count)
			break
		var/list/bucket = floor_buckets[bucket_index]
		if(!bucket)
			continue
		. += length(bucket) / POINT_AMBIENCE_QUAD_SIZE
		if(!by_category)
			continue
		count_bucket_categories(bucket, by_category)

/// Adds one bucket's source counts to a diagnostic tally keyed by category config name
/datum/controller/subsystem/point_ambience/proc/count_bucket_categories(list/bucket, list/by_category)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	for(var/i = 1 + POINT_AMBIENCE_QUAD_CATEGORY, i <= length(bucket), i += POINT_AMBIENCE_QUAD_SIZE)
		var/datum/point_ambience_category/category = categories[bucket[i]]
		by_category[category.config_name] += 1
