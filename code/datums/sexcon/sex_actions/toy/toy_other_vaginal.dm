/datum/sex_action/toy_other_vagina
	name = "Use toy on their cunt"
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT
	var/pegging = FALSE

/datum/sex_action/toy_other_vagina/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!pegging && !get_dildo_in_either_hand(user) || pegging && !get_dildo_on_belt(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_other_vagina/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!pegging && !get_dildo_in_either_hand(user) || pegging && !get_dildo_on_belt(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_other_vagina/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = !pegging ? get_dildo_in_either_hand(user) : get_dildo_on_belt(user)
	user.visible_message(span_warning("[user] shoves \the [dildo] in [target]'s cunt..."))

/datum/sex_action/toy_other_vagina/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] pleasures [target]'s cunt..."))
	user.sexcon.outercourse_noise(target, TRUE)

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)
	target.sexcon.handle_passive_ejaculation()

	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	if(dildo)
		dildo.do_silver_check(target)

/datum/sex_action/toy_other_vagina/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = !pegging ? get_dildo_in_either_hand(user) : get_dildo_on_belt(user)
	user.visible_message(span_warning("[user] pulls out \the [dildo] from [target]'s cunt."))

/datum/sex_action/toy_other_vagina/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/toy_other_vagina/pegging
	name = "Peg their cunt"
	pegging = TRUE

/datum/sex_action/toy_other_vagina/pegging/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] pegs [target]'s cunt."))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(target, 2.4, 7, FALSE)
	target.sexcon.handle_passive_ejaculation()

	var/obj/item/dildo/dildo = get_dildo_on_belt(user)
	if(dildo)
		dildo.do_silver_check(target)
