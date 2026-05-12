/// Plays a chastity movement sound (jingle, rattle, etc.) when a sex action involves a wearer.
/// Checks both user and action_target for a chastity device — whichever has one produces the sound.
/// Probability scales with action speed. Volume scales with sex force tier (MID→HIGH→EXTREME).
/// Returns TRUE always (used as a callback hook, not a gate).
/datum/sex_controller/proc/modular_chastitycourse_noise(mob/living/carbon/human/action_target)
	if(!user || QDELETED(user) || !istype(user))
		return TRUE
	if(force < SEX_FORCE_MID)
		return TRUE

	var/obj/item/chastity/chastity_item = null
	var/mob/living/carbon/human/sound_target = action_target

	if(action_target?.chastity_device)
		chastity_item = action_target.chastity_device
	else if(user?.chastity_device)
		chastity_item = user.chastity_device
		sound_target = user

	if(!chastity_item)
		return TRUE

	if(!prob(20 + (speed * 10)))
		return TRUE

	var/chastity_volume = 25
	switch(force)
		if(SEX_FORCE_MID)
			chastity_volume = 30
		if(SEX_FORCE_HIGH)
			chastity_volume = 40
		if(SEX_FORCE_EXTREME)
			chastity_volume = 50

	playsound(sound_target, chastity_item.chastity_move_sound ? chastity_item.chastity_move_sound : SFX_JINGLE_BELLS, chastity_volume, TRUE, -2, ignore_walls = FALSE)
	return TRUE

