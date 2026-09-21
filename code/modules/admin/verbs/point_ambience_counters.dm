GLOBAL_DATUM(point_ambience_counters, /datum/point_ambience_counters)

/datum/controller/subsystem/point_ambience
	var/measure_move_gate = FALSE
	var/list/move_gate_counts = list(
		"checked" = 0,
		"silent" = 0,
		"discontinuous" = 0,
		"cache bypass" = 0,
		"listener state" = 0,
		"pending service" = 0,
		"self source" = 0,
		"playing" = 0,
		"fading" = 0,
		"unknown ranking" = 0,
		"nonempty ranking" = 0,
	)

/datum/controller/subsystem/point_ambience/proc/observe_move_gate(client/listener_client, mob/listener, discontinuous)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	move_gate_counts["checked"]++
	if(discontinuous)
		move_gate_counts["discontinuous"]++
		return
	if(!use_tile_cache || cross_floor || verify_tile_cache)
		move_gate_counts["cache bypass"]++
		return
	if(listener_client.point_ambience_silenced || listener_client.point_ambience_ear || isnewplayer(listener) || isobserver(listener))
		move_gate_counts["listener state"]++
		return
	if(!isnull(dirty_clients[listener_client]))
		move_gate_counts["pending service"]++
		return
	if(listener.point_ambience_self_source)
		move_gate_counts["self source"]++
		return
	if(length(listener_client.point_ambience_sources))
		move_gate_counts["playing"]++
		return
	for(var/list/slot as anything in listener_client.point_ambience_slots)
		if(slot?[POINT_AMBIENCE_SLOT_FADE_NEXT])
			move_gate_counts["fading"]++
			return
	var/turf/listener_turf = get_turf(listener)
	var/turf/served_turf = listener_client.point_ambience_cache_turf
	if(!listener_turf || !served_turf)
		move_gate_counts["unknown ranking"]++
		return
	var/current_ranking = tile_cache[listener_turf]
	var/previous_ranking = tile_cache[served_turf]
	if(isnull(current_ranking) || isnull(previous_ranking))
		move_gate_counts["unknown ranking"]++
		return
	if(current_ranking != TRUE || previous_ranking != TRUE)
		move_gate_counts["nonempty ranking"]++
		return
	move_gate_counts["silent"]++

/**
 * What a point ambience measurement depends on besides the code, as one line to print beside a result.
 *
 * Each listener's effective Point Ambience volume decides the volume sent and, once sends below a
 * threshold stop, how many sends happen at all. Muted and observing clients are passed over entirely. The
 * knobs set the service rate and the index's contents set the walk. Two runs are comparable only
 * when these match, so every report carries them. Read when printed, never per service.
 */
/proc/point_ambience_conditions()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	var/listening = 0
	var/muted = 0
	var/observing = 0
	var/list/sliders = list()
	for(var/client/listener_client as anything in GLOB.clients)
		if(isobserver(listener_client.mob))
			observing++
		else if(listener_client.point_ambience_silenced)
			muted++
		else
			listening++
			var/slider = "no prefs"
			if(listener_client.prefs)
				if(listener_client.prefs.pointambience_independent)
					slider = "[listener_client.prefs.pointambiencevol] independent"
				else
					slider = "[listener_client.prefs.pointambiencevol] at Master [listener_client.prefs.overallvol]"
			sliders[slider] = (sliders[slider] || 0) + 1
	var/list/slider_parts = list()
	for(var/slider in sliders)
		slider_parts += "[slider] x[sliders[slider]]"
	var/list/source_parts = list()
	for(var/datum/point_ambience_category/category as anything in ambience.categories)
		var/count = ambience.source_counts[category] || 0
		if(count)
			source_parts += "[category.config_name] [count] at [category.volume]"
	return "conditions: [listening] listening (slider [length(slider_parts) ? slider_parts.Join(", ") : "none"]), [muted] muted, [observing] observing; interval [ambience.move_service_interval], running [ambience.move_service_interval_running_override], skip [ambience.standing_skip], active skip [ambience.skip_active_movers ? "on" : "off"], clip wait [ambience.clip_coalesce_window / 10] s, budget [ambience.max_services_per_tick], cutoff [ambience.send_cutoff], queue [ambience.use_queue ? "on" : "off"], cross floor [ambience.cross_floor ? "on" : "off"], tile cache [ambience.use_tile_cache ? (ambience.cross_floor ? "bypassed" : "on") : "off"], cache verification [ambience.verify_tile_cache ? "on" : "off"]; sources, count at volume: [source_parts.Join(", ")]"

