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
	damage_coeff = list(BRUTE = 1, BURN = 0.5, TOX = 0, CLONE = 0, STAMINA = 0, OXY = 0)
	
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
		/datum/action/cooldown/mob_cooldown/fractal_fatality =  "bb_fractal_tearapart",
	)

	COOLDOWN_DECLARE(scream_cd)
	COOLDOWN_DECLARE(fractal_effect_cd)

	base_pixel_x = -12
	pixel_x = -12

/datum/ai_controller/fractal_mutant
	movement_delay = 0.8 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/targeted_mob_ability/check_range/tear_apart,
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
		/datum/action/cooldown/mob_cooldown/simple_charge = "bb_fractal_charge"
	)



/datum/ai_controller/fractal_mutant/forcer
	movement_delay = 0.8 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/targeted_mob_ability/check_range/charge,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk/less_walking


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
	min_range = 0
	max_range = 1
	finish_planning = FALSE


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
	desc = "Seize a nearby victim, lift them from the ground, and tear them apart."
	cooldown_time = 2 MINUTES
	melee_cooldown_time = 0
	shared_cooldown = NONE

	button_icon = 'icons/obj/magic.dmi'
	button_icon_state = "2"

	var/fatality_range = 1
	var/preparation_time = 2 SECONDS
	var/lift_time = 1.5 SECONDS
	var/flip_time = 2 SECONDS
	var/kill_time = 3 SECONDS

	var/grab_sound = 'modular_fenysha_events/sound/fractal_scream2.ogg'
	var/kill_sound = 'modular_fenysha_events/sound/fractal_glitch2.ogg'


/datum/action/cooldown/mob_cooldown/fractal_fatality/PreActivate(atom/target)
	target = get_turf(target)

	if(get_dist(owner, target) > fatality_range)
		return FALSE

	var/mob/living/victim = locate() in target.contents
	if(!victim || victim == owner)
		return FALSE

	if(victim.stat == DEAD)
		return FALSE

	return ..()


/datum/action/cooldown/mob_cooldown/fractal_fatality/Activate(atom/target)
	var/turf/T = get_turf(target)

	var/mob/living/victim
	for(var/mob/living/M in T.contents)
		if(M != owner && M.stat != DEAD)
			victim = M
			break

	if(!victim)
		return FALSE

	if(get_dist(owner, victim) > fatality_range)
		return FALSE

	StartCooldown()
	INVOKE_ASYNC(src, PROC_REF(do_fatality), victim)
	return TRUE


/datum/action/cooldown/mob_cooldown/fractal_fatality/proc/do_fatality(mob/living/victim)
	if(!victim || QDELETED(victim) || victim.stat == DEAD)
		return

	victim.Stun(1 MINUTES)
	victim.Knockdown(1 MINUTES)

	var/mob/living/living_onwer = owner

	living_onwer.Stun(6 SECONDS)
	owner.face_atom(victim)
	victim.face_atom(owner)

	owner.visible_message(span_userdanger("[owner] suddenly grabs [victim]!"))

	if(grab_sound)
		playsound(owner, grab_sound, 80, TRUE)

	// Small anticipation pause.
	if(!do_after(owner, preparation_time, target = victim))
		return

	if(!victim || QDELETED(victim))
		return

	if(get_dist(owner, victim) > fatality_range)
		return

	owner.visible_message(span_userdanger("[owner] lifts [victim] off the ground!"))

	// Raise the victim.
	animate(
		victim,
		pixel_y = victim.pixel_y + 12,
		time = lift_time,
		easing = QUAD_EASING
	)

	// Make the monster pull them closer.
	animate(
		owner,
		pixel_y = owner.pixel_y + 2,
		time = lift_time,
		easing = QUAD_EASING
	)

	sleep(lift_time)

	if(!victim || QDELETED(victim))
		return

	if(get_dist(owner, victim) > fatality_range)
		return

	owner.visible_message(span_userdanger("[victim] hangs helplessly above the ground in [owner]'s grasp."))
	sleep(6)


	if(!victim || QDELETED(victim))
		return

	if(get_dist(owner, victim) > fatality_range)
		return

	owner.visible_message(span_userdanger("[owner] violently twists [victim] upside down!"))

	animate(
		victim,
		transform = victim.transform.Turn(180),
		time = flip_time,
		easing = QUAD_EASING
	)

	sleep(flip_time)

	if(!victim || QDELETED(victim))
		return
	if(get_dist(owner, victim) > fatality_range)
		return

	playsound(owner, kill_sound, 100, TRUE)
	owner.visible_message(span_userdanger("[owner] tears [victim] apart!"))

	// A tiny anticipation animation.
	animate(
		owner,
		pixel_x = owner.pixel_x + 2,
		time = 2
	)

	// Stretch the victim vertically before the tear.
	animate(
		victim,
		transform = victim.transform.Scale(1, 1.3),
		time = 4,
		easing = QUAD_EASING
	)

	sleep(kill_time)

	if(!victim || QDELETED(victim))
		return

	if(get_dist(owner, victim) > fatality_range)
		return

	var/turf/kill_turf = get_turf(victim)
	if(!kill_turf)
		return

	// The final violent pull.
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

	// Make the victim appear to scream / struggle at the very last moment.
	victim.visible_message(
		span_userdanger("[owner] violently tears [victim] apart!")
	)

	sleep(3)

	if(!victim || QDELETED(victim))
		return

	if(iscarbon(victim))
		var/mob/living/carbon/C = victim
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
			pick(list('sound/combat/gib (1).ogg','sound/combat/gib (2).ogg')),
			100,
			TRUE
		)

	else
		victim.adjustBruteLoss(200)

		if(victim.stat != DEAD)
			victim.death()

	if(kill_turf)
		new /obj/effect/gibspawner/human(kill_turf)
	animate(owner, pixel_y = 0, time = 4)
