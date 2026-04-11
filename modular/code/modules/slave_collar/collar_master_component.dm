/**
 * collar_master — mind-based component that lets a player act as a "master" over bound pets.
 *
 * Ownership model:
 *   - The component attaches to a /datum/mind, not a body. If the master mind body-swaps, the
 *     component travels with the mind and the verbs are re-added to the new body via _JoinParent/_RemoveFromParent.
 *   - my_pets: pets currently active under this master (have full signal hooks).
 *   - registered_pets: pets with at least the base attack-gate signal hooks wired up.
 *     In practice these are the same population; registered_pets is used to guard the explicit remove_pet path.
 *   - speech_altered_pets, denied_orgasm_pets: feature-state subsets. Membership ≠ ownership.
 *
 * Control items (collar vs. cursed chastity):
 *   - A pet is bound via either a /obj/item/clothing/neck/roguetown/cursed_collar OR a cursed
 *     /obj/item/chastity (chastity_cursed == TRUE). Both carry a collar_master/chastity_master mind ref.
 *   - get_pet_control_item() resolves whichever is present and stamps this mind onto it.
 *   - send_pet_gain_signal() fires the appropriate COMSIG (COMSIG_CARBON_GAIN_COLLAR or COMSIG_CARBON_GAIN_CHASTITY)
 *     so downstream listeners (inventory, trait hooks, etc.) stay consistent.
 *   - cleanup_pet() calls release_pet_control_item() which removes the item through the correct path
 *     without any O(n) global list scan.
 *
 * Pet lifecycle (add → signal → stabilize → cleanup):
 *   1. add_pet(): validates control item, commits to my_pets, registers signals, fires gain signal,
 *      queues two delayed stabilization pulses.
 *   2. verify_control_binding() / final_verify_binding(): deferred signal re-sends that guard against
 *      race conditions during equip/body transitions.
 *   3. cleanup_pet(): full teardown — signals, tracking lists, traits, listening state, timers,
 *      control item release, release feedback. Called on death or explicit release.
 *
 * Signal routing:
 *   - on_pet_say()      → intercepts COMSIG_MOB_SAY to replace speech with animal noises when altered.
 *   - on_pet_attack()   → gates COMSIG_MOB_ATTACK_HAND / COMSIG_ITEM_ATTACK to block harm-intent
 *                         attacks against the master and punish the attempt with collar shock.
 *   - on_pet_death()    → defers cleanup via addtimer to avoid signal re-entrancy during death handling.
 *   - relay_heard()     → forwards COMSIG_MOVABLE_HEAR from listened pet to master's chat.
 *   - relay_emote()     → forwards COMSIG_MOB_EMOTE from listened pet to master's chat.
 *
 * High-pop feedback suppression:
 *   - When GLOB.clients >= high_pop_suppression_cap (default 120), per-pet per-channel cooldowns
 *     are applied via high_pop_feedback_until to throttle arousal sounds, jitter, and messages.
 *   - high_pop_feedback_allowed() is the central gate; keys are "[REF(pet)]:[channel]".
 *
 * Cursed chastity command wrappers (lines ~928–1026):
 *   - toggle_* procs cycle state; set_* procs write directly (used by TGUI direct-state actions).
 *   - get_commandable_cursed_chastity() is the shared guard: validates pet, fires the COLLAR_COMMAND
 *     signal so listeners can block the action, then returns the device for the caller to act on.
 */
#define COLLAR_TRAIT "collar_master"
#define COLLAR_SURRENDER_TIME 10 SECONDS

GLOBAL_LIST_EMPTY(collar_masters)

/datum/status_effect/surrender/collar
	id = "collar_surrender"
	duration = COLLAR_SURRENDER_TIME
	alert_type = /atom/movable/screen/alert/status_effect/collar_surrender

/atom/movable/screen/alert/status_effect/collar_surrender
	name = "Forced Surrender"
	desc = "Your collar forces you to submit!"
	icon_state = "surrender"

/datum/component/collar_master
	// Invariants:
	// - my_pets contains pets currently considered under this master's control.
	// - registered_pets contains pets with the base collar-master signal hooks active.
	// - speech_altered_pets and denied_orgasm_pets are feature-state subsets, not ownership lists.
	// - listening_pet is the single current hearing/emote tap target.
	// - high_pop_feedback_until is a per-pet/per-channel suppression map used only for feedback throttling.
	var/datum/mind/mindparent
	var/list/my_pets = list()
	var/list/temp_selected_pets = list()
	var/listening = FALSE
	var/deny_orgasm = FALSE
	var/dominating = FALSE
	var/silenced = FALSE
	var/scrying = FALSE
	var/last_command_time = 0
	var/command_cooldown = 2 SECONDS
	/// Flavor text path for collar string banks. Kept as a file-local define to avoid global pollution.
	/// Full list entries live in modular/code/modules/slave_collar/strings/collar_flavor_text.json.
	var/static/list/pet_sounds = strings("collar_flavor_text.json", "collar_pet_sounds", "modular/code/modules/slave_collar/strings")
	var/static/list/arousal_messages = strings("collar_flavor_text.json", "collar_arousal_messages", "modular/code/modules/slave_collar/strings")
	var/list/registered_pets = list()
	var/list/speech_altered_pets = list()
	var/list/denied_orgasm_pets = list()
	var/mob/living/carbon/human/original_pet_body
	var/mob/living/carbon/human/original_master_body
	var/mob/living/carbon/human/listening_pet
	var/high_pop_suppression_cap = 120
	var/high_pop_feedback_cooldown = 5 SECONDS
	var/list/high_pop_feedback_until = list()

