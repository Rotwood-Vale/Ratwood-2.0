#define BB_FRACTAL_FATALITY_ACTIVE "bb_fractal_fatality_active"



/datum/ai_planning_subtree/fractal_fatality_lock
/datum/ai_planning_subtree/fractal_fatality_lock/SelectBehaviors(
		datum/ai_controller/controller,
		seconds_per_tick
	)
	if(controller.blackboard[BB_FRACTAL_FATALITY_ACTIVE])
		return SUBTREE_RETURN_FINISH_PLANNING

	return


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

	// No faction check.
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


/mob/proc/grant_actions_by_list(list/input)
	if(length(input) <= 0)
		return

	for(var/action in input)
		var/datum/action/ability = new action(src)
		ability.Grant(src)

		var/blackboard_key = input[action]
		if(isnull(blackboard_key))
			continue

		ai_controller?.set_blackboard_key(blackboard_key, ability)

/mob/living/simple_animal/hostile/fractal_mutant
	name = "???"
	desc = "A massive, monstrous abomination. It's hard to latch onto even the slightest detail."

	icon = 'modular_fenysha_events/icons/mob/fractal_mutant.dmi'
	base_intents = list(/datum/intent/simple/claw)
	icon_state = "fractal_mutant"
	icon_living = "fractal_mutant"
	
	wander = FALSE
	minbodytemp = 0
	maxbodytemp = INFINITY
	speed = 1.5

	loot = list()
	maxHealth = 750
	health = 750
	healable = FALSE
	
	obj_damage = 200
	melee_damage_lower = 50
	melee_damage_upper = 50
	harm_intent_damage = 50
	armor_penetration = 40
	damage_coeff = list(BRUTE = 0.8, BURN = 0.5, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	
	atmos_requirements = null
	faction = list("void", "fractal")

	stop_automated_movement_when_pulled = FALSE	
	environment_smash = ENVIRONMENT_SMASH_STRUCTURES
	canparry = TRUE
	d_intent = INTENT_PARRY

	robust_searching = TRUE
	vision_range = 8
	aggro_vision_range = 13
	retreat_distance = 0
	minimum_distance = 0
	limb_destroyer = TRUE
	defprob = 60
	
	STASTR = 20
	STAPER = 13
	STACON = 14
	STAWIL = 15
	STASPD = 15


	layer = ABOVE_ALL_MOB_LAYER
	plane = GAME_PLANE_UPPER

	ai_controller = /datum/ai_controller/fractal_mutant

	attack_sound = 'modular_fenysha_events/sound/fractal_attack.ogg'
	VAR_PRIVATE/static/list/footstep_sounds = list(
		'modular_fenysha_events/sound/fractal_footstep/heavy_1.ogg',
		'modular_fenysha_events/sound/fractal_footstep/heavy_2.ogg',
		'modular_fenysha_events/sound/fractal_footstep/heavy_3.ogg',
		'modular_fenysha_events/sound/fractal_footstep/heavy_4.ogg',
		'modular_fenysha_events/sound/fractal_footstep/heavy_5.ogg',
		'modular_fenysha_events/sound/fractal_footstep/heavy_6.ogg',
	)

	var/list/scream_sounds = list(
		'modular_fenysha_events/sound/fractal_scream1.ogg',
		'modular_fenysha_events/sound/fractal_scream2.ogg', 
		'modular_fenysha_events/sound/fractal_scream3.ogg', 
	)

	var/list/inntacte_actions = list(
		/datum/action/cooldown/mob_cooldown/fractal_fatality = "bb_fractal_tearapart",
		/datum/action/cooldown/mob_cooldown/fractal_finish = "bb_fractal_finish",
		/datum/action/cooldown/mob_cooldown/fractal_roar = "bb_fractal_roar",
		/datum/action/cooldown/mob_cooldown/fractal_repulse = "bb_fractal_repulse",
	)

	COOLDOWN_DECLARE(scream_cd)
	COOLDOWN_DECLARE(fractal_effect_cd)

	base_pixel_x = -12
	pixel_x = -12

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



/mob/living/simple_animal/hostile/fractal_mutant/Initialize(mapload)
	. = ..()
	setup_visual()
	AddComponent(/datum/component/alien_examine)
	grant_actions_by_list(inntacte_actions)

/mob/living/simple_animal/hostile/fractal_mutant/proc/setup_visual()
	add_filter("fractal_wave", 1, list("type" = "wave", "size" = 2, "x" = 10, "y" = 10, "offset" = 0))
	
	var/filter = get_filter("fractal_wave")
	animate(filter, offset = 100, time = 30, loop = -1, flags = ANIMATION_PARALLEL)
	animate(offset = 15, time = 30)

	start_fractal_pulse()


/mob/living/simple_animal/hostile/fractal_mutant/proc/start_fractal_pulse()
	var/matrix/M1 = matrix()
	M1.Scale(1.05, 0.95)
	
	var/matrix/M2 = matrix()
	M2.Scale(0.95, 1.05)
	
	var/matrix/M_reset = matrix()

	animate(src, transform = M1, time = 2, loop = -1, easing = JUMP_EASING, flags = ANIMATION_PARALLEL)
	animate(transform = M2, time = 2, easing = JUMP_EASING)
	animate(transform = M_reset, time = 4)


/mob/living/simple_animal/hostile/fractal_mutant/Move(atom/newloc, dir, step_x, step_y)
	. = ..()
	new /obj/effect/temp_visual/decoy/fading/halfsecond(get_turf(src), src)

/mob/living/simple_animal/hostile/fractal_mutant/Moved()
	. = ..()
	for(var/mob/living/L in view(aggro_vision_range, src))
		if(L.faction == "void" || L.faction == "fractal")
			continue
		shake_camera(L, 1, 0.5)
	playsound(get_turf(src), pick(footstep_sounds), 50, TRUE)

/mob/living/simple_animal/hostile/fractal_mutant/Life()
	. = ..()

	if(COOLDOWN_FINISHED(src, fractal_effect_cd))
		for(var/mob/living/L in get_hearers_in_view(7, src))
			if(L == src || L.faction == "void" || L.faction == "fractal")
				continue
			if(!L.has_status_effect(/datum/status_effect/fractal_screen))
				L.apply_status_effect(/datum/status_effect/fractal_screen)
		COOLDOWN_START(src, fractal_effect_cd, 3 SECONDS)


/mob/living/simple_animal/hostile/fractal_mutant/attacked_by(obj/item/I, mob/living/user)
	. = ..()
	
	if(COOLDOWN_FINISHED(src, scream_cd))
		emote("scream")
		playsound(get_turf(src), pick(scream_sounds), 100, TRUE)
		COOLDOWN_START(src, scream_cd, 6 SECONDS)




/mob/living/simple_animal/hostile/fractal_mutant/forcer
	icon = 'modular_fenysha_events/icons/mob/fractal_mutant64x64.dmi'
	icon_state = "forcer"
	icon_living = "forcer"

	base_pixel_x = -16
	pixel_x = -16

	base_intents = list(/datum/intent/simple/headbutt)

	maxHealth = 1200
	health = 1200
	healable = FALSE
	
	obj_damage = 50
	melee_damage_lower = 25
	melee_damage_upper = 25
	harm_intent_damage = 25
	armor_penetration = 20

	STASTR = 30
	limb_destroyer = FALSE

	speed = 2.3

	ai_controller = /datum/ai_controller/fractal_mutant/forcer
	inntacte_actions = list(
		/datum/action/cooldown/mob_cooldown/fractal_finish = "bb_fractal_finish",
		/datum/action/cooldown/mob_cooldown/simple_charge = "bb_fractal_charge", 
		/datum/action/cooldown/mob_cooldown/fractal_roar = "bb_fractal_roar",
		/datum/action/cooldown/mob_cooldown/fractal_repulse = "bb_fractal_repulse",
	)



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


/datum/ai_planning_subtree/targeted_mob_ability/check_range
	var/min_range = 0
	var/max_range = 10

/datum/ai_planning_subtree/targeted_mob_ability/check_range/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	var/atom/target = controller.blackboard[target_key]
	if(!target || !controller.pawn)
		return
	var/distance_to_target = get_dist(controller.pawn, target)
	if(distance_to_target >= max_range || distance_to_target <= min_range)
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


/datum/action/cooldown/mob_cooldown/simple_charge
	name = "Charge"
	desc = "Charge towards a targeted location, dealing heavy damage on impact."
	cooldown_time = 10 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "3"

	var/max_range = 10
	var/charge_sound = 'modular_fenysha_events/sound/fractal_scream1.ogg'
	var/charge_delay = 5

/datum/action/cooldown/mob_cooldown/simple_charge/PreActivate(atom/target)
	target = get_turf(target)
	if (get_dist(owner, target) > max_range)
		return FALSE
	return ..()

/datum/action/cooldown/mob_cooldown/simple_charge/Activate(atom/target)
	var/dist = get_dist(owner, target) - 1
	if(dist <= 1)
		owner.balloon_alert(owner, "To close!")
		return
	INVOKE_ASYNC(src, PROC_REF(do_charge), get_turf(target))
	StartCooldown()
	return TRUE

/datum/action/cooldown/mob_cooldown/simple_charge/proc/do_charge(turf/target)
	owner.visible_message(span_danger("[owner] charges towards [target]!"))
	if(charge_delay)
		if(!do_after(owner, charge_delay))
			owner.balloon_alert(owner, "Interupted!")
	if(charge_sound)
		playsound(owner, charge_sound, 40)
	var/dist = get_dist(owner, target) - 1
	for(var/i = 1 to dist)
		if(get_dist(owner, target) <= 1)
			break
		new /obj/effect/temp_visual/decoy/fading/halfsecond(owner.loc, owner)
		owner.forceMove(get_step_towards(owner, target))
		sleep(2)

	for(var/mob/living/living_target in target.contents)
		if(get_dist(owner, living_target) <= 1)
			var/damage = rand(20, 30)
			living_target.take_bodypart_damage(damage)
			living_target.Knockdown(10)
			shake_camera(living_target)
	playsound(owner, 'modular_fenysha_events/sound/fractal_glitch2.ogg', 100, TRUE)



/datum/action/cooldown/mob_cooldown/fractal_fatality
	name = "Fractal Fatality"
	desc = "Charge towards a nearby victim, seize them, and tear them apart."
	cooldown_time = 2 MINUTES
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "2"

	var/fatality_range = 2
	var/charge_range = 5

	var/preparation_time = 2 SECONDS
	var/lift_time = 1.5 SECONDS
	var/flip_time = 2 SECONDS
	var/kill_time = 3 SECONDS

	var/charge_delay = 5
	var/charge_speed = 2

	var/charge_sound = 'modular_fenysha_events/sound/fractal_scream1.ogg'
	var/grab_sound = 'modular_fenysha_events/sound/fractal_scream2.ogg'
	var/kill_sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'


/datum/action/cooldown/mob_cooldown/fractal_fatality/PreActivate(atom/target)
	target = get_turf(target)

	if(!target)
		return FALSE

	if(get_dist(owner, target) > charge_range)
		return FALSE

	var/mob/living/victim = locate() in target.contents

	if(!victim || victim == owner)
		return FALSE

	if(victim.stat == DEAD)
		return FALSE

	return ..()


/datum/action/cooldown/mob_cooldown/fractal_fatality/Activate(atom/target)
	var/turf/T = get_turf(target)

	if(!T)
		return FALSE

	var/mob/living/victim

	for(var/mob/living/M in T.contents)
		if(M != owner && M.stat != DEAD)
			victim = M
			break

	if(!victim)
		return FALSE

	if(get_dist(owner, victim) > charge_range)
		return FALSE

	var/datum/ai_controller/controller = owner.ai_controller

	if(controller?.blackboard[BB_FRACTAL_FATALITY_ACTIVE])
		return FALSE

	controller?.set_blackboard_key(BB_FRACTAL_FATALITY_ACTIVE, TRUE)

	StartCooldown()

	INVOKE_ASYNC(src, PROC_REF(do_fatality), victim)

	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_fatality/proc/do_fatality(mob/living/victim)
	if(!victim || QDELETED(victim) || victim.stat == DEAD)
		end_fatality()
		return

	var/dist = get_dist(owner, victim) - 1

	if(dist > 0)
		owner.visible_message(
			span_danger("[owner] suddenly charges towards [victim]!")
		)

		if(charge_delay)
			if(!do_after(owner, charge_delay))
				owner.balloon_alert(owner, "Interrupted!")
				return

		if(charge_sound)
			playsound(owner, charge_sound, 50, TRUE)

		for(var/i = 1 to dist)
			if(!victim || QDELETED(victim) || victim.stat == DEAD)
				end_fatality()
				return

			if(get_dist(owner, victim) <= 1)
				break

			// The victim can move while the mutant is charging.
			var/turf/victim_turf = get_turf(victim)

			if(!victim_turf)
				end_fatality()
				return

			new /obj/effect/temp_visual/decoy/fading/halfsecond(owner.loc, owner)

			owner.forceMove(get_step_towards(owner, victim_turf))

			sleep(charge_speed)

	// The charge must have brought us close enough.
	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return


	victim.Stun(1 MINUTES)
	victim.Knockdown(1 MINUTES)

	// We only stun the owner after the charge.
	var/mob/living/living_owner = owner
	living_owner.Stun(6 SECONDS)

	owner.face_atom(victim)
	victim.face_atom(owner)

	owner.visible_message(
		span_userdanger("[owner] suddenly grabs [victim]!")
	)

	if(grab_sound)
		playsound(owner, grab_sound, 80, TRUE)

	if(!do_after(owner, preparation_time, target = victim))
		end_fatality()
		return

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	owner.visible_message(
		span_userdanger("[owner] lifts [victim] off the ground!")
	)

	animate(
		victim,
		pixel_y = victim.pixel_y + 12,
		time = lift_time,
		easing = QUAD_EASING
	)

	animate(
		owner,
		pixel_y = owner.pixel_y + 2,
		time = lift_time,
		easing = QUAD_EASING
	)

	sleep(lift_time)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	owner.visible_message(
		span_userdanger("[victim] hangs helplessly above the ground in [owner]'s grasp.")
	)

	sleep(6)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	owner.visible_message(
		span_userdanger("[owner] violently twists [victim] upside down!")
	)

	animate(
		victim,
		transform = victim.transform.Turn(180),
		time = flip_time,
		easing = QUAD_EASING
	)

	sleep(flip_time)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	playsound(owner, kill_sound, 100, TRUE)

	owner.visible_message(
		span_userdanger("[owner] tears [victim] apart!")
	)

	animate(
		owner,
		pixel_x = owner.pixel_x + 2,
		time = 2
	)

	animate(
		victim,
		transform = victim.transform.Scale(1, 1.3),
		time = 4,
		easing = QUAD_EASING
	)

	sleep(kill_time)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(get_dist(owner, victim) > fatality_range)
		end_fatality()
		return

	var/turf/kill_turf = get_turf(victim)

	if(!kill_turf)
		end_fatality()
		return

	animate(
		owner,
		pixel_x = owner.pixel_x - 3,
		time = 2,
		easing = QUAD_EASING
	)

	animate(
		victim,
		pixel_y = victim.pixel_y + 3,
		transform = victim.transform.Scale(1, 1.45),
		time = 3,
		easing = QUAD_EASING
	)

	shake_camera(victim, 6, 2)

	playsound(kill_turf, kill_sound, 100, TRUE)

	victim.visible_message(
		span_userdanger("[owner] violently tears [victim] apart!")
	)

	sleep(3)

	if(!victim || QDELETED(victim))
		end_fatality()
		return

	if(iscarbon(victim))
		var/mob/living/carbon/C = victim

		C.death(TRUE)

		C.spill_organs()

		var/list/parts_to_remove = list()

		for(var/obj/item/bodypart/part as anything in C.bodyparts)
			if(istype(part, /obj/item/bodypart/l_leg) || \
				istype(part, /obj/item/bodypart/r_leg))
				parts_to_remove += part

		for(var/obj/item/bodypart/part as anything in parts_to_remove)
			if(!part || QDELETED(part))
				continue

			if(!part.drop_limb())
				continue

			var/direction = get_dir(owner, C)

			if(!direction)
				direction = pick(GLOB.alldirs)

			part.throw_at(
				get_edge_target_turf(kill_turf, direction),
				rand(2, 4),
				5
			)

		new /obj/effect/gibspawner/human(kill_turf)

		playsound(
			kill_turf,
			pick(list(
				'sound/combat/gib (1).ogg',
				'sound/combat/gib (2).ogg'
			)),
			100,
			TRUE
		)

	else
		victim.adjustBruteLoss(200)

		if(victim.stat != DEAD)
			victim.death()
	end_fatality()
	animate(
		owner,
		pixel_y = 0,
		time = 4
	)

/datum/action/cooldown/mob_cooldown/fractal_fatality/proc/end_fatality()
	var/datum/ai_controller/controller = owner?.ai_controller

	if(controller)
		controller.clear_blackboard_key(BB_FRACTAL_FATALITY_ACTIVE)






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


/datum/action/cooldown/mob_cooldown/fractal_finish
	name = "Fractal Finish"
	desc = "Finish off an incapacitated victim."
	cooldown_time = 3 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "2"

	var/finish_range = 1
	var/finish_delay = 1
	var/finish_sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'


/datum/action/cooldown/mob_cooldown/fractal_finish/PreActivate(atom/target)
	target = get_turf(target)

	if(!target)
		return FALSE

	if(get_dist(owner, target) > finish_range)
		return FALSE

	var/mob/living/victim = locate() in target.contents

	if(!victim || victim == owner)
		return FALSE

	if(victim.stat != UNCONSCIOUS)
		return FALSE

	return ..()


/datum/action/cooldown/mob_cooldown/fractal_finish/Activate(atom/target)
	var/turf/T = get_turf(target)

	if(!T)
		return FALSE

	var/mob/living/victim

	for(var/mob/living/M in T.contents)
		if(M != owner && M.stat == UNCONSCIOUS)
			victim = M
			break

	if(!victim)
		return FALSE

	if(get_dist(owner, victim) > finish_range)
		return FALSE

	StartCooldown()

	INVOKE_ASYNC(src, PROC_REF(do_finish), victim)

	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_finish/proc/do_finish(mob/living/victim)
	if(!victim || QDELETED(victim))
		return

	if(victim.stat != UNCONSCIOUS)
		return

	if(get_dist(owner, victim) > finish_range)
		return

	owner.face_atom(victim)
	victim.face_atom(owner)

	owner.visible_message(
		span_danger("[owner] crouches over [victim].")
	)

	if(finish_sound)
		playsound(owner, finish_sound, 80, TRUE)

	if(finish_delay)
		sleep(finish_delay)

	if(!victim || QDELETED(victim))
		return

	if(victim.stat != UNCONSCIOUS)
		return

	if(get_dist(owner, victim) > finish_range)
		return

	var/turf/T = get_turf(victim)

	if(!T)
		return

	owner.visible_message(
		span_userdanger("[owner] tears [victim] apart!")
	)

	shake_camera(victim, 6, 2)

	if(iscarbon(victim))
		var/mob/living/carbon/C = victim

		C.death(TRUE)

		// Spill the contents of the chest.
		C.spill_organs()

		var/list/parts = list()

		for(var/obj/item/bodypart/part as anything in C.bodyparts)
			if(
				istype(part, /obj/item/bodypart/l_arm) || \
				istype(part, /obj/item/bodypart/r_arm) || \
				istype(part, /obj/item/bodypart/l_leg) || \
				istype(part, /obj/item/bodypart/r_leg)
			)
				parts += part

		for(var/obj/item/bodypart/part as anything in parts)
			if(QDELETED(part))
				continue

			if(!part.drop_limb())
				continue

			part.throw_at(
				get_edge_target_turf(T, pick(GLOB.alldirs)),
				1,
				3
			)

		new /obj/effect/gibspawner/human(T)

		playsound(
			T,
			pick(list(
				'sound/combat/gib (1).ogg',
				'sound/combat/gib (2).ogg'
			)),
			90,
			TRUE
		)

	else
		victim.death()


/datum/action/cooldown/mob_cooldown/fractal_roar
	name = "Fractal Roar"
	desc = "Release a violent shock through your surroundings, knocking nearby creatures from their feet."
	cooldown_time = 12 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "4"

	var/range = 2
	var/knockdown_time = 15
	var/charge_time = 3

	var/sound = 'modular_fenysha_events/sound/fractal_scream3.ogg'


/datum/action/cooldown/mob_cooldown/fractal_roar/Activate(atom/target)
	if(!owner)
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(do_roar))

	StartCooldown()
	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_roar/proc/do_roar()
	owner.visible_message(
		span_danger("[owner] releases a violent pulse of force!")
	)

	// Small wind-up.
	animate(
		owner,
		transform = owner.transform.Scale(1.15, 0.9),
		time = charge_time,
		easing = QUAD_EASING
	)

	sleep(charge_time)

	if(!owner || QDELETED(owner))
		return

	animate(
		owner,
		transform = matrix(),
		time = 2,
		easing = QUAD_EASING
	)

	playsound(owner, sound, 90, TRUE)

	// Simple visual ring around the monster.
	for(var/direction in GLOB.alldirs)
		var/turf/T = get_step(get_turf(owner), direction)

		if(!T)
			continue

		new /obj/effect/temp_visual/decoy/fading/halfsecond(T, owner)

	// Hit everything nearby.
	for(var/mob/living/victim in range(range, owner))
		if(victim == owner)
			continue

		if(victim.stat == DEAD)
			continue

		victim.Knockdown(knockdown_time)
		shake_camera(victim, 4, 1)



