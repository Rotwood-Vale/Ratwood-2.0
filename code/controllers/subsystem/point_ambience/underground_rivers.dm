// A door reads as shut whatever its state, since rivers do not track doors
#define UNDERGROUND_RIVER_FILL_BLOCKED(T) (isclosedturf(T) || T.opacity || T.sound_door_count || T.sound_opening_count)

/// A river turf in an area with river_underground came into being, so it seeds the fill
/datum/controller/subsystem/point_ambience/proc/underground_river_tile_added(turf/water)
	underground_river_tiles[water] = TRUE
	if(underground_river_fill_done)
		underground_river_fill_dirty[water] = TRUE

/// A seeding river turf is going away
/datum/controller/subsystem/point_ambience/proc/underground_river_tile_removed(turf/water)
	underground_river_tiles -= water
	if(underground_river_fill_done)
		underground_river_fill_dirty[water] = TRUE

/**
 * A turf was replaced, or a door or window arrived on it or left it.
 *
 * Only a marked turf can change what the fill reaches. A blocker bordering the fill is marked too, and
 * an unmarked turf is either out of reach or only reachable past the step budget
 */
/datum/controller/subsystem/point_ambience/proc/underground_river_turf_changed(turf/changed)
	if(underground_river_fill_done && !isnull(underground_river_marks[changed]))
		underground_river_fill_dirty[changed] = TRUE

/**
 * Marks every turf within reach of underground water, once, at the first fire.
 *
 * Every map and every template placed at init is in place by then, and nobody is in game to wait on
 * one pass, so it runs whole rather than across ticks. Each mark is the steps from the nearest water.
 * A blocker is marked as well but never walked past, so standing in a doorway hears the river in full,
 * and so a marked turf alone tells underground_river_turf_changed() that a change there matters
 */
/datum/controller/subsystem/point_ambience/proc/fill_underground_river_marks()
	PRIVATE_PROC(TRUE)
	underground_river_fill_done = TRUE
	rustg_time_reset("pa_underground_river_fill")
	var/list/queue = scratch_fill_queue
	queue.Cut()
	for(var/turf/water as anything in underground_river_tiles)
		underground_river_marks[water] = 0
		if(!UNDERGROUND_RIVER_FILL_BLOCKED(water))
			queue += water
	underground_river_fill_walk(underground_river_marks)
	underground_river_marked_tiles = length(underground_river_marks)
	underground_river_fill_boot_ms = rustg_time_microseconds("pa_underground_river_fill") / 1000
	log_world("Point ambience underground river fill: [underground_river_marked_tiles] tiles marked from [length(underground_river_tiles)] underground water tiles in [round(underground_river_fill_boot_ms, 0.1)] ms")

/**
 * Rebuilds the marks around the turfs that changed, a box at a time until the tick is spent.
 *
 * Changed turfs that fit in one box spanning twice the step budget share it, so a template landing is a
 * few walks rather than one per turf. Only marks within the budget of a box can change, so that region
 * is cleared and walked again from the water within reach of it, then copied back. The walk keeps its
 * own marks: a correct mark outside the region would otherwise stop it reaching the region behind it.
 * Turfs whose box is not reached stay dirty, and the next fire carries on without the wait
 */
