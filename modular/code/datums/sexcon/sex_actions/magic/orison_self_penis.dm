/datum/sex_action/masturbate_penis_orison
	name = "Jerk off with godhand"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_COCK
	target_sex_part = SEX_PART_COCK
	subtle_supported = TRUE

/datum/sex_action/masturbate_penis_orison/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/orison))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_penis_orison/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(!user.sexcon.can_use_penis())
		return FALSE
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/orison))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_penis_orison/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] offers a quiet orison while touching [user.p_their()] cock..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_penis_orison/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/list/data = modular_get_orison_patron_data(user.patron?.type)
	var/message_suffix = data["message"]
	modular_try_show_orison_indulgence_notice(user, user, data)
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] jerks [user.p_their()] cock with a prayer laced grip... [message_suffix]"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()
	if(data["jingle"])
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)

	var/skill_level = max(user.get_skill_level(/datum/skill/magic/holy), 1)
	user.sexcon.perform_sex_action(user, (data["arousal_mult"] * skill_level), data["pain"], TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_penis_orison/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] finishes the prayer and eases off [user.p_their()] cock."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate_penis_orison/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
