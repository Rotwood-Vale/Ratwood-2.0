/datum/sex_action/chastityplay/force_cage_cunnilingus
    name = "Force them to lick your belt"
    require_grab = TRUE
    stamina_cost = 1.0
    category = SEX_CATEGORY_PENETRATE
    target_sex_part = SEX_PART_JAWS

/datum/sex_action/chastityplay/force_cage_cunnilingus/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_cunnilingus/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/force_cage_cunnilingus/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] seizes [target] and drags [target.p_their()] face firmly against [user.p_their()] chastity belt!"))

/datum/sex_action/chastityplay/force_cage_cunnilingus/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] grinds [target]'s mouth against the front of [user.p_their()] belt, using [target.p_their()] tongue as [user.p_their()] own..."))
    user.sexcon.oralcourse_noise(target)
    user.sexcon.perform_sex_action(user, 1.8, 0, TRUE)
    user.sexcon.perform_sex_action(target, 0, 2, FALSE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/force_cage_cunnilingus/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] releases [target] with a firm shove backward, [target.p_their()] face marked with the imprint of the belt's front panel."))

/datum/sex_action/chastityplay/force_cage_cunnilingus/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
