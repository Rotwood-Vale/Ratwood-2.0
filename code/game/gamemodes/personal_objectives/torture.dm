/datum/objective/torture
	name = "以痛逼供"
	triumph_count = 0
	var/torture_count = 0
	var/required_count = 1

/datum/objective/torture/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_TORTURE_PERFORMED, PROC_REF(on_torture_performed))
	update_explanation_text()

/datum/objective/torture/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_TORTURE_PERFORMED)
	return ..()

/datum/objective/torture/proc/on_torture_performed(datum/source, mob/living/victim)
	SIGNAL_HANDLER
	if(completed)
		return

	torture_count++
	if(torture_count >= required_count)
		complete_objective(victim)

/datum/objective/torture/proc/complete_objective(mob/living/victim)
	to_chat(owner.current, span_greentext("你已通过痛苦逼出了真相，令齐佐感到满意！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Zizo", 15)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_TORTURE_PERFORMED)

/datum/objective/torture/update_explanation_text()
	explanation_text = "折磨某人，直到其哀求怜悯，以取悦齐佐！"
