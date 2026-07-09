/datum/sex_action/footsmother//Blame Pots for this existing.
	name = "Smother them with feet"
	check_same_tile = FALSE

/datum/sex_action/footsmother/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(user.resting)
		return FALSE
	return TRUE

/datum/sex_action/footsmother/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE

	// Need bare feet ofc
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_L_FOOT || BODY_ZONE_PRECISE_R_FOOT))
		return FALSE

	// Need to stand up
	if(user.resting)
		return FALSE

	// Target can't stand up
	if(!target.resting)
		return FALSE
	return TRUE

/datum/sex_action/footsmother/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_messsage(span_warning("[user] puts [user.p_their()] feet on [target]'s face..."))
	user.sexcon.show_progress = 0

/datum/sex_action/footsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)



 	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] smothers [target]'s face with [user.p_their()] feet..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = FALSE

datum/sex_action/footsmother/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] feet off [target]'s face..."))

/datum/sex_action/footsmother/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
