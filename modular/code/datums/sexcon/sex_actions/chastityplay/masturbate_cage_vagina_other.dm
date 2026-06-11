/datum/sex_action/chastityplay/masturbate_cage_vagina_other
    name = "摩擦他们被锁住的缝隙"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_CUNT

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user == target)
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(!target.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user == target)
        return FALSE
    if(!target.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(!target.sexcon.has_chastity_vagina())
        return FALSE
    if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]用两根手指划过[target]贞操带的前挡板，摸索着找到那道缝隙。"))

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]让手指沿着[target]贞操带上的缝隙来回游走，隔着细缝感受那层被锁住的滚烫肌肤......"))
    user.sexcon.perform_sex_action(target, 1.8, 0.5, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]把手指从[target]的贞操带上移开了。"))

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
