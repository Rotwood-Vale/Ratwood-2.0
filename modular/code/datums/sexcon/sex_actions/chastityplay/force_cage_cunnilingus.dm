/datum/sex_action/chastityplay/force_cage_cunnilingus
    name = "强迫他们舔你的贞操带"
    require_grab = TRUE
    stamina_cost = 1.0
    category = SEX_CATEGORY_PENETRATE
    target_sex_part = SEX_PART_JAWS

/datum/sex_action/chastityplay/force_cage_cunnilingus/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_cunnilingus/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_cunnilingus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]一把抓住[target]，把[target]的脸狠狠拖到贞操带上！"))

/datum/sex_action/chastityplay/force_cage_cunnilingus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]把[target]的嘴碾在贞操带的前片上，把[target]的舌头当成自己的一样使唤..."))
    user.sexcon.oralcourse_noise(target)
    user.sexcon.perform_sex_action(user, 1.8, 0, TRUE)
    user.sexcon.perform_sex_action(target, 0, 2, FALSE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/force_cage_cunnilingus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]猛地把[target]向后推开，[target]的脸上还留着贞操带前片压出的痕迹。"))

/datum/sex_action/chastityplay/force_cage_cunnilingus/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
