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
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, user, BODY_ZONE_CHEST))
		return FALSE
	if(!breasts)
		return FALSE
	if(breasts.breast_size < 3)
		return FALSE
	return TRUE

/datum/sex_action/titsmother/on_failed_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	if(!check_location_accessible(target, user, BODY_ZONE_CHEST))
		to_chat(user, span_notice("My chest needs to be accessible."))
		return
	if(breasts && breasts.breast_size < 3)
		to_chat(user, span_notice("My breasts are too small to do that..."))

/datum/sex_action/titsmother/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] smothers [target]'s head under [user.p_their()] tits!"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/titsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] smothers [target]'s face with [user.p_their()] tits..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.outercourse_noise(user)

	// Fat titty smash (only possible with massive/heaping/obscene size breasts)
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(breasts.breast_size > 6)	
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				user.sexcon.try_jaw_crush(target)
	
	// User pleasure
	user.sexcon.perform_sex_action(user, 1, 0, TRUE)
	user.sexcon.handle_passive_ejaculation(user)
	
	// Target pleasure
	user.sexcon.perform_sex_action(target, 1, 0.2, FALSE)
	target.sexcon.handle_passive_ejaculation(target)

	// Oxyloss from strong intent and up (only possible with moderate and higher size breasts)
	if(breasts.breast_size < 2)	
		user.sexcon.perform_deepthroat_oxyloss(target, 0.5)

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/titsmother/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [target]'s head out from under [user.p_their()] tits."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/titsmother/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
