// Regression checks for the passenger/mount movement relationship.
/datum/unit_test/mountable_movement/Run()
	var/mob/living/carbon/human/mount = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/rider = allocate(/mob/living/carbon/human/consistent)
	var/mob/living/carbon/human/bystander = allocate(/mob/living/carbon/human/consistent)
	var/turf/start = run_loc_floor_bottom_left
	var/turf/destination = get_step(start, NORTH)
	mount.forceMove(start)
	rider.forceMove(start)
	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "Could not mount the test rider")

	// A thrown mount should pass its own rider, but not unrelated standing mobs.
	mount.throwing = new /datum/thrownthing(mount)
	rider.density = TRUE
	rider.mobility_flags |= MOBILITY_STAND
	bystander.density = TRUE
	bystander.mobility_flags |= MOBILITY_STAND
	var/pass_rider = rider.CanPass(mount, start)
	var/pass_bystander = bystander.CanPass(mount, start)
	bystander.forceMove(destination)
	var/hit_passenger = mount.throwing.hitcheck()
	QDEL_NULL(mount.throwing)
	TEST_ASSERT(!hit_passenger, "The throw hit check collided with an attached passenger")
	TEST_ASSERT(pass_rider, "The jumping mount collided with its rider")
	TEST_ASSERT(!pass_bystander, "The jumping mount could pass unrelated standing mobs")

	var/datum/component/riding/riding = mount.GetComponent(/datum/component/riding)
	TEST_ASSERT_EQUAL(riding.driver, rider, "The mounted rider was not registered as driver")
	rider.m_intent = MOVE_INTENT_RUN
	riding.riding_xp_move_counter = 0
	// Forced transport must synchronize passengers without earning steering XP.
	mount.forceMove(destination)
	TEST_ASSERT_EQUAL(riding.riding_xp_move_counter, 0, "Forced movement awarded steering XP")
	TEST_ASSERT_EQUAL(rider.last_mount_move_time, world.time, "Mount movement timestamp was not recorded")
	TEST_ASSERT_EQUAL(rider.loc, mount.loc, "Forced movement left the rider behind")
	TEST_ASSERT_EQUAL(rider.buckled, mount, "Forced movement broke the buckle")
	TEST_ASSERT(!rider.can_zFall(destination, 1), "A mounted passenger can fall independently")

	rider.mind_initialize()
	var/datum/skill/riding_skill = GetSkillRef(/datum/skill/misc/riding)
	var/datum/skill_holder/rider_skills = rider.ensure_skills()
	var/starting_xp = rider_skills.skill_experience[riding_skill]
	bystander.forceMove(run_loc_floor_top_right)
	riding.riding_xp_move_counter = 0
	for(var/i in 1 to 5)
		riding.last_vehicle_move = -1000
		mount.Move(mount.loc == start ? destination : start, mount.loc == start ? NORTH : SOUTH)
	TEST_ASSERT_EQUAL(rider_skills.skill_experience[riding_skill], starting_xp, "Player transport awarded Riding XP")
	mount.forceMove(destination)
	mount.unbuckle_mob(rider, TRUE)
	mount.forceMove(start)
	TEST_ASSERT_EQUAL(rider.loc, destination, "A dismounted rider still follows the mount")
