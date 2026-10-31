/**
 * Registers login signals and initializes movement hooks for connected clients.
 *
 * Observers and muted listeners remain unhooked. The standing sweep handles stationary listeners
 * and changes that movement alone cannot detect.
 */
/datum/controller/subsystem/point_ambience/proc/hook_logins()
	PRIVATE_PROC(TRUE)
	hooked_logins = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGIN, PROC_REF(player_login))
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGOUT, PROC_REF(player_logout))
	for(var/client/listener_client as anything in GLOB.clients)
		if(listener_client.mob)
			player_login(null, listener_client.mob)

/// Refreshes a client's ambience hooks after login or a mob change. Observers stop playback and
/// release head tracking
/datum/controller/subsystem/point_ambience/proc/player_login(datum/source, mob/player)
	SIGNAL_HANDLER
	if(isobserver(player))
		stop_all_for(player.client)
		qdel(player.client?.point_ambience?.head_watch)
		return
	if(player.client)
		player.client.point_ambience.last_move = null
		player.client.point_ambience.speed_moved = null
		player.client.point_ambience.speed_silenced = FALSE
		update_silenced(player.client)

/datum/controller/subsystem/point_ambience/proc/player_logout(datum/source, mob/player)
	SIGNAL_HANDLER
	UnregisterSignal(player, list(COMSIG_MOVABLE_MOVED, COMSIG_SPECIES_GAIN, COMSIG_SPECIES_LOSS))
	// dirty_clients is left alone: a client that merely changed mobs is still owed a service, and
	// one that truly left leaves a null key for drain_dirty() to drop

/// Rebuilds the category bitmask used to check whether a listener has any enabled ambience
/datum/controller/subsystem/point_ambience/proc/refresh_audible_mask()
	PRIVATE_PROC(TRUE)
	audible_mask = 0
	for(var/datum/point_ambience_category/category as anything in categories)
		if(!category.silenced)
			audible_mask |= category.mask

/// Converts per-category preferences into the bitmask used during servicing
/datum/controller/subsystem/point_ambience/proc/muted_mask_for(datum/preferences/prefs)
	PRIVATE_PROC(TRUE)
	. = 0
	if(!prefs)
		return
	for(var/datum/point_ambience_category/category as anything in categories)
		if(category.muted_for(prefs))
			. |= category.mask

/**
 * Whether a listener's preferences leave them nothing to hear.
 *
 * The listener is muted when point ambience is off, POINT_AMBIENCE_VOLUME is zero,
 * loudest_volume scaled by their effective volume falls below send_cutoff even at distance zero,
 * or muted_mask covers audible_mask.
 * muted_by() makes that one decision for the move hook. prepare_serving() checks zero volume
 * again before sending. A listener without preferences is served at the default scale
 *
 * Arguments:
 * * muted_mask - muted_mask_for(prefs), passed by a caller that already has it
 */
/datum/controller/subsystem/point_ambience/proc/muted_by(datum/preferences/prefs, muted_mask = null)
	PRIVATE_PROC(TRUE)
	if(!prefs)
		return FALSE
	if(prefs.point_ambience_toggles & SOUND_DISABLE_POINT_AMBIENCE)
		return TRUE
	var/effective_volume = POINT_AMBIENCE_VOLUME(prefs)
	if(!effective_volume)
		return TRUE
	// The cutoff comparison is strict: a source exactly at send_cutoff may still play
	if(send_cutoff && loudest_volume * effective_volume * 0.01 < send_cutoff)
		return TRUE
	if(isnull(muted_mask))
		muted_mask = muted_mask_for(prefs)
	return (muted_mask & audible_mask) == audible_mask

/**
 * Recomputes overall and per-category mute state, then updates the movement hook.
 *
 * Called after login and audio preference changes. Muted listeners have no movement hook. Active
 * services still check effective volume before sending.
 */
