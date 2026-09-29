/datum/sex_action/manticore_maw_rimjob
	parent_type = /datum/sex_action/tailmaw
	name = "Rim their ass with tail maw"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_TAIL_MAW
	target_sex_part = SEX_PART_ANUS

/datum/sex_action/manticore_maw_rimjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]'s tail maw flowers wide before suctioning to [target]'s rear as curious tendrils begin to massage and probe their asshole."))

/datum/sex_action/manticore_maw_rimjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_perform(user, target))
		return FALSE
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "Each tendril trapses [user.sexcon.get_generic_force_adjective()] along the wrinkled ring, circling it, occassioanlly teasing [target]'s insides with an exploratory prod."
		if(SEX_FORCE_MID)
			message = "With a sound like furious slurping, the hundreds of feelers coat [target]'s ass with a generous gloss of mucosal venom. The tendrils [user.sexcon.get_generic_force_adjective()] toy and play with [target.p_their()] butthole, pulling the rim wide little-by-little."
		if(SEX_FORCE_HIGH)
			message = "[user]'s tail maw holds [target] in a tight seal. The extruding tendrils crowd and coil one another, [user.sexcon.get_generic_force_adjective()] boring into [target.p_their()] rear, stretching it wide and painful around the undulating mass."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "The tendrils borrow deep, worming a path through [target]'s intestines, [user.sexcon.get_generic_force_adjective()] scraping along their walls as girth gaping their shithole pushing the flesh to near-fissure."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	target.sexcon.handle_passive_ejaculation()
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)
	return TRUE

/datum/sex_action/manticore_maw_rimjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(span_notice("[user]'s tail maw lets go of [target] with a wet sigh, its tendrils slipping free of [target.p_their()] painfully gaped and leaking asshole."))

/datum/sex_action/manticore_maw_rimjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check() || target.sexcon.finished_check()
