/datum/preferences/proc/check_virtue_vice_conflict(virtue_type, show_message = FALSE, mob/user = null)
	// Check if selected virtue conflicts with any selected vice
	var/list/vice_list = list()
	for(var/i = 1 to 8)
		var/datum/charflaw/v = vars["vice[i]"]
		if(v)
			vice_list += v
	
	// Prosthetic Limbs vs Wood Arms
	if(virtue_type == /datum/virtue/prosthetics/prosthetic_specialist)
		// Note: Can't check selected limbs during selection, but wood arm vices shouldn't be selectable with prosthetic virtue
		for(var/datum/charflaw/vice in vice_list)
			if(vice && (vice.type == /datum/charflaw/limbloss/arm_r || vice.type == /datum/charflaw/limbloss/arm_l))
				if(show_message && user)
					to_chat(user, span_warning("Prosthetic Limbs virtue conflicts with Wood Arm vice!"))
				return TRUE
	
	// Night-eyed vs Colorblind
	if(virtue_type == /datum/virtue/utility/night_vision)
		for(var/datum/charflaw/vice in vice_list)
			if(vice && vice.type == /datum/charflaw/colorblind)
				if(show_message && user)
					to_chat(user, span_warning("Night-eyed virtue conflicts with Colorblind vice!"))
				return TRUE
	
	// Socialite (Beautiful) vs Ugly
	if(virtue_type == /datum/virtue/utility/socialite)
		for(var/datum/charflaw/vice in vice_list)
			if(vice && vice.type == /datum/charflaw/ugly)
				if(show_message && user)
					to_chat(user, span_warning("Socialite virtue conflicts with Ugly vice!"))
				return TRUE
			if(vice && vice.type == /datum/charflaw/eerie_beauty)
				if(show_message && user)
					to_chat(user, span_warning("Socialite virtue conflicts with Eerie Beauty vice!"))
				return TRUE
	
	// Giant virtue or Sturdy Giant pack vs Lumbering Giant vice
	if(virtue_type == /datum/virtue/size/giant || virtue_type == /datum/virtue/pack/sturdygiant)
		for(var/datum/charflaw/vice in vice_list)
			if(vice && vice.type == /datum/charflaw/lumbering_giant)
				if(show_message && user)
					to_chat(user, span_warning("Giant-related virtues conflict with Lumbering Giant vice!"))
				return TRUE
	
	// Deathless (no hunger/breath) vs any food/breathing related vices
	// Deathless conflicts with nothing currently, but kept for future reference
	
	return FALSE

/datum/preferences/proc/check_virtue_virtue_conflict(virtue_type, other_virtue_type, show_message = FALSE, mob/user = null)
	if(!virtue_type || !other_virtue_type)
		return FALSE
	// Note: Prosthetic specialist handles its own zone conflicts internally during selection
	return FALSE

/datum/preferences/proc/check_vice_virtue_conflict(vice_type, show_message = FALSE, mob/user = null)
	// Check if selected vice conflicts with any selected virtue
	var/list/virtue_list = list()
	
	// Add origin virtue
	if(origin_virtue)
		virtue_list += origin_virtue
	
	// Add origin items
	if(LAZYLEN(origin_items))
		virtue_list += origin_items
	
	// Add feats
	if(LAZYLEN(feats))
		virtue_list += feats
	
	// Also check legacy virtues for backwards compatibility
	if(virtue)
		virtue_list += virtue
	if(virtuetwo)
		virtue_list += virtuetwo
	
	// Wood Arm (R/L) vs Prosthetic Limbs
	if(vice_type == /datum/charflaw/limbloss/arm_r || vice_type == /datum/charflaw/limbloss/arm_l)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/prosthetics/prosthetic_specialist)
				if(show_message && user)
					to_chat(user, span_warning("Wood Arm vice conflicts with Prosthetic Limbs virtue!"))
				return TRUE
	
	// Colorblind vs Night-eyed
	if(vice_type == /datum/charflaw/colorblind)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/utility/night_vision)
				if(show_message && user)
					to_chat(user, span_warning("Colorblind vice conflicts with Night-eyed virtue!"))
				return TRUE
	
	// Ugly vs Socialite (Beautiful)
	if(vice_type == /datum/charflaw/ugly)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/utility/socialite)
				if(show_message && user)
					to_chat(user, span_warning("Ugly vice conflicts with Socialite virtue!"))
				return TRUE
	
	// Eerie Beauty vs Socialite (Beautiful)
	if(vice_type == /datum/charflaw/eerie_beauty)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/utility/socialite)
				if(show_message && user)
					to_chat(user, span_warning("Eerie Beauty vice conflicts with Socialite virtue!"))
				return TRUE
	
	// Mute vs Second Voice (can't have second voice if you're mute)
	if(vice_type == /datum/charflaw/mute)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/utility/secondvoice)
				if(show_message && user)
					to_chat(user, span_warning("Mute vice conflicts with Second Voice virtue - you can't have a second voice if you're mute!"))
				return TRUE
	
	// Unintelligible vs Second Voice (second voice won't help if you're unintelligible)
	if(vice_type == /datum/charflaw/unintelligible)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/utility/secondvoice)
				if(show_message && user)
					to_chat(user, span_warning("Unintelligible vice conflicts with Second Voice virtue!"))
				return TRUE
	
	// Lumbering Giant vs Giant virtue or Sturdy Giant pack
	if(vice_type == /datum/charflaw/lumbering_giant)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/size/giant)
				if(show_message && user)
					to_chat(user, span_warning("Lumbering Giant vice conflicts with Giant virtue!"))
				return TRUE
			if(virt && virt.type == /datum/virtue/pack/sturdygiant)
				if(show_message && user)
					to_chat(user, span_warning("Lumbering Giant vice conflicts with Sturdy Giant virtue pack!"))
				return TRUE
	
	return FALSE

