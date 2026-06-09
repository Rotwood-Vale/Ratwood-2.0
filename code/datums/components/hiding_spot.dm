/*!
 * Component you can add to anything that allows people to hide inside of it
 */

/datum/component/hiding_spot
	/// Reference to whatever is hiding inside parent
	var/datum/weakref/hider
	/// Message you get when the spot is occupied
	var/occupied_message = "Someone is already hiding in %LOCATION!"
	/// Message you get when you hide inside
	var/hide_message = "I hide in %LOCATION!"
	/// Message you get when you unhide from
	var/unhide_message = "I come out from %LOCATION!"

/*
 * Component Arguments:

 * occupied_message: Message you get when you try to hide but the spot is taken
 * hide_message: Message you get when you manage to hide inside the spot
 * unhide_message: Message you get when you unhide from the spot
 */

/datum/component/hiding_spot/Initialize(occupied_message, hide_message, unhide_message)
	if(!isatom(parent))
		return COMPONENT_INCOMPATIBLE
	src.occupied_message = replacetext(occupied_message, "%LOCATION", "[parent]")
	src.hide_message = replacetext(hide_message, "%LOCATION", "[parent]")
	src.unhide_message = replacetext(unhide_message, "%LOCATION", "[parent]")

/datum/component/hiding_spot/RegisterWithParent()
	RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(on_parent_delete))
	RegisterSignal(parent, COMSIG_ATOM_RELAYMOVE, PROC_REF(hider_moved))
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_attack_hand))
	RegisterSignal(parent, COMSIG_PARENT_EXAMINE, PROC_REF(on_parent_examine))
	RegisterSignal(parent, COMSIG_LOOK_AROUND_SPOTTED, PROC_REF(on_spotted))

/datum/component/hiding_spot/UnregisterFromParent()
	// Just in case, let's double check
	if(!QDELETED(hider))
		escape_hidingspot(hider.resolve())

	UnregisterSignal(parent, list(COMSIG_QDELETING, COMSIG_ATOM_RELAYMOVE, COMSIG_ATOM_ATTACK_HAND, COMSIG_PARENT_EXAMINE, COMSIG_LOOK_AROUND_SPOTTED))

/// Kicks out the occupant if the thing we are hiding inside is ever deleted
/datum/component/hiding_spot/proc/on_parent_delete()
	SIGNAL_HANDLER
	var/mob/living/hiding_mob = hider.resolve()
	if(!hiding_mob)
		return
	escape_hidingspot(hiding_mob)

/// Hides the occupant inside of parent if they click on sneak intent
/datum/component/hiding_spot/proc/on_attack_hand(datum/source, mob/living/user)
	if(!isliving(user))
		return // No ghosts
	var/mob/living/potential_hider = user

	if(potential_hider.loc == parent) // If the hider clicks the spot, they get out
		escape_hidingspot(potential_hider)
		return

	if(potential_hider.m_intent != MOVE_INTENT_SNEAK)
		return

	if(locate(/obj/structure/bars) in get_turf(parent))
		to_chat(potential_hider, span_warning("This hiding spot is blocked!"))
		return

	if(!QDELETED(hider))
		to_chat(potential_hider, span_warning(occupied_message))
		return

	var/sneak_level = potential_hider.get_skill_level(/datum/skill/misc/sneaking) || 0
	var/sneaktime = max(1 SECONDS, 5 SECONDS - (sneak_level SECONDS)) // Hard caps at 1 second at Expert and above.

	if(!do_after(potential_hider, sneaktime, target = parent))
		return

	potential_hider.forceMove(parent)
	to_chat(potential_hider, span_warning(hide_message))
	hider = WEAKREF(potential_hider)
	return COMPONENT_NO_ATTACK_HAND

/// Kicks out the occupant, nulls out the reference so someone else can hide inside
/datum/component/hiding_spot/proc/escape_hidingspot(mob/living/user)
	var/turf/exit_turf = get_turf(parent)
	if(!exit_turf)
		return
	user.forceMove(exit_turf)
	to_chat(user, span_warning(unhide_message))
	hider = null

/// If the hider moves while inside the hiding spot, let them out
/datum/component/hiding_spot/proc/hider_moved(datum/source, mob/living/user)
	SIGNAL_HANDLER
	if(user != hider.resolve())
		return
	escape_hidingspot(user)
	return COMSIG_BLOCK_RELAYMOVE

/// Adds text to the parent that this can be used as a hiding place
/datum/component/hiding_spot/proc/on_parent_examine(datum/source, mob/user, list/examine_list)
	SIGNAL_HANDLER
	if(!isliving(user)) // stinky ghosts
		return

	if(!in_range(user, parent))
		return

	if(QDELETED(hider))
		examine_list += span_notice(\
			"Some structures can be used as hiding places. \
			Toggle the 'SNEAK' button on your HUD, then click the structure to hide in it. \
			You can stop hiding by clicking the structure again, or by moving out of it.")
		return

	var/mob/living/found_mob = hider.resolve()
	escape_hidingspot(found_mob)

/// Reveals that this spot is being used to hide in when someone nearby looks around
/datum/component/hiding_spot/proc/on_spotted(datum/source, mob/living/looker)
	SIGNAL_HANDLER
	if(QDELETED(hider) || !isliving(looker))
		return
	var/mob/living/hiding_mob = hider.resolve()
	var/sneak_amount = 8 + (hiding_mob.get_skill_level(/datum/skill/misc/sneaking) * 2)
	if(looker.STAPER >= sneak_amount) // skewed towards the hiding player because there's already a separate, guaranteed way to find hiders.
		found_ping(get_turf(parent), looker.client, "hidden")
