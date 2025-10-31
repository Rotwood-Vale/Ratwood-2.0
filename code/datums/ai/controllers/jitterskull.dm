// Jitterskull-specific AI controller: moves all mob Initialize() loops into proper AI planning/idle behavior

/datum/ai_controller/jitterskull
	movement_delay = 0.15 SECONDS
	ai_movement = /datum/ai_movement/hybrid_pathing

	blackboard = list(
		BB_TARGETTING_DATUM = new /datum/targetting_datum/basic()
	)

	planning_subtrees = list(
		/datum/ai_planning_subtree/jitterskull/maintain_vendetta,
		/datum/ai_planning_subtree/jitterskull/guard_helpless,
		/datum/ai_planning_subtree/jitterskull/anti_stuck_and_tether,
		/datum/ai_planning_subtree/simple_find_target/closest,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
	)

	idle_behavior = /datum/idle_behavior/jitterskull_search

/datum/ai_controller/jitterskull/TryPossessPawn(atom/new_pawn)
	. = ..()
	// Kick off the spawn cinematic outside Initialize() to avoid sleeping there
	var/mob/living/simple_animal/hostile/rogue/jitterskull/J = new_pawn
	if(istype(J))
		spawn(0)
			J.spawn_cinematic()
	return
