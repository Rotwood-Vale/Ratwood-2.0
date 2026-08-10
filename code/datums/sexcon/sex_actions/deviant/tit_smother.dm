/datum/sex_action/titsmother
	name = "Smother them with boobs"
	subtle_supported = TRUE

/datum/sex_action/titsmother/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_CHEST))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE

/datum/sex_action/titsmother/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	if(user == target)
		return FALSE
	if(!user.sexcon.Adjacent_Or_Closet(target))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_CHEST))
		return FALSE
	if(!breasts)
		return FALSE
	return TRUE

/datum/sex_action/titsmother/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	if(breasts && breasts.breast_size < 3)
		user.visible_message(span_warning("[user] presses [target]'s face against [user.p_their()] chest!"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
		user.sexcon.show_progress = 0
		return
	user.visible_message(span_warning("[user] smothers [target]'s head under [user.p_their()] tits!"), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/titsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	if(!breasts)
		user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE
		return
	var/breast_size = breasts.breast_size
	var/is_small_chest = breast_size < 3
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	if(is_small_chest)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] presses [target]'s face into [user.p_their()] chest..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] smothers [target]'s face with [user.p_their()] tits..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.outercourse_noise(user)

	// Fat titty smash (only possible with massive/heaping/obscene size breasts)
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU) || (user.STASTR > 12))
		if(breast_size > 6)
			if(istype(user.rmb_intent, /datum/rmb_intent/strong))
				user.sexcon.try_jaw_crush(target)

	// User pleasure
	if(is_small_chest)
		user.sexcon.perform_sex_action(user, 0.6, 0, TRUE)
	else
		user.sexcon.perform_sex_action(user, 1, 0, TRUE)
	user.sexcon.handle_passive_ejaculation(user)

	// Target pleasure
	if(is_small_chest)
		user.sexcon.perform_sex_action(target, 0.6, 0.1, FALSE)
	else
		user.sexcon.perform_sex_action(target, 1, 0.2, FALSE)
	target.sexcon.handle_passive_ejaculation(target)

	// Oxyloss from sex intensity rough and up, scaled by chest size.
	if(!is_small_chest)
		user.sexcon.perform_deepthroat_oxyloss(target, 1.3)
	user.sexcon.handle_passive_ejaculation(user)

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/titsmother/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	if(breasts && breasts.breast_size < 3)
		user.visible_message(span_warning("[user] eases [target]'s face away from [user.p_their()] chest."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
		return
	user.visible_message(span_warning("[user] pulls [target]'s head out from under [user.p_their()] tits."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/titsmother/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
