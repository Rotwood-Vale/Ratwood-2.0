/datum/sex_action/grind_body
	name = "Grind against them"
	check_same_tile = FALSE

/datum/sex_action/grind_body/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/grind_body/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	if(!target.get_bodypart(check_zone(user.zone_selected)))
		return FALSE
	return TRUE

/datum/sex_action/grind_body/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls themselves onto [target]..."), vision_distance = 1)
	user.sexcon.show_progress = 0

/datum/sex_action/grind_body/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle
	var/zone_text
	if(user.sexcon.force < SEX_FORCE_MID && user.sexcon.speed < SEX_SPEED_MID) // always subtle
		do_subtle = 1
	else if(user.sexcon.force < SEX_FORCE_EXTREME && user.sexcon.speed < SEX_SPEED_EXTREME)
		do_subtle = !prob(user.sexcon.force > SEX_FORCE_MID ? 5 : 2) // roll the dice, diceman
	else
		do_subtle = 0 // we go loud
	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN)
		zone_text = user.dir == target.dir ? "ass" : "crotch"
	else
		zone_text = lowertext(parse_zone(user.zone_selected))
	user.sexcon.show_progress = !do_subtle
	user.visible_message(user.sexcon.spanify_force("[user] [do_subtle ? pick("subtly","sneakily","covertly","stealthily","quietly") : user.sexcon.get_generic_force_adjective()] grinds over [target]'s [zone_text]..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		if(user.sexcon.force > SEX_FORCE_HIGH)
			playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
		else
			user.make_sucking_noise()
		user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(user, 1, 0.5, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.perform_sex_action(target, 1, 0.5, TRUE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/grind_body/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops grinding against [target] ..."), vision_distance = 1)

/datum/sex_action/grind_body/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
