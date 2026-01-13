/datum/preferences/proc/open_language_menu(mob/user)
	if(!user || !user.client)
		return
	
	// Redirect to unified character customization menu
	open_vices_menu(user)

/datum/preferences/proc/generate_language_html(mob/user)
	// Use shared point pool
	var/total_points = get_total_points()
	var/spent_points = 0
    
	// Calculate spent points from languages (1 each)
	var/purchased_count = 0
	if(extra_language_1 && extra_language_1 != "None")
		purchased_count++
	if(extra_language_2 && extra_language_2 != "None")
		purchased_count++
    
	spent_points = purchased_count * 1
	// Also subtract loadout spent to reflect shared pool
	var/remaining_points = total_points - (spent_points + get_loadout_points_spent())
	
	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<style>
			body {
				font-family: Verdana, Arial, sans-serif;
				background: #1C0000;
				color: #e3c06f;
				margin: 0;
				padding: 20px;
			}
			.header {
				text-align: center;
				padding: 15px;
				background: rgba(0, 0, 0, 0.4);
				border: 1px solid #e3c06f;
				margin-bottom: 20px;
			}
			.header h1 {
				margin: 0;
				color: #e3c06f;
				font-size: 1.5em;
			}
			.points-counter {
				font-size: 1em;
				margin-top: 10px;
			}
			.points-available {
				color: #4CAF50;
			}
			.points-spent {
				color: #ff9800;
			}
			.info-box {
				background: rgba(76, 175, 80, 0.1);
				border: 1px solid #4CAF50;
				padding: 15px;
				margin-bottom: 20px;
				font-size: 0.9em;
			}
			.language-grid {
				display: grid;
				grid-template-columns: 1fr 1fr;
				gap: 15px;
				padding: 20px;
			}
			.language-slot {
				background: rgba(0, 0, 0, 0.4);
				border: 1px solid #444;
				padding: 15px;
			}
			.language-slot:hover {
				border-color: #e3c06f;
			}
			.slot-header {
				display: flex;
				justify-content: space-between;
				align-items: center;
				margin-bottom: 10px;
				padding-bottom: 10px;
				border-bottom: 1px solid #444;
			}
			.slot-number {
				font-weight: bold;
				color: #e3c06f;
			}
			.slot-cost {
				background: #e3c06f;
				color: #1C0000;
				padding: 2px 8px;
				font-size: 0.9em;
				font-weight: bold;
			}
			.language-display {
				margin-bottom: 10px;
			}
			.language-name {
				font-weight: bold;
				color: #e3c06f;
				margin-bottom: 5px;
				font-size: 1.1em;
			}
			.language-desc {
				font-size: 0.85em;
				color: #999;
				line-height: 1.4;
			}
			.btn {
				padding: 6px 12px;
				border: 1px solid #444;
				background: rgba(0, 0, 0, 0.4);
				color: #e3c06f;
				cursor: pointer;
				font-family: Verdana, Arial, sans-serif;
				font-size: 0.85em;
				text-decoration: none;
				display: inline-block;
				margin: 2px;
			}
			.btn:hover {
				background: rgba(227, 192, 111, 0.2);
				border-color: #e3c06f;
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
			.empty-slot {
				text-align: center;
				padding: 20px;
				color: #666;
				font-style: italic;
			}
			.actions {
				margin-top: 10px;
				display: flex;
				flex-wrap: wrap;
				gap: 5px;
			}
		</style>
		<body>
			<div class="header">
				<h1>📜 Additional Language Selection 📜</h1>
				<div class="points-counter">
					<span class="points-available">Available Points: [remaining_points]</span> | 
					<span class="points-spent">Spent (Languages): [spent_points]</span> / 
					<span>Total Points: [total_points]</span>
				</div>
			</div>
			
			<div class="info-box">
				ℹ You get <b>one free language</b> based on your character background, plus up to 2 additional languages (1 point each). Your race already grants you certain languages by default.
			</div>
			
			<div class="language-grid">
	"}
	
	// FREE LANGUAGE SLOT
	var/datum/language/free_lang
	if(ispath(extra_language, /datum/language))
		free_lang = new extra_language()
	
	html += "<div class='language-slot' style='border-color: #4CAF50;'>"
	html += "<div class='slot-header'>"
	html += "<span class='slot-number'>Free Language</span>"
	html += "<span class='slot-cost' style='background: #4CAF50; color: #000;'>FREE</span>"
	html += "</div>"
	
	if(free_lang)
		html += "<div class='language-display'>"
		html += "<div class='language-name'>[free_lang.name]</div>"
		html += "<div class='language-desc'>[free_lang.desc]</div>"
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
	
	// Generate 2 paid language slots (1 point each)
	for(var/i = 1 to 2)
		var/slot_var = i == 1 ? "extra_language_1" : "extra_language_2"
		var/current_lang_path = vars[slot_var]
		
		html += "<div class='language-slot'>"
		html += "<div class='slot-header'>"
		html += "<span class='slot-number'>Language Slot [i]</span>"
		
		if(current_lang_path && current_lang_path != "None")
			html += "<span class='slot-cost'>1 Point</span>"
		
		html += "</div>"
		
		if(current_lang_path && current_lang_path != "None")
			// Language is selected
			var/datum/language/lang = new current_lang_path()
			
			html += "<div class='language-display'>"
			html += "<div class='language-name'>[lang.name]</div>"
			html += "<div class='language-desc'>[lang.desc]</div>"
			html += "</div>"
			
			html += "<div class='actions'>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];language_action=change;slot=[i]'>Change Language</a>"
			html += "<a class='btn btn-clear' href='byond://?src=\ref[src];language_action=clear;slot=[i]'>Clear</a>"
			html += "</div>"
			
			qdel(lang)
		else
			// Empty slot
			html += "<div class='empty-slot'>"
			html += "No Language Selected<br><br>"
			html += "<a class='btn btn-select' href='byond://?src=\ref[src];language_action=select;slot=[i]'>Select Language</a>"
			html += "</div>"
		
		html += "</div>"
	
	html += {"
			</div>
		</body>
		</html>
	"}
	
	return html

// Old Topic handler - now handled in vices_menu.dm

// Old Topic handler removed - now handled in vices_menu.dm
