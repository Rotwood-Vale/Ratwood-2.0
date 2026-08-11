/datum/sex_action/chastityplay/masturbate_cage_penis_other
    name = "Stroke their caged cock"
    category = SEX_CATEGORY_HANDS
    target_sex_part = SEX_PART_COCK
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] closes [user.p_their()] fingers around [target]'s [get_chastity_device_name(target)] and starts a slow, deliberate stroke."))

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] works [target]'s [get_chastity_device_name(target)] with a measured grip, [target.p_their()] cock pressing uselessly into the bars with every pull..."))
    user.sexcon.perform_sex_action(target, 1.9, 0.5, TRUE)
    target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/masturbate_cage_penis_other/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] lets go of [target]'s [get_chastity_device_name(target)] and steps back."))

/datum/sex_action/chastityplay/masturbate_cage_penis_other/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(target.sexcon.finished_check())
        return TRUE
    return FALSE
