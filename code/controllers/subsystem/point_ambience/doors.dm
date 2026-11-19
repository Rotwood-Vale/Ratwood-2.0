/**
 * Collects a tile affected by a door change, so repeated changes share one gather per period.
 *
 * FLANKS counts too, since its corner probes read doors.
 *
 * Arguments:
 * * location - the door or an affected turf. Movement reports both the old and new turf.
 */
/datum/controller/subsystem/point_ambience/proc/door_changed(atom/location)
	metrics.door_changes++
	// Before login hooks exist, no listener has a cached answer to refresh
	var/can_recheck_doors = hooked_logins && mode == POINT_AMBIENCE_LIVE \
		&& door_recheck && door_mode != SOUND_DOORS_NONE
	if(!can_recheck_doors)
		return
	var/turf/door_turf = get_turf(location)
	if(door_turf)
		changed_doors[door_turf] = TRUE

/**
 * Schedules a refresh for listeners whose source paths could be affected by a changed door.
 *
 * The spatial grid gathers nearby bodies. The square-range check removes whole-cell overreach.
 * door_may_affect_listener() then checks their cached source paths. mark_listener() sends the remaining
 * listeners past the standing shortcut, through the queue when it is on.
 *
 * The grid follows bodies, so a detached head near the door is not found. Its listener catches up
 * when the head or the body next moves
 */
/datum/controller/subsystem/point_ambience/proc/recheck_doors()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	next_door_recheck = world.time + door_recheck_period
	// Detach the pending set before processing so a runtime cannot replay the same batch
	// indefinitely
	var/list/pending_doors = changed_doors
	changed_doors = list()
	for(var/turf/door_turf as anything in pending_doors)
		if(door_turf.z > length(SSspatial_grid.grids_by_z_level))
			continue
		for(var/mob/listener as anything in SSspatial_grid.orthogonal_range_search(door_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS, max_range))
			var/client/listener_client = listener.client
			if(!listener_client || isobserver(listener))
				continue
			// Detached hearing uses the head's position, which this body-based gather cannot
			// locate
			if(listener_client.point_ambience.ear)
				mark_listener(listener_client)
				continue
			var/turf/listener_turf = get_turf(listener)
			if(listener_turf?.z != door_turf.z)
				continue
			var/listener_outside_reach = abs(listener_turf.x - door_turf.x) > max_range \
				|| abs(listener_turf.y - door_turf.y) > max_range
			if(listener_outside_reach)
				continue
			if(!door_may_affect_listener(listener_turf, door_turf))
				continue
			metrics.door_listeners_marked++
			mark_listener(listener_client)

/**
 * Checks whether a door could affect a cached winner or runner-up in a category that uses occlusion.
 *
 * door_near_source_path() is a conservative box filter, not an occlusion trace. Read the shared
 * tile ranking before occlusion: the listener's own selection can omit a source blocked by a shut
 * door, and using that selection would prevent opening the door from bringing the source back.
 * An unknown ranking requires a refresh. A known empty ranking has nothing for a door to block.
 */
/datum/controller/subsystem/point_ambience/proc/door_may_affect_listener(turf/listener_turf, turf/door_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!use_tile_cache)
		return TRUE
	var/ranking_entry = tile_cache[listener_turf]
	if(isnull(ranking_entry))
		return TRUE
	// TRUE is an empty ranking, nothing in range to block
	if(!islist(ranking_entry))
		return FALSE
	var/list/ranking = ranking_entry
	for(var/rank_index = 1, rank_index <= length(ranking), rank_index += POINT_AMBIENCE_RANK_SIZE)
		var/datum/point_ambience_category/category = ranking[rank_index]
		if(!category.occlude)
			continue
		if(door_near_source_path(listener_turf, ranking[rank_index + POINT_AMBIENCE_RANK_SOURCE], door_turf) || door_near_source_path(listener_turf, ranking[rank_index + POINT_AMBIENCE_RANK_RUNNER_UP], door_turf))
			return TRUE
	return FALSE

/**
 * Tests whether a door lies in the listener/source bounding box widened for corner probes.
 *
 * Both axes include a one-tile margin. Passing this filter means the source needs rechecking.
 * It does not establish that the door blocks sound. A missing source or source turf cannot qualify.
 */
/datum/controller/subsystem/point_ambience/proc/door_near_source_path(turf/listener_turf, atom/source, turf/door_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!source)
		return FALSE
	var/turf/source_turf = source_turfs[source] || get_turf(source)
	if(!source_turf)
		return FALSE

	var/within_path_x_bounds = door_turf.x >= min(listener_turf.x, source_turf.x) - 1 \
		&& door_turf.x <= max(listener_turf.x, source_turf.x) + 1
	if(!within_path_x_bounds)
		return FALSE
	var/within_path_y_bounds = door_turf.y >= min(listener_turf.y, source_turf.y) - 1 \
		&& door_turf.y <= max(listener_turf.y, source_turf.y) + 1
	return within_path_y_bounds
