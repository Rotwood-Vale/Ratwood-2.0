/**
 * Opens a bulk source update, for a caller about to change many sources in one go.
 *
 * Until the matching close, every register and unregister still keeps the index, the counts, the
 * overrides and the fallback loops exact and bumps static_version. What it defers is the work that
 * repeats across overlapping sources: its ranking invalidation, its history entry and its walk over
 * every client. The outermost close does each once, see finish_bulk(). Unbatched, the Index only
 * snuff's 1699 overlapping removals took 38.4 ms in one tick with one client connected, and cleared
 * 69 cached entries between them. The Mass Snuff verb timed that under ideal conditions, not a
 * loaded server, and it may be out of date
 *
 * Open and close in the same proc and the same tick, with nothing between that can sleep. A scope
 * still open on a later tick is closed by the next fire or scope and reported, so a caller that fails
 * part way leaves rankings stale for about a tick rather than local invalidation off for good
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
 * The outermost close.
 *
 * One clear_tile_cache() for everything the scope changed, which also empties the history and bumps
 * static_version, so no listener reuses an answer from before or during the scope. Then one pass over
 * what every listener plays: a channel stops when its source was removed or moved between categories
 * inside the scope and its FINAL category is not the one it plays under. Membership alone is not
 * enough. A source put back in the same category keeps playing, one restored under another category
 * loses its old channel, and a held torch, never in the index, is left alone unless the scope itself
 * removed it. A channel already fading out has left point_ambience_sources and finishes its fade, as
 * it does after an ordinary unregister
 *
 * A service run inside the scope can rank from buckets still changing or hit an entry not yet
 * flushed, so it may start or keep a source the scope removes. This pass stops any such channel and
 * the flush discards the entry, which is why no reader checks bulk_depth
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
 * One tick of index changes outside any bulk update reached POINT_AMBIENCE_BULK_BURST. Names the
 * caller so it can be moved into a scope, at most once every five minutes. Diagnostic only: the
 * changes keep the ordinary path, which stays correct, only slower
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
 * A runtime fails whichever unit test is running, and create_and_destroy changes sources in bulk
 */
/datum/controller/subsystem/point_ambience/proc/call_chain()
	PRIVATE_PROC(TRUE)
	var/list/chain = list()
	for(var/callee/frame = caller, frame && length(chain) < 12, frame = frame.caller)
		chain += "[frame.proc.type][frame.file ? " ([frame.file]:[frame.line])" : ""]"
	return chain.Join(", ")
