/// The door count a sound occlusion walk trusts, and what a walk makes of a door shut, open and gone
/datum/unit_test/point_ambience_doors

/datum/unit_test/point_ambience_doors/Run()
	var/turf/listener = locate(run_loc_floor_bottom_left.x + 1, run_loc_floor_bottom_left.y + 1, run_loc_floor_bottom_left.z)
	var/turf/door_turf = locate(listener.x + 2, listener.y, listener.z)
	var/turf/source = locate(listener.x + 4, listener.y, listener.z)
	var/turf/aside = locate(door_turf.x, door_turf.y + 1, door_turf.z)
	TEST_ASSERT_NOTNULL(source, "The test needs five tiles in a row")
	TEST_ASSERT_EQUAL(door_turf.sound_door_count, 0, "A bare floor must hold no door")

	var/obj/structure/mineral_door/door = allocate(/obj/structure/mineral_door, door_turf)
	TEST_ASSERT_EQUAL(door_turf.sound_door_count, 1, "A door created on a turf must be counted there")
	TEST_ASSERT(door.opacity, "A mineral door must start shut and opaque")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_LIVE), OCCLUSION_SOLID, "A shut door on the line must block a live walk")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_FLANKS), OCCLUSION_CLEAR, "The corner rule alone must let the line through a shut door")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6), OCCLUSION_CLEAR, "A walk told nothing of doors must ignore them")

	door.set_opacity(FALSE)
	door.door_opened = TRUE
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_LIVE), OCCLUSION_CLEAR, "An open door must let a live walk through")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_ALWAYS), OCCLUSION_SOLID, "An open door that shuts solid must still block when every door counts")
	door.door_opened = FALSE
	door.set_opacity(TRUE)

	door.forceMove(aside)
	TEST_ASSERT_EQUAL(door_turf.sound_door_count, 0, "A door moved off must leave no count behind")
	TEST_ASSERT_EQUAL(aside.sound_door_count, 1, "A moved door must be counted where it lands")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_LIVE), OCCLUSION_CLEAR, "A line the door has left must be clear")

	qdel(door)
	TEST_ASSERT_EQUAL(aside.sound_door_count, 0, "A deleted door must leave no count behind")

/datum/unit_test/point_ambience_doors/Destroy()
	// The opacity changes above report the door, and nothing should be gathered for a test
	SSpoint_ambience.changed_doors.Cut()
	return ..()
