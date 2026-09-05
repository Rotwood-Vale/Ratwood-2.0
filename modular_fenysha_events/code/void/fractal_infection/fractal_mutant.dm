/*
 * The fractal mutants themselves.
 *
 * Only what the mob is: stats, look, and the procs it runs on its own. Its
 * decision making lives in fractal_mutant_ai.dm and the actions it fires in
 * fractal_mutant_abilities.dm; both are included after this file, so the
 * blackboard key below reaches them.
 */

/// Set while a fatality is playing out, to keep the planner off the pawn.
#define BB_FRACTAL_FATALITY_ACTIVE "bb_fractal_fatality_active"

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
	desc = "A massive, monstrous abomination. The shape of it does not settle - edges you were sure of a moment ago are somewhere else now, and you cannot say when they moved. Looking at any one part of it is easy enough. Holding two parts in mind at once is not."

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
	desc = "It is built the way the others are, but there is more of it, and the extra does not go anywhere you can follow. The air ahead of it leans. Nothing is touching it, and it leans anyway."
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



