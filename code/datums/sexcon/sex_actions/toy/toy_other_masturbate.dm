/datum/sex_action/toy_other_masturbate
	name = "Jerk their toy off"
	// Allow through all clothes, so no body zone accessibility check for clothing
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS

/datum/sex_action/toy_other_masturbate/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!get_dildo_on_belt(target))
		return FALSE
	return TRUE

/datum/sex_action/toy_other_masturbate/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!get_dildo_on_belt(target))
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	// No clothing or body zone checks, can always jerk
	return TRUE

/datum/sex_action/toy_other_masturbate/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] starts jerking [target]'s toy..."))

/datum/sex_action/toy_other_masturbate/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/chosen_verb = pick(list("jerks [target]'s toy", "strokes [target]'s toy", "masturbates [target]'s toy", "jerks off [target]'s toy", "polishes [target]'s toy"))
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [chosen_verb]..."))
	user.sexcon.generic_sex_noise()

	var/obj/item/dildo/dildo = get_dildo_on_belt(target)
	if(dildo)
		dildo.do_silver_check(user)

/datum/sex_action/toy_other_masturbate/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_on_belt(target)
	if(dildo)
		user.visible_message(span_warning("[user] stops jerking \the [dildo]."))
	else
		user.visible_message(span_warning("[user] stops jerking the toy."))

/datum/sex_action/toy_other_masturbate/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
