/datum/sex_action/chastityplay/masturbate_cage_vagina
	name = "Rub your locked slit"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_CUNT
	user_needs_chastity = TRUE

/datum/sex_action/chastityplay/masturbate_cage_vagina/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] presses [user.p_their()] fingers flat against [user.p_their()] chastity belt, searching for the gap in the front plate."))

/datum/sex_action/chastityplay/masturbate_cage_vagina/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rubs circles over the front of [user.p_their()] belt, fingers slipping through the slits to press where it matters — barely..."))
	user.sexcon.perform_sex_action(user, 1.6, 0.5, TRUE)
	user.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/masturbate_cage_vagina/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] hand away from [user.p_their()] belt, frustrated and no closer to relief."))

/datum/sex_action/chastityplay/masturbate_cage_vagina/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
