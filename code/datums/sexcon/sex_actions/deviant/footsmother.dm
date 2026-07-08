/datum/sex_action/footsmother//Blame Pots for this existing.
	name = "Smother them with feet"
	check_same_tile = FALSE

/datum/sex_action/footsmother/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	if(user.resting)
		return FALSE
	return TRUE

/datum/sex_action/footsmother/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(target, target, BODY_ZONE_PRECISE_MOUTH))
		return FALSE

	// Need bare feet ofc
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_L_FOOT || BODY_ZONE_PRECISE_R_FOOT))
		return FALSE

	// Need to stand up
	if(user.resting)
		return FALSE
		
	// Target can't stand up
	if(!target.resting)
		return FALSE
	return TRUE

/datum/sex_action/footsmother/get_start_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] puts [user.p_their()] feet on [target]'s face...")

/datum/sex_action/footsmother/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] pulls [user.p_their()] feet off [target]'s face...")

/datum/sex_action/footsmother/lock_sex_object(mob/living/carbon/human/user, mob/living/carbon/human/target)
	sex_locks |= new /datum/sex_session_lock(target, BODY_ZONE_PRECISE_MOUTH)

/datum/sex_action/footsmother/on_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	user.visible_message(sex_session.spanify_force("[user] [sex_session.get_generic_force_adjective()] smothers [target]'s face with [user.p_their()] feet..."))

/datum/sex_action/footsmother/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/datum/sex_session/sex_session = get_sex_session(user, target)
	playsound(user, 'sound/misc/mat/fingering.ogg', 30, TRUE, -2, ignore_walls = FALSE)

	if(istype(user.shoes, /obj/item/clothing/shoes/roguetown/jester))
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)

	sex_session.perform_sex_action(target, 2, 4, TRUE)
	sex_session.handle_passive_ejaculation(target)
