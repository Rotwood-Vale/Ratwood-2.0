/datum/sex_action/masturbate_vagina_prestidigitation
	name = "Rub clit with magehand"
	category = SEX_CATEGORY_HANDS
	user_sex_part = SEX_PART_CUNT
	target_sex_part = SEX_PART_CUNT
	subtle_supported = TRUE

/datum/sex_action/masturbate_vagina_prestidigitation/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_vagina_prestidigitation/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(!user.mind?.has_spell(/obj/effect/proc_holder/spell/targeted/touch/prestidigitation))
		return FALSE
	return TRUE

/datum/sex_action/masturbate_vagina_prestidigitation/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] conjures arcyne hands toward [user.p_their()] cunt..."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))
	user.sexcon.show_progress = 0

/datum/sex_action/masturbate_vagina_prestidigitation/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/do_subtle = user.sexcon.do_subtle_action
	user.sexcon.show_progress = !do_subtle
	user.sexcon.suppress_moan = do_subtle

	user.sexcon_action_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective(is_stealth = do_subtle)] guides disembodied magical hands to tweak [user.p_their()] clit..."), vision_distance = (do_subtle ? 1 : DEFAULT_MESSAGE_RANGE))
	if(!do_subtle)
		user.sexcon.generic_sex_noise()

	var/skill_level = max(user.get_skill_level(/datum/skill/magic/arcane), 1)
	user.sexcon.perform_sex_action(user, (2.5 * skill_level), 3, TRUE)
	user.sexcon.handle_passive_ejaculation()

	user.sexcon.suppress_moan = FALSE

/datum/sex_action/masturbate_vagina_prestidigitation/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] lowers [user.p_their()] hands as the prestidigitation fades."), vision_distance = (user.sexcon.do_subtle_action ? 1 : DEFAULT_MESSAGE_RANGE))

/datum/sex_action/masturbate_vagina_prestidigitation/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
