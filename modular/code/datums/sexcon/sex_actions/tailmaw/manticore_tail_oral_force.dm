/datum/sex_action/manticore_tail_oral_force
	parent_type = /datum/sex_action/tailmaw
	name = "Force tail maw onto their mouth"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_JAWS
	user_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tail_oral_force/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail rises and clamps over [target]'s mouth, the maw blooming open to seal around [target]'s lips, feelers spilling past [target]'s teeth."))

/datum/sex_action/manticore_tail_oral_force/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]'s tail maw pulses gently over [target]'s mouth, the feelers lazily exploring [target]'s tongue and gums, secreting a tingling sweet nectar."
		if(SEX_FORCE_MID)
			message = "The feelers inside [user]'s tail push deeper into [target]'s mouth, curling around [target]'s tongue and pulling it into the warm, slick maw."
		if(SEX_FORCE_HIGH)
			message = "[user]'s tail maw clamps down on [target]'s face, feelers shoving deep into [target]'s throat, the orifice pulsing as it force-feeds its sweet slick down [target]'s gullet."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]'s tail seals [target]'s mouth completely, the feelers writhing down [target]'s throat in a suffocating mass, pumping nectar until it bubbles from [target]'s nose."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	user.sexcon.perform_sex_action(target, 2, 2, TRUE)
	user.sexcon.perform_sex_action(user, 2, 0, FALSE)
	handle_tailmaw_oral_climax(user, target)

/datum/sex_action/manticore_tail_oral_force/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail releases [target]'s mouth, the feelers peeling free with strings of nectar and saliva trailing between them."))

/datum/sex_action/manticore_tail_oral_force/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
