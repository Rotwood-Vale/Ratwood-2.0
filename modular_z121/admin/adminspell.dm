/client/proc/adminspell_has_target_spell(mob/target, spell_type)
	if(target.mind?.has_spell(spell_type))
		return TRUE

	for(var/obj/effect/proc_holder/spell/existing_spell as anything in target.mob_spell_list)
		if(istype(existing_spell, spell_type))
			return TRUE

	return FALSE

/client/proc/adminspell_get_target()
	var/list/keys = list()
	for(var/mob/player_mob in GLOB.player_list)
		if(player_mob.client)
			keys += player_mob.client

	var/client/selection = input("Please, select a player!", "Admin Spell", null, null) as null|anything in sortKey(keys)
	if(!selection)
		return null

	if(!isliving(selection.mob))
		to_chat(src, span_warning("The selected player does not have a living character to receive spells."))
		return null

	return selection.mob

/client/proc/adminspell_spell_types()
	return list(
		/obj/effect/proc_holder/spell/invoked/adminkill,
		/obj/effect/proc_holder/spell/invoked/adminheal,
		/obj/effect/proc_holder/spell/invoked/blink/adminblink,
		/obj/effect/proc_holder/spell/invoked/mimicry/copy,
	)

/client/proc/adminspell()
	set category = "-GameMaster-"
	set name = "AdminSpell"
	set desc = "Grant the admin spell package to a selected player."

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return

	var/list/spell_types = adminspell_spell_types()
	var/list/granted_names = list()

	for(var/spell_type in spell_types)
		if(adminspell_has_target_spell(target, spell_type))
			continue

		var/obj/effect/proc_holder/spell/new_spell = new spell_type
		if(target.mind)
			target.mind.AddSpell(new_spell, target)
		else
			target.AddSpell(new_spell)
			message_admins(span_danger("AdminSpell granted spells to a mindless mob; they will not transfer with mind swaps or cloning."))

		granted_names += initial(new_spell.name)

	if(!granted_names.len)
		to_chat(src, span_notice("[target] already knows the full admin spell package."))
		return

	var/spell_summary = english_list(granted_names)
	to_chat(src, span_notice("Granted [spell_summary] to [target]."))
	to_chat(target, span_notice("You have been granted [spell_summary]."))

	log_admin("[key_name(usr)] granted the admin spell package ([spell_summary]) to [key_name(target)].")
	var/msg = span_adminnotice("[key_name_admin(usr)] granted the admin spell package ([spell_summary]) to [key_name_admin(target)].")
	message_admins(msg)
	admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] has granted you the admin spell package ([spell_summary]).</font>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "AdminSpell")

/client/proc/removeadminspell()
	set category = "-GameMaster-"
	set name = "RemoveAdminSpell"
	set desc = "Remove the admin spell package from a selected player."

	if(!check_rights(R_ADMIN))
		return

	var/mob/living/target = adminspell_get_target()
	if(!target)
		return

	var/list/spell_types = adminspell_spell_types()
	var/list/removed_names = list()

	for(var/spell_type in spell_types)
		var/obj/effect/proc_holder/spell/mind_spell = target.mind?.get_spell(spell_type)
		if(mind_spell)
			removed_names += initial(mind_spell.name)
			target.mind.RemoveSpell(mind_spell)
			continue

		for(var/obj/effect/proc_holder/spell/mob_spell as anything in target.mob_spell_list)
			if(!istype(mob_spell, spell_type))
				continue
			removed_names += initial(mob_spell.name)
			target.RemoveSpell(mob_spell)
			break

	if(!removed_names.len)
		to_chat(src, span_notice("[target] does not have any admin spell package spells."))
		return

	var/spell_summary = english_list(removed_names)
	to_chat(src, span_notice("Removed [spell_summary] from [target]."))
	to_chat(target, span_notice("[spell_summary] have been removed from you."))

	log_admin("[key_name(usr)] removed the admin spell package ([spell_summary]) from [key_name(target)].")
	var/msg = span_adminnotice("[key_name_admin(usr)] removed the admin spell package ([spell_summary]) from [key_name_admin(target)].")
	message_admins(msg)
	admin_ticket_log(target, "<font color='green'>[key_name_admin(usr)] has removed the admin spell package ([spell_summary]) from you.</font>")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "RemoveAdminSpell")
