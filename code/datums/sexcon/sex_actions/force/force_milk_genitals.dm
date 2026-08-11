/datum/sex_action/force_milk_genitals
	name = "Forcibly milk cock"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	/// Target's genitals are being stimulated; set so modular_emit_received_sex_action_signal can resolve receiver_part.
	target_sex_part = SEX_PART_COCK
	/// Bespoke per-genital chastity checks live in shows_on_menu/can_perform — skip the generic validate signal to avoid double-blocking.
	intimate_check_flags = SEX_ACTION_INTIMATE_CHECK_NONE

/datum/sex_action/force_milk_genitals/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!(. = ..()))
		return
	var/holding = user.get_active_held_item()
	if(!istype(holding, /obj/item/reagent_containers/glass))
		return FALSE
	return TRUE

/datum/sex_action/force_milk_genitals/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user] starts masturbating [target] over [user.get_active_held_item()]..."))

/datum/sex_action/force_milk_genitals/proc/get_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] jerks [target]'s cock into the [user.get_active_held_item()]...")

/datum/sex_action/force_milk_genitals/proc/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] stops jerking [target] into the container.")

/datum/sex_action/force_milk_genitals/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon_action_message(get_perform_message(user, target))
	user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)

	target.sexcon.handle_cock_milking(user)

/datum/sex_action/force_milk_genitals/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(get_finish_message(user, target))

/datum/sex_action/force_milk_genitals/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE

/datum/sex_action/force_milk_genitals/cunt
	name = "Forcibly milk cunt"
	target_sex_part = SEX_PART_CUNT

/datum/sex_action/force_milk_genitals/cunt/get_finish_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return span_warning("[user] stops fingering [target] over the container.")

/datum/sex_action/force_milk_genitals/cunt/get_perform_message(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()] fingers [target]'s cunt over the [user.get_active_held_item()]...")
