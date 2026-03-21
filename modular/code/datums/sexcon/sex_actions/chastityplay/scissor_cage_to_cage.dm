/datum/sex_action/chastityplay/scissor_cage_to_cage
    name = "Scissor belt to belt"
    user_sex_part = SEX_PART_CUNT
    target_sex_part = SEX_PART_CUNT

/datum/sex_action/chastityplay/scissor_cage_to_cage/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    if(!target.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/scissor_cage_to_cage/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    if(!target.sexcon.has_chastity_vagina())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/scissor_cage_to_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] maneuvers close until [user.p_their()] belt meets [target]'s belt \u2014 the contact announcing itself with a dull clunk of steel."))

/datum/sex_action/chastityplay/scissor_cage_to_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [user.p_their()] hips against [target]'s in a grinding scissor, metal dragging over metal with an ugly rasp..."))
    // Chastity device sound is handled internally by perform_sex_action via chastitycourse_noise — no outercourse noise here, it's purely metal-on-metal.
    user.sexcon.perform_sex_action(user, 1.3, 1, TRUE)
    user.sexcon.perform_sex_action(target, 1.3, 1, TRUE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/scissor_cage_to_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] untangles [user.p_their()] legs from [target]'s and the two belts scrape apart."))

/datum/sex_action/chastityplay/scissor_cage_to_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
