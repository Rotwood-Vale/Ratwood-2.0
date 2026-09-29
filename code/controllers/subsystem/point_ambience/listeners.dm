/**
 * Hooks the login signals and runs the login handler for every client already connected.
 *
 * The handler gives each player's mob the move hook unless it is a ghost or they have point ambience
 * muted. Moving listeners are served by the hook. The once-a-second standing walk covers the ones
 * standing still and sources that change state beside them
 */
/datum/controller/subsystem/point_ambience/proc/hook_logins()
	PRIVATE_PROC(TRUE)
	hooked_logins = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGIN, PROC_REF(player_login))
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGOUT, PROC_REF(player_logout))
	for(var/client/listener_client as anything in GLOB.clients)
		if(listener_client.mob)
			player_login(null, listener_client.mob)

/// Observers get no ambience: whatever the client was hearing stops here, on the transition
/// itself, and no move hook is attached to the ghost. A ghost has no ear, so a head watch goes too
/datum/controller/subsystem/point_ambience/proc/player_login(datum/source, mob/player)
	SIGNAL_HANDLER
	if(isobserver(player))
		stop_all_for(player.client)
		qdel(player.client?.point_ambience_head_watch)
		return
	if(player.client)
		player.client.point_ambience_last_move = null
		player.client.point_ambience_speed_moved = null
		player.client.point_ambience_speed_silenced = FALSE
		update_silenced(player.client)

/datum/controller/subsystem/point_ambience/proc/player_logout(datum/source, mob/player)
	SIGNAL_HANDLER
	UnregisterSignal(player, list(COMSIG_MOVABLE_MOVED, COMSIG_SPECIES_GAIN, COMSIG_SPECIES_LOSS))
	// dirty_clients is left alone: a client that merely changed mobs is still owed a service, and
	// one that truly left leaves a null key for drain_dirty() to drop

/// Recomputed whenever the config decides which categories are silenced, since that is what a
/// listener's turned-off categories are held against
/datum/controller/subsystem/point_ambience/proc/refresh_audible_mask()
	PRIVATE_PROC(TRUE)
	audible_mask = 0
	for(var/datum/point_ambience_category/category as anything in categories)
		if(!category.silenced)
			audible_mask |= category.mask

/// The categories one listener has muted, as their bits. Read per service in place of the
/// preferences, so a category toggle costs one AND there
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
	// Under the cutoff at distance 0 is inaudible in practice, so it unhooks like a zero rather than
	// costing a service a step that the send then refuses. At the cutoff itself the send goes out
	if(send_cutoff && loudest_volume * effective_volume * 0.01 < send_cutoff)
		return TRUE
	if(isnull(muted_mask))
		muted_mask = muted_mask_for(prefs)
	return (muted_mask & audible_mask) == audible_mask

/**
 * Recomputes whether a listener hears point ambience at all and which categories they have muted.
 *
 * Attaches or detaches their move hook to match, so a muted listener's steps cost nothing, the same
 * as an observer's. Called at login and on every change in the volume menu. Nothing per step or per
 * walk decides muting from preferences except prepare_serving's zero check
 */
/datum/controller/subsystem/point_ambience/proc/update_silenced(client/listener_client)
	PRIVATE_PROC(TRUE)
	var/datum/preferences/prefs = listener_client.prefs
	var/muted_mask = muted_mask_for(prefs)
	listener_client.point_ambience_muted_mask = muted_mask
	listener_client.point_ambience_silenced = muted_by(prefs, muted_mask)
	var/mob/player = listener_client.mob
	if(!player || isobserver(player))
		// A ghost has no ear. player_login drops the watch on ghosting, and this is the backstop
		if(listener_client.point_ambience_head_watch)
			qdel(listener_client.point_ambience_head_watch)
		return
	if(listener_client.point_ambience_silenced)
		UnregisterSignal(player, COMSIG_MOVABLE_MOVED)
	else
		RegisterSignal(player, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)
	// Kept whether they are muted or not: it costs nothing while nothing moves, and an ear resolved
	// only on unmuting would be wrong for the first service after it
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
	var/was_silenced = listener_client.point_ambience_silenced
	var/was_muted = listener_client.point_ambience_muted_mask
	update_silenced(listener_client)
	if(listener_client.point_ambience_silenced)
		if(restart || !was_silenced)
			stop_all_for(listener_client)
		return
	if(restart)
		stop_all_for(listener_client)
		mark_listener(listener_client)
		return
	var/now_muted = listener_client.point_ambience_muted_mask
	var/newly_muted = now_muted & ~was_muted
	if(newly_muted)
		for(var/datum/point_ambience_category/category as anything in categories)
			if(newly_muted & category.mask)
				stop_for(listener_client, category)
	if(was_silenced || (was_muted & ~now_muted))
		mark_listener(listener_client)

/**
 * Marks a listener for a service after something the move hook cannot see.
 *
 * Their ear or what carries it moved, a door near them changed, or a preference came back on. Drops
 * the standing cache too, or the walk would shortcut straight past the change. With the queue off
 * only the cache goes, and the standing walk serves them
 */
/datum/controller/subsystem/point_ambience/proc/mark_listener(client/listener_client)
	if(!listener_client || mode != POINT_AMBIENCE_LIVE || listener_client.point_ambience_silenced)
		return
	listener_client.point_ambience_cache_turf = null
	listener_client.point_ambience_last_move = null
	if(use_queue && !dirty_clients[listener_client])
		dirty_clients[listener_client] = world.time

