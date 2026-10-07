/**
 * Runs the river refills, the fades, the door gathers, the queue and the standing walk, in that order.
 *
 * Each phase has its own usage counter for the Server verb. First close any bulk update left open
 * from an earlier tick, then seed the config before hooking logins. That order lets each client's
 * initial muting check see the configured silenced categories. River fills stay current in every
 * mode. The remaining phases run only in live mode.
 */
/datum/controller/subsystem/point_ambience/fire(resumed)
	if(bulk_depth && bulk_opened_at != world.time)
		close_leaked_bulk()
	if(!settings_seeded)
		seed_settings()
	if(!hooked_logins)
		hook_logins()
	var/usage_before
	if(length(river_fill.dirty) && world.time >= river_fill.next)
		usage_before = TICK_USAGE
		rebuild_river_fill()
		metrics.river_fill_usage += TICK_USAGE - usage_before
	if(mode != POINT_AMBIENCE_LIVE)
		return

	// Advance fades before service work consumes the tick budget, including for listeners who
	// stopped moving
	if(length(fading) && world.time >= fade_next_due)
		usage_before = TICK_USAGE
		run_fades()
		metrics.fade_usage += TICK_USAGE - usage_before

	// Gather door changes before draining so their requests can run in this fire
	if(length(changed_doors) && world.time >= next_door_recheck)
		usage_before = TICK_USAGE
		recheck_doors()
		metrics.door_usage += TICK_USAGE - usage_before

	// Drain existing requests even after use_queue is disabled
	if(length(dirty_clients))
		usage_before = TICK_USAGE
		drain_dirty()
		metrics.drain_usage += TICK_USAGE - usage_before

	if(!length(currentrun) && world.time >= next_standing_walk)
		next_standing_walk = world.time + standing_walk_interval
		currentrun = GLOB.clients.Copy()
		// Movement config can change after startup. Refresh the natural running limit for each
		// sweep
		natural_run_step = CONFIG_GET(number/movedelay/run_delay) - 0.5
	if(!length(currentrun))
		return
	usage_before = TICK_USAGE
	run_standing_walk()
	metrics.walk_usage += TICK_USAGE - usage_before

/**
 * Visits clients at standing_walk_interval, resuming a partial sweep after the tick budget expires.
 *
 * Skips recent services, unchanged active movers and queued clients. can_check_cached_selection
 * checks the prerequisites for the inlined standing shortcut. POINT_AMBIENCE_STANDING_UNCHANGED
 * validates its cached answer. Other clients go through service_client().
 *
 * Keep this shortcut aligned with service_client(), including its counters. A due clip, alternate
 * hearing anchor, lobby mob, speed state or changed self source requires normal servicing. Every
 * iteration reaches a tick check. Leaving the loop clears in_standing_walk.
 */
/datum/controller/subsystem/point_ambience/proc/run_standing_walk()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	in_standing_walk = TRUE
	while(length(currentrun))
		if(MC_TICK_CHECK)
			break
		var/client/listener_client = currentrun[currentrun.len]
		currentrun.len--
		if(!listener_client || listener_client.point_ambience.silenced || isobserver(listener_client.mob))
			continue
		var/datum/point_ambience_listener/listener_state = listener_client.point_ambience
		if(standing_skip && world.time - listener_state.last_service < standing_skip)
			metrics.standing_skipped++
			continue
		// A natural step or the first sweep after movement stops restores speed-silenced ambience
		if(listener_state.speed_silenced && !isnull(listener_state.speed_moved) \
			&& world.time - listener_state.speed_moved < POINT_AMBIENCE_SPEED_STILL)
			metrics.standing_skipped++
			continue
		var/mob/listener = listener_client.mob
		if(standing_skip && walking_unchanged(listener_client, listener))
			metrics.standing_skipped++
			continue
		if(!isnull(dirty_clients[listener_client]))
			metrics.standing_skipped++
			continue

		var/turf/listener_turf = get_turf(listener)
		var/datum/preferences/prefs = listener_client.prefs
		var/can_check_cached_selection = listener_turf && !listener_state.clip_due && !listener_state.ear \
			&& !isnewplayer(listener) && isnull(listener_state.speed_moved) \
			&& listener.point_ambience_self_source == listener_state.cache_self
		if(can_check_cached_selection && POINT_AMBIENCE_STANDING_UNCHANGED(listener_state, listener_turf, (prefs ? POINT_AMBIENCE_VOLUME(prefs) : null)))
			listener_state.cache_version = static_version
			metrics.services_total++
			metrics.shortcut_hits++
			metrics.standing_walk_hits++
			continue

		var/shortcut_hits_before = metrics.shortcut_hits
		service_client(listener_client)
		if(metrics.shortcut_hits != shortcut_hits_before)
			metrics.standing_walk_hits++
	in_standing_walk = FALSE