// Returns TRUE when server population is high enough to enable feedback suppression.
/datum/component/collar_master/proc/is_high_pop_suppressed()
	return (GLOB.clients?.len >= high_pop_suppression_cap)

// In high-pop mode, throttles repeat feedback channels per pet to reduce client spam.
/datum/component/collar_master/proc/high_pop_feedback_allowed(mob/living/carbon/human/pet, channel, cooldown = high_pop_feedback_cooldown)
	if(!pet || !channel)
		return FALSE
	if(!is_high_pop_suppressed())
		return TRUE

	var/key = "[REF(pet)]:[channel]"
	var/next_allowed = high_pop_feedback_until[key]
	if(next_allowed && world.time < next_allowed)
		return FALSE

	high_pop_feedback_until[key] = world.time + cooldown
	return TRUE

// --- Component lifecycle ---

// Initialize component state for this master and register in global tracking.
/datum/component/collar_master/Initialize(...)
	. = ..()
	mindparent = parent
	GLOB.collar_masters += mindparent

// Cleanup hook: release all registered pets and remove master from global tracking.
/datum/component/collar_master/Destroy(force, silent)
	. = ..()
	for(var/pet in my_pets)
		cleanup_pet(pet)
	GLOB.collar_masters -= mindparent

// --- Pet binding and stabilization ---

// Resolves the control item currently binding this pet and stamps master ownership onto it.
/datum/component/collar_master/proc/get_pet_control_item(mob/living/carbon/human/pet)
	if(!pet)
		return null

	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(SLOT_NECK)
	var/obj/item/chastity/chastity = pet.chastity_device
	var/obj/item/control_item

	if(istype(collar))
		control_item = collar
		collar.collar_master = mindparent
		if(!collar.collar_master)
			return null
	else if(istype(chastity) && chastity.chastity_cursed)
		control_item = chastity
		chastity.chastity_master = mindparent
		if(!chastity.chastity_master)
			return null

	return control_item

// Returns a user-facing name for the active control item type.
/datum/component/collar_master/proc/get_control_item_name(obj/item/control_item)
	return istype(control_item, /obj/item/clothing/neck/roguetown/cursed_collar) ? "collar" : "chastity device"

// Returns the controlling mind stamped onto a collar or cursed chastity item.
/datum/component/collar_master/proc/get_control_item_master(obj/item/control_item)
	if(istype(control_item, /obj/item/clothing/neck/roguetown/cursed_collar))
		var/obj/item/clothing/neck/roguetown/cursed_collar/collar = control_item
		return collar.collar_master
	if(istype(control_item, /obj/item/chastity))
		var/obj/item/chastity/chastity = control_item
		return chastity.chastity_master
	return null

// Sends the correct control gain signal for the pet's active control item.
/datum/component/collar_master/proc/send_pet_gain_signal(mob/living/carbon/human/pet, obj/item/control_item)
	if(!pet || !control_item)
		return FALSE
	if(istype(control_item, /obj/item/clothing/neck/roguetown/cursed_collar))
		SEND_SIGNAL(pet, COMSIG_CARBON_GAIN_COLLAR, control_item)
	else
		SEND_SIGNAL(pet, COMSIG_CARBON_GAIN_CHASTITY, control_item)
	return TRUE

// Queues the delayed post-bind feedback and verification pulses without changing existing timing.
/datum/component/collar_master/proc/queue_binding_stabilization(mob/living/carbon/human/pet, obj/item/control_item)
	if(!pet || !control_item)
		return FALSE
	addtimer(CALLBACK(src, PROC_REF(give_control_feedback), pet, control_item), 0.1 SECONDS)
	addtimer(CALLBACK(src, PROC_REF(verify_control_binding), pet, control_item), 0.2 SECONDS)
	return TRUE

// Registers attack-related control signals for a pet.
/datum/component/collar_master/proc/register_pet(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	// Use existing signals from the dominated component
	RegisterSignal(pet, list(
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
		COMSIG_ITEM_ATTACK,
		COMSIG_LIVING_ATTACKED_BY
	), PROC_REF(on_pet_attack))

	return TRUE

// Registers a pet under this master and binds control source (collar or cursed chastity).
/datum/component/collar_master/proc/add_pet(mob/living/carbon/human/pet)
	if(!pet || (pet in my_pets))
		return FALSE

	var/obj/item/control_item = get_pet_control_item(pet)
	if(!control_item)
		return FALSE

	// Commit pet registration only after control source is validated.
	my_pets += pet
	registered_pets += pet

	// Register all signals including attack signals
	RegisterSignal(pet, COMSIG_MOB_SAY, PROC_REF(on_pet_say))
	RegisterSignal(pet, COMSIG_MOB_DEATH, PROC_REF(on_pet_death))

	register_pet(pet)
	send_pet_gain_signal(pet, control_item)
	queue_binding_stabilization(pet, control_item)

	return TRUE

// Sends post-bind flavor feedback to both pet and master.
/datum/component/collar_master/proc/give_control_feedback(mob/living/carbon/human/pet, obj/item/control_item)
	if(!pet || !(pet in my_pets))
		return
	var/item_name = get_control_item_name(control_item)
	to_chat(pet, span_notice("The [item_name] tightens as it recognizes its master!"))
	to_chat(parent, span_notice("You feel the [item_name] bind to [pet]'s will."))

// Validates final control binding and re-emits gain signal to ensure listeners are synchronized.
/datum/component/collar_master/proc/verify_control_binding(mob/living/carbon/human/pet, obj/item/control_item)
	if(!pet || !control_item)
		return

	var/datum/mind/master = get_control_item_master(control_item)
	if(!master)
		return

	// Prevent self-control
	var/mob/master_mob = master.current
	if(pet == master_mob)
		var/item_name = get_control_item_name(control_item)
		to_chat(pet, span_warning("The [item_name] refuses to bind."))
		pet.dropItemToGround(control_item, force = TRUE)
		return FALSE

	var/item_name = get_control_item_name(control_item)
	to_chat(pet, span_notice("Your [item_name] pulses, reinforcing your master's control..."))
	send_pet_gain_signal(pet, control_item)
	addtimer(CALLBACK(src, PROC_REF(final_verify_binding), pet, control_item), 0.2 SECONDS)

// Final delayed signal pulse for robustness after equip/bind transitions.
/datum/component/collar_master/proc/final_verify_binding(mob/living/carbon/human/pet, obj/item/control_item)
	if(!pet || !control_item)
		return

	var/datum/mind/master = get_control_item_master(control_item)
	if(!master)
		return

	send_pet_gain_signal(pet, control_item)

// Speech interception: swaps normal speech for pet noises when alteration is active.
/datum/component/collar_master/proc/on_pet_say(datum/source, list/speech_args)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets))
		return

	if(pet in speech_altered_pets)
		speech_args[SPEECH_MESSAGE] = ""  // Clear the speech message
		var/emote_text = pick(pet_sounds)
		emote_text = replacetext(emote_text, "*", "") // Remove asterisk
		pet.visible_message(span_emote("<b>[pet]</b> [emote_text]"))
		return COMPONENT_CANCEL_SAY

