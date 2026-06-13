/datum/objective/consume_organs
	name = "吞食器官"
	triumph_count = 0
	var/organs_consumed = 0
	var/hearts_consumed = 0
	var/organs_required = 2
	var/hearts_required = 1

/datum/objective/consume_organs/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_ORGAN_CONSUMED, PROC_REF(on_organ_consumed))
	update_explanation_text()

/datum/objective/consume_organs/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_ORGAN_CONSUMED)
	return ..()

/datum/objective/consume_organs/proc/on_organ_consumed(datum/source, organ_type)
	SIGNAL_HANDLER
	if(completed)
		return

	organs_consumed++

	if(ispath(organ_type, /obj/item/reagent_containers/food/snacks/organ/heart))
		hearts_consumed++
		to_chat(owner.current, span_cult("当你吞下心脏时，你感受到了格拉加尔的愉悦！"))
	else
		to_chat(owner.current, span_notice("已吞食器官！还需要 [organs_required - organs_consumed] 个器官。"))

	if(organs_consumed >= organs_required && hearts_consumed >= hearts_required)
		complete_objective()

/datum/objective/consume_organs/proc/complete_objective()
	to_chat(owner.current, span_greentext("你已吞食足够的器官与心脏，令格拉加尔感到满意！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Graggar", 15)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_ORGAN_CONSUMED)

/datum/objective/consume_organs/update_explanation_text()
	explanation_text = "吞食 [organs_required] 个器官，其中至少包含 [hearts_required] 颗心脏，以平息格拉加尔的欲望！"
