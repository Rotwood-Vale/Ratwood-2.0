/**
 * Cumulative point-ambience counters read by the Server verb and tests.
 *
 * Subsystem replacement creates a fresh metrics datum, so snapshots from the previous instance must
 * be discarded.
 *
 * The *_usage fields sum TICK_USAGE deltas across calls, measured as percentages of a tick. They
 * cover the subsystem phases and exclude inline movement servicing when use_queue is disabled.
 */
/datum/point_ambience_metrics
	var/tile_cache_hits = 0
	var/tile_cache_misses = 0
	var/fade_packets = 0
	var/runner_up_silenced = 0
	/// Every service, the standing walk's included. The drain reads it around each service it calls,
	/// since a muted client returns before counting
	var/services_total = 0
	/// Services that reused the standing shortcut, including calls outside the standing sweep
	var/shortcut_hits = 0
	var/standing_walk_hits = 0
	/// Actual source-index changes, separate from static_version invalidations caused by settings
	/// or cache resets
	var/index_changes = 0
	/// Wall walks across the round, probes included
	var/occlusion_checks_total = 0
	/// Door tile change notifications, before deduplication or recheck filtering
	var/door_changes = 0
	/// Listeners queued by a door gather after its range and cached-path filters
	var/door_listeners_marked = 0
	/// Cumulative TICK_USAGE for the queue drain. The following fields track the other phases
	var/drain_usage = 0
	var/walk_usage = 0
	var/fade_usage = 0
	var/door_usage = 0
	var/river_fill_usage = 0
	/// Non-standing services with no in-range sources and no active playback
	var/moving_silent = 0
	/// Services rejected because the listener was muted, including requests queued before muting
	var/muted_services_refused = 0
	var/sends_total = 0
	/// Services that passed the unchanged-standing shortcut and resolved sources. Denominator for
	/// sends and occlusion checks
	var/services_ranked = 0
	/// The longest queue wait since the Server verb last started a window
	var/queue_wait_window_max = 0
	/// Drains, and the services in them, by how many ran together: 1, 2, 3 to 4, 5 to 8, 9 or more
	var/list/drain_size_drains = list(0, 0, 0, 0, 0)
	var/list/drain_size_services_total = list(0, 0, 0, 0, 0)
	/// Move-hook services refused, by which gate
	var/services_dropped_tick_usage = 0
	var/services_dropped_budget = 0
	var/queue_served = 0
	var/queue_wait_total = 0
	/// Fires that hit the budget with entries still waiting
	var/queue_deferred_ticks = 0
	var/moves_total = 0
	var/move_services = 0
	var/drains = 0
	var/drain_services = 0
	var/drain_paused = 0
	var/standing_skipped = 0
	/// Listeners silenced for moving faster than a natural run
	var/speed_silences = 0
	/// Standing-sweep cache misses grouped by changed turf, source version or effective volume
	var/standing_walk_miss_turf = 0
	var/standing_walk_miss_version = 0
	var/standing_walk_miss_volume = 0

	var/tile_cache_mismatches = 0
	var/bulk_scopes = 0
	var/bulk_leaks = 0
	var/unbatched_bursts = 0
