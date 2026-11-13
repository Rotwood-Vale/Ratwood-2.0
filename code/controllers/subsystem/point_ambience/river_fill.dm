/// River fill treats all opening tiles as barriers because it does not track their open/closed
/// state
#define RIVER_FILL_BLOCKED(T) (isclosedturf(T) || T.opacity || T.sound_door_count || T.sound_opening_count)
/// The audible path cost of a mark, or null for a blocked or absent one, which both mean silence
#define RIVER_FILL_HEARD_COST(mark) (RIVER_FILL_AUDIBLE(mark) ? RIVER_FILL_COST(mark) : null)
/// Half steps per cardinal and per diagonal step
#define RIVER_FILL_CARDINAL 2
#define RIVER_FILL_DIAGONAL 3
/// Cardinal entries precede diagonals in the propagation tables
#define RIVER_FILL_CARDINAL_COUNT 4
#define RIVER_FILL_NEIGHBOR_COUNT 8
/// Fields of the changed-turf bounds returned by take_dirty_box()
#define RIVER_FILL_BOX_Z 1
#define RIVER_FILL_BOX_MIN_X 2
#define RIVER_FILL_BOX_MIN_Y 3
#define RIVER_FILL_BOX_MAX_X 4
#define RIVER_FILL_BOX_MAX_Y 5
/// Diagonal neighbor indices 5..8 select flank pairs 1/2, 3/4, 5/6 and 7/8. Cardinals have no pair
#define RIVER_FILL_FIRST_FLANK_INDEX(neighbor_index) (((neighbor_index) * 2) - 9)
#define RIVER_FILL_SECOND_FLANK_INDEX(neighbor_index) (((neighbor_index) * 2) - 8)

/**
 * Where rivers can be heard: each turf's path cost from eligible water, kept current as ground changes.
 *
 * One lives on SSpoint_ambience and survives a rebuilt subsystem. The subsystem builds it at server
 * init and schedules rebuild_box() between its ticks, and a service reads marks.
 *
 * A build follows mark_water_seeds() -> propagate_reach(). A regional rebuild runs those stages
 * in scratch storage, then wake_changed_listeners() compares audible results before publish_region()
 * replaces the affected marks. Ordinary listener services only read the completed field.
 */
/datum/point_ambience_river_fill
	/// Packed path cost and blocker bit, null beyond reach. Zero is an audible seed. Turf keys
	/// survive replacement, and rebuild_box() redoes the regions a change affects
	var/list/marks = list()
	/// Eligible river turfs, keyed to TRUE. These seed the fill, not the source index
	var/list/seeds = list()
	/// Marked turfs that changed and are not refilled yet, each keyed to TRUE
	var/list/dirty = list()
	var/next = 0
	/// Whether the initial fill has run, after map and template placement at server init
	var/done = FALSE
	/// Pending turfs grouped by path cost: buckets[cost + 1]. Reused and emptied by propagate_reach()
	var/list/buckets = list()
	var/list/scratch_marks = list()
	/// N, E, S, W flank states, overwritten for each turf before its diagonal neighbors are checked
	var/list/scratch_open = list(FALSE, FALSE, FALSE, FALSE)
	/// River fill boxes rebuilt since boot, the turfs marked now, and the boot fill's cost
	var/rebuilds = 0
	var/marked_tiles = 0
	var/boot_ms = 0

/datum/point_ambience_river_fill/New()
	. = ..()
	for(var/cost in 0 to POINT_AMBIENCE_RIVER_FILL_BUDGET)
		buckets += list(list())

/// Registers eligible water as a fill seed, without adding a positional sound source
/datum/point_ambience_river_fill/proc/tile_added(turf/water)
	seeds[water] = TRUE
	if(done)
		dirty[water] = TRUE

/// Removes a seed and schedules its old reach for reconstruction
/datum/point_ambience_river_fill/proc/tile_removed(turf/water)
	seeds -= water
	if(done)
		dirty[water] = TRUE

/**
 * Records terrain or opening placement changes that can affect river reach.
 *
 * Boundary blockers are marked too. Removing one can extend the fill, whereas an unmarked
 * turf is beyond the budget or behind an already marked blocker.
 */
/datum/point_ambience_river_fill/proc/turf_changed(turf/changed)
	if(done && !isnull(marks[changed]))
		dirty[changed] = TRUE

