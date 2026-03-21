/datum/sex_action/chastityplay/frot_cage
	name = "Frot with their chastity device"
	user_sex_part =	SEX_PART_COCK
	target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/frot_cage/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!target.sexcon.has_chastity_penis())
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/frot_cage/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!requires_other_target(user, target))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!target.sexcon.has_chastity_penis())
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!can_reach_target_groin(user, target))
		return FALSE
	return TRUE

/datum/sex_action/chastityplay/frot_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		user.visible_message(span_warning("[user] eases [user.p_their()] cock against the outer face of [target]'s spiked [get_chastity_device_name(target)], finding the edges carefully."))
		return
	user.visible_message(span_warning("[user] presses [user.p_their()] cock flush against the face of [target]'s [get_chastity_device_name(target)]."))

/datum/sex_action/chastityplay/frot_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
		user.sexcon.try_pelvis_crush(target)

	if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
		play_chastity_impact_sound(target, 'sound/combat/hits/bladed/genstab (1).ogg', 40, 45)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] drags [user.p_their()] cock across [target]'s spiked [get_chastity_device_name(target)] — each stroke on the outside forces the inward spikes across [target.p_their()] skin..."))
		user.sexcon.outercourse_noise(target, TRUE)
		user.sexcon.perform_sex_action(user, 0.8, 0.4, TRUE)
		user.sexcon.perform_sex_action(target, 0.8, 3.2, TRUE)
		user.sexcon.try_do_pain_scream(target, 3.2)
		user.sexcon.handle_passive_ejaculation(target)
		target.sexcon.handle_passive_ejaculation(user)

		if(target.sexcon.check_active_ejaculation())
			target.sexcon.ejaculate()
		return
	play_chastity_impact_sound(target, list('sound/combat/hits/onmetal/grille (1).ogg', 'sound/combat/hits/onmetal/grille (2).ogg'), 35, 35)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] slides [user.p_their()] cock along the length of [target]'s [get_chastity_device_name(target)], hips rolling into every pass..."))
	user.sexcon.outercourse_noise(target, TRUE)
	user.sexcon.perform_sex_action(user, 1.2, 0, TRUE)
	user.sexcon.perform_sex_action(target, 1.4, 1, TRUE)
	user.sexcon.handle_passive_ejaculation(target)
	target.sexcon.handle_passive_ejaculation(user)

	if(target.sexcon.check_active_ejaculation())
		target.sexcon.ejaculate()

/datum/sex_action/chastityplay/frot_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] rolls [user.p_their()] hips back and breaks contact with [target]'s [get_chastity_device_name(target)]."))

/datum/sex_action/chastityplay/frot_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
	
