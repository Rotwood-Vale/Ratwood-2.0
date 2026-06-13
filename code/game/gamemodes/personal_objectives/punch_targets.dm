/datum/objective/punch_people
	name = "痛殴他人"
	triumph_count = 0
	var/punches_done = 0
	var/punches_required = 3

/datum/objective/punch_people/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_HEAD_PUNCHED, PROC_REF(on_head_punched))
	update_explanation_text()

/datum/objective/punch_people/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_HEAD_PUNCHED)
	return ..()

/datum/objective/punch_people/proc/on_head_punched(datum/source, mob/living/carbon/human/woman)
	SIGNAL_HANDLER
	if(completed)
		return

	punches_done++

	if(punches_done < punches_required)
		to_chat(owner.current, span_notice("已挥拳打脸！还需要 [punches_required - punches_done] 次打脸。"))

	if(punches_done >= punches_required)
		complete_objective()

/datum/objective/punch_people/proc/complete_objective()
	to_chat(owner.current, span_greentext("你已经狠狠干了足够多的脸，令格拉加尔感到满意！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Graggar", 15)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_HEAD_PUNCHED)

/datum/objective/punch_people/update_explanation_text()
	explanation_text = "朝别人的脸狠狠干上 [punches_required] 拳，以彰显你对格拉加尔的虔诚！"
