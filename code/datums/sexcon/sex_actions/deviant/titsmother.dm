/datum/sex_action/titsmother
	name = "Smother them with boobs"
	subtle_supported = TRUE

/datum/sex_action/titsmother/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_CHEST))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return
	return TRUE

/datum/sex_action/titsmother/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	. = ..()
	if(!.)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_CHEST))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/titsmother/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] shoves [target]'s head between [user.p_their()] tits!"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/titsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] smothers [target]'s face with [user.p_their()] tits..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

	if(!do_subtle)
		user.sexcon.outercourse_noise()

	// Fat titty smash
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(istype(user.rmb_intent, /datum/rmb_intent/strong))
			user.sexcon.try_jaw_crush(target)
	
	// User pleasure
	user.sexcon.perform_sex_action(user, 1, 0, TRUE)
	user.sexcon.handle_passive_ejaculation(user)
		

/datum/sex_action/titsmother/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [target]'s head out from inbetween [user.p_their()] tits."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/titsmother/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
