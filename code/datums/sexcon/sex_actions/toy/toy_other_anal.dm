/datum/sex_action/toy_other_anal
	name = "用玩具玩弄对方后穴"
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
	user.visible_message(span_warning("[user]把[dildo]塞进了[target]的后穴里……"))

/datum/sex_action/toy_other_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]玩弄着[target]的后穴……"))
	user.sexcon.outercourse_noise(target)

	user.sexcon.perform_sex_action(target, 2, 6, TRUE)
	target.sexcon.handle_passive_ejaculation()

	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	if(dildo)
		dildo.do_silver_check(target)

/datum/sex_action/toy_other_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = !pegging ? get_dildo_in_either_hand(user) : get_dildo_on_belt(user)
	user.visible_message(span_warning("[user]把[dildo]从[target]的后穴里抽了出来。"))

/datum/sex_action/toy_other_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/toy_other_anal/pegging
	name = "用玩具抽插对方后穴"
	pegging = TRUE

/datum/sex_action/toy_other_anal/pegging/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用玩具抽插着[target]的后穴。"))
	user.sexcon.intercourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(target, 2, 6, TRUE)
	target.sexcon.handle_passive_ejaculation()

	var/obj/item/dildo/dildo = get_dildo_on_belt(user)
	if(dildo)
		dildo.do_silver_check(target)
