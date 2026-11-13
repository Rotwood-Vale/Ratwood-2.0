/// The move service interval each pace gets, and the pace a rider is read at. The move hook and the
/// speed cutoff need a client, which a unit test cannot make, so those are checked in game
/datum/unit_test/point_ambience_speed
	var/saved_interval
	var/saved_running
	var/saved_steps
	var/saved_natural_run_step
	var/mob/living/carbon/human/rider

/datum/unit_test/point_ambience_speed/Run()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	saved_interval = ambience.move_service_interval
	saved_running = ambience.move_service_interval_running_override
	saved_steps = ambience.move_service_steps
	saved_natural_run_step = ambience.natural_run_step
	ambience.move_service_interval = 7
	ambience.move_service_interval_running_override = 5
	ambience.move_service_steps = 2
	ambience.natural_run_step = 1.5

	TEST_ASSERT_EQUAL(ambience.move_interval_for(3, FALSE), 6, "A speed 10 walker must be served every 2nd step")
	TEST_ASSERT_EQUAL(ambience.move_interval_for(2.5, FALSE), 5, "A speed 15 walker must be served every 2nd step")
	TEST_ASSERT_EQUAL(ambience.move_interval_for(3.3, FALSE), 6.5, "A step count must round down to the tick")
	TEST_ASSERT_EQUAL(ambience.move_interval_for(3.9, FALSE), 7, "The interval must cap a slow walker")
	TEST_ASSERT_EQUAL(ambience.move_interval_for(2, TRUE), 4, "A speed 10 runner must be served every 2nd step")
	TEST_ASSERT_EQUAL(ambience.move_interval_for(1.5, TRUE), 3, "A speed 15 runner must be served every 2nd step")
	TEST_ASSERT_EQUAL(ambience.move_interval_for(2.9, TRUE), 5, "The running override must cap a slow runner")
	TEST_ASSERT_EQUAL(ambience.move_interval_for(1, TRUE), 3, "A pace past a natural run must be paced as one")
	ambience.move_service_steps = 0
	TEST_ASSERT_EQUAL(ambience.move_interval_for(3, FALSE), 7, "No step limit must leave the interval alone")
	TEST_ASSERT_EQUAL(ambience.move_interval_for(1.5, TRUE), 5, "No step limit must leave the running override alone")

	rider = allocate(/mob/living/carbon/human/consistent)
	TEST_ASSERT_EQUAL(ambience.step_delay_of(rider), rider.cached_multiplicative_slowdown, "Someone on foot must be read at their own pace")
	var/obj/mount = allocate(/obj)
	var/datum/component/riding/riding = mount.AddComponent(/datum/component/riding)
	riding.vehicle_move_delay = 1.25
	rider.buckled = mount
	TEST_ASSERT_EQUAL(ambience.step_delay_of(rider), 1.25, "A rider must be read at the mount's pace")

/datum/unit_test/point_ambience_speed/Destroy()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	ambience.move_service_interval = saved_interval
	ambience.move_service_interval_running_override = saved_running
	ambience.move_service_steps = saved_steps
	ambience.natural_run_step = saved_natural_run_step
	// Set by hand rather than buckled, so nothing on the mount's side knows to let go
	if(rider)
		rider.buckled = null
		rider = null
	return ..()
