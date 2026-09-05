/*
 * How a fractal mutant decides what to do.
 *
 * Split out of fractal_mutant.dm: target selection, the planning subtrees and
 * the controllers themselves. The mob definitions stay in fractal_mutant.dm and
 * the abilities these subtrees fire live in fractal_mutant_abilities.dm.
 *
 * BB_FRACTAL_FATALITY_ACTIVE is defined in fractal_mutant.dm, which the .dme
 * includes ahead of this file.
 */

/*
 * ---------------------------------------------------------------------------
 * What counts as a target
 * ---------------------------------------------------------------------------
 */

/datum/targetting_datum/fractal

/datum/targetting_datum/fractal/can_attack(mob/living/living_mob, atom/the_target)
	if(!the_target || isturf(the_target))
		return FALSE

	if(QDELETED(the_target))
		return FALSE

	if(!isliving(the_target))
		return FALSE

	var/mob/living/target = the_target

	// Never attack itself.
	if(target == living_mob)
		return FALSE

	// Godmode is still absolute.
	if(target.status_flags & GODMODE)
		return FALSE

	// Cannot attack what it cannot see.
	if(living_mob.see_invisible < target.invisibility)
		return FALSE

	// Fractals do not attack across disconnected z-levels.
	if(living_mob.z != target.z)
		return FALSE

	// Death is the only state that makes a target invalid.
	// Unconscious, stunned, knocked down, sleeping, etc. are all valid.
	if(target.stat == DEAD)
		return FALSE

	if(("void" in target.faction) || ("fractal" in target.faction))
		return FALSE

	// No summoner protection.
	// No mercy.
	return TRUE

/datum/ai_behavior/find_potential_targets/fractal
	vision_range = 13

/datum/ai_behavior/find_potential_targets/fractal/pick_final_target(
		datum/ai_controller/controller,
		list/filtered_targets
	)

	if(!length(filtered_targets))
		return

	var/mob/living/pawn = controller.pawn
	var/mob/living/current_target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	var/mob/living/best_target
	var/best_score = -INFINITY

	for(var/mob/living/target as anything in filtered_targets)
		var/score = get_target_score(pawn, target, current_target)

		if(score > best_score)
			best_score = score
			best_target = target

	return best_target


/datum/ai_behavior/find_potential_targets/fractal/proc/get_target_score(
		mob/living/pawn,
		mob/living/target,
		mob/living/current_target
	)

	var/score = 0
	var/distance = get_dist(pawn, target)

	score += max(0, (vision_range - distance) * 3)

	if(target == current_target)
		score += 40

	if(iscarbon(target))
		score += score_carbon(target)
	else
		score += score_simple_mob(target)


	score += rand(-5, 5)
	return score

/datum/ai_behavior/find_potential_targets/fractal/proc/score_simple_mob(
		mob/living/target
	)

	if(target.maxHealth <= 0)
		return 0

	var/health_ratio = clamp(
		target.health / target.maxHealth,
		0,
		1
	)

	var/score = 0

	// Weak targets are preferred.
	if(health_ratio <= 0.25)
		score += 100
	else if(health_ratio <= 0.5)
		score += 55
	else if(health_ratio <= 0.75)
		score += 25

	// A conventional simple mob close to death is extremely attractive.
	if(target.health <= target.maxHealth * 0.1)
		score += 40

	return score

/datum/ai_behavior/find_potential_targets/fractal/proc/score_carbon(
		mob/living/carbon/target
	)

	var/score = 25

	if(target.stat == DEAD)
		return -INFINITY

	if(target.stat == UNCONSCIOUS)
		score += 350

	var/health_ratio = clamp(
		target.health / max(target.maxHealth, 1),
		0,
		1
	)

	if(health_ratio <= 0.2)
		score += 120
	else if(health_ratio <= 0.4)
		score += 80
	else if(health_ratio <= 0.6)
		score += 40

	var/damage = target.getBruteLoss() + target.getFireLoss()

	if(damage >= 75)
		score += 30
	else if(damage >= 50)
		score += 20
	else if(damage >= 25)
		score += 10

	// Missing major limbs.
	var/has_left_arm = FALSE
	var/has_right_arm = FALSE
	var/has_left_leg = FALSE
	var/has_right_leg = FALSE

	for(var/obj/item/bodypart/part as anything in target.bodyparts)
		if(istype(part, /obj/item/bodypart/l_arm))
			has_left_arm = TRUE
		else if(istype(part, /obj/item/bodypart/r_arm))
			has_right_arm = TRUE
		else if(istype(part, /obj/item/bodypart/l_leg))
			has_left_leg = TRUE
		else if(istype(part, /obj/item/bodypart/r_leg))
			has_right_leg = TRUE

	if(!has_left_arm)
		score += 15

	if(!has_right_arm)
		score += 15

	if(!has_left_leg)
		score += 30

	if(!has_right_leg)
		score += 30

	return score

/datum/ai_planning_subtree/simple_find_target/fractal

/datum/ai_planning_subtree/simple_find_target/fractal/SelectBehaviors(
		datum/ai_controller/controller,
		delta_time
	)

	controller.queue_behavior(
		/datum/ai_behavior/find_potential_targets/fractal,
		BB_BASIC_MOB_CURRENT_TARGET,
		BB_TARGETTING_DATUM,
		BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION
	)

/*
 * ---------------------------------------------------------------------------
 * Planning subtrees
 * ---------------------------------------------------------------------------
 */

/datum/ai_planning_subtree/fractal_fatality_lock
/datum/ai_planning_subtree/fractal_fatality_lock/SelectBehaviors(
		datum/ai_controller/controller,
		seconds_per_tick
	)
	if(controller.blackboard[BB_FRACTAL_FATALITY_ACTIVE])
		return SUBTREE_RETURN_FINISH_PLANNING

	return

