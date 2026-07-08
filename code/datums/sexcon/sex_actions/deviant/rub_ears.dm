/datum/sex_action/rub_ears
	name = "Rub their ears"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	subtle_supported = TRUE

/datum/sex_action/rub_ears/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/rub_ears/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_EARS, TRUE))
		return FALSE
	return TRUE

/datum/sex_action/rub_ears/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] places [user.p_their()] hands against [target] ears..."))

/datum/sex_action/rub_ears/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)

	if(HAS_TRAIT(target, TRAIT_KEENEARS) || iself(target) || ishalfelf(target) || isdarkelf(target) || iswoodelf(target) || isgoblinp(target) || isgnoll(target)) || istabaxi(target) || iskobold(target) || isvulp(target) || islupian(target)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rubs [target]'s ears... [target.p_their()] weakness..."))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rubs [target]'s ears..."))

/datum/sex_action/rub_ears/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	target.sexcon.make_sucking_noise()

	if(HAS_TRAIT(target, TRAIT_KEENEARS) || iself(target) || ishalfelf(target) || isdarkelf(target) || iswoodelf(target) || isgoblinp(target) || isgnoll(target)) || istabaxi(target) || iskobold(target) || isvulp(target) || islupian(target)
		user.sexcon.perform_sex_action(target, 5, 0, TRUE)
	else
		user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)

	user.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/rub_ears/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops rubbing [target]'s ears ..."))

/datum/sex_action/rub_ears/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
