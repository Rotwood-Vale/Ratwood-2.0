/datum/sex_action/cunnilingus
	name = "为对方舔阴"
	user_sex_part = SEX_PART_JAWS
	target_sex_part = SEX_PART_CUNT
	subtle_supported = TRUE

/datum/sex_action/cunnilingus/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/cunnilingus/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/datum/sex_action/cunnilingus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始舔弄[target]的阴蒂……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = FALSE

/datum/sex_action/cunnilingus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]舔弄着[target]的阴蒂……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.oralcourse_noise(target)
		user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(target, 2, 3, TRUE)
	user.sexcon.consume_oral_drips(target)
	if(target.sexcon.check_active_ejaculation())
		target.visible_message(span_love("[target]在[user]口中达到了高潮！"))
		target.sexcon.cum_into(oral = TRUE, splashed_user = user)

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/cunnilingus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了对[target]阴蒂的舔弄……"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/cunnilingus/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
