/datum/sex_action/vaginal_ride_sex
	name = "Ride them"
	stamina_cost = 1.0
	aggro_grab_instead_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_CUNT
	target_sex_part = SEX_PART_COCK

/datum/sex_action/vaginal_ride_sex/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/vaginal_ride_sex/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/vaginal_ride_sex/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] gets on top of [target] and begins riding [target.p_them()] with [user.p_their()] cunt!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)

/datum/sex_action/vaginal_ride_sex/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rides [target]."))
	user.sexcon.intercourse_noise(user, TRUE)
	user.sexcon.do_thrust_animate(target)

	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	target.sexcon.perform_sex_action(target, 2, 0, TRUE)
	if(target.sexcon.check_active_ejaculation())
		target.visible_message(span_love("[target] cums into [user]'s cunt!"))
		target.sexcon.cum_into(splashed_user = user)
		target.try_impregnate(user)
		target.virginity = FALSE
		user.virginity = FALSE

	if(target.sexcon.considered_limp())
		target.sexcon.perform_sex_action(user, 1.2, 3, FALSE)
	else
		target.sexcon.perform_sex_action(user, 2.4, 7, FALSE)
	user.sexcon.handle_passive_ejaculation()

/datum/sex_action/vaginal_ride_sex/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] gets off [target]."))

/datum/sex_action/vaginal_ride_sex/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
