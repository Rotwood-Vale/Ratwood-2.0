// Witch Totem System Integration
// Checks if witch has totem and enough energy to cast

/obj/effect/proc_holder/spell/proc/witch_totem_check(mob/user)
	if(!ishuman(user) || !HAS_TRAIT(user, TRAIT_WITCH))
		return TRUE // Not a witch, no totem needed
	
	var/mob/living/carbon/human/H = user
	
	// Check if they have a totem equipped anywhere
	var/obj/item/witch_totem/totem = locate(/obj/item/witch_totem) in H.get_equipped_items()
	
	if(!totem)
		to_chat(user, span_warning("I need to have my witch totem equipped to channel this power!"))
		return FALSE

	
	// Calculate base energy cost based on spell tier
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
	
	// Apply 50% discount if totem is held in hands
	var/held_totem = (H.get_active_held_item() == totem || H.get_inactive_held_item() == totem)
	if(held_totem)
		energy_cost = round(energy_cost * 0.5)
	
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
		var/obj/item/witch_totem/totem = locate(/obj/item/witch_totem) in H.get_equipped_items()
		
		if(totem)
			// Calculate base energy cost based on spell tier
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
			
			// Apply 50% discount if totem is held in hands
			var/held_totem = (H.get_active_held_item() == totem || H.get_inactive_held_item() == totem)
			if(held_totem)
				energy_cost = round(energy_cost * 0.5)
				to_chat(user, span_green("Holding my totem reduces the energy cost!"))
			
			if(totem.consume_energy(energy_cost))
				to_chat(user, span_purple("My totem's energy: [totem.current_energy]/[totem.max_energy]"))