/**
 * Builds river reach after map and template placement, at server init.
 *
 * Marks pack a path cost in half-steps and a blocker bit. A blocked seed or boundary is silent
 * and cannot expand, but stays recorded for later invalidation. Boot time is reported separately
 * from runtime refills. The initial build runs whole and never publishes a partial field
 */
/datum/point_ambience_river_fill/proc/build()
	rustg_time_reset("pa_river_fill")
	marks.Cut()
	mark_water_seeds(marks, seeds)
	propagate_reach(marks)
	marked_tiles = length(marks)
	dirty.Cut()
	done = TRUE
	boot_ms = rustg_time_microseconds("pa_river_fill") / 1000

/**
 * Rebuilds one box of changed turfs from nearby water. The rest stay dirty for the next call.
 *
 * changed_bounds groups nearby dirty turfs. Expanding it by the fill reach gives the replacement
 * region, bounded by region_min/max_x/y. Expanding that region once more gives seed_search_min/max,
 * the corners of the water search: at reach 8, at most 33 by 33 and 49 by 49 turfs respectively.
 * The fill runs in scratch marks and may leave the replacement region to find routes back into it.
 * Published marks stay intact until listeners have been compared against the rebuilt field.
 */
/datum/point_ambience_river_fill/proc/rebuild_box()
	if(!length(dirty))
		return
	var/list/changed_bounds = take_dirty_box()
	rebuilds++
	var/region_z = changed_bounds[RIVER_FILL_BOX_Z]
	var/region_min_x = max(changed_bounds[RIVER_FILL_BOX_MIN_X] - POINT_AMBIENCE_RIVER_FILL_RANGE, 1)
	var/region_min_y = max(changed_bounds[RIVER_FILL_BOX_MIN_Y] - POINT_AMBIENCE_RIVER_FILL_RANGE, 1)
	var/region_max_x = min(changed_bounds[RIVER_FILL_BOX_MAX_X] + POINT_AMBIENCE_RIVER_FILL_RANGE, world.maxx)
	var/region_max_y = min(changed_bounds[RIVER_FILL_BOX_MAX_Y] + POINT_AMBIENCE_RIVER_FILL_RANGE, world.maxy)
	var/list/rebuilt_marks = scratch_marks
	rebuilt_marks.Cut()
	var/turf/seed_search_min = locate(max(region_min_x - POINT_AMBIENCE_RIVER_FILL_RANGE, 1), max(region_min_y - POINT_AMBIENCE_RIVER_FILL_RANGE, 1), region_z)
	var/turf/seed_search_max = locate(min(region_max_x + POINT_AMBIENCE_RIVER_FILL_RANGE, world.maxx), min(region_max_y + POINT_AMBIENCE_RIVER_FILL_RANGE, world.maxy), region_z)
	mark_water_seeds(rebuilt_marks, block(seed_search_min, seed_search_max), seeds)
	propagate_reach(rebuilt_marks, TRUE, region_min_x, region_min_y, region_max_x, region_max_y)
	wake_changed_listeners(rebuilt_marks, region_z, region_min_x, region_min_y, region_max_x, region_max_y)
	publish_region(rebuilt_marks, region_z, region_min_x, region_min_y, region_max_x, region_max_y)
	rebuilt_marks.Cut()

/**
 * Takes the first dirty turf and every other dirty turf that fits in one box with it.
 *
 * A box spans at most twice the reach on each axis. Turfs that do not fit stay dirty for the next
 * call. Returns z, min x, min y, max x, max y in RIVER_FILL_BOX_* field order.
 */
/datum/point_ambience_river_fill/proc/take_dirty_box()
	PRIVATE_PROC(TRUE)
	var/list/changed_turfs = dirty
	dirty = list()
	var/turf/first_changed = changed_turfs[1]
	var/changed_z = first_changed.z
	var/changed_min_x = first_changed.x
	var/changed_min_y = first_changed.y
	var/changed_max_x = first_changed.x
	var/changed_max_y = first_changed.y
	for(var/turf/changed as anything in changed_turfs)
		var/fits = changed.z == changed_z \
			&& max(changed_max_x, changed.x) - min(changed_min_x, changed.x) <= POINT_AMBIENCE_RIVER_FILL_RANGE * 2 \
			&& max(changed_max_y, changed.y) - min(changed_min_y, changed.y) <= POINT_AMBIENCE_RIVER_FILL_RANGE * 2
		if(!fits)
			dirty[changed] = TRUE
			continue
		changed_min_x = min(changed_min_x, changed.x)
		changed_min_y = min(changed_min_y, changed.y)
		changed_max_x = max(changed_max_x, changed.x)
		changed_max_y = max(changed_max_y, changed.y)
	return list(changed_z, changed_min_x, changed_min_y, changed_max_x, changed_max_y)

