/datum/sex_action/chastityplay/fondle_cage
	name = "抚弄其贞操装置"
	user_sex_part = SEX_PART_NULL
	category = SEX_CATEGORY_HANDS

/datum/sex_action/chastityplay/fondle_cage/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!target_has_cage(target))
		return FALSE
	if(!can_reach_target_groin(user, target))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/fondle_cage/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!target_has_cage(target))
		return FALSE
	if(!can_reach_target_groin(user, target))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/fondle_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		user.visible_message(span_warning("[user]用手指划过[target]的[get_chastity_device_name(target)]内侧尖刺..."))
		return
	user.visible_message(span_warning("[user]用手指环住[target]的[get_chastity_device_name(target)]，感受着它的分量。"))

/datum/sex_action/chastityplay/fondle_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]摩擦并按压[target]带刺的贞操装置，每一次抽动都让尖刺更深地陷进去..."))
		user.sexcon.perform_sex_action(target, 0.2, 3.6, TRUE)
		user.sexcon.try_do_pain_scream(target, 3.6)
		if(target.sexcon.check_active_ejaculation())
			target.sexcon.ejaculate()
		return
	user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]用掌心挤压并揉弄[target]的[get_chastity_device_name(target)]，刻意地摆弄着冰冷金属..."))
	// Chastity device sound is handled internally by perform_sex_action via chastitycourse_noise.
	user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)
	if(target.sexcon.check_active_ejaculation())
		target.sexcon.ejaculate()

/datum/sex_action/chastityplay/fondle_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]松开了[target]的[get_chastity_device_name(target)]，把手抽开。"))

/datum/sex_action/chastityplay/fondle_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
