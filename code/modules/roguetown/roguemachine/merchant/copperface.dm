/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////

// DESIGN NOTE
// The copperface exists [Somewhere when it is actually mapped in]
// Prices are steeper to not necessarily give the merchant in town competition.
// The intended customers are wretches, bandits and other outlaws.
// This provides especially wretches reasons to harrass adventurers and get vital items they usually can't out of town like lockpicks, red or prosthetics

/obj/structure/roguemachine/goldface/copperface
	name = "COPPERFACE"
	desc = "Never gets tired, does not ask questions, only minor signs of tampering. Alas, fashioned with copper of low quality."
	motto = "COPPERFACE - Everyone has a price."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "copperface"
	lockid = null // Not lockable
	locked = FALSE
	max_integrity = 0 // Screw you, gamer
	profit_id = null // No one can withdraw profit from copperface
	value_record_key = STATS_COPPERFACE_VALUE_SPENT
	categories = list(
		"Diplomacy and Persuasion",
		"Beverages",
		"Exotic Import",
		"General Labour",
		"Health and Hygiene",
		"Self Defense",
	)
	categories_gamer = list()
	bypass_tax = TRUE
	extra_fee = 0.5 // 50% extra fee.

/obj/structure/roguemachine/goldface/crimsonface
	name = "CRIMSONFACE"
	desc = "An independent crimson vendor. It serves only recognized freeholders."
	motto = "CRIMSONFACE - No Gods or Kings, Only Man."
	icon = 'icons/roguetown/misc/machines.dmi'
	icon_state = "streetvendor1"
	lockid = null
	locked = FALSE
	max_integrity = 0
	profit_id = null
	bypass_tax = TRUE
	extra_fee = 0
	is_public = FALSE
	categories = list(
		"Alcohols",
		"Food",
		"Substances",
		"Gems",
		"Luxury",
		"Cosmetics",
		"Instruments",
		"Magic",
		"Livestock",
		"Raw Materials",
		"Seeds",
		"Tools",
		"Apparel",
		"Wardrobe",
	)
	categories_gamer = list(
		"Adventuring Supplies",
		"Armor (Light)",
		"Armor (Iron)",
		"Armor (Steel)",
		"Armor (Exotic)",
		"Potions",
		"Weapons (Ranged)",
		"Weapons (Iron and Shields)",
		"Weapons (Steel)",
		"Weapons (Exotic)",
	)

/obj/structure/roguemachine/goldface/crimsonface/proc/can_use_crimsonface(mob/living/user)
	if(!ishuman(user))
		return FALSE
	if(!HAS_TRAIT(user, TRAIT_FREEHOLDER))
		to_chat(user, span_warning("CRIMSONFACE does not respond. It serves only freeholders."))
		return FALSE
	return TRUE

/obj/structure/roguemachine/goldface/crimsonface/attack_hand(mob/living/user)
	if(!can_use_crimsonface(user))
		return
	return ..()

/obj/structure/roguemachine/goldface/crimsonface/Topic(href, href_list)
	if(!can_use_crimsonface(usr))
		return
	return ..()
