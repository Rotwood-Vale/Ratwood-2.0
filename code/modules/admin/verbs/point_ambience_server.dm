/**
 * Point ambience on a live server: what it costs and what it does across every player, from counts
 * the subsystem keeps anyway. Nothing here times, observes or switches anything on, so opening it
 * changes nothing it reports. The first use starts a window and later ones report since its start.
 *
 * Cost is world.tick_usage summed over each phase of fire(). Outside it are inline services, with
 * the queue off, and the move hook's marks and index changes, which are small
 */
GLOBAL_DATUM(point_ambience_server_window, /datum/point_ambience_server_window)

/// The counts at the start of a window, which a report subtracts from the current ones
/datum/point_ambience_server_window
	var/time
	var/list/counts

/datum/point_ambience_server_window/New()
	time = world.time
	counts = point_ambience_server_counts()
	SSpoint_ambience.queue_wait_window_max = 0

/client/proc/point_ambience_server()
	set category = "Debug"
	set name = "Point Ambience Server"
	if(!check_rights(R_DEBUG))
		return
	var/datum/point_ambience_server_window/window = GLOB.point_ambience_server_window
	if(!window || SSpoint_ambience.started_at > window.time)
		GLOB.point_ambience_server_window = new
		to_chat(src, span_notice("Point ambience server: window started."))
		return
	var/choice = input(src, "Window open for [round((world.time - window.time) / 10)] s.", "Point Ambience Server") as null|anything in list("Report", "Report and start a new window")
	if(!choice)
		return
	to_chat(src, point_ambience_server_report(window))
	if(choice == "Report and start a new window")
		GLOB.point_ambience_server_window = new

/// Every count a report reads, by name
/proc/point_ambience_server_counts()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	return list(
		"drain_usage" = ambience.drain_usage,
		"walk_usage" = ambience.walk_usage,
		"fade_usage" = ambience.fade_usage,
		"door_usage" = ambience.door_usage,
		"steps" = ambience.moves_total,
		"moving" = ambience.drain_services + ambience.move_services,
		"drains" = ambience.drains,
		"skipped" = ambience.standing_skipped,
		"cached" = ambience.standing_walk_hits,
		"walked" = ambience.standing_walk_miss_turf + ambience.standing_walk_miss_version + ambience.standing_walk_miss_volume,
		"ranked" = ambience.services_ranked,
		"silent" = ambience.moving_silent,
		"sends" = ambience.sends_total,
		"checks" = ambience.occlusion_checks_total,
		"blocked" = ambience.runner_up_silenced,
		"waited" = ambience.queue_wait_total,
		"served" = ambience.queue_served,
		"deferred" = ambience.queue_deferred_ticks,
		"paused" = ambience.drain_paused,
		"dropped" = ambience.services_dropped_tick_usage + ambience.services_dropped_budget,
		"fade_packets" = ambience.fade_packets,
		"hits" = ambience.tile_cache_hits,
		"misses" = ambience.tile_cache_misses,
		"index" = ambience.index_changes,
		"doors" = ambience.door_changes,
		"reserved" = ambience.door_listeners_marked,
		"speed" = ambience.speed_silences,
		"muted_refused" = ambience.muted_services_refused,
		"drain_size_drains" = ambience.drain_size_drains.Copy(),
		"drain_size_services_total" = ambience.drain_size_services_total.Copy(),
	)