// Utility emote helper for simple pet noise output.
/datum/component/collar_master/proc/do_pet_emote(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return
	pet.emote("me", EMOTE_VISIBLE, pick(pet_sounds))

// --- Release and cleanup ---

// Death hook: defers cleanup to avoid signal re-entrancy issues during death handling.
/datum/component/collar_master/proc/on_pet_death(datum/source)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets))
		return
	addtimer(CALLBACK(src, PROC_REF(cleanup_pet), pet), 0.1 SECONDS)

// Unregisters the base signal hooks used by the explicit remove path.
/datum/component/collar_master/proc/unregister_pet_base_signals(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE

	UnregisterSignal(pet, list(
		COMSIG_MOB_SAY,
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_ITEM_ATTACK,
		COMSIG_LIVING_ATTACKED_BY
	))

	return TRUE

// Explicit pet removal path: unregister active signals, then cleanup state.
/datum/component/collar_master/proc/remove_pet(mob/living/carbon/human/pet)
	if(!pet || !(pet in registered_pets))
		return FALSE

	unregister_pet_base_signals(pet)
	registered_pets -= pet
	cleanup_pet(pet)
	return TRUE

// Attack gate: blocks harm intent attacks against master and optionally punishes pet.
/datum/component/collar_master/proc/on_pet_attack(datum/source, atom/target)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets))
		return

	// Block attacks against the master only if on harm intent
	if(target == mindparent?.current && pet.used_intent.type == INTENT_HARM)
		to_chat(pet, span_warning("Your collar shocks you as you try to attack your master!"))
		INVOKE_ASYNC(src, PROC_REF(shock_pet), pet, 10)
		return COMPONENT_CANCEL_ATTACK

// Applies collar shock effects (damage/stamina/feedback) at configurable intensity.
/datum/component/collar_master/proc/shock_pet(mob/living/carbon/human/pet, intensity = 10)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(SEND_SIGNAL(pet, COMSIG_CARBON_COLLAR_COMMAND, src, COLLAR_COMMAND_SHOCK, intensity) & COMPONENT_COLLAR_COMMAND_BLOCK)
		return FALSE

	// Calculate damage based on intensity
	var/damage = intensity * 0.5

	// Apply damage and effects
	pet.adjustFireLoss(damage)
	pet.adjustStaminaLoss(intensity * 2)
	pet.Knockdown(intensity * 0.2 SECONDS)
	pet.do_jitter_animation(intensity)

	// Visual effects
	pet.visible_message(span_danger("[pet]'s collar crackles with electricity!"), \
					   span_userdanger("Your collar sends searing pain through your body!"))

	var/turf/T = get_turf(pet)
	if(T)
		new /obj/effect/temp_visual/cult/sparks(T)
		playsound(T, list('sound/items/stunmace_hit (1).ogg','sound/items/stunmace_hit (2).ogg'), 50, TRUE)
		do_sparks(2, FALSE, pet)

	// Add a temporary overlay effect
	pet.flash_fullscreen("redflash3")
	addtimer(CALLBACK(pet, TYPE_PROC_REF(/mob/living, clear_fullscreen), "pain"), 2 SECONDS)
	log_collar_command(pet, COLLAR_LOG_SHOCK, "intensity=[intensity] damage=[damage]")

	return TRUE

// UI helper to choose one or multiple valid online pets for a command.
/datum/component/collar_master/proc/select_pets(mob/user, action_name = "", allow_multiple = FALSE)
	var/list/valid_pets = list()
	for(var/mob/living/carbon/human/pet in my_pets)
		if(!pet || !pet.mind || !pet.client)
			continue
		valid_pets += pet

	if(!length(valid_pets))
		return list()

	if(allow_multiple)
		var/list/selected = input(user, "Choose pets to [action_name]:", "Pet Selection") as null|anything in valid_pets
		return selected ? selected : list()
	else
		var/mob/living/carbon/human/selected = input(user, "Choose a pet to [action_name]:", "Pet Selection") as null|anything in valid_pets
		return selected ? list(selected) : list()

