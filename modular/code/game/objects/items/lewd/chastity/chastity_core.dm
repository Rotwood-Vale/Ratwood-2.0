/// Indexed by chastity_type + 1. Each entry is the list of traits applied by apply_standard_chastity_traits().
/// Type 0 = intersex full device, 1 = cage, 2 = cage+anal, 3 = spiked cage, 4 = spiked cage+anal.
/// Type 5 = insertable belt (vagina only), 6 = insertable+anal, 7 = spiked insertable, 8 = spiked insertable+anal, 9 = spiked intersex.
/// Insertable belts (types 5-8) use TRAIT_CHASTITY_VAGINA_BLOCKED rather than TRAIT_CHASTITY_FULL so that
/// has_chastity_anal() (which checks FULL) does NOT fire on non-shielded insertable variants.
/// Cursed devices do NOT use this list — their traits are toggled dynamically via apply_cursed_state().
GLOBAL_LIST_INIT(chastity_standard_traits, list(
	list(TRAIT_CHASTITY_FULL),                                                        // type 0 — intersex full device
	list(TRAIT_CHASTITY_CAGE),                                                        // type 1 — cock cage
	list(TRAIT_CHASTITY_CAGE, TRAIT_CHASTITY_ANAL),                                  // type 2 — cage + anal shield
	list(TRAIT_CHASTITY_CAGE, TRAIT_CHASTITY_SPIKED),                                // type 3 — spiked cage
	list(TRAIT_CHASTITY_CAGE, TRAIT_CHASTITY_ANAL, TRAIT_CHASTITY_SPIKED),           // type 4 — spiked cage + anal
	list(TRAIT_CHASTITY_VAGINA_BLOCKED),                                              // type 5 — insertable belt (vagina only, no anal shield)
	list(TRAIT_CHASTITY_VAGINA_BLOCKED, TRAIT_CHASTITY_ANAL),                        // type 6 — insertable + anal shield
	list(TRAIT_CHASTITY_VAGINA_BLOCKED, TRAIT_CHASTITY_SPIKED),                      // type 7 — spiked insertable
	list(TRAIT_CHASTITY_VAGINA_BLOCKED, TRAIT_CHASTITY_ANAL, TRAIT_CHASTITY_SPIKED), // type 8 — spiked insertable + anal
	list(TRAIT_CHASTITY_FULL, TRAIT_CHASTITY_SPIKED)                                 // type 9 — spiked intersex device
))

/obj/item/chastity
	var/cursed_front_mode = 0 // 0 = block all front access, 1 = penis open, 2 = vagina open, 3 = all front open
	var/cursed_anal_open = FALSE // is our ass shielded by the cursed belt?
	var/cursed_spikes_on = FALSE // are spikes deployed by our cursed belt?
	var/chastity_flat = FALSE // is the cage flat-style (more restrictive) or standard? Generally just for our cursed cage content.
	var/chastity_move_sound = SFX_JINGLE_BELLS // sound played when the chastity device moves
	var/chastity_move_delay = CHASTITY_MOVE_SOUND_DELAY // delay between movement sounds
	var/chastity_move_volume = 55 // how loud is our cock cage?
	var/chastity_move_chance = 5 // how often does it trigger on move?
	var/chastity_high_pop_client_cap = CHASTITY_HIGH_POP_THRESHOLD // for jingle throttle. Don't want the server spamming the noise when 120 people potentially cage up. 
	var/chastity_high_pop_move_chance_mult = CHASTITY_HIGH_POP_SOUND_MULT // lower chance to play the sound in high pop.
	var/tmp/chastity_move_counter = 0 // counter for move sound delay
