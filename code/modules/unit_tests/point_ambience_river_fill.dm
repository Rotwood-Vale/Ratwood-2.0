/// Exercises the production fill without exposing its private build procs in normal builds
/datum/controller/subsystem/point_ambience/proc/unit_test_river_fill(rebuild = FALSE)
	if(rebuild)
		while(length(river_fill_dirty))
			river_fill_rebuild()
	else
		river_fill_build()

/// Weighted reach, silent blockers, local reconstruction and live tuning must agree
/datum/unit_test/point_ambience_river_fill
	var/list/saved_fill_state = list()
	var/list/saved_turfs = list()

/datum/unit_test/point_ambience_river_fill/Run()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	for(var/field in list("river_fill_marks", "river_fill_seeds", "river_fill_dirty", "river_fill_buckets", "river_fill_scratch_marks", "river_fill_scratch_open", "river_fill_done", "river_fill_next", "river_fill_marked_tiles", "river_fill_rebuilds", "river_fill_boot_ms", "mode"))
		saved_fill_state[field] = ambience.vars[field]
	ambience.mode = POINT_AMBIENCE_OFF
	ambience.river_fill_marks = list()
	ambience.river_fill_seeds = list()
	ambience.river_fill_dirty = list()
	ambience.river_fill_buckets = list()
	for(var/cost in 0 to POINT_AMBIENCE_RIVER_FILL_BUDGET)
		ambience.river_fill_buckets += list(list())
	ambience.river_fill_scratch_marks = list()
	ambience.river_fill_scratch_open = list(FALSE, FALSE, FALSE, FALSE)
	ambience.river_fill_done = FALSE

	var/turf/seed = locate(run_loc_floor_bottom_left.x + 2, run_loc_floor_bottom_left.y + 2, run_loc_floor_bottom_left.z)
	var/turf/north = get_step(seed, NORTH)
	var/turf/east = get_step(seed, EAST)
	var/turf/diagonal = get_step(seed, NORTHEAST)
	TEST_ASSERT(diagonal && !diagonal.opacity, "The fixture needs an open corner")
	for(var/turf/changed as anything in list(seed, north, east))
		saved_turfs[changed] = list(changed.sound_door_count, changed.sound_opening_count)
		changed.sound_door_count = 0
		changed.sound_opening_count = 0
	ambience.river_fill_tile_added(seed)
	ambience.river_fill_tile_added(seed)
	TEST_ASSERT_EQUAL(length(ambience.river_fill_seeds), 1, "Seed registration must be idempotent")
	ambience.unit_test_river_fill()
	TEST_ASSERT_EQUAL(ambience.river_fill_marks[seed], 0, "Zero must remain an audible seed, not an absent mark")
	TEST_ASSERT(RIVER_FILL_AUDIBLE(ambience.river_fill_marks[seed]), "The seed must play")
	TEST_ASSERT_EQUAL(RIVER_FILL_COST(ambience.river_fill_marks[north]), 2, "Cardinal steps cost two half-steps")
	TEST_ASSERT_EQUAL(RIVER_FILL_COST(ambience.river_fill_marks[diagonal]), 3, "Diagonal steps cost three half-steps")
	for(var/turf/marked as anything in ambience.river_fill_marks)
		TEST_ASSERT_EQUAL(marked.z, seed.z, "A fill must never cross floors")
		TEST_ASSERT(RIVER_FILL_COST(ambience.river_fill_marks[marked]) <= POINT_AMBIENCE_RIVER_FILL_BUDGET, "No mark may exceed the budget")
	for(var/list/bucket as anything in ambience.river_fill_buckets)
		TEST_ASSERT_EQUAL(length(bucket), 0, "Reusable buckets must release their turf references")

	// Door counters alone block river reach, even if the underlying turf is transparent
	north.sound_door_count = 1
	ambience.river_fill_turf_changed(north)
	ambience.unit_test_river_fill(TRUE)
	TEST_ASSERT_NOTNULL(ambience.river_fill_marks[north], "A boundary blocker must retain invalidation metadata")
	TEST_ASSERT(!RIVER_FILL_AUDIBLE(ambience.river_fill_marks[north]), "Doorway tiles must be silent")
	TEST_ASSERT_EQUAL(RIVER_FILL_COST(ambience.river_fill_marks[diagonal]), 3, "One open flank permits the diagonal")
	east.sound_opening_count = 1
	ambience.river_fill_turf_changed(east)
	ambience.unit_test_river_fill(TRUE)
	TEST_ASSERT(RIVER_FILL_COST(ambience.river_fill_marks[diagonal]) > 3, "Two blocked flanks must force a detour")
	var/list/regional = ambience.river_fill_marks.Copy()
	ambience.unit_test_river_fill()
	for(var/turf/marked as anything in (regional | ambience.river_fill_marks))
		TEST_ASSERT_EQUAL(regional[marked], ambience.river_fill_marks[marked], "Local barrier reconstruction must match a fresh build")
		TEST_ASSERT_EQUAL(isnull(regional[marked]), isnull(ambience.river_fill_marks[marked]), "A zero-cost mark must not compare equal to missing coverage")

	north.sound_door_count = 0
	east.sound_opening_count = 0
	ambience.river_fill_turf_changed(north)
	ambience.river_fill_turf_changed(east)
	ambience.unit_test_river_fill(TRUE)
	TEST_ASSERT_EQUAL(RIVER_FILL_COST(ambience.river_fill_marks[diagonal]), 3, "Removing barriers must restore the shorter path")
	seed.sound_opening_count = 1
	ambience.river_fill_turf_changed(seed)
	ambience.unit_test_river_fill(TRUE)
	TEST_ASSERT_EQUAL(ambience.river_fill_marked_tiles, 1, "A blocked seed must not expand, and old reach must be cleared")
	TEST_ASSERT(!RIVER_FILL_AUDIBLE(ambience.river_fill_marks[seed]), "A blocked seed must be silent")
	ambience.river_fill_tile_removed(seed)
	ambience.unit_test_river_fill(TRUE)
	TEST_ASSERT_EQUAL(ambience.river_fill_marked_tiles, 0, "Removing the final seed must clear its marks")
	TEST_ASSERT_NULL(ambience.river_fill_marks[seed], "The removed seed must not remain audible")
	seed.sound_opening_count = 0
	ambience.river_fill_tile_added(seed)
	ambience.unit_test_river_fill(TRUE)
	TEST_ASSERT_EQUAL(ambience.river_fill_marks[seed], 0, "Adding water to an unmarked region must restore coverage")

	// A plain new, since allocate() builds atoms on a turf and runtimes on a datum
	var/datum/point_ambience_category/river/river = new
	TEST_ASSERT(!river.vv_edit_var("range", 12), "Range edits must not diverge from the fixed fill budget")
	TEST_ASSERT_EQUAL(river.range, POINT_AMBIENCE_RIVER_FILL_RANGE, "Refused edits must preserve reach")
	TEST_ASSERT(!river.vv_edit_var("falloff_exponent", 0), "The live curve cannot have a zero exponent")
	TEST_ASSERT(river.vv_edit_var("falloff_exponent", 1), "A positive river exponent must remain editable")
	TEST_ASSERT_EQUAL(river.inv_falloff_exponent, 1, "A curve edit must refresh the send's reciprocal")
	TEST_ASSERT(river.vv_edit_var("min_volume", 4.5), "River floor must remain editable")
	TEST_ASSERT_EQUAL(river.floor_ratio, 0.1, "A floor edit must update the ratio used by the send")
	qdel(river)

/datum/unit_test/point_ambience_river_fill/Destroy()
	for(var/turf/changed as anything in saved_turfs)
		var/list/state = saved_turfs[changed]
		changed.sound_door_count = state[1]
		changed.sound_opening_count = state[2]
	for(var/field in saved_fill_state)
		SSpoint_ambience.vars[field] = saved_fill_state[field]
	return ..()
