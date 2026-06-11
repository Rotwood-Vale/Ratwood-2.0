/datum/sex_action/throat_sex
	name = "抽插对方喉咙"
	stamina_cost = 1.0
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_JAWS
	knot_on_finish = TRUE

/datum/sex_action/throat_sex/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(isdullahan(target) && knot_on_finish)
		var/datum/species/dullahan/dullahan = target.dna.species
		if(dullahan.headless)
			return FALSE
	return TRUE

/datum/sex_action/throat_sex/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.sexcon.can_use_penis())
		return FALSE
	if(isdullahan(target) && knot_on_finish)
		var/datum/species/dullahan/dullahan = target.dna.species
		if(dullahan.headless)
			return FALSE
	return TRUE

/datum/sex_action/throat_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]的肉棒滑入了[target]的喉咙！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/throat_sex/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.do_knot_action)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]抽插着[target]的喉咙。"))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用结顶弄着[target]的喉咙。"))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.oralcourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_jaw_crush(target)

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user]射进了[target]的喉咙里！"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(oral = TRUE, splashed_user = target, consume_charge = i == 1 ? TRUE : FALSE) // give facial status effect for the target, considering this was rough throat sex
			sleep(10)
		user.virginity = FALSE

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 0, 2, FALSE)
	else
		user.sexcon.perform_sex_action(target, 0, 7, FALSE)
		user.sexcon.perform_deepthroat_oxyloss(target, 2.6)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/throat_sex/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的肉棒从[target]的喉咙里抽了出来。"))

/datum/sex_action/throat_sex/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/throat_sex/double
	name = "用双根肉棒抽插对方喉咙"

/datum/sex_action/throat_sex/double/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.double_penis_type())
		return FALSE
	return ..()

/datum/sex_action/throat_sex/double/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.double_penis_type())
		return FALSE
	return ..()

/datum/sex_action/throat_sex/double/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]将[user.p_their()]的双根肉棒滑入了[target]的喉咙！"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/throat_sex/double/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!user.sexcon.do_knot_action)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用双根肉棒抽插着[target]的喉咙。"))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用双结顶弄着[target]的喉咙。"))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.oralcourse_noise(target)
	user.sexcon.do_thrust_animate(target)

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user]射进了[target]的喉咙里！"))
		for(var/i = 1; i <= user.sexcon.get_load_bursts(); i++)
			user.sexcon.cum_into(oral = TRUE, splashed_user = target, consume_charge = i == 1 ? TRUE : FALSE) // give facial status effect for the target, considering this was rough throat sex
			sleep(10)
		user.virginity = FALSE

	if(user.sexcon.considered_limp())
		user.sexcon.perform_sex_action(target, 0, 2, FALSE)
	else
		user.sexcon.perform_sex_action(target, 0, 7, FALSE)
		user.sexcon.perform_deepthroat_oxyloss(target, 2.6)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/throat_sex/double/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的双根肉棒从[target]的喉咙里抽了出来。"))
