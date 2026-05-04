/**
 * collar_master_tgui — TGUI interface and action routing for the collar_master component.
 *
 * The main entry point is the collar_master_control_ui() verb added to the master's body in
 * collar_master_component.dm::_JoinParent(). It creates a /datum/collar_control_menu datum and
 * opens the "CollarControl" TGUI window.
 *
 * /datum/collar_control_menu:
 *   - Holds a reference to the caller's /datum/component/collar_master (master_component).
 *   - selected_pet_refs is an associative list of REF() strings for currently-selected pets.
 *     Selection is per-session (not persisted); the front-end sends select_pet / select_all /
 *     clear_selection actions to manage it.
 *
 * ui_data() flow:
 *   - Validates the component via get_component_for_user() to prevent a UI spoofed by a non-master.
 *   - Builds a pets_data list: per-pet status, anatomy, selection state, and full cursed-chastity
 *     state if the pet has a bound cursed device.
 *
 * ui_act() action routing:
 *   - Selection actions (select_pet, select_all, clear_selection) are cheap reads — no cooldown.
 *   - All other actions resolve selected pets via resolve_selected_pets(), which re-validates against
 *     CM.my_pets to prevent stale refs from doing anything after a pet is released mid-session.
 *   - Most actions consume a shared command_cooldown via consume_cooldown() to prevent rapid-fire abuse.
 *   - Cursed chastity direct-state actions (chastity_set_*) deliberately skip the global cooldown
 *     check at line ~128 and run their own consume_cooldown() inline. This is intentional: they are
 *     read-like parameter changes (not punishment actions) and need their own per-change throttle
 *     rather than being blocked by a shock/surrender that fired a moment before.
 *   - resolve_single_cursed_target() guards chastity_set_* actions — they require exactly one pet
 *     with a cursed device selected, and emit a chat warning otherwise.
 *
 * Helper procs at the bottom of the file:
 *   - get_component_for_user(): cross-validates UI user against the stored master_component reference.
 *   - resolve_selected_pets(): resolves selected_pet_refs back to live mob refs, re-checking my_pets membership.
 *   - consume_cooldown(): returns FALSE and warns if the command cooldown has not yet elapsed.
 *   - report_count(): unified feedback — tells the master how many pets were affected by a batch command.
 */
/mob/proc/collar_master_control_ui()
	set name = "Collar Control (TGUI)"
	set category = "Collar Tab"

	var/datum/component/collar_master/CM = mind?.GetComponent(/datum/component/collar_master)
	if(!CM)
		return

	var/datum/collar_control_menu/menu = new(CM)
	menu.ui_interact(src)

/datum/collar_control_menu
	var/datum/component/collar_master/master_component
	var/list/selected_pet_refs = list()

/datum/collar_control_menu/New(datum/component/collar_master/CM)
	if(!CM)
		qdel(src)
		return
	master_component = CM
	..()

/datum/collar_control_menu/Destroy()
	master_component = null
	selected_pet_refs = null
	return ..()

/datum/collar_control_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "CollarControl", "Collar Control", 1000, 650)
		ui.set_state(GLOB.always_state)
		ui.open()

