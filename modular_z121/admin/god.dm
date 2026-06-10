#define TRAIT_ADMIN_GOD "God"

/proc/admin_god_stat_keys()
	return list(
		STATKEY_STR,
		STATKEY_PER,
		STATKEY_INT,
		STATKEY_CON,
		STATKEY_WIL,
		STATKEY_SPD,
		STATKEY_LCK,
	)

/proc/admin_god_ensure_skill_uncaps()
	for(var/skill_type in SSskills.all_skills)
		var/datum/skill/skill_ref = GetSkillRef(skill_type)
		if(!skill_ref)
			continue
		if(!islist(skill_ref.trait_uncap))
			skill_ref.trait_uncap = list()
		skill_ref.trait_uncap[TRAIT_ADMIN_GOD] = SKILL_LEVEL_LEGENDARY

/proc/admin_god_apply(mob/living/target)
	if(!target)
		return FALSE

	admin_god_ensure_skill_uncaps()
	ADD_TRAIT(target, TRAIT_ADMIN_GOD, TRAIT_ADMIN_GOD)

	for(var/statkey in admin_god_stat_keys())
		var/current_value = target.get_stat(statkey)
		if(isnull(current_value))
			continue
		var/difference = 20 - current_value
		if(difference)
			target.change_stat(statkey, difference)

	var/datum/skill_holder/skill_holder = target.ensure_skills()
	for(var/skill_type in SSskills.all_skills)
		skill_holder.adjust_skillrank_up_to(skill_type, SKILL_LEVEL_LEGENDARY, TRUE)

	target.update_stamina()
	target.updatehealth()
	return TRUE

/client/proc/god()
	set category = "-GameMaster-"
	set name = "God"
	set desc = "Grant the God trait to a selected player and perfect their stats and skills."

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return

	var/already_god = HAS_TRAIT(target, TRAIT_ADMIN_GOD)
	if(!admin_god_apply(target))
		to_chat(src, span_warning("Failed to grant the God trait to [target]."))
		return

	if(already_god)
		to_chat(src, span_notice("Reapplied the God trait to [target] and restored all stats and skills to their divine maximum."))
		to_chat(target, span_notice("Divine power floods through me once more. My God trait restores my stats and skills to perfection."))
		log_admin("[key_name(usr)] reapplied the God trait to [key_name(target)] and restored all stats and skills to their maximum.")
		message_admins(span_adminnotice("[key_name_admin(usr)] reapplied the God trait to [key_name_admin(target)] and restored all stats and skills to their maximum."))
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] has reapplied the God trait to you and restored all stats and skills to their maximum.</font>")
	else
		to_chat(src, span_notice("Granted the God trait to [target]. Their stats are now 20 and all skills are capped and set to 6."))
		to_chat(target, span_notice("I have been granted the God trait. My stats are now perfect, and all my skills are legendary."))
		log_admin("[key_name(usr)] granted the God trait to [key_name(target)], setting all stats to 20 and all skill caps and levels to 6.")
		message_admins(span_adminnotice("[key_name_admin(usr)] granted the God trait to [key_name_admin(target)], setting all stats to 20 and all skill caps and levels to 6."))
		admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] has granted you the God trait, setting all stats to 20 and all skill caps and levels to 6.</font>")

	SSblackbox.record_feedback("tally", "admin_verb", 1, "God")

#undef TRAIT_ADMIN_GOD
