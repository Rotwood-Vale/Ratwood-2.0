/datum/sex_action/force_foot_lick
	name = "强迫对方舔脚"
	check_same_tile = FALSE
	require_grab = TRUE
	stamina_cost = 1.0
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/force_foot_lick/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		if(isdullahan(user))
			var/datum/species/dullahan/dullahan = user.dna.species
			if(dullahan.headless && !user.is_holding(dullahan.my_head))
				return FALSE
		else
			return FALSE
	return TRUE

/datum/sex_action/force_foot_lick/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		if(isdullahan(user))
			var/datum/species/dullahan/dullahan = user.dna.species
			if(dullahan.headless && !user.is_holding(dullahan.my_head))
				return FALSE
		else
			return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_L_FOOT) && !check_location_accessible(user, user, BODY_ZONE_PRECISE_R_FOOT))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/force_foot_lick/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]双脚狠狠顶到了[target]头上！"))

/datum/sex_action/force_foot_lick/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]强迫[target]舔[user.p_their()]双脚。"))
	target.sexcon.make_sucking_noise()

/datum/sex_action/force_foot_lick/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]把[user.p_their()]双脚从[target]头边挪开了。"))
