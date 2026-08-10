/datum/sex_action/masturbate_other_vagina_orison
	name = "Rub their clit with godhand"
	check_same_tile = FALSE
	ranged_los_action = TRUE
	category = SEX_CATEGORY_HANDS
	target_sex_part = SEX_PART_CUNT
	subtle_supported = TRUE

/datum/sex_action/masturbate_other_vagina_orison/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/orison))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_other_vagina_orison/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, target, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/orison))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_other_vagina_orison/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] offers a quiet orison, directing the energies toward [target]'s clit..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_other_vagina_orison/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	var/list/data = modular_get_orison_patron_data(user.patron?.type)
	var/message_suffix = data["message"]
	modular_try_show_orison_indulgence_notice(target, user, data)
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = target.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] traces blessed circles over [target]'s clit with sanctified disembodied fingers... [message_suffix]"), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()
	if(data["jingle"])
		playsound(user, SFX_JINGLE_BELLS, 30, TRUE, -2, ignore_walls = FALSE)

	var/skill_level = max(user.get_skill_level(/datum/skill/magic/holy), 1)
	user.sexcon.perform_sex_action(target, (data["arousal_mult"] * skill_level), data["pain"], TRUE)
	target.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = target.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_other_vagina_orison/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] finishes the prayer and eases off [target]'s clit."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate_other_vagina_orison/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
