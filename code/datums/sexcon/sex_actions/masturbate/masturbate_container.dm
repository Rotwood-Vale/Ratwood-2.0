/datum/sex_action/masturbate_container
	name = "对着容器自慰"
	category = SEX_CATEGORY_HANDS
	/// Self-action: signal resolver reads user_sex_part as receiver_part. Set so modular_emit_received_sex_action_signal fires correctly.
	user_sex_part = SEX_PART_COCK | SEX_PART_CUNT
	/// Bespoke per-genital chastity checks live in shows_on_menu/can_perform — skip the generic validate signal to avoid double-blocking.
	intimate_check_flags = SEX_ACTION_INTIMATE_CHECK_NONE

/datum/sex_action/masturbate_container/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user != target)
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS) && !user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(user.getorganslot(ORGAN_SLOT_PENIS) && !user.sexcon.has_chastity_penis())
		return TRUE
	if(user.getorganslot(ORGAN_SLOT_VAGINA) && !user.sexcon.has_chastity_vagina())
		return TRUE
	return FALSE

/datum/sex_action/masturbate_container/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/holding = user.get_active_held_item()
	if(istype(holding, /obj/item/reagent_containers/glass) != TRUE)
		return FALSE
	if(user != target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_PENIS) && !user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(user.getorganslot(ORGAN_SLOT_PENIS) && !user.sexcon.has_chastity_penis())
		return TRUE
	if(user.getorganslot(ORGAN_SLOT_VAGINA) && !user.sexcon.has_chastity_vagina())
		return TRUE
	return FALSE

/datum/sex_action/masturbate_container/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始对着[user.get_active_held_item()]自慰……"))

/datum/sex_action/masturbate_container/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/container_name = user.get_active_held_item()
	if(!container_name)
		container_name = "容器"
	var/chosen_verb = pick(list("对着\the [container_name]取悦着自己", "隔着\the [container_name]色情地揉弄着自己", "对着\the [container_name]自慰"))

	user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] [chosen_verb]."))

	user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(user, 2, 0, TRUE)

	user.sexcon.handle_container_ejaculation()

/datum/sex_action/masturbate_container/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]停下了对着容器自慰的动作。"))

/datum/sex_action/masturbate_container/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user.sexcon.finished_check())
		return TRUE
	return FALSE
