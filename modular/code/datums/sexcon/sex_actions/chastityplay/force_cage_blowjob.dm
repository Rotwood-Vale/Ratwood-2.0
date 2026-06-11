/datum/sex_action/chastityplay/force_cage_blowjob
    name = "强迫他们贴上你的贞操笼"
    require_grab = TRUE
    stamina_cost = 1.0
    category = SEX_CATEGORY_PENETRATE
    target_sex_part = SEX_PART_JAWS

/datum/sex_action/chastityplay/force_cage_blowjob/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_blowjob/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_blowjob/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]抓住[target]的后脑，把[target]的脸猛地按进[get_chastity_device_name(user)]里！"))

/datum/sex_action/chastityplay/force_cage_blowjob/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]把[target]的脸死死压在[get_chastity_device_name(user)]上，口鼻都被挤进了冰冷金属之间..."))
    user.sexcon.oralcourse_noise(target)
    user.sexcon.perform_sex_action(user, 1.3, 0.5, TRUE)
    user.sexcon.perform_sex_action(target, 0, 3, FALSE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/force_cage_blowjob/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]松开[target]的头，让[target]从[get_chastity_device_name(user)]前挣脱开来。"))

/datum/sex_action/chastityplay/force_cage_blowjob/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
