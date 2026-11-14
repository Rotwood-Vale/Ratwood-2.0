// Spies verify action dispatch without inventing a client for headless tests.
/mob/living/carbon/human/mountable_pilot_test
	parent_type = /mob/living/carbon/human/consistent
	var/received_direction
	var/jump_count = 0
	var/received_jump_range
	var/received_jump_cost
	var/relax_message_invisibility

/mob/living/carbon/human/mountable_pilot_test/visible_message(message, self_message, blind_message, vision_distance = DEFAULT_MESSAGE_RANGE, list/ignored_mobs, runechat_message = null, log_seen = NONE, log_seen_msg = null)
	if(findtext(message, "relax their posture again"))
		relax_message_invisibility = invisibility
	return ..()

/mob/living/carbon/human/mountable_pilot_test/execute_piloted_move(direction)
	received_direction = direction
	return TRUE

/mob/living/carbon/human/mountable_pilot_test/jump_action_resolve(atom/target, stamina_cost, jump_range, extra)
	jump_count++
	received_jump_range = jump_range
	received_jump_cost = stamina_cost

// These turfs record the actor at the entry to existing climbing logic.
/turf/closed/mountable_climb_test
	wallclimb = TRUE
	var/mob/actor

/turf/closed/mountable_climb_test/attack_hand(mob/user, params, datum/callback/pilot_check = null)
	if(!pilot_check)
		return ..()
	if(pilot_check.Invoke())
		actor = user
	return TRUE

/turf/open/transparent/openspace/mountable_climb_test
	var/mob/actor
	var/along_wall = FALSE

// The unit-test reservation has no connected level below it.
/turf/open/transparent/openspace/mountable_climb_test/show_bottom_level()
	return TRUE

/turf/open/transparent/openspace/mountable_climb_test/attack_hand(mob/user, params, datum/callback/pilot_check = null)
	if(!pilot_check)
		return ..()
	if(pilot_check.Invoke())
		actor = user
	return TRUE

/turf/open/transparent/openspace/mountable_climb_test/climb_from_openspace(mob/living/user, datum/callback/pilot_check = null)
	if(pilot_check?.Invoke())
		actor = user
		along_wall = TRUE
	return TRUE

/datum/unit_test/mountable_piloting
	var/turf/changed_turf
	var/restore_type

/datum/unit_test/mountable_piloting/Destroy()
	if(changed_turf && restore_type)
		changed_turf.ChangeTurf(restore_type)
	return ..()

