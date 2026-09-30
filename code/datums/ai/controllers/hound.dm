/datum/ai_controller/volf/hound
	planning_subtrees = list(
		/datum/ai_planning_subtree/flee_target,
		/datum/ai_planning_subtree/target_retaliate,
		/datum/ai_planning_subtree/attack_obstacle_in_path,
		/datum/ai_planning_subtree/basic_melee_attack_subtree,
		/datum/ai_planning_subtree/follow_handler
	)

/datum/ai_planning_subtree/follow_handler
	var/handler_key = BB_FOLLOW_TARGET

/datum/ai_planning_subtree/follow_handler/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(QDELETED(controller.blackboard[handler_key]))
		return
	controller.queue_behavior(/datum/ai_behavior/follow_friend, handler_key)
	return SUBTREE_RETURN_FINISH_PLANNING
