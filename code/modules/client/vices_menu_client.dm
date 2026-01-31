// Client-side vices menu datum
// This handles UI generation and caching to reduce server-side overhead
/datum/vices_menu
	var/client/owner // The client that owns this menu
	var/datum/preferences/prefs // Reference to the player's preferences
	var/list/cached_loadout_icons = list() // Client-specific icon cache (max 200 icons)
	var/list/temp_loadout_selection // Temporary storage for loadout selection state
	
/datum/vices_menu/New(client/C)
	if(!istype(C))
		qdel(src)
		return
	owner = C
	prefs = C.prefs
	..()

/datum/vices_menu/Destroy()
	owner = null
	prefs = null
	cached_loadout_icons.Cut()
	temp_loadout_selection = null
	return ..()

// Open the vices menu
/datum/vices_menu/proc/open_menu()
	if(!owner || !owner.mob || !prefs)
		return
	
	// Clean up duplicate vices/virtues (one-time fix for existing characters)
	prefs.fix_duplicate_vices()
	
	var/html_content = generate_vices_html()
	owner.mob << browse(html_content, "window=character_custom;size=750x500")

// Generate the full HTML for the vices menu
/datum/vices_menu/proc/generate_vices_html()
	if(!owner || !prefs)
		return ""
	
	var/mob/user = owner.mob
	
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
			.footer {
				background: [theme["panel_dark"]];
				border-top: 2px solid [theme["border"]];
				padding: 6px;
				text-align: center;
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
			</div>
			
			<div class="tabs">
				<a class="tab active" onclick="showTab('traits')">Traits & Virtues</a>
				<a class="tab" onclick="showTab('loadout')">Loadout Items</a>
				<a class="tab" onclick="showTab('languages')">Languages</a>
				<a class="tab" onclick="showTab('presets')">Presets</a>
			</div>
			
			<div id="traits" class="tab-content active">
		</head>
	"}
	
	// Generate "Traits & Virtues" tab (combines statpack, virtues, and vices)
	html += generate_statpack_tab()
	html += generate_virtues_tab()
	html += generate_vices_tab()
	
	html += "</div>" // Close traits tab
	
	// Generate loadout tab
	html += "<div id='loadout' class='tab-content'>"
	html += generate_loadout_tab()
	html += "</div>"
	
	// Generate languages tab
	html += "<div id='languages' class='tab-content'>"
	html += generate_languages_tab()
	html += "</div>"
	
	// Generate presets tab
	html += "<div id='presets' class='tab-content'>"
	html += generate_presets_tab()
	html += "</div>"
	
	html += {"
			<div class='footer'>
				<a class='btn' href='byond://?src=\ref[prefs];undo_action=undo'>↶ Undo Last Change</a>
				<a class='btn btn-clear' href='byond://?src=\ref[prefs];close_menu=1'>Close</a>
			</div>
		</body>
		</html>
	"}
	
	return html

// Generate statpack tab content
/datum/vices_menu/proc/generate_statpack_tab()
	if(!prefs)
		return ""
	
	var/list/theme = list(
		"text" = "#aa8f8f",
		"label" = "#aa8f8f",
		"border" = "#7b5353",
		"panel" = "#00000066"
	)
	
	var/html = {"
		<div class="statpack-section">
			<h2>Statpack Selection</h2>
			<div class="statpack-current">
	"}
	
	var/datum/statpack/current_statpack = prefs.statpack
	if(current_statpack)
		var/stats_string = current_statpack.generate_modifier_string()
		if(stats_string)
			html += "<div class='statpack-name'>[current_statpack.name] <span class='statpack-stats'>" + stats_string + "</span></div>"
		else
			html += "<div class='statpack-name'>[current_statpack.name]</div>"
		html += {"<div class="statpack-desc">[current_statpack.desc]</div>"}
	else
		html += "<div class='statpack-name'>None Selected</div>"
	
	html += {"
			</div>
			<div class="actions">
				<a class='btn btn-select' href='byond://?src=\ref[prefs];statpack_action=change'>Change Statpack</a>
			</div>
		</div>
	"}
	
	return html

// Generate virtues tab content
/datum/vices_menu/proc/generate_virtues_tab()
	if(!prefs)
		return ""
	
	var/list/theme = list(
		"text" = "#aa8f8f",
		"label" = "#aa8f8f",
		"border" = "#7b5353",
		"panel" = "#00000066"
	)
	
	var/html = {"
		<div class="statpack-section">
			<h2>Virtue Selection</h2>
			<div class="statpack-current">
	"}
	
	var/virtue_name = prefs.virtue ? prefs.virtue.name : "None"
	var/virtue_desc = prefs.virtue ? prefs.virtue.desc : ""
	html += "<div class=\"statpack-name\">Primary Virtue: [virtue_name]</div>"
	html += "<div class=\"statpack-desc\">[virtue_desc]</div>"
	
	html += "</div>"
	
	// Second virtue for Virtuous statpack
	if(prefs.statpack && prefs.statpack.name == "Virtuous" && prefs.virtuetwo)
		html += {"
		<div class="statpack-current" style='margin-top: 10px;'>
			<div class="statpack-name">Second Virtue: [prefs.virtuetwo.name]</div>
			<div class="statpack-desc">[prefs.virtuetwo.desc]</div>
		</div>"}
	
	html += {"
			<div class="actions">
				<a class='btn btn-select' href='byond://?src=\ref[prefs];virtue_action=change_primary'>Change Primary Virtue</a>
		"}
	
	if(prefs.statpack && prefs.statpack.name == "Virtuous")
		html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];virtue_action=change_secondary'>Change Second Virtue</a>"
	
	html += {"
			</div>
		</div>
	"}
	
	return html

// Generate vices tab content  
/datum/vices_menu/proc/generate_vices_tab()
	if(!prefs)
		return ""
	
	var/list/theme = list(
		"text" = "#aa8f8f",
		"label" = "#aa8f8f",
		"border" = "#7b5353",
		"panel" = "#00000066",
		"bg" = "#100000"
	)
	
	var/html = {"
		<h2 style='color: [theme["text"]]; padding: 0 20px; margin: 20px 0 10px 0; border-bottom: 1px solid [theme["border"]]; padding-bottom: 10px;'>Vice Selection</h2>
		<p style='color: [theme["label"]]; padding: 0 20px; margin: 0 0 15px 0; font-size: 0.9em;'>Select up to 5 vices (at least 1 required). Each selected vice grants +1 point. Points are shared between languages and loadout.</p>
		<div class="vices-grid">
	"}
	
	// Generate vice slots
	for(var/i = 1 to 5)
		var/slot_var = "vice[i]"
		var/datum/charflaw/current_vice = prefs.vars[slot_var]
		var/is_required = (i == 1)
		
		html += "<div class='vice-slot[is_required ? " required" : ""]'>"
		html += "<div class='slot-header'>"
		html += "<span class='slot-number'>Vice Slot [i]</span>"
		
		if(is_required)
			html += "<span class='slot-required'>REQUIRED</span>"
		
		if(current_vice)
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
			html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];vice_action=change;slot=[i]'>Change Vice</a>"
			if(!is_required)
				html += "<a class='btn btn-clear' href='byond://?src=\ref[prefs];vice_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
		else
			// Empty slot
			html += "<div class='empty-slot'>"
			if(is_required)
				html += "No Vice Selected - <b>REQUIRED</b><br><br>"
			else
				html += "Empty Slot<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];vice_action=select;slot=[i]'>Select Vice</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
			</div>
	"}
	
	return html

// Generate loadout tab content
/datum/vices_menu/proc/generate_loadout_tab()
	if(!prefs || !owner)
		return ""
	
	var/mob/user = owner.mob
	var/list/theme = list(
		"text" = "#aa8f8f",
		"label" = "#aa8f8f",
		"border" = "#7b5353",
		"panel" = "#00000066",
		"panel_dark" = "#00000044"
	)
	
	var/html = {"
			<h2 style='color: [theme["text"]]; margin: 0 0 10px 0; font-size: 1.1em;'>Loadout Selection</h2>
	"}
	
	// Calculate point costs for loadout
	var/total_points = prefs.get_total_points()
	var/loadout_spent = 0
	for(var/i = 1 to 10)
		var/datum/loadout_item/loadout_slot = prefs.vars[i == 1 ? "loadout" : "loadout[i]"]
		if(loadout_slot && loadout_slot.triumph_cost)
			loadout_spent += loadout_slot.triumph_cost

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
	
	// Generate loadout slots with icons
	for(var/i = 1 to 10)
		var/slot_var = i == 1 ? "loadout" : "loadout[i]"
		var/datum/loadout_item/current_item = prefs.vars[slot_var]
		var/custom_name = prefs.vars["loadout_[i]_name"]
		var/custom_desc = prefs.vars["loadout_[i]_desc"]
		var/item_color = prefs.vars["loadout_[i]_hex"]
		
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
			
			// Use the item's icon with CLIENT-SIDE caching
			if(icon_file && icon_state)
				var/cache_key = "[icon_file]_[icon_state]"
				if(!(cache_key in cached_loadout_icons))
					// Prevent cache from growing too large
					if(cached_loadout_icons.len >= 200)
						cached_loadout_icons.Cut(1, 50) // Remove oldest 50 entries
					cached_loadout_icons[cache_key] = icon(icon_file, icon_state)
				user << browse_rsc(cached_loadout_icons[cache_key], "loadout_icon_[i].png")
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
			html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];loadout_action=item;slot=[i]'>Change Item</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[prefs];loadout_action=rename;slot=[i]'>Rename</a>"
			html += "<a class='btn btn-customize' href='byond://?src=\ref[prefs];loadout_action=describe;slot=[i]'>Description</a>"
			html += "<a class='btn btn-color' href='byond://?src=\ref[prefs];loadout_action=color;slot=[i]'>Color</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[prefs];loadout_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
		else
			html += "<div class='empty-slot'>"
			html += "Empty Slot<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[prefs];loadout_action=item;slot=[i]'>Select Item</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
			</div>
	"}
	
	return html

// Continue in next file section...
