SUBSYSTEM_DEF(sound_tokens)
	name = "Sound Tokens"
	wait = 1
	flags = SS_TICKER | SS_BACKGROUND | SS_NO_INIT

	/// Clients whose mobs need every one of their sound tokens repositioned, batched
	/// per tick so a mob crossing ten tokens' ranges costs one update, not ten.
	var/list/clients_needing_update = list()
	var/list/currentrun = list()

/**
 * Movement tracking is registered ONCE per listening mob, by the subsystem, rather than once
 * per token. A mob standing in a tavern with a band and a music box hears several tokens, and
 * registering per token meant every step ran that many handlers to set the same single flag.
 * The mob's own sound_tokens list tells us when it becomes the first or last one.
 */
/datum/controller/subsystem/sound_tokens/proc/track_listener(mob/listener_mob)
	if(LAZYLEN(listener_mob.sound_tokens) > 1) // already tracked by an earlier token
		return
	RegisterSignal(listener_mob, COMSIG_MOVABLE_MOVED, PROC_REF(on_listener_moved))

/datum/controller/subsystem/sound_tokens/proc/untrack_listener(mob/listener_mob)
	if(LAZYLEN(listener_mob.sound_tokens)) // still hearing something else
		return
	UnregisterSignal(listener_mob, COMSIG_MOVABLE_MOVED)

/// A listening mob moved; flag its client for one positional refresh of all its tokens.
/datum/controller/subsystem/sound_tokens/proc/on_listener_moved(atom/movable/mover)
	SIGNAL_HANDLER
	var/mob/moved_mob = mover
	if(moved_mob.client)
		clients_needing_update[moved_mob.client] = TRUE

/datum/controller/subsystem/sound_tokens/fire(resumed)
	if(!resumed)
		currentrun = clients_needing_update
		clients_needing_update = list()
	// No rate limiting here on purpose. The queue is an idempotent mark drained once per
	// fire, so a client already cannot be refreshed more than once a tick however fast it
	// moves, so the ceiling is structural. A distance threshold on top of that bought about 2%
	// of what deleting SSsoundloopers already saved, in exchange for halving positional
	// fidelity and a two-tier queue flag that could silently suppress updates. Not worth it
	// without a profile saying otherwise.
	while(length(currentrun))
		var/client/client = currentrun[currentrun.len]
		currentrun.len--
		// A client that disconnected between being queued and this fire leaves a null here.
		// Upstream reads client.mob unguarded and gets away with it because it only queues on
		// source movement; we also queue on listener movement, so the window is much wider.
		if(!client)
			continue
		var/mob/owned_mob = client.mob
		if(!owned_mob)
			continue
		for(var/datum/sound_token/token as anything in owned_mob.sound_tokens)
			token.update_listener(owned_mob)
		if(MC_TICK_CHECK)
			break
