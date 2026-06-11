/datum/sex_action/suck_balls
	name = "含弄对方睾丸"
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/suck_balls/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_TESTICLES))
		return FALSE
	return TRUE

/datum/sex_action/suck_balls/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_TESTICLES))
		return FALSE
	return TRUE

/datum/sex_action/suck_balls/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始含弄[target]的睾丸了……"))

/datum/sex_action/suck_balls/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]含弄着[target]的睾丸……"))
	user.sexcon.oralcourse_noise(user)

	user.sexcon.perform_sex_action(target, 1, 3, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/suck_balls/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了含弄[target]睾丸的动作……"))

/datum/sex_action/suck_balls/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
