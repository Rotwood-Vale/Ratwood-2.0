/datum/objective/taste_lux
	name = "品尝神性精华"
	triumph_count = 0

/datum/objective/taste_lux/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_LUX_TASTED, PROC_REF(on_lux_tasted))
	update_explanation_text()

/datum/objective/taste_lux/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_LUX_TASTED)
	return ..()

/datum/objective/taste_lux/proc/on_lux_tasted()
	SIGNAL_HANDLER
	to_chat(owner.current, span_greentext("你已品尝神性精华，完成了巴奥莎的目标！"))
	owner.current.adjust_triumphs(2)
	completed = TRUE
	adjust_storyteller_influence("Baotha", 20)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_LUX_TASTED)

/datum/objective/taste_lux/update_explanation_text()
	explanation_text = "品尝禁忌的灵辉精华，亲身感受神性！巴奥莎正注视着你……"
