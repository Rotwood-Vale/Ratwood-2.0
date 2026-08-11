/datum/sex_action/chastityplay/force_cage_nuzzle
    name = "Force them to nuzzle your cage"
    require_grab = TRUE
    stamina_cost = 1.0
    target_sex_part = SEX_PART_JAWS
	user_sex_part = SEX_PART_COCK
	user_needs_chastity = TRUE

/datum/sex_action/chastityplay/force_cage_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] takes hold of [target]'s head and guides it firmly into [user.p_their()] [get_chastity_device_name(user)]."))

/datum/sex_action/chastityplay/force_cage_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] holds [target]'s face against [user.p_their()] [get_chastity_device_name(user)], nose and cheek pressed into the metal..."))
    target.sexcon.make_sucking_noise()
    user.sexcon.perform_sex_action(user, 0.9, 0, TRUE)
    user.sexcon.perform_sex_action(target, 0, 1.5, FALSE)
    user.sexcon.handle_passive_ejaculation(target)
    target.sexcon.handle_passive_ejaculation()

/datum/sex_action/chastityplay/force_cage_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
    user.visible_message(span_warning("[user] loosens [user.p_their()] grip and lets [target] pull [target.p_their()] face back from [user.p_their()] [get_chastity_device_name(user)]."))

/datum/sex_action/chastityplay/force_cage_nuzzle/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
    if(user.sexcon.finished_check())
        return TRUE
    return FALSE