/proc/point_ambience_server_report(datum/point_ambience_server_window/window)
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	var/list/now = point_ambience_server_counts()
	var/list/was = window.counts
	var/list/delta = list()
	for(var/key in now)
		if(!islist(now[key]))
			delta[key] = now[key] - was[key]
	var/seconds = max((world.time - window.time) / 10, 1)
	var/listening = 0
	var/muted = 0
	var/moving_now = 0
	for(var/client/listener_client as anything in GLOB.clients)
		if(!listener_client.mob || isobserver(listener_client.mob) || isnewplayer(listener_client.mob))
			continue
		if(listener_client.point_ambience_silenced)
			muted++
			continue
		listening++
		if(!isnull(listener_client.point_ambience_last_move) && world.time - listener_client.point_ambience_last_move < 2 SECONDS)
			moving_now++
	var/drain_ms = TICK_DELTA_TO_MS(delta["drain_usage"]) / seconds
	var/walk_ms = TICK_DELTA_TO_MS(delta["walk_usage"]) / seconds
	var/fade_ms = TICK_DELTA_TO_MS(delta["fade_usage"]) / seconds
	var/door_ms = TICK_DELTA_TO_MS(delta["door_usage"]) / seconds
	var/total_ms = drain_ms + walk_ms + fade_ms + door_ms
	var/ranked = delta["ranked"]
	var/checks = delta["checks"]
	var/list/drain_size_drains = now["drain_size_drains"]
	var/list/drain_size_services_total = now["drain_size_services_total"]
	var/list/was_drains = was["drain_size_drains"]
	var/list/was_services = was["drain_size_services_total"]
	var/batched_services = 0
	var/list/shares = list()
	for(var/i in 1 to length(drain_size_services_total))
		batched_services += drain_size_services_total[i] - was_services[i]
	var/static/list/batch_names = list("1", "2", "3-4", "5-8", "9+")
	var/batch_drain_total = 0
	for(var/i in 1 to length(drain_size_services_total))
		batch_drain_total += drain_size_drains[i] - was_drains[i]
		shares += "[batch_names[i]] [round((drain_size_services_total[i] - was_services[i]) / max(batched_services, 1) * 100)]%"
	var/lookups = delta["hits"] + delta["misses"]
	var/list/lines = list()
	lines += "<b>Point ambience server</b>, [round(seconds)] s, [listening] listening, [muted] muted, [moving_now] moving now, [round(delta["steps"] / seconds / max(listening, 1), 0.01)] steps/s a player"
	lines += "muted: [muted] players hear nothing by choice | services that reached one [delta["muted_refused"]]"
	lines += "cost ms/s: [round(total_ms, 0.001)] | drain [round(drain_ms, 0.001)] | standing [round(walk_ms, 0.001)] | fades [round(fade_ms, 0.001)] | doors [round(door_ms, 0.001)] | [round(total_ms / 10, 0.01)]% of the server[ambience.use_queue ? "" : " | queue off, moving services not in cost"]"
	lines += "services/s: moving [round(delta["moving"] / seconds, 0.01)] | standing skipped [round(delta["skipped"] / seconds, 0.01)], cached [round(delta["cached"] / seconds, 0.01)], walked [round(delta["walked"] / seconds, 0.01)]"
	lines += "moving silent: [round(delta["silent"] / max(delta["moving"], 1) * 100, 0.1)]%, [round(delta["silent"] / seconds, 0.01)]/s"
	lines += "per ranked service: sends [round(delta["sends"] / max(ranked, 1), 0.01)] | wall checks [round(checks / max(ranked, 1), 0.01)] | blocked [round(delta["blocked"] / max(checks, 1) * 100, 0.1)]%"
	lines += "batching: drains/s [round(delta["drains"] / seconds, 0.01)] | services a drain [round(batched_services / max(batch_drain_total, 1), 0.01)] | services by batch size: [shares.Join(", ")]"
	lines += "queue: wait avg [round(delta["waited"] / max(delta["served"], 1) / world.tick_lag, 0.01)] ticks, max [round(ambience.queue_wait_window_max / world.tick_lag)] | budget hit [round(delta["deferred"] / max(delta["drains"], 1) * 100, 0.1)]% of drains | paused [delta["paused"]] | dropped [delta["dropped"]]"
	lines += "fades/s [round(delta["fade_packets"] / seconds, 0.01)] | tile cache hit [round(delta["hits"] / max(lookups, 1) * 100, 0.1)]% | index changes/min [round(delta["index"] / seconds * 60, 0.1)] | door tile changes/s [round(delta["doors"] / seconds, 0.01)], re-served/s [round(delta["reserved"] / seconds, 0.01)] | speed silenced/s [round(delta["speed"] / seconds, 0.01)]"
	return lines.Join("<br>")
