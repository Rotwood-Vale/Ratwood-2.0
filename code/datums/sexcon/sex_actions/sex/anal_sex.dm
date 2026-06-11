/datum/sex_action/anal_sex
	name = "肛交对方"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_ANUS
	knot_on_finish = TRUE

/datum/sex_action/anal_sex/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/anal_sex/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.sexcon.can_use_penis())
		return FALSE
	return TRUE

/datum/sex_action/anal_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的肉棒插进了[target]的屁股里！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/anal_sex/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.do_knot_action)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]狠狠干着[target]的屁股。"))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用肉棒结狠狠干着[target]的屁股。"))
	user.sexcon.intercourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user]射进了[target]的屁股里！"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(splashed_user = target, orifice = SEX_PART_ANUS, consume_charge = i == 1 ? TRUE : FALSE)
			if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
			sleep(10)
		user.virginity = FALSE

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 1.2, 4, FALSE)
	else
		user.sexcon.perform_sex_action(target, 2.4, !user.sexcon.do_knot_action ? 9 : 14, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/anal_sex/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的肉棒从[target]的屁股里抽了出来。"))

/datum/sex_action/anal_sex/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/anal_sex/double
	name = "用双茎肛交对方"

/datum/sex_action/anal_sex/double/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.double_penis_type())
		return FALSE
	return ..()

/datum/sex_action/anal_sex/double/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.double_penis_type())
		return FALSE
	return ..()

/datum/sex_action/anal_sex/double/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的双茎插进了[target]的屁股里！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/anal_sex/double/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.do_knot_action)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用双茎狠狠干着[target]的屁股。"))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用双重肉棒结狠狠干着[target]的屁股。"))
	user.sexcon.intercourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user]射进了[target]的屁股里！"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(splashed_user = target, orifice = SEX_PART_ANUS, consume_charge = i == 1 ? TRUE : FALSE)
			if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
			sleep(10)
		user.virginity = FALSE

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 1.2, 4, FALSE)
	else
		user.sexcon.perform_sex_action(target, 2.4, 14, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/anal_sex/double/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的双茎从[target]的屁股里抽了出来。"))
