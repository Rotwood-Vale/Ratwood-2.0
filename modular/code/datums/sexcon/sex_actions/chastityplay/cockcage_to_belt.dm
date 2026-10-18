/datum/sex_action/chastityplay/cockcage_to_belt
	name = "Press cage to belt"
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT
	target_needs_chastity = TRUE
	user_sex_part = SEX_PART_COCK
	user_needs_chastity = TRUE

/datum/sex_action/chastityplay/cockcage_to_belt/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] closes in on [target] until [user.p_their()] cage knocks flush against [target.p_their()] locked belt."))

/datum/sex_action/chastityplay/cockcage_to_belt/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] grinds [user.p_their()] cage against [target]'s belt, the slow steel-on-steel drag loud enough to make nearby people wince..."))
	// Chastity device sound is handled internally by perform_sex_action via chastitycourse_noise — no outercourse noise here, it's purely metal-on-metal.

	user.sexcon.perform_sex_action(user, 1.1, 1, TRUE)
	user.sexcon.perform_sex_action(target, 1.1, 1, TRUE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cockcage_to_belt/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] steps back and the two devices separate with a last rasp of metal."))

/datum/sex_action/chastityplay/cockcage_to_belt/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
