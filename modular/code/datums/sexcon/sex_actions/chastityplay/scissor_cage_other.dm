/datum/sex_action/chastityplay/scissor_cage_other
    name = "用锁住的肉缝磨蹭"
    user_sex_part = SEX_PART_CUNT
    target_sex_part = SEX_PART_CUNT

/datum/sex_action/chastityplay/scissor_cage_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(target.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/scissor_cage_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(target.sexcon.has_chastity_vagina())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/scissor_cage_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]向前挪动身体，直到[user.p_their()]贞操带上锁住的缝隙贴上[target]裸露的阴部。"))

/datum/sex_action/chastityplay/scissor_cage_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]用[user.p_their()]贞操带的缝隙磨蹭[target]的阴部，金属边缘一下一下拖过[target]最敏感的地方……"))
    user.sexcon.outercourse_noise(target, TRUE)
    user.sexcon.perform_sex_action(user, 1.6, 0.5, TRUE)
    user.sexcon.perform_sex_action(target, 1.7, 0.5, TRUE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/scissor_cage_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]缓缓分开，让贞操带的缝隙从[target]的阴部上轻轻拖离。"))

/datum/sex_action/chastityplay/scissor_cage_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
