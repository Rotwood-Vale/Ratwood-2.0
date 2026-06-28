/*!
This subsystem mostly exists to populate and manage the skill singletons.
*/

SUBSYSTEM_DEF(skills)
	name = "Skills"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SKILLS
	///Dictionary of skill.type || skill ref
	var/list/all_skills = list()
	///Static assoc list of levels (ints) - strings
	var/static/list/level_names = alist(
		SKILL_LEVEL_NOVICE = span_info("<span class='small'>新手</span>"),
		SKILL_LEVEL_APPRENTICE = span_info("学徒"),
		SKILL_LEVEL_JOURNEYMAN = span_biginfo("熟练"),
		SKILL_LEVEL_EXPERT = span_biginfo("专家"),
		SKILL_LEVEL_MASTER = "<b>大师</b>",
		SKILL_LEVEL_LEGENDARY = span_greentext("<b>传奇</b>"),
	)//This list is already in the right order, due to indexing
	///Plain level names without the span
	var/static/list/level_names_plain = alist(
		SKILL_LEVEL_NOVICE = "新手",
		SKILL_LEVEL_APPRENTICE = "学徒",
		SKILL_LEVEL_JOURNEYMAN = "熟练",
		SKILL_LEVEL_EXPERT = "专家",
		SKILL_LEVEL_MASTER = "大师",
		SKILL_LEVEL_LEGENDARY = "传奇",
	)

/datum/controller/subsystem/skills/Initialize(timeofday)
	InitializeSkills()
	return ..()

///Ran on initialize, populates the skills dictionary
/datum/controller/subsystem/skills/proc/InitializeSkills(timeofday)
	for(var/type in typesof(/datum/skill))
		if(is_abstract(type))
			continue
		var/datum/skill/ref = new type
		all_skills[type] = ref

/proc/skill_to_string_fancy(skill_level)
	if(!skill_level)
		return span_warning("None")
	return SSskills.level_names[skill_level]

/proc/skill_to_string(skill_level)
	if(!skill_level)
		return "None"
	return SSskills.level_names_plain[skill_level]
