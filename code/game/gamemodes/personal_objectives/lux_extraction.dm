/datum/objective/lux_extraction
	name = "抽取灵辉"
	triumph_count = 0

/datum/objective/lux_extraction/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_LUX_EXTRACTED, PROC_REF(on_lux_extracted))
	update_explanation_text()

/datum/objective/lux_extraction/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_LUX_EXTRACTED)
	return ..()

/datum/objective/lux_extraction/proc/on_lux_extracted(datum/source, mob/living/target)
	SIGNAL_HANDLER
	if(completed)
		return

	to_chat(owner.current, span_greentext("你已抽取灵辉，完成了佩斯特拉的目标！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Pestra", 15)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_LUX_EXTRACTED)

/datum/objective/lux_extraction/update_explanation_text()
	explanation_text = "从活物身上抽取灵辉，以满足佩斯特拉的好奇心！"
