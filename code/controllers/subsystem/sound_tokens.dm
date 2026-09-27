SUBSYSTEM_DEF(sound_tokens)
	name = "Sound Tokens"
	wait = 1
	flags = SS_TICKER | SS_BACKGROUND | SS_NO_INIT

	/// Clients whose tokens need repositioning. A mark is idempotent, so several steps or source moves
	/// in one tick refresh a client once
	var/list/clients_needing_update = list()
	var/list/currentrun = list()

/**
 * Registers movement tracking ONCE per listening mob, rather than once per token.
 *
 * A mob in a tavern with a band and a music box hears several tokens, and a handler per token
 * would run that many times a step to set the same single flag. The mob's own sound_tokens list
 * says when a token is its first or last.
 */
/datum/controller/subsystem/sound_tokens/proc/track_listener(mob/listener_mob)
	if(LAZYLEN(listener_mob.sound_tokens) > 1) // Already tracked by an earlier token
		return
	RegisterSignal(listener_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_listener_moved))

/datum/controller/subsystem/sound_tokens/proc/untrack_listener(mob/listener_mob)
	if(LAZYLEN(listener_mob.sound_tokens)) // Still hearing something else
		return
	UnregisterSignal(listener_mob, COMSIG_MOVABLE_MOVED)

/// A listening mob moved, so flag its client for one positional refresh of all its tokens
/datum/controller/subsystem/sound_tokens/proc/on_listener_moved(atom/movable/mover)
	SIGNAL_HANDLER
	var/mob/moved_mob = mover
	if(moved_mob.client)
		clients_needing_update[moved_mob.client] = TRUE

/**
 * Drains the clients marked for a positional refresh.
 *
 * No rate limit beyond the queue. A mark is idempotent and drained once per fire, so a client is
 * refreshed at most once a tick however fast it moves. A distance threshold would halve positional
 * fidelity and add a second queue flag that can suppress updates, so it waits on a profile.
 */
/datum/controller/subsystem/sound_tokens/fire(resumed)
	if(!resumed)
		currentrun = clients_needing_update
		clients_needing_update = list()
	while(length(currentrun))
		var/client/client = currentrun[currentrun.len]
		currentrun.len--
		// A client that disconnected after being marked leaves a null. TG has no such check, never
		// marking on listener movement
		if(!client)
			continue
		var/mob/owned_mob = client.mob
		if(!owned_mob)
			continue
		for(var/datum/sound_token/token as anything in owned_mob.sound_tokens)
			token.update_listener(owned_mob)
		if(MC_TICK_CHECK)
			break
