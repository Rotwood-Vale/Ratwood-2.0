/datum/sex_action/tailjob
	name = "用尾巴撸弄对方"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_COCK

/datum/sex_action/tailjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL) && !islamia(user))
		return FALSE
	return TRUE

/datum/sex_action/tailjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_TAIL) && !islamia(user))
		return FALSE
	return TRUE

/datum/sex_action/tailjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]用[user.p_their()]的尾巴缠上了[target]的肉棒……"))

/datum/sex_action/tailjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用[user.p_their()]的尾巴撸弄着[target]的肉棒。"))
	user.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(target, 2, 0, TRUE)

	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/tailjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了用尾巴撸弄[target]肉棒的动作。"))

/datum/sex_action/tailjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
