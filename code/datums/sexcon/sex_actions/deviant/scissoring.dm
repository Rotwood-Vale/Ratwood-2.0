/datum/sex_action/scissoring
	name = "与对方磨阴"
	user_sex_part = SEX_PART_CUNT
	target_sex_part = SEX_PART_CUNT

/datum/sex_action/scissoring/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/scissoring/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/scissoring/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]分开[user.p_their()]双腿，将[user.p_their()]阴部贴上了[target]的阴部！"))

/datum/sex_action/scissoring/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]与[target]的阴部彼此磨蹭。"))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(user, 1, 4, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.perform_sex_action(target, 1, 4, TRUE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/scissoring/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了与[target]磨阴的动作。"))

/datum/sex_action/scissoring/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
