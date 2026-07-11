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

/datum/sex_action/crotch_nuzzle/on_failed_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return
	if(check_same_tile)
		var/same_tile = (get_turf(user) == get_turf(target))
		var/grab_bypass = (aggro_grab_instead_same_tile && user.get_highest_grab_state_on(target) == GRAB_AGGRESSIVE)
		if(!same_tile && !grab_bypass)
			to_chat(user, span_notice("I need to be on the same tile as them, or hold them aggressively."))
			return
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		to_chat(user, span_notice("Their groin needs to be accessible."))
		return
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		to_chat(user, span_notice("My mouth needs to be accessible."))

/datum/sex_action/crotch_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] moves [user.p_their()] head against [target]'s crotch..."))

/datum/sex_action/crotch_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] nuzzles [target]'s crotch..."))

	user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/crotch_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops nuzzling [target]'s crotch..."))

/datum/sex_action/crotch_nuzzle/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
