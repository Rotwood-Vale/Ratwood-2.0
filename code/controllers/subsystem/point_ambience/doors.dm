/**
 * Collects a tile affected by a door change, so repeated changes share one gather per period.
 * FLANKS counts too, since its corner probes read doors.
 *
 * Arguments:
 * * location - the door or an affected turf. Movement reports both the old and new turf.
 */
/datum/controller/subsystem/point_ambience/proc/door_changed(atom/location)
	door_changes++
	// Before login hooks exist, no listener has a cached answer to refresh.
	if(!hooked_logins || !door_recheck || door_mode == SOUND_DOORS_NONE || mode != POINT_AMBIENCE_LIVE)
		return
	var/turf/door_turf = get_turf(location)
	if(door_turf)
		changed_doors[door_turf] = TRUE

/**
 * Serves again every listener a changed door could stand between and one of their sources. The
 * spatial grid finds who is in reach, the box filter drops those whose sources lie elsewhere, and
 * mark_listener() queues the rest past the standing shortcut.
 *
 * The grid follows bodies, so a detached head near the door is not found. Its listener catches up
 * when the head or the body next moves
 */
/datum/controller/subsystem/point_ambience/proc/recheck_doors()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	next_door_recheck = world.time + door_recheck_period
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_door_recheck")
	// Taken before the loop, so a runtime part way cannot leave the set to fail again every period
	var/list/doors = changed_doors
	changed_doors = list()
	for(var/turf/door_turf as anything in doors)
		// A floor the spatial grid was never told about has no cells to search
		if(door_turf.z > length(SSspatial_grid.grids_by_z_level))
			continue
		door_gathers++
		for(var/mob/listener as anything in SSspatial_grid.orthogonal_range_search(door_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS, max_range))
			var/client/listener_client = listener.client
			if(!listener_client || isobserver(listener))
				continue
			// The ear is the head, somewhere else, so the body's position says nothing
			if(listener_client.point_ambience_ear)
				mark_listener(listener_client)
				continue
			var/turf/listener_turf = get_turf(listener)
			// The grid answers in whole 17 tile cells, so this is the actual reach
			if(!listener_turf || listener_turf.z != door_turf.z \
				|| abs(listener_turf.x - door_turf.x) > max_range || abs(listener_turf.y - door_turf.y) > max_range)
				continue
			door_listeners_found++
			if(door_recheck_filter && !door_in_reach(listener_turf, door_turf))
				continue
			door_listeners_marked++
			mark_listener(listener_client)
	if(timing)
		door_gather_ms += rustg_time_microseconds("pa_door_recheck") / 1000

/**
 * Whether a door could stand on a line a service walks from this turf: inside the box between the
 * listener and the winner or runner-up of a category walls can block, widened by one tile for the
 * corner probes. Reads the tile cache's ranking, which is taken before occlusion. A service writes
 * its occlusion answer into the listener's own list, so a source a shut door silenced is gone from
 * there and opening the door would never bring it back. No ranking to read means no way to rule
 * the door out
 */
/datum/controller/subsystem/point_ambience/proc/door_in_reach(turf/listener_turf, turf/door_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!use_tile_cache || cross_floor)
		return TRUE
	var/entry = tile_cache[listener_turf]
	if(isnull(entry))
		return TRUE
	// TRUE is an empty ranking, nothing in range to block
	if(!islist(entry))
		return FALSE
	var/list/ranking = entry
	for(var/i = 1, i <= length(ranking), i += 5)
		var/datum/point_ambience_category/category = ranking[i]
		if(!category.occlude)
			continue
		if(door_in_box(listener_turf, ranking[i + 1], door_turf) || door_in_box(listener_turf, ranking[i + 3], door_turf))
			return TRUE
	return FALSE

/datum/controller/subsystem/point_ambience/proc/door_in_box(turf/listener_turf, atom/source, turf/door_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!source)
		return FALSE
	var/turf/source_turf = source_turfs[source] || get_turf(source)
	if(!source_turf)
		return FALSE
	return door_turf.x >= min(listener_turf.x, source_turf.x) - 1 && door_turf.x <= max(listener_turf.x, source_turf.x) + 1 \
		&& door_turf.y >= min(listener_turf.y, source_turf.y) - 1 && door_turf.y <= max(listener_turf.y, source_turf.y) + 1
