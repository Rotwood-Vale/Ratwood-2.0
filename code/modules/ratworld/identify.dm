// Ratworld identification system: undiscovered items and Book of Identification

// Identify an item: reveal and/or roll its enchantments and apply effects
/proc/ratworld_identify_item(obj/item/I, mob/living/user)
	if(!I) return FALSE
	if(I.vars && ("rw_discovered" in I.vars) && I.vars["rw_discovered"]) 
		if(user) to_chat(user, span_notice("[I] has already been identified."))
		return FALSE
	// Mark discovered
	I.vars["rw_discovered"] = TRUE
	// Play discovery sound
	if(user)
		playsound(get_turf(user), 'sound/ratworld/discover.ogg', 80, FALSE)
	// Ensure rarity exists (fallback to 1 if defines aren't available in this unit)
	var/r = I.vars?["rw_rarity"]
	if(!isnum(r)) r = 1
	// Determine slot key for this item
	var/slot_key = ratworld_slot_key_for_item(I)
	// If flagged to roll on discovery or no enchants present, roll fresh
	var/should_roll = I.vars?["rw_roll_on_discover"]
	var/list/ids = I.vars?["rw_enchants"]
	if(should_roll || !islist(ids) || !ids.len)
		var/count = get_ratworld_rarity_slot_count(r)
		// Ensure undiscovered items actually get at least one enchant
		if(count <= 0) count = 1
		ids = ratworld_roll_enchant_ids_for_slot(count, slot_key)
		// Fallback: if no slot-eligible enchants found, try general roll
		if(!islist(ids) || !ids.len)
			ids = ratworld_roll_enchant_ids(count)
		I.vars["rw_enchants"] = ids
		I.vars["rw_enchant_vals"] = list()
		var/list/counts = list()
		for(var/id in ids)
			if(!istext(id)) continue
			// Use the identifier's luck (if any) when rolling enchant values
			var/list/rv = ratworld_roll_enchant_value_for_slot(id, slot_key, user)
			if(!islist(rv)) continue
			var/val = rv["value"]
			if(!isnum(val)) continue
			// Sum duplicate rolls into a single entry
			if(isnum(I.vars["rw_enchant_vals"][id]))
				I.vars["rw_enchant_vals"][id] += val
			else
				I.vars["rw_enchant_vals"][id] = val
			counts[id] = (isnum(counts[id]) ? counts[id] + 1 : 1)
		// Roll semi-rare +STAT on discovery too
		ratworld_maybe_roll_item_stat_bonus(I)
		// Assign special attributes and unique naming for high rarities
		if(r >= RW_RARITY_ARTIFACT || r == RW_RARITY_ASCENDANT)
			// Guaranteed special
			ratworld_assign_special_attribute(I)
			// Unique-style name
			var/n = ratworld_generate_unique_name(I)
			if(istext(n)) I.name = n
		else if(r == RW_RARITY_UNIQUE)
			if(prob(20)) ratworld_assign_special_attribute(I)
			var/n2 = ratworld_generate_unique_name(I)
			if(istext(n2)) I.name = n2
		// Clear the flag now that we've rolled
		if(I.vars?["rw_roll_on_discover"]) I.vars["rw_roll_on_discover"] = FALSE
	// Apply item-side persistent effects/components only; wearer effects will apply on subsequent equip/hold events.
	ratworld_apply_enchantments(I)
	// If already equipped/held and now discovered, attempt conditional apply (will self-qualify in ratworld_apply_wearer_effects).
	if(isliving(I.loc))
		var/mob/living/holder = I.loc
		ratworld_apply_wearer_effects(I, holder)
	if(user)
		to_chat(user, span_notice("You identify [I]. Its properties are now revealed."))
	return TRUE

// Simple book that can identify items when used on them
/obj/item/book/ratworld_identification
	name = "Book of Identification"
	desc = "Reveals the hidden properties of items. Use it on an undiscovered item."
	icon = 'icons/roguetown/items/books.dmi'
	icon_state = "spellbookgem_0"

/obj/item/book/ratworld_identification/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity) return
	if(!istype(target, /obj/item))
		to_chat(user, span_warning("You must use this on an item."))
		return
	var/obj/item/I = target
	if(I.vars && ("rw_discovered" in I.vars) && I.vars["rw_discovered"])
		to_chat(user, span_notice("[I] is already identified."))
		return
	if(ratworld_identify_item(I, user))
		// Book has unlimited uses; do not consume
		return
	to_chat(user, span_warning("Nothing happens."))

// One-time-use Scroll of Identification
/obj/item/paper/scroll/ratworld_identification
	name = "Scroll of Identification"
	desc = "A single-use scroll that reveals the hidden properties of an item."

/obj/item/paper/scroll/ratworld_identification/afterattack(atom/target, mob/user, proximity)
	. = ..()
	if(!proximity) return
	if(!istype(target, /obj/item))
		to_chat(user, span_warning("You must use this on an item."))
		return
	var/obj/item/I = target
	if(I.vars && ("rw_discovered" in I.vars) && I.vars["rw_discovered"]) 
		to_chat(user, span_notice("[I] is already identified."))
		return
	if(ratworld_identify_item(I, user))
		qdel(src)
		return
	to_chat(user, span_warning("Nothing happens."))