/datum/collar_control_menu/ui_data(mob/user)
	var/list/data = list()
	var/datum/component/collar_master/CM = get_component_for_user(user)
	if(!CM)
		data["invalid"] = TRUE
		return data

	var/cooldown_remaining = max(0, round((CM.last_command_time + CM.command_cooldown - world.time) / 10, 0.1))
	data["master_name"] = CM.mindparent?.current?.real_name || "Unknown"
	data["cooldown_remaining"] = cooldown_remaining
	data["high_pop_mode"] = CM.is_high_pop_suppressed()
	data["selected_count"] = length(resolve_selected_pets(CM))

	var/list/pets_data = list()
	for(var/mob/living/carbon/human/pet in CM.my_pets)
		if(!pet)
			continue
		var/list/pet_entry = list()
		var/location_name = get_area_name(pet, TRUE)
		pet_entry["ref"] = REF(pet)
		pet_entry["name"] = pet.real_name
		pet_entry["connected"] = !!pet.client
		pet_entry["condition"] = pet.get_damage_condition_summary()
		pet_entry["location"] = location_name ? location_name : "Unknown"
		pet_entry["conscious"] = (pet.stat < UNCONSCIOUS)
		if(pet.stat == DEAD)
			pet_entry["mental_state"] = "Dead"
		else if(pet.stat >= UNCONSCIOUS)
			pet_entry["mental_state"] = "Unconscious"
		else
			pet_entry["mental_state"] = "Conscious"
		pet_entry["selected"] = (REF(pet) in selected_pet_refs)
		pet_entry["speech_altered"] = (pet in CM.speech_altered_pets)
		pet_entry["orgasm_denied"] = (pet in CM.denied_orgasm_pets)
		pet_entry["arousal_forced"] = !!pet.active_timers?["force_arousal_[REF(pet)]"]
		pet_entry["clothing_forbidden"] = HAS_TRAIT_FROM(pet, TRAIT_NUDIST, COLLAR_TRAIT)
		pet_entry["forced_love"] = pet.has_status_effect(/datum/status_effect/in_love)
		var/obj/item/clothing/neck/roguetown/cursed_collar/collar = pet.get_item_by_slot(SLOT_NECK)
		var/obj/item/chastity/device = CM.get_pet_cursed_chastity(pet)
		if(istype(collar))
			pet_entry["received_cum_count"] = collar.received_cum_count
		else if(device)
			pet_entry["received_cum_count"] = device.received_cum_count
		else
			pet_entry["received_cum_count"] = null

		pet_entry["has_cursed_chastity"] = !!device
		pet_entry["has_penis"] = !!pet.getorganslot(ORGAN_SLOT_PENIS)
		pet_entry["has_vagina"] = !!pet.getorganslot(ORGAN_SLOT_VAGINA)
		pet_entry["chastity"] = list(
			"locked" = device ? device.locked : FALSE,
			"front_mode" = device ? device.cursed_front_mode : 0,
			"anal_open" = device ? device.cursed_anal_open : FALSE,
			"spikes_on" = device ? device.cursed_spikes_on : FALSE,
			"is_flat" = device ? device.chastity_flat : FALSE
		)

		pets_data += list(pet_entry)

	data["pets"] = pets_data
	return data

