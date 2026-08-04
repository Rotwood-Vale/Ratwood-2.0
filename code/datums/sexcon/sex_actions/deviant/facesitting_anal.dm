/datum/sex_action/facesitting_anal
	name = "Sit on their face with ass"

/datum/sex_action/facesitting_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/facesitting_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	// Need to stand up
	if(user.resting)
		return FALSE
	// Target can't stand up
	if(!target.resting)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/facesitting_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] lowers [user.p_their()] ass onto [target]'s face!"))

/datum/sex_action/facesitting_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/verbstring = pick(list("smushes", "forces", "presses", "grinds", "rams", "jams"))
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [verbstring] [user.p_their()] asshole against [target] face."))
	
	target.sexcon.make_sucking_noise()
	user.sexcon.do_thrust_animate(target)

	// Fat ass smash
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_jaw_crush(target)

	// User pleasure
	user.sexcon.perform_sex_action(user, 1, 1, TRUE)
	user.sexcon.handle_passive_ejaculation(target)

	// Target pleasure and oxyloss from strong intent and up
	user.sexcon.perform_deepthroat_oxyloss(target, 1)
	user.sexcon.perform_sex_action(target, 1, 3, FALSE)
	target.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/facesitting_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] gets off [target]'s face."))

/datum/sex_action/facesitting_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE

