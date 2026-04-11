/datum/sex_action/chastityplay/masturbate_cage_penis_other
    name = "Stroke their caged cock"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/masturbate_cage_penis_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    // has_chastity_cage() also matches vagina-only belts; we need a caged cock specifically.
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] closes [user.p_their()] fingers around [target]'s [get_chastity_device_name(target)] and starts a slow, deliberate stroke."))

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [target]'s [get_chastity_device_name(target)] with a measured grip, [target.p_their()] cock pressing uselessly into the bars with every pull..."))
    user.sexcon.perform_sex_action(target, 1.9, 0.5, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] lets go of [target]'s [get_chastity_device_name(target)] and steps back."))

/datum/sex_action/chastityplay/masturbate_cage_penis_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
