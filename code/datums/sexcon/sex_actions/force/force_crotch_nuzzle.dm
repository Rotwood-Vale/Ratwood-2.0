/datum/sex_action/force_crotch_nuzzle
	name = "Force them to nuzzle"
	require_grab = TRUE
	stamina_cost = 1.0
	target_sex_part = SEX_PART_JAWS

/datum/sex_action/force_crotch_nuzzle/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		if(isdullahan(user))
			var/datum/species/dullahan/dullahan = user.dna.species
			if(dullahan.headless && !user.is_holding(dullahan.my_head))
				return FALSE
		else
			return FALSE
	return TRUE

/datum/sex_action/force_crotch_nuzzle/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		if(isdullahan(user))
			var/datum/species/dullahan/dullahan = user.dna.species
			if(dullahan.headless && !user.is_holding(dullahan.my_head))
				return FALSE
		else
			return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/force_crotch_nuzzle/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] forces [target]'s head against [user.p_their()] crotch!"))

/datum/sex_action/force_crotch_nuzzle/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] forces [target] to nuzzle [user.p_their()] crotch."))
	target.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(user, 0.5, 0, TRUE)
	user.sexcon.handle_passive_ejaculation(target)

/datum/sex_action/force_crotch_nuzzle/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] pulls [target]'s head away from [user.p_their()] crotch."))

/datum/sex_action/force_crotch_nuzzle/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
