/// The door count a sound occlusion walk trusts, and what a walk makes of a door shut, open and gone
/datum/unit_test/point_ambience_doors
	var/saved_mode
	var/saved_door_mode
	var/saved_door_recheck
	var/saved_hooked_logins
	var/saved_door_changes
	var/list/saved_changed_doors

/datum/unit_test/point_ambience_doors/Run()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	saved_mode = ambience.mode
	saved_door_mode = ambience.door_mode
	saved_door_recheck = ambience.door_recheck
	saved_hooked_logins = ambience.hooked_logins
	saved_door_changes = ambience.door_changes
	saved_changed_doors = ambience.changed_doors
	ambience.mode = POINT_AMBIENCE_LIVE
	ambience.door_mode = SOUND_DOORS_LIVE
	ambience.door_recheck = TRUE
	ambience.hooked_logins = TRUE
	ambience.changed_doors = list()

	var/turf/listener = locate(run_loc_floor_bottom_left.x + 1, run_loc_floor_bottom_left.y + 1, run_loc_floor_bottom_left.z)
	var/turf/door_turf = locate(listener.x + 2, listener.y, listener.z)
	var/turf/source = locate(listener.x + 3, listener.y, listener.z)
	var/turf/aside = locate(door_turf.x, door_turf.y + 1, door_turf.z)
	TEST_ASSERT(source && !source.opacity, "The test needs four open tiles in a row")
	TEST_ASSERT_EQUAL(door_turf.sound_door_count, 0, "A bare floor must hold no door")

	var/obj/structure/mineral_door/door = allocate(/obj/structure/mineral_door, door_turf)
	TEST_ASSERT_EQUAL(door_turf.sound_door_count, 1, "A door created on a turf must be counted there")
	TEST_ASSERT(ambience.changed_doors[door_turf], "Creating a shut door must schedule a listener refresh")
	TEST_ASSERT(door.opacity, "A mineral door must start shut and opaque")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_LIVE), OCCLUSION_SOLID, "A shut door on the line must block a live walk")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_FLANKS), OCCLUSION_CLEAR, "The corner rule alone must let the line through a shut door")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6), OCCLUSION_CLEAR, "A walk told nothing of doors must ignore them")

	// Opening clears opacity before the animation and marks the door open after it
	door.set_opacity(FALSE)
	door.isSwitchingStates = TRUE
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_ALWAYS), OCCLUSION_SOLID, "A door still opening must block when every door counts")
	door.isSwitchingStates = FALSE
	door.door_opened = TRUE
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_LIVE), OCCLUSION_CLEAR, "An open door must let a live walk through")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_ALWAYS), OCCLUSION_SOLID, "An open door that shuts solid must still block when every door counts")
	door.door_opened = FALSE
	door.set_opacity(TRUE)

	ambience.changed_doors.Cut()
	door.forceMove(aside)
	TEST_ASSERT(ambience.changed_doors[door_turf], "Moving a shut door must refresh its old tile")
	TEST_ASSERT(ambience.changed_doors[aside], "Moving a shut door must refresh its new tile")
	TEST_ASSERT_EQUAL(door_turf.sound_door_count, 0, "A door moved off must leave no count behind")
	TEST_ASSERT_EQUAL(aside.sound_door_count, 1, "A moved door must be counted where it lands")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_LIVE), OCCLUSION_CLEAR, "A line the door has left must be clear")

	// An open mineral door still obstructs the ALWAYS mode, including when moved or removed.
	door.set_opacity(FALSE)
	door.door_opened = TRUE
	ambience.door_mode = SOUND_DOORS_ALWAYS
	ambience.changed_doors.Cut()
	door.forceMove(door_turf)
	TEST_ASSERT(ambience.changed_doors[aside], "Moving an open door in ALWAYS mode must refresh its old tile")
	TEST_ASSERT(ambience.changed_doors[door_turf], "Moving an open door in ALWAYS mode must refresh its new tile")
	ambience.changed_doors.Cut()
	qdel(door)
	TEST_ASSERT(ambience.changed_doors[door_turf], "Deleting an open door in ALWAYS mode must schedule a listener refresh")
	TEST_ASSERT_EQUAL(aside.sound_door_count, 0, "A deleted door must leave no count behind")
	TEST_ASSERT_EQUAL(door_turf.sound_door_count, 0, "The deleted door's last tile must hold no count")
	ambience.changed_doors.Cut()
	ambience.hooked_logins = FALSE
	ambience.door_changed(door_turf)
	TEST_ASSERT_EQUAL(length(ambience.changed_doors), 0, "Door changes before login hooks exist need no listener refresh")

/datum/unit_test/point_ambience_doors/Destroy()
	. = ..()
	SSpoint_ambience.mode = saved_mode
	SSpoint_ambience.door_mode = saved_door_mode
	SSpoint_ambience.door_recheck = saved_door_recheck
	SSpoint_ambience.hooked_logins = saved_hooked_logins
	SSpoint_ambience.door_changes = saved_door_changes
	SSpoint_ambience.changed_doors = saved_changed_doors

/// A gate spans three tiles and stands a blocker on each, and the blockers are what a walk reads there
/datum/unit_test/point_ambience_gate
	var/saved_door_changes
	var/list/saved_changed_doors

/datum/unit_test/point_ambience_gate/Run()
	saved_door_changes = SSpoint_ambience.door_changes
	saved_changed_doors = SSpoint_ambience.changed_doors
	SSpoint_ambience.changed_doors = list()
	var/turf/gate_turf = locate(run_loc_floor_bottom_left.x + 1, run_loc_floor_bottom_left.y + 2, run_loc_floor_bottom_left.z)
	var/turf/middle = locate(gate_turf.x + 1, gate_turf.y, gate_turf.z)
	var/turf/listener = locate(middle.x, middle.y - 1, middle.z)
	var/turf/source = locate(middle.x, middle.y + 1, middle.z)
	TEST_ASSERT(source && !source.opacity, "The test needs three open tiles across the gate's middle")

	var/obj/structure/gate/gate = allocate(/obj/structure/gate, gate_turf)
	TEST_ASSERT_EQUAL(length(gate.blockers), 3, "A shut gate must stand a blocker on each of its three tiles")
	// The gate's own bounds cover all three tiles, which puts it in each one's contents beside the blocker
	TEST_ASSERT_EQUAL(middle.sound_door_count, 2, "A gate's middle tile must count the gate and its blocker as doors")
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_LIVE), OCCLUSION_SOLID, "A shut gate across the line must block a live walk")

	// What open() does after its animation, without the sleep
	gate.set_opacity(FALSE)
	for(var/obj/gblock/blocker as anything in gate.blockers)
		blocker.set_opacity(FALSE)
	TEST_ASSERT_EQUAL(opacity_between(listener, source, 6, FALSE, null, SOUND_DOORS_LIVE), OCCLUSION_CLEAR, "An open gate must let a live walk through")

/datum/unit_test/point_ambience_gate/Destroy()
	. = ..()
	// The opacity changes above report the gate, and nothing a test did should be gathered
	SSpoint_ambience.door_changes = saved_door_changes
	SSpoint_ambience.changed_doors = saved_changed_doors