/datum/action/cooldown/mob_cooldown/fractal_repulse
	name = "Fractal Repulse"
	desc = "Blast nearby creatures away from you."
	cooldown_time = 9 SECONDS
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "1"

	var/range = 2
	var/throw_distance = 3
	var/throw_speed = 4

	var/sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'


/datum/action/cooldown/mob_cooldown/fractal_repulse/Activate(atom/target)
	if(!owner)
		return FALSE

	INVOKE_ASYNC(src, PROC_REF(do_repulse))

	StartCooldown()
	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_repulse/proc/do_repulse()
	owner.visible_message(
		span_danger("[owner] releases a violent burst of force!")
	)

	// Brief anticipation.
	animate(
		owner,
		transform = owner.transform.Scale(0.9, 1.1),
		time = 3,
		easing = QUAD_EASING
	)

	sleep(3)

	if(!owner || QDELETED(owner))
		return

	animate(
		owner,
		transform = matrix(),
		time = 2,
		easing = QUAD_EASING
	)

	playsound(owner, sound, 100, TRUE)

	var/turf/origin = get_turf(owner)

	if(!origin)
		return

	for(var/mob/living/victim in range(range, origin))
		if(victim == owner)
			continue

		if(victim.stat == DEAD)
			continue

		var/turf/victim_turf = get_turf(victim)

		if(!victim_turf)
			continue

		var/direction = get_dir(origin, victim_turf)

		if(!direction)
			direction = pick(GLOB.alldirs)

		var/turf/destination = get_ranged_target_turf(
			victim_turf,
			direction,
			throw_distance
		)

		if(destination)
			victim.throw_at(
				destination,
				throw_distance,
				throw_speed
			)

		shake_camera(victim, 5, 1)


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
		pawn.actions.Find(/datum/action/cooldown/mob_cooldown/fractal_roar)

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
        repulse,
        BB_BASIC_MOB_CURRENT_TARGET
    )

    return SUBTREE_RETURN_FINISH_PLANNING
