/datum/sex_action/force_titjob
	name = "Jerk them off with tits"
	require_grab = TRUE
	target_sex_part = SEX_PART_COCK

/datum/sex_action/force_titjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/force_titjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_CHEST, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_BREASTS))
		return FALSE
	return TRUE


/datum/sex_action/force_titjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	if(breasts && breasts.breast_size < 2)
		user.visible_message(span_warning("[user] presses [target]'s cock against [user.p_their()] chest and starts rubbing it over it!"))
		return
	user.visible_message(span_warning("[user] grabs [target]'s cock and shoves it between [user.p_their()] tits!"))

/datum/sex_action/force_titjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	var/is_small_chest = breasts && breasts.breast_size < 2
	if(is_small_chest)
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rubs [target]'s cock against [user.p_their()] chest."))
	else
		user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] shoves [target]'s cock between [user.p_their()] tits."))
	user.sexcon.outercourse_noise(user)

	if(is_small_chest)
		user.sexcon.perform_sex_action(target, 1, 2, TRUE)
	else
		user.sexcon.perform_sex_action(target, 2, 4, TRUE)

	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/force_titjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/obj/item/organ/breasts/breasts = user.getorganslot(ORGAN_SLOT_BREASTS)
	if(breasts && breasts.breast_size < 2)
		user.visible_message(span_warning("[user] eases [target]'s cock away from [user.p_their()] chest."))
		return
	user.visible_message(span_warning("[user] pulls [target.p_their()] cock out from between [user.p_their()]'s tits."))

/datum/sex_action/force_titjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE

