/datum/sex_action/chastityplay/cage_dildo_vagina
    name = "摆弄对方内置假阳具"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_CUNT

/datum/sex_action/chastityplay/cage_dildo_vagina/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(!target.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_dildo_vagina/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(!target.sexcon.has_chastity_vagina())
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_dildo_vagina/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        user.visible_message(span_warning("[user]双手握住[target]尖刺贞操带的外壳，稳住它后开始摆弄。"))
        return
    user.visible_message(span_warning("[user]双手抓住[target]的贞操带，开始缓慢而刻意地摇动它。"))

/datum/sex_action/chastityplay/cage_dildo_vagina/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]带动[target]的尖刺贞操带来回碾磨，外壳每一次挪动都让倒刺划过柔软的血肉……"))
        user.sexcon.outercourse_noise(target, TRUE)
        user.sexcon.perform_sex_action(target, 1.3, 4.8, TRUE)
        user.sexcon.try_do_pain_scream(target, 4.8)
        target.sexcon.handle_passive_ejaculation(user)
        return
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]有节奏地摇磨[target]的贞操带，每一次推送都让内部的假阳具更深地顶入……"))
    user.sexcon.outercourse_noise(target, TRUE)
    user.sexcon.perform_sex_action(target, 2.3, 1.5, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_dildo_vagina/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]稳住[target]的贞操带后松开双手。"))

/datum/sex_action/chastityplay/cage_dildo_vagina/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
