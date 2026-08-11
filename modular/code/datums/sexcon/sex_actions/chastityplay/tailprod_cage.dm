/datum/sex_action/chastityplay/tailprod_cage
	name = "Prod their cage with your tail"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_TAIL
	target_sex_part = SEX_PART_COCK
	target_needs_chastity = TRUE

/datum/sex_action/chastityplay/tailprod_cage/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] sweeps [user.p_their()] tail low and coils it around [target]'s [get_chastity_device_name(target)], feeling the weight of the device."))

/datum/sex_action/chastityplay/tailprod_cage/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] coils and strokes [user.p_their()] tail along [target]'s [get_chastity_device_name(target)], the tip pressing into gaps between bars with practiced patience..."))
	user.sexcon.perform_sex_action(target, 1.3, 2, TRUE)
	target.sexcon.handle_passive_ejaculation(user)

/datum/sex_action/chastityplay/tailprod_cage/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] uncoils [user.p_their()] tail from [target]'s [get_chastity_device_name(target)] and lets it drop."))

/datum/sex_action/chastityplay/tailprod_cage/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
