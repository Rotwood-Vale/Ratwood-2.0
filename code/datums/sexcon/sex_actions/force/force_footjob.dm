/datum/sex_action/force_footjob
	name = "Use their feet to get off"
	check_same_tile = FALSE
	require_grab = TRUE
	stamina_cost = 1.0
	target_sex_part = SEX_PART_FEET
	user_sex_part = SEX_PART_COCK
	user_needs_functional = TRUE

/datum/sex_action/force_footjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] grabs [target]'s feet and clamps them around [user.p_their()] cock!"))

/datum/sex_action/force_footjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] uses [target]'s feet to jerk off."))
	user.sexcon.outercourse_noise(target)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)
	user.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/force_footjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] cock out from inbetween [target]'s feet."))
