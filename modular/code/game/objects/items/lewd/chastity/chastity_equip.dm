// Self-equip flow: validates wearer state, then applies standard chastity setup.
/obj/item/chastity/attack_self(mob/user) // self equipping chastity device
	if(!ishuman(user))
		return
	var/mob/living/carbon/human/H = user
	if(H.client?.prefs && !H.client.prefs.chastenable)
		to_chat(user, span_warning("I have chastity content disabled."))
		return
	// Spiked devices are extreme content — require the wearer's explicit opt-in.
	// Use the trait list as the authoritative spiked check so this stays in sync with chastity_standard_traits.
	if((TRAIT_CHASTITY_SPIKED in GLOB.chastity_standard_traits[chastity_type + 1]) && (H.client?.prefs && !H.client.prefs.extreme_erp))
		to_chat(user, span_warning("Eora intervenes. I cannot equip a spiked device."))
		return
	if(!can_cage_target(H, user))
		return
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		to_chat(user, span_warning("My groin is not accessible!"))
		return
	if(H.chastity_device)
		to_chat(user, span_warning("I am already wearing a chastity device!"))
		return
	if(!chastity_genital_check(H))
		to_chat(user, span_warning("I don't have the required genitalia for the [src]."))
		return
	ensure_chastity_feature(H)
	user.visible_message(span_notice("I attempt to chasten my genitals with the [src]..."))
	if(do_after(user, 50, needhand = 1, target = H))
		equip_standard_chastity(H, user)
	..()

// Equip-other flow: handles normal devices and cursed devices with master-binding logic.
/obj/item/chastity/attack(mob/M, mob/user, def_zone) // equipping others with chastity device
	if(!ishuman(M))
		return
	var/mob/living/carbon/human/H = M
	if(H.client?.prefs && !H.client.prefs.chastenable)
		to_chat(user, span_warning("Eora intervenes. They have chastity content disabled."))
		return
	if(user?.client?.prefs && !user.client.prefs.chastenable)
		to_chat(user, span_warning("I have chastity content disabled."))
		return
	// Spiked devices are extreme content — the wearer must have explicitly opted in.
	// Use the trait list as the authoritative spiked check so this stays in sync with chastity_standard_traits.
	if((TRAIT_CHASTITY_SPIKED in GLOB.chastity_standard_traits[chastity_type + 1]) && (H.client?.prefs && !H.client.prefs.extreme_erp))
		to_chat(user, span_warning("Eora intervenes. They cannot be fitted with a spiked device."))
		return
	if(!can_cage_target(H, user))
		return
	if(H.chastity_device == src)
		attack_self(user)
		return
	if(H.chastity_device)
		to_chat(user, span_warning("[H] is already wearing a chastity device!"))
		return
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN))
		to_chat(user, span_warning("The groin area is not accessible!"))
		return
	if(!chastity_genital_check(H))
		to_chat(user, span_warning("[H] does not have the required genitalia for the [src]."))
		return
	user.visible_message(span_notice("[user] tries to put the [src] on [H]..."))
	if(chastity_cursed)
		if(H == user)
			to_chat(user, span_warning("I cannot fasten a cursed chastity device on myself."))
			return
		if(!chastity_master)
			to_chat(user, span_warning("The cursed device rejects binding without an imprinted master."))
			return
		var/obj/item/clothing/neck/roguetown/cursed_collar/existing_collar = H.get_item_by_slot(SLOT_NECK)
		if(istype(existing_collar))
			to_chat(user, span_warning("[H] is already bound by a cursed collar."))
			return

		var/equip_time = 50
		if(H.surrendering || H.has_status_effect(/datum/status_effect/surrender/collar))
			equip_time = 25
		if(!do_after(user, equip_time, needhand = 1, target = H))
			return
		if(H.chastity_device)
			to_chat(user, span_warning("[H] is already wearing a chastity device!"))
			return
		existing_collar = H.get_item_by_slot(SLOT_NECK)
		if(istype(existing_collar))
			to_chat(user, span_warning("[H] is already bound by a cursed collar."))
			return

		ensure_chastity_feature(H)
		attach_chastity_feature(H)

		playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)
		finalize_chastity_equip(H)
		// Handle cursed binding
		if(chastity_master)
			var/datum/component/collar_master/CM = chastity_master.GetComponent(/datum/component/collar_master)
			if(!CM)
				CM = chastity_master.AddComponent(/datum/component/collar_master)
			CM.add_pet(H)
		locked = TRUE
		if(cursed_front_mode < 0 || cursed_front_mode > 3)
			cursed_front_mode = 0
		apply_cursed_state(H)
	else
		ensure_chastity_feature(H)
		// Line 51 already announced the attempt to nearby players; no second message needed here.
		if(do_after(user, 50, needhand = 1, target = H))
			equip_standard_chastity(H, user)
	..()

