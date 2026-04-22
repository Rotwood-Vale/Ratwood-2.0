/datum/sex_action/armpit_nuzzle
	name = "Nuzzle their armpit"
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/armpit_nuzzle/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/armpit_nuzzle/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/armpit_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] flutters up and nestles [user.p_their()] tiny body into [target]'s armpit..."))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] tucks [target]'s tiny body against [user.p_their()] armpit, the fae almost disappearing inside..."))
	else
		user.visible_message(span_warning("[user] moves [user.p_their()] head against [target]'s armpit..."))

/datum/sex_action/armpit_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		var/list/seelie_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] curls up in [target]'s armpit...",
			"[user] [user.sexcon.get_generic_force_adjective()] wiggles [user.p_their()] tiny body deeper into [target]'s armpit...",
			"[user] [user.sexcon.get_generic_force_adjective()] nuzzles into [target]'s armpit with [user.p_their()] entire body...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_msgs)))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		var/list/seelie_recv_msgs = list(
			"[user] [user.sexcon.get_generic_force_adjective()] nuzzles [target]'s armpit, practically pressing the tiny fae against [user.p_their()] nose...",
			"[user] [user.sexcon.get_generic_force_adjective()] presses [user.p_their()] nose into [target]'s tiny armpit...",
		)
		user.visible_message(user.sexcon.spanify_force(pick(seelie_recv_msgs)))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] nuzzles [target]'s armpit..."))

/datum/sex_action/armpit_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(isseelie(user) && !HAS_TRAIT(target, TRAIT_TINY))
		user.visible_message(span_warning("[user] flutters out of [target]'s armpit, wings shaking off warmth..."))
	else if(isseelie(target) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] pulls away, letting [target] tumble free..."))
	else
		user.visible_message(span_warning("[user] stops nuzzling [target]'s armpit..."))
