/// Subtype more forgiving for items.
/// Careful, this can go wrong and keep a mob hyperfocused on an item it can't lose aggro on
/datum/targetting_datum/basic/allow_items
/datum/targetting_datum/basic/allow_items/can_attack(mob/living/living_mob, atom/the_target)
	. = ..()
	if(isitem(the_target))
		// trust fall exercise
		return TRUE

/// Subtype that ignores anything held inside, such as the consumed victim.
/// Going after somebody else.
/datum/targetting_datum/basic/allow_items/not_own_contents
/datum/targetting_datum/basic/allow_items/not_own_contents/can_attack(mob/living/living_mob, atom/the_target)
	if(the_target?.loc == living_mob)
		return FALSE
	return ..()
