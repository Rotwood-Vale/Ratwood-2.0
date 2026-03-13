/datum/sex_action/toy_anal
	name = "Pleasure butt with toy"
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_ANUS
	target_sex_part = SEX_PART_ANUS

/datum/sex_action/toy_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!get_dildo_in_either_hand(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!get_dildo_in_either_hand(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	user.visible_message(span_warning("[user] starts shoves [dildo] in [user.p_their()] butt..."))

/datum/sex_action/toy_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] pleasures [user.p_their()] butt with \the [dildo]."))
	user.sexcon.outercourse_noise(user)

	user.sexcon.perform_sex_action(user, 2, 6, TRUE)
	user.sexcon.handle_passive_ejaculation()

	if(dildo)
		dildo.do_silver_check(user)

/datum/sex_action/toy_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	user.visible_message(span_warning("[user] pulls \the [dildo] from [user.p_their()] butt."))

/datum/sex_action/toy_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
