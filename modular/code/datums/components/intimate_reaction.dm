/**
 * Reusable component framework for intimate accessory reactions (chastity devices, piercings, insertable toys, etc.).
 *
 * HOW TO USE — QUICK PATHS:
 *
 * 1. Adding strings to an existing accessory:
 *    Just add entries to the relevant JSON bank under modular/code/game/objects/items/lewd/chastity/strings/.
 *    No DM changes needed.
 *
 * 2. New accessory with sex-action reactions only (no movement):
 *    - Make a new subtype of /datum/component/intimate_reaction.
 *    - Override try_handle_wearer_sex_action_received() with your logic.
 *    - Override is_valid_wearer_source() — call ..() first, then add any item-specific check (e.g., source.my_item == parent).
 *    - Call bind_to_wearer(H) when the item is equipped; call unbind_from_wearer(H) when it is removed or destroyed.
 *    - Use pick_string_bank(filename, key) to pull strings. Pass a strings_path argument if your JSONs live outside the chastity directory.
 *
 * 3. New accessory with movement reactions (bell piercing, vibrating plug, etc.):
 *    - Follow step 2, then also call register_movement_reaction(H) inside your bind_to_wearer override (after ..()).
 *    - Call unregister_movement_reaction(H) inside unbind_from_wearer (before ..()).
 *    - Override try_handle_wearer_moved() with your step-counter / message logic.
 *      last_movement_message_time and movement_message_cooldown are available on the base for cooldown gating.
 *
 * 4. New accessory that can stack with other instances (piercings, multiple toys simultaneously):
 *    - Override dupe_mode to COMPONENT_DUPE_ALLOW_ALL on your subtype — the base defaults to COMPONENT_DUPE_UNIQUE
 *      which will silently discard the second instance otherwise.
 *
 * 5. Coverage-aware flavor text (reaction differs based on armor over the body part):
 *    - Call get_cover_tier_for_zone(source, BODY_ZONE_PRECISE_GROIN) (or whichever zone applies) to get the
 *      covering armor tier (null = uncovered, ARMOR_CLASS_NONE through ARMOR_CLASS_HEAVY).
 *    - Route to the appropriate JSON bank based on the returned tier.
 *
 * 6. Blocking sex actions while an accessory is worn (plug blocking anal penetration, etc.):
 *    - Use /datum/component/intimate_action_guard instead — see the /chastity subtype below for the pattern.
 *
 * GENERAL GUIDELINES:
 *    - Keep reaction logic lightweight: prefer cooldowns, early returns, and external string banks over inline
 *      text or repeated visible_message spam. BYOND will thank you.
 *    - If this stops working yell at Yuckuza on Discord.
 */
/datum/component/intimate_reaction
	/// Override to COMPONENT_DUPE_ALLOW_ALL for accessories that can coexist in multiples on the same wearer
	/// (e.g., a nipple piercing and a tongue piercing are different items but the same component subtype).
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/human/wearer = null
	/// Movement cooldown state shared across all subtypes. Subtypes set movement_message_cooldown in their
	/// vars block to tune the frequency; last_movement_message_time is updated inside try_handle_wearer_moved.
	var/last_movement_message_time = 0
	var/movement_message_cooldown = 10 SECONDS

/// Initializes the component.
/datum/component/intimate_reaction/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

/// Destroys the component.
/datum/component/intimate_reaction/Destroy(force, silent)
	if(wearer)
		unbind_from_wearer(wearer)
	return ..()

