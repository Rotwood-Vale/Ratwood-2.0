// Openings remain barriers when open. River fill does not track door state
#define RIVER_FILL_BLOCKED(T) (isclosedturf(T) || T.opacity || T.sound_door_count || T.sound_opening_count)

/// Registers eligible water as a fill seed, without adding a positional sound source
/datum/controller/subsystem/point_ambience/proc/river_fill_tile_added(turf/water)
	river_fill_seeds[water] = TRUE
	if(river_fill_done)
		river_fill_dirty[water] = TRUE

/// Removes a seed and schedules its old reach for reconstruction
/datum/controller/subsystem/point_ambience/proc/river_fill_tile_removed(turf/water)
	river_fill_seeds -= water
	if(river_fill_done)
		river_fill_dirty[water] = TRUE

/**
 * Records terrain or opening placement changes that can affect river reach.
 *
 * Boundary blockers are marked too. Removing one can extend the fill, whereas an unmarked
 * turf is beyond the budget or behind an already marked blocker.
 */
/datum/controller/subsystem/point_ambience/proc/river_fill_turf_changed(turf/changed)
	if(river_fill_done && !isnull(river_fill_marks[changed]))
		river_fill_dirty[changed] = TRUE

/**
 * Builds river reach after map and template placement, at server init.
 *
 * Marks pack a path cost in half-steps and a blocker bit. A blocked seed or boundary is silent
 * and cannot expand, but stays recorded for later invalidation. Boot time is reported separately
 * from runtime refills. The initial build runs whole and never publishes a partial field
 */
/datum/controller/subsystem/point_ambience/proc/river_fill_build()
	PRIVATE_PROC(TRUE)
	rustg_time_reset("pa_river_fill")
	river_fill_marks.Cut()
	var/list/first_bucket = river_fill_buckets[1]
	for(var/turf/water as anything in river_fill_seeds)
		var/blocked = !!RIVER_FILL_BLOCKED(water)
		river_fill_marks[water] = RIVER_FILL_MARK(0, blocked)
		if(!blocked)
			first_bucket += water
	river_fill_walk(river_fill_marks)
	river_fill_marked_tiles = length(river_fill_marks)
	river_fill_dirty.Cut()
	river_fill_done = TRUE
	river_fill_boot_ms = rustg_time_microseconds("pa_river_fill") / 1000

/**
 * Rebuilds changed regions from nearby water, yielding only between complete regions.
 *
 * A changed box spans at most twice the reach. Its replacement region adds reach on every side,
 * and a second expansion bounds the seed search. At reach 8 these are at most 33x33 and 49x49 turfs.
 * Scratch marks may explore outside the replacement region to find routes back into it. Old
 * published marks must survive until listener answers have been compared with the new ones.
 */
/datum/controller/subsystem/point_ambience/proc/river_fill_rebuild()
	PRIVATE_PROC(TRUE)
	river_fill_next = world.time + door_recheck_period
	var/list/marks = river_fill_scratch_marks
	var/list/first_bucket = river_fill_buckets[1]
	while(length(river_fill_dirty))
		var/list/dirty = river_fill_dirty
		river_fill_dirty = list()
		var/turf/first = dirty[1]
		var/z = first.z
		var/low_x = first.x
		var/low_y = first.y
		var/high_x = first.x
		var/high_y = first.y
		for(var/turf/changed as anything in dirty)
			if(changed.z != z || max(high_x, changed.x) - min(low_x, changed.x) > POINT_AMBIENCE_RIVER_FILL_RANGE * 2 || max(high_y, changed.y) - min(low_y, changed.y) > POINT_AMBIENCE_RIVER_FILL_RANGE * 2)
				river_fill_dirty[changed] = TRUE
				continue
			low_x = min(low_x, changed.x)
			low_y = min(low_y, changed.y)
			high_x = max(high_x, changed.x)
			high_y = max(high_y, changed.y)
		river_fill_rebuilds++
		low_x = max(low_x - POINT_AMBIENCE_RIVER_FILL_RANGE, 1)
		low_y = max(low_y - POINT_AMBIENCE_RIVER_FILL_RANGE, 1)
		high_x = min(high_x + POINT_AMBIENCE_RIVER_FILL_RANGE, world.maxx)
		high_y = min(high_y + POINT_AMBIENCE_RIVER_FILL_RANGE, world.maxy)
		marks.Cut()
		var/turf/seed_low = locate(max(low_x - POINT_AMBIENCE_RIVER_FILL_RANGE, 1), max(low_y - POINT_AMBIENCE_RIVER_FILL_RANGE, 1), z)
		var/turf/seed_high = locate(min(high_x + POINT_AMBIENCE_RIVER_FILL_RANGE, world.maxx), min(high_y + POINT_AMBIENCE_RIVER_FILL_RANGE, world.maxy), z)
		for(var/turf/water as anything in block(seed_low, seed_high))
			if(!river_fill_seeds[water])
				continue
			var/blocked = !!RIVER_FILL_BLOCKED(water)
			marks[water] = RIVER_FILL_MARK(0, blocked)
			if(!blocked)
				first_bucket += water
		river_fill_walk(marks, TRUE, low_x, low_y, high_x, high_y)
		// Both blocked and absent mean silence. Only a changed audible answer needs a service
		for(var/client/listener_client as anything in GLOB.clients)
			var/mob/listener = listener_client?.mob
			if(!listener || isobserver(listener) || isnewplayer(listener))
				continue
			var/turf/listener_turf = get_turf(listener_client.point_ambience_ear || listener)
			if(listener_turf?.z != z || listener_turf.x < low_x || listener_turf.x > high_x || listener_turf.y < low_y || listener_turf.y > high_y)
				continue
			var/old_mark = river_fill_marks[listener_turf]
			var/new_mark = marks[listener_turf]
			var/old_cost = RIVER_FILL_AUDIBLE(old_mark) ? RIVER_FILL_COST(old_mark) : null
			var/new_cost = RIVER_FILL_AUDIBLE(new_mark) ? RIVER_FILL_COST(new_mark) : null
			if(old_cost != new_cost || isnull(old_cost) != isnull(new_cost))
				mark_listener(listener_client)
		// Publish only the replacement region, including marks that disappeared. Nulling retains
		// existing turf keys without reindexing the map, and untouched ground gets no new key
		for(var/turf/replaced as anything in block(locate(low_x, low_y, z), locate(high_x, high_y, z)))
			var/old_mark = river_fill_marks[replaced]
			var/new_mark = marks[replaced]
			if(isnull(old_mark) && isnull(new_mark))
				continue
			river_fill_marked_tiles += isnull(old_mark) - isnull(new_mark)
			river_fill_marks[replaced] = new_mark
		marks.Cut()
		if(length(river_fill_dirty) && MC_TICK_CHECK)
			river_fill_next = world.time
			return

