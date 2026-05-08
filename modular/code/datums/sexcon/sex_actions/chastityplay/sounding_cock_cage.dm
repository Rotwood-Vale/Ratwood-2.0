/datum/sex_action/chastityplay/sounding_cock_cage
    name = "Sound their caged urethra"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/sounding_cock_cage/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    var/obj/item/organ/penis/target_cock = target.getorganslot(ORGAN_SLOT_PENIS)
    if(!target_cock)
        return FALSE
    // Slitted penises have no urethral opening to sound. Sorry taper chuds.
    if(target_cock.sheath_type == SHEATH_TYPE_SLIT)
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/sounding_cock_cage/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    var/obj/item/organ/penis/target_cock = target.getorganslot(ORGAN_SLOT_PENIS)
    if(!target_cock)
        return FALSE
    if(target_cock.sheath_type == SHEATH_TYPE_SLIT)
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/sounding_cock_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        user.visible_message(span_warning("[user] produces a thin probe and angles it carefully toward [target]'s urethral opening, navigating the spikes of [target.p_their()] [get_chastity_device_name(target)]."))
        return
    user.visible_message(span_warning("[user] produces a thin probe and lines it up with the small exposed opening of [target]'s [get_chastity_device_name(target)]."))

/datum/sex_action/chastityplay/sounding_cock_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] advances the probe through the spiked [get_chastity_device_name(target)], each tiny flinch from [target] pressing the cage's spikes deeper inward..."))
        user.sexcon.perform_sex_action(target, 0.2, 10.2, TRUE)
        user.sexcon.try_do_pain_scream(target, 10.2)
        target.sexcon.handle_passive_ejaculation(user)
        return
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works the probe deeper into [target]'s urethra through the opening of [target.p_their()] [get_chastity_device_name(target)], slow and deliberate..."))
    user.sexcon.perform_sex_action(target, 0.5, 8.5, TRUE)
    user.sexcon.try_do_pain_scream(target, 8.5)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/sounding_cock_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] draws the probe back out of [target]'s [get_chastity_device_name(target)] in one careful, slow pull."))

/datum/sex_action/chastityplay/sounding_cock_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
