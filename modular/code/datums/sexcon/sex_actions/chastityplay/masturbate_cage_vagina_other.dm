/datum/sex_action/chastityplay/masturbate_cage_vagina_other
    name = "Rub their locked slit"
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
    user.visible_message(span_warning("[user] traces two fingers over the front panel of [target]'s chastity belt, finding the slot."))

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [user.p_their()] fingers along the gap in [target]'s belt, feeling the heat of locked skin through the slit..."))
    user.sexcon.perform_sex_action(target, 1.8, 0.5, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] slides [user.p_their()] fingers away from [target]'s belt."))

/datum/sex_action/chastityplay/masturbate_cage_vagina_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
