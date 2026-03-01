/datum/sex_action/masturbate_penis_other
	name = "Jerk them off"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_COCK

/datum/sex_action/masturbate_penis_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_penis_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_penis_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] starts jerking [target]'s cock..."), vision_distance = 1)
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_penis_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle
	if(user.sexcon.force < SEX_FORCE_MID && user.sexcon.speed < SEX_SPEED_MID)
		do_subtle = 1
	else if(user.sexcon.force < SEX_FORCE_EXTREME && user.sexcon.speed < SEX_SPEED_EXTREME)
		do_subtle = !prob(user.sexcon.force > SEX_FORCE_MID ? 5 : 2)
	else
		do_subtle = 0
	user.sexcon.show_progress = !do_subtle
	user.visible_message(user.sexcon.spanify_force("[user] [do_subtle ? pick("subtly","sneakily","covertly","stealthily","quietly") : user.sexcon.get_generic_force_adjective()] jerks [target]'s cock off..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	target.sexcon.suppress_moan = do_subtle
	user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	target.sexcon.handle_passive_ejaculation(user)
	target.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_penis_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops jerking [target]'s cock."), vision_distance = 1)

/datum/sex_action/masturbate_penis_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
