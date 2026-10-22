SUBSYSTEM_DEF(sound_tokens)
	name = "Sound Tokens"
	wait = 1
	flags = SS_TICKER | SS_BACKGROUND | SS_NO_INIT

	/// Clients whose tokens need repositioning. A mark is idempotent, so several steps or source moves
	/// in one tick refresh a client once
	var/list/clients_needing_update = list()
	var/list/currentrun = list()

/**
 * Restores movement tracking for token listeners after subsystem recovery.
 *
 * Tokens and mob.sound_tokens survive the old subsystem, but its signal registrations do not.
 * Re-register each listener and queue a positional refresh.
 */
/datum/controller/subsystem/sound_tokens/Recover()
	for(var/client/listener_client as anything in GLOB.clients)
		var/mob/listener_mob = listener_client?.mob
		if(!LAZYLEN(listener_mob?.sound_tokens))
			continue
		RegisterSignal(listener_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_listener_moved))
		clients_needing_update[listener_client] = TRUE

/**
 * Registers movement tracking when a mob receives its first sound token.
 *
 * One handler queues all of the mob's tokens, avoiding a separate movement handler for each token.
 */
/datum/controller/subsystem/sound_tokens/proc/track_listener(mob/listener_mob)
	if(LAZYLEN(listener_mob.sound_tokens) > 1)
		return
	RegisterSignal(listener_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_listener_moved))

/datum/controller/subsystem/sound_tokens/proc/untrack_listener(mob/listener_mob)
	if(LAZYLEN(listener_mob.sound_tokens))
		return
	UnregisterSignal(listener_mob, COMSIG_MOVABLE_MOVED)

/// Queues a positional refresh of the moving listener's tokens
/datum/controller/subsystem/sound_tokens/proc/on_listener_moved(atom/movable/mover)
	SIGNAL_HANDLER
	var/mob/moved_mob = mover
	if(moved_mob.client)
		clients_needing_update[moved_mob.client] = TRUE

/**
 * Refreshes every token heard by clients in the movement queue.
 *
 * Repeated marks are coalesced until the subsystem drains the queue.
 */
/datum/controller/subsystem/sound_tokens/fire(resumed)
	if(!resumed)
		currentrun = clients_needing_update
		clients_needing_update = list()
	while(length(currentrun))
		var/client/client = currentrun[currentrun.len]
		currentrun.len--
		// A client may disconnect after being queued
		if(!client)
			continue
		var/mob/owned_mob = client.mob
		if(!owned_mob)
			continue
		for(var/datum/sound_token/token as anything in owned_mob.sound_tokens)
			token.update_listener(owned_mob)
		if(MC_TICK_CHECK)
			break
