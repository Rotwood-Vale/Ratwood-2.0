/datum/sex_action/blowjob
	handles_target_climax = TRUE
	name = "Suck them off"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_COCK
	knot_on_finish = TRUE

/datum/sex_action/blowjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	return !HAS_TRAIT(target, TRAIT_TINY)

/datum/sex_action/blowjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	return !HAS_TRAIT(target, TRAIT_TINY)

/datum/sex_action/blowjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(user, TRAIT_TINY) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] starts licking [target]'s cock..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user] starts sucking [target]'s cock..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = FALSE

/datum/sex_action/blowjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle
	var/tiny_user_licking = HAS_TRAIT(user, TRAIT_TINY) && !HAS_TRAIT(target, TRAIT_TINY)
	if(tiny_user_licking)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] licks [target]'s cock..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else if(!user.sexcon.do_knot_action_as_bottom)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] sucks [target]'s cock..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] sucks [target]'s cock, taking the knot into their mouth..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.oralcourse_noise(user)
		user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	if(!target.sexcon.considered_limp())
		user.sexcon.perform_deepthroat_oxyloss(user, 1.3)
	if(target.sexcon.check_active_ejaculation())
		if(tiny_user_licking)
			target.visible_message(span_lovebold("[target] cums onto [user]'s hair and face!"))
			target.sexcon.cum_onto(user)
		else
			target.visible_message(span_love("[target] cums into [user]'s mouth!"))
			for(var/i = 1; i <= target.sexcon.get_load_bursts(); i++)
				target.sexcon.cum_into(oral = TRUE, splashed_user = user, knot_action = src, knot_swap_roles = TRUE, knot_btm = user, consume_charge = i == 1 ? TRUE : FALSE)
				sleep(10)

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/blowjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(user, TRAIT_TINY) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] stops licking [target]'s cock ..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user] stops sucking [target]'s cock ..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/blowjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
