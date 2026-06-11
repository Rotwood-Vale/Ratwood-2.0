/datum/sex_action/armpit_nuzzle
	name = "蹭弄对方腋下"
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/armpit_nuzzle/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/armpit_nuzzle/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_CHEST))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/armpit_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]的脑袋凑向了[target]的腋下……"))

/datum/sex_action/armpit_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]蹭弄着[target]的腋下……"))

/datum/sex_action/armpit_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了蹭弄[target]腋下的动作……"))
