/datum/sex_action/masturbate_vagina_finger
	name = "指弄小穴"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_CUNT
	target_sex_part = SEX_PART_CUNT
	subtle_supported = TRUE

/datum/sex_action/masturbate_vagina_finger/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_vagina_finger/can_perform(mob/living/user, mob/living/target)
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_vagina_finger/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始指弄[user.p_their()]自己的[pick("裂缝","小穴","嫩穴","蜜处")]……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_vagina_finger/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]指弄着[user.p_their()]自己的[pick("裂缝","小穴","嫩穴","蜜处")]……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)

	user.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_vagina_finger/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了指弄小穴的动作。"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate_vagina_finger/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
