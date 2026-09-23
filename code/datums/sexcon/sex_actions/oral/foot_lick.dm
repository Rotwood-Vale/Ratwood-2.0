/datum/sex_action/foot_lick
	name = "Lick their feet"
	check_same_tile = FALSE
	target_sex_part = SEX_PART_FEET
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/foot_lick/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] starts licking [target]'s feet..."))

/datum/sex_action/foot_lick/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] licks [target]'s feet..."))
	user.sexcon.make_sucking_noise()

/datum/sex_action/foot_lick/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops licking [target]'s feet ..."))
