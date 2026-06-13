/datum/objective/literacy
	name = "学会识字"
	triumph_count = 0

/datum/objective/literacy/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED, PROC_REF(on_skill_increased))
	update_explanation_text()

/datum/objective/literacy/Destroy()
	UnregisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED)
	return ..()

/datum/objective/literacy/proc/on_skill_increased(datum/source, datum/skill/skill_ref, new_level, old_level)
	SIGNAL_HANDLER
	if(completed)
		return

	if(istype(skill_ref, /datum/skill/misc/reading) && old_level == SKILL_LEVEL_NONE && new_level > SKILL_LEVEL_NONE)
		to_chat(owner.current, span_greentext("你已学会阅读，完成了诺克的目标！"))
		owner.current.adjust_triumphs(1)
		completed = TRUE
		adjust_storyteller_influence("Noc", 10)
		escalate_objective()
		UnregisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED)

/datum/objective/literacy/update_explanation_text()
	explanation_text = "摆脱你的无知！学会阅读，取悦诺克！"
