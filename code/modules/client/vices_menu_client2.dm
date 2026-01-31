// Continuation of client-side vices menu datum

// Generate languages tab content
/datum/vices_menu/proc/generate_languages_tab()
	if(!prefs || !owner)
		return ""
	
	var/mob/user = owner.mob
	var/list/theme = list(
		"text" = "#aa8f8f",
		"label" = "#aa8f8f",
		"border" = "#7b5353",
		"panel" = "#00000066",
		"panel_dark" = "#00000044",
		"bg" = "#100000"
	)
	
	var/html = {"
		<h2 style='color: [theme["text"]]; margin: 0 0 20px 0;'>📜 Additional Language Selection 📜</h2>
	"}
	
	// Calculate language costs using actual player TRIUMPHS
	var/lang_spent = 0
	if(prefs.extra_language_1 && prefs.extra_language_1 != "None")
		lang_spent += 2
	if(prefs.extra_language_2 && prefs.extra_language_2 != "None")
		lang_spent += 4

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
	if(ispath(prefs.extra_language, /datum/language))
		free_lang = new prefs.extra_language()
	
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
		html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];language_action=free_change'>Change Language</a>"
		html += "</div>"
		qdel(free_lang)
	else
		html += "<div class='empty-slot'>"
		html += "No Language Selected<br><br>"
		html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];language_action=free_select'>Select Language</a>"
		html += "</div>"
	
	html += "</div>"
	
	// Generate 2 paid language slots
	for(var/i = 1 to 2)
		var/slot_var = i == 1 ? "extra_language_1" : "extra_language_2"
		var/current_lang_path = prefs.vars[slot_var]
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
			html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];language_action=change;slot=[i]'>Change Language</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[prefs];language_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
			
			qdel(lang)
		else
			html += "<div class='empty-slot'>"
			html += "Empty Slot<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];language_action=select;slot=[i]'>Select Language</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
			</div>
	"}
	
	return html