/**
 * Whether a walking client can skip this visit, since nothing has changed near them.
 *
 * Still walking means a step within standing_skip and a service within one walk of that. Nothing
 * changed means the torch in hand is the one last served, and no source near their current turf has
 * changed since then. The reuse test reads their current turf, the walk's shortcut their cached one.
 * A due clip or a detached ear always takes the full service
 */
/datum/controller/subsystem/point_ambience/proc/walking_unchanged(client/listener_client, mob/listener)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/point_ambience_listener/listener_state = listener_client.point_ambience
	if(listener_state.clip_due || listener_state.ear)
		return FALSE
	var/last_move = listener_state.last_move
	if(isnull(last_move) || world.time - last_move >= standing_skip)
		return FALSE
	if(world.time - listener_state.last_service >= standing_skip + standing_walk_interval)
		return FALSE
	if(listener_state.cache_self != listener?.point_ambience_self_source)
		return FALSE
	if(!listener_state.cache_turf)
		return FALSE
	if(listener_state.cache_version == static_version)
		return TRUE
	return can_reuse_tile_listener(get_turf(listener), listener_state.cache_version)

/**
 * Serves the marked clients, back to back, oldest mark first, up to the budget.
 *
 * Stops at the service budget or the MC tick limit, leaving unprocessed entries for the next fire.
 * The queue is retained between runs rather than rebuilt. service_attempts counts calls for clients
 * with a mob, including ones that return early. completed_services counts only calls that reached
 * service accounting, so a muted client consumes budget without inflating the batch statistics.
 */
/datum/controller/subsystem/point_ambience/proc/drain_dirty()
	PRIVATE_PROC(TRUE)
	metrics.drains++
	var/service_attempts = 0
	var/services_at_start = metrics.drain_services
	while(length(dirty_clients))
		if(max_services_per_tick && service_attempts >= max_services_per_tick)
			metrics.queue_deferred_ticks++
			break
		var/client/listener_client = dirty_clients[1]
		// Invalid clients still reach the tick check after removal, bounding cleanup of stale queue
		// entries
		var/queued_at = listener_client ? dirty_clients[listener_client] : world.time
		dirty_clients.Cut(1, 2)
		if(listener_client?.mob)
			var/queue_wait = world.time - queued_at
			metrics.queue_wait_total += queue_wait
			metrics.queue_wait_window_max = max(metrics.queue_wait_window_max, queue_wait)
			metrics.queue_served++
			service_attempts++
			var/services_before_call = metrics.services_total
			if(GLOB.point_ambience_survey)
				GLOB.point_ambience_survey.time_real_service(listener_client)
			else
				service_client(listener_client)
			listener_client.point_ambience.last_service = world.time
			// A muted client returns before counting and was not served
			if(metrics.services_total != services_before_call)
				metrics.drain_services++
		if(MC_TICK_CHECK)
			metrics.drain_paused++
			break

	var/completed_services = metrics.drain_services - services_at_start
	if(!completed_services)
		return
	var/batch_size_bucket
	switch(completed_services)
		if(1, 2)
			batch_size_bucket = completed_services
		if(3 to 4)
			batch_size_bucket = 3
		if(5 to 8)
			batch_size_bucket = 4
		else
			batch_size_bucket = 5
	metrics.drain_size_drains[batch_size_bucket]++
	metrics.drain_size_services_total[batch_size_bucket] += completed_services
