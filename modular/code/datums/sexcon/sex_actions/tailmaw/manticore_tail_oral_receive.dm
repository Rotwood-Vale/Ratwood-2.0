/datum/sex_action/manticore_tail_oral_receive
	parent_type = /datum/sex_action/tailmaw
	name = "Eat out their tail maw"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tail_oral_receive/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] buries [user.p_their()] face in [target]'s blooming tail maw, tongue pushing past the plates as the feelers latch on to [user.p_their()] lips."))

/datum/sex_action/manticore_tail_oral_receive/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user] laps gently at [target]'s tail maw, tongue tracing the rim of the plates as the feelers curl around [user.p_their()] chin, tasting salt and skin."
		if(SEX_FORCE_MID)
			message = "[user] pushes [user.p_their()] tongue deep into [target]'s tail, the feelers wrapping around the wet muscle and pulling it further inside, nectar flooding [user.p_their()] mouth."
		if(SEX_FORCE_HIGH)
			message = "[user] eats [target]'s tail maw with reckless hunger, tongue plunging in and out as the feelers lash and suckle at [user.p_their()] lips, both their faces slicked with sweet nectar."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user] buries [user.p_their()] face so deep in [target]'s tail the maw clamps around [user.p_their()] skull, feelers coating every inch of tongue and lips as the orifice tries to swallow [user.p_their()] head whole."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	user.sexcon.perform_sex_action(target, 3, 0, FALSE)
	handle_tailmaw_oral_climax(target, user)

/datum/sex_action/manticore_tail_oral_receive/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] drenched face from [target]'s tail maw, chin dripping with sweet nectar, the feelers straining after [user.p_them()]."))

/datum/sex_action/manticore_tail_oral_receive/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
