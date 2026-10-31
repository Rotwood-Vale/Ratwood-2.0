/**
 * Requests a listener update after movement, subject to timing, step and queue limits.
 *
 * The standing sweep catches a final step skipped by the interval. Forced moves and floor changes
 * bypass that interval at most once per POINT_AMBIENCE_JUMP_GAP. Later jumps use the normal
 * interval.
 *
 * With speed_cutoff, the first unusually fast step fades ambient sources and the first natural step
 * restores them. Intermediate fast steps need no service. Detached hearing is exempt, and an
 * unknown step delay is not treated as fast movement.
 *
 * The inline path checks its service and tick budgets before updating next_service, allowing a
 * refused request to retry on the next step. Queued requests instead retain their place until the
 * subsystem can serve them.
 */
/datum/controller/subsystem/point_ambience/proc/on_moved(atom/movable/mover, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	// Count attempted movement before any service gate returns
	if(GLOB.point_ambience_survey)
		GLOB.point_ambience_survey.count_move(mover)
	if(mode != POINT_AMBIENCE_LIVE)
		return
	if(!ismob(mover))
		return
	var/mob/listener = mover
	var/client/listener_client = listener.client
	if(!listener_client)
		return
	metrics.moves_total++
	var/turf/old_turf = old_loc
	var/discontinuous = forced || (old_turf && old_turf.z != listener.z)
	var/datum/point_ambience_listener/listener_state = listener_client.point_ambience
	var/jump_served = discontinuous && world.time >= listener_state.jump_next
	if(jump_served)
		listener_state.jump_next = world.time + POINT_AMBIENCE_JUMP_GAP
	listener_state.last_move = jump_served ? null : world.time
	// Only mounted listeners need the rider-specific delay calculation
	var/step_delay = listener.buckled ? step_delay_of(listener) : listener.cached_multiplicative_slowdown
	var/urgent = jump_served
	var/faster_than_run = speed_cutoff && !isnull(step_delay) && step_delay < natural_run_step
	if(faster_than_run && !listener_state.ear)
		listener_state.speed_moved = world.time
		if(!listener_state.speed_silenced)
			urgent = TRUE
		else if(!jump_served)
			return
	else if(listener_state.speed_silenced)
		listener_state.speed_moved = null
		urgent = TRUE
	if(!urgent && move_service_interval && world.time < listener_state.next_service)
		return
	if(GLOB.point_ambience_counters)
		GLOB.point_ambience_counters.observe_move_gate(listener_client, listener, discontinuous)
	if(!use_queue && max_services_per_tick)
		if(TICK_CHECK_LOW)
			metrics.services_dropped_tick_usage++
			return
		if(world.time != services_tick_stamp)
			services_tick_stamp = world.time
			services_this_tick = 0
		if(services_this_tick >= max_services_per_tick)
			metrics.services_dropped_budget++
			return
		services_this_tick++
	if(move_service_interval)
		// Apply the current pace when scheduling the next service, not retroactively to the
		// existing deadline
		listener_state.next_service = world.time + move_interval_for(step_delay, listener.m_intent == MOVE_INTENT_RUN)
	if(use_queue)
		// Preserve the first request's position and timestamp when the client is already queued
		if(!dirty_clients[listener_client])
			dirty_clients[listener_client] = world.time
		return
	metrics.move_services++
	listener_state.last_service = world.time
	if(GLOB.point_ambience_survey)
		GLOB.point_ambience_survey.time_real_service(listener_client)
		return
	service_client(listener_client)

/**
 * Returns the movement delay in deciseconds for the listener or their mount.
 *
 * Mounted delay includes rider intent and skill. Per-step diagonal or strafe adjustments are
 * applied elsewhere.
 */
/datum/controller/subsystem/point_ambience/proc/step_delay_of(mob/listener)
	var/datum/component/riding/riding = listener.buckled?.GetComponent(/datum/component/riding)
	return riding ? riding.vehicle_move_delay : listener.cached_multiplicative_slowdown

/**
 * Returns the service interval for a movement delay and intent, rounded down to the tick.
 *
 * Uses the running override when configured, then shortens the interval to move_service_steps if
 * enabled. Delays faster than natural_run_step use that minimum for interval calculation.
 * speed_cutoff separately controls their playback.
 */
/datum/controller/subsystem/point_ambience/proc/move_interval_for(step_delay, running)
	. = (running && move_service_interval_running_override) ? move_service_interval_running_override : move_service_interval
	if(move_service_steps)
		. = min(., FLOOR(move_service_steps * max(step_delay, natural_run_step), world.tick_lag))

/**
 * Fades ambient sources when a listener exceeds the speed cutoff.
 *
 * The held self source keeps playing at distance zero. The cache is cleared so a listener who stops
 * on their last serviced turf cannot retain the silenced result.
 */
/datum/controller/subsystem/point_ambience/proc/speed_silence(client/listener_client, turf/listener_turf, atom/self_source)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!listener_client.point_ambience.speed_silenced)
		listener_client.point_ambience.speed_silenced = TRUE
		metrics.speed_silences++
	listener_client.point_ambience.cache_turf = null
	var/list/sources = listener_client.point_ambience.sources
	for(var/datum/point_ambience_category/category as anything in categories)
		var/atom/playing = sources[category]
		if(!playing || playing == self_source)
			continue
		fade_out(listener_client, category, listener_turf)
