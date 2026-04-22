/datum/sex_action/crotch_nuzzle
	name = "Nuzzle their crotch"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_COCK|SEX_PART_CUNT

/datum/sex_action/crotch_nuzzle/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/crotch_nuzzle/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/crotch_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] flutters between [target]'s legs and presses [user.p_their()] tiny body against their crotch..."))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] brings [user.p_their()] face down to [target]'s tiny crotch..."))
	else
		user.visible_message(span_warning("[user] moves [user.p_their()] head against [target]'s crotch..."))

/datum/sex_action/crotch_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		var/list/seelie_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] nuzzles [user.p_their()] tiny face into [target]'s crotch...",
			"[user] [user.sexcon.get_generic_force_adjective()] rubs [user.p_their()] whole body against [target]'s crotch...",
			"[user] [user.sexcon.get_generic_force_adjective()] buries [user.p_their()] tiny form into [target]'s crotch...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_msgs)))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		var/list/seelie_recv_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] nuzzles [target]'s tiny crotch, [user.p_their()] breath hot against the little fae's body...",
			"[user] [user.sexcon.get_generic_force_adjective()] presses [user.p_their()] lips against [target]'s minuscule groin, practically engulfing the fae...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_recv_msgs)))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] nuzzles [target]'s crotch..."))

	user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/crotch_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] flutters away from [target]'s crotch, fae dust drifting in [user.p_their()] wake..."))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] pulls [user.p_their()] face away from [target]'s tiny crotch..."))
	else
		user.visible_message(span_warning("[user] stops nuzzling [target]'s crotch..."))

/datum/sex_action/crotch_nuzzle/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
