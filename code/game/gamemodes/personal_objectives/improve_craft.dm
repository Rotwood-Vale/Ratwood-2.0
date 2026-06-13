/datum/objective/improve_craft
	name = "提升工艺技艺"
	triumph_count = 0
	var/levels_gained = 0
	var/required_levels = 2

/datum/objective/improve_craft/on_creation()
	. = ..()
	if(owner?.current)
		RegisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED, PROC_REF(on_skill_improved))
	update_explanation_text()

/datum/objective/improve_craft/Destroy()
	if(owner?.current)
		UnregisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED)
	return ..()

/datum/objective/improve_craft/proc/on_skill_improved(datum/source, datum/skill/skill_ref, new_level, old_level)
	SIGNAL_HANDLER
	if(completed)
		return

	if(!istype(skill_ref, /datum/skill/craft))
		return

	var/real_old = (old_level == SKILL_LEVEL_NONE && !(skill_ref in owner.current.skills?.known_skills)) ? SKILL_LEVEL_NONE : old_level

	if(new_level <= real_old)
		return

	var/level_diff = new_level - real_old
	levels_gained += level_diff

	if(levels_gained >= required_levels)
		to_chat(owner.current, span_greentext("你的工艺技艺已提升到足以取悦玛勒姆！"))
		owner.current.adjust_triumphs(1)
		completed = TRUE
		adjust_storyteller_influence("Malum", 10)
		escalate_objective()
		UnregisterSignal(owner.current, COMSIG_SKILL_RANK_INCREASED)
	else
		var/remaining = required_levels - levels_gained
		to_chat(owner.current, span_notice("工艺技能已提升！还需要 [remaining] 级才能完成玛勒姆的试炼！"))

/datum/objective/improve_craft/update_explanation_text()
	explanation_text = "通过练习或梦境获得 [required_levels] 级新的工艺技能等级，以此磨炼你的手艺。为了玛勒姆！"
