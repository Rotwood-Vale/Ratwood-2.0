/datum/sex_action/masturbate_penis_over
	name = "朝着对方自慰"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_COCK

/datum/sex_action/masturbate_penis_over/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_penis_over/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.sexcon.can_use_penis())
		return FALSE
	if(!user.Adjacent(target))
		return FALSE
	if(!user.sexcon.Adjacent_Or_Closet(target))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_penis_over/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始朝着[target]自慰……"))

/datum/sex_action/masturbate_penis_over/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/chosen_verb = pick(list("撸弄着[user.p_their()]的肉棒", "套弄着[user.p_their()]的肉棒", "自慰着", "自我撸弄着"))
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]朝着[target][chosen_verb]"))
	user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(user, 2, 4, TRUE)

	if(user.sexcon.check_active_ejaculation())
		var/cum_on_face = check_zone(user.zone_selected) == BODY_ZONE_HEAD
		if(cum_on_face)
			user.visible_message(span_love("[user]射在了[target]脸上！"))
		else
			user.visible_message(span_love("[user]射在了[target]身上！"))
		user.sexcon.cum_onto(target, cum_on_face = cum_on_face)

/datum/sex_action/masturbate_penis_over/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了朝着[target]自慰的动作。"))

/datum/sex_action/masturbate_penis_over/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
