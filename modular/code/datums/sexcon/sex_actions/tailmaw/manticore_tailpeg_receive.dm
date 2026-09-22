/datum/sex_action/manticore_tailpeg_receive
	parent_type = /datum/sex_action/tailmaw
	name = "Fuck their tail maw"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_COCK
	user_needs_functional = TRUE
	target_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tailpeg_receive/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] spreads apart the plates on [target]'s tail and sinks [user.p_their()] cock into the waiting maw, feelers immediately latching on with hungry suction."))

/datum/sex_action/manticore_tailpeg_receive/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user] gently rocks into [target]'s tail maw, the feelers inside pulsing around [user.p_their()] shaft in warm, milking waves."
		if(SEX_FORCE_MID)
			message = "[user] fucks [target]'s tail with growing need, the maw clenching in response, feelers spiraling tight around [user.p_their()] cock."
		if(SEX_FORCE_HIGH)
			message = "[user] pounds [target]'s tail maw, each thrust making the orifice squelch obscenely as the feelers inside writhe and grip."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user] uses [target]'s tail like a cocksleeve, hammering the maw with reckless force, feelers torn between gripping and being crushed by the brutality."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(user, 3, 0, TRUE)
	handle_tailmaw_ejaculation(user, target, user, target)
	user.sexcon.perform_sex_action(target, 2.4, 7, FALSE)
	target.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tailpeg_receive/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] cock free from [target]'s tail maw with a slick pop, trails of nectar clinging stubbornly."))

/datum/sex_action/manticore_tailpeg_receive/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.finished_check()
