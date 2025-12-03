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

// Datum to hold reagent alchemy effects
/datum/reagent_alchemy_effects
	var/list/effects = list()  // List of effect strings
	
/datum/reagent_alchemy_effects/New(list/effect_list)
	. = ..()
	if(effect_list)
		effects = effect_list.Copy()

// Add alchemy effects variable to all reagents
/datum/reagent
	var/datum/reagent_alchemy_effects/alchemy_effects = null

// Helper proc to add alchemy effects to a reagent
/datum/reagent/proc/set_alchemy_effects(list/effect_list)
	alchemy_effects = new /datum/reagent_alchemy_effects(effect_list)
	return alchemy_effects

// Proc to get common effects between two reagents
/proc/get_common_alchemy_effects(datum/reagent/R1, datum/reagent/R2)
	if(!R1?.alchemy_effects || !R2?.alchemy_effects)
		return list()
	
	var/list/common = list()
	for(var/effect in R1.alchemy_effects.effects)
		if(effect in R2.alchemy_effects.effects)
			common += effect
	
	return common

// Proc to create a potion based on common effects
/proc/create_potion_from_effects(list/effects)
	if(!effects || !effects.len)
		return null
	
	// Sort effects to ensure consistent potion type
	sortTim(effects, /proc/cmp_text_asc)
	
	// Determine potion type based on primary effect
	var/primary_effect = effects[1]
	
	switch(primary_effect)
		if(EFFECT_HEAL_BRUTE)
			return /datum/reagent/medicine/healthpot
		if(EFFECT_HEAL_BURN)
			return /datum/reagent/medicine/healthpot
		if(EFFECT_HEAL_TOX)
			return /datum/reagent/medicine/antidote
		if(EFFECT_RESTORE_STAMINA)
			return /datum/reagent/medicine/stampot
		if(EFFECT_RESTORE_ENERGY)
			return /datum/reagent/medicine/manapot
		if(EFFECT_FORTIFY_STRENGTH)
			return /datum/reagent/buff/strength
		if(EFFECT_FORTIFY_PERCEPTION)
			return /datum/reagent/buff/perception
		if(EFFECT_FORTIFY_INTELLIGENCE)
			return /datum/reagent/buff/intelligence
		if(EFFECT_FORTIFY_CONSTITUTION)
			return /datum/reagent/buff/constitution
		if(EFFECT_FORTIFY_ENDURANCE)
			return /datum/reagent/buff/endurance
		if(EFFECT_FORTIFY_SPEED)
			return /datum/reagent/buff/speed
		if(EFFECT_FORTIFY_LUCK)
			return /datum/reagent/buff/fortune
		if(EFFECT_PARALYZE)
			return /datum/reagent/toxin/zombiepowder  // Placeholder
		if(EFFECT_POISON)
			return /datum/reagent/berrypoison
		if(EFFECT_DAMAGE_STAMINA)
			return /datum/reagent/stampoison
	
	// Default to a basic health potion if no specific match
	return /datum/reagent/medicine/healthpot

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
		if(!R1.alchemy_effects)
			continue
			
		for(var/j = i+1 to reagent_list.len)
			var/datum/reagent/R2 = reagent_list[j]
			if(!R2.alchemy_effects)
				continue
			
			// Get common effects
			var/list/common = get_common_alchemy_effects(R1, R2)
			if(!common || !common.len)
				continue
			
			// Found a match! Create potion
			var/potion_type = create_potion_from_effects(common)
			if(!potion_type)
				continue
			
			// Calculate amount to convert (minimum of the two reagents)
			var/convert_amount = min(R1.volume, R2.volume)
			convert_amount = min(convert_amount, 30)  // Max 30 units per mix
			
			// Remove source reagents
			remove_reagent(R1.type, convert_amount)
			remove_reagent(R2.type, convert_amount)
			
			// Add potion (2 reagents → 1 potion, so half the amount)
			add_reagent(potion_type, convert_amount * 0.5)
			
			// Notify
			if(istype(my_atom, /obj/item/reagent_containers))
				my_atom.visible_message("<span class='notice'>[my_atom] bubbles as the reagents combine into a potion!</span>")
			
			return TRUE
	
	return FALSE
