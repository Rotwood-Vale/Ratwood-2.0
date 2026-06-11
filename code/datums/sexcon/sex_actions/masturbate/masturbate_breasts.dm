/datum/sex_action/masturbate_breasts
	name = "揉弄胸部"
	category = SEX_CATEGORY_HANDS
	subtle_supported = TRUE

/datum/sex_action/masturbate_breasts/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_breasts/can_perform(mob/living/user, mob/living/target)
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_CHEST, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_breasts/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始揉弄[user.p_their()]自己的胸部……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_breasts/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]揉捏着[user.p_their()]自己的胸部……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

	user.sexcon.perform_sex_action(user, 1, 4, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_breasts/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了揉弄[user.p_their()]自己胸部的动作。"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate_breasts/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