/**
 * Finds shortest fill paths using reusable buckets for integer costs 0 through 16.
 *
 * Cardinals cost 2, diagonals 3. A diagonal needs one open cardinal flank. Cheaper arrivals
 * replace earlier marks, and queued entries whose cost has since improved are ignored. Blocker
 * bits are reused only from this construction's marks, never from an older published field.
 *
 * With pruned set, discard paths whose remaining budget cannot reach the replacement box.
 * The lower bound is twice the Chebyshev gap, and routes may leave the box and return to it
 */
/datum/controller/subsystem/point_ambience/proc/river_fill_walk(list/marks, pruned = FALSE, low_x, low_y, high_x, high_y)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// Cardinals N, E, S, W precede diagonals NE, SE, SW, NW, so their flank states are ready
	var/static/list/offsets = list(0, 1, 1, 0, 0, -1, -1, 0, 1, 1, 1, -1, -1, -1, -1, 1)
	var/static/list/flanks = list(1, 2, 3, 2, 3, 4, 1, 4)
	var/list/open = river_fill_scratch_open
	for(var/cost in 0 to POINT_AMBIENCE_RIVER_FILL_BUDGET)
		var/list/queue = river_fill_buckets[cost + 1]
		for(var/turf/here as anything in queue)
			if(RIVER_FILL_COST(marks[here]) != cost || cost + 2 > POINT_AMBIENCE_RIVER_FILL_BUDGET)
				continue
			for(var/direction in 1 to 8)
				var/next_cost = cost + (direction <= 4 ? 2 : 3)
				if(direction > 4 && (next_cost > POINT_AMBIENCE_RIVER_FILL_BUDGET || (!open[flanks[direction * 2 - 9]] && !open[flanks[direction * 2 - 8]])))
					continue
				var/turf/neighbour = locate(here.x + offsets[direction * 2 - 1], here.y + offsets[direction * 2], here.z)
				if(!neighbour)
					if(direction <= 4)
						open[direction] = FALSE
					continue
				var/known = marks[neighbour]
				var/blocked = isnull(known) ? !!RIVER_FILL_BLOCKED(neighbour) : (known & RIVER_FILL_BLOCKED_BIT)
				if(direction <= 4)
					open[direction] = !blocked
				if(!isnull(known) && RIVER_FILL_COST(known) <= next_cost)
					continue
				if(pruned && 2 * max(low_x - neighbour.x, neighbour.x - high_x, low_y - neighbour.y, neighbour.y - high_y, 0) > POINT_AMBIENCE_RIVER_FILL_BUDGET - next_cost)
					continue
				marks[neighbour] = RIVER_FILL_MARK(next_cost, blocked)
				if(!blocked)
					var/list/next_bucket = river_fill_buckets[next_cost + 1]
					next_bucket += neighbour
		queue.Cut()

#undef RIVER_FILL_BLOCKED