// Toggles master listening relay through a specific pet's sensory channel.
/datum/component/collar_master/proc/toggle_listening(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	if(listening_pet == pet)
		UnregisterSignal(pet, list(COMSIG_MOVABLE_HEAR, COMSIG_MOB_EMOTE))
		listening = FALSE
		listening_pet = null
		to_chat(mindparent.current, span_notice("You stop listening through [pet]'s collar."))
		to_chat(pet, span_notice("Your collar relaxes as your master stops listening."))
		return TRUE

	if(listening_pet)
		UnregisterSignal(listening_pet, list(COMSIG_MOVABLE_HEAR, COMSIG_MOB_EMOTE))

	listening = TRUE
	listening_pet = pet

	if(listening_pet)
		// Add master to pet's message viewers
		RegisterSignal(pet, COMSIG_MOVABLE_HEAR, PROC_REF(relay_heard))
		RegisterSignal(pet, COMSIG_MOB_EMOTE, PROC_REF(relay_emote))
		to_chat(mindparent.current, span_notice("You start listening through [pet]'s collar."))
		to_chat(pet, span_warning("Your collar tingles as your master listens through your ears!"))

	return TRUE

// Relays heard speech text from listened pet to master.
/datum/component/collar_master/proc/relay_heard(datum/source, list/hearing_args)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets) || !listening || pet != listening_pet)
		return

	var/message = hearing_args[HEARING_MESSAGE]
	if(message)
		to_chat(mindparent.current, span_notice("<i>Through [pet]'s collar: [message]</i>"))

// Relays emote output from listened pet to master.
/datum/component/collar_master/proc/relay_emote(datum/source, emote_key, emote_message)
	SIGNAL_HANDLER
	var/mob/living/carbon/human/pet = source
	if(!pet || !(pet in my_pets) || !listening || pet != listening_pet)
		return

	if(emote_message)
		to_chat(mindparent.current, span_notice("<i>Through [pet]'s collar: [pet] [emote_message]</i>"))

