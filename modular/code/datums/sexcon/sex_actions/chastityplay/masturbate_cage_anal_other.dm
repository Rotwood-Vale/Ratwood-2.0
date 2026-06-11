/datum/sex_action/chastityplay/masturbate_cage_anal_other
    name = "挑逗他们的后庭贞操盾"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_ANUS

/datum/sex_action/chastityplay/masturbate_cage_anal_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user == target)
        return FALSE
    if(!target.sexcon.has_chastity_anal())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_anal_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user == target)
        return FALSE
    if(!target.sexcon.has_chastity_anal())
        return FALSE
    if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]把手探到[target]身后，摸索其贞操带后方护盾的边缘。"))

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]让手指沿着[target]后方护盾的接缝来回游走，朝着挡板贴住肌肤的地方持续压进去......"))
    user.sexcon.perform_sex_action(target, 1.5, 1, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_anal_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]把手从[target]后方的护盾上抽了回来。"))

/datum/sex_action/chastityplay/masturbate_cage_anal_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
