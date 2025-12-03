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

// Helper proc to get smell description for an effect
/proc/get_effect_smell(effect)
	return GLOB.alchemy_effect_smells[effect] || "strange essence"

// Add alchemy effects variable to all reagents (simple list, no datum wrapper)
/datum/reagent
	var/list/alchemy_effects = null

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
			
			// Check if both reagents are from the same source herb - if so, skip
			if(istype(R1, /datum/reagent/herb_extract) && istype(R2, /datum/reagent/herb_extract))
				var/datum/reagent/herb_extract/E1 = R1
				var/datum/reagent/herb_extract/E2 = R2
				if(E1.source_herb_name && E2.source_herb_name && E1.source_herb_name == E2.source_herb_name)
					continue  // Same herb source, don't mix
			
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
			mixed.source_herb_name = "mixed"  // Mark as mixed so it can't be mixed with itself
			mixed.name = "alchemical potion"
			mixed.description = "A potion created by mixing reagents with common alchemical properties."
			
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
