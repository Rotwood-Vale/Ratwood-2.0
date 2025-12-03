// Alchemy book using the recipe_book framework with custom book entries
/obj/item/recipe_book/alchemy
	name = "Secrets of Alchemy"
	icon_state = "book3_0"
	base_icon_state = "book3"
	types = list(/datum/book_entry/alchemy)

// Book entry base for alchemy - creates all the entries dynamically
/datum/book_entry/alchemy
	abstract_type = /datum/book_entry/alchemy
	category = "Alchemy"

// Introduction to the alchemy system
/datum/book_entry/alchemy/introduction
	name = "Introduction to Alchemy"
	category = "Introduction"

/datum/book_entry/alchemy/introduction/inner_book_html(mob/user)
	return {"
		<h2>🜏 Greetings, Aspiring Alchemist! 🜏</h2>
		<p>Within these sacred pages lie the mysteries of the alchemical arts, a fusion of ancient wisdom from the kingdoms of Deliverance and the Scrolls of Elder knowledge, refined through generations of careful study.</p>
		<p>Each ingredient of this world carries within it <strong style="color: #8b4513;">four fundamental essences</strong>, invisible to the untrained eye but revealed through the sacred art of extraction. The first three essences grant power and restoration, while the <span style="color: #c62828; font-weight: bold;">fourth essence always harbors corruption</span>—a reminder that all power comes with a price.</p>
		<p>Through the proper application of base reagents in the sacred cauldron, you may extract these essences selectively. Mix wisely, for when two reagents share an essence, they create powerful elixirs beyond the sum of their parts!</p>
	"}

// The 8 extract types
/datum/book_entry/alchemy/extracts
	name = "The Eight Sacred Extracts"
	category = "Extraction"

/datum/book_entry/alchemy/extracts/inner_book_html(mob/user)
	return {"
		<h2>⚗️ The Eight Sacred Extracts ⚗️</h2>
		<p>Through four tiers of skill, the alchemist masters eight distinct forms of extraction, each revealing different aspects of an ingredient's nature.</p>
		
		<h3 style="color: #2e7d32; margin-top: 15px;">NOVICE - The Foundation</h3>
		<p><strong>Herb Tonic</strong> (Water 90u + Herb → 60u):<br>
		Extracts the <strong>1st Essence</strong>. Water, the universal solvent, draws forth the most accessible essence.</p>
		
		<p><strong>Oil of Herb</strong> (Oil 90u + Herb → 60u):<br>
		Extracts the <strong>2nd Essence</strong>. Oil's viscous nature captures the deeper, hidden essence.</p>
		
		<h3 style="color: #ff6f00; margin-top: 15px;">AMATEUR - The Expansion</h3>
		<p><strong>Herb Bitters</strong> (Wine 90u + Herb → 60u):<br>
		Extracts <strong>ALL 4 Essences</strong>. Wine's alchemical power reveals everything at once—both blessing and curse!</p>
		
		<p><strong>Vitriol of Herb</strong> (Acid 90u + Herb → 60u):<br>
		Extracts the <span style="color: #c62828;"><strong>4th Essence (Corruption)</strong></span>. Acid's caustic nature isolates only the harmful aspect—perfect for deadly poisons!</p>
		
		<h3 style="color: #1565c0; margin-top: 15px;">JOURNEYMAN - The Concentration</h3>
		<p><strong>Herb Syrup</strong> (Boil Tonic again → 30u):<br>
		Upgrades 1st Essence to <strong>GREATER power (2x potency!)</strong>. No additional herb required—mastery over matter itself!</p>
		
		<p><strong>Herb Paste</strong> (Boil Oil again → 30u):<br>
		Upgrades 2nd Essence to <strong>GREATER power (2x potency!)</strong>. The essence condenses and amplifies.</p>
		
		<h3 style="color: #6a1b9a; margin-top: 15px;">EXPERT - The Mastery</h3>
		<p><strong>Herb Powder</strong> (Boil Bitters again → 30u):<br>
		Upgrades <strong>ALL 4 Essences to GREATER!</strong> The ultimate achievement—all powers amplified simultaneously!</p>
		
		<p><strong>Herb Salt</strong> (Boil Vitriol again → 30u):<br>
		Upgrades the <span style="color: #c62828;"><strong>4th Essence to GREATER Corruption!</strong></span> The deadliest poisons known to alchemy!</p>
	"}

// How to make potions
/datum/book_entry/alchemy/mixing
	name = "The Art of Potion Mixing"
	category = "Mixing"

/datum/book_entry/alchemy/mixing/inner_book_html(mob/user)
	return {"
		<h2>🧪 The Art of Potion Mixing 🧪</h2>
		<p>The true power of alchemy reveals itself when two extracts are combined. When reagents share a common essence, they may be mixed in a vial to create potions of extraordinary power!</p>
		
		<h3 style="color: #8b4513;">The Rules of Mixing:</h3>
		<p><strong>1. Shared Essences:</strong> The resulting potion will possess ALL essences that appear in BOTH source extracts. If Rosa Tonic (heal burn, restore blood, fortify constitution) is mixed with Symphitum Oil (heal burn, heal brute, restore blood), the resulting potion will have heal burn AND restore blood—both effects apply when consumed!</p>
		
		<p><strong>2. Different Sources:</strong> You cannot mix extracts from the same ingredient. Rosa Tonic cannot be mixed with Rosa Paste. Seek diversity in your ingredients!</p>
		
		<p><strong>3. Potion Naming:</strong> The alchemical spirits name themselves based on their nature:<br>
		- <strong>One essence</strong>: Simple, elegant names (e.g., "soothing", "mending")<br>
		- <strong>Two essences</strong>: Paired descriptive words (e.g., "soothing heal", "vital fortitude")<br>
		- <strong>Three or more essences</strong>: The mysterious "strange brew"—too complex to name!</p>
		
		<p><strong>4. Property Blending:</strong> Mixed potions inherit the colors, smells, and tastes of their source extracts, creating unique visual and sensory experiences.</p>
		
		<h3 style="color: #8b4513;">Example:</h3>
		<p>Rosa Tonic (1st essence: heal burn) + Symphitum Oil (2nd essence: heal brute)<br>
		→ No shared essences = No potion created<br><br>
		Rosa Tonic (heal burn, restore blood) + Blackberry Powder (restore blood, heal toxin)<br>
		→ Shared essence: restore blood = "vital" potion created!</p>
	"}

// Ingredient list - dynamically generated
/datum/book_entry/alchemy/ingredients
	name = "Known Alchemical Ingredients"
	category = "Ingredients"

/datum/book_entry/alchemy/ingredients/inner_book_html(mob/user)
	var/html = "<h2>📜 Known Alchemical Ingredients 📜</h2>"
	html += "<p style='font-style: italic; margin-bottom: 15px;'>A complete catalog of all ingredients discovered to possess alchemical essences. Study them well!</p>"
	
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
		<table style="width: 100%; border-collapse: collapse; margin: 10px 0; font-size: 0.9em;">
			<tr style="background-color: #8b4513; color: white;">
				<th style="border: 2px solid #3e2723; padding: 8px; text-align: left;">Ingredient</th>
				<th style="border: 2px solid #3e2723; padding: 8px; text-align: center;">1st Essence</th>
				<th style="border: 2px solid #3e2723; padding: 8px; text-align: center;">2nd Essence</th>
				<th style="border: 2px solid #3e2723; padding: 8px; text-align: center;">3rd Essence</th>
				<th style="border: 2px solid #3e2723; padding: 8px; text-align: center; color: #ffcccb;">4th Essence (⚠)</th>
			</tr>
	"}
	
	// Add rows for each ingredient
	var/row_num = 0
	for(var/item_name in sorted_names)
		var/list/effects = alchemy_items[item_name]
		row_num++
		
		var/row_color = row_num % 2 == 0 ? "rgba(210, 180, 140, 0.2)" : "rgba(255, 255, 255, 0.8)"
		html += "<tr style='background-color: [row_color];'>"
		html += "<td style='border: 1px solid #3e2723; padding: 6px; font-weight: bold;'>[item_name]</td>"
		
		// Effect 1-3 (positive, green)
		for(var/i = 1 to 3)
			if(length(effects) >= i)
				html += "<td style='border: 1px solid #3e2723; padding: 6px; text-align: center; color: #2e7d32; font-style: italic;'>[format_effect_name(effects[i])]</td>"
			else
				html += "<td style='border: 1px solid #3e2723; padding: 6px; text-align: center;'>—</td>"
		
		// Effect 4 (negative, red)
		if(length(effects) >= 4)
			html += "<td style='border: 1px solid #3e2723; padding: 6px; text-align: center; color: #c62828; font-weight: bold; font-style: italic;'>[format_effect_name(effects[4])]</td>"
		else
			html += "<td style='border: 1px solid #3e2723; padding: 6px; text-align: center;'>—</td>"
		
		html += "</tr>"
	
	html += "</table>"
	html += "<p style='margin-top: 15px; font-style: italic; color: #654321;'>Total ingredients cataloged: [sorted_names.len]</p>"
	
	return html

/datum/book_entry/alchemy/ingredients/proc/format_effect_name(effect_name)
	if(!effect_name)
		return "Unknown"
	
	// Convert effect constant to readable name
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
