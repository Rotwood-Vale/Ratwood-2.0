/datum/sex_action/facesitting
	name = "坐到对方脸上"

/datum/sex_action/facesitting/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/facesitting/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
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

/datum/sex_action/facesitting/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]一屁股坐到了[target]脸上！"))

/datum/sex_action/facesitting/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/verbstring = pick(list("摩擦着", "压挤着", "强行按着"))
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()][verbstring][user.p_their()]臀部贴在[target]脸上。"))
	target.sexcon.make_sucking_noise()
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_jaw_crush(target)

	user.sexcon.perform_sex_action(user, 1, 3, TRUE)
	user.sexcon.handle_passive_ejaculation(target)

	user.sexcon.perform_deepthroat_oxyloss(target, 1.3)
	user.sexcon.perform_sex_action(target, 0, 2, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/facesitting/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]从[target]脸上挪开了。"))

/datum/sex_action/facesitting/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
