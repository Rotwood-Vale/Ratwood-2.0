/datum/sex_action/chastityplay/frot_cage_other
    name = "Let them frot on your cage"
    user_sex_part = SEX_PART_COCK
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/frot_cage_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/frot_cage_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/frot_cage_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
        user.visible_message(span_warning("[user] takes [target.p_their()] cock and presses it to the outer face of [user.p_their()] spiked [get_chastity_device_name(user)], watching."))
        return
    user.visible_message(span_warning("[user] reaches for [target] and presses [target.p_their()] cock against the face of [user.p_their()] [get_chastity_device_name(user)]."))

/datum/sex_action/chastityplay/frot_cage_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
        user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] draws [target.p_their()] cock across the spiked outer surface of [user.p_their()] [get_chastity_device_name(user)], each drag leaving a new sting..."))
        user.sexcon.outercourse_noise(target, TRUE)

        user.sexcon.perform_sex_action(user, 0.8, 2.0, TRUE)
        user.sexcon.perform_sex_action(target, 0.8, 2.4, TRUE)
        user.sexcon.try_do_pain_scream(user, 2.0)
        user.sexcon.try_do_pain_scream(target, 2.4)
        user.sexcon.handle_passive_ejaculation(target)
        target.sexcon.handle_passive_ejaculation(user)
        return
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [target.p_their()] cock along the bars of [user.p_their()] [get_chastity_device_name(user)], each pass earning a faint rasp of metal..."))
    user.sexcon.outercourse_noise(target, TRUE)

    user.sexcon.perform_sex_action(user, 1.1, 1, TRUE)
    user.sexcon.perform_sex_action(target, 1.5, 0, TRUE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/frot_cage_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] releases [target] and lets [target.p_their()] cock slip away from [user.p_their()] [get_chastity_device_name(user)]."))

/datum/sex_action/chastityplay/frot_cage_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
