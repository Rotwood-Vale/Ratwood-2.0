/datum/sex_action/manticore_chastity_tease
	parent_type = /datum/sex_action/tailmaw
	name = "Tease their cage with tail feelers"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_COCK
	user_sex_part = SEX_PART_TAIL_MAW
	target_needs_chastity = TRUE

/datum/sex_action/manticore_chastity_tease/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail maw blooms open against [target]'s cage, the feelers inside slipping between the bars to wriggle against the trapped flesh within."))

/datum/sex_action/manticore_chastity_tease/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "The feelers inside [user]'s tail lazily probe through [target]'s cage bars, tracing the contours of [target]'s trapped cock with infuriating slowness, each touch leaving a tingle of venom."
		if(SEX_FORCE_MID)
			message = "More feelers squeeze between [target]'s cage bars, the tiny tendrils wrapping around whatever flesh they can reach, pulsing with warmth and secreting their tingling nectar against [target]'s swelling, caged cock."
		if(SEX_FORCE_HIGH)
			message = "[user]'s tail feelers push aggressively through [target]'s cage, dozens of tendrils wriggling against the trapped shaft, probing [target]'s slit, and smearing venom into every crevice they can reach."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]'s tail seals around [target]'s cage entirely, every feeler inside fighting through the bars in a swarming mass, coating the trapped cock in sweet nectar until it drools from the cage's drain hole."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	user.sexcon.perform_sex_action(target, 3, 0, TRUE)
	user.sexcon.perform_sex_action(user, 1, 0, FALSE)
	user.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_chastity_tease/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail withdraws from [target]'s cage, the feelers reluctantly unthreading from between the bars, strings of nectar trailing behind."))

/datum/sex_action/manticore_chastity_tease/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
