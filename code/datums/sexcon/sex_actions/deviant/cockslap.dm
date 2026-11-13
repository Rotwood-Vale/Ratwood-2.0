/datum/sex_action/cockslap
	name = "Cockslap them"
	check_same_tile = FALSE
	do_time = 2.5 SECONDS
	stamina_cost = 0
	category = SEX_CATEGORY_MISC
	user_sex_part = SEX_PART_COCK

/// Only massive pintles can cockslap. They don't need to be erect.
/datum/sex_action/cockslap/proc/has_massive_pintle(mob/living/carbon/human/user)
	var/obj/item/organ/penis/pintle = user.getorganslot(ORGAN_SLOT_PENIS)
	return pintle?.massive

/datum/sex_action/cockslap/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!has_massive_pintle(user))
		return FALSE
	return ..()

/datum/sex_action/cockslap/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!has_massive_pintle(user))
		return FALSE
	if(!(. = ..()))
		return FALSE
	if(!user.sexcon.Adjacent_Or_Closet(target))
		return FALSE
	// Their face has to be bare: masks and helmets block it.
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	// Can't swing it while someone is riding or sucking it.
	if(user.sexcon.is_pintle_occupied())
		return FALSE
	return TRUE

/datum/sex_action/cockslap/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] hefts [user.p_their()] massive cock and lines it up with [target]'s face!"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/cockslap/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/force = user.sexcon.force
	var/do_subtle = user.sexcon.do_subtle_action
	playsound(target, pick('sound/foley/slap.ogg', 'sound/foley/smackspecial.ogg'), 50, TRUE, -2, ignore_walls = FALSE)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] slaps [target] across the face with [user.p_their()] massive cock."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

	user.sexcon.perform_sex_action(user, 1, 0, TRUE)
	user.sexcon.perform_sex_action(target, 1 + (0.3 * force), 0.5 * force, FALSE)
	user.sexcon.handle_passive_ejaculation()
	target.sexcon.handle_passive_ejaculation()

	if(force >= SEX_FORCE_HIGH && prob(30))
		to_chat(target, span_warning("My cheek stings from the heavy slap!"))

/datum/sex_action/cockslap/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops cockslapping [target]."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/cockslap/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
