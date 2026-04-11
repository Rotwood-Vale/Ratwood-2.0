/datum/sex_action/tonguebath
	name = "Bathe with tongue"
	user_sex_part = SEX_PART_JAWS

/datum/sex_action/tonguebath/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	return TRUE

/datum/sex_action/tonguebath/can_perform(mob/living/user, mob/living/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN))
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_MOUTH))
		return FALSE
	return TRUE

/datum/sex_action/tonguebath/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] sticks [user.p_their()] tongue out, getting close to [target]..."))

/datum/sex_action/tonguebath/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] bathes [target]'s body with [user.p_their()] tongue..."))
	user.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)
	target.sexcon.handle_passive_ejaculation()

	var/datum/status_effect/facial/facial = target.has_status_effect(/datum/status_effect/facial)
	var/datum/status_effect/facial/creampie = target.has_status_effect(/datum/status_effect/facial/internal)
	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN && creampie)
		user.visible_message(user.sexcon.spanify_force("[user] cleans up the [target]'s crotch with [user.p_their()] tongue..."))
		playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
		creampie.clean_up(null, CLEAN_WEAK)
	if(user.zone_selected == BODY_ZONE_HEAD && facial)
		user.visible_message(user.sexcon.spanify_force("[user] cleans the [target]'s stained face with [user.p_their()] tongue..."))
		playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
		facial.clean_up(null, CLEAN_WEAK)

/datum/sex_action/tonguebath/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] stops bathing [target]'s body ..."))

/datum/sex_action/tonguebath/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
