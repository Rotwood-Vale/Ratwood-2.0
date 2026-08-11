/datum/sex_action/kissing
	name = "Make out with them"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/kissing/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	user.visible_message(span_warning("[user] starts making out with [target]..."))

/datum/sex_action/kissing/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] makes out with [target]..."))
	if(user.sexcon.force > SEX_FORCE_MID)
		user.sexcon.oralcourse_noise(target)
	else
		user.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(user, 1, 2, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.perform_sex_action(target, 1, 2, TRUE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/kissing/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	user.visible_message(span_warning("[user] stops making out with [target] ..."))
