/datum/sex_action/masturbate_other_anus
	name = "Finger their butt"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_ANUS

/datum/sex_action/masturbate_other_anus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] starts fucking [target]'s butt with their finger..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user] starts fingering [target]'s butt..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_other_anus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/tiny_target_fingering = HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY)
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	if(tiny_target_fingering)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] fucks [target]'s butt with their finger..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] fingers [target]'s butt..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(target, 2, 6, TRUE)
	target.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_other_anus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] stops fucking [target]'s butt with their finger."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user] stops fingering [target]'s butt."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate_other_anus/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