// Core type definition — base name, icon, sizing, and feature-slot vars.
// Movement-sound vars (chastity_move_sound, chastity_move_delay, etc.) are declared in the
// block above because BYOND requires them before Initialize() is compiled. Both blocks together
// form the full /obj/item/chastity type; this split is purely a compile-order requirement.
/obj/item/chastity
	name = "chastity belt"
	desc = "A unisex metal device designed to prevent penetrative sex. It has a lock on the front, and encloses the groin area behind robust iron bars. For the devout."
	icon = 'modular/icons/obj/lewd/chastity.dmi'
	icon_state = "cage_belt"
	mob_overlay_icon = "cage_belt"
	w_class = WEIGHT_CLASS_TINY
	resistance_flags = INDESTRUCTIBLE
	var/datum/bodypart_feature/chastity/chastity_feature // snowflake slot for chastity items, belt's dont work as clothing equippables
	var/chastity_type = 0 // 0 = full, 1 = cage, 2 = cage with anal, 3 = spiked cage, 4 = spiked cage with anal, 5 = insertable, 6 = insertable with anal, 7 = spiked insertable, 8 = spiked insertable with anal, 9 = spiked intersex device
	var/chastity_organtype = 0 // 0 = neuter, 1 = penis required, 2 = vagina required, 3 = both required
	var/obj/item/roguekey/chastity/generated_key = null // persistent key object for this device; reused across re-equips
	var/lockable = TRUE // if the device can be traditionally locked with a key or lockpick, should be true for everything but cursed devices which are locked via the collar master menu
	locked = FALSE
	var/chastity_cursed = FALSE // if the device works like a cursed collar
	var/mob/living/carbon/human/chastity_victim = null // variable for anyone currently caged
	var/datum/mind/chastity_master = null // varient of the collar master variable but for specifically cages
	var/obj/item/dildo/attached_toy = null // dildo mounted directly onto this chastity device
	lockid = null
	lockhash = null
	grid_height = 32
	grid_width = 32
	throw_speed = 0.5
	var/sprite_acc = /datum/sprite_accessory/chastity/full // overlay for chastity items on the sprite, function in a similar vein to underwear in that they aren't traditional equipped clothing items, instead going in a snowflake slot
	lefthand_file = 'modular/icons/mob/inhands/lewd/items_lefthand.dmi'
	righthand_file = 'modular/icons/mob/inhands/lewd/items_righthand.dmi'
	nudist_approved = TRUE

// Ensure each chastity item has a unique lockhash used by matching keys.
/obj/item/chastity/Initialize()
	. = ..()
	if(!lockhash)
		lockhash = rand(100000,999999)
		while(lockhash in GLOB.lockhashes)
			lockhash = rand(100000,999999)
		GLOB.lockhashes += lockhash

/obj/item/chastity/examine()
	. = ..()
	if(attached_toy)
		. += "[span_notice("\An [attached_toy] appears attached to \the [initial(name)]. Alt+RMB to remove it.")]"

/obj/item/chastity/attackby(obj/item/I, mob/user, params)
	if(!istype(I, /obj/item/dildo))
		return ..()
	var/obj/item/dildo/held_dildo = I
	if(held_dildo.is_attached_to_belt)
		return
	if(attached_toy)
		to_chat(user, span_info("\The [initial(name)] already has a toy attached! Remove it first."))
		return
	if(!user.transferItemToLoc(held_dildo, null))
		to_chat(user, span_warning("\The [held_dildo] is stuck to your hand!"))
		return
	if(attach_toy(held_dildo, user))
		user.visible_message(span_warning("[user] equips \the [held_dildo] onto \the [initial(name)]."))

/obj/item/chastity/AltRightClick(mob/user)
	if(!attached_toy)
		return
	if(!isliving(user) || !user.TurfAdjacent(src))
		return
	if(user.get_active_held_item())
		to_chat(user, span_info("I can't do that with my hand full!"))
		return
	user.visible_message(span_warning("[user] removes \the [attached_toy] from \the [initial(name)]."))
	detach_toy(user)

