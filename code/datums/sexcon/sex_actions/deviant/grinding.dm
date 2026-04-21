/datum/sex_action/grind_body
	name = "Grind against them"
	check_same_tile = FALSE
	subtle_supported = TRUE

/datum/sex_action/grind_body/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/grind_body/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!user.sexcon.Adjacent_Or_Closet(target))
		return FALSE
	if(!target.get_bodypart(check_zone(user.zone_selected)))
		return FALSE
	return TRUE

/datum/sex_action/grind_body/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] presses [user.p_their()] entire tiny body against [target]..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] pulls [target]'s tiny body against [user.p_them()]self..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user] pulls themselves onto [target]..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/grind_body/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/pleasure_target
	var/zone_text
	switch(user.zone_selected)
		if(BODY_ZONE_PRECISE_GROIN)
			zone_text = user.dir == target.dir ? "ass" : "crotch"
			pleasure_target = 1
		if(BODY_ZONE_CHEST)
			zone_text = target.getorganslot(ORGAN_SLOT_BREASTS) ? "tits" : "chest"
			pleasure_target = 1
		else
			zone_text = LOWER_TEXT(parse_zone(user.zone_selected))
			pleasure_target = 0
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	// Seelie-specific grinding messages
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))		var/list/seelie_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] rubs [user.p_their()] whole tiny body against [target]'s [zone_text]...",
			"[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] writhes [user.p_their()] little form against [target]'s [zone_text]...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_msgs)), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		var/list/seelie_recv_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] grinds [user.p_their()] [zone_text] over [target]'s tiny body, practically smothering the fae...",
			"[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] rolls [user.p_their()] [zone_text] against [target]...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_recv_msgs)), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] grinds over [target]'s [zone_text]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		if(user.sexcon.force > SEX_FORCE_HIGH)
			user.sexcon.outercourse_noise(target)
		else
			user.sexcon.make_sucking_noise()
		user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(user, 1, 0.5, TRUE)
	user.sexcon.handle_passive_ejaculation()

	if(pleasure_target)
		user.sexcon.perform_sex_action(target, 1, 0.5, TRUE)
	target.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/grind_body/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] peels [user.p_their()] tiny body away from [target], fae dust sparkling in [user.p_their()] wake..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] pulls away from [target]'s tiny body..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user] stops grinding against [target]..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/grind_body/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
