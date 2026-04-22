/datum/sex_action/kissing
	name = "Make out with them"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/kissing/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/kissing/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/kissing/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	..()
	// Seelie performing: flutter up to kiss
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] flutters up to [target]'s lips and presses [user.p_their()] tiny mouth against them..."))
	// Seelie receiving: someone kisses the tiny fae
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] carefully lifts [target] and presses [user.p_their()] lips against the tiny fae's whole face..."))
	// Both seelie
	else if(isseelie(user) && isseelie(target))
		user.visible_message(span_warning("[user] wraps [user.p_their()] tiny arms around [target] and kisses [target.p_them()] deeply, both fae glowing softly..."))
	else
		user.visible_message(span_warning("[user] starts making out with [target]..."))

/datum/sex_action/kissing/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	// Seelie performing: tiny fae kissing a larger partner
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		var/list/seelie_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] presses [user.p_their()] tiny lips to [target]'s...",
			"[user] [user.sexcon.get_generic_force_adjective()] plants fae kisses across [target]'s lips...",
			"[user] [user.sexcon.get_generic_force_adjective()] flutters against [target]'s mouth, [user.p_their()] whole tiny body warm...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_msgs)))
	// Seelie receiving: someone making out with the tiny fae
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		var/list/seelie_recv_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] presses [user.p_their()] lips over [target]'s tiny face...",
			"[user] [user.sexcon.get_generic_force_adjective()] kisses [target], lips almost engulfing the little fae's head entirely...",
			"[user] [user.sexcon.get_generic_force_adjective()] makes out with [target], tongue dwarfing the tiny fae...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_recv_msgs)))
	// Both seelie
	else if(isseelie(user) && isseelie(target))
		var/list/both_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] kisses [target] passionately, their tiny bodies glowing together...",
			"[user] [user.sexcon.get_generic_force_adjective()] embraces [target] and kisses [target.p_them()] deeply...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(both_msgs)))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] makes out with [target]..."))
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
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] flutters back from [target]'s lips, leaving a faint glittering residue..."))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] gently sets [target] down, the tiny fae's glow slowly fading..."))
	else if(isseelie(user) && isseelie(target))
		user.visible_message(span_warning("[user] breaks the kiss with [target], a soft glow fading between them..."))
	else
		user.visible_message(span_warning("[user] stops making out with [target] ..."))
