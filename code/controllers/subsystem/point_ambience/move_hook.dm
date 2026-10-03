/**
 * Requests a point ambience service after an eligible move, normally through the queue.
 *
 * The interval skips some moves, and the periodic client walk catches a skipped final step. A
 * service must discover new sources as well as update those already playing.
 *
 * Forced moves and floor changes can invalidate the last answer. They bypass
 * move_service_interval at most once per POINT_AMBIENCE_JUMP_GAP, so repeated forced moves cannot
 * demand a service every tick. A jump held by that gap follows the ordinary interval.
 *
 * With speed_cutoff enabled, movement faster than a natural run fades point ambience. The first
 * fast step and the first step back at a natural pace bypass the interval. Intermediate fast steps
 * need no service. A headless dullahan is exempt because its detached head hears from its own
 * position. An unknown step delay must not be mistaken for fast movement.
 *
 * The inline fallback checks TICK_CHECK_LOW and max_services_per_tick after the interval gate but
 * before setting point_ambience_next_service. A refused move can retry on the next step. The
 * standing walk can catch a listener who stops, with its next check governed by
 * standing_walk_interval and standing_skip. TICK_CHECK_LOW leaves half the tick limit unused
 * because Move() runs late in the tick, after the controller, garbage collection and SendMaps.
 * On a busy server this rejects work the queue can defer into tick slack, so the queue remains
 * the default.
 */
/datum/controller/subsystem/point_ambience/proc/on_moved(atom/movable/mover, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	// Before every early return: the survey counts steps taken, which is what a service is billed by
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
	moves_total++
	// A jump skips the interval, one per POINT_AMBIENCE_JUMP_GAP. See the proc doc
	var/turf/old_turf = old_loc
	var/discontinuous = forced || (old_turf && old_turf.z != listener.z)
	var/jump_served = discontinuous && world.time >= listener_client.point_ambience_jump_next
	if(jump_served)
		listener_client.point_ambience_jump_next = world.time + POINT_AMBIENCE_JUMP_GAP
	listener_client.point_ambience_last_move = jump_served ? null : world.time
	// A plain read for anyone on foot, the proc only for a rider
	var/step_delay = listener.buckled ? step_delay_of(listener) : listener.cached_multiplicative_slowdown
	var/urgent = jump_served
	// The speed cutoff. See the proc doc
	if(speed_cutoff && !isnull(step_delay) && !listener_client.point_ambience_ear && step_delay < natural_run_step)
		listener_client.point_ambience_speed_moved = world.time
		if(!listener_client.point_ambience_speed_silenced)
			urgent = TRUE
		else if(!jump_served)
			speed_moves_skipped++
			return
	else if(listener_client.point_ambience_speed_silenced)
		listener_client.point_ambience_speed_moved = null
		urgent = TRUE
	if(!urgent && move_service_interval && world.time < listener_client.point_ambience_next_service)
		return
	if(GLOB.point_ambience_counters)
		GLOB.point_ambience_counters.observe_move_gate(listener_client, listener, discontinuous)
	// The inline path's two rails. See the proc doc
	if(!use_queue && max_services_per_tick)
		if(TICK_CHECK_LOW)
			services_dropped_tick_usage++
			note_drop()
			return
		if(world.time != services_tick_stamp)
			services_tick_stamp = world.time
			services_this_tick = 0
		if(services_this_tick >= max_services_per_tick)
			services_dropped_budget++
			note_drop()
			return
		services_this_tick++
	if(move_service_interval)
		// Read when the next service is scheduled, not when this one is gated, so a change of intent
		// or pace takes hold from the following step rather than retroactively
		listener_client.point_ambience_next_service = world.time + move_interval_for(step_delay, listener.m_intent == MOVE_INTENT_RUN)
	if(use_queue)
		// Idempotent: a client already marked keeps its place, so ten steps in a tick are one entry
		// and nobody moves up the set by moving more. The stamp is the wait the survey reports
		if(!dirty_clients[listener_client])
			dirty_clients[listener_client] = world.time
		return
	move_services++
	listener_client.point_ambience_last_service = world.time
	// Timed in place when a survey runs
	if(GLOB.point_ambience_survey)
		GLOB.point_ambience_survey.time_real_service(listener_client)
		return
	service_client(listener_client)

/// Deciseconds between this listener's steps as the movement code spaces them: a rider at the
/// mounted pace, which the mount's speed and the rider's intent and riding skill set together,
/// anyone else at their own. A diagonal or a strafe adds to one step after this is read
/datum/controller/subsystem/point_ambience/proc/step_delay_of(mob/listener)
	var/datum/component/riding/riding = listener.buckled?.GetComponent(/datum/component/riding)
	return riding ? riding.vehicle_move_delay : listener.cached_multiplicative_slowdown

/**
 * The move service interval for one pace: the configured interval, or the running override for a
 * runner, shortened so a natural mover is served at least every move_service_steps steps. A pace
 * faster than a natural run counts as one, speed_cutoff deciding what those movers hear.
 *
 * Rounded down to the tick. A step lands on the first tick at or after its due time, so where the
 * step count sets the interval it is exact: that many steps on always arrives at or past it and one
 * fewer never does
 */
/datum/controller/subsystem/point_ambience/proc/move_interval_for(step_delay, running)
	. = (running && move_service_interval_running_override) ? move_service_interval_running_override : move_service_interval
	if(move_service_steps)
		. = min(., FLOOR(move_service_steps * max(step_delay, natural_run_step), world.tick_lag))

/**
 * Fades everything a listener hears for moving faster than a natural run, except a torch in their
 * own hand, which at distance 0 sounds no different at speed. Keyed on the source rather than the
 * category, so a sconce on the torch channel still goes.
 *
 * Drops the cached walk too. Otherwise a mover who halts on the tile they were last served at takes
 * the standing shortcut and stays silent
 */
/datum/controller/subsystem/point_ambience/proc/speed_silence(client/listener_client, turf/listener_turf, atom/self_source)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!listener_client.point_ambience_speed_silenced)
		listener_client.point_ambience_speed_silenced = TRUE
		speed_silences++
	listener_client.point_ambience_cache_turf = null
	var/list/sources = listener_client.point_ambience_sources
	for(var/datum/point_ambience_category/category as anything in categories)
		var/atom/playing = sources[category]
		if(!playing || playing == self_source)
			continue
		fade_out(listener_client, category, listener_turf, FALSE)
		speed_fades++

/**
 * Records that this tick refused a move service, once per tick however many it refused.
 *
 * The length of a run of consecutive such ticks is what separates a spike from sustained overload,
 * and the survey reads both.
 */
/datum/controller/subsystem/point_ambience/proc/note_drop()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/tick_index = round(world.time / world.tick_lag)
	if(tick_index == last_drop_tick_index)
		return
	ticks_dropping++
	current_drop_run = (tick_index == last_drop_tick_index + 1) ? current_drop_run + 1 : 1
	longest_drop_run = max(longest_drop_run, current_drop_run)
	last_drop_tick_index = tick_index
