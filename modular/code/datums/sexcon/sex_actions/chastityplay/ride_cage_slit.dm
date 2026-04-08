/datum/sex_action/chastityplay/ride_cage_slit
    name = "Ride their cage with your slit"
    stamina_cost = 1.0
    category = SEX_CATEGORY_PENETRATE
    user_sex_part = SEX_PART_SLIT_SHEATH
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/ride_cage_slit/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    var/obj/item/organ/penis/user_penis = user.getorganslot(ORGAN_SLOT_PENIS)
    if(!user_penis || user_penis.sheath_type != SHEATH_TYPE_SLIT)
        return FALSE
    if(user.sexcon.has_chastity_cage())
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/ride_cage_slit/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    var/obj/item/organ/penis/user_penis = user.getorganslot(ORGAN_SLOT_PENIS)
    if(!user_penis || user_penis.sheath_type != SHEATH_TYPE_SLIT)
        return FALSE
    if(!user.sexcon.can_use_penis())
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/ride_cage_slit/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] straddles [target] and rolls forward until [user.p_their()] genital slit settles flush against [target.p_their()] [get_chastity_device_name(target)]."))

/datum/sex_action/chastityplay/ride_cage_slit/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [user.p_their()] slit along the length of [target]'s [get_chastity_device_name(target)], each pass dragging metal across sensitive flesh..."))
    user.sexcon.outercourse_noise(target, TRUE)

    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    user.sexcon.perform_sex_action(user, 1.8, 0, TRUE)
    user.sexcon.perform_sex_action(target, 1.2, 1, TRUE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/ride_cage_slit/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] rocks back and lifts [user.p_their()] slit off [target]'s [get_chastity_device_name(target)], the separation quiet and deliberate."))

/datum/sex_action/chastityplay/ride_cage_slit/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
