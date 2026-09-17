/datum/sex_action/force_thighjob
	name = "Jerk them off with thighs"
	target_sex_part = SEX_PART_COCK
	target_needs_functional = TRUE

/datum/sex_action/force_thighjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] moves [user.p_their()] thighs between [target]'s cock..."))

/datum/sex_action/force_thighjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] jerks [target]'s cock with [user.p_their()] thighs..."))
	user.sexcon.outercourse_noise(user)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)

	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/force_thighjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops jerking [target] off with [user.p_their()] thighs..."))

/datum/sex_action/force_thighjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
