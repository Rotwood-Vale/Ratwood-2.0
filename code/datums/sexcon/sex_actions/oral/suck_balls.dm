/datum/sex_action/suck_balls
	name = "Suck their balls"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_BALLS

/datum/sex_action/suck_balls/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	return !HAS_TRAIT(target, TRAIT_TINY)

/datum/sex_action/suck_balls/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	return !HAS_TRAIT(target, TRAIT_TINY)

/datum/sex_action/suck_balls/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(user, TRAIT_TINY) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] starts licking [target]'s balls..."))
	else
		user.visible_message(span_warning("[user] starts sucking [target]'s balls..."))

/datum/sex_action/suck_balls/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(user, TRAIT_TINY) && !HAS_TRAIT(target, TRAIT_TINY))
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] licks [target]'s balls..."))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] sucks [target]'s balls..."))
	user.sexcon.oralcourse_noise(user)

	user.sexcon.perform_sex_action(target, 1, 3, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/suck_balls/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(user, TRAIT_TINY) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] stops licking [target]'s balls ..."))
	else
		user.visible_message(span_warning("[user] stops sucking [target]'s balls ..."))

/datum/sex_action/suck_balls/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
