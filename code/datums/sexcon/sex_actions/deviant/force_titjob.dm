/datum/sex_action/force_titjob
	name = "用胸部替对方撸弄"
	target_sex_part = SEX_PART_COCK

/datum/sex_action/force_titjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/force_titjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/force_titjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]抓住[target]的肉棒，狠狠干进了[user.p_their()]双乳之间！"))

/datum/sex_action/force_titjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]把[target]的肉棒夹在[user.p_their()]双乳之间套弄。"))
	user.sexcon.outercourse_noise(user)

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)

	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/force_titjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[target.p_their()]肉棒从[user.p_their()]双乳间抽了出来。"))

/datum/sex_action/force_titjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
