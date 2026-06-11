/datum/sex_action/slit_sex
	name = "插入对方裂缝"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_SLIT_SHEATH
	knot_on_finish = TRUE

/datum/sex_action/slit_sex/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	var/obj/item/organ/penis/pp = target.getorganslot(ORGAN_SLOT_PENIS)
	if(!pp || pp.sheath_type != SHEATH_TYPE_SLIT)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/slit_sex/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	var/obj/item/organ/penis/pp = target.getorganslot(ORGAN_SLOT_PENIS)
	if(!pp || pp.sheath_type != SHEATH_TYPE_SLIT)
		return FALSE
	if(!user.sexcon.can_use_penis())
		return FALSE
	return TRUE

/datum/sex_action/slit_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]的肉棒滑入了[target]的裂缝中！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/slit_sex/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.do_knot_action)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]抽插着[target]的裂缝。"))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用结顶弄着[target]的裂缝。"))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user]射进了[target]的裂缝里！"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(splashed_user = target, orifice = SEX_PART_SLIT_SHEATH, consume_charge = i == 1 ? TRUE : FALSE)
			if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
			sleep(10)
		user.virginity = FALSE

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 1.2, 3, FALSE)
	else
		user.sexcon.perform_sex_action(target, 2.4, !user.sexcon.do_knot_action ? 7 : 11, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/slit_sex/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的肉棒从[target]的裂缝中抽了出来。"))

/datum/sex_action/slit_sex/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/slit_sex/double
	name = "用双根肉棒插入对方裂缝"

/datum/sex_action/slit_sex/double/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.double_penis_type())
		return FALSE
	return ..()

/datum/sex_action/slit_sex/double/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.double_penis_type())
		return FALSE
	return ..()

/datum/sex_action/slit_sex/double/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]的双根肉棒滑入了[target]的裂缝中！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/slit_sex/double/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.do_knot_action)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用双根肉棒抽插着[target]的裂缝。"))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用双结顶弄着[target]的裂缝。"))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user]射进了[target]的裂缝里！"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(splashed_user = target, orifice = SEX_PART_SLIT_SHEATH, consume_charge = i == 1 ? TRUE : FALSE)
			if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
			sleep(10)
		user.virginity = FALSE

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 1.2, 3, FALSE)
	else
		user.sexcon.perform_sex_action(target, 2.4, 11, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/slit_sex/double/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的双根肉棒从[target]的裂缝中抽了出来。"))
