/datum/sex_action/frotting
	name = "与对方相互磨蹭"
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_COCK

/datum/sex_action/frotting/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/frotting/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/frotting/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]肉棒狠狠干到了[target]的肉棒上！"))

/datum/sex_action/frotting/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]与[target]相互磨蹭着肉棒。"))
	user.sexcon.outercourse_noise(target, TRUE)

	user.sexcon.perform_sex_action(user, 1, 4, TRUE)
	user.sexcon.handle_passive_ejaculation(target)

	user.sexcon.perform_sex_action(target, 1, 4, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/frotting/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]松开了彼此纠缠在一起的肉棒。"))
