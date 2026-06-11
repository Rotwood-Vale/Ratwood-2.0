/datum/sex_action/footjob
	name = "用脚替对方撸弄"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_COCK

/datum/sex_action/footjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/footjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_L_FOOT))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_R_FOOT))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/footjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]双脚搭上了[target]的肉棒……"))

/datum/sex_action/footjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用[user.p_their()]双脚套弄着[target]的肉棒……"))
	user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)

	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/footjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]双脚从[target]的肉棒上挪开了……"))

/datum/sex_action/footjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
