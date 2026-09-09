GLOBAL_DATUM(point_ambience_counters, /datum/point_ambience_counters)

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
	var/walks_mastervol
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
	walks_mastervol = ambience.walks_mastervol
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
		for(var/i in 1 to length(size_names))
			var/bucket_services = ambience.drain_size_services[i] - snapshot.drain_size_services[i]
			var/bucket_ms = ambience.drain_size_ms[i] - snapshot.drain_size_ms[i]
			bucket_parts += "[size_names[i]]: " + (bucket_services ? "[round(bucket_ms * 1000 / bucket_services)] us x[bucket_services]" : "none")
		lines += "&nbsp;&nbsp;batched: [bucket_parts.Join(", ")]"
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
		var/volume_walks = ambience.walks_mastervol - snapshot.walks_mastervol
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
