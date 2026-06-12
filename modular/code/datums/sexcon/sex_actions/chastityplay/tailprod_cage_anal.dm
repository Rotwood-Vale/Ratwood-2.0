/datum/sex_action/chastityplay/tailprod_cage_anal
    name = "用尾巴拨弄对方的后庭护盾"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_ANUS

/datum/sex_action/chastityplay/tailprod_cage_anal/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_TAIL))
        return FALSE
    if(!target.sexcon.has_chastity_anal())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/tailprod_cage_anal/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_TAIL))
        return FALSE
    if(!target.sexcon.has_chastity_anal())
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/tailprod_cage_anal/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]将[user.p_their()]的尾尖探入[target]后方护盾的下缘，摸索着挡板与皮肤之间的缝隙。"))

/datum/sex_action/chastityplay/tailprod_cage_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]让[user.p_their()]的尾巴在[target]后方护盾下缓缓游走，尾尖挤压、卷缠着金属尚未彻底封住的地方……"))
    user.sexcon.perform_sex_action(target, 1.1, 3, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/tailprod_cage_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]将[user.p_their()]的尾巴从[target]后方护盾下抽了回来。"))

/datum/sex_action/chastityplay/tailprod_cage_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