// Generate presets tab content
/datum/vices_menu/proc/generate_presets_tab()
	if(!prefs)
		return ""
	
	var/list/theme = list(
		"text" = "#aa8f8f",
		"label" = "#aa8f8f",
		"border" = "#7b5353",
		"panel" = "#00000066"
	)
	
	var/html = {"
		<h2 style='color: [theme["text"]]; margin: 0 0 10px 0; font-size: 1.1em;'>Character Presets</h2>
		<div class='statpack-section' style='margin-bottom: 15px;'>
			<p style='margin: 0; font-size: 0.8em;'>Save and load complete character setups including statpack, virtues, vices, and loadout.</p>
		</div>
		<div style='display: grid; grid-template-columns: 1fr; gap: 10px;'>
	"}
	
	// Generate 3 preset slots
	for(var/i = 1 to 3)
		var/preset_summary = prefs.get_preset_summary(i)
		var/is_empty = (preset_summary == "Empty")
		
		html += "<div class='vice-slot'>"
		html += "<div class='slot-header'>"
		html += "<span class='slot-number'>Preset [i]</span>"
		html += "</div>"
		
		if(!is_empty)
			html += "<div class='vice-display'>"
			html += "<div class='vice-info'>"
			html += "<div class='vice-name'>Saved Configuration</div>"
			html += "<div class='vice-desc'>[preset_summary]</div>"
			html += "</div>"
			html += "</div>"
			html += "<div class='actions'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];preset_action=load;slot=[i]'>Load</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[prefs];preset_action=save;slot=[i]'>Overwrite</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[prefs];preset_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
		else
			html += "<div class='empty-slot'>"
			html += "Empty Preset Slot<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];preset_action=save;slot=[i]'>Save Current Setup</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
			</div>
	"}
	
	return html

// Show loadout item selection window (with CLIENT-SIDE icon caching)
/datum/vices_menu/proc/show_loadout_selection(slot)
	if(!prefs || !owner || !owner.mob)
		return
	
	var/mob/user = owner.mob
	var/slot_var = (slot == 1) ? "loadout" : "loadout[slot]"
	var/pref_ref = "\ref[prefs]"
	
	// Build list of already selected loadout items (excluding current slot)
	var/list/selected_loadouts = list()
	for(var/i = 1 to 10)
		if(i == slot)
			continue
		var/datum/loadout_item/other_item = prefs.vars[i == 1 ? "loadout" : "loadout[i]"]
		if(other_item)
			selected_loadouts += other_item.type
	
	var/html = {"
		<!DOCTYPE html>
		<html>
		<head>
			<meta charset='UTF-8'>
			<style>
				body {
					font-family: Verdana, Arial, sans-serif;
					background: #1a0000;
					color: #aa8f8f;
					margin: 0;
					padding: 10px;
				}
				.search-container {
					position: sticky;
					top: 0;
					background: #1a0000;
					padding: 5px 0;
					z-index: 100;
					border-bottom: 2px solid #7b5353;
				}
				.search-box {
					width: 100%;
					padding: 8px;
					background: #2a1111;
					border: 1px solid #7b5353;
					color: #aa8f8f;
					font-size: 1em;
					box-sizing: border-box;
				}
				.item-list {
					margin-top: 10px;
				}
				.item-entry {
					display: flex;
					align-items: center;
					padding: 8px;
					margin-bottom: 5px;
					background: rgba(0, 0, 0, 0.4);
					border: 1px solid #7b5353;
					cursor: pointer;
					transition: background 0.2s;
				}
				.item-entry:hover {
					background: rgba(123, 83, 83, 0.3);
				}
				.item-entry.hidden {
					display: none;
				}
				.item-entry.locked-item {
					opacity: 0.5;
					cursor: not-allowed;
					background: rgba(60, 20, 20, 0.3);
				}
				.item-entry.locked-item:hover {
					background: rgba(60, 20, 20, 0.3);
				}
				.item-icon {
					width: 32px;
					height: 32px;
					margin-right: 10px;
					background: rgba(0, 0, 0, 0.6);
					border: 1px solid #444;
				}
				.item-info {
					flex: 1;
				}
				.item-name {
					font-weight: bold;
					font-size: 0.9em;
				}
				.item-cost {
					color: #4CAF50;
					font-size: 0.8em;
					margin-left: 5px;
				}
				.lock-reason {
					font-size: 0.75em;
					color: #ff6b6b;
					margin-top: 2px;
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
	var/list/loadouts_available = list()
	
	for(var/path as anything in GLOB.loadout_items)
		var/datum/loadout_item/item = GLOB.loadout_items[path]
		
		var/is_locked = FALSE
		var/lock_reason = ""
		
		// Check if donator item
		if(item.donoritem && user?.ckey)
			if(!item.donator_ckey_check(user.ckey))
				continue
		
		// Check if nobility requirement is met
		if(!item.nobility_check(owner))
			is_locked = TRUE
			lock_reason = "🔒 Requires: Nobility virtue, or High priority for Noble/Courtier/Yeoman jobs"
		
		// Skip if already selected in another slot
		var/datum/loadout_item/current_item = prefs.vars[slot_var]
		if(item.type in selected_loadouts)
			if(!current_item || current_item.type != item.type)
				continue
		
		icon_counter++
		
		// Get item icon with CLIENT-SIDE caching
		var/obj/item/sample = item.path
		var/icon_file = initial(sample.icon)
		var/icon_state_name = initial(sample.icon_state)
		
		if(icon_file && icon_state_name)
			var/cache_key = "[icon_file]_[icon_state_name]"
			if(!(cache_key in cached_loadout_icons))
				if(cached_loadout_icons.len >= 200)
					cached_loadout_icons.Cut(1, 50)
				cached_loadout_icons[cache_key] = icon(icon_file, icon_state_name)
			user << browse_rsc(cached_loadout_icons[cache_key], "loadout_select_[icon_counter].png")
		
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
	
	// Store the available items temporarily in the CLIENT-SIDE datum
	temp_loadout_selection = list("prefs" = prefs, "items" = loadouts_available, "slot" = slot)
	user << browse(html, "window=loadout_select;size=500x700")
