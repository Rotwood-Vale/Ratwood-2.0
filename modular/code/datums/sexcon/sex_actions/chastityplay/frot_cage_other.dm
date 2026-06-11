/datum/sex_action/chastityplay/frot_cage_other
    name = "让他们在你的贞操笼上磨蹭"
    user_sex_part = SEX_PART_COCK
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/frot_cage_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/frot_cage_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/frot_cage_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
        user.visible_message(span_warning("[user]握住[target]的阴茎，把它压到带刺的[get_chastity_device_name(user)]外侧，冷眼看着。"))
        return
    user.visible_message(span_warning("[user]伸手抓向[target]，把[target]的阴茎压在[get_chastity_device_name(user)]正面。"))

/datum/sex_action/chastityplay/frot_cage_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
        user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]拖着[target]的阴茎划过带刺的[get_chastity_device_name(user)]外表面，每一下都留下新的刺痛..."))
        user.sexcon.outercourse_noise(target, TRUE)

        user.sexcon.perform_sex_action(user, 0.8, 2.0, TRUE)
        user.sexcon.perform_sex_action(target, 0.8, 2.4, TRUE)
        user.sexcon.try_do_pain_scream(user, 2.0)
        user.sexcon.try_do_pain_scream(target, 2.4)
        user.sexcon.handle_passive_ejaculation(target)
        target.sexcon.handle_passive_ejaculation(user)
        return
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]让[target]的阴茎沿着[get_chastity_device_name(user)]栅条来回磨蹭，每一次划过都带起轻微的金属刮响..."))
    user.sexcon.outercourse_noise(target, TRUE)

    user.sexcon.perform_sex_action(user, 1.1, 1, TRUE)
    user.sexcon.perform_sex_action(target, 1.5, 0, TRUE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/frot_cage_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]放开[target]，让[target]的阴茎从[get_chastity_device_name(user)]上滑开。"))

/datum/sex_action/chastityplay/frot_cage_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
