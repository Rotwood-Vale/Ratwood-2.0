/datum/objective/nobility
	name = "跻身贵族"
	triumph_count = 0

/datum/objective/nobility/on_creation()
	. = ..()
	if(owner?.current)
		if(HAS_TRAIT(owner.current, TRAIT_NOBLE))
			on_nobility_granted()
		else
			RegisterSignal(owner.current, SIGNAL_ADDTRAIT(TRAIT_NOBLE), PROC_REF(on_nobility_granted))
	update_explanation_text()

/datum/objective/nobility/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, SIGNAL_ADDTRAIT(TRAIT_NOBLE))
	return ..()

/datum/objective/nobility/proc/on_nobility_granted()
	SIGNAL_HANDLER
	if(completed)
		return

	to_chat(owner.current, span_greentext("你已获得贵族身份，完成了阿斯特拉塔的目标！"))
	owner.current.adjust_triumphs(2)
	completed = TRUE
	adjust_storyteller_influence("Astrata", 15)
	escalate_objective()
	UnregisterSignal(owner.current, SIGNAL_ADDTRAIT(TRAIT_NOBLE))

/datum/objective/nobility/update_explanation_text()
	explanation_text = "不择手段跻身贵族之列，以赢得阿斯特拉塔的认可！"