/datum/controller/subsystem/point_ambience/proc/refill_underground_river_marks()
	PRIVATE_PROC(TRUE)
	next_underground_river_fill = world.time + door_recheck_period
	var/list/marks = scratch_fill_marks
	var/list/queue = scratch_fill_queue
	while(length(underground_river_fill_dirty))
		// The first changed turf and every one that fits its box, the rest left for the next box
		var/list/dirty = underground_river_fill_dirty
		underground_river_fill_dirty = list()
		var/turf/first = dirty[1]
		var/z = first.z
		var/low_x = first.x
		var/low_y = first.y
		var/high_x = first.x
		var/high_y = first.y
		for(var/turf/changed as anything in dirty)
			if(changed.z != z || max(high_x, changed.x) - min(low_x, changed.x) > POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS * 2 || max(high_y, changed.y) - min(low_y, changed.y) > POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS * 2)
				underground_river_fill_dirty[changed] = TRUE
				continue
			low_x = min(low_x, changed.x)
			low_y = min(low_y, changed.y)
			high_x = max(high_x, changed.x)
			high_y = max(high_y, changed.y)
		underground_river_fills++
		low_x = max(low_x - POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS, 1)
		low_y = max(low_y - POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS, 1)
		high_x = min(high_x + POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS, world.maxx)
		high_y = min(high_y + POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS, world.maxy)
		// Nulled rather than removed, so underground_river_marks is never reindexed
		for(var/turf/cleared as anything in block(locate(low_x, low_y, z), locate(high_x, high_y, z)))
			if(!isnull(underground_river_marks[cleared]))
				underground_river_marks[cleared] = null
				underground_river_marked_tiles--
		marks.Cut()
		queue.Cut()
		for(var/turf/water as anything in underground_river_tiles)
			if(water.z == z && max(low_x - water.x, water.x - high_x, low_y - water.y, water.y - high_y) <= POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS)
				marks[water] = 0
				if(!UNDERGROUND_RIVER_FILL_BLOCKED(water))
					queue += water
		underground_river_fill_walk(marks, TRUE, low_x, low_y, high_x, high_y)
		for(var/turf/marked as anything in marks)
			if(marked.x < low_x || marked.x > high_x || marked.y < low_y || marked.y > high_y)
				continue
			if(isnull(underground_river_marks[marked]))
				underground_river_marked_tiles++
			underground_river_marks[marked] = marks[marked]
		marks.Cut()
		// A standing listener's cached answer does not cover the mark, so it is served again
		for(var/client/listener_client as anything in GLOB.clients)
			var/mob/listener = listener_client?.mob
			if(!listener || isobserver(listener) || isnewplayer(listener))
				continue
			var/turf/listener_turf = get_turf(listener_client.point_ambience_ear || listener)
			if(listener_turf?.z == z && listener_turf.x >= low_x && listener_turf.x <= high_x && listener_turf.y >= low_y && listener_turf.y <= high_y)
				mark_listener(listener_client)
		if(length(underground_river_fill_dirty) && MC_TICK_CHECK)
			next_underground_river_fill = world.time
			return

/**
 * Walks out from the turfs already queued, marking each turf it reaches with its steps.
 *
 * Eight ways, a diagonal counting one step and passing a corner only where a flanking cardinal is open.
 * Pruned, it also skips any turf too far from the region to reach back into it with the steps left.
 * Nothing is allocated per turf, the queue being a reused list read by index
 */
/datum/controller/subsystem/point_ambience/proc/underground_river_fill_walk(list/marks, pruned = FALSE, low_x, low_y, high_x, high_y)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// North, east, south and west, then the diagonals, each as an x and a y offset
	var/static/list/offsets = list(0, 1, 1, 0, 0, -1, -1, 0, 1, 1, 1, -1, -1, -1, -1, 1)
	// The two cardinals beside each diagonal, by their place in the order above
	var/static/list/flanks = list(1, 2, 3, 2, 3, 4, 1, 4)
	var/list/open = scratch_fill_open
	var/list/queue = scratch_fill_queue
	var/read = 0
	while(read < length(queue))
		read++
		var/turf/here = queue[read]
		var/next = marks[here] + 1
		if(next > POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS)
			continue
		for(var/direction in 1 to 8)
			if(direction > 4 && !open[flanks[direction * 2 - 9]] && !open[flanks[direction * 2 - 8]])
				continue
			var/turf/neighbour = locate(here.x + offsets[direction * 2 - 1], here.y + offsets[direction * 2], here.z)
			if(!neighbour)
				if(direction <= 4)
					open[direction] = FALSE
				continue
			var/blocked = UNDERGROUND_RIVER_FILL_BLOCKED(neighbour)
			if(direction <= 4)
				open[direction] = !blocked
			if(!isnull(marks[neighbour]))
				continue
			if(pruned && max(low_x - neighbour.x, neighbour.x - high_x, low_y - neighbour.y, neighbour.y - high_y) > POINT_AMBIENCE_UNDERGROUND_RIVER_FILL_STEPS - next)
				continue
			marks[neighbour] = next
			// A blocker is marked so a doorway hears full, and never walked past
			if(!blocked)
				queue += neighbour
	queue.Cut()

#undef UNDERGROUND_RIVER_FILL_BLOCKED
