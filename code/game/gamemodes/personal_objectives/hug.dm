/datum/objective/hug_beggar
	name = "拥抱镇民"
	triumph_count = 0

/datum/objective/hug_beggar/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_MOB_HUGGED, PROC_REF(on_hug))
	update_explanation_text()

/datum/objective/hug_beggar/Destroy()
	UnregisterSignal(owner.current, COMSIG_MOB_HUGGED)
	return ..()

/datum/objective/hug_beggar/proc/on_hug(datum/source, mob/living/target)
	SIGNAL_HANDLER
	if(completed)
		return

	if(target.job == "Towner" || istype(target.mind?.assigned_role, /datum/job/roguetown/villager))
		to_chat(owner.current, span_greentext("你拥抱了一位本地居民，完成了伊欧拉的目标！"))
		owner.current.adjust_triumphs(1)
		completed = TRUE
		adjust_storyteller_influence("Eora", 10)
		escalate_objective()
		UnregisterSignal(owner.current, COMSIG_MOB_HUGGED)

/datum/objective/hug_beggar/update_explanation_text()
	explanation_text = "人人都值得被爱！拥抱一位镇民，以取悦伊欧拉！"
