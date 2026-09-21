/*
 * Click targeting for mutant abilities a player is driving.
 *
 * The AI calls PreActivate(target) itself, so it never needs any of this. A
 * player only ever gets Trigger() with no target, and the base falls back to
 * PreActivate(owner) - which is why Charge reported "to close" and the two
 * grabs looked for a victim standing on the mutant's own tile.
 *
 * check_click_intercept() calls InterceptClickOn() on whatever is set as the
 * intercept, so an action can serve as its own the same way proc_holder spells
 * do. Only the abilities that actually want a target opt in.
 */

/datum/action/cooldown/mob_cooldown
	/// Whether a player triggering this arms a click rather than firing at once.
	var/player_targeted = FALSE
	/// Set while waiting for that click.
	var/aiming = FALSE

/datum/action/cooldown/mob_cooldown/Trigger(trigger_flags, atom/target)
	// A target means the AI, or a click that already came back to us.
	if(target || !player_targeted || !owner?.client)
		return ..()

	if(!IsAvailable())
		return FALSE

	// Pressing it again while armed is the cancel.
	if(aiming)
		stop_aiming()
		return FALSE

	start_aiming()
	return TRUE

/datum/action/cooldown/mob_cooldown/proc/start_aiming()
	aiming = TRUE
	owner.click_intercept = src
	to_chat(owner, span_notice("Pick a target for [name]. Press it again to stop."))

/datum/action/cooldown/mob_cooldown/proc/stop_aiming()
	aiming = FALSE
	if(owner?.click_intercept == src)
		owner.click_intercept = null

/datum/action/cooldown/mob_cooldown/InterceptClickOn(mob/user, params, atom/clicked)
	stop_aiming()
	// TRUE either way: the click was spent aiming and must not also swing.
	if(!IsAvailable() || !clicked || clicked == owner)
		return TRUE
	PreActivate(clicked)
	return TRUE

/datum/action/cooldown/mob_cooldown/Remove(mob/removed_from)
	stop_aiming()
	return ..()
