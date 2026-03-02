/datum/sex_action/toy_masturbate
	name = "Jerk toy off"
	category = SEX_CATEGORY_HANDS

/datum/sex_action/toy_masturbate/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!get_dildo_in_either_hand(user) && !get_dildo_on_belt(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_masturbate/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!get_dildo_in_either_hand(user) && !get_dildo_on_belt(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_masturbate/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user) || get_dildo_on_belt(user)
	if(dildo)
		user.visible_message(span_warning("[user] starts jerking off \the [dildo]..."))
	else
		user.visible_message(span_warning("[user] starts jerking off the toy..."))

/datum/sex_action/toy_masturbate/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/chosen_verb = pick(list("jerks [user.p_their()] toy", "strokes [user.p_their()] toy", "masturbates [user.p_their()] toy", "jerks off [user.p_their()] toy", "polishes [user.p_their()] toy"))
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [chosen_verb]..."))
	user.sexcon.generic_sex_noise()

	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user) || get_dildo_on_belt(user)
	if(dildo)
		dildo.do_silver_check(target)

/datum/sex_action/toy_masturbate/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user) || get_dildo_on_belt(user)
	if(dildo)
		user.visible_message(span_warning("[user] stops jerking off \the [dildo]."))
	else
		user.visible_message(span_warning("[user] stops jerking off the toy."))

/datum/sex_action/toy_masturbate/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