/datum/ai_planning_subtree/targeted_mob_ability/check_range
	var/min_range = 0
	var/max_range = 10

/datum/ai_planning_subtree/targeted_mob_ability/check_range/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/atom/target = controller.blackboard[target_key]
	if(!target || !controller.pawn)
		return
	var/distance_to_target = get_dist(controller.pawn, target)
	if(distance_to_target >= max_range || distance_to_target < min_range)
		return
	return ..()


/datum/ai_planning_subtree/targeted_mob_ability/check_range/charge
	ability_key = "bb_fractal_charge"
	min_range = 2
	finish_planning = FALSE

/datum/ai_planning_subtree/targeted_mob_ability/check_range/tear_apart
    ability_key = "bb_fractal_tearapart"
    min_range = 1
    max_range = 5
    finish_planning = TRUE


/datum/ai_planning_subtree/fractal_finish
/datum/ai_planning_subtree/fractal_finish/SelectBehaviors(
		datum/ai_controller/controller,
		delta_time
	)

	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!target || QDELETED(target))
		return

	if(target.stat != UNCONSCIOUS)
		return

	var/mob/living/pawn = controller.pawn

	if(!pawn)
		return

	if(get_dist(pawn, target) > 1)
		return

	var/datum/action/cooldown/mob_cooldown/fractal_finish/finisher = \
		controller.blackboard["bb_fractal_finish"]

	if(!finisher || !finisher.IsAvailable())
		return

	controller.queue_behavior(
		/datum/ai_behavior/fractal_finish_target
	)

	return SUBTREE_RETURN_FINISH_PLANNING



/datum/ai_behavior/fractal_finish_target
	action_cooldown = 1 SECONDS

/datum/ai_behavior/fractal_finish_target/perform(
		seconds_per_tick,
		datum/ai_controller/controller
	)

	var/mob/living/pawn = controller.pawn
	var/mob/living/target = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]

	if(!pawn || !target)
		finish_action(controller, succeeded = FALSE)
		return

	if(QDELETED(target) || target.stat != UNCONSCIOUS)
		finish_action(controller, succeeded = FALSE)
		return

	// Too far away. The normal movement/attack AI gets a chance.
	if(get_dist(pawn, target) > 1)
		finish_action(controller, succeeded = FALSE)
		return

	var/datum/action/cooldown/mob_cooldown/fractal_finish/finisher = \
		controller.blackboard["bb_fractal_finish"]

	if(!finisher || !finisher.IsAvailable())
		finish_action(controller, succeeded = FALSE)
		return

	return ..()


/datum/ai_behavior/fractal_finish_target/finish_action(
		datum/ai_controller/controller,
		succeeded,
		...
	)
	. = ..()
	if(!succeeded)
		return

	controller.CancelActions()


/datum/ai_planning_subtree/fractal_roar

/datum/ai_planning_subtree/fractal_roar/SelectBehaviors(
		datum/ai_controller/controller,
		delta_time
	)

	var/mob/living/pawn = controller.pawn

	if(!pawn)
		return

	var/count = 0

	for(var/mob/living/L in range(2, pawn))
		if(L == pawn)
			continue

		if(L.stat == DEAD)
			continue

		if(L.faction_check_mob(pawn, exact_match = FALSE))
			continue

		count++

	if(count < 2)
		return

	var/datum/action/cooldown/mob_cooldown/fractal_roar/roar = \
		controller.blackboard["bb_fractal_roar"]

	if(!roar || !roar.IsAvailable())
		return

	controller.queue_behavior(
		/datum/ai_behavior/targeted_mob_ability,
		"bb_fractal_roar",
		BB_BASIC_MOB_CURRENT_TARGET
	)

	return SUBTREE_RETURN_FINISH_PLANNING



/datum/ai_planning_subtree/fractal_repulse
/datum/ai_planning_subtree/fractal_repulse/SelectBehaviors(
        datum/ai_controller/controller,
        delta_time
    )
    if(controller.blackboard[BB_FRACTAL_FATALITY_ACTIVE])
        return

    var/datum/action/cooldown/mob_cooldown/fractal_repulse/repulse = \
        controller.blackboard["bb_fractal_repulse"]

    if(!repulse || !repulse.IsAvailable())
        return

    var/mob/living/pawn = controller.pawn
    if(!pawn)
        return

    var/has_target = FALSE

    for(var/mob/living/target in view(3, pawn))
        if(!target || target == pawn)
            continue

        if(QDELETED(target) || target.stat == DEAD)
            continue

        has_target = TRUE
        break

    if(!has_target)
        return

    controller.queue_behavior(
        /datum/ai_behavior/targeted_mob_ability,
        "bb_fractal_repulse",
        BB_BASIC_MOB_CURRENT_TARGET
    )

    return SUBTREE_RETURN_FINISH_PLANNING


/*
 * ---------------------------------------------------------------------------
 * Controllers
 * ---------------------------------------------------------------------------
 */

/datum/ai_controller/fractal_mutant
	movement_delay = 0.8 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/fractal()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/fractal_fatality_lock,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target/fractal,
		/datum/ai_planning_subtree/targeted_mob_ability/check_range/tear_apart,
		/datum/ai_planning_subtree/fractal_repulse,
		/datum/ai_planning_subtree/fractal_roar,
		/datum/ai_planning_subtree/fractal_finish,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk/less_walking


/datum/ai_controller/fractal_mutant/forcer
	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/fractal()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target/fractal,
		/datum/ai_planning_subtree/targeted_mob_ability/check_range/charge,
		/datum/ai_planning_subtree/fractal_repulse,
		/datum/ai_planning_subtree/fractal_roar,
		/datum/ai_planning_subtree/fractal_finish,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)


