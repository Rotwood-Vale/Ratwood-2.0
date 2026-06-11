/datum/sex_action/chastityplay/masturbate_cage_penis_other
    name = "抚弄他们被锁住的阴茎"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/masturbate_cage_penis_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    // has_chastity_cage() also matches vagina-only belts; we need a caged cock specifically.
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]用手指握住[target]的[get_chastity_device_name(target)]，开始缓慢而刻意地抚弄。"))

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]以稳定的力道套弄[target]的[get_chastity_device_name(target)]，每一次拉动都只让[target]的阴茎徒劳地顶向栅栏......"))
    user.sexcon.perform_sex_action(target, 1.9, 0.5, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]松开了[target]的[get_chastity_device_name(target)]，向后退了一步。"))

/datum/sex_action/chastityplay/masturbate_cage_penis_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
