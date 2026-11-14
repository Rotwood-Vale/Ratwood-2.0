/datum/sex_action/titjob
	name = "Use their tits to get off"
	target_sex_part = SEX_PART_BREASTS
	user_sex_part = SEX_PART_COCK

/datum/sex_action/titjob/get_display_name(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return "Use their [target.get_chest_word()] to get off"

/datum/sex_action/titjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] grabs [target] and starts rubbing their body against their cock!"))
	else
		user.visible_message(span_warning("[user] grabs [target]'s [target.get_chest_word()] and shoves [user.p_their()] cock inbetween!"))

/datum/sex_action/titjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rubs their cock against [target]'s body."))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] fucks [target]'s [target.get_chest_word()]."))
	user.sexcon.outercourse_noise(user)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)

	user.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/titjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] pulls their cock away from [target]'s body."))
	else
		user.visible_message(span_warning("[user] pulls [user.p_their()] cock out from inbetween [target]'s [target.get_chest_word()]."))

/datum/sex_action/titjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
