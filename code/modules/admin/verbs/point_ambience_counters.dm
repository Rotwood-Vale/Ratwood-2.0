GLOBAL_DATUM(point_ambience_counters, /datum/point_ambience_counters)

/**
 * What a point ambience measurement depends on besides the code, as one line to print beside a result.
 *
 * Each listener's slider under Master decides the volume sent and, once sends below a threshold
 * stop, how many sends happen at all. Muted and observing clients are passed over entirely. The
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
			var/slider = listener_client.prefs ? "[listener_client.prefs.pointambiencevol] at Master [listener_client.prefs.overallvol]" : "no prefs"
			sliders[slider] = (sliders[slider] || 0) + 1
	var/list/slider_parts = list()
	for(var/slider in sliders)
		slider_parts += "[slider] x[sliders[slider]]"
	var/list/source_parts = list()
	for(var/datum/point_ambience_category/category as anything in ambience.categories)
		var/count = ambience.source_counts[category] || 0
		if(count)
			source_parts += "[category.config_name] [count] at [category.volume]"
	return "conditions: [listening] listening (slider [length(slider_parts) ? slider_parts.Join(", ") : "none"]), [muted] muted, [observing] observing; interval [ambience.move_service_interval], running [ambience.move_service_interval_running_override], skip [ambience.standing_skip], budget [ambience.max_services_per_tick], cutoff [ambience.send_cutoff], queue [ambience.use_queue ? "on" : "off"], cross floor [ambience.cross_floor ? "on" : "off"]; sources, count at volume: [source_parts.Join(", ")]"

/datum/point_ambience_counters
	var/time
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
	var/standing_skipped
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

/datum/point_ambience_counters/New()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	time = world.time
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
	standing_skipped = ambience.standing_skipped
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

/client/proc/point_ambience_counters()
	set category = "Debug"
	set name = "Point Ambience Counters"
	if(!check_rights(R_DEBUG))
		return
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Point Ambience Counters") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!
	var/datum/point_ambience_counters/snapshot = GLOB.point_ambience_counters
	if(!snapshot)
		GLOB.point_ambience_counters = new
		to_chat(src, span_notice("Point ambience counters: <b>start marked, timing on.</b> The subsystem counts services and sends whatever happens; marking a start also switches on the two timers that fill the ms figures, and Clear switches them back off. Run the verb again whenever you want the stretch since now."))
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
	if(queue_on)
		lines += "&nbsp;&nbsp;cost [round((drain_ms + walk_ms) / seconds, 0.01)] ms/s (steps [round(drain_ms / seconds, 0.01)], standing [round(walk_ms / seconds, 0.01)])"
	else
		lines += "&nbsp;&nbsp;cost: standing [round(walk_ms / seconds, 0.01)] ms/s, steps not timed (queue off)"
	if(players)
		lines += "&nbsp;&nbsp;per player: [round(moves / seconds / players, 0.01)] steps/s, [round((drained + inline_services) / seconds / players, 0.01)] served/s"
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
		var/density_line = density_total ? ", [median] candidates (90th [ninetieth]), [round(density[1] / density_total * 100)]% empty" : ""
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
	to_chat(src, lines.Join("<br>"))
	switch(alert(src, "Keep: measure from the same start, so the window keeps growing.\nRestart: measure a fresh window from now.\nClear: stop timing until someone runs this again.\n\nOnly Clear changes anything the server does. The counts cost nothing and run regardless; the ms figures need two FFI timer calls a tick, which is why they follow the snapshot.", "Point Ambience Counters", "Keep", "Restart", "Clear"))
		if("Restart")
			GLOB.point_ambience_counters = new
			to_chat(src, span_notice("Point ambience counters: new start marked, timing still on."))
		if("Clear")
			GLOB.point_ambience_counters = null
			to_chat(src, span_notice("Point ambience counters: cleared, <b>timing off.</b> The next run marks a fresh start and switches it back on."))
