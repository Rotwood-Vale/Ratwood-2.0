/datum/sex_action/masturbate_other_vagina_finger
	name = "Finger their pussy"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_CUNT

/datum/sex_action/masturbate_other_vagina_finger/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] starts fucking [target]'s [pick("slit","cunt","pussy","snatch")] with their fingers..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user] starts fingering [target]'s [pick("slit","cunt","pussy","snatch")]..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_other_vagina_finger/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/tiny_target_fingering = HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY)
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	if(tiny_target_fingering)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] fucks [target]'s [pick("slit","cunt","pussy","snatch")] with their finger..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] fingers [target]'s [pick("slit","cunt","pussy","snatch")]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)

	target.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_other_vagina_finger/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] stops fucking [target]'s [pick("slit","cunt","pussy","snatch")] with their finger."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user] stops fingering [target]'s [pick("slit","cunt","pussy","snatch")]."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate_other_vagina_finger/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