/// Binds the component to the wearer mob, registering the sex-action signal.
/// Returns TRUE on success. Subtypes call ..() and then register any additional signals they need.
/datum/component/intimate_reaction/proc/bind_to_wearer(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(wearer == H)
		return TRUE
	if(wearer)
		unbind_from_wearer(wearer)
	wearer = H
	RegisterSignal(H, COMSIG_CARBON_SEX_ACTION_RECEIVED, PROC_REF(on_wearer_sex_action_received))
	return TRUE

/datum/component/intimate_reaction/proc/unbind_from_wearer(mob/living/carbon/human/H)
	if(!H)
		H = wearer
	if(!H)
		return FALSE
	UnregisterSignal(H, COMSIG_CARBON_SEX_ACTION_RECEIVED)
	if(H == wearer)
		wearer = null
	return TRUE

/// Raw signal handler for sex-action events. Validates wearer identity then defers to try_handle_wearer_sex_action_received.
/datum/component/intimate_reaction/proc/on_wearer_sex_action_received(datum/source, mob/living/carbon/human/acting_mob, datum/sex_controller/acting_sexcon, datum/sex_action/action, receiver_part, giving, arousal_amt, pain_amt, applied_force, applied_speed)
	SIGNAL_HANDLER
	if(source != wearer)
		return FALSE
	return try_handle_wearer_sex_action_received(source, acting_mob, acting_sexcon, action, receiver_part, giving, arousal_amt, pain_amt, applied_force, applied_speed)

/// Stub. Override in subtypes to implement sex-action reactions (arousal messages, pain strings, flavor text, etc.).
/datum/component/intimate_reaction/proc/try_handle_wearer_sex_action_received(mob/living/carbon/human/source, mob/living/carbon/human/acting_mob, datum/sex_controller/acting_sexcon, datum/sex_action/action, receiver_part, giving, arousal_amt, pain_amt, applied_force, applied_speed)
	return FALSE

/// Registers COMSIG_MOVABLE_MOVED on H, routing it through on_wearer_moved → try_handle_wearer_moved.
/// Call from bind_to_wearer in any subtype that needs movement-based reactions (jingle emotes, vibration triggers, etc.).
/datum/component/intimate_reaction/proc/register_movement_reaction(mob/living/carbon/human/H)
	RegisterSignal(H, COMSIG_MOVABLE_MOVED, PROC_REF(on_wearer_moved))

/// Unregisters COMSIG_MOVABLE_MOVED from H. Always pair this with register_movement_reaction in unbind_from_wearer.
/datum/component/intimate_reaction/proc/unregister_movement_reaction(mob/living/carbon/human/H)
	UnregisterSignal(H, COMSIG_MOVABLE_MOVED)

/// Raw signal handler for movement events. Validates wearer identity then defers to try_handle_wearer_moved.
/datum/component/intimate_reaction/proc/on_wearer_moved(datum/source)
	SIGNAL_HANDLER
	if(source != wearer)
		return FALSE
	return try_handle_wearer_moved(source)

/// Stub. Override in subtypes to implement movement-based reactions (step counters, jingle emotes, etc.).
/// last_movement_message_time and movement_message_cooldown on the base class are available for cooldown gating.
/datum/component/intimate_reaction/proc/try_handle_wearer_moved(mob/living/carbon/human/source)
	return FALSE

/// Returns TRUE if source is non-null, not QDELeted, and matches the currently bound wearer.
/// Subtypes override to add item-specific checks (e.g., source.chastity_device == parent for the chastity subtype).
/datum/component/intimate_reaction/proc/is_valid_wearer_source(mob/living/carbon/human/source)
	return source && !QDELETED(source) && source == wearer

/**
 * Picks a random string from an external JSON string bank.
 *
 * Arguments:
 *  - filename: JSON file name within strings_path (e.g., "chastity_movement_messages.json").
 *  - string_key: key to look up within the JSON object.
 *  - strings_path: directory containing the JSON file. Defaults to the chastity strings directory.
 *    Pass a different path when implementing non-chastity accessories that use their own JSON banks.
 *
 * Named pick_string_bank to avoid collision with the global pick_chastity_string() preprocessor macro.
 */
/datum/component/intimate_reaction/proc/pick_string_bank(filename, string_key, strings_path = "modular/code/game/objects/items/lewd/chastity/strings")
	if(!string_key)
		return null
	var/list/string_bank = strings(filename, string_key, strings_path)
	if(!islist(string_bank) || !string_bank.len)
		return null
	return pick(string_bank)

/**
 * Returns the highest armor_class of equipped items covering the given body zone that have surgery_cover = TRUE.
 *
 * Mirrors get_location_accessible() logic: only real clothing layers count; tattoos and paint
 * (surgery_cover = FALSE) are ignored. Use this to gate or grade flavor reactions based on whether
 * a body part is exposed or hidden under armor — e.g., BODY_ZONE_PRECISE_GROIN for chastity devices,
 * BODY_ZONE_PRECISE_CHEST for nipple piercings.
 *
 * Returns:
 *  - null               → zone is uncovered; the body part and any device on it are fully visible.
 *  - ARMOR_CLASS_NONE   → covered by plain clothing with no declared armor tier.
 *  - ARMOR_CLASS_LIGHT  → covered by light armor (leather, gambeson, padded cloth, etc.).
 *  - ARMOR_CLASS_MEDIUM → covered by medium armor (chainmail, cuirass, etc.).
 *  - ARMOR_CLASS_HEAVY  → covered by full plate.
 */
/datum/component/intimate_reaction/proc/get_cover_tier_for_zone(mob/living/carbon/human/source, body_zone)
	var/highest_tier = -1 // -1 = nothing covering yet; null return means uncovered
	for(var/obj/item/equipped_item in source.get_equipped_items(include_pockets = FALSE, include_beltslots = FALSE))
		if(!zone2covered(body_zone, equipped_item.body_parts_covered_dynamic))
			continue
		if(!equipped_item.surgery_cover)
			continue // tattoos and similar soft overlays don't count as real cover
		if(!isclothing(equipped_item))
			continue
		var/obj/item/clothing/C = equipped_item
		highest_tier = max(highest_tier, C.armor_class)
	return highest_tier >= 0 ? highest_tier : null

/// Component for blocking or hiding sex actions based on worn intimate accessories.
/datum/component/intimate_action_guard
	dupe_mode = COMPONENT_DUPE_UNIQUE
	var/mob/living/carbon/human/wearer = null

/// Initializes the component.
/datum/component/intimate_action_guard/Initialize()
	if(!isitem(parent))
		return COMPONENT_INCOMPATIBLE

/// Destroys the component.
/datum/component/intimate_action_guard/Destroy(force, silent)
	if(wearer)
		unbind_from_wearer(wearer)
	return ..()

/// Binds the action blocker, hides sex action based on context
/datum/component/intimate_action_guard/proc/bind_to_wearer(mob/living/carbon/human/H)
	if(!H)
		return FALSE
	if(wearer == H)
		return TRUE
	if(wearer)
		unbind_from_wearer(wearer)
	wearer = H
	RegisterSignal(H, COMSIG_CARBON_SEX_ACTION_VALIDATE, PROC_REF(on_wearer_validate_sex_action))
	return TRUE

/datum/component/intimate_action_guard/proc/unbind_from_wearer(mob/living/carbon/human/H)
	if(!H)
		H = wearer
	if(!H)
		return FALSE
	UnregisterSignal(H, COMSIG_CARBON_SEX_ACTION_VALIDATE)
	if(H == wearer)
		wearer = null
	return TRUE
/datum/component/intimate_action_guard/proc/on_wearer_validate_sex_action(datum/source, datum/sex_action/action, mob/living/carbon/human/other, checked_part, is_user_role, menu_check)
	SIGNAL_HANDLER
	if(source != wearer)
		return FALSE
	return try_validate_wearer_sex_action(source, action, other, checked_part, is_user_role, menu_check)

/// Validates the sex action for the wearer of the chastity device.
/datum/component/intimate_action_guard/proc/try_validate_wearer_sex_action(mob/living/carbon/human/source, datum/sex_action/action, mob/living/carbon/human/other, checked_part, is_user_role, menu_check)
	return FALSE

/datum/component/intimate_action_guard/chastity

/datum/component/intimate_action_guard/chastity/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return .
	if(!istype(parent, /obj/item/chastity))
		return COMPONENT_INCOMPATIBLE

/datum/component/intimate_action_guard/chastity/try_validate_wearer_sex_action(mob/living/carbon/human/source, datum/sex_action/action, mob/living/carbon/human/other, checked_part, is_user_role, menu_check)
	var/obj/item/chastity/device = parent
	if(!source || QDELETED(source) || source != wearer)
		return FALSE
	if(source.chastity_device != device)
		return FALSE

	checked_part = checked_part & (SEX_PART_COCK | SEX_PART_CUNT | SEX_PART_ANUS)
	if(!checked_part)
		return FALSE

	var/datum/sex_controller/wearer_sexcon = source.sexcon
	if(!wearer_sexcon)
		return FALSE
	if((checked_part & SEX_PART_COCK) && wearer_sexcon.has_chastity_penis())
		return COMPONENT_SEX_ACTION_BLOCK
	if((checked_part & SEX_PART_CUNT) && wearer_sexcon.has_chastity_vagina())
		return COMPONENT_SEX_ACTION_BLOCK
	if((checked_part & SEX_PART_ANUS) && wearer_sexcon.has_chastity_anal())
		return COMPONENT_SEX_ACTION_BLOCK
	return FALSE

/// Chastity-specific cooldown state for receive-flavor and arousal reaction channels.
/// last_movement_message_time and movement_message_cooldown are inherited from the base class.
/datum/component/intimate_reaction/chastity_receive_flavor
	var/last_receive_flavor_time = 0
	var/receive_flavor_cooldown = 8 SECONDS
	var/last_arousal_message_time = 0
	var/arousal_message_cooldown = 10 SECONDS

/datum/component/intimate_reaction/chastity_receive_flavor/Initialize()
	. = ..()
	if(. == COMPONENT_INCOMPATIBLE)
		return .
	if(!istype(parent, /obj/item/chastity))
		return COMPONENT_INCOMPATIBLE

/// Binds the component to the wearer mob.
/datum/component/intimate_reaction/chastity_receive_flavor/bind_to_wearer(mob/living/carbon/human/H)
	var/already_bound = (wearer == H)
	. = ..()
	if(!.)
		return FALSE
	if(already_bound)
		return TRUE
	register_movement_reaction(H) // routes COMSIG_MOVABLE_MOVED → on_wearer_moved → try_handle_wearer_moved
	var/obj/item/chastity/device = parent
	if(device)
		device.chastity_move_counter = 0
	return TRUE

/// Unbinds the component from the wearer mob.
/datum/component/intimate_reaction/chastity_receive_flavor/unbind_from_wearer(mob/living/carbon/human/H)
	if(!H)
		H = wearer
	if(!H)
		return FALSE
	unregister_movement_reaction(H) // mirrors register_movement_reaction in bind_to_wearer
	return ..(H)

/// Extends the base validity check with a chastity-device cross-reference.
/// Ensures source is still actively wearing THIS specific device, not just any chastity item.
/datum/component/intimate_reaction/chastity_receive_flavor/is_valid_wearer_source(mob/living/carbon/human/source)
	if(!..()) // base: non-null, not QDELeted, matches bound wearer
		return FALSE
	var/obj/item/chastity/device = parent
	return source.chastity_device == device

/// for cum retention, specifically if the user has cummed while in the chastity device.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/has_retained_creampie(mob/living/carbon/human/source)
	if(!source)
		return FALSE
	return !!source.has_status_effect(/datum/status_effect/facial/internal)

/// Returns TRUE if the wearer should receive spiritually-framed flavor text.
/// Matches the exact conditions used by refresh_chastity_mood_effects() in chastity_core.dm:
/// church job roles always qualify; godfearing flaw or Devotee virtue qualify if their patron approves of chastity.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/is_devout_chastity_wearer(mob/living/carbon/human/source)
	// Church job positions always get the devout framing — vows and station are sufficient.
	if(source.mind?.assigned_role in GLOB.church_positions)
		return TRUE
	// Godfearing flaw or Devotee virtue qualify, but only if their patron actually endorses the practice.
	// Inhumen patrons and Eora do not — see patron_approves_chastity() in chastity_core.dm.
	var/obj/item/chastity/device = source.chastity_device
	if(!device || !device.patron_approves_chastity(source))
		return FALSE
	return source.has_flaw(/datum/charflaw/addiction/godfearing) || device.has_devotee_virtue(source)

/// Gets the string key for the receive flavor message.
/// action and acting_mob are used to distinguish masturbation (self-touch), outercourse (manual by another), and penetrative contexts.
/// The general banks (chastity_*_general_receive) now only fire for penetrative actions — outercourse and self-touch have dedicated banks.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/get_receive_flavor_key(mob/living/carbon/human/source, receiver_part, datum/sex_action/action, mob/living/carbon/human/acting_mob)
	var/datum/sex_controller/wearer_sexcon = source?.sexcon
	if(!wearer_sexcon)
		return null

	var/has_penis_chastity = wearer_sexcon.has_chastity_penis()
	var/has_vagina_chastity = wearer_sexcon.has_chastity_vagina()
	var/devout = is_devout_chastity_wearer(source)

	// Anal penetration — anatomy-specific banks unchanged; devout still get the unified receive bank.
	if(receiver_part & SEX_PART_ANUS)
		if(devout)
			return "chastity_receive_devout"
		if(has_penis_chastity && has_vagina_chastity)
			return "chastity_intersex_anal_recieve"
		if(has_penis_chastity)
			return "chastity_cock_anal_recieve"
		if(has_vagina_chastity)
			return "chastity_vagina_anal_recieve"

	// Self-touch: the wearer attempting to pleasure themselves through or against the device.
	// Detected when the acting mob IS the wearer — covers masturbate_cage_penis, masturbate_vagina, etc.
	var/is_masturbation = (acting_mob == source)
	if(is_masturbation)
		if(devout)
			return "chastity_masturbation_devout"
		if(has_penis_chastity && has_vagina_chastity)
			return "chastity_intersex_masturbation"
		if(has_penis_chastity)
			return "chastity_cock_masturbation"
		if(has_vagina_chastity)
			return "chastity_vagina_masturbation"

	// Outercourse: manual stimulation from another person (SEX_CATEGORY_HANDS).
	// Covers stroking the cage bars, pressing the belt panel, sounding, fingering around the device, etc.
	var/is_outercourse = action && (action.category & SEX_CATEGORY_HANDS)
	if(is_outercourse)
		if(devout)
			return "chastity_outercourse_devout"
		if(has_penis_chastity && has_vagina_chastity)
			return "chastity_intersex_outercourse"
		if(has_penis_chastity)
			return "chastity_cock_outercourse"
		if(has_vagina_chastity)
			return "chastity_vagina_outercourse"

	// Penetrative (SEX_CATEGORY_PENETRATE) or unclassified misc — general banks, now correctly scoped to this context.
	if(devout)
		return "chastity_receive_devout"
	if(has_penis_chastity && has_vagina_chastity)
		return "chastity_intersex_general_receive"
	if(has_penis_chastity)
		return "chastity_cock_general_receive"
	if(has_vagina_chastity)
		return "chastity_vagina_general_receive"

	return null

/// how we determine which string bank to use depending on sex organ and arousal.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/get_arousal_key(mob/living/carbon/human/source)
	var/datum/sex_controller/wearer_sexcon = source?.sexcon
	if(!wearer_sexcon)
		return null

	// Retention overrides everything — even devout wearers feel that particular hell distinctly.
	if(wearer_sexcon.has_chastity_vagina() && has_retained_creampie(source))
		return "chastity_insert_vagina_retention"

	// Devout/church wearers experience the device through a spiritual lens regardless of anatomy.
	if(is_devout_chastity_wearer(source))
		return "chastity_arousal_devout"

	// Intersex wearers (belt + cage) — dual denial from both directions simultaneously.
	if(wearer_sexcon.has_chastity_penis() && wearer_sexcon.has_chastity_vagina())
		return "chastity_arousal_intersex"

	// Belt-only wearers.
	if(wearer_sexcon.has_chastity_vagina())
		return "chastity_arousal_vagina"

	if(!wearer_sexcon.has_chastity_cage())
		return null

	// Large-cock wearers get a dedicated bank describing the physical discomfort of the undersized cage.
	var/obj/item/organ/penis/wearer_penis = source.getorganslot(ORGAN_SLOT_PENIS)
	if(wearer_penis && wearer_penis.penis_size >= MAX_PENIS_SIZE)
		return "chastity_arousal_large_cock"

	var/frustration_threshold = (AROUSAL_HARD_ON_THRESHOLD * 2)
	var/teasing_threshold = (ACTIVE_EJAC_THRESHOLD - 30)
	if(wearer_sexcon.arousal >= ACTIVE_EJAC_THRESHOLD)
		return "chastity_arousal_edge"
	if(wearer_sexcon.arousal >= teasing_threshold)
		return "chastity_arousal_teasing"
	if(wearer_sexcon.arousal >= frustration_threshold)
		return "chastity_arousal_frustration"
	return "chastity_arousal_denial"

/datum/component/intimate_reaction/chastity_receive_flavor/proc/get_arousal_message_chance(mob/living/carbon/human/source, arousal_amt, applied_force, applied_speed)
	var/datum/sex_controller/wearer_sexcon = source?.sexcon
	if(!wearer_sexcon)
		return 0

	var/chance = 0
	if(wearer_sexcon.has_chastity_vagina())
		chance = has_retained_creampie(source) ? 28 : 18
	else if(wearer_sexcon.arousal >= ACTIVE_EJAC_THRESHOLD)
		chance = 30
	else if(wearer_sexcon.arousal >= (ACTIVE_EJAC_THRESHOLD - 30))
		chance = 22
	else if(wearer_sexcon.arousal >= (AROUSAL_HARD_ON_THRESHOLD * 2))
		chance = 16
	else
		chance = 8

	chance += (arousal_amt * 2)
	chance += (applied_force * 3)
	chance += (applied_speed * 3)
	return min(round(chance), 75)

/// Gets the string key for the pain message.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/get_pain_key(mob/living/carbon/human/source, pain_amt)
	var/datum/sex_controller/wearer_sexcon = source?.sexcon
	if(!wearer_sexcon)
		return null
	if(!HAS_TRAIT(source, TRAIT_CHASTITY_SPIKED))
		return null
	// Devout/church wearers frame all spiked pain as mortification of the flesh offered to their patron.
	// This takes priority over both the masochist and horror-tier banks — spiritual acceptance is its own register.
	if(is_devout_chastity_wearer(source) && pain_amt >= PAIN_MILD_EFFECT)
		return "chastity_pain_spikes_devout"
	// Intersex wearers with both devices spiked get their own bank — internal barbs AND external cage teeth simultaneously.
	if(wearer_sexcon.has_chastity_penis() && wearer_sexcon.has_chastity_vagina() && pain_amt >= PAIN_MILD_EFFECT)
		if(wearer_sexcon.is_masochist_in_spiked_chastity())
			return "chastity_pain_spikes_intersex_masochist"
		return "chastity_pain_spikes_intersex"
	// Vaginal belt spikes take priority over the generic cage banks — the internal damage is its own category.
	if(wearer_sexcon.has_chastity_vagina() && pain_amt >= PAIN_MILD_EFFECT)
		if(wearer_sexcon.is_masochist_in_spiked_chastity())
			return "chastity_pain_spikes_vagina_masochist"
		return "chastity_pain_spikes_vagina"
	if(pain_amt >= PAIN_HIGH_EFFECT)
		if(wearer_sexcon.is_masochist_in_spiked_chastity())
			return "chastity_pain_high_masochist"
		return "chastity_pain_high"
	if(pain_amt >= PAIN_MED_EFFECT)
		if(wearer_sexcon.is_masochist_in_spiked_chastity())
			return "chastity_pain_medium_masochist"
		return "chastity_pain_medium"
	if(pain_amt >= PAIN_MILD_EFFECT)
		if(wearer_sexcon.is_masochist_in_spiked_chastity())
			return "chastity_pain_low_masochist"
		return "chastity_pain_low"
	return null

/// Gets the string key for the movement message.
/// When the base key would be chastity_jingle_emotes (visible device), checks groin coverage tier via
/// get_cover_tier_for_zone() (defined on the base class) and redirects to the appropriate muffled bank.
/// Pain and struggle keys always pass through unchanged — gait and wincing are visible regardless of coverage.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/get_movement_string_key(mob/living/carbon/human/source)
	var/datum/sex_controller/wearer_sexcon = source?.sexcon
	if(!wearer_sexcon)
		return null

	var/has_restrictive_chastity = (wearer_sexcon.has_chastity_cage() || wearer_sexcon.has_chastity_anal())
	var/weighted_roll = rand(1, 100)
	if(HAS_TRAIT(source, TRAIT_CHASTITY_SPIKED) && weighted_roll <= 15)
		return "chastity_movement_pain"
	if(has_restrictive_chastity && weighted_roll <= 45)
		return "chastity_movement_struggle"

	// Device is visible by default. Check if clothing or armor is muffling it.
	var/cover_tier = get_cover_tier_for_zone(source, BODY_ZONE_PRECISE_GROIN)
	if(isnull(cover_tier))
		return "chastity_jingle_emotes" // Device is visible — use the explicit bank
	switch(cover_tier)
		if(ARMOR_CLASS_NONE)
			return "chastity_jingle_cloth"
		if(ARMOR_CLASS_LIGHT)
			return "chastity_jingle_light_armor"
		if(ARMOR_CLASS_MEDIUM)
			return "chastity_jingle_medium_armor"
		if(ARMOR_CLASS_HEAVY)
			return "chastity_jingle_heavy_armor"
	return "chastity_jingle_cloth" // fallback: covered but unrecognised tier

/// Handles the receive flavor message.
/// action and acting_mob are threaded through to get_receive_flavor_key so the correct context bank (masturbation, outercourse, penetrative) can be selected.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/try_handle_receive_flavor(mob/living/carbon/human/source, receiver_part, datum/sex_action/action, mob/living/carbon/human/acting_mob, applied_force, applied_speed)
	var/datum/sex_controller/wearer_sexcon = source?.sexcon
	if(!wearer_sexcon || !wearer_sexcon.modular_chastity_content_enabled_for(source))
		return FALSE
	if(source.stat != CONSCIOUS)
		return FALSE
	if(last_receive_flavor_time + receive_flavor_cooldown >= world.time)
		return FALSE

	var/string_key = get_receive_flavor_key(source, receiver_part, action, acting_mob)
	if(!string_key)
		return FALSE
	if(!prob(10 + (applied_force * 5) + (applied_speed * 5)))
		return FALSE

	var/message = pick_string_bank("chastity_receive_flavor.json", string_key)
	if(!message)
		return FALSE

	last_receive_flavor_time = world.time
	to_chat(source, span_warning(message))
	return TRUE

/// Handles the arousal message.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/try_handle_arousal_message(mob/living/carbon/human/source, arousal_amt, applied_force, applied_speed)
	var/datum/sex_controller/wearer_sexcon = source?.sexcon
	if(!wearer_sexcon || !wearer_sexcon.modular_chastity_content_enabled_for(source))
		return FALSE
	if(source.stat != CONSCIOUS)
		return FALSE
	if(arousal_amt <= 0)
		return FALSE
	if(wearer_sexcon.last_arousal_increase_time != world.time)
		return FALSE
	if(last_arousal_message_time + arousal_message_cooldown >= world.time)
		return FALSE

	var/string_key = get_arousal_key(source)
	if(!string_key)
		return FALSE
	var/message_chance = get_arousal_message_chance(source, arousal_amt, applied_force, applied_speed)
	if(message_chance <= 0 || !prob(message_chance))
		return FALSE
	var/message = pick_string_bank("chastity_arousal_messages.json", string_key)
	if(!message)
		return FALSE

	last_arousal_message_time = world.time
	to_chat(source, span_love(message))
	return TRUE

/// Handles the pain message.
/datum/component/intimate_reaction/chastity_receive_flavor/proc/try_handle_pain_message(mob/living/carbon/human/source, pain_amt)
	var/datum/sex_controller/wearer_sexcon = source?.sexcon
	if(!wearer_sexcon || !wearer_sexcon.modular_chastity_content_enabled_for(source))
		return FALSE
	if(source.stat != CONSCIOUS)
		return FALSE
	if(wearer_sexcon.last_pain != world.time)
		return FALSE

	var/string_key = get_pain_key(source, pain_amt)
	var/message = pick_string_bank("chastity_pain_messages.json", string_key)
	if(!message)
		return FALSE

	// Three distinct display registers based on the wearer's relationship with the device:
	// - Devout (span_notice): serene acceptance, mortification framing — visible messages show composed endurance.
	// - Masochist (span_love): eager, involuntary pleasure — visible messages show desperate enjoyment.
	// - Standard (span_boldwarning): horror and pain — visible messages show distress.
	// Routing in get_pain_key() already assigns the correct bank, so we just need to pick the right span.
	var/devout_spiked = is_devout_chastity_wearer(source)
	var/masochist_spiked = !devout_spiked && wearer_sexcon.is_masochist_in_spiked_chastity()
	if(devout_spiked)
		to_chat(source, span_notice(message))
	else if(masochist_spiked)
		to_chat(source, span_love(message))
	else
		to_chat(source, span_boldwarning(message))

	if(pain_amt >= PAIN_HIGH_EFFECT)
		source.flash_fullscreen("redflash3")
		if(prob(70))
			if(devout_spiked)
				source.visible_message(span_notice("[source] goes very still, jaw set, as the chastity spikes bite deep — enduring it with deliberate composure."))
			else if(masochist_spiked)
				source.visible_message(span_warning("[source] shudders and whimpers as the chastity spikes bite in, seeming to savor the punishment."))
			else
				source.visible_message(span_warning("[source] writhes in pain as the chastity spikes dig bloody into their tortured flesh!"))
		return TRUE

	if(pain_amt >= PAIN_MED_EFFECT)
		source.flash_fullscreen("redflash2")
		if(prob(50))
			if(devout_spiked)
				source.visible_message(span_notice("[source] breathes carefully through the bite of the chastity spikes, expression drawn but steady."))
			else if(masochist_spiked)
				source.visible_message(span_warning("[source] trembles as the chastity spikes grind in, breathing out an eager, pained moan."))
			else
				source.visible_message(span_warning("[source] shudders in pain as the chastity spikes dig into their flesh!"))
		return TRUE

	source.flash_fullscreen("redflash1")
	if(prob(30))
		if(devout_spiked)
			source.visible_message(span_notice("[source] shifts slightly as the chastity spikes catch, then stills themselves with quiet deliberateness."))
		else if(masochist_spiked)
			source.visible_message(span_warning("[source] shivers as the chastity spikes tease their flesh, eyes half-lidded."))
		else
			source.visible_message(span_warning("[source] groans as the chastity spikes prod their flesh..."))
	return TRUE

/// Movement reaction for chastity devices — dispatched by the base on_wearer_moved handler.
/// Handles the step counter, high-pop chance scaling, optional chastity sound, and message dispatch.
/datum/component/intimate_reaction/chastity_receive_flavor/try_handle_wearer_moved(mob/living/carbon/human/source)
	var/obj/item/chastity/device = parent
	if(!device || !is_valid_wearer_source(source))
		return FALSE

	device.chastity_move_counter++
	if(device.chastity_move_counter < device.chastity_move_delay)
		return FALSE
	device.chastity_move_counter = 0

	var/effective_move_chance = device.chastity_move_chance
	if(GLOB.clients?.len >= device.chastity_high_pop_client_cap)
		effective_move_chance = max(1, round(device.chastity_move_chance * device.chastity_high_pop_move_chance_mult))
	if(!prob(effective_move_chance))
		return FALSE

	if(device.chastity_move_sound)
		playsound(source, device.chastity_move_sound, device.chastity_move_volume, TRUE)

	var/datum/sex_controller/wearer_sexcon = source.sexcon
	if(!wearer_sexcon || !wearer_sexcon.modular_chastity_content_enabled_for(source))
		return TRUE
	if(source.stat != CONSCIOUS)
		return TRUE
	if(last_movement_message_time + movement_message_cooldown >= world.time)
		return TRUE

	var/string_key = get_movement_string_key(source)
	var/message = pick_string_bank("chastity_movement_messages.json", string_key)
	if(!message)
		return TRUE

	last_movement_message_time = world.time
	// All jingle banks (visible and all covered variants) produce messages beginning with "'s",
	// so they are concatenated directly onto the name without a separating space.
	// Pain and struggle messages begin with a verb and need the leading space.
	if(string_key == "chastity_movement_pain")
		source.visible_message(span_warning("[source] [message]"))
	else if(copytext(string_key, 1, 17) == "chastity_jingle_")
		source.visible_message(span_notice("[source][message]"))
	else
		source.visible_message(span_notice("[source] [message]"))
	return TRUE

/datum/component/intimate_reaction/chastity_receive_flavor/try_handle_wearer_sex_action_received(mob/living/carbon/human/source, mob/living/carbon/human/acting_mob, datum/sex_controller/acting_sexcon, datum/sex_action/action, receiver_part, giving, arousal_amt, pain_amt, applied_force, applied_speed)
	if(!is_valid_wearer_source(source))
		return FALSE
	var/handled = FALSE
	if(try_handle_pain_message(source, pain_amt))
		handled = TRUE
	if(try_handle_arousal_message(source, arousal_amt, applied_force, applied_speed))
		handled = TRUE
	if(try_handle_receive_flavor(source, receiver_part, action, acting_mob, applied_force, applied_speed))
		handled = TRUE
	return handled