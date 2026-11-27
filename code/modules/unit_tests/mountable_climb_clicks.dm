// Integration regression: real click parameters, real climbing and real do_after.
// The previous dispatch-only spies missed attack_hand's second-argument contract.
/turf/closed/wall/mountable_click_test
	wallclimb = TRUE
	climbdiff = 0

/datum/unit_test/mountable_climb_clicks
	var/list/changed_turfs = list()

/datum/unit_test/mountable_climb_clicks/Destroy()
	for(var/turf/changed as anything in changed_turfs)
		changed.ChangeTurf(/turf/closed/void)
	return ..()

/datum/unit_test/mountable_climb_clicks/Run()
	var/datum/space_level/lower = SSmapping.add_new_zlevel("Mountable climb test lower", list(ZTRAIT_UP = TRUE))
	var/datum/space_level/upper = SSmapping.add_new_zlevel("Mountable climb test upper", list(ZTRAIT_DOWN = TRUE))
	for(var/z_value in list(lower.z_value, upper.z_value))
		for(var/turf/T in block(locate(9, 9, z_value), locate(12, 12, z_value)))
			changed_turfs += T.ChangeTurf(/turf/open/floor/rogue/naturalstone)
	var/turf/start = locate(10, 10, lower.z_value)
	var/turf/wall = locate(10, 11, lower.z_value)
	wall = wall.ChangeTurf(/turf/closed/wall/mountable_click_test)
	var/turf/open/transparent/openspace/gap = locate(10, 10, upper.z_value)
	gap = gap.ChangeTurf(/turf/open/transparent/openspace)
	var/turf/landing = locate(10, 11, upper.z_value)
	var/mob/living/carbon/human/mountable_pilot_test/mount = allocate(/mob/living/carbon/human/mountable_pilot_test, start)
	var/mob/living/carbon/human/rider = allocate(/mob/living/carbon/human/consistent, start)
	mount.mind_initialize()
	rider.mind_initialize()
	mount.adjust_skillrank(/datum/skill/misc/climbing, SKILL_LEVEL_LEGENDARY, TRUE)
	mount.physiology.do_after_speed = 0.1
	mount.used_hand = 1
	rider.used_hand = 1
	var/click_params = "icon-x=16;icon-y=16;left=1;button=left"
	TEST_ASSERT_EQUAL(get_step_multiz(start, UP), gap, "Test levels did not connect")
	// Unmounted ordinary clicks: a params string must never become a callback.
	mount.ClickOn(wall, click_params)
	TEST_ASSERT_EQUAL(mount.loc, landing, "Normal wall click did not complete climb")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Normal climb leaked busy state/progress bars")
	mount.next_move = 0
	mount.next_click = 0
	mount.ClickOn(gap, click_params)
	TEST_ASSERT_EQUAL(mount.loc, start, "Normal open-space click did not climb down")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Downward climb leaked busy state/progress bars")
	TEST_ASSERT(do_after(mount, 2, target = mount), "Timed action failed after solo climbs")

	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "Could not mount integration-test rider")
	var/datum/component/riding/human/riding = mount.GetComponent(/datum/component/riding)
	// The mount's own click while carrying must remain functional.
	mount.next_move = 0
	mount.next_click = 0
	mount.ClickOn(wall, click_params)
	TEST_ASSERT_EQUAL(mount.loc, landing, "Mount's own climb failed with passenger")
	TEST_ASSERT_EQUAL(rider.loc, landing, "Passenger did not follow mount's climb")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Mount's own climb leaked state")
	mount.next_move = 0
	rider.next_move = 0
	rider.next_click = 0
	rider.ClickOn(gap, click_params)
	TEST_ASSERT_EQUAL(mount.loc, start, "Passenger open-space click did not descend")
	TEST_ASSERT_EQUAL(rider.loc, start, "Passenger did not follow descent")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Piloted descent leaked state")

	for(var/i in 1 to 2)
		mount.next_move = 0
		rider.next_move = 0
		rider.next_click = 0
		rider.ClickOn(wall, click_params)
		TEST_ASSERT_EQUAL(mount.loc, landing, "Repeated pilot climb failed")
		TEST_ASSERT_EQUAL(rider.loc, landing, "Repeated pilot climb separated passenger")
		TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Pilot climb accumulated bars")
		mount.next_move = 0
		rider.next_move = 0
		rider.next_click = 0
		rider.ClickOn(gap, click_params)
		TEST_ASSERT_EQUAL(mount.loc, start, "Repeated descent failed")
		TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Pilot descent accumulated bars")
	TEST_ASSERT(do_after(mount, 2, target = mount), "Mount timed action remained locked after climbing")
	TEST_ASSERT(do_after(rider, 2, target = rider), "Rider timed action remained locked after climbing")
	TEST_ASSERT(riding.handle_ride(rider, EAST), "Steering remained blocked after climbs")
	TEST_ASSERT_EQUAL(mount.received_direction, EAST, "Post-climb steering did not reach mount")

	// Real wall traversal and descent, not a dispatch spy.
	mount.forceMove(landing)
	var/turf/side_wall = locate(11, 12, upper.z_value)
	side_wall = side_wall.ChangeTurf(/turf/closed/wall/mountable_click_test)
	var/turf/open/transparent/openspace/traverse = locate(11, 11, upper.z_value)
	traverse = traverse.ChangeTurf(/turf/open/transparent/openspace)
	mount.next_move = 0
	traverse.MouseDrop_T(rider, rider)
	TEST_ASSERT_EQUAL(mount.loc, traverse, "Real piloted wall traversal failed")
	TEST_ASSERT_EQUAL(rider.loc, traverse, "Wall traversal left passenger behind")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Wall traversal leaked action state")
	TEST_ASSERT(istype(mount.get_active_held_item(), /obj/item/clothing/wall_grab), "Traversal should occupy the climbing hand")
	// As with normal climbing, select the free hand for the next click.
	mount.swap_hand()
	TEST_ASSERT(!mount.get_active_held_item(), "No free hand for descent")
	var/turf/open/transparent/openspace/down_gap = locate(11, 10, upper.z_value)
	down_gap = down_gap.ChangeTurf(/turf/open/transparent/openspace)
	mount.next_move = 0
	rider.next_move = 0
	rider.next_click = 0
	rider.ClickOn(down_gap, click_params)
	TEST_ASSERT_EQUAL(mount.loc, locate(11, 10, lower.z_value), "Could not descend after wall traversal")
	TEST_ASSERT_EQUAL(rider.loc, mount.loc, "Post-traversal descent separated passenger")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Post-traversal descent leaked state")
	mount.forceMove(start)

	// Real climb cancellation must clean up before a later action can begin.
	mount.next_move = 0
	rider.next_move = 0
	rider.next_click = 0
	mount.physiology.do_after_speed = 1
	addtimer(CALLBACK(mount, TYPE_PROC_REF(/mob/living/carbon/human, toggle_rider_steering)), 2)
	rider.ClickOn(wall, click_params)
	TEST_ASSERT_EQUAL(mount.loc, start, "Canceled pilot climb still moved mount")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Canceled climb leaked busy state/bars")
	TEST_ASSERT(do_after(mount, 2, target = mount), "Timed actions failed after canceled climb")
	mount.toggle_rider_steering()
	TEST_ASSERT(riding.handle_ride(rider, EAST), "Steering failed after canceled climb")

	// Walking over a cliff must restore the passive passenger's own movement.
	mount.remove_status_effect(/datum/status_effect/debuff/climbing_lfwb)
	mount.forceMove(landing)
	mount.Move(gap, SOUTH)
	TEST_ASSERT_EQUAL(mount.loc, start, "Cliff fall did not reach lower floor")
	TEST_ASSERT_NULL(rider.buckled, "Cliff impact did not dismount passenger")
	TEST_ASSERT(rider.mobility_flags & MOBILITY_MOVE, "Passenger lost movement after cliff dismount")
	TEST_ASSERT(!rider.anchored && !rider.force_moving && !rider.doing, "Passenger retained a movement/action lock")
	TEST_ASSERT(rider.Move(get_step(start, EAST), EAST), "Passenger could not walk away after fall")
	TEST_ASSERT(do_after(rider, 2, target = rider), "Passenger timed action failed after fall")

	// Match the reported pair: Arachnid mount and Fluvian passenger, no rider input.
	var/mob/living/carbon/human/species/arachnid/spider = allocate(/mob/living/carbon/human/species/arachnid, landing)
	var/mob/living/carbon/human/species/moth/fluvian = allocate(/mob/living/carbon/human/species/moth, landing)
	ADD_TRAIT(spider, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(spider.buckle_mob(fluvian, TRUE), "Could not mount Fluvian passenger")
	spider.Move(gap, SOUTH)
	TEST_ASSERT_EQUAL(spider.loc, start, "Arachnid did not reach cliff bottom")
	TEST_ASSERT_NULL(fluvian.buckled, "Fluvian remained attached after impact")
	TEST_ASSERT(fluvian.mobility_flags & MOBILITY_MOVE, "Fluvian lost movement after dismount")
	TEST_ASSERT(!fluvian.anchored && !fluvian.force_moving && !fluvian.doing && !fluvian.pulledby, "Fluvian retained a movement/action lock")
	TEST_ASSERT(fluvian.Move(get_step(start, WEST), WEST), "Fluvian could not walk away after impact")
	TEST_ASSERT(do_after(fluvian, 2, target = fluvian), "Fluvian could not perform a timed action after impact")

	// Trees have an object click handler separate from the wall and open-space handlers.
	var/obj/structure/flora/newbranch/branch = allocate(/obj/structure/flora/newbranch, gap)
	mount = allocate(/mob/living/carbon/human/mountable_pilot_test, start)
	rider = allocate(/mob/living/carbon/human/consistent, start)
	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	mount.used_hand = 1
	rider.used_hand = 1
	mount.physiology.do_after_speed = 0.1
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "Could not mount for the tree test")
	for(var/tree_type in list(/obj/structure/flora/newtree, /obj/structure/flora/newtreealt))
		var/obj/structure/flora/tree = allocate(tree_type, get_step(start, EAST))
		mount.next_move = 0
		rider.next_move = 0
		rider.next_click = 0
		rider.ClickOn(tree, click_params)
		TEST_ASSERT_EQUAL(mount.loc, gap, "Rider tree click did not climb with the mount")
		TEST_ASSERT_EQUAL(rider.loc, gap, "Rider did not follow the mount up the tree")
		mount.forceMove(start)
		qdel(tree)
	mount.physiology.do_after_speed = 1
	var/obj/structure/flora/newtree/tree = allocate(/obj/structure/flora/newtree, get_step(start, EAST))
	mount.next_move = 0
	rider.next_move = 0
	rider.next_click = 0
	addtimer(CALLBACK(mount, TYPE_PROC_REF(/mob/living/carbon/human, toggle_rider_steering)), 2)
	rider.ClickOn(tree, click_params)
	TEST_ASSERT_EQUAL(mount.loc, start, "Tree climb completed after steering was revoked")
	TEST_ASSERT_EQUAL(rider.loc, start, "Tree climb moved rider after steering was revoked")
	TEST_ASSERT(!mount.doing && !LAZYLEN(mount.progressbars), "Tree climb left the mount busy")
	qdel(branch)