/datum/point_ambience_counters
	var/time
	var/list/move_gate_counts
	var/moves_total
	var/move_services
	var/drains
	var/drain_ms
	var/drain_services
	var/drain_sends
	var/drain_paused
	var/drain_tick_usage_total
	var/list/drain_size_services
	var/list/drain_size_ms
	var/list/drain_density_count
	var/standing_walks
	var/standing_walk_ms
	var/fade_range_starts
	var/fade_wall_starts
	var/fade_in_starts
	var/fade_skipped
	var/fade_takeovers
	var/fade_refused_far
	var/fade_refused_full
	var/fade_refused_state
	var/fade_deferred
	var/fade_packets
	var/fade_ms
	var/clip_refreshes
	var/clip_refresh_fast
	var/clip_refresh_full
	var/clip_refresh_coalesced
	var/clip_refresh_deferred
	var/clip_refresh_timeouts
	var/clip_refresh_queued
	var/clip_refresh_ms
	var/standing_skipped
	var/standing_active_skipped
	var/standing_pending_skipped
	var/tick_services
	var/tick_standing_hits
	var/walks_turf
	var/walks_version
	var/walks_volume
	var/index_changes
	var/queue_served
	var/queue_wait_total
	var/queue_deferred_ticks
	var/services_dropped_tick
	var/services_dropped_count
	var/ticks_dropping
	var/services_total
	var/occlusion_checks_total
	var/occlusion_corners
	var/runner_up_silenced
	var/tile_cache_hits
	var/tile_cache_misses
	var/tile_cache_cleared
	var/tile_cache_checks
	var/tile_cache_mismatches
	var/tile_cache_invalidation_ms

/datum/point_ambience_counters/New()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	time = world.time
	move_gate_counts = ambience.move_gate_counts.Copy()
	moves_total = ambience.moves_total
	move_services = ambience.move_services
	drains = ambience.drains
	drain_ms = ambience.drain_ms
	drain_services = ambience.drain_services
	drain_sends = ambience.drain_sends
	drain_paused = ambience.drain_paused
	drain_tick_usage_total = ambience.drain_tick_usage_total
	drain_size_services = ambience.drain_size_services.Copy()
	drain_size_ms = ambience.drain_size_ms.Copy()
	drain_density_count = ambience.drain_density_count.Copy()
	standing_walks = ambience.standing_walks
	standing_walk_ms = ambience.standing_walk_ms
	fade_range_starts = ambience.fade_range_starts
	fade_wall_starts = ambience.fade_wall_starts
	fade_in_starts = ambience.fade_in_starts
	fade_skipped = ambience.fade_skipped
	fade_takeovers = ambience.fade_takeovers
	fade_refused_far = ambience.fade_refused_far
	fade_refused_full = ambience.fade_refused_full
	fade_refused_state = ambience.fade_refused_state
	fade_deferred = ambience.fade_deferred
	fade_packets = ambience.fade_packets
	fade_ms = ambience.fade_ms
	clip_refreshes = ambience.clip_refreshes
	clip_refresh_fast = ambience.clip_refresh_fast
	clip_refresh_full = ambience.clip_refresh_full
	clip_refresh_coalesced = ambience.clip_refresh_coalesced
	clip_refresh_deferred = ambience.clip_refresh_deferred
	clip_refresh_timeouts = ambience.clip_refresh_timeouts
	clip_refresh_queued = ambience.clip_refresh_queued
	clip_refresh_ms = ambience.clip_refresh_ms
	standing_skipped = ambience.standing_skipped
	standing_active_skipped = ambience.standing_active_skipped
	standing_pending_skipped = ambience.standing_pending_skipped
	tick_services = ambience.tick_services
	tick_standing_hits = ambience.tick_standing_hits
	walks_turf = ambience.walks_turf
	walks_version = ambience.walks_version
	walks_volume = ambience.walks_volume
	index_changes = ambience.index_changes
	queue_served = ambience.queue_served
	queue_wait_total = ambience.queue_wait_total
	queue_deferred_ticks = ambience.queue_deferred_ticks
	services_dropped_tick = ambience.services_dropped_tick
	services_dropped_count = ambience.services_dropped_count
	ticks_dropping = ambience.ticks_dropping
	services_total = ambience.services_total
	occlusion_checks_total = ambience.occlusion_checks_total
	occlusion_corners = ambience.occlusion_corners
	runner_up_silenced = ambience.runner_up_silenced
	tile_cache_hits = ambience.tile_cache_hits
	tile_cache_misses = ambience.tile_cache_misses
	tile_cache_cleared = ambience.tile_cache_cleared
	tile_cache_checks = ambience.tile_cache_checks
	tile_cache_mismatches = ambience.tile_cache_mismatches
	tile_cache_invalidation_ms = ambience.tile_cache_invalidation_ms