/obj/item/chastity/update_icon()
	. = ..()
	if(attached_toy)
		var/matrix/M = new
		M.Scale(-0.8, -0.8)
		attached_toy.transform = M
		attached_toy.pixel_y = -6
		attached_toy.vis_flags = VIS_INHERIT_ID | VIS_INHERIT_LAYER | VIS_INHERIT_PLANE

/// Mounts a dildo onto this device. Fails if a toy is already present on the device OR if the
/// current wearer already has a belt-mounted toy (prevents two insertion sources stacking).
/// Sets is_attached_to_belt on the dildo, adds it to vis_contents, and refreshes overlays.
/obj/item/chastity/proc/attach_toy(obj/item/dildo/new_toy, mob/user)
	if(!new_toy || attached_toy || new_toy.is_attached_to_belt)
		return FALSE
	if(chastity_victim && istype(chastity_victim.belt, /obj/item/storage/belt/rogue))
		var/obj/item/storage/belt/rogue/worn_belt = chastity_victim.belt
		if(worn_belt.attached_toy)
			if(user)
				to_chat(user, span_warning("[chastity_victim] already has a toy attached to [chastity_victim.p_their()] belt."))
			return FALSE
	new_toy.is_attached_to_belt = TRUE
	attached_toy = new_toy
	vis_contents += attached_toy
	playsound(get_turf(user ? user : src), 'sound/foley/dropsound/food_drop.ogg', 40, TRUE, -1)
	update_icon()
	refresh_wearer_overlays()
	return TRUE

/// Removes the mounted dildo. Attempts to place it in the user's active hand first;
/// if that fails (hand full or no user), drops it at the device's location instead.
/obj/item/chastity/proc/detach_toy(mob/user)
	if(!attached_toy)
		return FALSE
	var/obj/item/dildo/dildo = attached_toy
	vis_contents -= dildo
	dildo.update_icon()
	dildo.is_attached_to_belt = FALSE
	attached_toy = null
	if(user && isliving(user) && !user.get_active_held_item() && user.put_in_hands(dildo))
		// moved to user hand above
	else
		dildo.forceMove(drop_location())
	update_icon()
	refresh_wearer_overlays()
	return TRUE

/obj/item/chastity/proc/refresh_wearer_overlays()
	if(!chastity_victim)
		return
	// Chastity bodypart visuals and belt-layer dildo overlay both need refreshes.
	chastity_victim.update_body_parts(TRUE)
	chastity_victim.update_inv_belt()

// Restricts caging to valid player-controlled humans and disallows transformed werewolves.
/obj/item/chastity/proc/can_cage_target(mob/living/carbon/human/H, mob/user)
	if(!H)
		return FALSE
	if(!H.mind)
		to_chat(user, span_warning("[H] cannot be fitted with a chastity device right now."))
		return FALSE
	if(istype(H, /mob/living/carbon/human/species/werewolf))
		to_chat(user, span_warning("[H]'s transformed body cannot be restrained by [src]."))
		return FALSE
	if(attached_toy && istype(H.belt, /obj/item/storage/belt/rogue))
		var/obj/item/storage/belt/rogue/worn_belt = H.belt
		if(worn_belt.attached_toy)
			to_chat(user, span_warning("[H] is already wearing a belt with an attached toy."))
			return FALSE
	return TRUE

// Verifies that the target has the genital configuration required by this device type.
/obj/item/chastity/proc/chastity_genital_check(mob/living/carbon/human/H) // check to see if cage target has the right genitals to wear the cage, cant wear an inverted dildo belt without a pussy
	if(chastity_organtype == 1 && !H.getorganslot(ORGAN_SLOT_PENIS))
		return FALSE
	if(chastity_organtype == 2 && !H.getorganslot(ORGAN_SLOT_VAGINA))
		return FALSE
	if(chastity_organtype == 3 && (!H.getorganslot(ORGAN_SLOT_PENIS) || !H.getorganslot(ORGAN_SLOT_VAGINA)))
		return FALSE
	return TRUE