/// Returns TRUE if the sexcon's user is wearing spiked chastity AND has the masochist flaw.
/// Used to gate masochist-specific flavor banks and pain moan overrides.
/datum/sex_controller/proc/modular_is_masochist_in_spiked_chastity()
	if(!HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
		return FALSE
	if(!user.has_flaw(/datum/charflaw/addiction/masochist))
		return FALSE
	return TRUE

/// Returns TRUE if chastity content (flavor text, noise, arousal messages) is enabled for mob H.
/// Offline/NPC mobs (no client/prefs) default to TRUE so automated procs don't silently break.
/datum/sex_controller/proc/modular_chastity_content_enabled_for(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(!H.client?.prefs)
		return TRUE
	return !!H.client.prefs.chastenable

/// Returns TRUE if chastity content is enabled for BOTH user and target in this sex controller.
/// Short-circuits on first failure — call before any chastity flavor dispatch that involves both parties.
/datum/sex_controller/proc/modular_chastity_content_enabled_for_pair()
	if(!modular_chastity_content_enabled_for(user))
		return FALSE
	if(target && target != user && !modular_chastity_content_enabled_for(target))
		return FALSE
	return TRUE

/// Cursed device override for has_chastity_penis().
/// If the user's device is in cursed mode, evaluates cursed_front_mode directly (mode 1 or 3 = penis exposed).
/// Falls through to ..() (trait check) for standard devices.
/datum/sex_controller/has_chastity_penis()
	var/obj/item/chastity/device = user?.chastity_device
	if(istype(device) && device.chastity_cursed)
		if(!user.getorganslot(ORGAN_SLOT_PENIS))
			return FALSE
		// Cursed mode 1 and 3 expose penis access.
		return !(device.cursed_front_mode == 1 || device.cursed_front_mode == 3)
	return ..()

/// Cursed device override for has_chastity_vagina().
/// If the user's device is in cursed mode, evaluates cursed_front_mode directly (mode 2 or 3 = vagina exposed).
/// Falls through to ..() (trait check) for standard devices.
/datum/sex_controller/has_chastity_vagina()
	var/obj/item/chastity/device = user?.chastity_device
	if(istype(device) && device.chastity_cursed)
		if(!user.getorganslot(ORGAN_SLOT_VAGINA))
			return FALSE
		// Cursed mode 2 and 3 expose vagina access.
		return !(device.cursed_front_mode == 2 || device.cursed_front_mode == 3)
	return ..()

/// Flat-cage override for has_chastity_flat().
/// Returns TRUE only when the equipped device is /obj/item/chastity/chastity_cage/flat.
/// Falls through to ..() (always FALSE) for all other device types.
/datum/sex_controller/has_chastity_flat()
	var/obj/item/chastity/device = user?.chastity_device
	if(!istype(device, /obj/item/chastity/chastity_cage/flat))
		return ..()
	return TRUE

/// Cursed device override for has_chastity_anal().
/// If the user's device is in cursed mode, evaluates cursed_anal_open directly.
/// Falls through to ..() (trait check) for standard devices.
/datum/sex_controller/has_chastity_anal()
	var/obj/item/chastity/device = user?.chastity_device
	if(istype(device) && device.chastity_cursed)
		return !device.cursed_anal_open
	return ..()


/// Returns TRUE if the user can use their penis for sex actions.
/// Requires: no TRAIT_LIMPDICK, no chastity cage blocking, a present and functional penis organ.
/datum/sex_controller/proc/modular_can_use_penis()
	if(HAS_TRAIT(user, TRAIT_LIMPDICK))
		return FALSE
	if(has_chastity_penis())
		return FALSE
	var/obj/item/organ/penis/penor = user.getorganslot(ORGAN_SLOT_PENIS)
	if(!penor)
		return FALSE
	if(!penor.functional)
		return FALSE
	return TRUE

/// Returns TRUE if the user can use their vagina for sex actions.
/// Requires: no chastity belt blocking, a present vagina organ.
/datum/sex_controller/proc/modular_can_use_vagina()
	if(has_chastity_vagina())
		return FALSE
	if(!user.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	return TRUE

/// Attempts to produce a chastity-specific ejaculation spill message when the user climaxes into a device.
/// Fires on a 50% chance if the user has any front or anal chastity blocking.
/// Emits a visible_message (range suppressed if suppress_moan is set) and calls cum_onto(user).
/// Returns TRUE if the spill happened, FALSE otherwise — callers use this to skip their own generic climax message.
/datum/sex_controller/proc/modular_try_handle_chastity_ejaculation()
	if(!(has_chastity_cage() || has_chastity_anal()))
		return FALSE
	if(!prob(50))
		return FALSE

	var/self_mess_msg = "[user] spills over [user.p_their()] own chastity!"
	if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
		self_mess_msg = "[user] spurts over [user.p_their()] own spiked chastity!"

	user.visible_message(span_love(self_mess_msg), vision_distance = (suppress_moan ? 1 : DEFAULT_MESSAGE_RANGE))
	cum_onto(user)
	return TRUE

/// Returns the appropriate climax message string for the user, accounting for chastity state.
/// Overrides default_msg if the user has any front/anal chastity device, with a stronger override for spiked variants.
/// Falls back to default_msg if no chastity is active (pass-through for non-chastity callers).
/datum/sex_controller/proc/modular_get_chastity_climax_message(default_msg)
	var/climax_msg = default_msg
	if(has_chastity_cage() || has_chastity_anal())
		climax_msg = "[user] climaxes and makes a mess in their chastity device!"
	if(HAS_TRAIT(user, TRAIT_CHASTITY_SPIKED))
		climax_msg = "[user] climaxes and makes a messy release in their spiked chastity!"
	return climax_msg

/// Scales arousal and pain amounts based on whether action_target is wearing spiked chastity.
/// Spiked chastity reduces pleasure (×0.75) and amplifies pain (×1.25) — call before dispatching to intimate_reaction.
/// Returns a two-element list: list(arousal_amt, pain_amt).
/datum/sex_controller/proc/modular_adjust_action_for_target_chastity(mob/living/carbon/human/action_target, arousal_amt, pain_amt)
	if(HAS_TRAIT(action_target, TRAIT_CHASTITY_SPIKED))
		arousal_amt *= 0.75
		pain_amt *= 1.25
	return list(arousal_amt, pain_amt)

/**
 * Fires COMSIG_CARBON_SEX_ACTION_RECEIVED on action_target with effective (multiplied) arousal and pain values.
 *
 * This is the primary dispatch point for intimate_reaction.dm — all chastityplay sex actions call this
 * to deliver flavor text, arousal ticks, and pain to the receiving mob.
 *
 * Multiplier pipeline applied before dispatch:
 *   - arousal × get_force_pleasure_multiplier(force, giving)
 *   - pain    × get_force_pain_multiplier(force) × get_speed_pain_multiplier(speed)
 *   - Dead targets receive zero effective arousal and pain (no feedback to corpses).
 *
 * action / receiver_part resolution:
 *   1. Tries current_action on the calling sexcon first (action_target == user or target).
 *   2. Falls back to receiver's own current_action if step 1 finds nothing.
 *   Returns FALSE without firing if neither resolves a valid action+part pair.
 *
 * Returns TRUE if the signal was fired, FALSE if no valid receiver context was found.
 */
/datum/sex_controller/proc/modular_emit_received_sex_action_signal(mob/living/carbon/human/action_target, arousal_amt, pain_amt, giving)
	if(!action_target || QDELETED(action_target))
		return FALSE

	var/datum/sex_controller/receiver_sexcon = action_target.sexcon
	if(!receiver_sexcon)
		return FALSE

	var/datum/sex_action/action = null
	var/receiver_part = SEX_PART_NULL

	if(current_action)
		action = SEX_ACTION(current_action)
		if(action)
			if(action_target == user)
				receiver_part = action.user_sex_part
			else if(action_target == target)
				receiver_part = action.target_sex_part

	if(!action || !receiver_part)
		if(receiver_sexcon.current_action)
			action = SEX_ACTION(receiver_sexcon.current_action)
			if(action)
				if(action_target == receiver_sexcon.user)
					receiver_part = action.user_sex_part
				else if(action_target == receiver_sexcon.target)
					receiver_part = action.target_sex_part

	if(!action || !receiver_part)
		return FALSE

	var/effective_arousal = arousal_amt
	var/effective_pain = pain_amt
	effective_arousal *= receiver_sexcon.get_force_pleasure_multiplier(force, giving)
	effective_pain *= receiver_sexcon.get_force_pain_multiplier(force)
	effective_pain *= receiver_sexcon.get_speed_pain_multiplier(speed)
	if(action_target.stat == DEAD)
		effective_arousal = 0
		effective_pain = 0

	SEND_SIGNAL(action_target, COMSIG_CARBON_SEX_ACTION_RECEIVED, user, src, action, receiver_part, giving, effective_arousal, effective_pain, force, speed)
	return TRUE

/// Returns TRUE if at least one party (user or action_target) has an active chastity device.
/// Used by sex action procs to decide whether to call modular_chastitycourse_noise()
/// rather than unconditionally playing a metal-rattle sound for non-chastity participants.
/datum/sex_controller/proc/modular_should_play_chastitycourse_noise(mob/living/carbon/human/action_target)
	if(user?.chastity_device || action_target?.chastity_device)
		return TRUE
	return FALSE

/// Returns 2 if the source's active sex action involves a double-penetration event, otherwise 1.
/// Shared logic used by both cursed collar and cursed chastity tally systems.
/proc/tally_increment_for_ejaculation_source(mob/living/carbon/human/source)
	if(!source?.sexcon)
		return 1
	if(!source.sexcon.double_penis_type())
		return 1

	var/action_type = source.sexcon.current_action
	if(ispath(action_type, /datum/sex_action/anal_sex/double))
		return 2
	if(ispath(action_type, /datum/sex_action/vaginal_sex/double))
		return 2
	if(ispath(action_type, /datum/sex_action/slit_sex/double))
		return 2
	if(ispath(action_type, /datum/sex_action/throat_sex/double))
		return 2
	if(ispath(action_type, /datum/sex_action/double_penetration_sex))
		return 2

	return 1

/// Records a non-self received ejaculation event on a receiver's cursed control item (collar or chastity), if present.
/datum/sex_controller/proc/modular_record_collar_receive_event(mob/living/carbon/human/receiver, mob/living/carbon/human/source)
	if(!receiver || !source)
		return FALSE
	if(receiver == source)
		return FALSE

	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = receiver.get_item_by_slot(SLOT_NECK)
	var/obj/item/chastity/chastity = receiver.chastity_device
	if(istype(collar) && istype(chastity) && chastity.chastity_cursed)
		log_world("modular_record_collar_receive_event: [receiver] has both cursed collar and cursed chastity — invariant violated, skipping.")
		return FALSE

	if(istype(collar))
		return collar.record_nonself_ejaculation(source, receiver)

	if(!istype(chastity) || !chastity.chastity_cursed)
		return FALSE

	return chastity.record_nonself_ejaculation(source, receiver)