/client/proc/point_ambience_counters()
	set category = "Debug"
	set name = "Point Ambience Counters"
	if(!check_rights(R_DEBUG))
		return
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Point Ambience Counters") // If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	var/datum/point_ambience_counters/snapshot = GLOB.point_ambience_counters
	if(!snapshot)
		var/counter_mode = alert(src, "Timing only keeps gate observation out of the movement hook. Timing + Gate counts safe cached-silence opportunities without skipping services.", "Point Ambience Counters", "Timing Only", "Timing + Gate", "Cancel")
		if(!counter_mode || counter_mode == "Cancel")
			return
		SSpoint_ambience.measure_move_gate = (counter_mode == "Timing + Gate")
		GLOB.point_ambience_counters = new
		to_chat(src, span_notice("Point ambience counters: <b>start marked, timing on.</b> Gate observation is [SSpoint_ambience.measure_move_gate ? "on" : "off"]; it skips no services. Clear stops timing and observation. Run the verb again whenever you want the stretch since now."))
		return
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	var/seconds = (world.time - snapshot.time) / 10
	if(seconds < 10)
		to_chat(src, span_warning("Point ambience counters: only [round(seconds)] s since the snapshot. Give it longer."))
		return
	if(ambience.started_at > snapshot.time)
		GLOB.point_ambience_counters = new
		to_chat(src, span_warning("Point ambience counters: the subsystem restarted since the snapshot. Taken again from now."))
		return
	snapshot.report(src)
	switch(alert(src, "Keep: measure from the same start, so the window keeps growing.\nRestart: measure a fresh window from now.\nClear: stop timing and gate observation until someone runs this again.\n\nThe gate observer reads existing state without skipping services. Its work runs in the movement hook, outside the component timers.", "Point Ambience Counters", "Keep", "Restart", "Clear"))
		if("Restart")
			GLOB.point_ambience_counters = new
			to_chat(src, span_notice("Point ambience counters: new start marked, timing still on. Gate observation is [ambience.measure_move_gate ? "on" : "off"]."))
		if("Clear")
			GLOB.point_ambience_counters = null
			ambience.measure_move_gate = FALSE
			to_chat(src, span_notice("Point ambience counters: cleared, <b>timing and gate observation off.</b> The next run marks a fresh start."))