/**
 * Marks candidate water seeds at cost zero and queues unblocked seeds for propagation.
 *
 * When eligible_seeds is supplied, only its members qualify. Regional builds use this to filter a
 * local block instead of traversing the full seed registry.
 */
/datum/point_ambience_river_fill/proc/mark_water_seeds(list/working_marks, list/candidate_turfs, list/eligible_seeds)
	PRIVATE_PROC(TRUE)
	var/list/seed_frontier = buckets[1]
	for(var/turf/water as anything in candidate_turfs)
		if(eligible_seeds && !eligible_seeds[water])
			continue
		var/blocked = !!RIVER_FILL_BLOCKED(water)
		working_marks[water] = RIVER_FILL_MARK(0, blocked)
		if(!blocked)
			seed_frontier += water

/// Queues a service for every listener in the region whose audible river answer the new marks change.
/// Both blocked and absent mean silence, so a change between those two wakes nobody
/datum/point_ambience_river_fill/proc/wake_changed_listeners(list/new_marks, z, low_x, low_y, high_x, high_y)
	PRIVATE_PROC(TRUE)
	for(var/client/listener_client as anything in GLOB.clients)
		var/mob/listener = listener_client?.mob
		if(!listener || isobserver(listener) || isnewplayer(listener))
			continue
		var/turf/listener_turf = get_turf(listener_client.point_ambience.ear || listener)
		var/in_region = listener_turf?.z == z && ISINRANGE(listener_turf.x, low_x, high_x) && ISINRANGE(listener_turf.y, low_y, high_y)
		if(!in_region)
			continue
		var/old_mark = marks[listener_turf]
		var/new_mark = new_marks[listener_turf]
		var/old_cost = RIVER_FILL_HEARD_COST(old_mark)
		var/new_cost = RIVER_FILL_HEARD_COST(new_mark)
		if(old_cost != new_cost || isnull(old_cost) != isnull(new_cost))
			SSpoint_ambience.mark_listener(listener_client)

/// Copies the region's new marks over the published ones, marks that disappeared included. Nulling
/// retains existing turf keys without reindexing the map, and untouched ground gets no new key
/datum/point_ambience_river_fill/proc/publish_region(list/new_marks, z, low_x, low_y, high_x, high_y)
	PRIVATE_PROC(TRUE)
	for(var/turf/replaced as anything in block(locate(low_x, low_y, z), locate(high_x, high_y, z)))
		var/old_mark = marks[replaced]
		var/new_mark = new_marks[replaced]
		if(isnull(old_mark) && isnull(new_mark))
			continue
		marked_tiles += isnull(old_mark) - isnull(new_mark)
		marks[replaced] = new_mark

/**
 * Propagates river reach through neighboring turfs, visiting cheaper paths first.
 *
 * The loops visit path cost, turfs queued at that cost, then eight neighbors of each turf.
 * Cost buckets run from 0 through the fixed budget. No sorting or per-turf list allocation is needed.
 * Cheaper arrivals replace earlier marks. Queued entries whose cost has since improved are skipped.
 *
 * Cardinals N, E, S, W cost 2 and precede diagonals NE, SE, SW, NW, which cost 3. A diagonal needs
 * one open cardinal flank. The cardinal pass overwrites all four reused flank states, including
 * missing neighbors. Keep these writes before the distance and pruning skips, since diagonals
 * need the current turf's flank states even when those neighbors need no new marks.
 *
 * working_marks holds this construction's costs and blocker bits, never an older published field.
 * With prune_to_region set, discard paths whose remaining budget cannot reach the replacement box.
 * The lower bound is twice the Chebyshev gap. Routes may leave the box and return to it.
 */
