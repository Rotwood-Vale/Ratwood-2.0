/datum/preferences/proc/check_virtue_vice_conflict(virtue_type, show_message = FALSE, mob/user = null)
	// Check if selected virtue conflicts with any selected vice
	var/list/vice_list = list()
	for(var/i = 1 to 5)
		var/datum/charflaw/v = vars["vice[i]"]
		if(v)
			vice_list += v
	
	// Bronze Arm (R) vs Wood Arm (R)
	if(virtue_type == /datum/virtue/utility/bronzearm_r)
		for(var/datum/charflaw/vice in vice_list)
			if(vice && vice.type == /datum/charflaw/limbloss/arm_r)
				if(show_message && user)
					to_chat(user, span_warning("Bronze Arm (R) virtue conflicts with Wood Arm (R) vice!"))
				return TRUE
	
	// Bronze Arm (L) vs Wood Arm (L)
	if(virtue_type == /datum/virtue/utility/bronzearm_l)
		for(var/datum/charflaw/vice in vice_list)
			if(vice && vice.type == /datum/charflaw/limbloss/arm_l)
				if(show_message && user)
					to_chat(user, span_warning("Bronze Arm (L) virtue conflicts with Wood Arm (L) vice!"))
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
	
	// Deathless (no hunger/breath) vs any food/breathing related vices
	// Deathless conflicts with nothing currently, but kept for future reference
	
	return FALSE

/datum/preferences/proc/check_virtue_virtue_conflict(virtue_type, other_virtue_type, show_message = FALSE, mob/user = null)
	if(!virtue_type || !other_virtue_type)
		return FALSE
	if(virtue_type == /datum/virtue/utility/bronzearm_r && other_virtue_type == /datum/virtue/utility/bronzearm_l)
		if(show_message && user)
			to_chat(user, span_warning("Bronze Arm (R) virtue conflicts with Bronze Arm (L) virtue - you can't have both bronze arms!"))
		return TRUE
	if(virtue_type == /datum/virtue/utility/bronzearm_l && other_virtue_type == /datum/virtue/utility/bronzearm_r)
		if(show_message && user)
			to_chat(user, span_warning("Bronze Arm (L) virtue conflicts with Bronze Arm (R) virtue - you can't have both bronze arms!"))
		return TRUE