// Shared helper for standard equip path: visual attach, ownership setup, key spawn, and traits.
/obj/item/chastity/proc/equip_standard_chastity(mob/living/carbon/human/H, mob/user)
	playsound(loc, 'sound/foley/equip/equip_armor_plate.ogg', 30, TRUE, -2)
	if(!attach_chastity_feature(H))
		return FALSE
	finalize_chastity_equip(H)
	generate_chastity_key(user, H)
	apply_standard_chastity_traits(H)
	return TRUE

// Unequips the device and removes all chastity-related state/traits from the wearer.
/obj/item/chastity/proc/remove_chastity(mob/living/carbon/human/H)
	if(H.chastity_device != src)
		return
	var/mob/living/carbon/human/old_wearer = H
	var/datum/component/intimate_action_guard/chastity/action_guard_component = GetComponent(/datum/component/intimate_action_guard/chastity)
	if(action_guard_component)
		action_guard_component.unbind_from_wearer(H)
	var/datum/component/intimate_reaction/chastity_receive_flavor/reaction_component = GetComponent(/datum/component/intimate_reaction/chastity_receive_flavor)
	if(reaction_component)
		reaction_component.unbind_from_wearer(H)
	clear_chastity_mood_effects(H)
	UnregisterSignal(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT)
	UnregisterSignal(H, COMSIG_CARBON_CHASTITY_STATE_CHANGED)
	chastity_move_counter = 0
	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	if(chest && chastity_feature)
		chest.remove_bodypart_feature(chastity_feature)
	H.chastity_device = null
	chastity_feature = null
	chastity_victim = null
	REMOVE_TRAIT(H, TRAIT_CHASTITY_FULL, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_CAGE, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_PENIS_BLOCKED, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_VAGINA_BLOCKED, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_ANAL, TRAIT_SOURCE_CHASTITY)
	REMOVE_TRAIT(H, TRAIT_CHASTITY_SPIKED, TRAIT_SOURCE_CHASTITY)
	if(locked)
		REMOVE_TRAIT(H, TRAIT_CHASTITY_LOCKED, TRAIT_SOURCE_CHASTITY)
		locked = FALSE
	// Handle cursed unbinding through the shared helper to avoid duplicated release logic.
	if(chastity_cursed)
		cleanup_cursed_binding(H)
	old_wearer.update_body_parts(TRUE)
	old_wearer.update_inv_belt()

/**
 * Emergency physical removal for non-cursed locked devices using hammer & chisel.
 * This is one of three allowed removal routes for a locked chastity device:
 *   1. Original generated key (always allowed, bypasses every check)
 *   2. Werewolf transformation destroying the device (break_on_werewolf_transform)
 *   3. This proc — hammer & chisel brute-force removal
 *
 * Hard mode blocks this path via COMSIG_CARBON_CHASTITY_LOCK_INTERACT; the wearer must NOT have
 * hard mode enabled for hammer & chisel to work. The signal is checked twice: once before the
 * while loop begins (immediate bail) and once per strike inside the loop (in case prefs change
 * mid-attempt, which shouldn't happen but is safe to guard anyway).
 *
 * Luck-scaled chisel slip:
 *   When the lock finally gives, there is a base 10% chance the sudden release rakes the blade
 *   edge through whatever anatomy is still trapped inside. Each luck point above 10 reduces the
 *   chance by 2%; each point below increases it by 2%, clamped between 2% and 22%.
 *   - Penis present: 20% sub-chance of full penectomy (organ removed), otherwise CBT wound.
 *   - Vagina only:   CBT wound if one isn't already present.
 *   - Intersex (both organs): falls into the penis branch — prick takes priority.
 *   All injury branches guard against wound stacking with has_wound() before applying.
 */
