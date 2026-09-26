/datum/sex_action/manticore_fist_maw
	parent_type = /datum/sex_action/tailmaw
	name = "Fist their tail maw"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_fist_maw/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pries apart the plates of [target]'s tail maw and pushes [user.p_their()] fist inside, the feelers immediately swarming [user.p_their()] fingers with desperate suction."))

/datum/sex_action/manticore_fist_maw/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user] slowly works [user.p_their()] fingers inside [target]'s tail maw, the feelers curling around each digit individually, tasting skin and pulling gently."
		if(SEX_FORCE_MID)
			message = "[user] pumps [user.p_their()] fist in and out of [target]'s tail, the maw's walls clenching around the intrusion as feelers coat [user.p_their()] wrist in warm, sweet slick."
		if(SEX_FORCE_HIGH)
			message = "[user] fists [target]'s tail maw with rough, twisting strokes, the orifice squelching obscenely around [user.p_their()] arm as the feelers grip and suckle at every knuckle."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user] rams [user.p_their()] arm elbow-deep into [target]'s tail maw, the muscular walls bearing down with bruising force as the feelers writhe and suction to [user.p_their()] skin in a frenzied mass."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	user.sexcon.perform_sex_action(target, 2, 3, FALSE)
	target.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_fist_maw/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] arm free from [target]'s tail maw, the orifice gaping and trembling, feelers straining after the retreating limb."))

/datum/sex_action/manticore_fist_maw/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return target.sexcon.finished_check()
