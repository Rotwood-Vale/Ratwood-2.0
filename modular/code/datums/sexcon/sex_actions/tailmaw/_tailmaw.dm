/datum/sex_action/tailmaw
	abstract_type = /datum/sex_action/tailmaw
	var/requires_extreme = FALSE

/datum/sex_action/tailmaw/shows_on_menu(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!..())
		return FALSE
	if(requires_extreme && !both_extreme_erp(user, target))
		return FALSE
	if(target_needs_chastity && (!user.sexcon.chastity_content_enabled_for(user) || !target.sexcon.chastity_content_enabled_for(target)))
		return FALSE
	return TRUE

/datum/sex_action/tailmaw/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return ..() && shows_on_menu(user, target)

/datum/sex_action/tailmaw/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	user.sexcon.do_thrust_animate(target)

/// Wounds belong to the completed action, never to cleanup after an interrupted do_after. This is mostly to prevent combat tailmawing.
/datum/sex_action/tailmaw/pear
	abstract_type = /datum/sex_action/tailmaw/pear
	do_time = 30 SECONDS
	continous = FALSE
	requires_extreme = TRUE
	var/wound_zone = BODY_ZONE_CHEST
	var/wound_type

/datum/sex_action/tailmaw/pear/can_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return ..() && target.get_bodypart(wound_zone)

/datum/sex_action/tailmaw/pear/on_perform(mob/living/carbon/human/user, mob/living/carbon/human/target)
	if(!can_perform(user, target))
		return FALSE
	var/obj/item/bodypart/affected_part = target.get_bodypart(wound_zone)
	if(!affected_part?.add_wound(wound_type))
		return FALSE
	..()
	// Attempt the scream before the normal pain reaction consumes the moan cooldown.
	user.sexcon.try_do_pain_scream(target, 10)
	playsound(target, 'sound/combat/wound_tear.ogg', 60, TRUE, ignore_walls = FALSE)
	user.sexcon.perform_sex_action(target, 0, 10, TRUE)
	user.sexcon.modular_emit_received_sex_action_signal(user, 0, 0, TRUE)
	return TRUE

/datum/sex_action/tailmaw/proc/handle_tailmaw_ejaculation(mob/living/carbon/human/user, mob/living/carbon/human/target, mob/living/carbon/human/donor, mob/living/carbon/human/receiver)
	if(!donor.sexcon.check_active_ejaculation() || !donor.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	var/obj/item/organ/tail/manticore/tail = get_manticore_tail(receiver)
	if(!tail)
		return FALSE
	var/bursts = donor.sexcon.get_load_bursts()
	for(var/i in 1 to bursts)
		if(QDELETED(tail) || get_manticore_tail(receiver) != tail || !can_perform(user, target) || !donor.getorganslot(ORGAN_SLOT_PENIS))
			break
		donor.sexcon.cum_into(splashed_user = receiver, orifice = SEX_PART_TAIL_MAW, skip_knot_try = TRUE, consume_charge = i == 1)
		if(i < bursts)
			sleep(1 SECONDS)
	return TRUE

/datum/sex_action/tailmaw/proc/handle_tailmaw_oral_climax(mob/living/carbon/human/owner, mob/living/carbon/human/receiver)
	if(get_manticore_tail(owner) && owner.sexcon.check_active_ejaculation())
		owner.sexcon.cum_into(oral = TRUE, splashed_user = receiver, skip_knot_try = TRUE, source_part = SEX_PART_TAIL_MAW)

/proc/both_extreme_erp(mob/living/carbon/human/user, mob/living/carbon/human/target)
	return user?.client?.prefs?.extreme_erp && target?.client?.prefs?.extreme_erp

/proc/get_extreme_content_excluded_mobs(atom/source)
	var/list/excluded = list()
	for(var/mob/M in get_hearers_in_view(DEFAULT_MESSAGE_RANGE, source))
		if(M == source || !M.client?.prefs)
			continue
		if(!M.client.prefs.extreme_erp)
			excluded += M
	return excluded
