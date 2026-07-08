/datum/sex_action/titsmother
	name = "Smother them with boobs"

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
	user.visible_message(span_warning("[user] shoves [target]'s head between [user.p_their()] tits!"))

/datum/sex_action/titsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [sex_session.get_generic_force_adjective()] smothers [target]'s face with [user.p_their()] tits..."))
	user.sexcon.outercourse_noise(user)

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)

	user.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/titsmother/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [target]'s head out from inbetween [user.p_their()] tits."))

/datum/sex_action/titsmother/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
