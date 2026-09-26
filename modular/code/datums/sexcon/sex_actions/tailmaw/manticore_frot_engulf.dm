/datum/sex_action/manticore_frot_engulf
	parent_type = /datum/sex_action/tailmaw
	name = "Frot then engulf both cocks with tail"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_COCK | SEX_PART_TAIL_MAW
	target_sex_part = SEX_PART_COCK

/datum/sex_action/manticore_frot_engulf/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] presses [user.p_their()] cock against [target]'s, grinding the two together before [user.p_their()] tail maw blooms open and descends, engulfing both shafts in warm, feeler-lined flesh."))
	playsound(user, 'sound/misc/mat/insert (1).ogg', 25, TRUE, ignore_walls = FALSE)

/datum/sex_action/manticore_frot_engulf/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	var/message
	switch(user.sexcon.force)
		if(SEX_FORCE_LOW)
			message = "[user]'s tail maw pulses around both cocks in lazy, milking waves, the feelers individually tending to each shaft, curling between them where the two press together."
		if(SEX_FORCE_MID)
			message = "The feelers inside [user]'s tail spiral around both cocks in tandem, squeezing and massaging as the maw's walls undulate, slick nectar making both shafts glide against each other."
		if(SEX_FORCE_HIGH)
			message = "[user]'s tail clenches both cocks together with crushing pressure, the feelers going wild, suctioning to every inch of flesh as the maw pumps in hard, rhythmic contractions."
		if(SEX_FORCE_EXTREME to SEX_FORCE_LUDICROUS)
			message = "[user]'s tail bears down on both cocks with bruising, desperate force, feelers writhing between the two shafts in frenzied knots, the maw's muscular walls spasming as it tries to milk both to completion simultaneously."
	user.sexcon_action_message(user.sexcon.spanify_force(message))
	user.sexcon.make_sucking_noise()
	user.sexcon.perform_sex_action(user, 3, 0, TRUE)
	user.sexcon.perform_sex_action(target, 3, 0, TRUE)
	handle_tailmaw_ejaculation(user, target, target, user)
	handle_tailmaw_ejaculation(user, target, user, user)

/datum/sex_action/manticore_frot_engulf/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]'s tail reluctantly releases both cocks, the maw peeling open to reveal both shafts glistening with nectar and each other's spend."))

/datum/sex_action/manticore_frot_engulf/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check() || target.sexcon.finished_check())
		return TRUE
	return FALSE
