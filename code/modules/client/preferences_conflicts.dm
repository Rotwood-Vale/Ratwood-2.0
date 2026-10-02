/datum/preferences/proc/get_customization_pick(typepath)
	if(!typepath)
		return null
	return GLOB.virtues[typepath] || GLOB.quirks[typepath]

/datum/preferences/proc/get_virtue_effective_types(virtue_typepath)
	var/list/types = list()
	if(!virtue_typepath)
		return types
	types += virtue_typepath
	if(ispath(virtue_typepath, /datum/virtue/pack))
		var/datum/virtue/pack/P = GLOB.virtues[virtue_typepath]
		if(P)
			types += P.granted_virtues
	return types

/datum/preferences/proc/check_pick_virtue_conflict(pick_type, existing_type, show_message = FALSE, mob/user = null)
	if(!pick_type || !existing_type)
		return FALSE
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	var/datum/customization_trait/existing = get_customization_pick(existing_type)
	if(!pick || !existing)
		return FALSE
	var/list/pick_effective = get_virtue_effective_types(pick_type)
	var/list/existing_effective = get_virtue_effective_types(existing_type)
	if(length(pick.incompatible_virtues))
		for(var/t in existing_effective)
			if(t in pick.incompatible_virtues)
				if(show_message && user)
					to_chat(user, span_warning("[pick.name] conflicts with [existing.name]!"))
				return TRUE
	if(length(existing.incompatible_virtues))
		for(var/t in pick_effective)
			if(t in existing.incompatible_virtues)
				if(show_message && user)
					to_chat(user, span_warning("[pick.name] conflicts with [existing.name]!"))
				return TRUE
	return FALSE

/datum/preferences/proc/check_pick_vice_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	if(!pick || !length(pick.incompatible_vices))
		return FALSE
	for(var/i = 1 to 6)
		var/datum/charflaw/vice = vars["vice[i]"]
		if(vice && (vice.type in pick.incompatible_vices))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [vice.name] vice!"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_pick_quirk_conflict(pick_type, show_message = FALSE, mob/user = null)
	var/datum/customization_trait/pick = get_customization_pick(pick_type)
	if(!pick)
		return FALSE
	for(var/datum/quirk/Q in quirks)
		if(!Q || Q.type == pick_type)
			continue
		if(length(pick.incompatible_quirks) && (Q.type in pick.incompatible_quirks))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [Q.name]!"))
			return TRUE
		if(length(Q.incompatible_quirks) && (pick_type in Q.incompatible_quirks))
			if(show_message && user)
				to_chat(user, span_warning("[pick.name] conflicts with [Q.name]!"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_vice_pick_conflict(vice_type, show_message = FALSE, mob/user = null)
	if(!vice_type)
		return FALSE
	var/list/held = list()
	if(virtue)
		held += virtue
	if(virtuetwo)
		held += virtuetwo
	held += quirks
	for(var/datum/customization_trait/pick in held)
		if(length(pick.incompatible_vices) && (vice_type in pick.incompatible_vices))
			if(show_message && user)
				var/datum/charflaw/vice = GLOB.charflaw_singletons[vice_type]
				to_chat(user, span_warning("[vice?.name || "This vice"] conflicts with [pick.name]!"))
			return TRUE
	return FALSE

/datum/preferences/proc/check_quirk_virtue_conflict(quirk_type, show_message = FALSE, mob/user = null)
	for(var/datum/virtue/virt in list(virtue, virtuetwo))
		if(virt && check_pick_virtue_conflict(quirk_type, virt.type, show_message, user))
			return TRUE
	return FALSE

/datum/preferences/proc/check_virtue_quirk_conflict(virtue_type, show_message = FALSE, mob/user = null)
	for(var/datum/quirk/Q in quirks)
		if(Q && check_pick_virtue_conflict(virtue_type, Q.type, show_message, user))
			return TRUE
	return FALSE

/datum/preferences/proc/check_vice_vice_conflict(vice_type, list/selected_vices, show_message = FALSE, mob/user = null)
	for(var/list/group in GLOB.vice_conflict_groups)
		if(!(vice_type in group))
			continue
		for(var/other in selected_vices)
			if(other == vice_type || !(other in group))
				continue
			if(show_message && user)
				var/datum/charflaw/vice = GLOB.charflaw_singletons[vice_type]
				var/datum/charflaw/other_vice = GLOB.charflaw_singletons[other]
				to_chat(user, span_warning("[vice?.name] vice conflicts with [other_vice?.name] vice!"))
			return TRUE
	return FALSE
