/datum/sex_action/chastityplay/sounding_cock_cage
    name = "探弄对方被锁住的尿道"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/sounding_cock_cage/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    var/obj/item/organ/penis/target_cock = target.getorganslot(ORGAN_SLOT_PENIS)
    if(!target_cock)
        return FALSE
    // Slitted penises have no urethral opening to sound. Sorry taper chuds.
    if(target_cock.sheath_type == SHEATH_TYPE_SLIT)
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/sounding_cock_cage/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(!requires_other_target(user, target))
        return FALSE
    var/obj/item/organ/penis/target_cock = target.getorganslot(ORGAN_SLOT_PENIS)
    if(!target_cock)
        return FALSE
    if(target_cock.sheath_type == SHEATH_TYPE_SLIT)
        return FALSE
    if(!target.sexcon.has_chastity_penis())
        return FALSE
    if(!can_reach_target_groin(user, target))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/sounding_cock_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        user.visible_message(span_warning("[user]取出一根细探针，小心调整角度，朝[target]的尿道口探去，同时避开[target.p_their()]的[get_chastity_device_name(target)]上的尖刺。"))
        return
    user.visible_message(span_warning("[user]取出一根细探针，对准[target]的[get_chastity_device_name(target)]上那一小处裸露的开口。"))

/datum/sex_action/chastityplay/sounding_cock_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(HAS_TRAIT(user, TRAIT_DEATHBYSNUSNU))
        user.sexcon.try_pelvis_crush(target)

    if(HAS_TRAIT(target, TRAIT_CHASTITY_SPIKED))
        user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]将探针穿过那带刺的[get_chastity_device_name(target)]缓缓推进，[target]每一次细微的抽动都会让笼上的尖刺更深地压进去……"))
        user.sexcon.perform_sex_action(target, 0.2, 10.2, TRUE)
        user.sexcon.try_do_pain_scream(target, 10.2)
        target.sexcon.handle_passive_ejaculation(user)
        return
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]顺着[target.p_their()]的[get_chastity_device_name(target)]开口，将探针一点点更深地送入[target]的尿道，动作缓慢而刻意……"))
    user.sexcon.perform_sex_action(target, 0.5, 8.5, TRUE)
    user.sexcon.try_do_pain_scream(target, 8.5)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/sounding_cock_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]小心而缓慢地一下下将探针从[target]的[get_chastity_device_name(target)]中抽出。"))

/datum/sex_action/chastityplay/sounding_cock_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
