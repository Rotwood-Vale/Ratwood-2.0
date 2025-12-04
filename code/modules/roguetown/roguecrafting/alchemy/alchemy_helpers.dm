// Helper proc to get smell description for an effect
/proc/get_effect_smell(effect)
	return GLOB.alchemy_effect_smells[effect] || "strange essence"

// Helper proc to get word pair for an effect [adjective, noun]
/proc/get_effect_words(effect)
	return GLOB.alchemy_effect_words[effect] || list("strange", "brew")

// Helper proc to generate potion name from effects list
/proc/generate_potion_name(list/effects)
	if(!effects || !effects.len)
		return "alchemical potion"
	
	// 3 or more effects = "strange brew"
	if(effects.len >= 3)
		return "strange brew"
	
	// 1 effect: use ONLY first word (adjective) from that effect
	if(effects.len == 1)
		var/list/words = get_effect_words(effects[1])
		return "[words[1]]"
	
	// 2 effects: mix adjective from first with noun from second
	if(effects.len == 2)
		var/list/words1 = get_effect_words(effects[1])
		var/list/words2 = get_effect_words(effects[2])
		return "[words1[1]] [words2[2]]"
	
	return "alchemical potion"

// Helper proc to blend colors
/proc/blend_colors(color1, color2, ratio = 0.5)
	if(!color1 || !color2)
		return color1 || color2 || "#FFFFFF"
	
	var/r1 = hex2num(copytext(color1, 2, 4))
	var/g1 = hex2num(copytext(color1, 4, 6))
	var/b1 = hex2num(copytext(color1, 6, 8))
	
	var/r2 = hex2num(copytext(color2, 2, 4))
	var/g2 = hex2num(copytext(color2, 4, 6))
	var/b2 = hex2num(copytext(color2, 6, 8))
	
	var/r = round(r1 * (1 - ratio) + r2 * ratio)
	var/g = round(g1 * (1 - ratio) + g2 * ratio)
	var/b = round(b1 * (1 - ratio) + b2 * ratio)
	
	return rgb(r, g, b)

// Add alchemy effects variable to all reagents (simple list, no datum wrapper)
/datum/reagent
	var/list/alchemy_effects = null
	var/smell_description = null  // For alchemy smells

// Helper proc to set alchemy effects on a reagent
/datum/reagent/proc/set_alchemy_effects(list/effect_list)
	if(!effect_list || !effect_list.len)
		alchemy_effects = null
		return
	alchemy_effects = effect_list.Copy()

// Proc to get common effects between two reagents
/proc/get_common_alchemy_effects(datum/reagent/R1, datum/reagent/R2)
	if(!R1?.alchemy_effects || !R2?.alchemy_effects)
		return list()
	
	var/list/common = list()
	for(var/effect in R1.alchemy_effects)
		if(effect in R2.alchemy_effects)
			common += effect
	
	return common

// Check if mixing should occur and perform it
/datum/reagents/proc/try_alchemy_mixing()
	if(!my_atom)
		return FALSE
	
	// Need at least 2 reagents to mix
	if(reagent_list.len < 2)
		return FALSE
	
	// Find pairs of reagents with common effects
	for(var/i = 1 to reagent_list.len)
		var/datum/reagent/R1 = reagent_list[i]
		if(!R1.alchemy_effects || !R1.alchemy_effects.len)
			continue
			
		for(var/j = i+1 to reagent_list.len)
			var/datum/reagent/R2 = reagent_list[j]
			if(!R2.alchemy_effects || !R2.alchemy_effects.len)
				continue
			
			// Check if both reagents share any common source herbs - if so, skip
			if(istype(R1, /datum/reagent/herb_extract) && istype(R2, /datum/reagent/herb_extract))
				var/datum/reagent/herb_extract/E1 = R1
				var/datum/reagent/herb_extract/E2 = R2
				if(E1.source_herb_name && E2.source_herb_name)
					// Split by hyphen to get all source herbs
					var/list/herbs1 = splittext(E1.source_herb_name, "-")
					var/list/herbs2 = splittext(E2.source_herb_name, "-")
					var/has_common_herb = FALSE
					for(var/herb1 in herbs1)
						if(herb1 in herbs2)
							has_common_herb = TRUE
							break
					if(has_common_herb)
						continue  // Share a common herb source, don't mix
			
			// Get common effects
			var/list/common = get_common_alchemy_effects(R1, R2)
			if(!common || !common.len)
				continue
			
			// Found a match! Create combined extract with all common effects
			// Calculate amount to convert (minimum of the two reagents)
			var/convert_amount = min(R1.volume, R2.volume)
			convert_amount = min(convert_amount, 30)  // Max 30 units per mix
			
			// Remove source reagents
			remove_reagent(R1.type, convert_amount)
			remove_reagent(R2.type, convert_amount)
			
			// Create a new tonic with combined effects (2 reagents → 1 mixed extract)
			var/datum/reagent/herb_extract/tonic/mixed = new()
			mixed.alchemy_effects = common.Copy()
			
			// Combine herb names to prevent re-mixing
			var/datum/reagent/herb_extract/E1 = R1
			var/datum/reagent/herb_extract/E2 = R2
			mixed.source_herb_name = "[E1.source_herb_name]-[E2.source_herb_name]"
			
			// Generate name based on effects
			mixed.name = generate_potion_name(common)
			mixed.description = "A potion created by mixing reagents with common alchemical properties."
			
			// Blend colors (50/50 mix)
			mixed.color = blend_colors(R1.color, R2.color, 0.5)
			
			// Combine smells from effects
			var/list/smell_parts = list()
			for(var/effect in common)
				var/smell = get_effect_smell(effect)
				if(smell && !(smell in smell_parts))
					smell_parts += smell
			mixed.smell_description = smell_parts.Join(", ")
			
			// Combine tastes
			if(R1.taste_description && R2.taste_description)
				mixed.taste_description = "[R1.taste_description] and [R2.taste_description]"
			else
				mixed.taste_description = R1.taste_description || R2.taste_description || "alchemical essence"
			
			// Blend alpha (transparency)
			if(isnum(R1.alpha) && isnum(R2.alpha))
				mixed.alpha = round((R1.alpha + R2.alpha) / 2)
			
			// Add the mixed extract (2 reagents → 1 potion, so half the amount)
			add_reagent_data(mixed, convert_amount * 0.5)
			
			// Notify
			if(istype(my_atom, /obj/item/reagent_containers))
				my_atom.visible_message("<span class='notice'>[my_atom] bubbles as the reagents combine into a potion!</span>")
			
			return TRUE
	
	return FALSE

// Helper to add a reagent with custom data (used for dynamic alchemy mixing)
/datum/reagents/proc/add_reagent_data(datum/reagent/R, amount)
	if(!R || amount <= 0)
		return
	
	// Check if we already have this reagent type
	var/datum/reagent/existing = has_reagent(R.type)
	if(existing)
		existing.volume += amount
		if(R.alchemy_effects && R.alchemy_effects.len)
			// Merge effects if they're not already present
			if(!existing.alchemy_effects)
				existing.alchemy_effects = list()
			for(var/effect in R.alchemy_effects)
				if(!(effect in existing.alchemy_effects))
					existing.alchemy_effects += effect
	else
		// Add new reagent
		R.volume = amount
		R.holder = src
		reagent_list += R
		if(R.alchemy_effects && R.alchemy_effects.len)
			R.alchemy_effects = R.alchemy_effects.Copy()
	
	update_total()
	my_atom?.on_reagent_change(ADD_REAGENT)
	handle_reactions()
	return TRUE
