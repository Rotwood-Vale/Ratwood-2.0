/datum/objective/rotten_feast
	name = "腐食盛宴"
	triumph_count = 0
	var/meals_eaten = 0
	var/meals_required = 2

/datum/objective/rotten_feast/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ROTTEN_FOOD_EATEN, PROC_REF(on_rotten_eaten))
	update_explanation_text()

/datum/objective/rotten_feast/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ROTTEN_FOOD_EATEN)
	return ..()

/datum/objective/rotten_feast/proc/on_rotten_eaten(datum/source, obj/item/eaten_food)
	SIGNAL_HANDLER
	if(completed)
		return

	meals_eaten++
	if(meals_eaten >= meals_required)
		to_chat(owner.current, span_greentext("你已吃下足够多的腐败食物，完成了佩斯特拉的目标！"))
		owner.current.adjust_triumphs(1)
		completed = TRUE
		adjust_storyteller_influence("Pestra", 10)
		escalate_objective()
		UnregisterSignal(owner.current, COMSIG_ROTTEN_FOOD_EATEN)
	else
		to_chat(owner.current, span_notice("已吃下腐败餐食！再吃 [meals_required - meals_eaten] 份即可完成佩斯特拉的目标。"))

/datum/objective/rotten_feast/update_explanation_text()
	explanation_text = "莫让任何东西白白浪费！吃下 [meals_required] 份腐败食物，以赢得佩斯特拉的青睐！"