/datum/collar_control_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	var/mob/user = ui?.user || usr
	var/datum/component/collar_master/CM = get_component_for_user(user)
	if(!CM)
		return TRUE

	switch(action)
		if("select_pet")
			var/pet_ref = params["pet_ref"]
			if(!pet_ref)
				return TRUE
			if(text2num("[params["selected"]]"))
				if(!(pet_ref in selected_pet_refs))
					selected_pet_refs += pet_ref
			else
				selected_pet_refs -= pet_ref
			return TRUE
		if("select_all")
			selected_pet_refs.Cut()
			for(var/mob/living/carbon/human/pet in CM.my_pets)
				if(pet)
					selected_pet_refs += REF(pet)
			return TRUE
		if("clear_selection")
			selected_pet_refs.Cut()
			return TRUE

	var/cursed_direct_action = (action in list(
		"chastity_set_lock",
		"chastity_set_front_mode",
		"chastity_set_anal_open",
		"chastity_set_spikes",
		"chastity_set_flat"
	))
	if(!cursed_direct_action)
		if(!consume_cooldown(CM, user))
			return TRUE

	var/list/targets = resolve_selected_pets(CM)
	if(!length(targets))
		to_chat(user, span_warning("No valid pets selected."))
		return TRUE

	switch(action)
		if("listen")
			var/mob/living/carbon/human/pet = targets[1]
			if(pet && pet.stat < UNCONSCIOUS)
				CM.toggle_listening(pet)
		if("shock")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(pet.stat >= UNCONSCIOUS)
					continue
				if(CM.shock_pet(pet, 15))
					affected++
			report_count(user, affected, "Shocked", "No pets were shocked.")
		if("force_surrender")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(CM.force_surrender(pet))
					affected++
			report_count(user, affected, "Forced surrender on", "No pets surrendered.")
		if("force_strip")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(CM.force_strip(pet))
					affected++
			report_count(user, affected, "Forced strip on", "No pets were stripped.")
		if("toggle_clothing")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(CM.permit_clothing(pet, HAS_TRAIT_FROM(pet, TRAIT_NUDIST, COLLAR_TRAIT)))
					affected++
			report_count(user, affected, "Toggled clothing permission for", "No clothing permissions changed.")
		if("toggle_speech")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(CM.toggle_speech(pet))
					affected++
			report_count(user, affected, "Toggled speech for", "No speech states changed.")
		if("force_action")
			var/action_text = trim(params["action_text"])
			if(!action_text)
				return TRUE
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				to_chat(pet, span_userdanger("Your collar compels you to perform an action!"))
				pet.visible_message(span_warning("[pet]'s collar pulses as they are forced to act!"))
				pet.say(action_text)
				if(!pet.is_shifted)
					pet.do_jitter_animation(15)
				playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
				affected++
			report_count(user, affected, "Forced action on", "No pets were forced to act.")
		if("toggle_love")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				var/love_enabled
				if(pet.has_status_effect(/datum/status_effect/in_love))
					pet.remove_status_effect(/datum/status_effect/in_love)
					REMOVE_TRAIT(pet, TRAIT_LOVESTRUCK, COLLAR_TRAIT)
					to_chat(pet, span_notice("The overwhelming attraction fades away..."))
					love_enabled = FALSE
				else
					pet.apply_status_effect(/datum/status_effect/in_love, user)
					ADD_TRAIT(pet, TRAIT_LOVESTRUCK, COLLAR_TRAIT)
					to_chat(pet, span_love("You feel an overwhelming attraction to [user]!"))
					love_enabled = TRUE
				playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
				log_collar_command(pet, COLLAR_LOG_LOVE, "enabled=[love_enabled]")
				affected++
			report_count(user, affected, "Toggled love status for", "No love states changed.")
		if("toggle_arousal")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(CM.toggle_arousal(pet))
					affected++
			report_count(user, affected, "Toggled arousal for", "No arousal states changed.")
		if("toggle_denial")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(CM.toggle_denial(pet))
					affected++
			report_count(user, affected, "Toggled denial for", "No denial states changed.")
		if("toggle_hallucinations")
			var/affected = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(CM.toggle_hallucinations(pet))
					affected++
			report_count(user, affected, "Toggled hallucinations for", "No hallucination states changed.")
		if("release_selected")
			var/released = 0
			for(var/mob/living/carbon/human/pet in targets)
				if(CM.remove_pet(pet))
					released++
			selected_pet_refs.Cut()
			report_count(user, released, "Released", "No pets were released.")
		if("send_message")
			var/message = trim(params["message"])
			if(!message)
				return TRUE
			var/sent = 0
			for(var/mob/living/carbon/human/pet in targets)
				to_chat(pet, span_userdanger("<i>Your collar resonates with your master's voice:</i> [message]"))
				playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
				if(!pet.is_shifted)
					pet.do_jitter_animation(15)
				sent++
			report_count(user, sent, "Sent message to", "No pets received message.")
		if("impose_will")
			var/will_text = params["will_text"]
			if(!length("[will_text]"))
				return TRUE
			var/sent = 0
			for(var/mob/living/carbon/human/pet in targets)
				to_chat(pet, will_text)
				playsound(pet, 'sound/misc/vampirespell.ogg', 50, TRUE)
				sent++
			report_count(user, sent, "Imposed will on", "No pets received imposed will.")
		if("chastity_set_lock")
			var/mob/living/carbon/human/pet = resolve_single_cursed_target(CM, targets, user)
			if(!pet)
				return TRUE
			if(!consume_cooldown(CM, user))
				return TRUE
			var/new_lock = text2num("[params["locked"]]")
			var/affected = 0
			if(CM.set_pet_chastity_lock(pet, new_lock))
				affected = 1
			report_count(user, affected, "Updated lock state for", "No cursed chastity lock states changed.")
		if("chastity_set_front_mode")
			var/mob/living/carbon/human/pet = resolve_single_cursed_target(CM, targets, user)
			if(!pet)
				return TRUE
			if(!consume_cooldown(CM, user))
				return TRUE
			var/front_mode = clamp(text2num("[params["front_mode"]]"), 0, 3)
			var/affected = 0
			if(CM.set_pet_chastity_front_mode(pet, front_mode))
				affected = 1
			report_count(user, affected, "Updated front mode for", "No cursed chastity front modes changed.")
		if("chastity_set_anal_open")
			var/mob/living/carbon/human/pet = resolve_single_cursed_target(CM, targets, user)
			if(!pet)
				return TRUE
			if(!consume_cooldown(CM, user))
				return TRUE
			var/anal_open = text2num("[params["anal_open"]]")
			var/affected = 0
			if(CM.set_pet_chastity_anal_open(pet, anal_open))
				affected = 1
			report_count(user, affected, "Updated anal access for", "No cursed chastity anal states changed.")
		if("chastity_set_spikes")
			var/mob/living/carbon/human/pet = resolve_single_cursed_target(CM, targets, user)
			if(!pet)
				return TRUE
			if(!consume_cooldown(CM, user))
				return TRUE
			var/spikes_on = text2num("[params["spikes_on"]]")
			var/affected = 0
			if(CM.set_pet_chastity_spikes(pet, spikes_on))
				affected = 1
			report_count(user, affected, "Updated spikes state for", "No cursed chastity spike states changed.")
		if("chastity_set_flat")
			var/mob/living/carbon/human/pet = resolve_single_cursed_target(CM, targets, user)
			if(!pet)
				return TRUE
			if(!consume_cooldown(CM, user))
				return TRUE
			var/is_flat = text2num("[params["is_flat"]]")
			var/affected = 0
			if(CM.set_pet_chastity_flat(pet, is_flat))
				affected = 1
			report_count(user, affected, "Updated cage style for", "No cursed chastity cage styles changed.")

	return TRUE