/datum/controller/subsystem/point_ambience/proc/update_silenced(client/listener_client)
	PRIVATE_PROC(TRUE)
	var/datum/preferences/prefs = listener_client.prefs
	var/muted_mask = muted_mask_for(prefs)
	listener_client.point_ambience.muted_mask = muted_mask
	listener_client.point_ambience.silenced = muted_by(prefs, muted_mask)
	var/mob/player = listener_client.mob
	if(!player || isobserver(player))
		// A ghost has no ear. player_login drops the watch on ghosting, and this is the backstop
		if(listener_client.point_ambience.head_watch)
			qdel(listener_client.point_ambience.head_watch)
		return
	if(listener_client.point_ambience.silenced)
		UnregisterSignal(player, COMSIG_MOVABLE_MOVED)
	else
		RegisterSignal(player, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)
	// Keep the hearing anchor current while muted so the first unmuted service uses the right
	// position
	update_head_watch(listener_client, player)
	RegisterSignal(player, COMSIG_SPECIES_GAIN, PROC_REF(on_species_changed), override = TRUE)
	RegisterSignal(player, COMSIG_SPECIES_LOSS, PROC_REF(on_species_changed), override = TRUE)

/**
 * A listener changed their point ambience preferences.
 *
 * Rechecks the overall mute state and per-category mask after a slider or toggle changes.
 *
 * Muting calls stop_all_for() or stop_for() immediately because a fully muted listener no longer
 * receives services. Unmuting calls mark_listener() because the unchanged-turf shortcut would
 * otherwise skip the send. Other volume changes take effect on the next service without cutting
 * the current clip
 *
 * Arguments:
 * * restart - stop everything playing and serve afresh whatever the answer, for a caller that
 *   changed what this listener hears by some route other than their preferences
 */
/datum/controller/subsystem/point_ambience/proc/listener_prefs_changed(client/listener_client, restart = FALSE)
	var/was_silenced = listener_client.point_ambience.silenced
	var/was_muted = listener_client.point_ambience.muted_mask
	update_silenced(listener_client)
	if(listener_client.point_ambience.silenced)
		if(restart || !was_silenced)
			stop_all_for(listener_client)
		return
	if(restart)
		stop_all_for(listener_client)
		mark_listener(listener_client)
		return
	var/now_muted = listener_client.point_ambience.muted_mask
	var/newly_muted = now_muted & ~was_muted
	if(newly_muted)
		for(var/datum/point_ambience_category/category as anything in categories)
			if(newly_muted & category.mask)
				stop_for(listener_client, category)
	if(was_silenced || (was_muted & ~now_muted))
		mark_listener(listener_client)

/**
 * Invalidates a listener's cached selection and requests a refresh.
 *
 * Used for door, hearing-anchor and preference changes. With use_queue enabled the client is
 * queued. Otherwise the next standing sweep performs the service.
 */
/datum/controller/subsystem/point_ambience/proc/mark_listener(client/listener_client)
	if(!listener_client || mode != POINT_AMBIENCE_LIVE || listener_client.point_ambience.silenced)
		return
	listener_client.point_ambience.cache_turf = null
	listener_client.point_ambience.last_move = null
	if(use_queue && !dirty_clients[listener_client])
		dirty_clients[listener_client] = world.time

/**
 * Sets a held torch as its carrier's private source at distance zero.
 *
 * Held and dropped torches stay outside the spatial index. A placed sconce is a separate indexed
 * source that nearby listeners can hear.
 */
/datum/controller/subsystem/point_ambience/proc/set_self_source(mob/carrier, atom/source)
	carrier.point_ambience_self_source = source

/**
 * Clears the mob's self source if it is this one.
 *
 * An extinguished torch stops immediately. A lit one can move from the hand into a sconce without
 * changing its clip or channel, so playback continues until the next service re-prices it. Stopping
 * here would leave a gap before the sconce is heard. With no other source in range, it fades out
 */
/datum/controller/subsystem/point_ambience/proc/clear_self_source(mob/carrier, atom/source, still_lit = FALSE)
	if(carrier.point_ambience_self_source != source)
		return
	carrier.point_ambience_self_source = null
	if(still_lit)
		return
	var/client/listener_client = carrier.client
	if(listener_client && listener_client.point_ambience.sources[self_category] == source)
		stop_for(listener_client, self_category)
