/datum/sex_action/force_milk_genitals
	name = "强行榨取下体"
	check_same_tile = FALSE
	category = SEX_CATEGORY_HANDS
	/// Target's genitals are being stimulated; set so modular_emit_received_sex_action_signal can resolve receiver_part.
	target_sex_part = SEX_PART_COCK | SEX_PART_CUNT
	/// Bespoke per-genital chastity checks live in shows_on_menu/can_perform — skip the generic validate signal to avoid double-blocking.
	intimate_check_flags = SEX_ACTION_INTIMATE_CHECK_NONE

/datum/sex_action/force_milk_genitals/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(user == target)
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS) && !target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(target.getorganslot(ORGAN_SLOT_PENIS) && !target.sexcon.has_chastity_penis())
		return TRUE
	if(target.getorganslot(ORGAN_SLOT_VAGINA) && !target.sexcon.has_chastity_vagina())
		return TRUE
	return FALSE

/datum/sex_action/force_milk_genitals/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	var/holding = user.get_active_held_item()
	if(istype(holding, /obj/item/reagent_containers/glass) != TRUE)
		return FALSE
	if(user == target)
		return FALSE
	if(!check_location_accessible(user, user, BODY_ZONE_PRECISE_GROIN, TRUE))
		return FALSE
	if(!target.getorganslot(ORGAN_SLOT_PENIS) && !target.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(target.getorganslot(ORGAN_SLOT_PENIS) && !target.sexcon.has_chastity_penis())
		return TRUE
	if(target.getorganslot(ORGAN_SLOT_VAGINA) && !target.sexcon.has_chastity_vagina())
		return TRUE
	return FALSE

/datum/sex_action/force_milk_genitals/on_start(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.visible_message(span_warning("[user]开始隔着[user.get_active_held_item()]撸弄[target]的下体……"))

/datum/sex_action/force_milk_genitals/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.getorganslot(ORGAN_SLOT_PENIS))
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]隔着[user.get_active_held_item()]撸弄[target]的肉棒……"))
	else
		user.visible_message(user.sexcon.spanify_force("[user] [user.sexcon.get_generic_force_adjective()]隔着[user.get_active_held_item()]抚弄[target]的阴部……"))
	user.sexcon.generic_sex_noise()

	user.sexcon.perform_sex_action(target, 2, 4, TRUE)

	target.sexcon.handle_cock_milking(user)

/datum/sex_action/force_milk_genitals/on_finish(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.getorganslot(ORGAN_SLOT_PENIS))
		user.visible_message(span_warning("[user]停下了隔着容器撸弄[target]肉棒的动作。"))
	else
		user.visible_message(span_warning("[user]停下了隔着容器抚弄[target]阴部的动作。"))

/datum/sex_action/force_milk_genitals/is_finished(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(target.sexcon.finished_check())
		return TRUE
	return FALSE