/obj/item/chastity/proc/attempt_forced_removal(mob/living/carbon/human/H, mob/user)
	if(!H || !user)
		return FALSE
	if(H.chastity_device != src)
		return FALSE
	if(!locked)
		to_chat(user, span_notice("The device is already unlocked."))
		return FALSE
	if(!lockable)
		to_chat(user, span_warning("This chastity device cannot be forced open this way."))
		return FALSE
	if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
		to_chat(user, span_warning("I can't reach the lock while [H]'s groin is covered."))
		return FALSE
	if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, null, FALSE, "forced_removal") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
		to_chat(user, span_warning(get_lock_denial_string()))
		playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
		return TRUE

	var/success_chance = 25
	if(ishuman(user))
		var/mob/living/carbon/human/U = user
		success_chance += (U.STALUC - 10) * 4
	success_chance = clamp(success_chance, 5, 80)

	user.visible_message(span_warning("[user] braces a chisel against [H]'s chastity lock and starts hammering!"), span_warning("I brace a chisel against [H]'s chastity lock and start hammering!"))
	while(H.chastity_device == src && locked)
		if(!do_after(user, 60, needhand = 1, target = H))
			return TRUE
		if(!get_location_accessible(H, BODY_ZONE_PRECISE_GROIN, skipundies = TRUE))
			to_chat(user, span_warning("I lose access to the lock and have to stop."))
			return TRUE
		if(SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, user, null, FALSE, "forced_removal") & COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK)
			to_chat(user, span_warning(get_lock_denial_string()))
			playsound(src, 'sound/foley/doors/lockrattle.ogg', 100)
			return TRUE

		playsound(get_turf(H), 'sound/combat/hits/bladed/genstab (1).ogg', 45, TRUE)
		H.apply_damage(rand(8,16), BRUTE, BODY_ZONE_PRECISE_GROIN)

		if(prob(35) && ishuman(user))
			var/mob/living/carbon/human/U = user
			U.apply_damage(rand(2,6), BRUTE, pick(BODY_ZONE_PRECISE_R_HAND, BODY_ZONE_PRECISE_L_HAND))
			to_chat(user, span_warning("The chisel slips and nicks my hand."))

		if(prob(success_chance))
			user.visible_message(span_notice("[user] finally pries [H]'s chastity device open."), span_notice("I finally pry the chastity device open."))
			locked = FALSE
			REMOVE_TRAIT(H, TRAIT_CHASTITY_LOCKED, TRAIT_SOURCE_CHASTITY)
			remove_chastity(H)
			if(!user.put_in_hands(src))
				forceMove(get_turf(H))

			// Luck-scaled chisel-slip: when the lock finally gives, the sudden release can drag
			// the blade edge through whatever is still trapped beneath it.
			// Base 10% chance; each luck point above 10 reduces by 2%, each below increases by 2%.
			// Clamped 2–22% so even very lucky wearers carry some risk.
			var/slip_chance = clamp(10 + (10 - H.STALUC) * 2, 2, 22)
			if(prob(slip_chance))
				var/obj/item/organ/penis_organ = H.getorganslot(ORGAN_SLOT_PENIS)
				var/obj/item/organ/vagina_organ = H.getorganslot(ORGAN_SLOT_VAGINA)
				var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
				var/turf/drop_turf = get_turf(H)

				if(penis_organ)
					// 20% sub-chance: the slipping edge catches and tears the organ free entirely.
					// Requires the wearer to have extreme ERP content enabled; without it the slip
					// still causes a CBT wound but stops short of full avulsion.
					if(prob(20) && H.client?.prefs?.extreme_erp)
						H.visible_message(span_userdanger("As the lock finally gives, [user]'s chisel catches [H.p_their()] trapped prick on the way out — the edge tears through flesh and root, ripping it free alongside the falling device."))
						playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamMale1.ogg', 'modular/sound/masomoans/agony/CBTScreamMale2.ogg'), 85, FALSE, 2)
						H.add_splatter_floor(drop_turf)
						penis_organ.Remove(H)
						penis_organ.forceMove(drop_turf)
					else if(chest && !chest.has_wound(/datum/wound/cbt))
						// Slip causes crushing/tearing internal groin injury but no avulsion.
						H.visible_message(span_userdanger("As the lock gives, [user]'s chisel bites into [H.p_their()] stones — the sudden jolt of metal twisting through [H.p_their()] groin as the device drops free."))
						playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamMale1.ogg', 'modular/sound/masomoans/agony/CBTScreamMale2.ogg'), 85, FALSE, 2)
						H.add_splatter_floor(drop_turf)
						chest.add_wound(/datum/wound/cbt)
				else if(vagina_organ && chest && !chest.has_wound(/datum/wound/cbt))
					// Slip rakes across exposed softer anatomy; no organ removal but severe tearing.
					H.visible_message(span_userdanger("As the lock gives, the chisel catches [H.p_their()] exposed slit — the device's sudden release dragging the edge through tender flesh and leaving a ragged wound."))
					playsound(drop_turf, pick('modular/sound/masomoans/agony/CBTScreamFemale1.ogg', 'modular/sound/masomoans/agony/CBTScreamFemale2.ogg'), 85, FALSE, 2)
					H.add_splatter_floor(drop_turf)
					chest.add_wound(/datum/wound/cbt)

			return TRUE
		else
			to_chat(user, span_warning("The lock holds. I need another strike."))

	return TRUE

