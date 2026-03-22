/datum/sex_action/chastityplay/cage_grind_slit_other
    name = "Grind your cage on their genital slit"
    user_sex_part = SEX_PART_COCK
    target_sex_part = SEX_PART_SLIT_SHEATH

/datum/sex_action/chastityplay/cage_grind_slit_other/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
    if(!penis || penis.sheath_type != SHEATH_TYPE_SLIT)
        return FALSE
    // Target's slit must be accessible — hide if their own slit is caged.
    if(target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_grind_slit_other/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    var/obj/item/organ/penis/penis = target.getorganslot(ORGAN_SLOT_PENIS)
    if(!penis || penis.sheath_type != SHEATH_TYPE_SLIT)
        return FALSE
    if(target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, user))
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/cage_grind_slit_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] rolls forward until [user.p_their()] [get_chastity_device_name(user)] meets the flush seam of [target]'s genital slit."))

/datum/sex_action/chastityplay/cage_grind_slit_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [user.p_their()] [get_chastity_device_name(user)] against [target]'s slit in a slow, relentless grind..."))
    user.sexcon.outercourse_noise(target, TRUE)
    user.sexcon.perform_sex_action(user, 1.2, 1, TRUE)
    user.sexcon.perform_sex_action(target, 1.6, 0, TRUE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_grind_slit_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] rocks back, breaking contact between [user.p_their()] [get_chastity_device_name(user)] and [target]'s slit."))

/datum/sex_action/chastityplay/cage_grind_slit_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
