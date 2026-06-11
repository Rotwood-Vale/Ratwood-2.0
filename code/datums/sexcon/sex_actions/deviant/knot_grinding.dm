/datum/sex_action/knot_grinding
	name = "磨蹭肉结"
	check_same_tile = FALSE
	category = SEX_CATEGORY_PENETRATE
	subtle_supported = TRUE

/datum/sex_action/knot_grinding/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(user.sexcon.knotted_status == KNOTTED_AS_TOP)
		return target == user.sexcon.knotted_recipient
	if(user.sexcon.knotted_status == KNOTTED_AS_BTM)
		return user.sexcon.knotted_forced_by_bottom && target == user.sexcon.knotted_owner
	return FALSE

/datum/sex_action/knot_grinding/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!(user.sexcon.knotted_status == KNOTTED_AS_TOP || (user.sexcon.knotted_status == KNOTTED_AS_BTM && user.sexcon.knotted_forced_by_bottom)))
		return FALSE
	if(user.sexcon.knotted_status == KNOTTED_AS_TOP && target != user.sexcon.knotted_recipient)
		return FALSE
	if(user.sexcon.knotted_status == KNOTTED_AS_BTM && target != user.sexcon.knotted_owner)
		return FALSE
	if(!(user.sexcon.knotted_part_partner&(SEX_PART_CUNT|SEX_PART_ANUS|SEX_PART_JAWS|SEX_PART_SLIT_SHEATH))) // if we're not knotted anyone of these, abort
		return FALSE
	return TRUE

/datum/sex_action/knot_grinding/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	if(user.sexcon.knotted_status == KNOTTED_AS_BTM)
		user.visible_message(span_warning("[user]开始把[target]的肉结往[user.p_them()]自己体内更深处磨送……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user]在[target]体内揉蹭着[user.p_their()]的肉结……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/knot_grinding/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/is_bottom_grinding = user.sexcon.knotted_status == KNOTTED_AS_BTM
	var/mob/living/carbon/human/recipient = is_bottom_grinding ? user : target
	var/zone_text
	var/pleasure_target
	switch(user.sexcon.knotted_part_partner)
		if(SEX_PART_CUNT)
			pleasure_target = 2
			zone_text = "小穴"
		if(SEX_PART_ANUS)
			var/has_prostate = recipient.getorganslot(ORGAN_SLOT_PENIS)
			pleasure_target = has_prostate ? 4 : 1
			zone_text = "后庭"
		if(SEX_PART_JAWS)
			pleasure_target = 0
			zone_text = "嘴里"
			recipient.adjustOxyLoss(3) // we're choking the orally knotted recipient
		if(SEX_PART_SLIT_SHEATH)
			pleasure_target = 2
			zone_text = "鞘内"
		else
			pleasure_target = 2
			zone_text = "体内"
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle
	if(is_bottom_grinding)
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]用[user.p_their()]的[zone_text]磨蹭着[target]的肉结……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)]在[target]的[zone_text]里磨蹭着[user.p_their()]的肉结……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.make_sucking_noise()
		user.sexcon.do_thrust_animate(target, pixels = 2, time = 1.5)

	user.sexcon.perform_sex_action(user, 2, 0.5, TRUE)
	if(is_bottom_grinding)
		user.sexcon.perform_sex_action(target, 2, 0, TRUE)
	user.sexcon.handle_passive_ejaculation()

	if(pleasure_target)
		user.sexcon.perform_sex_action(recipient, pleasure_target, 0, TRUE)
	target.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/knot_grinding/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	if(user.sexcon.knotted_status == KNOTTED_AS_BTM)
		user.visible_message(span_warning("[user]停下了磨蹭[target]肉结的动作……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	else
		user.visible_message(span_warning("[user]停下了在[target]体内磨蹭[user.p_their()]肉结的动作……"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/knot_grinding/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
