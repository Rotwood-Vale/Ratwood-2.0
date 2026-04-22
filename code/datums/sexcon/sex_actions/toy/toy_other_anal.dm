/datum/sex_action/toy_other_anal
	name = "Use toy on their butt"
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_ANUS
	var/pegging = FALSE

/datum/sex_action/toy_other_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!pegging && !get_dildo_in_either_hand(user) || pegging && !get_dildo_on_belt(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_other_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!pegging && !get_dildo_in_either_hand(user) || pegging && !get_dildo_on_belt(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_other_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = !pegging ? get_dildo_in_either_hand(user) : get_dildo_on_belt(user)
	user.visible_message(span_warning("[user] shoves \the [dildo] in [target]'s butt..."))

/datum/sex_action/toy_other_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] pleasures [target]'s butt..."))
	user.sexcon.outercourse_noise(target)

	user.sexcon.perform_sex_action(target, 2, 6, TRUE)
	target.sexcon.handle_passive_ejaculation()

	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	if(dildo)
		dildo.do_silver_check(target)

/datum/sex_action/toy_other_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = !pegging ? get_dildo_in_either_hand(user) : get_dildo_on_belt(user)
	user.visible_message(span_warning("[user] pulls \the [dildo] from [target]'s butt."))

/datum/sex_action/toy_other_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/toy_other_anal/pegging
	name = "Peg their butt"
	pegging = TRUE

/datum/sex_action/toy_other_anal/pegging/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] pegs [target]'s ass."))
	user.sexcon.intercourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(target, 2, 6, TRUE)
	target.sexcon.handle_passive_ejaculation()

	var/obj/item/dildo/dildo = get_dildo_on_belt(user)
	if(dildo)
		dildo.do_silver_check(target)
