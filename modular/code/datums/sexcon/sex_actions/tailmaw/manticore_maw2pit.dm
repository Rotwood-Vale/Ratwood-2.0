/datum/sex_action/manticore_maw2pit
	parent_type = /datum/sex_action/tailmaw
	name = "Suck their armpit with tail maw"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_CHEST
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_maw2pit/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]'s tail puckers against [target]'s raised arm suctions to their pit, its feelers beginning to smear the pungent skin with a gloss of sexual fluids."))

/datum/sex_action/manticore_maw2pit/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_perform(user, target))
		return FALSE
	..()
	var/armpit_description = user.sexcon.get_armpit_description(target)
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]'s tail maw nuzzles [user.sexcon.get_generic_force_adjective()] beneath [target]'s arm, suckling [target.p_their()] [armpit_description] inward before letting the skin pop free with a moist +snap+!"
		if(SEX_FORCE_MID)
			message = "Tendrils lick and fondle [target]'s [armpit_description], [user.sexcon.get_generic_force_adjective()] slurping the salt from [target.p_their()] skin while the bud maintains a warm, snug seal."
		if(SEX_FORCE_HIGH)
			message = "[user]'s tail clamps [user.sexcon.get_generic_force_adjective()] beneath [target]'s arm, feelers painting [target.p_their()] [armpit_description] with venom gloss as the maw drinks in the heady scent of stewed sweat and nectar."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "The tail overflows with ooze as it [user.sexcon.get_generic_force_adjective()] frots against [target]'s [armpit_description]. Tendrils extrude, anchoring around [target]'s shoulder as [user] pleasures their tailcunt with [target.p_their()] underarms."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.oralcourse_noise(user, TRUE)
	user.sexcon.perform_sex_action(target, 1, 0, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	target.sexcon.handle_passive_ejaculation()
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)
	return TRUE

/datum/sex_action/manticore_maw2pit/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]'s tail releases [target]'s pit with a damp pop, its feelers trailing away, leaving the violated skin tingling and slick with [user.p_their()] tailcunt's dischage."))

/datum/sex_action/manticore_maw2pit/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
