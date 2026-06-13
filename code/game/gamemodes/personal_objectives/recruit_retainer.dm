/datum/objective/retainer
	name = "招募侍从"
	triumph_count = 0
	var/retainers_recruited = 0

/datum/objective/retainer/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(SSdcs, COMSIG_GLOB_ROLE_CONVERTED, PROC_REF(on_retainer_recruited))
	update_explanation_text()

/datum/objective/retainer/Destroy()
	UnregisterSignal(SSdcs, COMSIG_GLOB_ROLE_CONVERTED)
	return ..()

/datum/objective/retainer/proc/on_retainer_recruited(datum/source, mob/living/carbon/human/recruiter, mob/living/carbon/human/recruit, new_role)
	SIGNAL_HANDLER
	if(recruiter != owner.current || new_role != "Retainer of [recruiter.real_name]")
		return

	retainers_recruited++
	if(retainers_recruited >= 1 && !completed)
		complete_objective()

/datum/objective/retainer/proc/complete_objective()
	to_chat(owner.current, span_greentext("你已招募一名侍从，完成了阿斯特拉塔的目标！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Astrata", 10)
	escalate_objective()

/datum/objective/retainer/update_explanation_text()
	explanation_text = "至少招募一名侍从为你效力，以向阿斯特拉塔证明你的领导能力。"

/obj/effect/proc_holder/spell/self/convertrole/retainer
	name = "招募侍从"
	new_role = "Retainer"
	overlay_state = "recruit_guard"
	recruitment_faction = "Retainers"
	recruitment_message = "成为我的侍从，为我效力吧，%RECRUIT！"
	accept_message = "我愿向你宣誓效忠！"
	refuse_message = "我必须拒绝你的提议。"


/obj/effect/proc_holder/spell/self/convertrole/retainer/convert(mob/living/carbon/human/recruit, mob/living/carbon/human/recruiter)
	if(QDELETED(recruit) || QDELETED(recruiter))
		return FALSE

	new_role = "Retainer of [recruiter.real_name]"

	. = ..()
	if(!.)
		return FALSE
