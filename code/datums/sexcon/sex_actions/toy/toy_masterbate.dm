/datum/sex_action/toy_masturbate
	name = "撸弄玩具"
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
		user.visible_message(span_warning("[user]开始撸弄[dildo]了……"))
	else
		user.visible_message(span_warning("[user]开始撸弄那件玩具了……"))

/datum/sex_action/toy_masturbate/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/chosen_verb = pick(list("撸弄着[user.p_their()]的玩具", "抚弄着[user.p_their()]的玩具", "摩擦着[user.p_their()]的玩具", "套弄着[user.p_their()]的玩具", "把玩着[user.p_their()]的玩具"))
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [chosen_verb]..."))
	user.sexcon.generic_sex_noise()

	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user) || get_dildo_on_belt(user)
	if(dildo)
		dildo.do_silver_check(target)

/datum/sex_action/toy_masturbate/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user) || get_dildo_on_belt(user)
	if(dildo)
		user.visible_message(span_warning("[user]停下了撸弄[dildo]的动作。"))
	else
		user.visible_message(span_warning("[user]停下了撸弄那件玩具的动作。"))

/datum/sex_action/toy_masturbate/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
