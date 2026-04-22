/datum/sex_action/rub_body
	name = "Rub their body"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS

/datum/sex_action/rub_body/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/rub_body/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/rub_body/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] lands on [target] and begins running [user.p_their()] tiny hands across their skin..."))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] cups [target]'s tiny body in [user.p_their()] palms and begins stroking the little fae..."))
	else
		user.visible_message(span_warning("[user] places [user.p_their()] hands onto [target]..."))

/datum/sex_action/rub_body/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		var/list/seelie_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] walks [user.p_their()] tiny hands across [target]'s skin, each touch leaving a faint tingle of fae warmth...",
			"[user] [user.sexcon.get_generic_force_adjective()] presses [user.p_their()] little palms against [target], kneading with [user.p_their()] whole body weight...",
			"[user] [user.sexcon.get_generic_force_adjective()] scurries across [target]'s body, rubbing with tiny hands...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_msgs)))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		var/list/seelie_recv_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] strokes [target]'s entire tiny body between [user.p_their()] fingers, the fae glowing warmly at the touch...",
			"[user] [user.sexcon.get_generic_force_adjective()] pets [target] with a single finger, the little fae shivering with delight...",
			"[user] [user.sexcon.get_generic_force_adjective()] traces a thumb along [target]'s minuscule frame...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_recv_msgs)))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rubs [target]'s body..."))
	user.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/rub_body/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] flutters off [target]'s body..."))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] stops petting [target]'s tiny body..."))
	else
		user.visible_message(span_warning("[user] stops rubbing [target]'s body ..."))

/datum/sex_action/rub_body/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
