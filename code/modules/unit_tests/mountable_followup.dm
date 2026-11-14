// Count grass contact without triggering unrelated random ambushes.
/mob/living/carbon/human/mountable_test
	parent_type = /mob/living/carbon/human/consistent
	var/plant_contacts = 0

/mob/living/carbon/human/mountable_test/consider_ambush(always, ignore_cooldown, min_dist, max_dist, silent)
	plant_contacts++

/datum/unit_test/mountable_followup/Run()
	var/mob/living/carbon/human/mountable_test/mount = allocate(/mob/living/carbon/human/mountable_test)
	var/mob/living/carbon/human/mountable_test/rider = allocate(/mob/living/carbon/human/mountable_test)
	var/turf/start = run_loc_floor_bottom_left
	var/turf/next = get_step(start, NORTH)
	mount.forceMove(start)
	rider.forceMove(start)
	ADD_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(/mob/living/carbon/human/proc/toggle_rider_steering in mount.verbs, "Mountable did not grant steering toggle")
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "Could not mount test passenger")
	var/datum/component/riding/human/riding = mount.GetComponent(/datum/component/riding)

	// Grass contact is suppressed, but tall plants still brush the passenger.
	var/obj/structure/flora/roguegrass/grass = allocate(/obj/structure/flora/roguegrass, start)
	var/obj/structure/flora/roguegrass/bush/bush = allocate(/obj/structure/flora/roguegrass/bush, start)
	var/datum/component/roguegrass/short_plants = grass.GetComponent(/datum/component/roguegrass)
	var/datum/component/roguegrass/tall_plants = bush.GetComponent(/datum/component/roguegrass)
	rider.plant_contacts = 0
	rider.m_intent = MOVE_INTENT_WALK
	short_plants.Crossed(grass, rider)
	TEST_ASSERT_EQUAL(rider.plant_contacts, 0, "Grass reacted to a carried passenger")
	tall_plants.Crossed(bush, rider)
	TEST_ASSERT_EQUAL(rider.plant_contacts, 1, "Bush failed to brush a passenger")
	qdel(grass)
	qdel(bush)

	// Both web implementations must exempt a real passenger during transport.
	var/obj/structure/spider/stickyweb/web = allocate(/obj/structure/spider/stickyweb, next)
	var/obj/structure/spider/stickyweb/mirespider/thin_web = allocate(/obj/structure/spider/stickyweb/mirespider, next)
	ADD_TRAIT(mount, TRAIT_WEBWALK, TRAIT_SOURCE_UNIT_TESTS)
	for(var/i in 1 to 50)
		TEST_ASSERT(web.CanPass(rider, start), "Web trapped a passenger")
		TEST_ASSERT(thin_web.CanPass(rider, start), "Mirespider web trapped a passenger")
	TEST_ASSERT(mount.Move(next, NORTH), "Webwalker could not carry passenger through webs")
	TEST_ASSERT_EQUAL(rider.loc, mount.loc, "Web crossing separated rider and mount")
	qdel(web)
	qdel(thin_web)

	// A protected mount crosses without exposing its passenger to ground shocks.
	var/obj/structure/glowshroom/kneestingers = allocate(/obj/structure/glowshroom, start)
	TEST_ASSERT(kneestingers.can_zap(mount), "Unprotected mount bypassed kneestingers")
	TEST_ASSERT(!kneestingers.can_zap(rider), "Kneestingers targeted an attached rider")
	TEST_ASSERT(kneestingers.CanPass(rider, start), "Kneestingers blocked the carried rider")
	ADD_TRAIT(mount, TRAIT_KNEESTINGER_IMMUNITY, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(mount.Move(start, SOUTH), "Dendorite mount could not carry a rider over kneestingers")
	TEST_ASSERT_EQUAL(rider.loc, start, "Kneestingers separated the rider from the mount")
	qdel(kneestingers)
	mount.forceMove(next)

	// Disabling control stops facing changes and movement, not carrying.
	mount.toggle_rider_steering()
	var/old_dir = mount.dir
	riding.last_vehicle_move = -1000
	riding.handle_ride(rider, WEST)
	TEST_ASSERT_EQUAL(mount.loc, next, "Disabled steering moved mount")
	TEST_ASSERT_EQUAL(mount.dir, old_dir, "Disabled steering turned mount")
	TEST_ASSERT(mount.Move(start, SOUTH), "Steering toggle blocked mount's own movement")
	TEST_ASSERT_EQUAL(rider.buckled, mount, "Steering toggle dismounted passenger")
	mount.toggle_rider_steering()

	// Stun and immobilization prevent skating without forcing a standing dismount.
	mount.Stun(20)
	riding.last_vehicle_move = -1000
	riding.handle_ride(rider, NORTH)
	TEST_ASSERT_EQUAL(mount.loc, start, "Rider steered stunned mount")
	TEST_ASSERT_EQUAL(rider.buckled, mount, "Standing stun unnecessarily dismounted rider")
	mount.SetStun(0)
	mount.Immobilize(20)
	riding.last_vehicle_move = -1000
	riding.handle_ride(rider, NORTH)
	TEST_ASSERT_EQUAL(mount.loc, start, "Rider steered immobilized mount")
	mount.SetImmobilized(0)

	// Player mounts no longer grant Riding XP, including sleep-banked XP.
	rider.mind_initialize()
	rider.adjust_skillrank(/datum/skill/misc/riding, SKILL_LEVEL_APPRENTICE, TRUE)
	var/before_sleep_xp = rider.mind.sleep_adv.get_sleep_xp(/datum/skill/misc/riding)
	rider.m_intent = MOVE_INTENT_RUN
	for(var/i in 1 to 6)
		mount.Move(mount.loc == start ? next : start, mount.loc == start ? NORTH : SOUTH)
	TEST_ASSERT_EQUAL(rider.mind.sleep_adv.get_sleep_xp(/datum/skill/misc/riding), before_sleep_xp, "Player transport awarded sleep XP")
	TEST_ASSERT_EQUAL(riding.riding_xp_move_counter, 0, "Player transport counted Riding XP moves")
	// A clientless mount must not fall back to unrestricted step/forceMove steering.
	var/atom/before_input = mount.loc
	TEST_ASSERT(!riding.handle_ride(rider, NORTH), "Clientless mount accepted steering")
	TEST_ASSERT_EQUAL(mount.loc, before_input, "Clientless steering moved mount")

	// Resting keeps attachment; immunity must not eject.
	mount.set_resting(TRUE, TRUE)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "Voluntary rest dismounted rider")
	ADD_TRAIT(mount, TRAIT_STUNIMMUNE, TRAIT_SOURCE_UNIT_TESTS)
	mount.Knockdown(20)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "Immune knockdown dismounted rider")
	REMOVE_TRAIT(mount, TRAIT_STUNIMMUNE, TRAIT_SOURCE_UNIT_TESTS)
	mount.SetKnockdown(0)
	TEST_ASSERT_EQUAL(rider.buckled, mount, "Clearing knockdown dismounted rider")
	mount.AdjustKnockdown(20)
	TEST_ASSERT_NULL(rider.buckled, "Adjusted knockdown did not dismount already-resting rider")
	TEST_ASSERT(!mount.buckle_mob(rider, TRUE), "Mounted a knocked-down mount")
	mount.SetKnockdown(0)
	mount.set_resting(FALSE, TRUE)
	TEST_ASSERT(mount.buckle_mob(rider, TRUE), "Could not remount recovered mount")
	mount.Paralyze(20, FALSE)
	TEST_ASSERT_NULL(rider.buckled, "Paralysis without mobility update failed to dismount")
	TEST_ASSERT_NULL(rider.get_mountable_mount(), "Dismounted rider retained ground exemption")
	// Direct and Set variants must also dismount, not only AdjustKnockdown.
	for(var/variant in list("Knockdown", "SetKnockdown"))
		mount.SetParalyzed(0)
		mount.SetKnockdown(0)
		mount.set_resting(FALSE, TRUE)
		TEST_ASSERT(mount.buckle_mob(rider, TRUE), "Could not remount for knockdown variant")
		call(mount, variant)(20)
		TEST_ASSERT_NULL(rider.buckled, "Knockdown variant did not dismount rider")

	// A dismounted non-Webwalker must become vulnerable again.
	web = allocate(/obj/structure/spider/stickyweb, get_turf(rider))
	var/blocked_by_web = FALSE
	for(var/i in 1 to 50)
		if(!web.CanPass(rider, start))
			blocked_by_web = TRUE
			break
	TEST_ASSERT(blocked_by_web, "Dismounted passenger retained web immunity")
	REMOVE_TRAIT(mount, TRAIT_PONYGIRL_RIDEABLE, TRAIT_SOURCE_UNIT_TESTS)
	TEST_ASSERT(!(/mob/living/carbon/human/proc/toggle_rider_steering in mount.verbs), "Trait removal left steering verb")
