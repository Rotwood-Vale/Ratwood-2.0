/datum/sex_action/vaginal_ride_sex
	handles_target_climax = TRUE
	name = "Ride them"
	stamina_cost = 1.0
	aggro_grab_instead_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_CUNT
	target_sex_part = SEX_PART_COCK
	knot_on_finish = TRUE

/datum/sex_action/vaginal_ride_sex/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	return !HAS_TRAIT(user, TRAIT_TINY) || HAS_TRAIT(target, TRAIT_TINY)

/datum/sex_action/vaginal_ride_sex/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return FALSE
	return !HAS_TRAIT(user, TRAIT_TINY) || HAS_TRAIT(target, TRAIT_TINY)

/datum/sex_action/vaginal_ride_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.visible_message(span_warning("[user] gets on top of [target], trying and failing to ride the tiny cock with their cunt!"))
	else
		user.visible_message(span_warning("[user] gets on top of [target] and begins riding [target.p_them()] with [user.p_their()] cunt!"))
		playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/vaginal_ride_sex/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_TINY) && !HAS_TRAIT(user, TRAIT_TINY))
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] tries to ride [target], unsuccessfully."))
		user.sexcon.do_thrust_animate(target)
		return FALSE

	if(!user.sexcon.do_knot_action_as_bottom)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rides [target]."))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] knot-rides [target]."))
	user.sexcon.intercourse_noise(user, TRUE)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_pelvis_crush(target)

	target.sexcon.perform_sex_action(target, 2, 0, TRUE, involved_penis = target.getorganslot(ORGAN_SLOT_PENIS))
	if(target.sexcon.check_active_ejaculation())
		target.visible_message(span_love("[target] cums into [user]'s cunt!"))
		for(var/i = 1; i <= target.sexcon.get_load_bursts(); i++)
			target.sexcon.cum_into(splashed_user = user, knot_action = src, knot_swap_roles = TRUE, knot_btm = user, orifice = SEX_PART_CUNT, consume_charge = i == 1 ? TRUE : FALSE)
			target.try_impregnate(user)
			sleep(10)
		target.lose_virginity(user)
		user.lose_virginity(target)

	if(target.sexcon.considered_limp())
		target.sexcon.perform_sex_action(user, 1.2, 3, FALSE, involved_penis = target.getorganslot(ORGAN_SLOT_PENIS))
	else
		target.sexcon.perform_sex_action(user, 2.4, 7, FALSE, involved_penis = target.getorganslot(ORGAN_SLOT_PENIS))
	user.sexcon.handle_passive_ejaculation()

/datum/sex_action/vaginal_ride_sex/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] gets off [target]."))

/datum/sex_action/vaginal_ride_sex/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
