/datum/sex_action/chastityplay/tailprod_cage_anal
    name = "Tailprod their anal shield"
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
    user.visible_message(span_warning("[user] works [user.p_their()] tail tip under the lower edge of [target]'s rear shield, finding the gap between plate and skin."))

/datum/sex_action/chastityplay/tailprod_cage_anal/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [user.p_their()] tail beneath [target]'s rear shield, the tip pressing and curling against whatever the metal hasn't sealed away..."))
    user.sexcon.perform_sex_action(target, 1.1, 3, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/tailprod_cage_anal/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] withdraws [user.p_their()] tail from beneath [target]'s rear shield."))

/datum/sex_action/chastityplay/tailprod_cage_anal/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
