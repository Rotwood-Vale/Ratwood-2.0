/datum/sex_action/toy_other_oral
	name = "用玩具玩弄对方嘴巴"
	category = SEX_CATEGORY_PENETRATE
	target_sex_part = SEX_PART_JAWS
	var/pegging = FALSE
	var/oxy_damage = FALSE

/datum/sex_action/toy_other_oral/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!pegging && !get_dildo_in_either_hand(user) || pegging && !get_dildo_on_belt(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_other_oral/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!pegging && !get_dildo_in_either_hand(user) || pegging && !get_dildo_on_belt(user))
		return FALSE
	return TRUE

/datum/sex_action/toy_other_oral/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = !pegging ? get_dildo_in_either_hand(user) : get_dildo_on_belt(user)
	user.visible_message(span_warning("[user]强迫[target]把[dildo]含进了嘴里……"))

/datum/sex_action/toy_other_oral/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]强迫[target]含弄着那根假阳具……"))
	user.sexcon.oralcourse_noise(target)

	var/obj/item/dildo/dildo = get_dildo_in_either_hand(user)
	if(dildo)
		dildo.do_silver_check(target)

/datum/sex_action/toy_other_oral/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/dildo/dildo = pegging ? get_dildo_in_either_hand(user) : get_dildo_on_belt(user)
	user.visible_message(span_warning("[user]把[dildo]从[target]的嘴里抽了出来。"))

/datum/sex_action/toy_other_oral/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/toy_other_oral/pegging
	name = "用玩具抽插对方嘴巴"
	pegging = TRUE

/datum/sex_action/toy_other_oral/pegging/throat
	name = "用玩具抽插对方喉咙"
	oxy_damage = TRUE

/datum/sex_action/toy_other_oral/pegging/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!oxy_damage)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用玩具抽插着[target]的嘴巴。"))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用玩具抽插着[target]的喉咙。"))
		user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.oralcourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(target, 0, 7, FALSE)
	if(oxy_damage)
		user.sexcon.perform_deepthroat_oxyloss(target, 2.6)
	target.sexcon.handle_passive_ejaculation()

	var/obj/item/dildo/dildo = get_dildo_on_belt(user)
	if(dildo)
		dildo.do_silver_check(target)