/datum/unit_test/mountable_piloting/Run()
	var/mob/living/carbon/human/mountable_pilot_test/mount = allocate(/mob/living/carbon/human/mountable_pilot_test)
	var/mob/living/carbon/human/mountable_pilot_test/rider = allocate(/mob/living/carbon/human/mountable_pilot_test)
	var/mob/living/carbon/human/stranger = allocate(/mob/living/carbon/human/consistent)
	var/turf/start = run_loc_floor_bottom_left
	var/turf/target = get_step(start, NORTH)
	mount.forceMove(start)
	rider.forceMove(start)
	stranger.forceMove(run_loc_floor_top_right)
	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "Could not mount pilot")
	var/datum/component/riding/human/riding = mount.GetComponent(/datum/component/riding)
	TEST_ASSERT(riding.can_rider_steer(rider), "Registered rider cannot steer")
	TEST_ASSERT(!riding.can_rider_steer(stranger), "Unrelated player could steer")
	TEST_ASSERT(riding.handle_ride(rider, NORTH), "Steering did not reach mount input")
	TEST_ASSERT_EQUAL(mount.received_direction, NORTH, "Direction was not forwarded to mount")
	TEST_ASSERT_NULL(rider.received_direction, "Rider executed mount movement")
	mount.doing = TRUE
	TEST_ASSERT(!riding.handle_ride(rider, SOUTH), "Rider interrupted mount timed action")
	mount.doing = FALSE
	TEST_ASSERT_EQUAL(mount.received_direction, NORTH, "Busy mount received movement")

	// Resting retains the passenger but suspends piloting until standing again.
	mount.set_resting(TRUE, TRUE)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "Resting dismounted the passenger")
	TEST_ASSERT(!riding.can_rider_steer(rider), "Resting mount allowed piloting")
	TEST_ASSERT(!riding.handle_ride(rider, SOUTH), "Rider moved a resting mount")
	TEST_ASSERT_EQUAL(mount.received_direction, NORTH, "Resting mount received movement input")
	mount.set_resting(FALSE, TRUE)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "Standing dismounted the passenger")
	TEST_ASSERT(riding.handle_ride(rider, NORTH), "Steering did not resume after standing")
	// Intent changes use the mount's restrictions and leave the rider's mode alone.
	rider.m_intent = MOVE_INTENT_WALK
	ADD_TRAIT(rider, TRAIT_NORUN, TRAIT_SOURCE_UNIT_TESTS)
	rider.request_movement_intent(MOVE_INTENT_RUN)
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_RUN, "Rider's NORUN blocked mount running")
	TEST_ASSERT_EQUAL(rider.m_intent, MOVE_INTENT_WALK, "Pilot changed personal mode")
	TEST_ASSERT_EQUAL(rider.get_controlled_movement_intent(), MOVE_INTENT_RUN, "Pilot HUD does not reflect mount mode")
	rider.request_movement_intent(MOVE_INTENT_SNEAK)
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_SNEAK, "Sneak was not forwarded")
	TEST_ASSERT_EQUAL(rider.m_intent, MOVE_INTENT_SNEAK, "Rider did not share Sneak")
	ADD_TRAIT(mount, TRAIT_NORUN, TRAIT_SOURCE_UNIT_TESTS)
	rider.request_movement_intent(MOVE_INTENT_RUN)
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_SNEAK, "Pilot bypassed mount NORUN")
	REMOVE_TRAIT(mount, TRAIT_NORUN, TRAIT_SOURCE_UNIT_TESTS)
	mount.toggle_rider_steering()
	rider.request_movement_intent(MOVE_INTENT_RUN)
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_SNEAK, "Disabled steering changed mount mode")
	TEST_ASSERT_EQUAL(rider.m_intent, MOVE_INTENT_SNEAK, "Denied input changed rider mode")
	mount.toggle_rider_steering()

	// Real jump setup, with only the final throw replaced by a recording spy.
	var/datum/intent/jump/jump_intent = new
	rider.sneak_faded = TRUE
	rider.invisibility = 100
	rider.request_movement_intent(MOVE_INTENT_WALK)
	TEST_ASSERT_EQUAL(rider.relax_message_invisibility, initial(rider.invisibility), "Public exit message was sent before leaving sneak invisibility")
	TEST_ASSERT_EQUAL(mount.m_intent, MOVE_INTENT_WALK, "Mount did not leave Sneak")
	TEST_ASSERT_EQUAL(rider.m_intent, MOVE_INTENT_WALK, "Rider did not leave Sneak")
	ADD_TRAIT(mount, TRAIT_BEWINGED, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(jump_intent.on_mmb(target, rider), "Pilot jump did not execute")
	TEST_ASSERT_EQUAL(mount.jump_count, 1, "Mount did not execute jump")
	TEST_ASSERT_EQUAL(rider.jump_count, 0, "Rider independently jumped")
	TEST_ASSERT_EQUAL(mount.received_jump_range, 3, "Jump ignored mount racial range")
	TEST_ASSERT_EQUAL(mount.received_jump_cost, 20, "Jump did not use mount Walk cost")
	TEST_ASSERT(mount.IsOffBalanced(), "Jump did not apply recovery to mount")
	TEST_ASSERT(!rider.IsOffBalanced(), "Jump applied recovery to passenger")
	TEST_ASSERT(!jump_intent.on_mmb(target, rider), "Pilot bypassed shared jump cooldown")
	mount.next_move = 0
	TEST_ASSERT(!jump_intent.on_mmb(target, rider), "Pilot bypassed mount off-balance")
	mount.remove_status_effect(STATUS_EFFECT_OFFBALANCED)
	mount.toggle_rider_steering()
	TEST_ASSERT(!jump_intent.on_mmb(target, rider), "Disabled steering allowed jump")
	TEST_ASSERT_EQUAL(rider.jump_count, 0, "Denied jump fell back to passenger")
	mount.toggle_rider_steering()
	qdel(jump_intent)

	// Wall click, down click and drag all dispatch as the mount.
	restore_type = target.type
	var/turf/closed/mountable_climb_test/wall = target.ChangeTurf(/turf/closed/mountable_climb_test)
	changed_turf = wall
	wall.attack_hand(rider, "icon-x=16;icon-y=16;left=1")
	TEST_ASSERT_EQUAL(wall.actor, mount, "Wall click did not use mount as climber")
	mount.next_move = 0
	var/turf/open/transparent/openspace/mountable_climb_test/space = wall.ChangeTurf(/turf/open/transparent/openspace/mountable_climb_test)
	changed_turf = space
	space.attack_hand(rider, "icon-x=16;icon-y=16;left=1")
	TEST_ASSERT_EQUAL(space.actor, mount, "Downward climb did not use mount")
	mount.next_move = 0
	space.actor = null
	space.MouseDrop_T(rider, rider)
	TEST_ASSERT(space.along_wall && space.actor == mount, "Dragging rider did not request mount wall traversal")
	mount.next_move = 0
	space.actor = null
	space.MouseDrop_T(mount, rider)
	TEST_ASSERT_EQUAL(space.actor, mount, "Dragging mount did not request wall traversal")
	mount.next_move = 0
	space.actor = null
	space.MouseDrop_T(stranger, rider)
	TEST_ASSERT_NULL(space.actor, "Dragging unrelated mob initiated climb")
	mount.toggle_rider_steering()
	space.attack_hand(rider, "icon-x=16;icon-y=16;left=1")
	space.MouseDrop_T(rider, rider)
	TEST_ASSERT_NULL(space.actor, "Denied climb fell back to passenger")
	mount.toggle_rider_steering()
	target = space.ChangeTurf(restore_type)
	changed_turf = null

	// A running climb callback cannot survive consent revocation, even if re-enabled.
	var/datum/callback/check = CALLBACK(riding, TYPE_PROC_REF(/datum/component/riding/human, continue_climb), rider, riding.steering_generation)
	TEST_ASSERT(check.Invoke(), "Fresh climb permission was invalid")
	addtimer(CALLBACK(mount, TYPE_PROC_REF(/mob/living/carbon/human, toggle_rider_steering)), 1)
	TEST_ASSERT(!do_after(mount, 10, target = target, extra_checks = check), "Disabling steering failed to cancel timed action")
	mount.toggle_rider_steering()
	TEST_ASSERT(!check.Invoke(), "Re-enabling steering resurrected canceled climb")
	qdel(check)
	check = CALLBACK(riding, TYPE_PROC_REF(/datum/component/riding/human, continue_climb), rider, riding.steering_generation)
	mount.unbuckle_mob(rider, TRUE)
	TEST_ASSERT(!check.Invoke(), "Dismount retained pending climb permission")
	TEST_ASSERT_EQUAL(rider.get_controlled_movement_intent(), rider.m_intent, "Dismounted HUD still reads mount mode")
	qdel(check)
