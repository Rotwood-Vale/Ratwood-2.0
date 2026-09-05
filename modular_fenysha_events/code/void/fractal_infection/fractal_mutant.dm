/mob/living/simple_animal/hostile/fractal_mutant
	name = "Fractal Mutant"
	desc = "A creature warped by the fractal infection."

	icon = 'modular_fenysha_events/icons/mob/fractal_mutant.dmi'
	base_intents = list(/datum/intent/simple/axe/skeleton)
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

	COOLDOWN_DECLARE(scream_cd)
	COOLDOWN_DECLARE(fractal_effect_cd)

/datum/ai_controller/fractal_mutant
	movement_delay = 0.8 SECONDS

	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		
	)

	idle_behavior = /datum/idle_behavior/idle_random_walk/less_walking




/mob/living/simple_animal/hostile/fractal_mutant/Initialize(mapload)
	. = ..()
	setup_visual()
	AddComponent(/datum/component/alien_examine)


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
		playsound(get_turf(src), pick(scream_sounds), 50, TRUE)
		COOLDOWN_START(src, scream_cd, 6 SECONDS)
