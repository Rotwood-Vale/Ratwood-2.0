/datum/sex_action/knot_grinding
	name = "Grind knot inside them"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE

/datum/sex_action/knot_grinding/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(user.sexcon.knotted_status != KNOTTED_AS_TOP)
		return FALSE
	return TRUE

/datum/sex_action/knot_grinding/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(user.sexcon.knotted_status != KNOTTED_AS_TOP)
		return FALSE
	if(!(user.sexcon.knotted_part_partner&(SEX_PART_CUNT|SEX_PART_ANUS|SEX_PART_JAWS|SEX_PART_SLIT_SHEATH))) // if we're not knotted anyone of these, abort
		return FALSE
	return TRUE

/datum/sex_action/knot_grinding/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] massages [user.p_their()] knot inside [target]..."), vision_distance = 1)

/datum/sex_action/knot_grinding/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/zone_text
	var/pleasure_target
	switch(user.sexcon.knotted_part_partner)
		if(SEX_PART_CUNT)
			pleasure_target = 2
			zone_text = "cunt"
		if(SEX_PART_ANUS)
			var/has_prostate = target.getorganslot(ORGAN_SLOT_PENIS)
			pleasure_target = has_prostate ? 4 : 1
			zone_text = "butt"
		if(SEX_PART_JAWS)
			pleasure_target = 0
			zone_text = "mouth"
			target.adjustOxyLoss(3) // we're choking them
		if(SEX_PART_SLIT_SHEATH)
			pleasure_target = 2
			zone_text = "sheath"
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] grinds [user.p_their()] knot inside [target]'s [zone_text]..."))
	user.sexcon.make_sucking_noise()
	user.sexcon.do_thrust_animate(target, pixels = 2, time = 1.5)

	user.sexcon.perform_sex_action(user, 2, 0.5, TRUE)
	user.sexcon.handle_passive_ejaculation()

	if(pleasure_target)
		user.sexcon.perform_sex_action(target, pleasure_target, 0, TRUE)
	target.sexcon.handle_passive_ejaculation()

/datum/sex_action/knot_grinding/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops grinding [user.p_their()] knot inside [target] ..."), vision_distance = 1)

/datum/sex_action/knot_grinding/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
