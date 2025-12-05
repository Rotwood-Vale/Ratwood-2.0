// Witch Totem System Integration
// Checks if witch has totem and enough energy to cast

/obj/effect/proc_holder/spell/proc/witch_totem_check(mob/user)
	if(!ishuman(user) || !HAS_TRAIT(user, TRAIT_WITCH))
		return TRUE // Not a witch, no totem needed
	
	var/mob/living/carbon/human/H = user
	
	// Check if they have a totem in either hand
	var/obj/item/witch_totem/totem = locate(/obj/item/witch_totem) in list(H.get_active_held_item(), H.get_inactive_held_item())
	
	if(!totem)
		to_chat(user, span_warning("I need to hold my witch totem to channel this power!"))
		return FALSE
	
	// Check totem compatibility with spell type
	if(!miracle && (totem.totem_type == "divine"))
		to_chat(user, span_warning("My divine totem cannot channel arcane energies!"))
		return FALSE
	
	if(miracle && (totem.totem_type == "arcane"))
		to_chat(user, span_warning("My arcane totem cannot channel divine miracles!"))
		return FALSE
	
	// Calculate energy cost based on spell tier
	var/energy_cost = 10 // Default T1
	
	if(miracle)
		// For miracles, check cleric tier based on devotion cost
		if(devotion_cost >= 90) // T4 miracles
			energy_cost = 100
		else if(devotion_cost >= 80) // T3 miracles
			energy_cost = 50
		else if(devotion_cost >= 40) // T2 miracles
			energy_cost = 25
		else // T1 miracles
			energy_cost = 10
	else
		// For arcane spells, check user's arcane tier
		if(HAS_TRAIT(H, TRAIT_ARCYNE_T3))
			energy_cost = 50
		else if(HAS_TRAIT(H, TRAIT_ARCYNE_T2))
			energy_cost = 25
		else
			energy_cost = 10
	
	// Check if totem has enough energy
	if(totem.current_energy < energy_cost)
		to_chat(user, span_warning("My totem lacks the energy to cast this! ([totem.current_energy]/[energy_cost] needed)"))
		return FALSE
	
	return TRUE

// Hook into after_cast to consume totem energy
/obj/effect/proc_holder/spell/after_cast(list/targets, mob/user = usr)
	. = ..()
	
	// Consume totem energy for witches
	if(ishuman(user) && HAS_TRAIT(user, TRAIT_WITCH))
		var/mob/living/carbon/human/H = user
		var/obj/item/witch_totem/totem = locate(/obj/item/witch_totem) in list(H.get_active_held_item(), H.get_inactive_held_item())
		
		if(totem)
			// Calculate energy cost based on spell tier
			var/energy_cost = 10 // Default T1
			
			if(miracle)
				// For miracles, check cleric tier based on devotion cost
				if(devotion_cost >= 120) // T4 miracles
					energy_cost = 100
				else if(devotion_cost >= 80) // T3 miracles
					energy_cost = 50
				else if(devotion_cost >= 40) // T2 miracles
					energy_cost = 25
				else // T1 miracles
					energy_cost = 10
			else
				// For arcane spells, check user's arcane tier
				if(HAS_TRAIT(H, TRAIT_ARCYNE_T3))
					energy_cost = 50
				else if(HAS_TRAIT(H, TRAIT_ARCYNE_T2))
					energy_cost = 25
				else
					energy_cost = 10
			
			if(totem.consume_energy(energy_cost))
				to_chat(user, span_purple("My totem's energy: [totem.current_energy]/[totem.max_energy]"))
