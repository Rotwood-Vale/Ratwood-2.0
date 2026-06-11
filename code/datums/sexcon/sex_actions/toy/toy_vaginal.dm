/datum/sex_action/toy_vagina
	name = "用玩具取悦阴部"
	user_sex_part = SEX_PART_CUNT
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_CUNT

/datum/sex_action/toy_vagina/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!get_dildo_in_either_hand(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_vagina/can_perform(mob/living/user, mob/living/target)
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!get_dildo_in_either_hand(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_vagina/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	user.visible_message(span_warning("[user]把[dildo]塞进了[user.p_their()]的阴部里……"))

/datum/sex_action/toy_vagina/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用[dildo]玩弄着[user.p_their()]的阴部。"))
	user.sexcon.outercourse_noise(user, TRUE)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)

	user.sexcon.handle_passive_ejaculation()

	if(dildo)
		dildo.do_silver_check(user)

/datum/sex_action/toy_vagina/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	user.visible_message(span_warning("[user]把[dildo]从[user.p_their()]的阴部里抽了出来。"))

/datum/sex_action/toy_vagina/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