// Creates and caches the bodypart feature object used to render/track equipped chastity.
/obj/item/chastity/proc/ensure_chastity_feature(mob/living/carbon/human/H)
	if(chastity_feature)
		return TRUE
	var/datum/bodypart_feature/chastity/chastity_new = new /datum/bodypart_feature/chastity()
	// Use the base accessory setter so we don't spawn a second hidden chastity item.
	call(chastity_new, /datum/bodypart_feature/proc/set_accessory_type)(sprite_acc, null, H)
	chastity_new.chastity_item = src
	chastity_feature = chastity_new
	return TRUE

// Attaches the prepared chastity bodypart feature to the chest bodypart.
/obj/item/chastity/proc/attach_chastity_feature(mob/living/carbon/human/H)
	var/obj/item/bodypart/chest = H.get_bodypart(BODY_ZONE_CHEST)
	if(!chest)
		return FALSE
	if(!chastity_feature)
		ensure_chastity_feature(H)
	chest.add_bodypart_feature(chastity_feature)
	return TRUE

// Finalizes equip bookkeeping by moving the item, assigning wearer refs, and movement jingle hooks.
/obj/item/chastity/proc/finalize_chastity_equip(mob/living/carbon/human/H)
	forceMove(H)
	H.chastity_device = src
	chastity_victim = H
	var/datum/component/intimate_action_guard/chastity/action_guard_component = LoadComponent(/datum/component/intimate_action_guard/chastity)
	if(action_guard_component)
		action_guard_component.bind_to_wearer(H)
	var/datum/component/intimate_reaction/chastity_receive_flavor/reaction_component = LoadComponent(/datum/component/intimate_reaction/chastity_receive_flavor)
	if(reaction_component)
		reaction_component.bind_to_wearer(H)
	register_wearer_jingle(H)
	refresh_chastity_mood_effects(H)
	refresh_wearer_overlays()

/// Returns TRUE if the wearer has hard mode enabled in their preferences.
/// Hard mode is an opt-in preference that makes the chastity device truly inescapable:
/// no master key, no lockpick, no hammer & chisel. Only the original generated key,
/// werewolf transformation destroying the device, or a catastrophic forced removal can free them.
/// Always call this before allowing any removal path other than the generated key.
/obj/item/chastity/proc/is_hardmode_active()
	return chastity_victim?.client?.prefs?.chastity_hardmode == CHASTITY_HARDMODE_ENABLED

/// Returns the appropriate lock-denial flavor string for this device.
/// Cursed devices get their own message; all other locked/hardmode devices use the generic denial.
/// Use this instead of repeating the ternary at every call site.
/obj/item/chastity/proc/get_lock_denial_string()
	return pick_chastity_string("chastity_lock_messages.json", chastity_cursed ? "chastity_cursed_lock" : "chastity_lock_denial")

/// Returns TRUE only if interaction_item is the exact persistent key object spawned for this device.
/// Reference-equality check — a copied key or a different key with the same lockhash will not pass.
/obj/item/chastity/proc/is_generated_unlock_key(obj/item/interaction_item)
	if(!interaction_item || !generated_key || QDELETED(generated_key))
		return FALSE
	return interaction_item == generated_key

/// Signal handler for COMSIG_CARBON_CHASTITY_LOCK_INTERACT.
/// Fired by any tool that attempts to interact with the chastity lock (lockpick, hammer & chisel, forced removal).
/// The lord key bypasses this signal entirely and calls is_hardmode_active() directly to avoid
/// a type mismatch (it attacks mobs, not the device itself).
/// Returns COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK to silently prevent the action if:
///   - the interaction is a removal (new_locked_state == FALSE)
///   - hard mode is active
///   - the item used is NOT the original generated key (or no item was used at all)
/// Locking is always permitted even in hard mode.
/obj/item/chastity/proc/on_chastity_lock_interact(datum/source, mob/user, obj/item/interaction_item, new_locked_state, method)
	SIGNAL_HANDLER
	if(source != chastity_victim)
		return
	if(!is_hardmode_active())
		return
	if(new_locked_state)
		return
	if(is_generated_unlock_key(interaction_item))
		return
	return COMPONENT_CHASTITY_LOCK_INTERACT_BLOCK