// Emergency break path used by werewolf transformation to destroy incompatible devices.
/obj/item/chastity/proc/break_on_werewolf_transform(mob/living/carbon/human/H)
	if(!H)
		return
	if(H.chastity_device != src)
		return

	if(HAS_TRAIT(H, TRAIT_CHASTITY_SPIKED))
		H.visible_message(span_userdanger("[H]'s swelling werewolf form violently bursts through [H.p_their()] spiked chastity device, sending shards flying!"))
	else
		H.visible_message(span_userdanger("[H]'s swelling werewolf form snaps [H.p_their()] chastity device apart with a sharp metallic crack!"))

	playsound(get_turf(H), 'sound/combat/gib (1).ogg', 70, FALSE, 2)
	remove_chastity(H)
	qdel(src)

// Hooks wearer state signals; movement sound and messaging are handled by the intimate reaction component.
/obj/item/chastity/proc/register_wearer_jingle(mob/living/carbon/human/H)
	if(!H)
		return
	UnregisterSignal(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT)
	RegisterSignal(H, COMSIG_CARBON_CHASTITY_LOCK_INTERACT, PROC_REF(on_chastity_lock_interact))
	UnregisterSignal(H, COMSIG_CARBON_CHASTITY_STATE_CHANGED)
	RegisterSignal(H, COMSIG_CARBON_CHASTITY_STATE_CHANGED, PROC_REF(on_chastity_state_changed))
	chastity_move_counter = 0

// Shared state-change signal callback for all chastity trait toggles and mode switches.
/obj/item/chastity/proc/on_chastity_state_changed(datum/source, obj/item/chastity/device, reason)
	SIGNAL_HANDLER
	if(device != src || source != chastity_victim)
		return
	refresh_chastity_mood_effects(chastity_victim)
	if(chastity_cursed)
		update_cursed_visual(chastity_victim)

// Failsafe cleanup: if item is deleted while worn, forcibly unapply all wearer state.
/obj/item/chastity/Destroy() // failsafe to remove chastity traits if the belt get's Qdel'd or something
	detach_toy()
	if(chastity_victim)
		remove_chastity(chastity_victim)
	return ..()
