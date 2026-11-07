/**
 * Collects due clip categories still playing and clears their due flags.
 *
 * Cancels any deferred callback because this service will perform the pending advancement. Returns
 * null when no active category needs a new clip.
 */
/datum/controller/subsystem/point_ambience/proc/collect_due_clips(client/listener_client)
	PRIVATE_PROC(TRUE)
	var/list/due
	listener_client.point_ambience.clip_due = FALSE
	var/list/slots = listener_client.point_ambience.slots
	for(var/datum/point_ambience_category/due_category as anything in categories)
		var/datum/point_ambience_slot/due_slot = LAZYACCESS(slots, due_category.index)
		if(!due_slot?.clip_due)
			continue
		due_slot.clip_due = null
		if(due_slot.timer)
			deltimer(due_slot.timer)
			due_slot.timer = null
		if(listener_client.point_ambience.sources[due_category])
			LAZYADD(due, due_category)
	return due

/**
 * Marks one expired clip for replacement.
 *
 * The client is queued, and the service picks the next clip. A service already queued takes it
 * along. A listener expected to step within clip_coalesce_window waits for that step, and the timer
 * returns with deferred set if the step never comes. With the queue off the service runs inline.
 * The old clip repeats natively until it is served.
 *
 * Arguments:
 * * deferred - the timer after waiting for a step, which serves the client unless a service
 *   already took the clip
 */
/datum/controller/subsystem/point_ambience/proc/advance_clip(client/listener_client, datum/point_ambience_category/category, deferred = FALSE)
	PRIVATE_PROC(TRUE)
	if(mode != POINT_AMBIENCE_LIVE || !listener_client || !listener_client.point_ambience.sources[category])
		return
	var/datum/point_ambience_slot/slot = slot_for(listener_client, category.index)
	if(deferred && !slot.clip_due)
		return
	slot.timer = null
	if(!deferred)
		slot.clip_due = TRUE
		listener_client.point_ambience.clip_due = TRUE
	if(!isnull(dirty_clients[listener_client]))
		return
	if(!deferred && clip_coalesce_window > 0)
		var/last_move = listener_client.point_ambience.last_move
		var/expect_movement = use_queue && !listener_client.point_ambience.ear \
			&& !isnull(last_move) && world.time - last_move < clip_coalesce_window
		if(expect_movement)
			slot.timer = addtimer(CALLBACK(src, PROC_REF(advance_clip), listener_client, category, TRUE), clip_coalesce_window, TIMER_STOPPABLE)
			return
	if(use_queue)
		dirty_clients[listener_client] = world.time
		return
	service_client(listener_client)

/**
 * Stops one category for one listener and forgets what it was playing.
 *
 * Arguments:
 * * send_null - FALSE when nothing was playing on the channel, so there is nothing to stop. A fade
 *   out is stopped whatever this says.
 */
/datum/controller/subsystem/point_ambience/proc/stop_for(client/listener_client, datum/point_ambience_category/category, send_null = TRUE)
	var/datum/point_ambience_listener/listener_state = listener_client.point_ambience
	listener_state.sources -= category
	if(category == river_category)
		listener_state.river_cost = null
		listener_state.river_scale = null
		listener_state.river_version = null
	var/list/slots = listener_state.slots
	var/datum/point_ambience_slot/slot = LAZYACCESS(slots, category.index)
	if(slot)
		slot.runner_up = null
		slot.last_volume = null
		POINT_AMBIENCE_CANCEL_CLIP_TIMER(slot)
		slot.clip_due = null
		if(slot.fade_next)
			// A fading-out channel still needs a stop packet even when send_null was FALSE
			if(isnull(slot.fade_target))
				send_null = TRUE
			POINT_AMBIENCE_CLEAR_FADE(slot)
	if(send_null)
		SEND_SOUND(listener_client, category.stop_sound)

/// Stops every category for one listener and clears their cached walk, so the next service is
/// fresh. Leaving the cache would let a stationary listener take the shortcut and stay silent
/datum/controller/subsystem/point_ambience/proc/stop_all_for(client/listener_client)
	PRIVATE_PROC(TRUE)
	if(!listener_client)
		return
	listener_client.point_ambience.clip_due = FALSE
	listener_client.point_ambience.last_move = null
	listener_client.point_ambience.river_cost = null
	listener_client.point_ambience.river_scale = null
	listener_client.point_ambience.river_version = null
	var/list/slots = listener_client.point_ambience.slots
	for(var/datum/point_ambience_category/category as anything in categories)
		if(listener_client.point_ambience.sources[category])
			stop_for(listener_client, category)
			continue
		// Fade-out channels are absent from sources but must also stop when the listener is muted
		var/datum/point_ambience_slot/slot = LAZYACCESS(slots, category.index)
		if(slot)
			POINT_AMBIENCE_CANCEL_CLIP_TIMER(slot)
		if(slot?.fade_next)
			stop_for(listener_client, category)
	// Muted listeners and ghosts may never service these lists again, so release their sources now
	slots.Cut()
	listener_client.point_ambience.cache_static?.Cut()
	listener_client.point_ambience.cache_self = null
	listener_client.point_ambience.cache_turf = null
