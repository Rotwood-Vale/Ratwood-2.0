/datum/objective/proper_burial
	name = "祝圣坟墓"
	triumph_count = 0
	var/burials_completed = 0
	var/required_burials = 1

/datum/objective/proper_burial/on_creation()
	. = ..()
	if(owner?.current)
		if(owner.current.job == "Acolyte" || istype(owner.current.mind?.assigned_role, /datum/job/roguetown/monk))
			required_burials = 2
		RegisterSignal(owner.current, COMSIG_GRAVE_CONSECRATED, PROC_REF(on_grave_consecrated))
	update_explanation_text()

/datum/objective/proper_burial/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_GRAVE_CONSECRATED)
	return ..()

/datum/objective/proper_burial/proc/on_grave_consecrated(datum/source, obj/structure/closet/dirthole/hole)
	SIGNAL_HANDLER
	if(completed)
		return

	burials_completed++
	if(burials_completed >= required_burials)
		complete_objective()
	else
		to_chat(owner.current, span_notice("坟墓已祝圣！再祝圣 [required_burials - burials_completed] 座即可完成内克拉的试炼。"))

/datum/objective/proper_burial/proc/complete_objective()
	to_chat(owner.current, span_greentext("你已祝圣足够多的坟墓，赢得了内克拉的认可！"))
	owner.current.adjust_triumphs(1)
	completed = TRUE
	adjust_storyteller_influence("Necra", 15)
	escalate_objective()
	UnregisterSignal(owner.current, COMSIG_GRAVE_CONSECRATED)

/datum/objective/proper_burial/update_explanation_text()
	explanation_text = "通过建造墓碑或施行葬礼仪式，祝圣 [required_burials] 座坟墓，以赢得内克拉的认可。"
