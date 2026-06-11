/datum/sex_action/chastityplay/masturbate_cage_vagina
    name = "摩擦你被锁住的缝隙"
    category = SEX_CATEGORY_HANDS
    user_sex_part = SEX_PART_CUNT

/datum/sex_action/chastityplay/masturbate_cage_vagina/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user != target)
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_vagina/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user != target)
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_VAGINA))
        return FALSE
    if(!user.sexcon.has_chastity_vagina())
        return FALSE
    if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_vagina/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]把手指平贴在自己贞操带上，寻找前挡板之间的缝隙。"))

/datum/sex_action/chastityplay/masturbate_cage_vagina/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]在自己贞操带前端不断打着圈摩擦，手指勉强从缝隙间探进去，压向最敏感的位置......"))
    user.sexcon.perform_sex_action(user, 1.6, 0.5, TRUE)
    user.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/masturbate_cage_vagina/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]把手从自己的贞操带上抽开，满心挫败，却依旧得不到纾解。"))

/datum/sex_action/chastityplay/masturbate_cage_vagina/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
