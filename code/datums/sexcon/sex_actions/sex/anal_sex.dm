/datum/sex_action/anal_sex
	handles_user_climax = TRUE
	name = "Sodomize them"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_COCK
	user_needs_functional = TRUE
	target_sex_part = SEX_PART_ANUS
	knot_on_finish = TRUE

/datum/sex_action/anal_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] forces [user.p_their()] cock into [target]'s tiny butt!"))
		var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
		var/obj/item/bodypart/groin = target.get_bodypart(BODY_ZONE_PRECISE_GROIN)
		if(chest)
			chest.add_wound(/datum/wound/fracture/chest)
		if(groin)
			groin.add_wound(/datum/wound/fracture/groin)
		target.apply_damage(30, BRUTE, chest)
	else if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] tries and fails to insert [user.p_their()] tiny cock into [target]'s butt!"))
	else
		user.visible_message(span_warning("[user] slides [user.p_their()] cock into [target]'s butt!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/anal_sex/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] tries to fuck [target]'s ass, unsuccessfully."))
		user.sexcon.do_thrust_animate(target)
		playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
		return FALSE

	if(!user.sexcon.do_knot_action)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] fucks [target]'s ass."))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] knot-fucks [target]'s ass."))
	target.lose_anal_virginity(user)
	user.sexcon.intercourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		target.apply_damage(10, BRUTE, target.get_bodypart(BODY_ZONE_CHEST))
		target.apply_damage(3, BRUTE, target.get_bodypart(BODY_ZONE_PRECISE_GROIN))

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)
			if(HAS_TRAIT(target, TRAIT_POPPABLE))
				user.sexcon.try_belly_pop(target)

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user] cums into [target]'s butt!"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(splashed_user = target, orifice = SEX_PART_ANUS, consume_charge = i == 1 ? TRUE : FALSE)
			if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
			else if(HAS_TRAIT(target, TRAIT_OVERLY_FERTILE) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
			sleep(10)
		user.lose_virginity(target)

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 1.2, 4, FALSE)
	else
		user.sexcon.perform_sex_action(target, 2.4, !user.sexcon.do_knot_action ? 9 : 14, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/anal_sex/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] cock out of [target]'s butt."))

/datum/sex_action/anal_sex/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/anal_sex/double
	name = "Sodomize them with both cocks"

/datum/sex_action/anal_sex/double/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.double_penis_type())
		return FALSE
	return ..()

/datum/sex_action/anal_sex/double/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.double_penis_type())
		return FALSE
	return ..()

/datum/sex_action/anal_sex/double/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] forces [user.p_their()] cocks into [target]'s tiny butt!"))
		var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
		var/obj/item/bodypart/groin = target.get_bodypart(BODY_ZONE_PRECISE_GROIN)
		if(chest)
			chest.add_wound(/datum/wound/fracture/chest)
		if(groin)
			groin.add_wound(/datum/wound/fracture/groin)
		target.apply_damage(30, BRUTE, chest)
	else if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] tries and fails to insert [user.p_their()] tiny cocks into [target]'s butt!"))
	else
		user.visible_message(span_warning("[user] slides [user.p_their()] cocks into [target]'s butt!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/anal_sex/double/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!HAS_TRAIT(target, TRAIT_TINY) && HAS_TRAIT(user, TRAIT_TINY))
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] tries to double-fuck [target]'s ass, unsuccessfully."))
		user.sexcon.do_thrust_animate(target)
		playsound(target, 'sound/misc/mat/segso.ogg', 50, TRUE, -2, ignore_walls = FALSE)
		return FALSE

	if(!user.sexcon.do_knot_action)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] double-fucks [target]'s ass."))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] double-knots [target]'s ass."))
	target.lose_anal_virginity(user)
	user.sexcon.intercourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		target.apply_damage(10, BRUTE, target.get_bodypart(BODY_ZONE_CHEST))
		target.apply_damage(3, BRUTE, target.get_bodypart(BODY_ZONE_PRECISE_GROIN))

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)
		if(HAS_TRAIT(target, TRAIT_POPPABLE))
			user.sexcon.try_belly_pop(target)

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user] cums into [target]'s butt!"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(splashed_user = target, orifice = SEX_PART_ANUS, consume_charge = i == 1 ? TRUE : FALSE)
			if(HAS_TRAIT(target, TRAIT_BAOTHA_FERTILITY_BOON) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
			else if(HAS_TRAIT(target, TRAIT_OVERLY_FERTILE) && !target.getorganslot(ORGAN_SLOT_VAGINA))
				user.try_impregnate(target)
			sleep(10)
		user.lose_virginity(target)

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 1.2, 4, FALSE)
	else
		user.sexcon.perform_sex_action(target, 2.4, 14, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/anal_sex/double/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [user.p_their()] cocks out of [target]'s butt."))