// Forces pet to drop held items as part of a strip command.
/datum/component/collar_master/proc/force_strip(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(SEND_SIGNAL(pet, COMSIG_CARBON_COLLAR_COMMAND, src, COLLAR_COMMAND_FORCE_STRIP, null) & COMPONENT_COLLAR_COMMAND_BLOCK)
		return FALSE

	pet.drop_all_held_items()
	for(var/obj/item/I in pet.get_equipped_items())
		if(istype(I, /obj/item/chastity))
			continue
		if(!(I.slot_flags & ITEM_SLOT_NECK))
			pet.dropItemToGround(I, TRUE)
	to_chat(pet, span_userdanger("Your collar tingles as it forces you to remove your clothing!"))
	pet.visible_message(span_warning("[pet]'s collar pulses with light as they frantically strip their clothing!"))
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	log_collar_command(pet, COLLAR_LOG_FORCE_STRIP)
	return TRUE

// Toggles hallucination trauma effect for controlled pet.
/datum/component/collar_master/proc/toggle_hallucinations(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	var/hallucinations_enabled = !pet.has_trauma_type(/datum/brain_trauma/mild/hallucinations)
	if(!hallucinations_enabled)
		pet.cure_trauma_type(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
		to_chat(pet, span_notice("Your collar pulses and the world becomes clearer."))
	else
		pet.gain_trauma(/datum/brain_trauma/mild/hallucinations, TRAUMA_RESILIENCE_BASIC)
		to_chat(pet, span_warning("Your collar pulses and the world begins to shift and warp!"))
		pet.do_jitter_animation(20)
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	log_collar_command(pet, COLLAR_LOG_HALLUCINATIONS, "enabled=[hallucinations_enabled]")
	return TRUE

// Sends direct illusion text feedback to a pet.
/datum/component/collar_master/proc/create_illusion(mob/living/carbon/human/pet, message)
	if(!pet || !(pet in my_pets))
		return FALSE

	to_chat(pet, span_warning("<b>Collar Illusion:</b> [message]"))
	pet.do_jitter_animation(20)
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	return TRUE

// Forces a visible emote action on pet.
/datum/component/collar_master/proc/force_emote(mob/living/carbon/human/pet, emote_text)
	if(!pet || !(pet in my_pets))
		return FALSE

	pet.emote("me", EMOTE_VISIBLE, emote_text)
	return TRUE

// Transfers a portion of master's damage/blood deficit to pet.
/datum/component/collar_master/proc/share_damage(mob/living/carbon/human/pet, mob/living/carbon/human/master)
	if(!pet || !(pet in my_pets) || !master)
		return FALSE

	var/total_damage = master.getBruteLoss() + master.getFireLoss() + master.getOxyLoss()
	if(total_damage <= 0)
		return FALSE

	var/damage_share = total_damage * 0.5
	pet.adjustBruteLoss(damage_share)
	master.adjustBruteLoss(-damage_share)

	// Share blood if applicable
	if(master.blood_volume && pet.blood_volume)
		var/blood_diff = BLOOD_VOLUME_NORMAL - master.blood_volume
		if(blood_diff > 0)
			var/blood_share = min(blood_diff * 0.5, pet.blood_volume - BLOOD_VOLUME_SAFE)
			if(blood_share > 0)
				pet.blood_volume -= blood_share
				master.blood_volume += blood_share

	return TRUE

// Applies surrender control package (stun/status/visuals) to a pet.
/datum/component/collar_master/proc/force_surrender(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(SEND_SIGNAL(pet, COMSIG_CARBON_COLLAR_COMMAND, src, COLLAR_COMMAND_FORCE_SURRENDER, null) & COMPONENT_COLLAR_COMMAND_BLOCK)
		return FALSE

	if(pet.stat >= UNCONSCIOUS)
		return FALSE

	if(pet.surrendering)
		return FALSE

	pet.surrendering = TRUE
	pet.toggle_cmode()
	pet.changeNext_move(CLICK_CD_EXHAUSTED)

	// Create and attach the surrender flag visual
	var/obj/effect/temp_visual/surrender/flaggy = new(pet)
	pet.vis_contents += flaggy

	// Apply stun and status effects
	pet.Stun(300)
	pet.Knockdown(300)
	pet.apply_status_effect(/datum/status_effect/debuff/breedable)
	pet.apply_status_effect(/datum/status_effect/debuff/submissive)

	// Visual and sound effects
	pet.visible_message(span_warning("[pet] is forced to surrender by their collar!"), \
					   span_userdanger("Your collar forces you to submit!"))
	playsound(pet, 'sound/misc/surrender.ogg', 100, FALSE, -1, ignore_walls=TRUE)

	pet.update_vision_cone()
	addtimer(CALLBACK(pet, TYPE_PROC_REF(/mob/living, end_submit)), 600)
	log_collar_command(pet, COLLAR_LOG_SURRENDER)

	return TRUE

// Toggles periodic arousal forcing loop for a pet.
/datum/component/collar_master/proc/toggle_arousal(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(SEND_SIGNAL(pet, COMSIG_CARBON_COLLAR_COMMAND, src, COLLAR_COMMAND_TOGGLE_AROUSAL, null) & COMPONENT_COLLAR_COMMAND_BLOCK)
		return FALSE

	var/loop_id = "force_arousal_[REF(pet)]"
	if(isnull(pet.active_timers))
		pet.active_timers = list()
	if(!(loop_id in pet.active_timers))
		pet.active_timers[loop_id] = null

	// Check if arousal is already being forced
	if(pet.active_timers[loop_id])
		var/timer_id = pet.active_timers[loop_id]
		if(timer_id)
			deltimer(timer_id)
		pet.active_timers[loop_id] = null
		pet.clear_fullscreen("love")
		to_chat(pet, span_notice("The waves of arousal from your collar subside..."))
		log_collar_command(pet, COLLAR_LOG_AROUSAL, "enabled=FALSE")
		return TRUE

	// Start arousal loop
	var/amount_per_tick = 5
	pet.active_timers[loop_id] = TRUE
	arousal_tick(pet, amount_per_tick, loop_id)
	pet.flash_fullscreen("love", /atom/movable/screen/fullscreen/love)

	// Visual feedback
	to_chat(pet, span_userdanger("Your collar sends waves of arousal through your body!"))
	pet.do_jitter_animation(20)
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	log_collar_command(pet, COLLAR_LOG_AROUSAL, "enabled=TRUE")

	return TRUE

// Per-tick arousal loop body: applies effects and reschedules while active.
/datum/component/collar_master/proc/arousal_tick(mob/living/carbon/human/pet, amount_per_tick, loop_id)
	if(!pet)
		return

	// If toggle was turned off, stop rescheduling.
	if(!pet.active_timers || !(loop_id in pet.active_timers) || isnull(pet.active_timers[loop_id]))
		return

	if(!pet.sexcon)
		pet.sexcon = new /datum/sex_controller(pet)

	var/high_pop_mode = is_high_pop_suppressed()

	pet.sexcon.adjust_arousal(amount_per_tick)
	if(!high_pop_mode || high_pop_feedback_allowed(pet, "arousal_fullscreen", 2 SECONDS))
		pet.flash_fullscreen("love", /atom/movable/screen/fullscreen/love)

	// Visual feedback each tick
	if(!high_pop_mode || high_pop_feedback_allowed(pet, "arousal_message", 4 SECONDS))
		to_chat(pet, span_love(pick(arousal_messages)))
	if(!high_pop_mode || high_pop_feedback_allowed(pet, "arousal_jitter", 3 SECONDS))
		pet.do_jitter_animation(10)

	// Sound effects based on arousal level
	if(prob(10) && (!high_pop_mode || high_pop_feedback_allowed(pet, "arousal_sound", 6 SECONDS)))  // 10% chance each tick to make a sound
		var/current_arousal = pet.sexcon.arousal
		if(current_arousal > 60)
			playsound(pet, pick('sound/vo/female/gen/se/sex (1).ogg',
							  'sound/vo/female/gen/se/sex (2).ogg',
							  'sound/vo/female/gen/se/sex (3).ogg',
							  'sound/vo/female/gen/se/sex (4).ogg',
							  'sound/vo/female/gen/se/sex (5).ogg',
							  'sound/vo/female/gen/se/sex (6).ogg',
							  'sound/vo/female/gen/se/sex (7).ogg'), 50, TRUE)
			pet.emote("moan")
		else if(current_arousal > 10)
			playsound(pet, pick('sound/vo/female/gen/se/sexlight (1).ogg',
							  'sound/vo/female/gen/se/sexlight (2).ogg',
							  'sound/vo/female/gen/se/sexlight (3).ogg',
							  'sound/vo/female/gen/se/sexlight (4).ogg',
							  'sound/vo/female/gen/se/sexlight (5).ogg',
							  'sound/vo/female/gen/se/sexlight (6).ogg',
							  'sound/vo/female/gen/se/sexlight (7).ogg'), 50, TRUE)
			pet.emote("whimper")

	// Continue loop
	pet.active_timers[loop_id] = addtimer(CALLBACK(src, PROC_REF(arousal_tick), pet, amount_per_tick, loop_id), 1 SECONDS, TIMER_STOPPABLE)

// Flavor/feedback command to induce affection.
/datum/component/collar_master/proc/force_love(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	// Apply love effects
	pet.emote("blush")
	to_chat(pet, span_love("Your collar fills you with overwhelming affection!"))
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	log_collar_command(pet, COLLAR_LOG_LOVE)
	return TRUE

// Toggles clothing permission by adding/removing nudist enforcement trait.
/datum/component/collar_master/proc/permit_clothing(mob/living/carbon/human/pet, permitted = TRUE)
	if(!pet || !(pet in my_pets))
		return FALSE

	if(permitted)
		REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
		to_chat(pet, span_notice("Your collar hums softly as your master grants you permission to wear clothing."))
		pet.visible_message(span_notice("[pet]'s collar glows briefly as they are permitted to dress."))
	else
		ADD_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
		to_chat(pet, span_notice("Your collar hums softly as your master denies you permission to put clothing on."))
		pet.visible_message(span_notice("[pet]'s collar glows briefly as they are forbidden to dress."))
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	log_collar_command(pet, COLLAR_LOG_CLOTHING, "permitted=[permitted]")
	return TRUE

// Builds status text summary for a selected pet.
/datum/component/collar_master/proc/check_pet_status(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	var/status_text = "<span class='notice'><b>[pet.real_name] Status:</b>\n"
	status_text += "Condition: [pet.get_damage_condition_summary()]\n"
	status_text += "Location: [get_area(pet)]\n"
	status_text += "Mental State: [pet.stat >= UNCONSCIOUS ? "Unconscious" : "Conscious"]\n"
	status_text += "Active Traits: "

	var/list/active_traits = list()
	if(pet in speech_altered_pets)
		active_traits += "Speech Altered"
	if(pet in denied_orgasm_pets)
		active_traits += "Orgasm Denial"
	if(pet == listening_pet)
		active_traits += "Listening Link"

	status_text += active_traits.len ? english_list(active_traits) : "None"
	status_text += "</span>"

	return status_text

// Batch-dispatch helper used by mass commands targeting multiple pets.
/datum/component/collar_master/proc/mass_command(command_type, list/targets, ...)
	if(!length(targets))
		return FALSE

	var/success_count = 0
	for(var/mob/living/carbon/human/pet in targets)
		if(!pet || !(pet in my_pets))
			continue

		switch(command_type)
			if("shock")
				var/intensity = args[1]
				if(shock_pet(pet, intensity))
					success_count++
			if("surrender")
				if(force_surrender(pet))
					success_count++
			if("strip")
				if(force_strip(pet))
					success_count++
			if("arousal")
				if(toggle_arousal(pet))
					success_count++
			if("love")
				if(force_love(pet))
					success_count++
			if("hallucinate")
				if(toggle_hallucinations(pet))
					success_count++

	return success_count

// Adds context-specific examine output depending on observer identity.
/datum/component/collar_master/proc/on_pet_examine(mob/living/carbon/human/pet, mob/user)
	if(!pet || !(pet in my_pets))
		return

	if(user == mindparent?.current)
		to_chat(user, span_notice("\nThe collar recognizes you as [pet.real_name]'s master. Use Collar Control for live status."))
	else if(user != pet)
		to_chat(user, span_warning("\nThey wear a strange collar around their neck."))

// Releases all pet-facing signal hooks used during cleanup.
/datum/component/collar_master/proc/cleanup_pet_signals(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE

	UnregisterSignal(pet, list(
		COMSIG_MOB_SAY,
		COMSIG_MOB_DEATH,
		COMSIG_HUMAN_MELEE_UNARMED_ATTACK,
		COMSIG_MOB_ATTACK_HAND,
		COMSIG_ITEM_ATTACK,
		COMSIG_LIVING_ATTACKED_BY,
		COMSIG_MOVABLE_HEAR,
		COMSIG_MOB_EMOTE
	))

	return TRUE

// Removes per-pet throttling keys and side-list membership.
/datum/component/collar_master/proc/cleanup_pet_tracking(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE

	var/pet_key_prefix = "[REF(pet)]:"
	for(var/key in high_pop_feedback_until)
		if(findtext(key, pet_key_prefix) == 1)
			high_pop_feedback_until -= key

	my_pets -= pet
	registered_pets -= pet
	speech_altered_pets -= pet
	denied_orgasm_pets -= pet
	return TRUE

// Removes persistent collar-applied traits from a pet.
/datum/component/collar_master/proc/cleanup_pet_traits(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE
	REMOVE_TRAIT(pet, TRAIT_NUDIST, COLLAR_TRAIT)
	return TRUE

// Clears the currently active listening tap target if it matches this pet.
/datum/component/collar_master/proc/cleanup_pet_listening_state(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE
	if(pet == listening_pet)
		UnregisterSignal(pet, list(COMSIG_MOVABLE_HEAR, COMSIG_MOB_EMOTE))
		listening_pet = null
		listening = FALSE
	return TRUE

// Cancels active denial/arousal timers and clears any persistent fullscreen state.
/datum/component/collar_master/proc/cleanup_pet_timers(mob/living/carbon/human/pet)
	if(!pet || isnull(pet.active_timers))
		return FALSE

	var/deny_loop = "deny_orgasm_[REF(pet)]"
	if(deny_loop in pet.active_timers)
		var/deny_timer = pet.active_timers[deny_loop]
		if(deny_timer)
			deltimer(deny_timer)
		pet.active_timers[deny_loop] = null

	var/arousal_loop = "force_arousal_[REF(pet)]"
	if(arousal_loop in pet.active_timers)
		var/arousal_timer = pet.active_timers[arousal_loop]
		if(isnum(arousal_timer) && arousal_timer)
			deltimer(arousal_timer)
		pet.active_timers[arousal_loop] = null
		pet.clear_fullscreen("love")

	return TRUE

// Releases the active collar or cursed chastity item tied to this pet.
/datum/component/collar_master/proc/release_pet_control_item(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE

	var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(SLOT_NECK)
	if(istype(collar))
		SEND_SIGNAL(pet, COMSIG_CARBON_LOSE_COLLAR)
		pet.dropItemToGround(collar, force = TRUE)
		REMOVE_TRAIT(collar, TRAIT_NODROP, CURSED_ITEM_TRAIT)

	var/obj/item/chastity/device = pet.chastity_device
	if(istype(device) && device.chastity_cursed && device.chastity_master == mindparent)
		device.remove_chastity(pet)
		if(!QDELETED(device))
			device.forceMove(get_turf(pet))

	return TRUE

// Sends the standardized release feedback after all teardown work is complete.
/datum/component/collar_master/proc/send_pet_release_feedback(mob/living/carbon/human/pet)
	if(!pet)
		return FALSE
	SEND_SIGNAL(pet, COMSIG_CARBON_COLLAR_RELEASED, src)
	to_chat(pet, span_notice("Your mind clears as the collar's control fades!"))
	if(mindparent.current)
		to_chat(mindparent.current, span_warning("[pet] is no longer under your control!"))
	return TRUE

// Centralized pet cleanup: traits, timers, listening links, and control-item release.
/datum/component/collar_master/proc/cleanup_pet(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	cleanup_pet_signals(pet)
	cleanup_pet_tracking(pet)
	cleanup_pet_traits(pet)
	cleanup_pet_listening_state(pet)
	cleanup_pet_timers(pet)
	release_pet_control_item(pet)
	send_pet_release_feedback(pet)

	return TRUE

// Adds master control verbs to owner mob when component is attached.
/datum/component/collar_master/_JoinParent()
	. = ..()
	if(mindparent?.current)
		mindparent.current.verbs += list(
			/mob/proc/collar_master_control_ui,
			/mob/proc/collar_master_help,
			/mob/proc/collar_master_releaseall
		)

// Removes master control verbs when component is detached.
/datum/component/collar_master/_RemoveFromParent()
	if(mindparent?.current)
		mindparent.current.verbs -= list(
			/mob/proc/collar_master_control_ui,
			/mob/proc/collar_master_help,
			/mob/proc/collar_master_releaseall
		)
	. = ..()

// Transfers a broad portion of master's suffering state to pet as punishment/support mechanic.
/datum/component/collar_master/proc/pass_wounds(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE

	var/mob/living/carbon/human/master = mindparent?.current
	if(!master)
		return FALSE

	// Pass all damage types
	pet.adjustBruteLoss(master.getBruteLoss() * 0.5)
	pet.adjustFireLoss(master.getFireLoss() * 0.5)
	pet.adjustOxyLoss(master.getOxyLoss() * 0.5)

	// Pass blood level if it exists
	if(pet.blood_volume && master.blood_volume)
		pet.blood_volume = max(BLOOD_VOLUME_SAFE, pet.blood_volume - (BLOOD_VOLUME_NORMAL - master.blood_volume) * 0.5)

	// Pass organ damage
	for(var/obj/item/organ/organ in master.internal_organs)
		var/obj/item/organ/matching_organ = pet.getorganslot(organ.slot)
		if(matching_organ && organ.damage > 0)
			matching_organ.applyOrganDamage(organ.damage * 0.5)

	pet.updatehealth()
	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	to_chat(pet, span_userdanger("Your collar burns as your master's suffering flows into you!"))
	pet.visible_message(span_warning("[pet] shudders as [master]'s wounds manifest on their body!"))
	pet.do_jitter_animation(20)

	// Heal the master slightly
	master.adjustBruteLoss(-10)
	master.adjustFireLoss(-10)
	master.adjustOxyLoss(-10)

	return TRUE

// --- Pet state / punishment toggles ---

// Toggles speech alteration state for one pet.
/datum/component/collar_master/proc/toggle_speech(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(SEND_SIGNAL(pet, COMSIG_CARBON_COLLAR_COMMAND, src, COLLAR_COMMAND_TOGGLE_SPEECH, null) & COMPONENT_COLLAR_COMMAND_BLOCK)
		return FALSE

	if(pet in speech_altered_pets)
		speech_altered_pets -= pet
		to_chat(mindparent.current, span_notice("You return [pet]'s speech to normal."))
		to_chat(pet, span_notice("Your collar relaxes - you can speak normally again."))
	else
		speech_altered_pets += pet
		to_chat(mindparent.current, span_notice("You alter [pet]'s speech to animal sounds."))
		to_chat(pet, span_warning("Your collar tingles - you find yourself only able to make animal noises!"))

	playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
	log_collar_command(pet, COLLAR_LOG_SPEECH, "altered=[pet in speech_altered_pets]")
	return TRUE

// Toggles orgasm denial loop for a pet.
/datum/component/collar_master/proc/toggle_denial(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	if(SEND_SIGNAL(pet, COMSIG_CARBON_COLLAR_COMMAND, src, COLLAR_COMMAND_TOGGLE_DENIAL, null) & COMPONENT_COLLAR_COMMAND_BLOCK)
		return FALSE

	if(isnull(pet.active_timers))
		pet.active_timers = list()

	var/loop_id = "deny_orgasm_[REF(pet)]"
	if(!(loop_id in pet.active_timers))
		pet.active_timers[loop_id] = null

	if(pet in denied_orgasm_pets)
		denied_orgasm_pets -= pet
		var/timer_id = pet.active_timers[loop_id]
		if(timer_id)
			deltimer(timer_id)
		pet.active_timers[loop_id] = null
		to_chat(pet, span_notice("Your collar loosens - you feel like you can finish again!"))
		log_collar_command(pet, COLLAR_LOG_DENIAL, "enabled=FALSE")
	else
		denied_orgasm_pets += pet
		// Start a loop to monitor and cap arousal
		pet.active_timers[loop_id] = addtimer(CALLBACK(src, PROC_REF(cap_arousal), pet, loop_id), 1 SECONDS, TIMER_STOPPABLE | TIMER_LOOP)
		to_chat(pet, span_warning("Your collar tightens - you feel like you won't be able to finish!"))
		log_collar_command(pet, COLLAR_LOG_DENIAL, "enabled=TRUE")
	return TRUE

// Loop callback that clamps arousal ceiling while denial is active.
/datum/component/collar_master/proc/cap_arousal(mob/living/carbon/human/pet, loop_id)
	if(!pet?.sexcon || !(pet in denied_orgasm_pets) || !pet.active_timers || !(loop_id in pet.active_timers) || isnull(pet.active_timers[loop_id]))
		return

	if(pet.sexcon.arousal > 90)
		pet.sexcon.arousal = 90
		if(high_pop_feedback_allowed(pet, "denial_message", 8 SECONDS))
			to_chat(pet, span_warning("Your collar prevents you from reaching climax!"))

// --- Cursed chastity command wrappers ---

// Returns pet's currently equipped cursed chastity device, if present.
/datum/component/collar_master/proc/get_pet_cursed_chastity(mob/living/carbon/human/pet)
	if(!pet)
		return null
	var/obj/item/chastity/device = pet.chastity_device
	if(!istype(device) || !device.chastity_cursed)
		return null
	return device

// Shared direct-command guard for cursed chastity state setters.
/datum/component/collar_master/proc/get_commandable_cursed_chastity(mob/living/carbon/human/pet, command_id, command_arg)
	if(!pet || !(pet in my_pets))
		return null
	if(SEND_SIGNAL(pet, COMSIG_CARBON_COLLAR_COMMAND, src, command_id, command_arg) & COMPONENT_COLLAR_COMMAND_BLOCK)
		return null
	return get_pet_cursed_chastity(pet)

// Wrapper command: toggles cursed chastity lock for a controlled pet.
/datum/component/collar_master/proc/toggle_pet_chastity_lock(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	var/obj/item/chastity/device = get_pet_cursed_chastity(pet)
	if(!device)
		return FALSE
	return device.toggle_cursed_lock(pet)

// Wrapper command: cycles cursed chastity front accessibility mode.
/datum/component/collar_master/proc/cycle_pet_chastity_front(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	var/obj/item/chastity/device = get_pet_cursed_chastity(pet)
	if(!device)
		return FALSE
	return device.cycle_cursed_front_mode(pet)

// Wrapper command: toggles cursed chastity anal access.
/datum/component/collar_master/proc/toggle_pet_chastity_anal(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	var/obj/item/chastity/device = get_pet_cursed_chastity(pet)
	if(!device)
		return FALSE
	return device.toggle_cursed_anal_open(pet)

// Wrapper command: toggles cursed chastity internal spikes.
/datum/component/collar_master/proc/toggle_pet_chastity_spikes(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	var/obj/item/chastity/device = get_pet_cursed_chastity(pet)
	if(!device)
		return FALSE
	return device.toggle_cursed_spikes(pet)

// Direct-state wrapper: sets cursed chastity lock instead of toggling/cycling.
/datum/component/collar_master/proc/set_pet_chastity_lock(mob/living/carbon/human/pet, should_lock)
	var/obj/item/chastity/device = get_commandable_cursed_chastity(pet, COLLAR_COMMAND_SET_CHASTITY_LOCK, should_lock)
	if(!device)
		return FALSE
	return device.set_cursed_lock(pet, should_lock)

// Direct-state wrapper: sets cursed chastity front mode.
/datum/component/collar_master/proc/set_pet_chastity_front_mode(mob/living/carbon/human/pet, mode)
	var/obj/item/chastity/device = get_commandable_cursed_chastity(pet, COLLAR_COMMAND_SET_CHASTITY_FRONT_MODE, mode)
	if(!device)
		return FALSE
	return device.set_cursed_front_mode(pet, mode)

// Direct-state wrapper: sets cursed chastity anal access.
/datum/component/collar_master/proc/set_pet_chastity_anal_open(mob/living/carbon/human/pet, should_open)
	var/obj/item/chastity/device = get_commandable_cursed_chastity(pet, COLLAR_COMMAND_SET_CHASTITY_ANAL_OPEN, should_open)
	if(!device)
		return FALSE
	return device.set_cursed_anal_open(pet, should_open)

// Direct-state wrapper: sets cursed chastity spike state.
/datum/component/collar_master/proc/set_pet_chastity_spikes(mob/living/carbon/human/pet, should_enable)
	var/obj/item/chastity/device = get_commandable_cursed_chastity(pet, COLLAR_COMMAND_SET_CHASTITY_SPIKES, should_enable)
	if(!device)
		return FALSE
	return device.set_cursed_spikes(pet, should_enable)

// Wrapper command: toggles cursed chastity flat/standard style.
/datum/component/collar_master/proc/toggle_pet_chastity_flat(mob/living/carbon/human/pet)
	if(!pet || !(pet in my_pets))
		return FALSE
	var/obj/item/chastity/device = get_pet_cursed_chastity(pet)
	if(!device)
		return FALSE
	return device.toggle_cursed_flat(pet)

// Direct-state wrapper: sets cursed chastity flat state.
/datum/component/collar_master/proc/set_pet_chastity_flat(mob/living/carbon/human/pet, should_be_flat)
	var/obj/item/chastity/device = get_commandable_cursed_chastity(pet, COLLAR_COMMAND_SET_CHASTITY_FLAT, should_be_flat)
	if(!device)
		return FALSE
	return device.set_cursed_flat(pet, should_be_flat)
