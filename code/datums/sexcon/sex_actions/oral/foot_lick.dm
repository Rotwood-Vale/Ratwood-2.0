/datum/sex_action/foot_lick
	name = "舔对方的脚"
	check_same_tile = FALSE
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/foot_lick/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/foot_lick/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_R_FOOT))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_L_FOOT))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/foot_lick/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始舔[target]的脚了……"))

/datum/sex_action/foot_lick/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]舔弄着[target]的双脚……"))
	user.sexcon.make_sucking_noise()

/datum/sex_action/foot_lick/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了舔[target]双脚的动作……"))