/datum/preferences/proc/check_vice_vice_conflict(vice_type, list/selected_vices, show_message = FALSE, mob/user = null)
	// Check for vice conflicts
	
	// === EYE-RELATED CONFLICTS ===
	// Bad Sight conflicts with: Cyclops (R), Cyclops (L), Blindness
	if(vice_type == /datum/charflaw/badsight)
		if(/datum/charflaw/noeyer in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Bad Sight vice conflicts with Cyclops (R) vice!"))
			return TRUE
		if(/datum/charflaw/noeyel in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Bad Sight vice conflicts with Cyclops (L) vice!"))
			return TRUE
		if(/datum/charflaw/noeyeall in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Bad Sight vice conflicts with Blindness vice!"))
			return TRUE
		if(/datum/charflaw/colorblind in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Bad Sight vice conflicts with Colorblind vice!"))
			return TRUE
	
	// Cyclops (R) conflicts with: Bad Sight, Cyclops (L), Blindness, Colorblind
	if(vice_type == /datum/charflaw/noeyer)
		if(/datum/charflaw/badsight in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Cyclops (R) vice conflicts with Bad Sight vice!"))
			return TRUE
		if(/datum/charflaw/noeyel in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Cyclops (R) vice conflicts with Cyclops (L) vice!"))
			return TRUE
		if(/datum/charflaw/noeyeall in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Cyclops (R) vice conflicts with Blindness vice!"))
			return TRUE
		if(/datum/charflaw/colorblind in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Cyclops (R) vice conflicts with Colorblind vice!"))
			return TRUE
	
	// Cyclops (L) conflicts with: Bad Sight, Cyclops (R), Blindness, Colorblind
	if(vice_type == /datum/charflaw/noeyel)
		if(/datum/charflaw/badsight in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Cyclops (L) vice conflicts with Bad Sight vice!"))
			return TRUE
		if(/datum/charflaw/noeyer in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Cyclops (L) vice conflicts with Cyclops (R) vice!"))
			return TRUE
		if(/datum/charflaw/noeyeall in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Cyclops (L) vice conflicts with Blindness vice!"))
			return TRUE
		if(/datum/charflaw/colorblind in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Cyclops (L) vice conflicts with Colorblind vice!"))
			return TRUE
	
	// Blindness conflicts with: Bad Sight, Cyclops (R), Cyclops (L), Colorblind
	if(vice_type == /datum/charflaw/noeyeall)
		if(/datum/charflaw/badsight in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Blindness vice conflicts with Bad Sight vice!"))
			return TRUE
		if(/datum/charflaw/noeyer in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Blindness vice conflicts with Cyclops (R) vice!"))
			return TRUE
		if(/datum/charflaw/noeyel in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Blindness vice conflicts with Cyclops (L) vice!"))
			return TRUE
		if(/datum/charflaw/colorblind in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Blindness vice conflicts with Colorblind vice!"))
			return TRUE
	
	// Colorblind conflicts with: Bad Sight, Cyclops (R), Cyclops (L), Blindness
	if(vice_type == /datum/charflaw/colorblind)
		if(/datum/charflaw/badsight in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Colorblind vice conflicts with Bad Sight vice!"))
			return TRUE
		if(/datum/charflaw/noeyer in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Colorblind vice conflicts with Cyclops (R) vice!"))
			return TRUE
		if(/datum/charflaw/noeyel in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Colorblind vice conflicts with Cyclops (L) vice!"))
			return TRUE
		if(/datum/charflaw/noeyeall in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Colorblind vice conflicts with Blindness vice!"))
			return TRUE
	
	// === SLEEP-RELATED CONFLICTS ===
	// Narcoleptic conflicts with: Insomnia (can't have both sleep disorders)
	if(vice_type == /datum/charflaw/narcoleptic)
		if(/datum/charflaw/sleepless in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Narcoleptic vice conflicts with Sleepless vice - you can't have both sleep disorders!"))
			return TRUE
	
	// Insomnia conflicts with: Narcoleptic
	if(vice_type == /datum/charflaw/sleepless)
		if(/datum/charflaw/narcoleptic in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Sleepless vice conflicts with Narcoleptic vice - you can't have both sleep disorders!"))
			return TRUE
	
	// === SPEECH-RELATED CONFLICTS ===
	// Mute conflicts with: Unintelligible (can't have both speech impediments)
	if(vice_type == /datum/charflaw/mute)
		if(/datum/charflaw/unintelligible in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Mute vice conflicts with Unintelligible vice - you can't have both speech impediments!"))
			return TRUE
	
	// Unintelligible conflicts with: Mute
	if(vice_type == /datum/charflaw/unintelligible)
		if(/datum/charflaw/mute in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Unintelligible vice conflicts with Mute vice - you can't have both speech impediments!"))
			return TRUE

	// === DIET-RELATED CONFLICTS ===
	// Carnivore conflicts with: Herbivore, Hemophage, Lithovore
	if(vice_type == /datum/charflaw/carnivore)
		if(/datum/charflaw/herbivore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Carnivore vice conflicts with Herbivore vice - you can't have multiple diet types!"))
			return TRUE
		if(/datum/charflaw/hemophage in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Carnivore vice conflicts with Hemophage vice - you can't have multiple diet types!"))
			return TRUE
		if(/datum/charflaw/lithovore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Carnivore vice conflicts with Lithovore vice - you can't have multiple diet types!"))
			return TRUE

	// Herbivore conflicts with: Carnivore, Hemophage, Lithovore
	if(vice_type == /datum/charflaw/herbivore)
		if(/datum/charflaw/carnivore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Herbivore vice conflicts with Carnivore vice - you can't have multiple diet types!"))
			return TRUE
		if(/datum/charflaw/hemophage in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Herbivore vice conflicts with Hemophage vice - you can't have multiple diet types!"))
			return TRUE
		if(/datum/charflaw/lithovore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Herbivore vice conflicts with Lithovore vice - you can't have multiple diet types!"))
			return TRUE

	// Hemophage conflicts with: Carnivore, Herbivore, Lithovore
	if(vice_type == /datum/charflaw/hemophage)
		if(/datum/charflaw/carnivore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Hemophage vice conflicts with Carnivore vice - you can't have multiple diet types!"))
			return TRUE
		if(/datum/charflaw/herbivore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Hemophage vice conflicts with Herbivore vice - you can't have multiple diet types!"))
			return TRUE
		if(/datum/charflaw/lithovore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Hemophage vice conflicts with Lithovore vice - you can't have multiple diet types!"))
			return TRUE

	// Lithovore conflicts with: Carnivore, Herbivore, Hemophage
	if(vice_type == /datum/charflaw/lithovore)
		if(/datum/charflaw/carnivore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Lithovore vice conflicts with Carnivore vice - you can't have multiple diet types!"))
			return TRUE
		if(/datum/charflaw/herbivore in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Lithovore vice conflicts with Herbivore vice - you can't have multiple diet types!"))
			return TRUE
		if(/datum/charflaw/hemophage in selected_vices)
			if(show_message && user)
				to_chat(user, span_warning("Lithovore vice conflicts with Hemophage vice - you can't have multiple diet types!"))
			return TRUE

	// === ASTRATA-SCORCHED CONFLICTS ===
	// NOTE: Astrata-Scorched is now a virtue, not a vice
	// The conflict check is handled in the virtue's apply_to_human proc
	// Hemophage is still a vice and incompatible with the Astrata-Scorched virtue

	return FALSE

// Helper functions for category-based virtue system
/datum/preferences/proc/count_selected_vices()
	var/count = 0
	for(var/i = 1 to 8)
		if(vars["vice[i]"])
			count++
	return count

/datum/preferences/proc/get_max_feats()
	// No longer limited by slots - feats are only limited by virtue points
	// Keeping this for backward compatibility with presets
	return 999

/datum/preferences/proc/enforce_feat_limit(mob/user = null)
	var/max_feats = get_max_feats()
	var/current_feats = LAZYLEN(feats)
	if(current_feats <= max_feats)
		return FALSE

	var/disabled_count = current_feats - max_feats
	feats.Cut(max_feats + 1)
	if(!LAZYLEN(feats))
		feats = null

	if(user)
		to_chat(user, span_warning("[disabled_count] feat[disabled_count > 1 ? "s were" : " was"] disabled because you no longer have enough vices."))

	return TRUE

// Virtue point system helpers
/datum/preferences/proc/get_max_virtue_points()
	// Base 15 points for all characters	
	var/points = 15
	// Virtuous statpack grants +5 additional virtue points
	if(statpack && statpack.name == "Virtuous")
		points += 5
	return points

/datum/preferences/proc/get_spent_virtue_points()
	var/total = 0
	
	// Count origin virtue
	if(origin_virtue && istype(origin_virtue, /datum/virtue) && origin_virtue.virtue_cost)
		total += origin_virtue.virtue_cost
	
	// Count origin items (with null filtering)
	if(LAZYLEN(origin_items))
		for(var/datum/virtue/V in origin_items)
			if(!V || !istype(V, /datum/virtue))
				continue
			if(V.virtue_cost)
				total += V.virtue_cost
	
	// Count feats (with null filtering)
	if(LAZYLEN(feats))
		for(var/datum/virtue/V in feats)
			if(!V || !istype(V, /datum/virtue))
				continue
			if(V.virtue_cost)
				total += V.virtue_cost
	
	// Count legacy virtues for backwards compatibility
	if(virtue && istype(virtue, /datum/virtue) && virtue.virtue_cost)
		total += virtue.virtue_cost
	if(virtuetwo && istype(virtuetwo, /datum/virtue) && virtuetwo.virtue_cost)
		total += virtuetwo.virtue_cost
	
	return total

/datum/preferences/proc/get_remaining_virtue_points()
	return get_max_virtue_points() - get_spent_virtue_points()

/datum/preferences/proc/can_afford_virtue(datum/virtue/V)
	if(!V || !V.virtue_cost)
		return TRUE // Free virtues are always affordable
	return get_remaining_virtue_points() >= V.virtue_cost

/datum/preferences/proc/can_select_virtue(category)
	switch(category)
		if("origin")
			// Can only select 1 origin virtue
			return !origin_virtue
		if("origin_items")
			// Can select 1 origin item (heirloom)
			return LAZYLEN(origin_items) < 1
		if("feats")
			// No slot limit - only limited by virtue points
			return TRUE
	return FALSE

/// Sanitize virtue lists by removing null or invalid entries
/datum/preferences/proc/sanitize_virtue_lists()
	var/changed = FALSE
	
	// Clean origin_items
	if(LAZYLEN(origin_items))
		var/list/cleaned_items = list()
		for(var/datum/virtue/V in origin_items)
			if(V && istype(V, /datum/virtue))
				cleaned_items += V
			else
				changed = TRUE
		origin_items = cleaned_items.len ? cleaned_items : null
	
	// Clean feats
	if(LAZYLEN(feats))
		var/list/cleaned_feats = list()
		for(var/datum/virtue/V in feats)
			if(V && istype(V, /datum/virtue))
				cleaned_feats += V
			else
				changed = TRUE
		feats = cleaned_feats.len ? cleaned_feats : null
	
	// Validate origin_virtue
	if(origin_virtue && !istype(origin_virtue, /datum/virtue))
		origin_virtue = null
		changed = TRUE
	
	return changed

/// Reset all virtues and vices to default state
/datum/preferences/proc/reset_virtues_and_vices()
	// Clear new virtue system
	origin_virtue = null
	origin_items = null
	feats = null
	
	// Clear custom origin system
	custom_origin_skills = null
	custom_origin_levels = null
	custom_origin_points_spent = 0
	
	// Reset legacy virtues
	virtue = GLOB.virtues[/datum/virtue/none]
	virtuetwo = GLOB.virtues[/datum/virtue/none]
	
	// Clear all vices
	for(var/i = 1 to 8)
		vars["vice[i]"] = null
	
	// Legacy vice
	charflaw = null
	
	save_character()

/// Reset all loadout items and languages to default state
/datum/preferences/proc/reset_loadout_and_languages()
	// Clear languages
	extra_language = "None"
	extra_language_1 = "None"
	extra_language_2 = "None"
	
	// Clear loadout items
	loadout = null
	loadout2 = null
	loadout3 = null
	loadout4 = null
	loadout5 = null
	loadout6 = null
	loadout7 = null
	loadout8 = null
	loadout9 = null
	loadout10 = null
	
	// Clear loadout names
	loadout_1_name = null
	loadout_2_name = null
	loadout_3_name = null
	loadout_4_name = null
	loadout_5_name = null
	loadout_6_name = null
	loadout_7_name = null
	loadout_8_name = null
	loadout_9_name = null
	loadout_10_name = null
	
	// Clear loadout descriptions
	loadout_1_desc = null
	loadout_2_desc = null
	loadout_3_desc = null
	loadout_4_desc = null
	loadout_5_desc = null
	loadout_6_desc = null
	loadout_7_desc = null
	loadout_8_desc = null
	loadout_9_desc = null
	loadout_10_desc = null
	
	// Clear loadout colors
	loadout_1_hex = null
	loadout_2_hex = null
	loadout_3_hex = null
	loadout_4_hex = null
	loadout_5_hex = null
	loadout_6_hex = null
	loadout_7_hex = null
	loadout_8_hex = null
	loadout_9_hex = null
	loadout_10_hex = null
	
	save_character()

/datum/preferences/proc/get_selected_stashed_item_types(datum/virtue/exclude_virtue = null)
	var/list/item_types = list()
	var/list/selected_virtues = list()

	if(origin_virtue && origin_virtue != exclude_virtue)
		selected_virtues += origin_virtue

	if(LAZYLEN(origin_items))
		for(var/datum/virtue/V in origin_items)
			if(V && V != exclude_virtue)
				selected_virtues += V

	if(LAZYLEN(feats))
		for(var/datum/virtue/V in feats)
			if(V && V != exclude_virtue)
				selected_virtues += V

	if(virtue && virtue != exclude_virtue)
		selected_virtues += virtue

	if(virtuetwo && virtuetwo != exclude_virtue)
		selected_virtues += virtuetwo

	for(var/datum/virtue/V in selected_virtues)
		if(!LAZYLEN(V.added_stashed_items))
			continue
		for(var/item_name in V.added_stashed_items)
			var/item_type = V.added_stashed_items[item_name]
			if(item_type)
				item_types[item_type] = TRUE

	return item_types

/datum/preferences/proc/has_stashed_item_conflict(datum/virtue/candidate, datum/virtue/exclude_virtue = null, show_message = FALSE, mob/user = null)
	if(!candidate || !LAZYLEN(candidate.added_stashed_items))
		return FALSE

	var/list/existing_item_types = get_selected_stashed_item_types(exclude_virtue)
	var/list/conflicts = list()

	for(var/item_name in candidate.added_stashed_items)
		var/item_type = candidate.added_stashed_items[item_name]
		if(item_type in existing_item_types)
			conflicts += item_name

	if(!LAZYLEN(conflicts))
		return FALSE

	if(show_message && user)
		to_chat(user, span_warning("This selection conflicts with an already selected stash item: [conflicts.Join(", ")]."))

	return TRUE

/datum/preferences/proc/is_blocked_by_origin(datum/virtue/candidate, show_message = FALSE, mob/user = null)
	// Check if the candidate virtue/item is blocked by the selected origin
	if(!candidate || !origin_virtue)
		return FALSE
	
	// Check if this feat is blocked by the origin
	if(candidate.category == "feats" && LAZYLEN(origin_virtue.blocked_feats))
		for(var/blocked_path in origin_virtue.blocked_feats)
			// Support both exact type matching and general path matching
			if(candidate.type == blocked_path || ispath(candidate.type, blocked_path))
				if(show_message && user)
					to_chat(user, span_warning("[candidate.name] is incompatible with your [origin_virtue.name] origin!"))
				return TRUE
	
	// Check if this item is blocked by the origin
	if(candidate.category == "origin_items" && LAZYLEN(origin_virtue.blocked_items))
		for(var/blocked_path in origin_virtue.blocked_items)
			// Support both exact type matching and general path matching
			if(candidate.type == blocked_path || ispath(candidate.type, blocked_path))
				if(show_message && user)
					to_chat(user, span_warning("[candidate.name] is incompatible with your [origin_virtue.name] origin!"))
				return TRUE
	
	return FALSE

/datum/preferences/proc/add_virtue_to_category(datum/virtue/V)
	if(!V || !V.category)
		return FALSE
	
	switch(V.category)
		if("origin")
			if(origin_virtue)
				return FALSE  // Already have an origin virtue
			origin_virtue = V
			return TRUE
		if("origin_items")
			if(LAZYLEN(origin_items) >= 1)
				return FALSE  // Already have 1 heirloom
			LAZYADD(origin_items, V)
			return TRUE
		if("feats")
			// No slot limit - only limited by virtue points
			LAZYADD(feats, V)
			return TRUE
	return FALSE

/datum/preferences/proc/remove_virtue_from_category(datum/virtue/V)
	if(!V || !V.category)
		return FALSE
	
	switch(V.category)
		if("origin")
			if(origin_virtue == V)
				origin_virtue = null
				return TRUE
		if("origin_items")
			if(V in origin_items)
				origin_items -= V
				return TRUE
		if("feats")
			if(V in feats)
				feats -= V
				return TRUE
	return FALSE

/datum/preferences/proc/generate_virtue_display_html(datum/virtue/V)
	var/html = ""
	if(!V)
		return html
	
	html += "<div class='vice-name'>[V.name]</div>"
	html += "<div class='vice-desc'>[V.desc]</div>"
	
	if(V.custom_text)
		html += "<div class='statpack-stats' style='margin-top: 4px;'>[V.custom_text]</div>"
	
	// Display traits granted
	if(LAZYLEN(V.added_traits))
		html += "<div class='statpack-stats' style='margin-top: 8px; font-size: 0.65em;'><strong>Traits:</strong><br>"
		for(var/trait in V.added_traits)
			html += "• [trait]<br>"
		html += "</div>"
	
	// Display skills granted
	if(LAZYLEN(V.added_skills))
		html += "<div class='statpack-stats' style='margin-top: 8px; font-size: 0.65em;'><strong>Skills:</strong><br>"
		for(var/skill in V.added_skills)
			if(!islist(skill))
				var/datum/skill/S = skill
				var/skill_name = initial(S.name)
				html += "• [skill_name]: +[V.added_skills[skill]]<br>"
			else
				var/list/skill_block = skill
				var/datum/skill/S = skill_block[1]
				var/skill_name = initial(S.name)
				html += "• [skill_name]: +[skill_block[2]] (max [skill_block[3]])<br>"
		html += "</div>"
	
	// Display stashed items
	if(LAZYLEN(V.added_stashed_items))
		html += "<div class='statpack-stats' style='margin-top: 8px; font-size: 0.65em;'><strong>Items:</strong><br>"
		for(var/item_name in V.added_stashed_items)
			html += "• [item_name]<br>"
		html += "</div>"
	
	return html

// Global cache for loadout item icons to prevent memory leaks
GLOBAL_LIST_EMPTY(cached_loadout_icons)

/datum/preferences/proc/save_to_history()
	// Initialize history list if null
	if(!customization_history)
		customization_history = list()
	
	// Save current state to history (max 10 entries)
	var/list/snapshot = list(
		"statpack" = statpack,
		"virtue" = virtue,
		"virtuetwo" = virtuetwo,
		"origin_virtue" = origin_virtue,
		"origin_items" = origin_items ? origin_items.Copy() : null,
		"feats" = feats ? feats.Copy() : null,
		"custom_origin_skills" = custom_origin_skills ? custom_origin_skills.Copy() : null,
		"custom_origin_levels" = custom_origin_levels ? custom_origin_levels.Copy() : null,
		"custom_origin_points_spent" = custom_origin_points_spent,
		"vice1" = vice1,
		"vice2" = vice2,
		"vice3" = vice3,
		"vice4" = vice4,
		"vice5" = vice5,
		"vice6" = vice6,
		"vice7" = vice7,
		"vice8" = vice8,
		"loadout" = loadout,
		"loadout2" = loadout2,
		"loadout3" = loadout3,
		"loadout4" = loadout4,
		"loadout5" = loadout5,
		"loadout6" = loadout6,
		"loadout7" = loadout7,
		"loadout8" = loadout8,
		"loadout9" = loadout9,
		"loadout10" = loadout10,
		"loadout_1_name" = loadout_1_name,
		"loadout_2_name" = loadout_2_name,
		"loadout_3_name" = loadout_3_name,
		"loadout_4_name" = loadout_4_name,
		"loadout_5_name" = loadout_5_name,
		"loadout_6_name" = loadout_6_name,
		"loadout_7_name" = loadout_7_name,
		"loadout_8_name" = loadout_8_name,
		"loadout_9_name" = loadout_9_name,
		"loadout_10_name" = loadout_10_name,
		"loadout_1_desc" = loadout_1_desc,
		"loadout_2_desc" = loadout_2_desc,
		"loadout_3_desc" = loadout_3_desc,
		"loadout_4_desc" = loadout_4_desc,
		"loadout_5_desc" = loadout_5_desc,
		"loadout_6_desc" = loadout_6_desc,
		"loadout_7_desc" = loadout_7_desc,
		"loadout_8_desc" = loadout_8_desc,
		"loadout_9_desc" = loadout_9_desc,
		"loadout_10_desc" = loadout_10_desc,
		"loadout_1_hex" = loadout_1_hex,
		"loadout_2_hex" = loadout_2_hex,
		"loadout_3_hex" = loadout_3_hex,
		"loadout_4_hex" = loadout_4_hex,
		"loadout_5_hex" = loadout_5_hex,
		"loadout_6_hex" = loadout_6_hex,
		"loadout_7_hex" = loadout_7_hex,
		"loadout_8_hex" = loadout_8_hex,
		"loadout_9_hex" = loadout_9_hex,
		"loadout_10_hex" = loadout_10_hex,
		"extra_language" = extra_language,
		"extra_language_1" = extra_language_1,
		"extra_language_2" = extra_language_2
	)
	
	// Add to history
	customization_history.Insert(1, snapshot)
	
	// Keep only last 10 entries
	if(customization_history.len > 10)
		customization_history.Cut(11)

/datum/preferences/proc/undo_last_change()
	if(!customization_history || !customization_history.len)
		return FALSE
	
	// Get the last snapshot
	var/list/snapshot = customization_history[1]
	
	// Restore all values
	statpack = snapshot["statpack"]
	virtue = snapshot["virtue"]
	virtuetwo = snapshot["virtuetwo"]
	origin_virtue = snapshot["origin_virtue"]
	var/list/stored_items = snapshot["origin_items"]
	if(stored_items)
		origin_items = stored_items.Copy()
	else
		origin_items = null
	var/list/stored_feats = snapshot["feats"]
	if(stored_feats)
		feats = stored_feats.Copy()
	else
		feats = null
	var/list/stored_custom_skills = snapshot["custom_origin_skills"]
	if(stored_custom_skills)
		custom_origin_skills = stored_custom_skills.Copy()
	else
		custom_origin_skills = null
	var/list/stored_custom_levels = snapshot["custom_origin_levels"]
	if(stored_custom_levels)
		custom_origin_levels = stored_custom_levels.Copy()
	else
		custom_origin_levels = null
	custom_origin_points_spent = snapshot["custom_origin_points_spent"]
	vice1 = snapshot["vice1"]
	vice2 = snapshot["vice2"]
	vice3 = snapshot["vice3"]
	vice4 = snapshot["vice4"]
	vice5 = snapshot["vice5"]
	vice6 = snapshot["vice6"]
	vice7 = snapshot["vice7"]
	vice8 = snapshot["vice8"]
	loadout = snapshot["loadout"]
	loadout2 = snapshot["loadout2"]
	loadout3 = snapshot["loadout3"]
	loadout4 = snapshot["loadout4"]
	loadout5 = snapshot["loadout5"]
	loadout6 = snapshot["loadout6"]
	loadout7 = snapshot["loadout7"]
	loadout8 = snapshot["loadout8"]
	loadout9 = snapshot["loadout9"]
	loadout10 = snapshot["loadout10"]
	loadout_1_name = snapshot["loadout_1_name"]
	loadout_2_name = snapshot["loadout_2_name"]
	loadout_3_name = snapshot["loadout_3_name"]
	loadout_4_name = snapshot["loadout_4_name"]
	loadout_5_name = snapshot["loadout_5_name"]
	loadout_6_name = snapshot["loadout_6_name"]
	loadout_7_name = snapshot["loadout_7_name"]
	loadout_8_name = snapshot["loadout_8_name"]
	loadout_9_name = snapshot["loadout_9_name"]
	loadout_10_name = snapshot["loadout_10_name"]
	loadout_1_desc = snapshot["loadout_1_desc"]
	loadout_2_desc = snapshot["loadout_2_desc"]
	loadout_3_desc = snapshot["loadout_3_desc"]
	loadout_4_desc = snapshot["loadout_4_desc"]
	loadout_5_desc = snapshot["loadout_5_desc"]
	loadout_6_desc = snapshot["loadout_6_desc"]
	loadout_7_desc = snapshot["loadout_7_desc"]
	loadout_8_desc = snapshot["loadout_8_desc"]
	loadout_9_desc = snapshot["loadout_9_desc"]
	loadout_10_desc = snapshot["loadout_10_desc"]
	loadout_1_hex = snapshot["loadout_1_hex"]
	loadout_2_hex = snapshot["loadout_2_hex"]
	loadout_3_hex = snapshot["loadout_3_hex"]
	loadout_4_hex = snapshot["loadout_4_hex"]
	loadout_5_hex = snapshot["loadout_5_hex"]
	loadout_6_hex = snapshot["loadout_6_hex"]
	loadout_7_hex = snapshot["loadout_7_hex"]
	loadout_8_hex = snapshot["loadout_8_hex"]
	loadout_9_hex = snapshot["loadout_9_hex"]
	loadout_10_hex = snapshot["loadout_10_hex"]
	extra_language = snapshot["extra_language"]
	extra_language_1 = snapshot["extra_language_1"]
	extra_language_2 = snapshot["extra_language_2"]
	
	// Remove this snapshot from history
	customization_history.Cut(1, 2)
	
	return TRUE

/datum/preferences/proc/save_preset(preset_slot)
	if(preset_slot < 1 || preset_slot > 3)
		return FALSE

	var/list/preset_origin_items = null
	if(LAZYLEN(origin_items))
		preset_origin_items = list()
		for(var/datum/virtue/item_virtue in origin_items)
			if(item_virtue)
				preset_origin_items += item_virtue.type

	var/list/preset_feats = null
	if(LAZYLEN(feats))
		preset_feats = list()
		for(var/datum/virtue/feat_virtue in feats)
			if(feat_virtue)
				preset_feats += feat_virtue.type
	
	var/list/preset = list(
		"statpack" = statpack?.type,
		"virtue" = virtue?.type,
		"virtuetwo" = virtuetwo?.type,
		"origin_virtue" = origin_virtue?.type,
		"origin_items" = preset_origin_items,
		"feats" = preset_feats,
		"custom_origin_skills" = custom_origin_skills ? custom_origin_skills.Copy() : null,
		"custom_origin_levels" = custom_origin_levels ? custom_origin_levels.Copy() : null,
		"custom_origin_points_spent" = custom_origin_points_spent,
		"vice1" = vice1?.type,
		"vice2" = vice2?.type,
		"vice3" = vice3?.type,
		"vice4" = vice4?.type,
		"vice5" = vice5?.type,
		"vice6" = vice6?.type,
		"vice7" = vice7?.type,
		"vice8" = vice8?.type,
		"loadout" = loadout?.type,
		"loadout2" = loadout2?.type,
		"loadout3" = loadout3?.type,
		"loadout4" = loadout4?.type,
		"loadout5" = loadout5?.type,
		"loadout6" = loadout6?.type,
		"loadout7" = loadout7?.type,
		"loadout8" = loadout8?.type,
		"loadout9" = loadout9?.type,
		"loadout10" = loadout10?.type,
		"loadout_1_name" = loadout_1_name,
		"loadout_2_name" = loadout_2_name,
		"loadout_3_name" = loadout_3_name,
		"loadout_4_name" = loadout_4_name,
		"loadout_5_name" = loadout_5_name,
		"loadout_6_name" = loadout_6_name,
		"loadout_7_name" = loadout_7_name,
		"loadout_8_name" = loadout_8_name,
		"loadout_9_name" = loadout_9_name,
		"loadout_10_name" = loadout_10_name,
		"loadout_1_desc" = loadout_1_desc,
		"loadout_2_desc" = loadout_2_desc,
		"loadout_3_desc" = loadout_3_desc,
		"loadout_4_desc" = loadout_4_desc,
		"loadout_5_desc" = loadout_5_desc,
		"loadout_6_desc" = loadout_6_desc,
		"loadout_7_desc" = loadout_7_desc,
		"loadout_8_desc" = loadout_8_desc,
		"loadout_9_desc" = loadout_9_desc,
		"loadout_10_desc" = loadout_10_desc,
		"loadout_1_hex" = loadout_1_hex,
		"loadout_2_hex" = loadout_2_hex,
		"loadout_3_hex" = loadout_3_hex,
		"loadout_4_hex" = loadout_4_hex,
		"loadout_5_hex" = loadout_5_hex,
		"loadout_6_hex" = loadout_6_hex,
		"loadout_7_hex" = loadout_7_hex,
		"loadout_8_hex" = loadout_8_hex,
		"loadout_9_hex" = loadout_9_hex,
		"loadout_10_hex" = loadout_10_hex,
		"extra_language" = extra_language,
		"extra_language_1" = extra_language_1,
		"extra_language_2" = extra_language_2
	)
	
	vars["loadout_preset_[preset_slot]"] = preset
	return TRUE

/datum/preferences/proc/load_preset(preset_slot)
	if(preset_slot < 1 || preset_slot > 3)
		return FALSE
	
	var/list/preset = vars["loadout_preset_[preset_slot]"]
	if(!preset || !istype(preset, /list) || !preset.len)
		return FALSE
	
	// Save current state to history before loading preset
	save_to_history()
	
	// Restore all values from preset with validation
	// Use string_to_typepath() to handle both type paths and JSON-decoded strings
	var/statpack_type = string_to_typepath(preset["statpack"])
	if(statpack_type && ispath(statpack_type, /datum/statpack))
		statpack = new statpack_type()
	else
		statpack = new /datum/statpack/wildcard/fated()
	
	var/virtue_type = string_to_typepath(preset["virtue"])
	if(virtue_type && ispath(virtue_type, /datum/virtue))
		virtue = new virtue_type()
	else
		virtue = new /datum/virtue/none()
	
	var/virtuetwo_type = string_to_typepath(preset["virtuetwo"])
	if(virtuetwo_type && ispath(virtuetwo_type, /datum/virtue))
		virtuetwo = new virtuetwo_type()
	else
		virtuetwo = new /datum/virtue/none()

	var/origin_virtue_type = string_to_typepath(preset["origin_virtue"])
	if(origin_virtue_type && ispath(origin_virtue_type, /datum/virtue))
		origin_virtue = GLOB.virtues[origin_virtue_type]
	else
		origin_virtue = null

	origin_items = null
	var/list/preset_origin_items = preset["origin_items"]
	if(islist(preset_origin_items))
		for(var/item_entry in preset_origin_items)
			var/item_type = string_to_typepath(item_entry)
			if(!item_type)
				item_type = string_to_typepath(preset_origin_items[item_entry])
			if(!item_type || !ispath(item_type, /datum/virtue))
				continue
			var/datum/virtue/item_virtue = GLOB.virtues[item_type]
			if(item_virtue)
				LAZYADD(origin_items, item_virtue)
	if(LAZYLEN(origin_items) > 2)
		origin_items.Cut(3)
	if(!LAZYLEN(origin_items))
		origin_items = null

	feats = null
	var/list/preset_feats = preset["feats"]
	if(islist(preset_feats))
		for(var/feat_entry in preset_feats)
			var/feat_type = string_to_typepath(feat_entry)
			if(!feat_type)
				feat_type = string_to_typepath(preset_feats[feat_entry])
			if(!feat_type || !ispath(feat_type, /datum/virtue))
				continue
			var/datum/virtue/feat_virtue = GLOB.virtues[feat_type]
			if(feat_virtue)
				LAZYADD(feats, feat_virtue)
	if(LAZYLEN(feats) > get_max_feats())
		feats.Cut(get_max_feats() + 1)
	if(!LAZYLEN(feats))
		feats = null
	
	// Restore custom origin skills
	var/list/preset_custom_skills = preset["custom_origin_skills"]
	if(islist(preset_custom_skills))
		custom_origin_skills = preset_custom_skills.Copy()
	else
		custom_origin_skills = null
	var/list/preset_custom_levels = preset["custom_origin_levels"]
	if(islist(preset_custom_levels))
		custom_origin_levels = preset_custom_levels.Copy()
	else
		custom_origin_levels = null
	custom_origin_points_spent = preset["custom_origin_points_spent"] || 0
	
	var/vice1_type = string_to_typepath(preset["vice1"])
	if(vice1_type && ispath(vice1_type, /datum/charflaw))
		vice1 = new vice1_type()
	else
		vice1 = null
	
	var/vice2_type = string_to_typepath(preset["vice2"])
	if(vice2_type && ispath(vice2_type, /datum/charflaw))
		vice2 = new vice2_type()
	else
		vice2 = null
	
	var/vice3_type = string_to_typepath(preset["vice3"])
	if(vice3_type && ispath(vice3_type, /datum/charflaw))
		vice3 = new vice3_type()
	else
		vice3 = null
	
	var/vice4_type = string_to_typepath(preset["vice4"])
	if(vice4_type && ispath(vice4_type, /datum/charflaw))
		vice4 = new vice4_type()
	else
		vice4 = null
	
	var/vice5_type = string_to_typepath(preset["vice5"])
	if(vice5_type && ispath(vice5_type, /datum/charflaw))
		vice5 = new vice5_type()
	else
		vice5 = null

	var/vice6_type = string_to_typepath(preset["vice6"])
	if(vice6_type && ispath(vice6_type, /datum/charflaw))
		vice6 = new vice6_type()
	else
		vice6 = null

	var/vice7_type = string_to_typepath(preset["vice7"])
	if(vice7_type && ispath(vice7_type, /datum/charflaw))
		vice7 = new vice7_type()
	else
		vice7 = null

	var/vice8_type = string_to_typepath(preset["vice8"])
	if(vice8_type && ispath(vice8_type, /datum/charflaw))
		vice8 = new vice8_type()
	else
		vice8 = null
	
	// Load loadout types and instantiate them if valid
	var/loadout_type = string_to_typepath(preset["loadout"])
	if(loadout_type && ispath(loadout_type, /datum/loadout_item))
		loadout = new loadout_type()
	else
		loadout = null
	
	var/loadout_type2 = string_to_typepath(preset["loadout2"])
	if(loadout_type2 && ispath(loadout_type2, /datum/loadout_item))
		loadout2 = new loadout_type2()
	else
		loadout2 = null
	
	var/loadout_type3 = string_to_typepath(preset["loadout3"])
	if(loadout_type3 && ispath(loadout_type3, /datum/loadout_item))
		loadout3 = new loadout_type3()
	else
		loadout3 = null
	
	var/loadout_type4 = string_to_typepath(preset["loadout4"])
	if(loadout_type4 && ispath(loadout_type4, /datum/loadout_item))
		loadout4 = new loadout_type4()
	else
		loadout4 = null
	
	var/loadout_type5 = string_to_typepath(preset["loadout5"])
	if(loadout_type5 && ispath(loadout_type5, /datum/loadout_item))
		loadout5 = new loadout_type5()
	else
		loadout5 = null
	
	var/loadout_type6 = string_to_typepath(preset["loadout6"])
	if(loadout_type6 && ispath(loadout_type6, /datum/loadout_item))
		loadout6 = new loadout_type6()
	else
		loadout6 = null
	
	var/loadout_type7 = string_to_typepath(preset["loadout7"])
	if(loadout_type7 && ispath(loadout_type7, /datum/loadout_item))
		loadout7 = new loadout_type7()
	else
		loadout7 = null
	
	var/loadout_type8 = string_to_typepath(preset["loadout8"])
	if(loadout_type8 && ispath(loadout_type8, /datum/loadout_item))
		loadout8 = new loadout_type8()
	else
		loadout8 = null
	
	var/loadout_type9 = string_to_typepath(preset["loadout9"])
	if(loadout_type9 && ispath(loadout_type9, /datum/loadout_item))
		loadout9 = new loadout_type9()
	else
		loadout9 = null
	
	var/loadout_type10 = string_to_typepath(preset["loadout10"])
	if(loadout_type10 && ispath(loadout_type10, /datum/loadout_item))
		loadout10 = new loadout_type10()
	else
		loadout10 = null
	
	// Always restore all string values from preset (including null/empty values)
	loadout_1_name = preset["loadout_1_name"]
	loadout_2_name = preset["loadout_2_name"]
	loadout_3_name = preset["loadout_3_name"]
	loadout_4_name = preset["loadout_4_name"]
	loadout_5_name = preset["loadout_5_name"]
	loadout_6_name = preset["loadout_6_name"]
	loadout_7_name = preset["loadout_7_name"]
	loadout_8_name = preset["loadout_8_name"]
	loadout_9_name = preset["loadout_9_name"]
	loadout_10_name = preset["loadout_10_name"]
	
	loadout_1_desc = preset["loadout_1_desc"]
	loadout_2_desc = preset["loadout_2_desc"]
	loadout_3_desc = preset["loadout_3_desc"]
	loadout_4_desc = preset["loadout_4_desc"]
	loadout_5_desc = preset["loadout_5_desc"]
	loadout_6_desc = preset["loadout_6_desc"]
	loadout_7_desc = preset["loadout_7_desc"]
	loadout_8_desc = preset["loadout_8_desc"]
	loadout_9_desc = preset["loadout_9_desc"]
	loadout_10_desc = preset["loadout_10_desc"]
	
	loadout_1_hex = preset["loadout_1_hex"]
	loadout_2_hex = preset["loadout_2_hex"]
	loadout_3_hex = preset["loadout_3_hex"]
	loadout_4_hex = preset["loadout_4_hex"]
	loadout_5_hex = preset["loadout_5_hex"]
	loadout_6_hex = preset["loadout_6_hex"]
	loadout_7_hex = preset["loadout_7_hex"]
	loadout_8_hex = preset["loadout_8_hex"]
	loadout_9_hex = preset["loadout_9_hex"]
	loadout_10_hex = preset["loadout_10_hex"]
	
	// Always set languages from preset (including null/empty values)
	extra_language = preset["extra_language"]
	extra_language_1 = preset["extra_language_1"]
	extra_language_2 = preset["extra_language_2"]
	
	return TRUE

/datum/preferences/proc/clear_preset(preset_slot)
	if(preset_slot < 1 || preset_slot > 3)
		return FALSE
	
	vars["loadout_preset_[preset_slot]"] = null
	return TRUE

/datum/preferences/proc/get_preset_summary(preset_slot)
	if(preset_slot < 1 || preset_slot > 3)
		return "Invalid Slot"
	
	var/list/preset = vars["loadout_preset_[preset_slot]"]
	if(!preset || !preset.len)
		return "Empty"
	
	// Build summary string
	var/summary = ""
	
	// Statpack - use string_to_typepath for JSON-decoded strings
	var/statpack_path = string_to_typepath(preset["statpack"])
	if(ispath(statpack_path, /datum/statpack))
		var/datum/statpack/sp_temp = new statpack_path()
		summary += "[sp_temp.name]"
	
	// Virtue - use string_to_typepath for JSON-decoded strings
	var/virtue_path = string_to_typepath(preset["virtue"])
	if(ispath(virtue_path, /datum/virtue))
		var/datum/virtue/v_temp = new virtue_path()
		if(v_temp.name != "None")
			summary += " | [v_temp.name]"
	
	// Count vices
	var/vice_count = 0
	for(var/i = 1 to 5)
		var/vice_path = string_to_typepath(preset["vice[i]"])
		if(ispath(vice_path, /datum/charflaw))
			vice_count++
	if(vice_count > 0)
		summary += " | [vice_count] vice[vice_count > 1 ? "s" : ""]"
	
	// Count loadout items
	var/loadout_count = 0
	for(var/i = 1 to 10)
		var/loadout_var = i == 1 ? "loadout" : "loadout[i]"
		var/loadout_path = string_to_typepath(preset[loadout_var])
		if(ispath(loadout_path, /datum/loadout_item))
			loadout_count++
	if(loadout_count > 0)
		summary += " | [loadout_count] item[loadout_count > 1 ? "s" : ""]"
	
	return summary

/datum/preferences/proc/open_vices_menu(mob/user)
	if(!user || !user.client)
		return
	
	// Clean up duplicate vices/virtues (one-time fix for existing characters)
	fix_duplicate_vices()
	
	var/html_content = generate_vices_html(user)
	user << browse(html_content, "window=character_custom;size=1050x720")

/datum/preferences/proc/fix_duplicate_vices()
	// Remove duplicate vices across slots
	var/list/seen_vices = list()
	for(var/i = 1 to 8)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice)
			if(vice.type in seen_vices)
				// Duplicate found, clear this slot
				vars["	[i]"] = null
			else
				seen_vices += vice.type

/datum/preferences/proc/generate_vices_html(mob/user)
	// Use same colors as main character creation menu
	var/list/theme = list(
		"bg" = "#100000",
		"text" = "#aa8f8f",
		"label" = "#aa8f8f",
		"border" = "#7b5353",
		"panel" = "#00000066",
		"panel_dark" = "#00000044",
		"button_hover" = "rgba(123, 83, 83, 0.3)"
	)
	
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<style>
			body {
				font-family: Verdana, Arial, sans-serif;
				font-size: 12px;
				background: #100000 url('flowers.png') repeat;
				color: [theme["text"]];
				margin: 0;
				padding: 0;
			}
			.header {
				text-align: center;
				padding: 5px;
				background: [theme["panel_dark"]];
				border-bottom: 2px solid [theme["border"]];
			}
			.header h1 {
				margin: 0;
				color: [theme["text"]];
				font-size: 1.0em;
			}
			.header p {
				margin: 2px 0;
				font-size: 0.65em;
				color: [theme["label"]];
			}
			.tabs {
				display: flex;
				background: [theme["panel"]];
				border-bottom: 1px solid [theme["border"]];
				padding: 0;
				margin: 0;
			}
			.tab {
				flex: 1;
				padding: 6px 10px;
				text-align: center;
				background: [theme["panel_dark"]];
				border-right: 1px solid [theme["border"]];
				color: [theme["label"]];
				cursor: pointer;
				text-decoration: none;
				display: block;
				font-size: 0.7em;
			}
			.tab:hover {
				background: [theme["button_hover"]];
				color: [theme["text"]];
			}
			.tab.active {
				background: [theme["button_hover"]];
				color: [theme["text"]];
			}
			.tab-content {
				padding: 8px;
				display: none;
			}
			.tab-content.active {
				display: block;
			}
			.vices-grid {
				display: grid;
				grid-template-columns: repeat(3, 1fr);
				gap: 5px;
			}
			.vice-slot {
				background: [theme["panel_dark"]];
				border: 1px solid [theme["border"]];
				padding: 6px;
			}
			.vice-slot.required {
				border-color: [theme["border"]];
			}
			.vice-slot:hover {
				border-color: [theme["border"]];
			}
			.slot-header {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 4px;
				padding-bottom: 3px;
				border-bottom: 1px solid [theme["border"]];
			}
			.slot-number {
				font-weight: bold;
				color: [theme["text"]];
				font-size: 0.7em;
			}
			.slot-required {
				background: [theme["border"]];
				color: [theme["bg"]];
				padding: 1px 5px;
				font-size: 0.6em;
				font-weight: bold;
			}
			.slot-cost {
				background: #4CAF50;
				color: #1C0000;
				padding: 1px 5px;
				font-size: 0.65em;
				font-weight: bold;
			}
			.vice-display {
				display: flex;
				align-items: flex-start;
				margin-bottom: 4px;
			}
			.vice-info {
				flex: 1;
			}
			.vice-name {
				font-weight: bold;
				color: [theme["text"]];
				margin-bottom: 2px;
				font-size: 0.75em;
			}
			.vice-desc {
				font-size: 0.65em;
				color: [theme["label"]];
				line-height: 1.2;
			}
			.btn {
				padding: 3px 6px;
				border: 1px solid [theme["border"]];
				background: [theme["panel_dark"]];
				color: [theme["text"]];
				cursor: pointer;
				font-family: Verdana, Arial, sans-serif;
				font-size: 0.6em;
				text-decoration: none;
				display: inline-block;
				margin: 1px;
			}
			.btn:hover {
				background: [theme["button_hover"]];
				border-color: [theme["border"]];
			}
			.btn-select {
				background: rgba(76, 175, 80, 0.3);
				border-color: #4CAF50;
				color: #4CAF50;
			}
			.btn-select:hover {
				background: rgba(76, 175, 80, 0.5);
			}
			.btn-clear {
				background: rgba(244, 67, 54, 0.3);
				border-color: #f44336;
				color: #f44336;
			}
			.btn-clear:hover {
				background: rgba(244, 67, 54, 0.5);
			}
			.btn-customize {
				background: rgba(33, 150, 243, 0.3);
				border-color: #2196F3;
				color: #2196F3;
			}
			.btn-customize:hover {
				background: rgba(33, 150, 243, 0.5);
			}
			.btn-color {
				background: rgba(156, 39, 176, 0.3);
				border-color: #9C27B0;
				color: #9C27B0;
			}
			.btn-color:hover {
				background: rgba(156, 39, 176, 0.5);
			}
			.empty-slot {
				text-align: center;
				padding: 8px;
				color: [theme["label"]];
				font-style: italic;
				font-size: 0.7em;
			}
			.actions {
				margin-top: 4px;
				display: flex;
				flex-wrap: wrap;
				gap: 3px;
			}
			.statpack-section {
				background: [theme["button_hover"]];
				border: 2px solid [theme["border"]];
				padding: 10px;
				margin-bottom: 10px;
			}
			.statpack-section h2 {
				margin: 0 0 6px 0;
				color: [theme["text"]];
				font-size: 1.05em;
				border-bottom: 1px solid [theme["border"]];
				padding-bottom: 6px;
			}
			.statpack-current {
				background: [theme["panel_dark"]];
				padding: 8px;
				margin: 6px 0;
				border: 1px solid [theme["border"]];
			}
			.statpack-name {
				font-weight: bold;
				color: [theme["text"]];
				font-size: 0.95em;
				margin-bottom: 4px;
			}
			.statpack-desc {
				color: [theme["label"]];
				line-height: 1.3;
				margin-bottom: 5px;
				font-size: 0.8em;
			}
			.statpack-stats {
				color: #4CAF50;
				font-style: italic;
				font-size: 0.75em;
			}
		</style>
		<script>
			function showTab(tabName) {
				// Hide all tab contents
				var contents = document.getElementsByClassName('tab-content');
				for(var i = 0; i < contents.length; i++) {
					contents\[i\].classList.remove('active');
				}
				
				// Remove active from all tabs
				var tabs = document.getElementsByClassName('tab');
				for(var i = 0; i < tabs.length; i++) {
					tabs\[i\].classList.remove('active');
				}
				
				// Show selected tab content
				document.getElementById(tabName).classList.add('active');
				event.target.classList.add('active');
				
				// Save current tab to cookie
				document.cookie = 'vices_menu_tab=' + tabName + '; path=/';
			}
			
			// Restore active tab on load
			window.onload = function() {
				var cookies = document.cookie.split(';');
				var activeTab = 'traits';
				for(var i = 0; i < cookies.length; i++) {
					var cookie = cookies\[i\].trim();
					if(cookie.indexOf('vices_menu_tab=') == 0) {
						activeTab = cookie.substring('vices_menu_tab='.length);
						break;
					}
				}
				
				// Activate the saved tab
				if(activeTab && document.getElementById(activeTab)) {
					var contents = document.getElementsByClassName('tab-content');
					for(var i = 0; i < contents.length; i++) {
						contents\[i\].classList.remove('active');
					}
					
					var tabs = document.getElementsByClassName('tab');
					for(var i = 0; i < tabs.length; i++) {
						tabs\[i\].classList.remove('active');
						if(tabs\[i\].getAttribute('onclick') && tabs\[i\].getAttribute('onclick').indexOf(activeTab) >= 0) {
							tabs\[i\].classList.add('active');
						}
					}
					
					document.getElementById(activeTab).classList.add('active');
				}
			};
		</script>
		<body>
			<div class="header">
				<h1>Character Customization</h1>
				<p>Configure all your character features</p>
				<div style="margin-top: 10px; display: flex; gap: 5px; justify-content: center; flex-wrap: wrap;">
					<a class='btn' href='byond://?src=\ref[src];undo_action=undo' style='font-size: 0.85em;'>⟲ Undo Last Change ([customization_history.len] available)</a>
					<a class='btn btn-clear' href='byond://?src=\ref[src];virtue_action=reset_virtues_vices' style='font-size: 0.85em;'>⚠ Reset Virtues/Vices</a>
					<a class='btn btn-clear' href='byond://?src=\ref[src];loadout_action=reset_loadout_languages' style='font-size: 0.85em;'>⚠ Reset Loadout/Languages</a>
				</div>
			</div>
			
			<div class="tabs">
				<a class="tab active" onclick="showTab('traits')">Traits & Virtues</a>
				<a class="tab" onclick="showTab('loadout')">Loadout Items</a>
				<a class="tab" onclick="showTab('languages')">Languages</a>
			</div>
			
			<div id="traits" class="tab-content active">
			
		<div class="statpack-section">
			<h2>Statpack Selection</h2>
			<div class="statpack-current">"}
	
	// Build statpack name with stats inline
	if(statpack)
		var/stats_string = statpack.generate_modifier_string()
		if(stats_string)
			html += "<div class='statpack-name'>[statpack.name] <span class='statpack-stats'>" + stats_string + "</span></div>"
		else
			html += "<div class='statpack-name'>[statpack.name]</div>"
		html += {"<div class="statpack-desc">[statpack.desc]</div>"}
	else
		html += "<div class='statpack-name'>None Selected</div>"
	
	html += {"		</div>
			<div class="actions">
				<a class='btn btn-select' href='byond://?src=\ref[src];statpack_action=change'>Change Statpack</a>
		</div>
	</div>
		<div class="statpack-section">
			<h2>Build Your Own Destiny</h2>
			<p style='font-size: 0.75em; margin: 4px 0; color: [theme["label"]];'>Select skills to represent your early training and experience. Choose up to 10 points worth of skills. Novice costs 1 point, Apprentice costs 3 points total.</p>"}
	
	// Calculate custom origin points
	var/origin_points_spent = 0
	var/origin_points_max = 10
	if(LAZYLEN(custom_origin_skills))
		for(var/i = 1 to length(custom_origin_skills))
			var/level = custom_origin_levels[i]
			if(level == 1)  // Novice
				origin_points_spent += 1
			else if(level == 2)  // Apprentice
				origin_points_spent += 3
	var/origin_points_remaining = origin_points_max - origin_points_spent
	
	// Point tracker
	html += "<p style='font-size: 0.85em; margin: 6px 0; padding: 6px; background: rgba(0,0,0,0.2); border-left: 3px solid [origin_points_remaining > 0 ? theme["accent"] : (origin_points_remaining == 0 ? "#28a745" : "#dc3545")]; color: [origin_points_remaining >= 0 ? theme["text"] : "#dc3545"];'>"
	html += "<strong>Origin Points:</strong> [origin_points_spent]/[origin_points_max] spent | <strong>[origin_points_remaining]</strong> remaining"
	html += "<br><span style='font-size: 0.9em;'>Novice = 1 point | Apprentice = 3 points total</span></p>"
	
	// Display selected skills
	html += "<div class='statpack-current'>"
	if(LAZYLEN(custom_origin_skills))
		for(var/i = 1 to length(custom_origin_skills))
			var/skill_path = custom_origin_skills[i]
			var/level = custom_origin_levels[i]
			var/datum/skill/S = skill_path  // This will be the path type
			var/skill_name = initial(S.name)
			var/skill_desc = initial(S.desc)
			var/level_name = (level == 1) ? "Novice" : "Apprentice"
			var/point_cost = (level == 1) ? 1 : 3
			
			html += "<div style='margin-bottom: 8px; padding: 6px; background: rgba(0,0,0,0.15); border-left: 2px solid [theme["accent"]];'>"
			html += "<div style='font-weight: bold; color: [theme["text"]];'>[skill_name] ([level_name] - [point_cost] pt\s)</div>"
			html += "<div style='font-size: 0.8em; color: [theme["label"]]; margin-top: 2px;'>[skill_desc]</div>"
			html += "<div class='actions' style='margin-top: 4px;'>"
			html += "<a class='btn btn-clear' style='font-size: 0.8em; padding: 3px 8px;' href='byond://?src=\ref[src];custom_origin_action=remove_skill;index=[i]'>Remove</a>"
			html += "</div>"
			html += "</div>"
	else
		html += "<div class='vice-name'>No Skills Selected</div>"
		html += "<div class='vice-desc' style='font-style: italic;'>Add skills to build your custom origin background.</div>"
	html += "</div>"
	
	html += {"
			<div class="actions">"}
	
	if(origin_points_remaining > 0)
		html += "<a class='btn btn-select' href='byond://?src=\ref[src];custom_origin_action=add_skill'>+ Add Skill ([origin_points_remaining] points remaining)</a>"
	else
		html += "<a class='btn btn-select' style='opacity: 0.5; cursor: not-allowed;' title='No points remaining'>+ Add Skill (0 points remaining)</a>"
	
	if(LAZYLEN(custom_origin_skills))
		html += "<a class='btn btn-clear' href='byond://?src=\ref[src];custom_origin_action=clear_all'>Clear All</a>"
	
	html += {"
			</div>
		</div>"}
	
	/* HIDDEN: Origin Heirloom section - code preserved but not displayed in UI
	   Uncomment this block to re-enable origin items in the UI
	
	html += {"
		<div class="statpack-section">
			<h2>Upbringing: Origin Heirloom</h2>
			<p style='font-size: 0.75em; margin: 4px 0; color: [theme["label"]];'>Select ONE origin heirloom. This is an item from your past.</p>"}
	
	// Display origin items
	var/item_count = LAZYLEN(origin_items)
	for(var/i = 1 to 1)
		html += "<div class='statpack-current' style='margin-top: 8px;'>"
		
		if(i <= item_count)
			var/datum/virtue/item = origin_items[i]
			html += generate_virtue_display_html(item)
			html += "<div class='actions' style='margin-top: 6px;'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=change_item;slot=[i]'>Change Item</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[src];virtue_action=clear_item;slot=[i]'>Clear</a>"
			html += "</div>"
		else
			html += "<div class='vice-name'>Heirloom Slot [i]: Empty</div>"
			html += "<div class='vice-desc' style='font-style: italic;'>Empty heirloom slot</div>"
			html += "<div class='actions' style='margin-top: 6px;'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=select_item;slot=[i]'>Select Heirloom</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
		</div>"}
	*/ // End of hidden origin items section
	
	html += {"
		<div class="statpack-section">
			<h2>Upbringing: Feats</h2>"}
	
	var/remaining_points = get_remaining_virtue_points()
	var/max_points = get_max_virtue_points()
	var/spent_points = get_spent_virtue_points()
	
	html += "<p style='font-size: 0.75em; margin: 4px 0; color: [theme["label"]];'>Select as many feats as you can afford. These are extraordinary abilities limited only by your virtue points.</p>"
	html += "<p style='font-size: 0.85em; margin: 6px 0; padding: 6px; background: rgba(0,0,0,0.2); border-left: 3px solid [remaining_points > 0 ? theme["accent"] : "#dc3545"]; color: [remaining_points > 0 ? theme["text"] : "#dc3545"];'>"
	html += "<strong>Virtue Points:</strong> [spent_points]/[max_points] spent | <strong>[remaining_points]</strong> remaining"
	html += "<br><span style='font-size: 0.9em;'>The points vary from most impactful virtues 7 - 5 points to least impactful ones 1 - 0 points.</span></p>"
	
	// Display feats
	var/feat_count = LAZYLEN(feats)
	if(feat_count > 0)
		for(var/i = 1 to feat_count)
			var/datum/virtue/feat = feats[i]
			html += "<div class='statpack-current' style='margin-top: 8px;'>"
			html += generate_virtue_display_html(feat)
			html += "<div class='actions' style='margin-top: 6px;'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=change_feat;slot=[i]'>Change Feat</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[src];virtue_action=clear_feat;slot=[i]'>Remove</a>"
			html += "</div>"
			html += "</div>"
	
	// Show add button if we have points remaining
	if(remaining_points > 0)
		html += "<div class='actions' style='margin-top: 8px;'>"
		html += "<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=add_feat' style='padding: 6px 12px;'>+ Add Feat ([remaining_points] points remaining)</a>"
		html += "</div>"
	else if(feat_count == 0)
		html += "<div class='actions' style='margin-top: 8px;'>"
		html += "<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=add_feat' style='padding: 6px 12px;'>+ Add Feat (browse free options)</a>"
		html += "</div>"
	else
		html += "<p style='font-size: 0.7em; margin-top: 8px; color: [theme["label"]]; font-style: italic;'>No remaining points. Remove feats or select vices to gain more points.</p>"
	
	html += {"
		</div>"}
	
	// Virtuous statpack bonus virtue section
	if(statpack && statpack.name == "Virtuous")
		html += {"
		<div class="statpack-section">
			<h2>Virtuous Bonus Virtue</h2>
			<p style='font-size: 0.75em; margin: 4px 0; color: [theme["label"]];'><strong>Special:</strong> As a Virtuous character, you can select ANY additional virtue from ANY category, including virtue packs!</p>
			<div class="statpack-current">"}
		
		// Display virtuetwo
		if(virtuetwo && virtuetwo.type != /datum/virtue/none)
			html += generate_virtue_display_html(virtuetwo)
			html += "<div class='actions' style='margin-top: 6px;'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=change_secondary'>Change Bonus Virtue</a>"
			html += "</div>"
		else
			html += "<div class='vice-name'>No Bonus Virtue Selected</div>"
			html += "<div class='actions' style='margin-top: 6px;'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=change_secondary'>Select Bonus Virtue</a>"
			html += "</div>"
		
		html += {"		</div>
		</div>"}
	
	html += {"
		
		<h2 style='color: [theme["text"]]; padding: 0 20px; margin: 20px 0 10px 0; border-bottom: 1px solid [theme["border"]]; padding-bottom: 10px;'>Vice Selection</h2>
		<p style='color: [theme["label"]]; padding: 0 20px; margin: 0 0 15px 0; font-size: 0.9em;'>Select up to 8 vices (at least 1 required).</p>			<div class="vices-grid">
	"}
	
	// Generate 8 vice slots
	for(var/i = 1 to 8)
		var/slot_var = "vice[i]"
		var/datum/charflaw/current_vice = vars[slot_var]
		var/is_required = (i == 1)
		
		html += "<div class='vice-slot[is_required ? " required" : ""]'>"
		html += "<div class='slot-header'>"
		html += "<span class='slot-number'>Vice Slot [i]</span>"
		
		if(is_required)
			html += "<span class='slot-required'>REQUIRED</span>"
		
		if(current_vice)
			// In point-buy, every vice contributes +1 point
			html += "<span class='slot-cost'>+1 Point</span>"
		
		html += "</div>"
		
		if(current_vice)
			// Vice is selected
			html += "<div class='vice-display'>"
			html += "<div class='vice-info'>"
			html += "<div class='vice-name'>[current_vice.name]</div>"
			html += "<div class='vice-desc'>[current_vice.desc]</div>"
			
			// Show faction info for Averse and Paranoid vices
			if(istype(current_vice, /datum/charflaw/averse))
				var/faction_name = "None"
				if(averse_chosen_faction)
					for(var/fname in GLOB.averse_factions)
						if(GLOB.averse_factions[fname] == averse_chosen_faction)
							faction_name = fname
							break
				html += "<div style='margin-top: 5px; padding: 3px; background: rgba(200,50,50,0.3); border-left: 2px solid #c83232; font-size: 0.85em;'>"
				html += "<b>Loathed Faction:</b> [faction_name]</div>"
			else if(istype(current_vice, /datum/charflaw/addiction/paranoid))
				var/faction_name = "None"
				if(paranoid_chosen_faction)
					for(var/fname in GLOB.averse_factions)
						if(GLOB.averse_factions[fname] == paranoid_chosen_faction)
							faction_name = fname
							break
				html += "<div style='margin-top: 5px; padding: 3px; background: rgba(50,100,200,0.3); border-left: 2px solid #5090ff; font-size: 0.85em;'>"
				html += "<b>Trusted Faction:</b> [faction_name]</div>"
			
			html += "</div>"
			html += "</div>"
			
			html += "<div class='actions'>"
			// Add faction selection button for Averse and Paranoid
			if(istype(current_vice, /datum/charflaw/averse))
				html += "<a class='btn' style='background: #c83232;' href='byond://?src=\ref[src];vice_action=select_faction;slot=[i];faction_type=averse'>Choose Faction</a>"
			else if(istype(current_vice, /datum/charflaw/addiction/paranoid))
				html += "<a class='btn' style='background: #5090ff;' href='byond://?src=\ref[src];vice_action=select_faction;slot=[i];faction_type=paranoid'>Choose Faction</a>"
			
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];vice_action=change;slot=[i]'>Change Vice</a>"
			if(!is_required)
				html += "<a class='btn btn-clear' href='byond://?src=\ref[src];vice_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
		else
			// Empty slot
			html += "<div class='empty-slot'>"
			if(is_required)
				html += "No Vice Selected - <b>REQUIRED</b><br><br>"
			else
				html += "Empty Slot<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];vice_action=select;slot=[i]'>Select Vice</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
			</div>
			</div>
			
		<div id="loadout" class="tab-content">
			<h2 style='color: [theme["text"]]; margin: 0 0 10px 0; font-size: 1.1em;'>Loadout Selection</h2>
	"}
	
	// Calculate point costs for loadout
	var/total_points = get_total_points()
	var/loadout_spent = 0
	for(var/i = 1 to 10)
		var/datum/loadout_item/loadout_slot = vars[i == 1 ? "loadout" : "loadout[i]"]
		if(loadout_slot && loadout_slot.triumph_cost)
			loadout_spent += loadout_slot.triumph_cost

	// Loadout uses its own point pool (not shared with languages)
	var/loadout_remaining = total_points - loadout_spent
	
	html += {"
			<div class='statpack-section'>
				<div style='font-size: 0.85em; margin-bottom: 5px;'>
					<span style='color: #4CAF50;'>Available Points: [loadout_remaining]</span> | 
					<span style='color: [theme["text"]];'>Spent (Loadout): [loadout_spent]</span> / 
					<span>Total Points: [total_points]</span>
				</div>
				<div style='background: rgba(123, 83, 83, 0.2); border: 1px solid [theme["border"]]; padding: 8px; margin-top: 8px; font-size: 0.7em;'>
					<div style='font-weight: bold; color: [theme["text"]]; margin-bottom: 4px;'>⚠ Loadout Item Modifications:</div>
					<div style='color: [theme["label"]]; line-height: 1.4;'>
						<b>ARMOR:</b> Set to armour minor protection (15 armor to all damage types) • Crit prevention removed • Armor class set to Light<br>
						<b>WEAPONS:</b> Damage reduced by 30% • Weapon defense reduced by 50%<br>
						<b>ALL ITEMS:</b> Sell price set to 0
					</div>
				</div>
			</div>
			<div style='display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px;'>
	"}
	
	// Generate loadout slots with original styling
	for(var/i = 1 to 10)
		var/slot_var = i == 1 ? "loadout" : "loadout[i]"
		var/datum/loadout_item/current_item = vars[slot_var]
		var/custom_name = vars["loadout_[i]_name"]
		var/custom_desc = vars["loadout_[i]_desc"]
		var/item_color = vars["loadout_[i]_hex"]
		
		html += "<div class='vice-slot'>"
		html += "<div class='slot-header'>"
		html += "<span class='slot-number'>Slot [i]</span>"
		
		if(current_item && current_item.triumph_cost)
			html += "<span class='slot-cost'>[current_item.triumph_cost] Points</span>"
		
		html += "</div>"
		
		if(current_item)
			// Item is selected - show with icon
			var/obj/item/sample = current_item.path
			var/icon_file = initial(sample.icon)
			var/icon_state = initial(sample.icon_state)
			var/item_desc = initial(sample.desc)
			
			html += "<div style='display: flex; align-items: center; margin-bottom: 6px;'>"
			html += "<div style='width: 48px; height: 48px; background: rgba(0,0,0,0.6); border: 1px solid #444; margin-right: 8px; display: flex; align-items: center; justify-content: center;'>"
			
			// Use the item's icon with caching
			if(icon_file && icon_state)
				var/cache_key = "[icon_file]_[icon_state]"
				if(!(cache_key in GLOB.cached_loadout_icons))
					// Prevent cache from growing too large
					if(GLOB.cached_loadout_icons.len >= MAX_ICON_CACHE_SIZE)
						GLOB.cached_loadout_icons.Cut(1, 50) // Remove oldest 50 entries
					GLOB.cached_loadout_icons[cache_key] = icon(icon_file, icon_state)
				user << browse_rsc(GLOB.cached_loadout_icons[cache_key], "loadout_icon_[i].png")
				html += "<img src='loadout_icon_[i].png' style='max-width: 46px; max-height: 46px;' />"
			
			html += "</div>"
			html += "<div style='flex: 1;'>"
			html += "<div class='vice-name'>[custom_name ? custom_name : current_item.name]</div>"
			html += "<div class='vice-desc'>[custom_desc ? custom_desc : (item_desc ? item_desc : current_item.desc)]</div>"
			
			if(custom_name || custom_desc)
				html += "<div style='margin-top: 3px; font-size: 0.7em; color: [theme["label"]];'>✎ Customized</div>"
			
			if(item_color)
				var/color_hex = clothing_color2hex(item_color)
				html += "<div style='margin-top: 3px; font-size: 0.7em; display: flex; align-items: center;'><span style='color: [color_hex];'>●</span> <span style='color: [theme["label"]]; margin-left: 3px;'>Color: [item_color]</span></div>"
			
			html += "</div>"
			html += "</div>"
			
			html += "<div class='actions'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];loadout_action=item;slot=[i]'>Change Item</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[src];loadout_action=rename;slot=[i]'>Rename</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[src];loadout_action=describe;slot=[i]'>Description</a>"
			html += "<a class='btn btn-color' href='byond://?src=\ref[src];loadout_action=color;slot=[i]'>Color</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[src];loadout_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
		else
			html += "<div class='empty-slot'>"
			html += "Empty Slot<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];loadout_action=item;slot=[i]'>Select Item</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
			</div>
		</div>
		
		<div id="languages" class="tab-content">
			<h2 style='color: [theme["text"]]; margin: 0 0 20px 0;'>📜 Additional Language Selection 📜</h2>
	"}
	
	// Calculate language costs using actual player TRIUMPHS (slot 1 = 2 triumphs, slot 2 = 4 triumphs)
	var/lang_spent = 0
	if(extra_language_1 && extra_language_1 != "None")
		lang_spent += 2
	if(extra_language_2 && extra_language_2 != "None")
		lang_spent += 4

	// Languages use ACTUAL triumph pool from player, NOT the vice/point pool
	var/total_triumphs = user.get_triumphs()
	var/lang_remaining = total_triumphs - lang_spent
	
	html += {"
			<div class='statpack-section' style='background: rgba(76, 175, 80, 0.1); border: 1px solid #4CAF50; padding: 15px; margin-bottom: 20px;'>
				<p style='margin: 0 0 10px 0;'>ℹ You get <b>one free language</b> from background, plus up to 2 additional languages. Slot 1 costs 2 Triumphs, Slot 2 costs 4 Triumphs. Your race may grant languages by default.</p>
				<div style='font-size: 1em;'>
					<span style='color: #4CAF50;'>Available Triumphs: [lang_remaining]</span> | 
					<span style='color: [theme["text"]];'>Spent (Languages): [lang_spent]</span> / 
					<span>Total Triumphs: [total_triumphs]</span>
				</div>
			</div>
			<div style='display: grid; grid-template-columns: repeat(3, 1fr); gap: 15px;'>
	"}
	
	// FREE LANGUAGE SLOT
	var/datum/language/free_lang
	if(ispath(extra_language, /datum/language))
		free_lang = new extra_language()
	
	html += "<div class='vice-slot' style='border-color: #4CAF50;'>"
	html += "<div class='slot-header'>"
	html += "<span class='slot-number'>Free Language</span>"
	html += "<span class='slot-cost' style='background: #4CAF50; color: [theme["bg"]];'>FREE</span>"
	html += "</div>"
	
	if(free_lang)
		html += "<div class='vice-display'>"
		html += "<div class='vice-info'>"
		html += "<div class='vice-name'>[free_lang.name]</div>"
		html += "<div class='vice-desc'>[free_lang.desc]</div>"
		html += "</div>"
		html += "</div>"
		html += "<div class='actions'>"
		html += "<a class='btn btn-select' href='byond://?src=\ref[src];language_action=free_change'>Change Language</a>"
		html += "</div>"
		qdel(free_lang)
	else
		html += "<div class='empty-slot'>"
		html += "No Language Selected<br><br>"
		html += "<a class='btn btn-select' href='byond://?src=\ref[src];language_action=free_select'>Select Language</a>"
		html += "</div>"
	
	html += "</div>"
	
	// Generate 2 paid language slots (slot 1 = 2 points, slot 2 = 4 points)
	for(var/i = 1 to 2)
		var/slot_var = i == 1 ? "extra_language_1" : "extra_language_2"
		var/current_lang_path = vars[slot_var]
		var/slot_cost = i == 1 ? 2 : 4
		
		html += "<div class='vice-slot'>"
		html += "<div class='slot-header'>"
		html += "<span class='slot-number'>Language Slot [i]</span>"
		if(current_lang_path && current_lang_path != "None")
			html += "<span class='slot-cost'>[slot_cost] Triumphs</span>"
		html += "</div>"
		
		if(current_lang_path && current_lang_path != "None")
			// Language is selected
			var/datum/language/lang = new current_lang_path()
			
			html += "<div class='vice-display'>"
			html += "<div class='vice-info'>"
			html += "<div class='vice-name'>[lang.name]</div>"
			html += "<div class='vice-desc'>[lang.desc]</div>"
			html += "</div>"
			html += "</div>"
			
			html += "<div class='actions'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];language_action=change;slot=[i]'>Change Language</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[src];language_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
			
			qdel(lang)
		else
			html += "<div class='empty-slot'>"
			html += "No Language Selected<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];language_action=select;slot=[i]'>Select Language</a>"
			html += "</div>"
		html += "</div>"
	
	html += "</div>"
	
	html += {"
		</div>
		
		<div style='margin-top: 20px; padding: 10px; background: [theme["panel"]]; border: 1px solid [theme["border"]];'>
			<div style='font-weight: bold; margin-bottom: 8px; color: [theme["text"]];'>📋 LOADOUT PRESETS</div>
			<div style='display: grid; grid-template-columns: repeat(3, 1fr); gap: 8px;'>
				<div style='padding: 8px; background: [theme["panel_dark"]]; border: 1px solid [theme["border"]];'>
					<div style='font-weight: bold; margin-bottom: 3px;'>Preset 1</div>
					<div style='font-size: 0.75em; color: [theme["label"]]; margin-bottom: 5px; min-height: 30px;'>[get_preset_summary(1)]</div>
					<a class='btn' href='byond://?src=\ref[src];preset_action=save;slot=1' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>💾 Save</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=load;slot=1' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>📂 Load</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=clear;slot=1' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>🗑️ Clear</a>
				</div>
				<div style='padding: 8px; background: [theme["panel_dark"]]; border: 1px solid [theme["border"]];'>
					<div style='font-weight: bold; margin-bottom: 3px;'>Preset 2</div>
					<div style='font-size: 0.75em; color: [theme["label"]]; margin-bottom: 5px; min-height: 30px;'>[get_preset_summary(2)]</div>
					<a class='btn' href='byond://?src=\ref[src];preset_action=save;slot=2' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>💾 Save</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=load;slot=2' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>📂 Load</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=clear;slot=2' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>🗑️ Clear</a>
				</div>
				<div style='padding: 8px; background: [theme["panel_dark"]]; border: 1px solid [theme["border"]];'>
					<div style='font-weight: bold; margin-bottom: 3px;'>Preset 3</div>
					<div style='font-size: 0.75em; color: [theme["label"]]; margin-bottom: 5px; min-height: 30px;'>[get_preset_summary(3)]</div>
					<a class='btn' href='byond://?src=\ref[src];preset_action=save;slot=3' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>💾 Save</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=load;slot=3' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>📂 Load</a>
					<a class='btn' href='byond://?src=\ref[src];preset_action=clear;slot=3' style='font-size: 0.7em; padding: 3px 6px; margin: 2px;'>🗑️ Clear</a>
				</div>
			</div>
		</div>
		
	</body>
	</html>
	"}
	
	return html

/datum/preferences/Topic(href, href_list)
	. = ..()
	
	// Handle loadout item selection from icon menu
	if(href_list["select_loadout_item"])
		if(!temp_loadout_selection)
			return
		
		var/item_id = href_list["select_loadout_item"]
		var/slot = text2num(href_list["slot"])
		var/list/selection_data = temp_loadout_selection
		
		var/list/items = selection_data["items"]
		var/datum/loadout_item/selected = items[item_id]
		
		if(!selected || !slot)
			temp_loadout_selection = null
			usr << browse(null, "window=loadout_select")
			return
		
		var/slot_var = (slot == 1) ? "loadout" : "loadout[slot]"
		
		// Check if this item is already selected in another slot
		for(var/i = 1 to 10)
			if(i == slot)
				continue
			var/datum/loadout_item/other_item = vars[i == 1 ? "loadout" : "loadout[i]"]
			if(other_item && other_item.type == selected.type)
				to_chat(usr, span_warning("This item is already selected in slot [i]! Each item can only be selected once."))
				temp_loadout_selection = null
				usr << browse(null, "window=loadout_select")
				return
		
		// Check point cost against loadout pool (not shared with languages)
		if(selected.triumph_cost)
			var/total_points = get_total_points()
			var/spent_points = 0
			
			// Calculate current loadout spent (excluding this slot if changing)
			for(var/i = 1 to 10)
				if(i == slot)
					continue
				var/datum/loadout_item/other_slot = vars[i == 1 ? "loadout" : "loadout[i]"]
				if(other_slot && other_slot.triumph_cost)
					spent_points += other_slot.triumph_cost
			
			if(spent_points + selected.triumph_cost > total_points)
				to_chat(usr, span_warning("Not enough points! Need [selected.triumph_cost], but only have [total_points - spent_points] remaining."))
				temp_loadout_selection = null
				usr << browse(null, "window=loadout_select")
				return
		
		vars[slot_var] = selected
		save_character()
		to_chat(usr, span_notice("Selected [selected.name] for slot [slot]."))
		
		temp_loadout_selection = null
		usr << browse(null, "window=loadout_select")
		open_vices_menu(usr)
		return
	
	// Handle preset actions
	if(href_list["preset_action"])
		var/action = href_list["preset_action"]
		var/slot = text2num(href_list["slot"])
		
		if(!slot || slot < 1 || slot > 3)
			return
		
		switch(action)
			if("save")
				if(save_preset(slot))
					save_character() // Persist preset to disk
					to_chat(usr, span_notice("Saved current setup to Preset [slot]!"))
					open_vices_menu(usr)
				else
					to_chat(usr, span_warning("Failed to save preset."))
			if("load")
				if(load_preset(slot))
					save_character() // Persist loaded state to disk
					to_chat(usr, span_notice("Loaded Preset [slot]!"))
					open_vices_menu(usr)
				else
					to_chat(usr, span_warning("Preset [slot] is empty or invalid."))
			if("clear")
				if(clear_preset(slot))
					save_character() // Persist cleared preset to disk
					to_chat(usr, span_notice("Cleared Preset [slot]."))
					open_vices_menu(usr)
				else
					to_chat(usr, span_warning("Failed to clear preset."))
		return
	
	// Handle undo action
	if(href_list["undo_action"])
		if(href_list["undo_action"] == "undo")
			if(undo_last_change())
				to_chat(usr, span_notice("Undid last change."))
				open_vices_menu(usr)
			else
				to_chat(usr, span_warning("No more changes to undo!"))
		return
	
	// Handle custom origin actions
	if(href_list["custom_origin_action"])
		var/action = href_list["custom_origin_action"]
		
		if(action == "add_skill")
			save_to_history()
			
			// Get available skills (non-combat, non-magic)
			var/list/available_skills = list()
			
			// Add craft skills
			available_skills["Crafting"] = /datum/skill/craft/crafting
			available_skills["Weaponsmithing"] = /datum/skill/craft/weaponsmithing
			available_skills["Armorsmithing"] = /datum/skill/craft/armorsmithing
			available_skills["Blacksmithing"] = /datum/skill/craft/blacksmithing
			available_skills["Smelting"] = /datum/skill/craft/smelting
			available_skills["Carpentry"] = /datum/skill/craft/carpentry
			available_skills["Masonry"] = /datum/skill/craft/masonry
			available_skills["Trapmaking"] = /datum/skill/craft/traps
			available_skills["Engineering"] = /datum/skill/craft/engineering
			available_skills["Cooking"] = /datum/skill/craft/cooking
			available_skills["Sewing"] = /datum/skill/craft/sewing
			available_skills["Skincrafting"] = /datum/skill/craft/tanning
			available_skills["Pottery"] = /datum/skill/craft/ceramics
			available_skills["Alchemy"] = /datum/skill/craft/alchemy
			
			// Add labor skills
			available_skills["Farming"] = /datum/skill/labor/farming
			available_skills["Mining"] = /datum/skill/labor/mining
			available_skills["Fishing"] = /datum/skill/labor/fishing
			available_skills["Butchering"] = /datum/skill/labor/butchering
			available_skills["Lumberjacking"] = /datum/skill/labor/lumberjacking
			
			// Add misc skills
			available_skills["Athletics"] = /datum/skill/misc/athletics
			available_skills["Climbing"] = /datum/skill/misc/climbing
			available_skills["Literacy"] = /datum/skill/misc/reading
			available_skills["Swimming"] = /datum/skill/misc/swimming
			available_skills["Pickpocketing"] = /datum/skill/misc/stealing
			available_skills["Sneaking"] = /datum/skill/misc/sneaking
			available_skills["Lockpicking"] = /datum/skill/misc/lockpicking
			available_skills["Riding"] = /datum/skill/misc/riding
			available_skills["Music"] = /datum/skill/misc/music
			available_skills["Medicine"] = /datum/skill/misc/medicine
			available_skills["Tracking"] = /datum/skill/misc/tracking
			
			// Remove already selected skills
			if(LAZYLEN(custom_origin_skills))
				for(var/skill_path in custom_origin_skills)
					for(var/display_name in available_skills)
						if(available_skills[display_name] == skill_path)
							available_skills -= display_name
							break
			
			available_skills = sort_list(available_skills)
			
			var/skill_choice = tgui_input_list(usr, "Select a skill to add:", "Add Skill", available_skills)
			if(!skill_choice)
				open_vices_menu(usr)
				return
			
			var/skill_path = available_skills[skill_choice]
			
			// Ask for level
			var/list/level_options = list()
			var/origin_points_spent = 0
			if(LAZYLEN(custom_origin_skills))
				for(var/i = 1 to length(custom_origin_skills))
					var/level = custom_origin_levels[i]
					if(level == 1)
						origin_points_spent += 1
					else if(level == 2)
						origin_points_spent += 3
			var/origin_points_remaining = 10 - origin_points_spent
			
			// Always show all options, but indicate which are affordable
			if(origin_points_remaining >= 1)
				level_options["Novice (1 point)"] = 1
			else
				level_options["Novice (1 point) - TOO EXPENSIVE"] = -1
			
			if(origin_points_remaining >= 3)
				level_options["Apprentice (3 points)"] = 2
			else
				level_options["Apprentice (3 points) - TOO EXPENSIVE"] = -2
			
			var/level_choice = tgui_input_list(usr, "Select skill level ([origin_points_remaining] points remaining):", "Skill Level", level_options)
			if(!level_choice)
				open_vices_menu(usr)
				return
			
			var/level = level_options[level_choice]
			
			// Check if they picked an unaffordable option
			if(level < 0)
				to_chat(usr, span_warning("You don't have enough points for that skill level!"))
				open_vices_menu(usr)
				return
			
			var/point_cost = (level == 1) ? 1 : 3
			
			// Add skill
			if(!custom_origin_skills)
				custom_origin_skills = list()
			if(!custom_origin_levels)
				custom_origin_levels = list()
			
			custom_origin_skills += skill_path
			custom_origin_levels += level
			
			save_character()
			to_chat(usr, span_notice("Added [skill_choice] at [level_choice] ([point_cost] point\s spent)."))
			open_vices_menu(usr)
			return
		
		if(action == "remove_skill")
			save_to_history()
			var/index = text2num(href_list["index"])
			if(!index || index < 1 || index > length(custom_origin_skills))
				return
			
			var/skill_path = custom_origin_skills[index]
			var/datum/skill/S = skill_path
			var/skill_name = initial(S.name)
			
			custom_origin_skills.Cut(index, index + 1)
			custom_origin_levels.Cut(index, index + 1)
			
			if(!length(custom_origin_skills))
				custom_origin_skills = null
				custom_origin_levels = null
			
			save_character()
			to_chat(usr, span_notice("Removed [skill_name] from your custom origin."))
			open_vices_menu(usr)
			return
		
		if(action == "clear_all")
			if(tgalert(usr, "This will remove all selected skills. Are you sure?", "Clear All Skills", "Yes", "No") != "Yes")
				return
			save_to_history()
			custom_origin_skills = null
			custom_origin_levels = null
			save_character()
			to_chat(usr, span_notice("Cleared all custom origin skills."))
			open_vices_menu(usr)
			return
	
	if(href_list["virtue_action"])
		var/action = href_list["virtue_action"]
		
		// Origin Selection
		if(action == "select_origin")
			save_to_history()
			
			var/list/origin_available = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if(V.category != "origin")
					continue
				// Skip if already selected as other virtues
				if(virtue && V.type == virtue.type)
					continue
				if(virtuetwo && V.type == virtuetwo.type)
					continue
				if(V in origin_items)
					continue
				// Check if already in feats
				var/already_in_feats = FALSE
				for(var/datum/virtue/feat in feats)
					if(feat && V.type == feat.type)
						already_in_feats = TRUE
						break
				if(already_in_feats)
					continue
				if(has_stashed_item_conflict(V, null, TRUE, usr))
					continue
				// Display name with cost - always show, mark if too expensive
				var/display_name = V.name
				var/can_afford = can_afford_virtue(V)
				if(V.virtue_cost)
					if(can_afford)
						display_name = "[V.name] ([V.virtue_cost] point\s)"
					else
						display_name = "[V.name] ([V.virtue_cost] point\s) - TOO EXPENSIVE"
				origin_available[display_name] = V
		
			origin_available = sort_list(origin_available)
			var/choice = tgui_input_list(usr, "Choose your origin:", "Origin Selection", origin_available)
			
			if(choice)
				var/datum/virtue/selected = origin_available[choice]
				if(has_stashed_item_conflict(selected, null, TRUE, usr))
					open_vices_menu(usr)
					return
				// Final check before adding
				if(!can_afford_virtue(selected))
					to_chat(usr, span_warning("You don't have enough virtue points for [choice]!"))
					open_vices_menu(usr)
					return
				origin_virtue = selected
				save_character()
				to_chat(usr, span_notice("Selected [choice] as your origin. ([selected.virtue_cost] point\s spent)"))
				to_chat(usr, "<span class='info'>[selected.desc]</span>")
			open_vices_menu(usr)
			return
		
		if(action == "clear_origin")
			save_to_history()
			origin_virtue = null
			save_character()
			enforce_feat_limit(usr)
			save_character()
			to_chat(usr, span_notice("Cleared origin selection."))
			open_vices_menu(usr)
			return
		
		if(action == "reset_virtues_vices")
			if(tgalert(usr, "This will reset ALL virtues and vices to their default states. This cannot be undone. Are you sure?", "Reset Virtues/Vices", "Yes", "No") != "Yes")
				return
			save_to_history()
			reset_virtues_and_vices()
			to_chat(usr, span_boldwarning("All virtues and vices have been reset to default."))
			open_vices_menu(usr)
			return
		
		// Origin items selection
		if(action == "select_item" || action == "change_item")
			var/slot = text2num(href_list["slot"])
			if(!slot || slot < 1 || slot > 1)
				return
			
			save_to_history()
			
			// Get the current item at this slot to calculate available points (if changing)
			var/datum/virtue/current_item = (slot <= LAZYLEN(origin_items)) ? origin_items[slot] : null
			var/refunded_points = current_item ? current_item.virtue_cost : 0
			
			var/list/items_available = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if(V.category != "origin_items")
					continue
				// Skip if already selected in another slot
				if(V in origin_items)
					continue
				// Skip if already selected as other virtues
				if(virtue && V.type == virtue.type)
					continue
				if(virtuetwo && V.type == virtuetwo.type)
					continue
				if(origin_virtue && V.type == origin_virtue.type)
					continue
				// Check if already in feats
				var/already_in_feats = FALSE
				for(var/datum/virtue/feat in feats)
					if(feat && V.type == feat.type)
						already_in_feats = TRUE
						break
				if(already_in_feats)
					continue
				if(has_stashed_item_conflict(V, current_item, TRUE, usr))
					continue
				// Check if blocked by origin
				if(is_blocked_by_origin(V))
					continue
				// Display name with cost - always show, mark if too expensive
				var/display_name = V.name
				var/can_afford = (!V.virtue_cost || (get_remaining_virtue_points() + refunded_points) >= V.virtue_cost)
				if(V.virtue_cost)
					if(can_afford)
						display_name = "[V.name] ([V.virtue_cost] point\s)"
					else
						display_name = "[V.name] ([V.virtue_cost] point\s) - TOO EXPENSIVE"
				items_available[display_name] = V
		
			items_available = sort_list(items_available)
			var/message = "Choose your origin heirloom:"
			if(action == "change_item")
				message = "Choose a new heirloom to replace the current one:"
			var/choice = tgui_input_list(usr, message, "Origin Item Selection", items_available)
			
			if(choice)
				var/datum/virtue/selected = items_available[choice]
				if(has_stashed_item_conflict(selected, current_item, TRUE, usr))
					open_vices_menu(usr)
					return
				// Check if blocked by origin
				if(is_blocked_by_origin(selected, TRUE, usr))
					open_vices_menu(usr)
					return
				
				// Final check before adding/changing
				if(selected.virtue_cost && (get_remaining_virtue_points() + refunded_points) < selected.virtue_cost)
					to_chat(usr, span_warning("You don't have enough virtue points for [choice]!"))
					open_vices_menu(usr)
					return
				
				// Replace if changing, or add if new
				if(slot <= LAZYLEN(origin_items))
					origin_items[slot] = selected
				else
					LAZYADD(origin_items, selected)
				
				save_character()
				to_chat(usr, span_notice("Selected [choice] as heirloom [slot]. ([selected.virtue_cost] point\s)"))
				to_chat(usr, "<span class='info'>[selected.desc]</span>")
			open_vices_menu(usr)
			return
		
		if(action == "clear_item")
			var/slot = text2num(href_list["slot"])
			if(!slot || slot < 1 || slot > 1)
				return
			
			save_to_history()
			
			if(slot <= LAZYLEN(origin_items))
				origin_items.Cut(slot, slot + 1)
				save_character()
				to_chat(usr, span_notice("Cleared heirloom slot [slot]."))
				open_vices_menu(usr)
			return
		
		// Feats selection
		if(action == "add_feat")
			save_to_history()
			
			var/list/feats_available = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if(V.category != "feats")
					continue
				// Exclude packs - they can only be selected via Virtuous statpack's virtuetwo
				if(istype(V, /datum/virtue/pack))
					continue
				// Skip if already selected
				if(V in feats)
					continue
				// Skip if already selected as other virtues
				if(virtue && V.type == virtue.type)
					continue
				if(virtuetwo && V.type == virtuetwo.type)
					continue
				if(origin_virtue && V.type == origin_virtue.type)
					continue
				if(V in origin_items)
					continue
				if(has_stashed_item_conflict(V, null, TRUE, usr))
					continue
				// Check if blocked by origin
				if(is_blocked_by_origin(V))
					continue
				// Check conflicts with virtue and vices
				if(check_virtue_vice_conflict(V.type, TRUE, usr))
					continue
				// Display name with cost - always show, mark if too expensive
				var/display_name = V.name
				var/can_afford = can_afford_virtue(V)
				if(V.virtue_cost)
					if(can_afford)
						display_name = "[V.name] ([V.virtue_cost] point\s)"
					else
						display_name = "[V.name] ([V.virtue_cost] point\s) - TOO EXPENSIVE"
				feats_available[display_name] = V
		
			feats_available = sort_list(feats_available)
			var/choice = tgui_input_list(usr, "Choose a feat:", "Feat Selection", feats_available)
			
			if(choice)
				var/datum/virtue/selected = feats_available[choice]
				if(has_stashed_item_conflict(selected, null, TRUE, usr))
					open_vices_menu(usr)
					return
				// Check if blocked by origin
				if(is_blocked_by_origin(selected, TRUE, usr))
					open_vices_menu(usr)
					return
				// Final check before adding
				if(!can_afford_virtue(selected))
					to_chat(usr, span_warning("You don't have enough virtue points for [choice]! ([selected.virtue_cost] required, [get_remaining_virtue_points()] available)"))
					open_vices_menu(usr)
					return
				LAZYADD(feats, selected)
				save_character()
				to_chat(usr, span_notice("Selected [choice] as a feat. ([selected.virtue_cost] point\s spent)"))
				to_chat(usr, "<span class='info'>[selected.desc]</span>")
			open_vices_menu(usr)
			return
		
		if(action == "change_feat")
			var/slot = text2num(href_list["slot"])
			if(!slot || slot < 1 || slot > LAZYLEN(feats))
				return
			
			save_to_history()
			
			// Get the current feat at this slot to calculate available points
			var/datum/virtue/current_feat = feats[slot]
			var/refunded_points = current_feat ? current_feat.virtue_cost : 0
			
			var/list/feats_available = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if(V.category != "feats")
					continue
				// Exclude packs - they can only be selected via Virtuous statpack's virtuetwo
				if(istype(V, /datum/virtue/pack))
					continue
				// Skip if already selected in another slot
				if(V in feats)
					continue
				// Skip if already selected as other virtues
				if(virtue && V.type == virtue.type)
					continue
				if(virtuetwo && V.type == virtuetwo.type)
					continue
				if(origin_virtue && V.type == origin_virtue.type)
					continue
				if(V in origin_items)
					continue
				if(has_stashed_item_conflict(V, current_feat, TRUE, usr))
					continue
				// Check if blocked by origin
				if(is_blocked_by_origin(V))
					continue
				// Check conflicts
				if(check_virtue_vice_conflict(V.type, TRUE, usr))
					continue
				// Display name with cost - always show, mark if too expensive
				var/display_name = V.name
				var/can_afford = (!V.virtue_cost || (get_remaining_virtue_points() + refunded_points) >= V.virtue_cost)
				if(V.virtue_cost)
					if(can_afford)
						display_name = "[V.name] ([V.virtue_cost] point\s)"
					else
						display_name = "[V.name] ([V.virtue_cost] point\s) - TOO EXPENSIVE"
				feats_available[display_name] = V
		
			feats_available = sort_list(feats_available)
			var/choice = tgui_input_list(usr, "Choose a new feat to replace [current_feat.name]:", "Change Feat", feats_available)
			
			if(choice)
				var/datum/virtue/selected = feats_available[choice]
				if(has_stashed_item_conflict(selected, current_feat, TRUE, usr))
					open_vices_menu(usr)
					return
				// Check if blocked by origin
				if(is_blocked_by_origin(selected, TRUE, usr))
					open_vices_menu(usr)
					return
				// Final check before changing
				if(selected.virtue_cost && (get_remaining_virtue_points() + refunded_points) < selected.virtue_cost)
					to_chat(usr, span_warning("You don't have enough virtue points for [choice]!"))
					open_vices_menu(usr)
					return
				feats[slot] = selected
				save_character()
				to_chat(usr, span_notice("Changed feat slot [slot] to [choice]. ([selected.virtue_cost] point\s)"))
				to_chat(usr, "<span class='info'>[selected.desc]</span>")
			open_vices_menu(usr)
			return
		
		if(action == "clear_feat")
			var/slot = text2num(href_list["slot"])
			if(!slot || slot < 1 || slot > LAZYLEN(feats))
				return
			
			save_to_history()
			feats.Cut(slot, slot + 1)
			save_character()
			to_chat(usr, span_notice("Removed feat from slot [slot]."))
			open_vices_menu(usr)
			return
		
		// Legacy handlers (kept for compatibility if needed, but can be removed eventually)
		if(action == "change_primary")
			// Save state before change
			save_to_history()
			// Build virtue list
			var/list/virtues_available = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				// Skip if already selected as secondary virtue
				if(virtuetwo && V.type == virtuetwo.type)
					continue
				// Basic filtering can be added here if needed
				// Display name with cost
				var/display_name = V.name
				if(V.virtue_cost)
					display_name = "[V.name] ([V.virtue_cost] point\s)"
				virtues_available[display_name] = V
			
			virtues_available = sort_list(virtues_available)
			var/choice = tgui_input_list(usr, "Choose your primary virtue:", "Virtue Selection", virtues_available)
			
			if(choice)
				var/datum/virtue/selected = virtues_available[choice]
				virtue = selected
				save_character()
				to_chat(usr, span_notice("Selected [choice] as primary virtue."))
				to_chat(usr, "<span class='info'>[selected.desc]</span>")
			open_vices_menu(usr)
			return
		
		if(action == "change_secondary")
			if(statpack.name != "Virtuous")
				to_chat(usr, span_warning("Second virtue is only available with the Virtuous statpack!"))
				return
			
			// Save state before change
			save_to_history()
			
			// Build virtue list - Virtuous can select from ANY category including packs!
			var/list/virtues_available = list()
			for(var/path as anything in GLOB.virtues)
				var/datum/virtue/V = GLOB.virtues[path]
				if(!V.name)
					continue
				// Check if restricted by species
				if(length(pref_species.restricted_virtues))
					if(V.type in pref_species.restricted_virtues)
						continue
				// Skip if already selected as primary virtue
				if(virtue && V.type == virtue.type)
					continue
				// Skip if already selected in origins
				if(origin_virtue && V.type == origin_virtue.type)
					continue
				// Skip if already in origin_items
				if(V in origin_items)
					continue
				// Skip if already in feats (check by type)
				var/already_in_feats = FALSE
				for(var/datum/virtue/feat in feats)
					if(feat && V.type == feat.type)
						already_in_feats = TRUE
						break
				if(already_in_feats)
					continue
				if(has_stashed_item_conflict(V, virtuetwo, TRUE, usr))
					continue
				// Check for conflicting vices
				if(check_virtue_vice_conflict(V.type, TRUE, usr))
					continue
				// Check for conflicting virtues (with primary virtue)
				if(virtue && check_virtue_virtue_conflict(V.type, virtue.type, TRUE, usr))
					continue
				// Virtuous statpack allows ALL virtues including packs!
				// Display name with cost
				var/display_name = V.name
				if(V.virtue_cost)
					display_name = "[V.name] ([V.virtue_cost] point\s)"
				virtues_available[display_name] = V
			
			virtues_available = sort_list(virtues_available)
			var/choice = tgui_input_list(usr, "Choose your second virtue (any category including packs!):", "Second Virtue Selection", virtues_available)
			
			if(choice)
				var/datum/virtue/selected = virtues_available[choice]
				if(has_stashed_item_conflict(selected, virtuetwo, TRUE, usr))
					open_vices_menu(usr)
					return
				virtuetwo = selected
				save_character()
				to_chat(usr, span_notice("Selected [choice] as second virtue."))
				to_chat(usr, "<span class='info'>[selected.desc]</span>")
			open_vices_menu(usr)
			return
	
	if(href_list["statpack_action"])
		if(href_list["statpack_action"] == "change")
			// Save state before change
			save_to_history()
			
			// Build statpack list
			var/list/statpacks_available = list()
			for (var/path as anything in GLOB.statpacks)
				var/datum/statpack/SP = GLOB.statpacks[path]
				if (!SP.name)
					continue
				// Add stats to the name in the selection list
				var/display_name = SP.name
				var/stats = SP.generate_modifier_string()
				if(stats)
					display_name = "[SP.name] [stats]"
				statpacks_available[display_name] = SP
			
			statpacks_available = sort_list(statpacks_available)
			var/choice = tgui_input_list(usr, "Choose your statpack:", "Statpack Selection", statpacks_available)
			
			if(choice)
				var/datum/statpack/selected = statpacks_available[choice]
				statpack = selected
				save_character()
				to_chat(usr, span_notice("Selected [choice] statpack."))
				to_chat(usr, "<span class='info'>[selected.description_string()]</span>")
				
				// Handle virtuetwo based on statpack
				if(statpack.name == "Virtuous")
					// Keep virtuetwo if we have it
				else
					virtuetwo = GLOB.virtues[/datum/virtue/none]
					save_character()
				
			open_vices_menu(usr)
			return
	
	if(href_list["vice_action"])
		var/action = href_list["vice_action"]
		var/slot = text2num(href_list["slot"])
		
		if(!slot || slot < 1 || slot > 8)
			return
		
		var/slot_var = "vice[slot]"
		
		switch(action)
			if("select_faction")
				var/faction_type = href_list["faction_type"]
				if(faction_type)
					var/list/faction_choices = list()
					for(var/faction_name in GLOB.averse_factions)
						faction_choices[faction_name] = GLOB.averse_factions[faction_name]
					
					var/faction_prompt = (faction_type == "averse") ? "Which faction do you loathe?" : "Which faction do you trust?"
					var/faction_choice = tgui_input_list(usr, faction_prompt, "Faction Selection", faction_choices)
					
					if(faction_choice)
						if(faction_type == "averse")
							averse_chosen_faction = GLOB.averse_factions[faction_choice]
							to_chat(usr, span_notice("You will now loathe the [faction_choice] faction."))
						else
							paranoid_chosen_faction = GLOB.averse_factions[faction_choice]
							to_chat(usr, span_notice("You will now trust the [faction_choice] faction."))
						
						save_character()
				open_vices_menu(usr)
				return
			
			if("select", "change")
				// Save state before change
				save_to_history()
				
				// Show vice selection menu
				var/list/vices_available = list()
				
				// Get all currently selected vices to prevent duplicates
				// Build list of vices in OTHER slots (not the current slot being modified)
				var/list/selected_in_other_slots = list()
				for(var/i = 1 to 8)
					if(i == slot) // Skip the slot we're currently modifying
						continue
					var/datum/charflaw/existing_vice = vars["vice[i]"]
					if(existing_vice)
						selected_in_other_slots += existing_vice.type
				
				for(var/vice_name in GLOB.character_flaws)
					var/datum/charflaw/vice_type = GLOB.character_flaws[vice_name]
					
					// PREVENT DUPLICATE VICES: Skip if this vice is already selected in another slot
					if(vice_type in selected_in_other_slots)
						continue
					
					// Check for conflicting virtues
					if(check_vice_virtue_conflict(vice_type, TRUE, usr))
						continue
					
					// Check for conflicting vices (eye-related)
					if(check_vice_vice_conflict(vice_type, selected_in_other_slots, TRUE, usr))
						continue
					
					vices_available[vice_name] = vice_type
				
				vices_available = sort_list(vices_available)
				var/choice = tgui_input_list(usr, "Select a vice for slot [slot]:", "Vice Selection", vices_available)
			
				if(choice)
					var/datum/charflaw/selected = vices_available[choice]
					// Create new vice and set in preferences
					vars[slot_var] = new selected()
					var/datum/charflaw/new_vice = vars[slot_var]
					
					// Clear legacy charflaw when using new vice system
					charflaw = null

					// Save to disk so it persists across character slots
					save_character()

					// Prompt to choose faction if this is Averse or Paranoid vice
					if(istype(new_vice, /datum/charflaw/averse))
						to_chat(usr, span_notice("Vice selected. Click 'Choose Faction' to select which faction you loathe."))
					else if(istype(new_vice, /datum/charflaw/addiction/paranoid))
						to_chat(usr, span_notice("Vice selected. Click 'Choose Faction' to select which faction you trust."))

					// Vices are intentionally not hot-applied to a living in-round character.
					// They are saved to preferences and applied on the next spawn.
					if(usr && ishuman(usr))
						var/mob/living/carbon/human/H = usr
						if(H.real_name == real_name)
							to_chat(usr, span_notice("Vice changes saved. They will apply next time you spawn."))
					
					to_chat(usr, span_notice("Selected [choice] for vice slot [slot]."))
					if(new_vice.desc)
						to_chat(usr, "<span class='info'>[new_vice.desc]</span>")
				
				open_vices_menu(usr)
			
			if("clear")
				vars[slot_var] = null
				enforce_feat_limit(usr)
				save_character()
				to_chat(usr, span_notice("Cleared vice slot [slot]."))
				open_vices_menu(usr)
		return
	
	if(href_list["loadout_action"])
		var/action = href_list["loadout_action"]
		
		if(action == "reset_loadout_languages")
			if(tgalert(usr, "This will reset ALL loadout items and languages to their default states. This cannot be undone. Are you sure?", "Reset Loadout/Languages", "Yes", "No") != "Yes")
				return
			save_to_history()
			reset_loadout_and_languages()
			to_chat(usr, span_boldwarning("All loadout items and languages have been reset to default."))
			open_vices_menu(usr)
			return
		
		var/slot = text2num(href_list["slot"])
		
		if(!slot || slot < 1 || slot > 10)
			return
		
		var/slot_var = (slot == 1) ? "loadout" : "loadout[slot]"

		switch(action)
			if("item")
				open_loadout_menu(usr, slot)
				return
			
			if("clear")
				vars[slot_var] = null
				vars["loadout_[slot]_name"] = null
				vars["loadout_[slot]_desc"] = null
				vars["loadout_[slot]_hex"] = null
				save_character()
				open_vices_menu(usr)
				return
			
			if("rename")
				var/datum/loadout_item/current = vars[slot_var]
				if(!current)
					return
				
				var/new_name = tgui_input_text(usr, "Enter a custom name for this item (leave blank to use default):", "Rename Item", vars["loadout_[slot]_name"], MAX_NAME_LEN)
				
				if(new_name != null) // Allow empty string to clear
					vars["loadout_[slot]_name"] = new_name
					save_character()
					open_vices_menu(usr)
				return
			
			if("describe")
				var/datum/loadout_item/current = vars[slot_var]
				if(!current)
					return
				
				var/new_desc = tgui_input_text(usr, "Enter a custom description for this item (leave blank to use default):", "Describe Item", vars["loadout_[slot]_desc"], max_length = 500, multiline = TRUE)
				
				if(new_desc != null) // Allow empty string to clear
					vars["loadout_[slot]_desc"] = new_desc
					save_character()
					open_vices_menu(usr)
				return
			
			if("color")
				var/datum/loadout_item/current = vars[slot_var]
				if(!current)
					return
				
				// Use dye bin colors for more variety
				var/list/color_choices = list("None")
				for(var/color_name in colorlist)
					color_choices += color_name
				
				var/new_color = tgui_input_list(usr, "Choose a color for this item:", "Item Color", color_choices, vars["loadout_[slot]_hex"])
				
				if(new_color)
					if(new_color == "None")
						vars["loadout_[slot]_hex"] = null
					else
						// Look up the hex value from colorlist
						vars["loadout_[slot]_hex"] = colorlist[new_color]
					save_character()
					open_vices_menu(usr)
				return
	
	if(href_list["language_action"])
		// Save state before any language change
		save_to_history()
		
		var/action = href_list["language_action"]
		
		// Handle free language
		if(action == "free_select" || action == "free_change")
			var/static/list/selectable_languages = list(
				/datum/language/elvish,
				/datum/language/dwarvish,
				/datum/language/orcish,
				/datum/language/hellspeak,
				/datum/language/draconic,
				/datum/language/celestial,
				/datum/language/canilunzt,
				/datum/language/grenzelhoftian,
				/datum/language/kazengunese,
				/datum/language/etruscan,
				/datum/language/gronnic,
				/datum/language/otavan,
				/datum/language/aavnic,
				/datum/language/merar,
				/datum/language/thievescant/signlanguage
			)
			var/list/choices = list("None")
			for(var/language in selectable_languages)
				if(language in pref_species.languages)
					continue
				var/datum/language/a_language = new language()
				choices[a_language.name] = language
				qdel(a_language)
			
			var/chosen_language = input(usr, "Choose your character's extra language:", "EXTRA LANGUAGE") as null|anything in choices
			if(chosen_language)
				if(chosen_language == "None")
					extra_language = "None"
				else
					extra_language = choices[chosen_language]
				save_character()
			open_vices_menu(usr)
			return
		
		// Handle triumph languages
		var/slot = text2num(href_list["slot"])
		
		if(!slot || slot < 1 || slot > 2)
			return
		
		var/slot_var = slot == 1 ? "extra_language_1" : "extra_language_2"
		
		switch(action)
			if("clear")
				vars[slot_var] = "None"
				save_character()
				to_chat(usr, span_notice("Cleared language slot [slot]."))
				open_vices_menu(usr)
			if("select", "change")
				// Show language selection menu
				var/static/list/selectable_languages = list(
					/datum/language/elvish,
					/datum/language/dwarvish,
					/datum/language/orcish,
					/datum/language/hellspeak,
					/datum/language/draconic,
					/datum/language/celestial,
					/datum/language/canilunzt,
					/datum/language/grenzelhoftian,
					/datum/language/kazengunese,
					/datum/language/etruscan,
					/datum/language/gronnic,
					/datum/language/otavan,
					/datum/language/aavnic,
					/datum/language/merar,
					/datum/language/thievescant/signlanguage
				)
				
				var/list/choices = list("None")
				for(var/language in selectable_languages)
					if(language in pref_species.languages)
						continue
					
					// Check if already selected in other slot
					var/other_slot_var = slot == 1 ? "extra_language_2" : "extra_language_1"
					if(vars[other_slot_var] == language)
						continue
					
					// Check if already selected as free language
					if(extra_language == language)
						continue
					
					var/datum/language/a_language = new language()
					choices[a_language.name] = language
					qdel(a_language)
				
				var/chosen_language = input(usr, "Choose a language (Slot 1: 2 Triumphs, Slot 2: 4 Triumphs):", "Language Selection") as null|anything in choices
				
				if(chosen_language)
					if(chosen_language == "None")
						vars[slot_var] = "None"
					else
						var/language_path = choices[chosen_language]
						
						// Check triumph cost against ACTUAL player triumph pool (not vice points)
						var/slot_cost = slot == 1 ? 2 : 4
						var/total_triumphs = usr.get_triumphs()
						var/spent_points = 0
						// Count current language purchases (excluding this slot)
						var/other_slot = slot == 1 ? 2 : 1
						var/other_slot_var = slot == 1 ? "extra_language_2" : "extra_language_1"
						if(vars[other_slot_var] && vars[other_slot_var] != "None")
							spent_points += (other_slot == 1 ? 2 : 4)
						if(spent_points + slot_cost > total_triumphs)
							to_chat(usr, span_warning("Not enough triumphs! Need [slot_cost], but only have [total_triumphs - spent_points] remaining."))
							return
						vars[slot_var] = language_path
						save_character()
						to_chat(usr, span_notice("Selected [chosen_language] for language slot [slot] ([slot_cost] Triumphs)."))
				open_vices_menu(usr)