/// Prints this snapshot through the Counters report without prompting or resetting counters
/datum/point_ambience_counters/proc/report(client/recipient)
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	var/datum/point_ambience_counters/snapshot = src
	var/seconds = (world.time - time) / 10
	if(!recipient || seconds <= 0 || ambience.started_at > time)
		return
	var/minutes = seconds / 60
	var/walks = ambience.standing_walks - snapshot.standing_walks
	var/tick_services = ambience.tick_services - snapshot.tick_services
	var/tick_hits = ambience.tick_standing_hits - snapshot.tick_standing_hits
	var/skipped = ambience.standing_skipped - snapshot.standing_skipped
	var/visits = tick_services + skipped
	var/players = walks ? visits / walks : 0
	var/moves = ambience.moves_total - snapshot.moves_total
	var/drained = ambience.drain_services - snapshot.drain_services
	var/inline_services = ambience.move_services - snapshot.move_services
	var/drain_ms = ambience.drain_ms - snapshot.drain_ms
	var/walk_ms = ambience.standing_walk_ms - snapshot.standing_walk_ms
	var/queue_on = ambience.use_queue

	var/list/lines = list()
	lines += "Point ambience: [round(minutes, 0.1)] min, [round(players)] players, queue [queue_on ? "on" : "off"], budget [ambience.max_services_per_tick], interval [ambience.move_service_interval], skip [ambience.standing_skip]"
	lines += "&nbsp;&nbsp;now, [point_ambience_conditions()]"
	var/gate_checked = ambience.move_gate_counts["checked"] - snapshot.move_gate_counts["checked"]
	var/gate_silent = ambience.move_gate_counts["silent"] - snapshot.move_gate_counts["silent"]
	var/list/gate_exclusions = list()
	for(var/reason in ambience.move_gate_counts)
		if(reason == "checked" || reason == "silent")
			continue
		var/count = ambience.move_gate_counts[reason] - snapshot.move_gate_counts[reason]
		if(count)
			gate_exclusions += "[reason] [count]"
	lines += "&nbsp;&nbsp;gate observation [ambience.measure_move_gate ? "on" : "off"] now: [gate_checked] movement requests after the interval check, [gate_silent] cached-silence opportunities ([round(gate_silent / max(gate_checked, 1) * 100, 0.1)]%); no services skipped"
	if(length(gate_exclusions))
		lines += "&nbsp;&nbsp;gate exclusions, first matching reason: [gate_exclusions.Join(", ")]"
	if(gate_checked)
		lines += "&nbsp;&nbsp;<i>Gate counts describe the current schedule, not predicted savings. Observation work is outside component timings and may affect execution warmth. Set measure_move_gate to FALSE and start a fresh window for timing comparisons.</i>"
	var/cache_hits = ambience.tile_cache_hits - snapshot.tile_cache_hits
	var/cache_misses = ambience.tile_cache_misses - snapshot.tile_cache_misses
	var/cache_cleared = ambience.tile_cache_cleared - snapshot.tile_cache_cleared
	var/cache_invalidation_ms = ambience.tile_cache_invalidation_ms - snapshot.tile_cache_invalidation_ms
	var/clip_ms = ambience.clip_refresh_ms - snapshot.clip_refresh_ms
	var/fade_ms = ambience.fade_ms - snapshot.fade_ms
	var/service_ms = drain_ms + walk_ms
	var/tracked_ms = service_ms + clip_ms + fade_ms + cache_invalidation_ms
	if(cache_hits || cache_misses || cache_cleared)
		lines += "&nbsp;&nbsp;tile rankings, all callers: [cache_hits] hits, [cache_misses] misses ([round(cache_hits / max(cache_hits + cache_misses, 1) * 100, 0.1)]% hit), [cache_cleared] entries cleared, [ambience.tile_cache_entries] live entries / [length(ambience.tile_cache)] visited positions; [ambience.tile_cache_checks - snapshot.tile_cache_checks] verified, [ambience.tile_cache_mismatches - snapshot.tile_cache_mismatches] mismatches; invalidation [round(cache_invalidation_ms / seconds, 0.001)] ms/s additional to service timings"
	if(ambience.verify_tile_cache)
		lines += "&nbsp;&nbsp;<i>Cache verification repeats rankings on hits. Turn it off before timing savings.</i>"
	if(queue_on)
		lines += "&nbsp;&nbsp;total tracked cost [round(tracked_ms / seconds, 0.001)] ms/s (services [round(service_ms / seconds, 0.001)], clip refresh [round(clip_ms / seconds, 0.001)], fades [round(fade_ms / seconds, 0.001)], cache invalidation [round(cache_invalidation_ms / seconds, 0.001)])"
		lines += "&nbsp;&nbsp;service cost: steps [round(drain_ms / seconds, 0.001)] ms/s, standing [round(walk_ms / seconds, 0.001)] ms/s"
	else
		lines += "&nbsp;&nbsp;tracked subtotal [round(tracked_ms / seconds, 0.001)] ms/s; inline movement services are not timed while the queue is off"
		lines += "&nbsp;&nbsp;service cost: standing [round(walk_ms / seconds, 0.001)] ms/s, steps not timed"
	if(players)
		lines += "&nbsp;&nbsp;per player: [round(moves / seconds / players, 0.01)] steps/s, [round((drained + inline_services) / seconds / players, 0.01)] served/s"
	var/clip_refreshes = ambience.clip_refreshes - snapshot.clip_refreshes
	var/clip_fast = ambience.clip_refresh_fast - snapshot.clip_refresh_fast
	var/clip_full = ambience.clip_refresh_full - snapshot.clip_refresh_full
	var/clip_coalesced = ambience.clip_refresh_coalesced - snapshot.clip_refresh_coalesced
	var/clip_deferred = ambience.clip_refresh_deferred - snapshot.clip_refresh_deferred
	var/clip_timeouts = ambience.clip_refresh_timeouts - snapshot.clip_refresh_timeouts
	var/clip_queued = ambience.clip_refresh_queued - snapshot.clip_refresh_queued
	lines += "&nbsp;&nbsp;clip refresh: [clip_refreshes] boundaries; [clip_queued] queued, [clip_deferred] deferred; [clip_coalesced] absorbed by another service, [clip_timeouts] timeout callbacks; outcomes [clip_fast] category-only, [clip_full] full service. Callback path [round(clip_ms / seconds, 0.001)] ms/s[clip_refreshes ? ", [round(clip_ms * 1000 / clip_refreshes, 0.1)] us per boundary including timeouts" : ""]. Queued service cost is included in the drain; absorbed work stays in its serving path."
	// Fades run in fire(), outside the drain and walk timers, so this cost is additional to the
	// line above. A fade out's first step is timed in its service, so the us figure divides fire()'s
	var/fade_out_starts = (ambience.fade_range_starts - snapshot.fade_range_starts) + (ambience.fade_wall_starts - snapshot.fade_wall_starts)
	var/fade_in_starts = ambience.fade_in_starts - snapshot.fade_in_starts
	var/fade_skipped = ambience.fade_skipped - snapshot.fade_skipped
	var/fade_refused_far = ambience.fade_refused_far - snapshot.fade_refused_far
	var/fade_refused_full = ambience.fade_refused_full - snapshot.fade_refused_full
	var/fade_refused_state = ambience.fade_refused_state - snapshot.fade_refused_state
	var/fade_refused = fade_refused_far + fade_refused_full + fade_refused_state
	var/fade_packets = ambience.fade_packets - snapshot.fade_packets
	if(fade_out_starts || fade_in_starts || fade_skipped || fade_refused || fade_packets)
		lines += "&nbsp;&nbsp;fade: [fade_out_starts] out ([ambience.fade_range_starts - snapshot.fade_range_starts] range, [ambience.fade_wall_starts - snapshot.fade_wall_starts] wall), [fade_in_starts] in, [ambience.fade_takeovers - snapshot.fade_takeovers] picked up mid fade, [fade_skipped] too quiet to fade, [fade_refused] cut instead ([fade_refused_far] too far or another floor, [fade_refused_full] list full, [fade_refused_state] nothing to fade from), [ambience.fade_deferred - snapshot.fade_deferred] steps deferred, [fade_packets + fade_out_starts] packets, [round(fade_ms / seconds, 0.001)] ms/s[fade_packets ? ", [round(fade_ms * 1000 / fade_packets, 0.1)] us a timed step" : ""] (steps [ambience.fade_steps] out, [ambience.fade_in_steps] in, ratio [ambience.fade_ratio], skip [ambience.fade_skip], budget [ambience.fade_budget] a run)"
	if(drained)
		var/buckets = length(ambience.drain_density_count)
		var/density_total = 0
		var/list/density = new /list(buckets)
		for(var/i in 1 to buckets)
			density[i] = (ambience.drain_density_count[i] || 0) - (snapshot.drain_density_count[i] || 0)
			density_total += density[i]
		var/median = null
		var/ninetieth = 0
		var/seen = 0
		for(var/i in 1 to buckets)
			seen += density[i]
			if(isnull(median) && seen >= density_total * 0.5)
				median = i - 1
			if(seen >= density_total * 0.9)
				ninetieth = i - 1
				break
		var/density_line = density_total ? ", [median] candidates (90th [ninetieth]), [round(density[1] / density_total * 100)]% empty across [density_total] fresh rankings" : ""
		lines += "&nbsp;&nbsp;step: [round(drain_ms * 1000 / drained)] us, [round((ambience.drain_sends - snapshot.drain_sends) / drained, 0.01)] sends[density_line]"
		var/static/list/size_names = list("1", "2", "3-4", "5-8", "9+")
		var/list/bucket_parts = list()
		var/list/bucket_services = list()
		var/list/bucket_us = list()
		var/timed_services = 0
		for(var/i in 1 to length(size_names))
			var/services_in = ambience.drain_size_services[i] - snapshot.drain_size_services[i]
			var/ms_in = ambience.drain_size_ms[i] - snapshot.drain_size_ms[i]
			bucket_services += services_in
			bucket_us += services_in ? ms_in * 1000 / services_in : 0
			timed_services += services_in
			bucket_parts += "[size_names[i]]: " + (services_in ? "[round(bucket_us[i])] us x[services_in]" : "none")
		lines += "&nbsp;&nbsp;batched: [bucket_parts.Join(", ")]"
		// What the batching buys, from the counts above and nothing sampled. A service drained alone
		// pays the cold start, so the solo bucket prices every service as if nothing ran beside it
		var/drain_total = ambience.drains - snapshot.drains
		// One mover never shares a drain, and a saving of 0 would read as batching buying nothing
		// rather than having nothing to compare
		if(timed_services && bucket_services[1] == timed_services)
			lines += "&nbsp;&nbsp;batches: every service ran alone this window, so there is nothing to compare. It takes two or more movers served in the same tick."
		else if(timed_services && drain_total)
			var/services_seen = 0
			var/median_size = size_names[1]
			for(var/i in 1 to length(size_names))
				services_seen += bucket_services[i]
				if(services_seen >= timed_services * 0.5)
					median_size = size_names[i]
					break
			var/deferred = ambience.queue_deferred_ticks - snapshot.queue_deferred_ticks
			var/batch_line = "batches: [round(drained / drain_total, 0.01)] services a drain, half of all services in drains of [median_size] or more, [round(deferred / drain_total * 100, 0.1)]% of drains stopped at the budget of [ambience.max_services_per_tick]"
			if(bucket_services[1])
				var/alone_us = bucket_us[1]
				var/saved_us = alone_us * timed_services - drain_ms * 1000
				batch_line += ", [round(saved_us / timed_services, 0.1)] us a service saved against all at the solo price ([round(saved_us / (alone_us * timed_services) * 100, 0.1)]%)"
				if(bucket_services[2])
					batch_line += ", the second of a pair [round(2 * bucket_us[2] - alone_us)] us against [round(alone_us)] alone"
			lines += "&nbsp;&nbsp;[batch_line]"
	if(queue_on)
		var/served = ambience.queue_served - snapshot.queue_served
		var/drain_count = ambience.drains - snapshot.drains
		var/wait_ticks = served ? (ambience.queue_wait_total - snapshot.queue_wait_total) / served / world.tick_lag : 0
		var/tick_used = drain_count ? (ambience.drain_tick_usage_total - snapshot.drain_tick_usage_total) / drain_count : 0
		lines += "&nbsp;&nbsp;queue: wait [round(wait_ticks, 0.01)] ticks, deferred [ambience.queue_deferred_ticks - snapshot.queue_deferred_ticks], paused [ambience.drain_paused - snapshot.drain_paused], tick [round(tick_used)]% used at drain"
		lines += "&nbsp;&nbsp;&nbsp;&nbsp;<i>this round, not this window: longest wait [round(ambience.queue_wait_max / world.tick_lag)] ticks, deepest [ambience.queue_depth_max]. A maximum cannot be subtracted, so these two can predate the start mark.</i>"
	else if(ambience.max_services_per_tick)
		var/refused_tick = ambience.services_dropped_tick - snapshot.services_dropped_tick
		var/refused_count = ambience.services_dropped_count - snapshot.services_dropped_count
		var/refused = refused_tick + refused_count
		var/refused_percent = (inline_services + refused) ? refused / (inline_services + refused) * 100 : 0
		lines += "&nbsp;&nbsp;cap: refused [round(refused_percent, 0.1)]% (tick [refused_tick], count [refused_count]), [ambience.ticks_dropping - snapshot.ticks_dropping] dropping ticks, longest run [ambience.longest_drop_run]"
	var/walked = tick_services - tick_hits
	var/index_walks = ambience.walks_version - snapshot.walks_version
	var/index_ms = visits ? walk_ms * index_walks / visits : 0
	if(visits)
		var/moved_walks = ambience.walks_turf - snapshot.walks_turf
		var/volume_walks = ambience.walks_volume - snapshot.walks_volume
		var/list/causes = list()
		for(var/list/cause in list(list("moved", moved_walks), list("index", index_walks), list("volume", volume_walks), list("no turf", walked - moved_walks - index_walks - volume_walks)))
			if(cause[2] > 0)
				causes += "[cause[1]] [round(cause[2] / max(walked, 1) * 100, 0.1)]"
		lines += "&nbsp;&nbsp;standing: [round(skipped / visits * 100, 0.1)]% skipped, [round(walked / visits * 100, 0.1)]% walked ([causes.Join(", ")]), [round(walk_ms * 1000 / visits, 0.1)] us a visit"
		lines += "&nbsp;&nbsp;active movement avoided [ambience.standing_active_skipped - snapshot.standing_active_skipped] additional standing services; queued work avoided [ambience.standing_pending_skipped - snapshot.standing_pending_skipped]"
	var/burning_down = 0
	for(var/obj/machinery/light/rogue/fire in GLOB.fires_list)
		if(initial(fire.fueluse) <= 0 || fire.fueluse <= 0)
			continue
		var/seconds_left = fire.fueluse / 5
		if(seconds_left <= 30 * 60)
			burning_down++
	var/index_share = (queue_on && drain_ms + walk_ms) ? " ([round(index_ms / (drain_ms + walk_ms) * 100, 0.1)]% of cost)" : ""
	lines += "&nbsp;&nbsp;index changes [round((ambience.index_changes - snapshot.index_changes) / minutes, 0.1)]/min, [round(index_ms / seconds, 0.01)] ms/s[index_share], [burning_down] fires burn down within 30 min"
	var/all_services = ambience.services_total - snapshot.services_total
	var/checks = ambience.occlusion_checks_total - snapshot.occlusion_checks_total
	if(all_services && checks)
		var/blocked = ambience.runner_up_silenced - snapshot.runner_up_silenced
		var/corners = ambience.occlusion_corners - snapshot.occlusion_corners
		lines += "&nbsp;&nbsp;walls: [round(checks / all_services, 0.01)] checks per service, [round(blocked / checks * 100, 0.1)]% blocked, [round(corners / checks * 100, 0.1)]% corners"
	if(GLOB.point_ambience_survey)
		lines += "&nbsp;&nbsp;survey running: its loops run inside the drain, so step and batched are both inflated"
	to_chat(recipient, lines.Join("<br>"))
