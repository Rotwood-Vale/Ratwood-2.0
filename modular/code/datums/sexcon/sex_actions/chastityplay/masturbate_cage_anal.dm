/datum/sex_action/chastityplay/masturbate_cage_anal
    name = "摩擦你的后庭贞操盾"
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
    user.visible_message(span_warning("[user]反手把手指按上自己贞操带的后方护盾。"))

/datum/sex_action/chastityplay/masturbate_cage_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]让手指沿着自己贞操带的后挡板来回施压，专门按向护盾最贴近肌肤的位置......"))
    user.sexcon.perform_sex_action(user, 1.2, 1, TRUE)
    user.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/masturbate_cage_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]把手从自己贞操带的后方护盾上收了回来。"))

/datum/sex_action/chastityplay/masturbate_cage_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