/datum/point_ambience_river_fill/proc/propagate_reach(list/working_marks, prune_to_region = FALSE, low_x, low_y, high_x, high_y)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/static/list/neighbor_offsets = list(
		0, 1, // N
		1, 0, // E
		0, -1, // S
		-1, 0, // W
		1, 1, // NE
		1, -1, // SE
		-1, -1, // SW
		-1, 1 // NW
	)
	var/static/list/diagonal_flanks = list(
		1, 2, // NE uses N or E
		3, 2, // SE uses S or E
		3, 4, // SW uses S or W
		1, 4 // NW uses N or W
	)
	var/list/cardinal_open = scratch_open
	for(var/path_cost in 0 to POINT_AMBIENCE_RIVER_FILL_BUDGET)
		var/list/cost_frontier = buckets[path_cost + 1]
		for(var/turf/current_turf as anything in cost_frontier)
			if(RIVER_FILL_COST(working_marks[current_turf]) != path_cost || path_cost + RIVER_FILL_CARDINAL > POINT_AMBIENCE_RIVER_FILL_BUDGET)
				continue
			for(var/neighbor_index in 1 to RIVER_FILL_NEIGHBOR_COUNT)
				var/is_diagonal = neighbor_index > RIVER_FILL_CARDINAL_COUNT
				var/neighbor_cost = path_cost + (is_diagonal ? RIVER_FILL_DIAGONAL : RIVER_FILL_CARDINAL)
				if(is_diagonal)
					var/has_open_flank = cardinal_open[diagonal_flanks[RIVER_FILL_FIRST_FLANK_INDEX(neighbor_index)]] || cardinal_open[diagonal_flanks[RIVER_FILL_SECOND_FLANK_INDEX(neighbor_index)]]
					if(neighbor_cost > POINT_AMBIENCE_RIVER_FILL_BUDGET || !has_open_flank)
						continue

				var/turf/neighbour = locate(current_turf.x + neighbor_offsets[neighbor_index * 2 - 1], current_turf.y + neighbor_offsets[neighbor_index * 2], current_turf.z)
				if(!neighbour)
					if(!is_diagonal)
						cardinal_open[neighbor_index] = FALSE
					continue
				var/known_mark = working_marks[neighbour]
				var/blocked = isnull(known_mark) ? !!RIVER_FILL_BLOCKED(neighbour) : (known_mark & RIVER_FILL_BLOCKED_BIT)
				if(!is_diagonal)
					cardinal_open[neighbor_index] = !blocked

				if(!isnull(known_mark) && RIVER_FILL_COST(known_mark) <= neighbor_cost)
					continue
				if(prune_to_region)
					var/region_gap = max(low_x - neighbour.x, neighbour.x - high_x, low_y - neighbour.y, neighbour.y - high_y, 0)
					if(region_gap * RIVER_FILL_CARDINAL > POINT_AMBIENCE_RIVER_FILL_BUDGET - neighbor_cost)
						continue

				working_marks[neighbour] = RIVER_FILL_MARK(neighbor_cost, blocked)
				if(!blocked)
					var/list/next_frontier = buckets[neighbor_cost + 1]
					next_frontier += neighbour
		cost_frontier.Cut()

/**
 * Rebuilds dirty river regions until the subsystem tick budget is exhausted.
 *
 * Each box is completed before the tick check. Remaining boxes stay dirty for the next fire.
 */
/datum/controller/subsystem/point_ambience/proc/rebuild_river_fill()
	PRIVATE_PROC(TRUE)
	river_fill.next = world.time + door_recheck_period
	while(length(river_fill.dirty))
		river_fill.rebuild_box()
		if(length(river_fill.dirty) && MC_TICK_CHECK)
			river_fill.next = world.time
			return

#undef RIVER_FILL_BLOCKED
#undef RIVER_FILL_HEARD_COST
#undef RIVER_FILL_CARDINAL
#undef RIVER_FILL_DIAGONAL
#undef RIVER_FILL_CARDINAL_COUNT
#undef RIVER_FILL_NEIGHBOR_COUNT
#undef RIVER_FILL_BOX_Z
#undef RIVER_FILL_BOX_MIN_X
#undef RIVER_FILL_BOX_MIN_Y
#undef RIVER_FILL_BOX_MAX_X
#undef RIVER_FILL_BOX_MAX_Y
#undef RIVER_FILL_FIRST_FLANK_INDEX
#undef RIVER_FILL_SECOND_FLANK_INDEX
