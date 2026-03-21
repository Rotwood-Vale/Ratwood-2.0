/datum/sex_action/chastityplay/masturbate_cage_anal
    name = "Rub your anal shield"
    category = SEX_CATEGORY_HANDS
    user_sex_part = SEX_PART_ANUS

/datum/sex_action/chastityplay/masturbate_cage_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user != target)
        return FALSE
    if(!user.sexcon.has_chastity_anal())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user != target)
        return FALSE
    if(!user.sexcon.has_chastity_anal())
        return FALSE
    if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] reaches back to press [user.p_their()] fingers against [user.p_their()] belt's rear shield."))

/datum/sex_action/chastityplay/masturbate_cage_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [user.p_their()] fingers against the rear plate of [user.p_their()] belt, pressing where the shield rides closest to skin..."))
    user.sexcon.perform_sex_action(user, 1.2, 1, TRUE)
    user.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/masturbate_cage_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] withdraws [user.p_their()] hand from [user.p_their()] belt's rear shield."))

/datum/sex_action/chastityplay/masturbate_cage_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
