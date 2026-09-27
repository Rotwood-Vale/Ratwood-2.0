/**
 * Opens a scope for changing many point ambience sources together.
 *
 * Each register_source() and unregister_source() still updates the index, counts, overrides,
 * fallback loops and static_version. The outermost finish_bulk() combines the repeated ranking
 * invalidation, source-change history update and walk over clients.
 * In a local one-client test, removing indexed lights one by one took 38.4 ms in one tick under
 * ideal conditions. That figure may change with the map or implementation.
 *
 * Open and close in the same proc and tick, without sleeping between them. close_leaked_bulk()
 * runs on the next fire or scope if a caller fails partway, limiting how long rankings stay stale.
 *
 * Arguments:
 * * label - names the caller if its scope leaks
 */
/datum/controller/subsystem/point_ambience/proc/begin_bulk_source_update(label)
	SHOULD_NOT_SLEEP(TRUE)
	if(bulk_depth && bulk_opened_at != world.time)
		close_leaked_bulk()
	bulk_depth++
	if(bulk_depth > 1)
		return
	bulk_opened_at = world.time
	bulk_label = label

/// Closes one bulk source update. Only the outermost close does the deferred work
/datum/controller/subsystem/point_ambience/proc/end_bulk_source_update()
	SHOULD_NOT_SLEEP(TRUE)
	// Zero when this caller's scope already leaked and was closed for it
	if(!bulk_depth)
		return
	bulk_depth--
	if(bulk_depth)
		return
	finish_bulk()

/**
 * Finishes the outermost bulk source update.
 *
 * One clear_tile_cache() resets source_change_history and bumps static_version, so no listener
 * reuses an answer from before the scope. Then bulk_affected sources are checked against each
 * client's point_ambience_sources. A source restored to the same category keeps playing. One
 * removed or moved to another category stops, even if it was indexed during the scope. A held
 * torch stays alone unless the scope removed it, and an existing fade finishes normally.
 *
 * A service inside the scope may use a ranking that is about to change. The final check stops any
 * channel whose source was removed, while the cache clear discards its stale ranking.
 * This cleanup is why readers do not check bulk_depth.
 */
/datum/controller/subsystem/point_ambience/proc/finish_bulk()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// Taken and reset before the work, so a runtime below cannot hand this scope's state to the next
	var/list/affected = bulk_affected
	var/changed = bulk_changes
	bulk_affected = list()
	bulk_changes = 0
	bulk_label = null
	bulk_scopes++
	if(!changed)
		return
	bulk_changes_total += changed
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_bulk")
	clear_tile_cache()
	if(length(affected))
		for(var/client/listener_client in GLOB.clients)
			var/list/playing = listener_client.point_ambience_sources
			if(!length(playing))
				continue
			// The loop walks a copy, so stop_for() may remove from the list
			for(var/datum/point_ambience_category/category as anything in playing)
				var/atom/source = playing[category]
				if(affected[source] && source_categories[source] != category)
					stop_for(listener_client, category)
					bulk_stops++
	if(timing)
		var/took = rustg_time_microseconds("pa_bulk") / 1000
		bulk_close_ms += took
		bulk_close_worst_ms = max(bulk_close_worst_ms, took)

/// Closes a scope whose caller never did. A scope cannot span ticks, so one open on a later tick leaked
/datum/controller/subsystem/point_ambience/proc/close_leaked_bulk()
	PRIVATE_PROC(TRUE)
	bulk_leaks++
	var/label = bulk_label
	bulk_depth = 0
	finish_bulk()
	log_world("Point ambience: bulk update [label] was still open a tick later and has been closed. Reached from [call_chain()]")

/**
 * Logs a burst of unbatched index changes, at most once every five minutes.
 *
 * Called when one tick of index changes outside any bulk update reaches POINT_AMBIENCE_BULK_BURST,
 * and names the caller so it can be moved into a scope. Diagnostic only: the changes keep the
 * ordinary path, which stays correct, only slower
 */
/datum/controller/subsystem/point_ambience/proc/report_unbatched_burst()
	PRIVATE_PROC(TRUE)
	unbatched_bursts++
	if(world.time < burst_quiet_until)
		return
	burst_quiet_until = world.time + 5 MINUTES
	log_world("Point ambience: [POINT_AMBIENCE_BULK_BURST] source changes in one tick outside a bulk update. Wrap the caller in begin_bulk_source_update(). Reached from [call_chain()]")

/**
 * The procs leading here, innermost first, for a report that must not raise a runtime.
 *
 * A runtime fails whichever unit test is running, and create_and_destroy changes sources in bulk
 */
/datum/controller/subsystem/point_ambience/proc/call_chain()
	PRIVATE_PROC(TRUE)
	var/list/chain = list()
	for(var/callee/frame = caller, frame && length(chain) < 12, frame = frame.caller)
		chain += "[frame.proc.type][frame.file ? " ([frame.file]:[frame.line])" : ""]"
	return chain.Join(", ")