/// Syncs the generated key's name, desc, and hardmode_indestructible flag to match the current
/// wearer and hard mode state. Call this whenever the wearer changes or prefs are updated.
/// If hard mode just activated (was_hardmode_key was FALSE), notifies the holding user so they
/// understand the weight of what they're carrying before they walk away with it.
/obj/item/chastity/proc/sync_generated_key_metadata(mob/living/carbon/human/H, mob/user = null)
	if(!H || !generated_key || QDELETED(generated_key))
		return

	var/obj/item/roguekey/chastity/new_key = generated_key
	var/was_hardmode_key = new_key.hardmode_indestructible
	new_key.name = "[H]'s chastity key"
	new_key.desc = "A small key for [H]'s chastity device."
	new_key.hardmode_indestructible = FALSE

	if(is_hardmode_active())
		new_key.hardmode_indestructible = TRUE
		new_key.name = "[H]'s binding key"
		new_key.desc = "A small key bearing the mark of a permanent binding. [H]'s freedom rests in this metal."
		if(user && !was_hardmode_key)
			to_chat(user, span_warning("The key feels heavier than it should. [H]'s fate now rests in your hands."))

// Spawns a matching physical key at the equipping user's turf (non-cursed devices only).
// Reuses the cached generated_key if it still exists to survive re-equips without orphaning old keys.
// Cursed devices don't get keys — they are locked/unlocked exclusively through the collar master TGUI.
/obj/item/chastity/proc/generate_chastity_key(mob/user, mob/living/carbon/human/H)
	if(!user || !H)
		return
	var/obj/item/roguekey/chastity/new_key = generated_key
	if(!new_key || QDELETED(new_key))
		new_key = new(get_turf(user))
		new_key.lockhash = src.lockhash
		generated_key = new_key
	sync_generated_key_metadata(H, user)

// Applies baseline chastity traits according to configured chastity_type for standard devices.
/obj/item/chastity/proc/apply_standard_chastity_traits(mob/living/carbon/human/H)
	var/list/traits_to_apply = GLOB.chastity_standard_traits[chastity_type + 1]
	if(!islist(traits_to_apply))
		notify_chastity_state_change(H, "standard_traits_invalid")
		return

	for(var/trait_id in traits_to_apply)
		ADD_TRAIT(H, trait_id, TRAIT_SOURCE_CHASTITY)

	notify_chastity_state_change(H, "standard_traits_applied")

// Shared physical lock-state mutation path for keys and lockpicks.
/obj/item/chastity/proc/set_chastity_locked_state(mob/living/carbon/human/H, should_lock, mob/user = null, obj/item/interaction_item = null, interaction_source = "manual", state_change_reason = "")
	if(!H || H.chastity_device != src)
		return FALSE

	var/new_locked_state = !!should_lock
	var/old_locked_state = locked
	locked = new_locked_state

	if(new_locked_state)
		ADD_TRAIT(H, TRAIT_CHASTITY_LOCKED, TRAIT_SOURCE_CHASTITY)
	else
		REMOVE_TRAIT(H, TRAIT_CHASTITY_LOCKED, TRAIT_SOURCE_CHASTITY)

	if(old_locked_state == new_locked_state)
		return FALSE

	if(!length(state_change_reason))
		state_change_reason = "lock_changed_[interaction_source]"

	SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_LOCK_CHANGED, user, interaction_item, new_locked_state, interaction_source)
	notify_chastity_state_change(H, state_change_reason)
	to_chat(H, new_locked_state ? span_warning(pick_chastity_string("chastity_lock_messages.json", "chastity_lock_click")) : span_notice(pick_chastity_string("chastity_lock_messages.json", "chastity_unlock_click")))
	return TRUE

