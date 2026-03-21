/datum/sex_action/chastityplay/cage_grind_pussy_other
    name = "Grind your cage on their pussy"
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
    user.visible_message(span_warning("[user] rolls [user.p_their()] hips forward until [user.p_their()] [get_chastity_device_name(user)] settles against [target]'s bare pussy."))

/datum/sex_action/chastityplay/cage_grind_pussy_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] rolls [user.p_their()] cage against [target]'s pussy in a slow, deliberate grind \u2014 bars pressing warm and unyielding..."))
    user.sexcon.outercourse_noise(target, TRUE)
    user.sexcon.do_thrust_animate(target)

    user.sexcon.perform_sex_action(user, 1.2, 0, TRUE)
    user.sexcon.perform_sex_action(target, 1.7, 1, TRUE)
    user.sexcon.handle_passive_ejaculation()
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/cage_grind_pussy_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] eases back, the metal of [user.p_their()] [get_chastity_device_name(user)] pulling away from [target] with a last rasp of contact."))

/datum/sex_action/chastityplay/cage_grind_pussy_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
