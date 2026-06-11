/datum/sex_action/chastityplay/force_cage_nuzzle
    name = "强迫他们蹭你的贞操笼"
    require_grab = TRUE
    stamina_cost = 1.0
    target_sex_part = SEX_PART_JAWS

/datum/sex_action/chastityplay/force_cage_nuzzle/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_nuzzle/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]按住[target]的头，强硬地把它引向[get_chastity_device_name(user)]。"))

/datum/sex_action/chastityplay/force_cage_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]把[target]的脸按在[get_chastity_device_name(user)]上，鼻子和脸颊都被压向金属..."))
    target.sexcon.make_sucking_noise()
    user.sexcon.perform_sex_action(user, 0.9, 0, TRUE)
    user.sexcon.perform_sex_action(target, 0, 1.5, FALSE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/force_cage_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]松开手劲，让[target]把脸从[get_chastity_device_name(user)]前抽回。"))

/datum/sex_action/chastityplay/force_cage_nuzzle/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
