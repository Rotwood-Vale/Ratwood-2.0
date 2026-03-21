/datum/sex_action/chastityplay/masturbate_cage_penis
    name = "Stroke your caged cock"
    category = SEX_CATEGORY_HANDS
    user_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/masturbate_cage_penis/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user != target)
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    // has_chastity_cage() would also match vagina-only belts; we specifically need a caged cock here.
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user != target)
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] wraps [user.p_their()] hand around [user.p_their()] [get_chastity_device_name(user)] and starts working it slow, knuckles pressing into the bars."))

/datum/sex_action/chastityplay/masturbate_cage_penis/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] drags [user.p_their()] palm up and down [user.p_their()] [get_chastity_device_name(user)], cock straining into the bars with every pass..."))
    user.sexcon.perform_sex_action(user, 1.6, 0.5, TRUE)
    user.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/masturbate_cage_penis/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] drops [user.p_their()] hand from [user.p_their()] [get_chastity_device_name(user)], breathless and no further along."))

/datum/sex_action/chastityplay/masturbate_cage_penis/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
