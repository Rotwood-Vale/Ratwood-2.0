/datum/sex_action/thighjob
	name = "用对方大腿磨弄自己"
	user_sex_part = SEX_PART_COCK

/datum/sex_action/thighjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/thighjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/thighjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]抓住了[target]的大腿，把[user.p_their()]的肉棒挤了进去！"))

/datum/sex_action/thighjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]抽弄着[target]的双腿。"))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)

	user.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/thighjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的肉棒从[target]的大腿间抽了出来。"))

/datum/sex_action/thighjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
