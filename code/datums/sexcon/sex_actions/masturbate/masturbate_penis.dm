/datum/sex_action/masturbate_penis
	name = "自慰撸弄"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_COCK
	subtle_supported = TRUE

/datum/sex_action/masturbate_penis/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_penis/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.sexcon.can_use_penis())
		return FALSE
	return TRUE

/datum/sex_action/masturbate_penis/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始自慰撸弄……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_penis/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	var/chosen_verb = pick(list("撸弄着[user.p_their()]的肉棒", "套弄着[user.p_their()]的肉棒", "自慰着", "自我撸弄着"))
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] [chosen_verb]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)

	user.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_penis/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了自慰撸弄的动作。"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate_penis/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
