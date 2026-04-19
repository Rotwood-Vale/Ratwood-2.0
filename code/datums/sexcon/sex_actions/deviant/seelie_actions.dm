/datum/sex_action/seelie_fleshlight
	name = "fae cocksleeve"
	stamina_cost = 1.5
	require_grab = TRUE
	category = SEX_CATEGORY_PENETRATE
	user_sex_part = SEX_PART_COCK

/datum/sex_action/seelie_fleshlight/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_TINY))
		return FALSE
	if(!isseelie(target))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/seelie_fleshlight/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(HAS_TRAIT(user, TRAIT_TINY))
		return FALSE
	if(!isseelie(target))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.sexcon.can_use_penis())
		return FALSE
	return TRUE

/datum/sex_action/seelie_fleshlight/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_danger("[user] grabs [target]'s tiny body and wraps [target.p_them()] around [user.p_their()] cock!"))
	playsound(target, list('sound/misc/mat/insert (1).ogg','sound/misc/mat/insert (2).ogg'), 20, TRUE, ignore_walls = FALSE)
	var/obj/item/bodypart/chest = target.get_bodypart(BODY_ZONE_CHEST)
	var/obj/item/bodypart/groin = target.get_bodypart(BODY_ZONE_PRECISE_GROIN)
	chest?.add_wound(/datum/wound/fracture/chest)
	groin?.add_wound(/datum/wound/fracture/groin)
	if(chest)
		target.apply_damage(25, BRUTE, chest)

/datum/sex_action/seelie_fleshlight/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/list/messages = list(
		"[user] [user.sexcon.get_generic_force_adjective()] slides [target]'s entire body up and down [user.p_their()] shaft.",
		"[user] [user.sexcon.get_generic_force_adjective()] pumps [target]'s tiny body along [user.p_their()] cock, the fae's wings fluttering helplessly.",
		"[user] [user.sexcon.get_generic_force_adjective()] uses [target] like a living cocksleeve.",
	)
	user.visible_message(user.sexcon.spanify_force(pick(messages)))
	user.sexcon.intercourse_noise(target, TRUE)
	user.sexcon.do_thrust_animate(target)

	target.apply_damage(8, BRUTE, target.get_bodypart(BODY_ZONE_CHEST))
	target.apply_damage(3, BRUTE, target.get_bodypart(BODY_ZONE_PRECISE_GROIN))

	user.sexcon.perform_sex_action(user, 3, 0, TRUE)
	if(user.sexcon.check_active_ejaculation())
		user.visible_message(span_love("[user] cums all over [target]'s tiny, battered body!"))
		user.sexcon.cum_onto(target)
		user.virginity = FALSE

	user.sexcon.perform_sex_action(target, 0, 12, FALSE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/seelie_fleshlight/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_danger("[user] releases [target]'s crumpled body, dropping the battered fae."))

/datum/sex_action/seelie_fleshlight/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