/**
 * Marks a lit torch in a hand as its carrier's self source, heard by the carrier alone.
 *
 * It never enters the index: it is served to its carrier at distance 0, so no walk ever scans it
 * and no standing listener has to be rechecked because someone walked past. A lit torch lying on
 * the ground is not indexed either. The only torch anyone else hears is one in a sconce, and then
 * the sconce is the source
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
	if(listener_client && listener_client.point_ambience_sources[self_category] == source)
		stop_for(listener_client, self_category)

/// One watch per dullahan client and none for anybody else, so nothing on everyone's path resolves
/// a species. Called at login and whenever the species changes
/datum/controller/subsystem/point_ambience/proc/update_head_watch(client/listener_client, mob/player)
	PRIVATE_PROC(TRUE)
	var/datum/point_ambience_head_watch/watch = listener_client.point_ambience_head_watch
	var/mob/living/carbon/human/human = player
	if(!istype(human) || !istype(human.dna?.species, /datum/species/dullahan))
		if(watch)
			qdel(watch)
		return
	if(watch)
		watch.retarget(human)
	else
		listener_client.point_ambience_head_watch = new /datum/point_ambience_head_watch(listener_client, human)

/// The gain signal is sent before the dullahan assigns my_head, so the watch is built a tick later
/datum/controller/subsystem/point_ambience/proc/on_species_changed(mob/player)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(rebuild_head_watch), player), 0)

/datum/controller/subsystem/point_ambience/proc/rebuild_head_watch(mob/player)
	PRIVATE_PROC(TRUE)
	var/client/listener_client = player?.client
	if(listener_client)
		update_head_watch(listener_client, player)

/**
 * Keeps a headless dullahan's listening point on their head.
 *
 * One per dullahan client, made at login and dropped when they stop being one. It follows the head
 * and whatever carries it, so a head in a bag on somebody's back still moves the ear, and writes
 * client.point_ambience_ear. Everyone else has no watch and no ear, and a service reads one var
 * rather than resolving a species.
 *
 * What it does not see: a container moved between holders without the tracked holder moving, and a
 * muffle change on the same turf. The once-a-second walk catches a turf change on its next visit,
 * subject to the skip and the budget. A muffle change on the same turf waits for the next service
 * either way
 */
/datum/point_ambience_head_watch
	var/client/owner
	var/mob/living/carbon/human/body
	var/obj/item/bodypart/head/dullahan/head
	/// The outermost movable carrying the head, so a carried head moves the ear with no head MOVED
	var/atom/movable/holder

/datum/point_ambience_head_watch/New(client/listener_client, mob/living/carbon/human/human)
	owner = listener_client
	retarget(human)

/datum/point_ambience_head_watch/Destroy(force)
	drop_head()
	if(owner?.point_ambience_head_watch == src)
		owner.point_ambience_head_watch = null
	owner = null
	body = null
	return ..()

/// Points the watch at a mob's head, seeded from its CURRENT state, so a client logging in with the
/// head already off is served from it rather than waiting for the head to move
/datum/point_ambience_head_watch/proc/retarget(mob/living/carbon/human/human)
	if(body != human)
		if(body)
			UnregisterSignal(body, COMSIG_QDELETING)
		body = human
		if(body)
			RegisterSignal(body, COMSIG_QDELETING, PROC_REF(on_body_deleted))
	var/datum/species/dullahan/species = human?.dna?.species
	if(!istype(species))
		drop_head()
		return
	var/obj/item/bodypart/head/dullahan/new_head = species.my_head
	if(head && head != new_head)
		drop_head()
	if(!new_head)
		return
	if(head != new_head)
		head = new_head
		RegisterSignal(head, COMSIG_MOVABLE_MOVED, PROC_REF(on_head_moved))
		RegisterSignal(head, COMSIG_QDELETING, PROC_REF(on_head_deleted))
	set_ear(species.headless)

/// The watch holds its body, so it goes with it rather than keeping a deleted mob alive
/datum/point_ambience_head_watch/proc/on_body_deleted(datum/source)
	SIGNAL_HANDLER
	qdel(src)

/// The ear on or off, the holder hooked to match, and the listener served again either way
/datum/point_ambience_head_watch/proc/set_ear(headless)
	if(!owner)
		return
	if(headless && head)
		owner.point_ambience_ear = head
		hook_holder()
	else
		owner.point_ambience_ear = null
		unhook_holder()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/drop_head()
	unhook_holder()
	if(head)
		UnregisterSignal(head, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
		head = null
	if(owner)
		owner.point_ambience_ear = null

/// The outermost movable holding the head: a pouch inside a backpack on a mob moves with the mob,
/// and only the mob's own MOVED will fire
/datum/point_ambience_head_watch/proc/hook_holder()
	var/atom/movable/outermost
	var/atom/above = head?.loc
	while(ismovable(above))
		outermost = above
		above = above.loc
	if(outermost == holder)
		return
	unhook_holder()
	holder = outermost
	if(holder)
		RegisterSignal(holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))
		RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_deleted))

/datum/point_ambience_head_watch/proc/unhook_holder()
	if(!holder)
		return
	UnregisterSignal(holder, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	holder = null

/// Reads the species, not the head's loc: doMove fires Moved BEFORE loc is null, so where the head
/// is cannot tell a detachment from a reattachment. Both paths set headless before they move it
/datum/point_ambience_head_watch/proc/on_head_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	var/datum/species/dullahan/species = body?.dna?.species
	set_ear(istype(species) && species.headless)

/datum/point_ambience_head_watch/proc/on_holder_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	// A bag picked up changes the chain without the head moving, so it is re-read on every carry
	hook_holder()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/on_head_deleted(datum/source)
	SIGNAL_HANDLER
	drop_head()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/on_holder_deleted(datum/source)
	SIGNAL_HANDLER
	unhook_holder()
