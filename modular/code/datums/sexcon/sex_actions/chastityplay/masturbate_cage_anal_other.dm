/datum/sex_action/chastityplay/masturbate_cage_anal_other
	name = "Tease their anal shield"
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_ANUS
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] slides [user.p_their()] hand behind [target] to find the edge of [target.p_their()] belt's rear shield."))

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [user.p_their()] fingers along the seam of [target]'s rear shield, pressing inward where the plate meets skin..."))
	user.sexcon.perform_sex_action(target, 1.5, 1, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] draws [user.p_their()] hand back from [target]'s rear shield."))

/datum/sex_action/chastityplay/masturbate_cage_anal_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
