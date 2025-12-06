// Witch Totem System Integration
// Checks if witch has totem and enough energy to cast

/obj/effect/proc_holder/spell/proc/witch_totem_check(mob/user)
	if(!ishuman(user))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_SHAMAN))
		to_chat(user, span_warning("Only those who walk the shaman’s path may bind a totem."))
		return FALSE
    
	var/mob/living/carbon/human/H = user
    
	// Find a totem either worn or held
	var/obj/item/witch_totem/totem = locate(/obj/item/witch_totem) in H.contents
    
	if(!totem)
		to_chat(user, span_warning("I need to hold or wear my totem to channel this power!"))
		return FALSE
    
	// Percentage-based casting: always allow casting if totem exists.
	// Actual energy check and penalties are handled in after_cast.
	return TRUE

// Hook into after_cast to consume totem energy
/obj/effect/proc_holder/spell/after_cast(list/targets, mob/user = usr)
	. = ..()
    
	// Shamans only: consume totem energy after cast
	if(ishuman(user) && HAS_TRAIT(user, TRAIT_SHAMAN))
		var/mob/living/carbon/human/H = user
		// Find a totem either worn or held
		var/obj/item/witch_totem/totem = locate(/obj/item/witch_totem) in H.contents
        
		if(totem)
			// Determine required percentage based on spell tier
			var/required_pct = 10 // Default T1 = 10%
			if(miracle)
				if(devotion_cost >= 120) // T4 miracles
					required_pct = 100
				else if(devotion_cost >= 80) // T3 miracles
					required_pct = 50
				else if(devotion_cost >= 40) // T2 miracles
					required_pct = 25
				else
					required_pct = 10
			else
				if(HAS_TRAIT(H, TRAIT_ARCYNE_T3))
					required_pct = 50
				else if(HAS_TRAIT(H, TRAIT_ARCYNE_T2))
					required_pct = 25
				else
					required_pct = 10

			// Apply 50% discount when held
			var/held_totem = (H.get_active_held_item() == totem || H.get_inactive_held_item() == totem)
			if(held_totem && HAS_TRAIT(H, TRAIT_SHAMAN))
				required_pct = max(5, round(required_pct * 0.5))
				to_chat(user, span_green("The spirits favor my grip."))

			// Current percentage available
			var/current_pct = 0
			if(totem.max_energy > 0)
				current_pct = round((totem.current_energy / totem.max_energy) * 100)

			// Consume energy based on percentage requirement
			var/required_units = round(totem.max_energy * (required_pct / 100))
			var/consumed = FALSE
			if(totem.current_energy >= required_units)
				consumed = totem.consume_energy(required_units)
			else
				// Not enough energy; consume what remains (optional minimal drain)
				if(totem.current_energy > 0)
					consumed = totem.consume_energy(totem.current_energy)

			if(consumed)
				to_chat(user, span_purple("Totem energy [totem.current_energy]/[totem.max_energy]"))

			// Backup pool usage and peril when casting with insufficient percentage
			if(current_pct < required_pct)
				var/missing_pct = max(0, required_pct - current_pct)
				// Drain backup resource depending on spell type
				if(miracle && H.devotion)
					// Map percent to devotion points: 10% => 1 devotion, then 4x
					var/devotion_drain = round((missing_pct / 10)) * 4
					H.devotion.update_devotion(-devotion_drain)
				else
					// Non-miracle: drain personal energy proportionally to missing percent
					H.energy_add(-round(H.max_energy * (missing_pct / 100)))

				// Initialize peril tracking vars on the mob if absent
				if(!isnum(H.vars["witch_peril_stack"]))
					H.vars["witch_peril_stack"] = 0
				if(!isnum(H.vars["witch_last_cast_time"]))
					H.vars["witch_last_cast_time"] = world.time

				// Increase peril when casting in quick succession (within 10 seconds), else decay
				var/last_cast = H.vars["witch_last_cast_time"]
				if(world.time - last_cast <= (10 SECONDS))
					H.vars["witch_peril_stack"] = min(H.vars["witch_peril_stack"] + 1, 10)
				else
					H.vars["witch_peril_stack"] = max(H.vars["witch_peril_stack"] - 1, 0)
				H.vars["witch_last_cast_time"] = world.time

				// Only apply heavier strain if backup pools are depleted
				var/backup_depleted = FALSE
				if(miracle && H.devotion)
					backup_depleted = (H.devotion.devotion <= 0)
				else
					backup_depleted = (H.energy <= 0)

				if(backup_depleted)
					var/peril = clamp(H.vars["witch_peril_stack"], 0, 10)
					// Progressive, exponential energy strain and sensory effects
					var/base = 20
					var/mult = 1.35
					var/severity = round(base * (mult ** peril))
					H.energy_add(-severity)
					H.blur_eyes(2 + round(peril * 0.3))
					H.Dizzy(4 + round(peril * 0.5))
					to_chat(user, span_warning("Peril swells within — my focus frays. ([peril])"))

				// Roleplay-friendly mild strain when under-required regardless of depletion
				var/strain = 50
				H.energy_add(-strain)
				H.blur_eyes(2)
				H.Dizzy(3)
				to_chat(H, span_warning("Arcyne strain seizes my senses as the totem falters!"))

				// Low-noise peril announcements at thresholds
				if(!isnum(H.vars["witch_peril_last_announce"]))
					H.vars["witch_peril_last_announce"] = -1
				var/peril_now = clamp(H.vars["witch_peril_stack"], 0, 10)
				var/announce_level = -1
				if(peril_now >= 8)
					announce_level = 8
				else if(peril_now >= 5)
					announce_level = 5
				else if(peril_now >= 2)
					announce_level = 2
				if(announce_level != -1 && H.vars["witch_peril_last_announce"] != announce_level)
					H.vars["witch_peril_last_announce"] = announce_level
					to_chat(H, span_purple("A warning chill crawls up my spine. Peril: [peril_now]/10"))
