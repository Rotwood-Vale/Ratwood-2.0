/datum/sex_action/footsmother
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
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_L_FOOT))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_R_FOOT))
		return FALSE

	// Need to stand up
	if(user.resting)
		return FALSE

	// Target can't stand up
	if(!target.resting)
		return FALSE
	return TRUE

/datum/sex_action/footsmother/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] puts [user.p_their()] feet on [target]'s face..."))

/datum/sex_action/footsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/verbstring = pick(list("smushes", "forces", "presses", "grinds", "rams", "jams"))

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [verbstring] [target]'s face with [user.p_their()] feet..."))
	user.sexcon.outercourse_noise()
	
	// Target pleasure and oxyloss from strong intent and up
	user.sexcon.perform_deepthroat_oxyloss(target, 0.5)
	user.sexcon.perform_sex_action(target, 1, 0, TRUE)
	user.sexcon.handle_passive_ejaculation(target)


/datum/sex_action/footsmother/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] feet off [target]'s face..."))

/datum/sex_action/footsmother/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