/// Fires COMSIG_CARBON_CHASTITY_STATE_CHANGED on the wearer so mood effects and cursed visuals
/// stay in sync after any trait or mode change. If the device is no longer the wearer's active
/// device (e.g. mid-removal), falls back to a direct refresh_chastity_mood_effects() call instead.
/obj/item/chastity/proc/notify_chastity_state_change(mob/living/carbon/human/H, reason = "")
	if(!H)
		return
	if(H.chastity_device == src)
		SEND_SIGNAL(H, COMSIG_CARBON_CHASTITY_STATE_CHANGED, src, reason)
		return
	refresh_chastity_mood_effects(H)

/// Returns TRUE if H has the Devotee virtue in either virtue slot.
/// Checked alongside patron_approves_chastity() to gate the chastity_devout mood bonus.
/obj/item/chastity/proc/has_devotee_virtue(mob/living/carbon/human/H)
	if(!H?.client?.prefs)
		return FALSE
	if(istype(H.client.prefs.virtue, /datum/virtue/combat/devotee))
		return TRUE
	if(istype(H.client.prefs.virtuetwo, /datum/virtue/combat/devotee))
		return TRUE
	return FALSE

/// Returns TRUE if H's patron would consider chastity virtuous.
/// Explicitly excluded: inhumen patrons (lust-aligned, consider chastity an affront) and Eora
/// (chastity conflicts with her domain). A null patron also returns FALSE — no patron, no blessing.
/obj/item/chastity/proc/patron_approves_chastity(mob/living/carbon/human/H)
	if(!H?.patron)
		return FALSE
	if(istype(H.patron, /datum/patron/inhumen))
		return FALSE
	if(istype(H.patron, /datum/patron/divine/eora))
		return FALSE
	return TRUE

/// Strips all chastity-related mood stresses from H. Called at the start of refresh_chastity_mood_effects()
/// and directly from remove_chastity() to guarantee a clean slate before re-evaluating or on unequip.
/obj/item/chastity/proc/clear_chastity_mood_effects(mob/living/carbon/human/H)
	if(!H)
		return
	H.remove_stress(/datum/stressevent/chastity_devout)
	H.remove_stress(/datum/stressevent/chastity_masochist)
	H.remove_stress(/datum/stressevent/chastity_church)
	H.remove_stress(/datum/stressevent/chastity_frustration)
	H.remove_stress(/datum/stressevent/chastity_flat_cramped)

// controls chastity mood events based on traits, flaws, and other character conditions. Called on equip/unequip and when relevant character conditions change (like patron or virtues).
/obj/item/chastity/proc/refresh_chastity_mood_effects(mob/living/carbon/human/H)
	if(!H)
		return

	clear_chastity_mood_effects(H)

	if(H.chastity_device != src)
		return

	if((H.has_flaw(/datum/charflaw/addiction/godfearing) || has_devotee_virtue(H)) && patron_approves_chastity(H))
		H.add_stress(/datum/stressevent/chastity_devout)

	if(H.has_flaw(/datum/charflaw/addiction/masochist) && HAS_TRAIT(H, TRAIT_CHASTITY_SPIKED))
		H.add_stress(/datum/stressevent/chastity_masochist)

	if(H.mind?.assigned_role in GLOB.church_positions)
		H.add_stress(/datum/stressevent/chastity_church)

	if(H.has_flaw(/datum/charflaw/addiction/lovefiend) || istype(H.patron, /datum/patron/inhumen/baotha))
		H.add_stress(/datum/stressevent/chastity_frustration)

	if(chastity_flat)
		var/obj/item/organ/penis/penis = H.getorganslot(ORGAN_SLOT_PENIS)
		if(penis?.penis_size >= DEFAULT_PENIS_SIZE)
			H.add_stress(/datum/stressevent/chastity_flat_cramped)
