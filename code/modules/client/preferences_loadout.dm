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
	var/datum/browser/popup = new(user, "loadout_slots", "<div align='center'>Loadout</div>", 750, 500)
	popup.set_content(get_loadout_slots_html(user))
	popup.open(FALSE)

/datum/preferences/proc/get_loadout_slots_html(mob/user)
	var/html = {"<style>
		body { font-family: Verdana, Arial, sans-serif; font-size: 16px; line-height: normal; }
		.slot { border: 1px solid #7b5353; background: #00000044; padding: 6px; margin: 2px; }
		.cost { float: right; background: #4CAF50; color: #1C0000; padding: 1px 5px; font-size: 0.65em; font-weight: bold; }
		.icon { border: 1px solid #444; background: rgba(0,0,0,0.6); width: 48px; height: 48px; margin-right: 8px; text-align: center; }
		.sub { border-bottom: 1px solid #7b5353; margin: 0 0 4px 0; padding-bottom: 3px; font-size: 0.7em; font-weight: bold; color: #aa8f8f; }
		.small { font-size: 0.65em; line-height: 1.2; color: #aa8f8f; }
		.name { font-size: 0.75em; font-weight: bold; color: #aa8f8f; margin-bottom: 2px; }
		.empty { text-align: center; padding: 8px; color: #aa8f8f; font-style: italic; font-size: 0.7em; }
		a.btn { display: inline-block; border: 1px solid #7b5353; padding: 3px 6px; margin: 1px; font-family: Verdana, Arial, sans-serif !important; font-size: 0.6em; line-height: normal; text-decoration: none; }
		a.btn.select { background: rgba(76, 175, 80, 0.3); border-color: #4CAF50; color: #4CAF50; }
		a.btn.clear { background: rgba(244, 67, 54, 0.3); border-color: #f44336; color: #f44336; }
		a.btn.customize { background: rgba(33, 150, 243, 0.3); border-color: #2196F3; color: #2196F3; }
		a.btn.color { background: rgba(156, 39, 176, 0.3); border-color: #9C27B0; color: #9C27B0; }
		a.btn:hover { filter: brightness(1.4); }
		</style>"}
	html += "<div class='sub'>Points: [get_remaining_points()] / [get_total_points()]</div>"
	html += "<div class='small'>Loadout items sell for nothing. Armor rating is reduced by 90% with no crit prevention, and weapon damage is reduced by 25%.</div>"
	html += "<table width='100%'><tr>"
	for(var/i in 1 to LOADOUT_SLOTS)
		var/datum/loadout_item/current_item = vars[loadout_var(i)]
		html += "<td width='50%' valign='top'><div class='slot'><div class='sub'>[current_item?.triumph_cost ? "<span class='cost'>[current_item.triumph_cost] Points</span>" : ""]Slot [i]</div>"
		if(current_item)
			html += get_loadout_item_html(user, i, current_item)
			html += "<br>[loadout_link("Change Item", "item", i, "select")] [loadout_link("Rename", "rename", i, "customize")] [loadout_link("Description", "describe", i, "customize")] [loadout_link("Color", "color", i, "color")] [loadout_link("Clear", "clear", i, "clear")]"
		else
			html += "<div class='empty'>Empty Slot<br><br>[loadout_link("Select Item", "item", i, "select")]</div>"
		html += "</div></td>"
		if(i % 2 == 0)
			html += "</tr><tr>"
	html += "</tr></table><div class='sub'>Presets</div><table width='100%'><tr>"
	for(var/i in 1 to PRESET_SLOTS)
		html += "<td valign='top'><div class='slot'><b>Preset [i]</b><br><span class='small'>[get_preset_summary(i)]</span><br>"
		html += "[preset_link("Save", "save", i, "select")] [preset_link("Load", "load", i, "customize")] [preset_link("Clear", "clear", i, "clear")]</div></td>"
	html += "</tr></table>"
	return html

/datum/preferences/proc/loadout_link(label, lo, slot, style)
	return "<a class='btn [style]' href='?_src_=prefs;preference=loadout;lo=[lo];slot=[slot]'>[label]</a>"

/datum/preferences/proc/preset_link(label, preset, slot, style)
	return "<a class='btn [style]' href='?_src_=prefs;preference=loadout;preset=[preset];slot=[slot]'>[label]</a>"

/datum/preferences/proc/get_loadout_item_html(mob/user, slot, datum/loadout_item/current_item)
	var/obj/item/sample = current_item.path
	var/icon_file = initial(sample.icon)
	var/icon_state = initial(sample.icon_state)
	var/item_desc = initial(sample.desc)
	var/custom_name = vars["loadout_[slot]_name"]
	var/custom_desc = vars["loadout_[slot]_desc"]
	var/item_color = vars["loadout_[slot]_hex"]
	var/html = "<table><tr><td valign='top'><div class='icon'>"
	if(icon_file && icon_state)
		var/cache_key = "[icon_file]_[icon_state]"
		if(!(cache_key in GLOB.cached_loadout_icons))
			if(GLOB.cached_loadout_icons.len >= MAX_ICON_CACHE_SIZE)
				GLOB.cached_loadout_icons.Cut(1, 50)
			GLOB.cached_loadout_icons[cache_key] = icon(icon_file, icon_state)
		user << browse_rsc(GLOB.cached_loadout_icons[cache_key], "loadout_icon_[slot].png")
		html += "<img src='loadout_icon_[slot].png' width='46' height='46'>"
	html += "</div></td><td valign='top'><div class='name'>[custom_name || current_item.name]</div>"
	html += "<div class='small'>[custom_desc || item_desc || current_item.desc]</div>"
	if(custom_name || custom_desc)
		html += "<div class='small' style='font-size: 0.7em;'>✎ Customized</div>"
	if(item_color)
		html += "<div class='small' style='font-size: 0.7em;'><span style='color: [item_color];'>●</span> Color: [item_color]</div>"
	html += "</td></tr></table>"
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
		"statpack" = statpack?.type,
		"virtue" = virtue?.type,
		"virtuetwo" = virtuetwo?.type,
		"quirks" = get_quirk_typepaths(),
		"quirk_configs" = get_quirk_configs(),
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
	var/statpack_type = string_to_typepath(preset["statpack"])
	if(ispath(statpack_type, /datum/statpack))
		statpack = new statpack_type()
	else
		statpack = new /datum/statpack/wildcard/fated()
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
	var/list/preset_configs = preset["quirk_configs"]
	for(var/datum/quirk/Q in quirks)
		if(islist(preset_configs))
			Q.load_config(preset_configs["[Q.type]"])
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
	var/statpack_path = string_to_typepath(preset["statpack"])
	if(ispath(statpack_path, /datum/statpack))
		var/datum/statpack/sp_temp = new statpack_path()
		summary += sp_temp.name
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
