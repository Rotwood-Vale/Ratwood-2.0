/datum/sex_action/chastityplay/scissor_cage_other
	name = "Scissor with your locked slit"
	user_sex_part = SEX_PART_CUNT
	user_needs_chastity = TRUE
	target_sex_part = SEX_PART_CUNT
	target_needs_functional = TRUE

/datum/sex_action/chastityplay/scissor_cage_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] shifts forward until [user.p_their()] locked belt slit settles against [target]'s bare cunt."))

/datum/sex_action/chastityplay/scissor_cage_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] grinds the slit of [user.p_their()] belt against [target]'s cunt — metal edge dragging where [target] is most sensitive..."))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(user, 1.6, 0.5, TRUE)
	user.sexcon.perform_sex_action(target, 1.7, 0.5, TRUE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/scissor_cage_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] separates, the belt slit pulling away from [target]'s cunt with a soft drag."))

/datum/sex_action/chastityplay/scissor_cage_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
