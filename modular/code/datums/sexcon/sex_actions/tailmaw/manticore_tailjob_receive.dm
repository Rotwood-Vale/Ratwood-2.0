/datum/sex_action/manticore_tailjob_receive
	parent_type = /datum/sex_action/tailmaw
	name = "Use their tail maw on my cock"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_TAIL_MAW

/datum/sex_action/manticore_tailjob_receive/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] grabs [target]'s tail and pushes [user.p_their()] cock into the blooming maw, gasping as the feelers latch on."))
	playsound(user, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_tailjob_receive/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user] slowly rocks [user.p_their()] hips into [target]'s tail maw, the feelers inside pulsing in response to each gentle thrust."
		if(SEX_FORCE_MID)
			message = "[user] fucks [target]'s tail with a steady rhythm, the maw's feelers wrapping tighter with each stroke, slick with sweet nectar."
		if(SEX_FORCE_HIGH)
			message = "[user] ruts into [target]'s tail maw with abandon, the orifice squelching around [user.p_their()] cock as feelers lash at the shaft."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user] rams [user.p_their()] cock into [target]'s tail with punishing force, the maw clenching so hard the feelers bruise, each thrust making the plates rattle."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(user, 3, 0, TRUE)
	handle_tailmaw_ejaculation(user, target, user, target)
	user.sexcon.perform_sex_action(target, 2, 0, FALSE)
	target.sexcon.handle_passive_ejaculation(climax_part = SEX_PART_TAIL_MAW)

/datum/sex_action/manticore_tailjob_receive/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls free from [target]'s tail maw, strings of slick nectar trailing between them."))

/datum/sex_action/manticore_tailjob_receive/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
