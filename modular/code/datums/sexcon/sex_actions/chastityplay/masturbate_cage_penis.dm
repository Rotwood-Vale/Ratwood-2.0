/datum/sex_action/chastityplay/masturbate_cage_penis
    name = "抚弄你被锁住的阴茎"
    category = SEX_CATEGORY_HANDS
    user_sex_part = SEX_PART_COCK

/datum/sex_action/chastityplay/masturbate_cage_penis/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user != target)
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    // has_chastity_cage() would also match vagina-only belts; we specifically need a caged cock here.
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user != target)
        return FALSE
    if(!user.getorganslot(ORGAN_SLOT_PENIS))
        return FALSE
    if(!user.sexcon.has_chastity_penis())
        return FALSE
    if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
        return FALSE
    return TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]用手环住自己的[get_chastity_device_name(user)]，开始缓缓套弄，指节压进了栅栏之间。"))

/datum/sex_action/chastityplay/masturbate_cage_penis/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(user.sexcon.spanify_force("[user][user.sexcon.get_generic_force_adjective()]让掌心沿着自己的[get_chastity_device_name(user)]上下摩擦，每一次来回都让阴茎徒劳地顶向栅栏......"))
    user.sexcon.perform_sex_action(user, 1.6, 0.5, TRUE)
    user.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/masturbate_cage_penis/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user]把手从自己的[get_chastity_device_name(user)]上放了下来，气息紊乱，却依旧毫无进展。"))

/datum/sex_action/chastityplay/masturbate_cage_penis/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
