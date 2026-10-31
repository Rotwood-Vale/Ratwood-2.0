/// Checks weighted river reach, blockers, local rebuilding and live tuning
/datum/unit_test/point_ambience_river_fill
	/// Isolated fill instance that leaves the live subsystem's river data untouched
	var/datum/point_ambience_river_fill/fill
	var/list/saved_turfs = list()

/// Drains dirty boxes to complete the rebuild synchronously for assertions
/datum/unit_test/point_ambience_river_fill/proc/rebuild_dirty()
	while(length(fill.dirty))
		fill.rebuild_box()

/datum/unit_test/point_ambience_river_fill/Run()
	fill = new
	var/turf/seed = locate(run_loc_floor_bottom_left.x + 2, run_loc_floor_bottom_left.y + 2, run_loc_floor_bottom_left.z)
	var/turf/north = get_step(seed, NORTH)
	var/turf/east = get_step(seed, EAST)
	var/turf/diagonal = get_step(seed, NORTHEAST)
	TEST_ASSERT(diagonal && !diagonal.opacity, "The fixture needs an open corner")
	for(var/turf/changed as anything in list(seed, north, east))
		saved_turfs[changed] = list(changed.sound_door_count, changed.sound_opening_count)
		changed.sound_door_count = 0
		changed.sound_opening_count = 0
	fill.tile_added(seed)
	fill.tile_added(seed)
	TEST_ASSERT_EQUAL(length(fill.seeds), 1, "Seed registration must be idempotent")
	fill.build()
	TEST_ASSERT_EQUAL(fill.marks[seed], 0, "Zero must remain an audible seed, not an absent mark")
	TEST_ASSERT(RIVER_FILL_AUDIBLE(fill.marks[seed]), "The seed must play")
	TEST_ASSERT_EQUAL(RIVER_FILL_COST(fill.marks[north]), 2, "Cardinal steps cost two half-steps")
	TEST_ASSERT_EQUAL(RIVER_FILL_COST(fill.marks[diagonal]), 3, "Diagonal steps cost three half-steps")
	for(var/turf/marked as anything in fill.marks)
		TEST_ASSERT_EQUAL(marked.z, seed.z, "A fill must never cross floors")
		TEST_ASSERT(RIVER_FILL_COST(fill.marks[marked]) <= POINT_AMBIENCE_RIVER_FILL_BUDGET, "No mark may exceed the budget")
	for(var/list/bucket as anything in fill.buckets)
		TEST_ASSERT_EQUAL(length(bucket), 0, "Reusable buckets must release their turf references")

	// Door counters alone block river reach, even if the underlying turf is transparent
	north.sound_door_count = 1
	fill.turf_changed(north)
	rebuild_dirty()
	TEST_ASSERT_NOTNULL(fill.marks[north], "A boundary blocker must retain invalidation metadata")
	TEST_ASSERT(!RIVER_FILL_AUDIBLE(fill.marks[north]), "Doorway tiles must be silent")
	TEST_ASSERT_EQUAL(RIVER_FILL_COST(fill.marks[diagonal]), 3, "One open flank permits the diagonal")
	east.sound_opening_count = 1
	fill.turf_changed(east)
	rebuild_dirty()
	TEST_ASSERT(RIVER_FILL_COST(fill.marks[diagonal]) > 3, "Two blocked flanks must force a detour")
	var/list/regional = fill.marks.Copy()
	fill.build()
	for(var/turf/marked as anything in (regional | fill.marks))
		TEST_ASSERT_EQUAL(regional[marked], fill.marks[marked], "Local barrier reconstruction must match a fresh build")
		TEST_ASSERT_EQUAL(isnull(regional[marked]), isnull(fill.marks[marked]), "A zero-cost mark must not compare equal to missing coverage")

	north.sound_door_count = 0
	east.sound_opening_count = 0
	fill.turf_changed(north)
	fill.turf_changed(east)
	rebuild_dirty()
	TEST_ASSERT_EQUAL(RIVER_FILL_COST(fill.marks[diagonal]), 3, "Removing barriers must restore the shorter path")
	seed.sound_opening_count = 1
	fill.turf_changed(seed)
	rebuild_dirty()
	TEST_ASSERT_EQUAL(fill.marked_tiles, 1, "A blocked seed must not expand, and old reach must be cleared")
	TEST_ASSERT(!RIVER_FILL_AUDIBLE(fill.marks[seed]), "A blocked seed must be silent")
	fill.tile_removed(seed)
	rebuild_dirty()
	TEST_ASSERT_EQUAL(fill.marked_tiles, 0, "Removing the final seed must clear its marks")
	TEST_ASSERT_NULL(fill.marks[seed], "The removed seed must not remain audible")
	seed.sound_opening_count = 0
	fill.tile_added(seed)
	rebuild_dirty()
	TEST_ASSERT_EQUAL(fill.marks[seed], 0, "Adding water to an unmarked region must restore coverage")

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
	QDEL_NULL(fill)
	return ..()
