GLOBAL_LIST_EMPTY(cached_loadout_icons)

/datum/preferences/proc/loadout_var(slot)
	if(slot == 1)
		return "loadout"
	return "loadout[slot]"

/datum/preferences/proc/open_loadout_menu(mob/user, slot = 1)
	if(!user || !user.client)
		return
	if(!loadout_menu)
		loadout_menu = new(src)
	loadout_menu.ui_interact(user)
	loadout_menu.current_slot = slot

/datum/preferences/proc/open_loadout_slots(mob/user)
	if(!user || !user.client)
		return
	user << browse(get_loadout_slots_html(user), "window=loadout_slots;size=750x600")

/datum/preferences/proc/get_loadout_slots_html(mob/user)
	var/html = {"
		<style>
			body { font-family: Verdana, Arial, sans-serif; background: #100000; color: #aa8f8f; }
			.slot { border: 1px solid #7b5353; background: #00000044; padding: 6px; margin: 3px; }
			a { color: #aa8f8f; border: 1px solid #7b5353; padding: 1px 4px; text-decoration: none; font-size: 0.8em; }
			a:hover { background: rgba(123, 83, 83, 0.3); }
		</style>
		<h2>Loadout</h2>
		<hr>
		<table width='100%'><tr>"}
	for(var/i in 1 to LOADOUT_SLOTS)
		var/datum/loadout_item/current_item = vars[loadout_var(i)]
		html += "<td width='50%' valign='top'><div class='slot'><b>Slot [i]</b>"
		if(current_item)
			html += "<br>[get_loadout_item_html(user, i, current_item)]"
			html += "<br>[loadout_link("Change", "item", i)] [loadout_link("Rename", "rename", i)] [loadout_link("Description", "describe", i)] [loadout_link("Color", "color", i)] [loadout_link("Clear", "clear", i)]"
		else
			html += "<br>Empty<br>[loadout_link("Select Item", "item", i)]"
		html += "</div></td>"
		if(i % 2 == 0)
			html += "</tr><tr>"
	html += "</tr></table><hr><table width='100%'><tr>"
	for(var/i in 1 to PRESET_SLOTS)
		html += "<td valign='top'><b>Preset [i]</b><br><small>[get_preset_summary(i)]</small><br>"
		html += "[preset_link("Save", "save", i)] [preset_link("Load", "load", i)] [preset_link("Clear", "clear", i)]</td>"
	html += "</tr></table>"
	return html

/datum/preferences/proc/loadout_link(label, lo, slot)
	return "<a href='?_src_=prefs;preference=loadout;lo=[lo];slot=[slot]'>[label]</a>"

/datum/preferences/proc/preset_link(label, preset, slot)
	return "<a href='?_src_=prefs;preference=loadout;preset=[preset];slot=[slot]'>[label]</a>"

/datum/preferences/proc/get_loadout_item_html(mob/user, slot, datum/loadout_item/current_item)
	var/obj/item/sample = current_item.path
	var/icon_file = initial(sample.icon)
	var/icon_state = initial(sample.icon_state)
	var/item_desc = initial(sample.desc)
	var/html = ""
	if(icon_file && icon_state)
		var/cache_key = "[icon_file]_[icon_state]"
		if(!(cache_key in GLOB.cached_loadout_icons))
			if(GLOB.cached_loadout_icons.len >= MAX_ICON_CACHE_SIZE)
				GLOB.cached_loadout_icons.Cut(1, 50)
			GLOB.cached_loadout_icons[cache_key] = icon(icon_file, icon_state)
		user << browse_rsc(GLOB.cached_loadout_icons[cache_key], "loadout_icon_[slot].png")
		html += "<img src='loadout_icon_[slot].png' width='32' height='32'> "
	html += "<b>[vars["loadout_[slot]_name"] || current_item.name]</b><br>[vars["loadout_[slot]_desc"] || item_desc || current_item.desc]"
	var/item_color = vars["loadout_[slot]_hex"]
	if(item_color)
		html += "<br><span style='color: [clothing_color2hex(item_color)];'>●</span> Color: [item_color]"
	return html

/datum/preferences/proc/process_loadout_link(mob/user, list/href_list)
	var/slot = text2num(href_list["slot"])
	if(!slot)
		return
	if(href_list["preset"])
		process_preset_link(user, href_list["preset"], slot)
		return
	if(slot > LOADOUT_SLOTS)
		return
	var/slot_var = loadout_var(slot)
	var/datum/loadout_item/current = vars[slot_var]
	switch(href_list["lo"])
		if("item")
			open_loadout_menu(user, slot)
			return
		if("clear")
			vars[slot_var] = null
			for(var/suffix in list("name", "desc", "hex"))
				vars["loadout_[slot]_[suffix]"] = null
		if("rename")
			if(!current)
				return
			var/new_name = tgui_input_text(user, "Enter a custom name for this item (leave blank to use default):", "Rename Item", vars["loadout_[slot]_name"], MAX_NAME_LEN)
			if(new_name != null)
				vars["loadout_[slot]_name"] = new_name
		if("describe")
			if(!current)
				return
			var/new_desc = tgui_input_text(user, "Enter a custom description for this item (leave blank to use default):", "Describe Item", vars["loadout_[slot]_desc"], max_length = 500, multiline = TRUE)
			if(new_desc != null)
				vars["loadout_[slot]_desc"] = new_desc
		if("color")
			if(!current)
				return
			var/list/color_choices = list("None")
			for(var/color_name in GLOB.colorlist)
				color_choices += color_name
			var/new_color = tgui_input_list(user, "Choose a color for this item:", "Item Color", color_choices, vars["loadout_[slot]_hex"])
			if(new_color == "None")
				vars["loadout_[slot]_hex"] = null
			else if(new_color)
				vars["loadout_[slot]_hex"] = GLOB.colorlist[new_color]
	open_loadout_slots(user)

/datum/preferences/proc/process_preset_link(mob/user, action, slot)
	if(slot < 1 || slot > PRESET_SLOTS)
		return
	switch(action)
		if("save")
			save_preset(slot)
			to_chat(user, span_notice("Saved current setup to Preset [slot]!"))
		if("load")
			if(!load_preset(slot))
				to_chat(user, span_warning("Preset [slot] is empty or invalid."))
				return
			validate_background()
			to_chat(user, span_notice("Loaded Preset [slot]!"))
		if("clear")
			vars["loadout_preset_[slot]"] = null
			to_chat(user, span_notice("Cleared Preset [slot]."))
	save_character()
	open_loadout_slots(user)

// presets :(
/datum/preferences/proc/save_preset(preset_slot)
	var/list/preset = list(
		"stat_caps" = stat_caps.Copy(),
		"virtue" = virtue?.type,
		"virtuetwo" = virtuetwo?.type,
		"quirks" = get_quirk_typepaths(),
		"redolent_type" = redolent_type,
		"redolent_scent" = redolent_scent,
		"extra_language" = extra_language
	)
	for(var/i in 1 to VICE_SLOTS)
		var/datum/charflaw/vice = vars["vice[i]"]
		preset["vice[i]"] = vice?.type
	for(var/i in 1 to LOADOUT_SLOTS)
		var/datum/loadout_item/item = vars[loadout_var(i)]
		preset[loadout_var(i)] = item?.type
		for(var/suffix in list("name", "desc", "hex"))
			preset["loadout_[i]_[suffix]"] = vars["loadout_[i]_[suffix]"]
	vars["loadout_preset_[preset_slot]"] = preset

/datum/preferences/proc/load_preset(preset_slot)
	var/list/preset = vars["loadout_preset_[preset_slot]"]
	if(!islist(preset) || !preset.len)
		return FALSE
	stat_caps = list()
	var/list/preset_caps = preset["stat_caps"]
	if(islist(preset_caps))
		for(var/stat in GLOB.budget_stats)
			if(isnum(preset_caps[stat]))
				stat_caps[stat] = clamp(preset_caps[stat], 8, STAT_BASE_MAX)
	var/virtue_type = string_to_typepath(preset["virtue"])
	if(ispath(virtue_type, /datum/virtue))
		virtue = new virtue_type()
	else
		virtue = new /datum/virtue/none()
	var/virtuetwo_type = string_to_typepath(preset["virtuetwo"])
	if(ispath(virtuetwo_type, /datum/virtue))
		virtuetwo = new virtuetwo_type()
	else
		virtuetwo = new /datum/virtue/none()
	quirks = list()
	var/quirks_preset = preset["quirks"]
	if(islist(quirks_preset))
		for(var/quirk_type in quirks_preset)
			var/resolved_type = string_to_typepath(quirk_type)
			if(ispath(resolved_type, /datum/quirk))
				quirks += new resolved_type()
	for(var/i in 1 to VICE_SLOTS)
		var/vice_type = string_to_typepath(preset["vice[i]"])
		vars["vice[i]"] = null
		if(ispath(vice_type, /datum/charflaw))
			vars["vice[i]"] = new vice_type()
	redolent_type = preset["redolent_type"] || "Neutral"
	redolent_scent = preset["redolent_scent"] || ""
	for(var/i in 1 to LOADOUT_SLOTS)
		var/loadout_type = string_to_typepath(preset[loadout_var(i)])
		vars[loadout_var(i)] = null
		if(ispath(loadout_type, /datum/loadout_item))
			vars[loadout_var(i)] = new loadout_type()
		for(var/suffix in list("name", "desc", "hex"))
			vars["loadout_[i]_[suffix]"] = preset["loadout_[i]_[suffix]"]
	extra_language = preset["extra_language"]
	return TRUE

/datum/preferences/proc/get_preset_summary(preset_slot)
	var/list/preset = vars["loadout_preset_[preset_slot]"]
	if(!islist(preset) || !preset.len)
		return "Empty"
	var/list/summary = list()
	var/virtue_path = string_to_typepath(preset["virtue"])
	if(ispath(virtue_path, /datum/virtue))
		var/datum/virtue/v_temp = new virtue_path()
		if(v_temp.name != "None")
			summary += v_temp.name
	var/quirk_count = 0
	if(islist(preset["quirks"]))
		for(var/quirk_type in preset["quirks"])
			if(ispath(string_to_typepath(quirk_type), /datum/quirk))
				quirk_count++
	var/vice_count = 0
	for(var/i in 1 to VICE_SLOTS)
		if(ispath(string_to_typepath(preset["vice[i]"]), /datum/charflaw))
			vice_count++
	var/loadout_count = 0
	for(var/i in 1 to LOADOUT_SLOTS)
		if(ispath(string_to_typepath(preset[loadout_var(i)]), /datum/loadout_item))
			loadout_count++
	if(quirk_count)
		summary += "[quirk_count] quirk\s"
	if(vice_count)
		summary += "[vice_count] vice\s"
	if(loadout_count)
		summary += "[loadout_count] item\s"
	return summary.Join(" | ")
