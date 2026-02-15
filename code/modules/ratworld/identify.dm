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
	// Random rolling on identify has been disabled. Identification simply
	// reveals existing `rw_enchants`/`rw_enchant_vals` stored on the item.
	var/list/ids = I.vars?["rw_enchants"]
	if(!islist(ids))
		I.vars["rw_enchants"] = list()
	if(!islist(I.vars?["rw_enchant_vals"]))
		I.vars["rw_enchant_vals"] = list()
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
