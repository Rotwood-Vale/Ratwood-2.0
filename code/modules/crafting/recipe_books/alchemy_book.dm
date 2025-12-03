// Custom alchemy book that displays ingredients with their alchemy_effects in a table
/obj/item/recipe_book/alchemy
	name = "Secrets of Alchemy"
	icon_state = "book3_0"
	base_icon_state = "book3"

/obj/item/recipe_book/alchemy/attack_self(mob/user)
	current_reader = user
	current_reader << browse(generate_alchemy_html(user),"window=recipe;size=1000x810")

/obj/item/recipe_book/alchemy/proc/generate_alchemy_html(mob/user)
	var/client/client = user
	if(!istype(client))
		client = user.client

	user << browse_rsc('html/book.png')

	var/html = {"
		<!DOCTYPE html>
		<html lang="en">
		<meta charset='UTF-8'>
		<meta http-equiv='X-UA-Compatible' content='IE=edge,chrome=1'/>
		<meta http-equiv='Content-Type' content='text/html; charset=UTF-8'/>

		<style>
			@import url('https://fonts.googleapis.com/css2?family=Charm:wght@700&display=swap');
			body {
				font-family: "Charm", cursive;
				font-size: 0.85em;
				text-align: center;
				margin: 15px;
				color: #3e2723;
				background-color: rgb(31, 20, 24);
				background: url('book.png');
				background-repeat: no-repeat;
				background-attachment: fixed;
				background-size: 100% 100%;
				overflow-y: scroll;
			}
			h1 {
				text-align: center;
				font-size: 1.7em;
				border-bottom: 2px solid #3e2723;
				padding-bottom: 8px;
				margin-bottom: 12px;
				color: #8b4513;
			}
			h2 {
				text-align: center;
				font-size: 1.2em;
				margin-top: 18px;
				margin-bottom: 8px;
				color: #654321;
			}
			.intro {
				text-align: left;
				padding: 12px 25px;
				margin-bottom: 15px;
				line-height: 1.5;
				font-size: 0.95em;
				border: 2px solid #8b4513;
				border-radius: 8px;
				background-color: rgba(210, 180, 140, 0.15);
			}
			.intro p {
				margin: 8px 0;
			}
			.intro strong {
				color: #8b4513;
			}
			table {
				margin: 12px auto;
				border-collapse: collapse;
				width: 96%;
				background-color: rgba(255, 255, 255, 0.75);
				font-size: 0.9em;
			}
			table, th, td {
				border: 2px solid #3e2723;
			}
			th {
				padding: 8px 4px;
				text-align: center;
				background-color: #8b4513;
				color: white;
				font-size: 0.95em;
			}
			td {
				padding: 6px 4px;
				text-align: center;
				vertical-align: middle;
			}
			tr:nth-child(even) {
				background-color: rgba(210, 180, 140, 0.2);
			}
			tr:hover {
				background-color: rgba(210, 180, 140, 0.4);
			}
			.ingredient-name {
				font-weight: bold;
				color: #3e2723;
				text-align: left;
				padding-left: 8px;
			}
			.effect {
				font-style: italic;
				color: #654321;
				font-size: 0.9em;
			}
			.positive {
				color: #2e7d32;
			}
			.negative {
				color: #c62828;
				font-weight: bold;
			}
			.extraction-guide {
				text-align: left;
				padding: 12px 25px;
				margin: 15px 25px;
				line-height: 1.4;
				font-size: 0.9em;
				border: 2px solid #8b4513;
				border-radius: 8px;
				background-color: rgba(210, 180, 140, 0.2);
			}
			.extraction-guide ul {
				margin: 8px 0;
				padding-left: 25px;
			}
			.extraction-guide li {
				margin: 4px 0;
			}
			.extraction-guide p {
				margin: 6px 0;
			}
		</style>

		<body>
			<h1>🜏 Secrets of Alchemy 🜏</h1>
			
			<div class="intro">
				<p><strong>Greetings, Aspiring Alchemist!</strong></p>
				<p>Within these sacred pages lie the mysteries of the alchemical arts—a fusion of ancient wisdom from the kingdoms of Deliverance and the Scrolls of Elder knowledge, refined through generations of careful study.</p>
				<p>Each ingredient of this world carries within it <strong>four fundamental essences</strong>, invisible to the untrained eye but revealed through the sacred art of extraction. The first three essences grant power and restoration, while the <span class="negative">fourth essence always harbors corruption</span>—a reminder that all power comes with a price.</p>
				<p>Through the proper application of base reagents in the sacred cauldron, you may extract these essences selectively. Mix wisely, for when two reagents share an essence, they create powerful elixirs beyond the sum of their parts!</p>
			</div>

			<h2>⚗️ The Four-Tiered Path of Extraction ⚗️</h2>
			<div class="extraction-guide">
				<p><strong>NOVICE</strong> - The Path of Water and Oil:</p>
				<ul>
					<li><strong>Herb Tonic</strong> (Water 90u + Herb) → Extracts the <strong>1st Essence</strong> (60u)</li>
					<li><strong>Oil of Herb</strong> (Oil 90u + Herb) → Extracts the <strong>2nd Essence</strong> (60u)</li>
				</ul>
				
				<p><strong>AMATEUR</strong> - The Path of Wine and Acid:</p>
				<ul>
					<li><strong>Herb Bitters</strong> (Wine 90u + Herb) → Extracts <strong>ALL 4 Essences</strong> (60u)</li>
					<li><strong>Vitriol of Herb</strong> (Acid 90u + Herb) → Extracts the <span class="negative">4th Essence (Corruption)</span> (60u)</li>
				</ul>
				
				<p><strong>JOURNEYMAN</strong> - The Path of Concentration:</p>
				<ul>
					<li><strong>Herb Syrup</strong> (Boil Tonic again) → <strong>GREATER 1st Essence</strong> (30u, 2x power!)</li>
					<li><strong>Herb Paste</strong> (Boil Oil again) → <strong>GREATER 2nd Essence</strong> (30u, 2x power!)</li>
				</ul>
				
				<p><strong>EXPERT</strong> - The Path of Mastery:</p>
				<ul>
					<li><strong>Herb Powder</strong> (Boil Bitters again) → <strong>GREATER ALL Essences</strong> (30u, ultimate power!)</li>
					<li><strong>Herb Salt</strong> (Boil Vitriol again) → <span class="negative"><strong>GREATER Corruption</strong></span> (30u, deadly poisons!)</li>
				</ul>
			</div>

			<h2>📜 Known Alchemical Ingredients 📜</h2>
	"}

	// Gather all items with alchemy_effects
	var/list/alchemy_items = list()
	
	// Check all grown items (herbs and produce)
	for(var/obj/item/reagent_containers/food/snacks/grown/path in subtypesof(/obj/item/reagent_containers/food/snacks/grown))
		var/list/effects = initial(path.alchemy_effects)
		if(effects && length(effects) > 0)
			var/item_name = initial(path.name)
			if(item_name && item_name != "")
				alchemy_items[item_name] = effects
	
	// Sort alphabetically
	var/list/sorted_names = sortList(alchemy_items)
	
	// Create table
	html += {"
		<table>
			<tr>
				<th style="width: 25%;">Ingredient</th>
				<th style="width: 18%;">1st Essence</th>
				<th style="width: 18%;">2nd Essence</th>
				<th style="width: 18%;">3rd Essence</th>
				<th style="width: 21%;" class="negative">4th Essence (⚠)</th>
			</tr>
	"}
	
	// Add rows for each ingredient
	for(var/item_name in sorted_names)
		var/list/effects = alchemy_items[item_name]
		
		html += "<tr>"
		html += "<td class='ingredient-name'>[item_name]</td>"
		
		// Effect 1
		if(length(effects) >= 1)
			html += "<td class='effect positive'>[format_effect_name(effects[1])]</td>"
		else
			html += "<td>—</td>"
		
		// Effect 2
		if(length(effects) >= 2)
			html += "<td class='effect positive'>[format_effect_name(effects[2])]</td>"
		else
			html += "<td>—</td>"
		
		// Effect 3
		if(length(effects) >= 3)
			html += "<td class='effect positive'>[format_effect_name(effects[3])]</td>"
		else
			html += "<td>—</td>"
		
		// Effect 4 (always negative)
		if(length(effects) >= 4)
			html += "<td class='effect negative'>[format_effect_name(effects[4])]</td>"
		else
			html += "<td>—</td>"
		
		html += "</tr>"
	
	html += {"
		</table>
		
		<div class="intro" style="margin-top: 25px;">
			<p><strong>The Art of Mixing:</strong></p>
			<p>When two extracts share a common essence, they may be combined to create potions of extraordinary power! The resulting elixir will possess ALL shared essences simultaneously.</p>
			<p><em>Remember:</em> Extracts from the same herb cannot be mixed—seek diversity in your ingredients!</p>
			<p><strong>Potion Names:</strong> Single essence = Simple name, Two essences = Paired words, Three or more = "Strange Brew"</p>
		</div>
		
		</body>
		</html>
	"}
	
	return html

/obj/item/recipe_book/alchemy/proc/format_effect_name(effect_name)
	if(!effect_name)
		return "Unknown"
	
	// Convert effect constant to readable name
	// Remove "EFFECT_" prefix and "GREATER_" prefix, convert underscores to spaces
	var/formatted = replacetext(effect_name, "EFFECT_", "")
	formatted = replacetext(formatted, "GREATER_", "")
	formatted = replacetext(formatted, "_", " ")
	
	// Capitalize first letter of each word
	var/list/words = splittext(formatted, " ")
	var/result = ""
	for(var/word in words)
		if(length(word) > 0)
			result += uppertext(copytext(word, 1, 2)) + copytext(word, 2) + " "
	
	return trim(result)
