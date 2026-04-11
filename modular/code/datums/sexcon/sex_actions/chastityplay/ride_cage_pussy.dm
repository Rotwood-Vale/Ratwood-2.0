/datum/sex_action/chastityplay/ride_cage_pussy
    name = "Ride their cage"
    stamina_cost = 1.0
    category = SEX_CATEGORY_PENETRATE
    user_sex_part = SEX_PART_CUNT
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/ride_cage_pussy/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(user.sexcon.has_chastity_vagina())
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/ride_cage_pussy/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(user.sexcon.has_chastity_vagina())
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/ride_cage_pussy/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] straddles [target] and settles [user.p_their()] weight down until [user.p_their()] pussy meets the bars of [target.p_their()] [get_chastity_device_name(target)]."))

/datum/sex_action/chastityplay/ride_cage_pussy/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rolls [user.p_their()] hips along [target]'s [get_chastity_device_name(target)], grinding [user.p_their()] bare pussy against bars that have no give..."))
    user.sexcon.outercourse_noise(target, TRUE)
    user.sexcon.do_thrust_animate(target)

    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    user.sexcon.perform_sex_action(user, 2.1, 0, TRUE)
    user.sexcon.perform_sex_action(target, 1.3, 1, TRUE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/ride_cage_pussy/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] lifts [user.p_their()] hips and slides off [target]'s [get_chastity_device_name(target)], the metal cold as [user.p_their()] warmth leaves it."))

/datum/sex_action/chastityplay/ride_cage_pussy/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