/datum/preferences/proc/check_vice_virtue_conflict(vice_type, show_message = FALSE, mob/user = null)
	// Check if selected vice conflicts with any selected virtue
	var/list/virtue_list = list(virtue, virtuetwo)
	
	// Wood Arm (R) vs Bronze Arm (R)
	if(vice_type == /datum/charflaw/limbloss/arm_r)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/utility/bronzearm_r)
				if(show_message && user)
					to_chat(user, span_warning("Wood Arm (R) vice conflicts with Bronze Arm (R) virtue!"))
				return TRUE
	
	// Wood Arm (L) vs Bronze Arm (L)
	if(vice_type == /datum/charflaw/limbloss/arm_l)
		for(var/datum/virtue/virt in virtue_list)
			if(virt && virt.type == /datum/virtue/utility/bronzearm_l)
				if(show_message && user)
					to_chat(user, span_warning("Wood Arm (L) vice conflicts with Bronze Arm (L) virtue!"))
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

	return FALSE

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
		"vice1" = vice1,
		"vice2" = vice2,
		"vice3" = vice3,
		"vice4" = vice4,
		"vice5" = vice5,
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
	vice1 = snapshot["vice1"]
	vice2 = snapshot["vice2"]
	vice3 = snapshot["vice3"]
	vice4 = snapshot["vice4"]
	vice5 = snapshot["vice5"]
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
	
	var/list/preset = list(
		"statpack" = statpack?.type,
		"virtue" = virtue?.type,
		"virtuetwo" = virtuetwo?.type,
		"vice1" = vice1?.type,
		"vice2" = vice2?.type,
		"vice3" = vice3?.type,
		"vice4" = vice4?.type,
		"vice5" = vice5?.type,
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
	user << browse(html_content, "window=character_custom;size=750x500")

/datum/preferences/proc/fix_duplicate_vices()
	// Remove duplicate vices across slots
	var/list/seen_vices = list()
	for(var/i = 1 to 5)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice)
			if(vice.type in seen_vices)
				// Duplicate found, clear this slot
				vars["vice[i]"] = null
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
				grid-template-columns: repeat(2, 1fr);
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
				<div style="margin-top: 10px;">
					<a class='btn' href='byond://?src=\ref[src];undo_action=undo' style='font-size: 0.85em;'>⟲ Undo Last Change ([customization_history.len] available)</a>
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
			<h2>Virtue Selection</h2>
			<div class="statpack-current">"}
	
	var/virtue_name = virtue ? virtue.name : "None"
	var/virtue_desc = virtue ? virtue.desc : ""
	html += "<div class=\"statpack-name\">Primary Virtue: [virtue_name]</div>"
	html += "<div class=\"statpack-desc\">[virtue_desc]</div>"
	
	if(virtue && virtue.custom_text)
		html += "<div class='statpack-stats' style='margin-top: 4px;'>" + virtue.custom_text + "</div>"
	
	// Display traits granted
	if(virtue && LAZYLEN(virtue.added_traits))
		html += "<div class='statpack-stats' style='margin-top: 8px;'><strong>Traits granted:</strong><br>"
		for(var/trait in virtue.added_traits)
			html += "• [trait]<br>"
		html += "</div>"
	
	// Display skills granted
	if(virtue && LAZYLEN(virtue.added_skills))
		html += "<div class='statpack-stats' style='margin-top: 8px;'><strong>Skills granted:</strong><br>"
		for(var/skill in virtue.added_skills)
			if(!islist(skill))
				var/datum/skill/S = skill
				var/skill_name = initial(S.name)
				html += "• [skill_name]: +[virtue.added_skills[skill]]<br>"
			else
				var/list/skill_block = skill
				var/datum/skill/S = skill_block[1]
				var/skill_name = initial(S.name)
				html += "• [skill_name]: +[skill_block[2]] (max [skill_block[3]])<br>"
		html += "</div>"
	
	// Display stashed items
	if(virtue && LAZYLEN(virtue.added_stashed_items))
		html += "<div class='statpack-stats' style='margin-top: 8px;'><strong>Stashed items:</strong><br>"
		for(var/item_name in virtue.added_stashed_items)
			html += "• [item_name]<br>"
		html += "</div>"
	
	html += "</div>"
	
	if(statpack && statpack.name == "Virtuous" && virtuetwo)
		html += {"
		<div class=\"statpack-current\" style='margin-top: 10px;'>
			<div class=\"statpack-name\">Second Virtue: [virtuetwo.name]</div>
			<div class=\"statpack-desc\">[virtuetwo.desc]</div>
		</div>"}
		
		if(virtuetwo.custom_text)
			html += "<div class='statpack-stats' style='margin-top: 4px;'>" + virtuetwo.custom_text + "</div>"
		
		// Display traits granted for second virtue
		if(LAZYLEN(virtuetwo.added_traits))
			html += "<div class='statpack-stats' style='margin-top: 8px;'><strong>Traits granted:</strong><br>"
			for(var/trait in virtuetwo.added_traits)
				html += "• [trait]<br>"
			html += "</div>"
		
		// Display skills granted for second virtue
		if(LAZYLEN(virtuetwo.added_skills))
			html += "<div class='statpack-stats' style='margin-top: 8px;'><strong>Skills granted:</strong><br>"
			for(var/skill in virtuetwo.added_skills)
				if(!islist(skill))
					var/datum/skill/S = skill
					var/skill_name = initial(S.name)
					html += "• [skill_name]: +[virtuetwo.added_skills[skill]]<br>"
				else
					var/list/skill_block = skill
					var/datum/skill/S = skill_block[1]
					var/skill_name = initial(S.name)
					html += "• [skill_name]: +[skill_block[2]] (max [skill_block[3]])<br>"
			html += "</div>"
		
		// Display stashed items for second virtue
		if(LAZYLEN(virtuetwo.added_stashed_items))
			html += "<div class='statpack-stats' style='margin-top: 8px;'><strong>Stashed items:</strong><br>"
			for(var/item_name in virtuetwo.added_stashed_items)
				html += "• [item_name]<br>"
			html += "</div>"
	
	html += {"
			<div class="actions">
				<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=change_primary'>Change Primary Virtue</a>"}
	
	if(statpack.name == "Virtuous")
		html += "<a class='btn btn-select' href='byond://?src=\ref[src];virtue_action=change_secondary'>Change Second Virtue</a>"
	
	html += {"
			</div>
		</div>
		
		<h2 style='color: [theme["text"]]; padding: 0 20px; margin: 20px 0 10px 0; border-bottom: 1px solid [theme["border"]]; padding-bottom: 10px;'>Vice Selection</h2>
		<p style='color: [theme["label"]]; padding: 0 20px; margin: 0 0 15px 0; font-size: 0.9em;'>Select up to 5 vices (at least 1 required). Each selected vice grants +1 point. Points are shared between languages and loadout.</p>			<div class="vices-grid">
	"}
	
	// Generate 5 vice slots
	for(var/i = 1 to 5)
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
			html += "</div>"
			html += "</div>"
			
			html += "<div class='actions'>"
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
			<div style='display: grid; grid-template-columns: repeat(2, 1fr); gap: 8px;'>
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
			<div style='display: grid; grid-template-columns: repeat(2, 1fr); gap: 15px;'>
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
	
	if(href_list["virtue_action"])
		var/action = href_list["virtue_action"]
		
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
				virtues_available[V.name] = V
			
			virtues_available = sort_list(virtues_available)
			var/choice = tgui_input_list(usr, "Choose your primary virtue:", "Virtue Selection", virtues_available)
			
			if(choice)
				var/datum/virtue/selected = virtues_available[choice]
				virtue = selected
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
			
			// Build virtue list
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
				// Check for conflicting vices
				if(check_virtue_vice_conflict(V.type, TRUE, usr))
					continue
				// Check for conflicting virtues (with primary virtue)
				if(virtue && check_virtue_virtue_conflict(V.type, virtue.type, TRUE, usr))
					continue
				virtues_available[V.name] = V
			
			virtues_available = sort_list(virtues_available)
			var/choice = tgui_input_list(usr, "Choose your second virtue:", "Second Virtue Selection", virtues_available)
			
			if(choice)
				var/datum/virtue/selected = virtues_available[choice]
				virtuetwo = selected
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
				to_chat(usr, span_notice("Selected [choice] statpack."))
				to_chat(usr, "<span class='info'>[selected.description_string()]</span>")
				
				// Handle virtuetwo based on statpack
				if(statpack.name == "Virtuous")
					// Keep virtuetwo if we have it
				else
					virtuetwo = GLOB.virtues[/datum/virtue/none]
				
				open_vices_menu(usr)
			return
	
	if(href_list["vice_action"])
		var/action = href_list["vice_action"]
		var/slot = text2num(href_list["slot"])
		
		if(!slot || slot < 1 || slot > 5)
			return
		
		var/slot_var = "vice[slot]"
		
		switch(action)
			if("select", "change")
				// Save state before change
				save_to_history()
				
				// Show vice selection menu
				var/list/vices_available = list()
				
				// Get all currently selected vices to prevent duplicates
				var/list/selected_vices = list()
				for(var/i = 1 to 5)
					var/datum/charflaw/existing_vice = vars["vice[i]"]
					if(existing_vice)
						selected_vices += existing_vice.type
				
				for(var/vice_name in GLOB.character_flaws)
					var/datum/charflaw/vice_type = GLOB.character_flaws[vice_name]
					
					// Skip if already selected in another slot
					var/datum/charflaw/current_vice = vars[slot_var]
					if(vice_type in selected_vices && current_vice?.type != vice_type)
						continue
					
					// Check for conflicting virtues
					if(check_vice_virtue_conflict(vice_type, TRUE, usr))
						continue
					
					// Check for conflicting vices (eye-related)
					if(check_vice_vice_conflict(vice_type, selected_vices, TRUE, usr))
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
				if(slot == 1)
					to_chat(usr, span_warning("Vice slot 1 is required and cannot be cleared!"))
					return
				
				// Clear the vice from preferences
				vars[slot_var] = null

				// Vices are intentionally not hot-applied to a living in-round character.
				// They are saved to preferences and applied on the next spawn.
				if(usr && ishuman(usr))
					var/mob/living/carbon/human/H = usr
					if(H.real_name == real_name)
						to_chat(usr, span_notice("Vice changes saved. They will apply next time you spawn."))
				
				open_vices_menu(usr)
	
	if(href_list["loadout_action"])
		// Save state before any loadout change
		save_to_history()
		
		var/action = href_list["loadout_action"]
		var/slot = text2num(href_list["slot"])
		
		if(!slot || slot < 1 || slot > 10)
			return
		
		var/slot_var = (slot == 1) ? "loadout" : "loadout[slot]"

		switch(action)
			if("item")
				// Clear any stale selection data and close existing windows
				temp_loadout_selection = null
				usr << browse(null, "window=loadout_select")
				
				// Initialize lists for available loadouts and selected loadouts
				var/list/loadouts_available = list()
				var/list/selected_loadouts = list()
				var/list/selected_items = list()
				for(var/i = 1 to 10)
					var/datum/loadout_item/existing_item = vars[i == 1 ? "loadout" : "loadout[i]"]
					if(existing_item)
						selected_items += existing_item
						selected_loadouts += existing_item.type
				
				// Build HTML menu with icons
				var/pref_ref = "\ref[src]"
				var/html = {"
					<html>
					<head>
					<style>
						body {
							font-family: Verdana, Arial, sans-serif;
							background: #100000 url('flowers.png') repeat;
							color: #aa8f8f;
							margin: 0;
							padding: 10px;
						}
						.search-container {
							margin-bottom: 15px;
						}
						.search-box {
							width: 100%;
							padding: 8px;
							background: #00000044;
							border: 1px solid #7b5353;
							color: #aa8f8f;
							font-family: Verdana, Arial, sans-serif;
							font-size: 0.9em;
							box-sizing: border-box;
						}
						.search-box:focus {
							outline: none;
							border-color: #aa8f8f;
						}
						.item-list {
							display: flex;
							flex-direction: column;
							gap: 5px;
						}
						.item-entry {
							display: flex;
							align-items: center;
							background: #00000044;
							border: 1px solid #7b5353;
							padding: 8px;
							cursor: pointer;
							transition: all 0.2s;
						}
						.item-entry:hover {
							background: rgba(123, 83, 83, 0.3);
							border-color: #7b5353;
						}
						.item-entry.hidden {
							display: none;
						}
						.item-icon {
							width: 32px;
							height: 32px;
							margin-right: 10px;
							image-rendering: pixelated;
							flex-shrink: 0;
						}
						.item-info {
							flex: 1;
						}
						.item-name {
							font-weight: bold;
							color: #aa8f8f;
							font-size: 0.85em;
						}
						.item-cost {
							color: #ff6b6b;
							font-size: 0.75em;
						}
						.locked-item {
							opacity: 0.5;
							cursor: not-allowed !important;
							background: #00000066 !important;
						}
						.locked-item:hover {
							background: #00000066 !important;
							border-color: #7b5353 !important;
						}
						.lock-reason {
							color: #ff9b42;
							font-size: 0.7em;
							margin-top: 3px;
							font-style: italic;
						}
						h2 {
							color: #aa8f8f;
							text-align: center;
							border-bottom: 2px solid #7b5353;
							padding-bottom: 10px;
							margin-top: 0;
						}
					</style>
					</head>
					<body>
					<h2>Select Item for Slot [slot]</h2>
					<div class='search-container'>
						<input type='text' id='searchBox' class='search-box' placeholder='Search items...' onkeyup='filterItems()'>
					</div>
					<div class='item-list'>
				"}
				
				var/icon_counter = 0
				for(var/path as anything in GLOB.loadout_items)
					var/datum/loadout_item/item = GLOB.loadout_items[path]
					
					var/is_locked = FALSE
					var/lock_reason = ""
					
					// Check if donator item
					if(item.donoritem && usr?.ckey)
						if(!item.donator_ckey_check(usr.ckey))
							continue
					
					// Check if nobility requirement is met
					if(!item.nobility_check(usr?.client))
						is_locked = TRUE
						lock_reason = "🔒 Requires: Nobility virtue, or High priority for Noble/Courtier/Yeoman jobs"
					
					// Skip if already selected in another slot (but allow if it's the current slot's item)
					var/datum/loadout_item/current_item = vars[slot_var]
					if(item.type in selected_loadouts)
						if(!current_item || current_item.type != item.type)
							continue
					
					icon_counter++
					
					// Get item icon with caching
					var/obj/item/sample = item.path
					var/icon_file = initial(sample.icon)
					var/icon_state_name = initial(sample.icon_state)
					
					if(icon_file && icon_state_name)
						var/cache_key = "[icon_file]_[icon_state_name]"
						if(!(cache_key in GLOB.cached_loadout_icons))
							if(GLOB.cached_loadout_icons.len >= MAX_ICON_CACHE_SIZE)
								GLOB.cached_loadout_icons.Cut(1, 50)
							GLOB.cached_loadout_icons[cache_key] = icon(icon_file, icon_state_name)
						usr << browse_rsc(GLOB.cached_loadout_icons[cache_key], "loadout_select_[icon_counter].png")
					
					var/display_name = item.name
					var/cost_text = ""
					if(item.triumph_cost)
						cost_text = "<span class='item-cost'>(-[item.triumph_cost] PT)</span>"
					
					var/locked_class = is_locked ? "locked-item" : ""
					var/onclick_action = is_locked ? "" : "onclick='window.location=\"byond://?src=[pref_ref];select_loadout_item=[icon_counter];slot=[slot]\"'"
					var/lock_indicator = is_locked ? "<div class='lock-reason'>[lock_reason]</div>" : ""
					
					html += {"
						<div class='item-entry [locked_class]' data-name='[display_name]' [onclick_action]>
							<img class='item-icon' src='loadout_select_[icon_counter].png' onerror='this.style.display=\"none\"'>
							<div class='item-info'>
								<div class='item-name'>[display_name] [cost_text]</div>
								[lock_indicator]
							</div>
						</div>
					"}
					
					if(!is_locked)
						loadouts_available["[icon_counter]"] = item
				
				html += {"
					</div>
					<script>
						function filterItems() {
							var searchValue = document.getElementById('searchBox').value.toLowerCase();
							var items = document.getElementsByClassName('item-entry');
							var idx;
							for(idx = 0; idx < items.length; idx++) {
								var itemName = items\[idx\].getAttribute('data-name').toLowerCase();
								if(itemName.includes(searchValue)) {
									items\[idx\].classList.remove('hidden');
								} else {
									items\[idx\].classList.add('hidden');
								}
							}
						}
					</script>
				</body>
				</html>
				"}
				
				// Store the available items temporarily for callback and show window
				temp_loadout_selection = list("prefs" = src, "items" = loadouts_available, "slot" = slot)
				usr << browse(html, "window=loadout_select;size=500x700")
				return
			
			if("clear")
				vars[slot_var] = null
				vars["loadout_[slot]_name"] = null
				vars["loadout_[slot]_desc"] = null
				vars["loadout_[slot]_hex"] = null
				open_vices_menu(usr)
				return
			
			if("rename")
				var/datum/loadout_item/current = vars[slot_var]
				if(!current)
					return
				
				var/new_name = tgui_input_text(usr, "Enter a custom name for this item (leave blank to use default):", "Rename Item", vars["loadout_[slot]_name"], MAX_NAME_LEN)
				
				if(new_name != null) // Allow empty string to clear
					vars["loadout_[slot]_name"] = new_name
					open_vices_menu(usr)
				return
			
			if("describe")
				var/datum/loadout_item/current = vars[slot_var]
				if(!current)
					return
				
				var/new_desc = tgui_input_text(usr, "Enter a custom description for this item (leave blank to use default):", "Describe Item", vars["loadout_[slot]_desc"], max_length = 500, multiline = TRUE)
				
				if(new_desc != null) // Allow empty string to clear
					vars["loadout_[slot]_desc"] = new_desc
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
						to_chat(usr, span_notice("Selected [chosen_language] for language slot [slot] ([slot_cost] Triumphs)."))
				open_vices_menu(usr)
