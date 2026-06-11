/datum/sex_action/tonguebath
	name = "用舌头清洗"
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
	user.visible_message(span_warning("[user]吐出了[user.p_their()]的舌头，慢慢凑近[target]……"))

/datum/sex_action/tonguebath/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]用[user.p_their()]的舌头清洗着[target]的身体……"))
	user.sexcon.make_sucking_noise()

	user.sexcon.perform_sex_action(target, 0.5, 0, TRUE)
	target.sexcon.handle_passive_ejaculation()

	var/datum/status_effect/facial/facial = target.has_status_effect(/datum/status_effect/facial)
	var/datum/status_effect/facial/creampie = target.has_status_effect(/datum/status_effect/facial/internal)
	var/datum/status_effect/facial/external/external = target.has_status_effect(/datum/status_effect/facial/external)
	if(user.zone_selected == BODY_ZONE_PRECISE_GROIN && creampie)
		user.visible_message(user.sexcon.spanify_force("[user]用[user.p_their()]的舌头舔净了[target]的胯间……"))
		playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
		creampie.clean_up(null, CLEAN_WEAK)
		if(user.reagents)
			user.reagents.add_reagent(/datum/reagent/erpjuice/cum, 3)
	if(user.zone_selected == BODY_ZONE_HEAD && facial)
		user.visible_message(user.sexcon.spanify_force("[user]用[user.p_their()]的舌头舔净了[target]被弄脏的脸……"))
		playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
		facial.clean_up(null, CLEAN_WEAK)
		if(user.reagents)
			user.reagents.add_reagent(/datum/reagent/erpjuice/cum, 3)
	if(user.zone_selected == BODY_ZONE_CHEST && external)
		user.visible_message(user.sexcon.spanify_force("[user]用[user.p_their()]的舌头把[target]的身体舔得干干净净……"))
		playsound(user, pick('sound/misc/mat/mouthend (1).ogg','sound/misc/mat/mouthend (2).ogg'), 100, FALSE, ignore_walls = FALSE)
		external.clean_up(null, CLEAN_WEAK)
		if(user.reagents)
			user.reagents.add_reagent(/datum/reagent/erpjuice/cum, 3)

/datum/sex_action/tonguebath/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了用舌头清洗[target]身体的动作……"))

/datum/sex_action/tonguebath/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
