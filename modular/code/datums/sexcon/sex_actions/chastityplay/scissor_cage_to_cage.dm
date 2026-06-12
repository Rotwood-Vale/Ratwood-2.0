/datum/sex_action/chastityplay/scissor_cage_to_cage
    name = "贞操带互相磨蹭"
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
    user.visible_message(span_warning("[user]贴近[target]，直到[user.p_their()]的贞操带撞上[target]的贞操带，沉闷的钢铁碰响随之传开。"))

/datum/sex_action/chastityplay/scissor_cage_to_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]扭动[user.p_their()]的腰胯，与[target]互相磨蹭，金属擦着金属发出刺耳难听的刮响……"))
    // Chastity device sound is handled internally by perform_sex_action via chastitycourse_noise — no outercourse noise here, it's purely metal-on-metal.
    user.sexcon.perform_sex_action(user, 1.3, 1, TRUE)
    user.sexcon.perform_sex_action(target, 1.3, 1, TRUE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/scissor_cage_to_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]将[user.p_their()]的双腿从[target]身上抽开，两条贞操带在刺耳的刮擦声中分离。"))

/datum/sex_action/chastityplay/scissor_cage_to_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