/datum/collar_control_menu/proc/get_component_for_user(mob/user)
	if(!user?.mind || !master_component)
		return null
	var/datum/component/collar_master/CM = user.mind.GetComponent(/datum/component/collar_master)
	if(CM != master_component)
		return null
	return CM

/datum/collar_control_menu/proc/resolve_selected_pets(datum/component/collar_master/CM)
	var/list/valid = list()
	for(var/pet_ref in selected_pet_refs)
		var/mob/living/carbon/human/pet = locate(pet_ref)
		if(!pet)
			continue
		if(!(pet in CM.my_pets))
			continue
		valid += pet
	return valid

/datum/collar_control_menu/proc/resolve_single_cursed_target(datum/component/collar_master/CM, list/targets, mob/user)
	var/list/cursed_targets = list()
	for(var/mob/living/carbon/human/pet in targets)
		if(CM.get_pet_cursed_chastity(pet))
			cursed_targets += pet
	var/cursed_target_count = length(cursed_targets)
	if(!cursed_target_count)
		to_chat(user, span_warning("No selected pets have cursed chastity."))
		return null
	if(cursed_target_count > 1)
		to_chat(user, span_warning("Select exactly one cursed pet for direct chastity control."))
		return null
	return cursed_targets[1]

/datum/collar_control_menu/proc/consume_cooldown(datum/component/collar_master/CM, mob/user)
	if(world.time < CM.last_command_time + CM.command_cooldown)
		to_chat(user, span_warning("The collar is still cooling down!"))
		return FALSE
	CM.last_command_time = world.time
	return TRUE

/datum/collar_control_menu/proc/report_count(mob/user, count, label, fail_text)
	if(count > 0)
		to_chat(user, span_notice("[label] [count] pets."))
	else
		to_chat(user, span_warning(fail_text))
