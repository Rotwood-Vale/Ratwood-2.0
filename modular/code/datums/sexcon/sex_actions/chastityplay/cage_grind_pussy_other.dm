/datum/sex_action/chastityplay/cage_grind_pussy_other
    name = "用你的贞操笼磨蹭对方阴部"
    user_sex_part = SEX_PART_COCK
    target_sex_part = SEX_PART_CUNT

/datum/sex_action/chastityplay/cage_grind_pussy_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(target.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_grind_pussy_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
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

/datum/sex_action/chastityplay/cage_grind_pussy_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]前挺[user.p_their()]的腰，让[user.p_their()]的[get_chastity_device_name(user)]贴上[target]裸露的阴部。"))

/datum/sex_action/chastityplay/cage_grind_pussy_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]缓慢而刻意地用[user.p_their()]的贞操笼磨蹭[target]的阴部，栅栏温热地压着，却毫不退让……"))
    user.sexcon.outercourse_noise(target, TRUE)
    user.sexcon.do_thrust_animate(target)

    user.sexcon.perform_sex_action(user, 1.2, 0, TRUE)
    user.sexcon.perform_sex_action(target, 1.7, 1, TRUE)
    user.sexcon.handle_passive_ejaculation()
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_grind_pussy_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]缓缓退开，让[user.p_their()]的[get_chastity_device_name(user)]从[target]身上发出最后一声刮擦后离开。"))

/datum/sex_action/chastityplay/cage_grind_pussy_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
