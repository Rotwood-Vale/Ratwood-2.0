/datum/sex_action/buttjob
	name = "Give them a butt job"
	user_sex_part = SEX_PART_ANUS
	target_sex_part = SEX_PART_COCK

/datum/sex_action/buttjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/buttjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/buttjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] shoves [target]'s cock between [user.p_their()] asscheeks!"))

/datum/sex_action/buttjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/verbstring = pick(list("rubs", "caresses", "squeezes", "grinds", "massages"))
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [verbstring] [target]'s cock with [user.p_their()] ass..."))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

	user.sexcon.perform_sex_action(user, 0.5, 2, TRUE)
	user.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/buttjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [target]'s cock out from inbetween [user.p_their()] asscheeks."))

/datum/sex_action/buttjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
