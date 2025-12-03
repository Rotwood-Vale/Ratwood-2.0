// Elder Scrolls-style Alchemy Effect System
// Each reagent has a list of effects that can be discovered through combination

// Alchemy effect types
#define EFFECT_HEAL_BRUTE "heal_brute"
#define EFFECT_HEAL_BURN "heal_burn"
#define EFFECT_HEAL_TOX "heal_toxin"
#define EFFECT_RESTORE_STAMINA "restore_stamina"
#define EFFECT_RESTORE_ENERGY "restore_energy"
#define EFFECT_RESTORE_BLOOD "restore_blood"
#define EFFECT_FORTIFY_STRENGTH "fortify_strength"
#define EFFECT_FORTIFY_PERCEPTION "fortify_perception"
#define EFFECT_FORTIFY_INTELLIGENCE "fortify_intelligence"
#define EFFECT_FORTIFY_CONSTITUTION "fortify_constitution"
#define EFFECT_FORTIFY_ENDURANCE "fortify_endurance"
#define EFFECT_FORTIFY_SPEED "fortify_speed"
#define EFFECT_FORTIFY_LUCK "fortify_luck"
#define EFFECT_PARALYZE "paralyze"
#define EFFECT_BLINDNESS "blindness"
#define EFFECT_SILENCE "silence"
#define EFFECT_SLOW "slow"
#define EFFECT_WEAKNESS "weakness"
#define EFFECT_POISON "poison"
#define EFFECT_DAMAGE_STAMINA "damage_stamina"
#define EFFECT_DAMAGE_ENERGY "damage_energy"

// Global associative list mapping effects to their smells
GLOBAL_LIST_INIT(alchemy_effect_smells, list(
	EFFECT_HEAL_BRUTE = "wet moss",
	EFFECT_HEAL_BURN = "soothing balm",
	EFFECT_HEAL_TOX = "purity",
	EFFECT_RESTORE_STAMINA = "fresh air",
	EFFECT_RESTORE_ENERGY = "clean air",
	EFFECT_RESTORE_BLOOD = "iron and life",
	EFFECT_FORTIFY_STRENGTH = "power",
	EFFECT_FORTIFY_PERCEPTION = "sharp clarity",
	EFFECT_FORTIFY_INTELLIGENCE = "arcane essence",
	EFFECT_FORTIFY_CONSTITUTION = "mountain air",
	EFFECT_FORTIFY_ENDURANCE = "earth",
	EFFECT_FORTIFY_SPEED = "a swift breeze",
	EFFECT_FORTIFY_LUCK = "fortune",
	EFFECT_PARALYZE = "stagnant air",
	EFFECT_BLINDNESS = "darkness",
	EFFECT_SILENCE = "muffled void",
	EFFECT_SLOW = "thick molasses",
	EFFECT_WEAKNESS = "decay",
	EFFECT_POISON = "death",
	EFFECT_DAMAGE_STAMINA = "exhaustion",
	EFFECT_DAMAGE_ENERGY = "draining cold"
))

// Global associative list mapping effects to paired words [adjective, noun] for potion naming
GLOBAL_LIST_INIT(alchemy_effect_words, list(
	EFFECT_HEAL_BRUTE = list("mending", "heal"),
	EFFECT_HEAL_BURN = list("soothing", "balm"),
	EFFECT_HEAL_TOX = list("curing", "antidote"),
	EFFECT_RESTORE_STAMINA = list("energizing", "vigor"),
	EFFECT_RESTORE_ENERGY = list("invigorating", "essence"),
	EFFECT_RESTORE_BLOOD = list("vital", "fluid"),
	EFFECT_FORTIFY_STRENGTH = list("mighty", "power"),
	EFFECT_FORTIFY_PERCEPTION = list("keen", "sight"),
	EFFECT_FORTIFY_INTELLIGENCE = list("brilliant", "mind"),
	EFFECT_FORTIFY_CONSTITUTION = list("hardy", "body"),
	EFFECT_FORTIFY_ENDURANCE = list("enduring", "fortitude"),
	EFFECT_FORTIFY_SPEED = list("swift", "motion"),
	EFFECT_FORTIFY_LUCK = list("fortunate", "blessing"),
	EFFECT_PARALYZE = list("binding", "lock"),
	EFFECT_BLINDNESS = list("darkening", "shadow"),
	EFFECT_SILENCE = list("muting", "silence"),
	EFFECT_SLOW = list("sluggish", "draught"),
	EFFECT_WEAKNESS = list("enfeebling", "curse"),
	EFFECT_POISON = list("toxic", "venom"),
	EFFECT_DAMAGE_STAMINA = list("draining", "fatigue"),
	EFFECT_DAMAGE_ENERGY = list("exhausting", "drain")
))

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
	
	// 1 effect: use adjective + noun from that effect
	if(effects.len == 1)
		var/list/words = get_effect_words(effects[1])
		return "[words[1]] [words[2]]"
	
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
