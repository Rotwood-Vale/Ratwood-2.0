/**
 * Active local survey, or null when no survey is running.
 *
 * These optional hooks let the subsystem compile without the local measurement tools. A survey
 * overrides them to collect movement and service timings.
 */
GLOBAL_DATUM(point_ambience_survey, /datum/point_ambience_survey)

/datum/point_ambience_survey

/// Records a movement event before the move hook applies its service limits
/datum/point_ambience_survey/proc/count_move(atom/movable/mover)
	return

/// Runs and times a service requested by movement or the queue
/datum/point_ambience_survey/proc/time_real_service(client/listener_client)
	return

/**
 * Active local counter snapshot, or null when none is held.
 *
 * The optional counter tool overrides the hook below. The shipped Server verb uses the subsystem's
 * metrics directly.
 */
GLOBAL_DATUM(point_ambience_counters, /datum/point_ambience_counters)

/datum/point_ambience_counters

/// Records whether a movement request could reuse a cached empty ranking. Does not skip services
/datum/point_ambience_counters/proc/observe_move_gate(client/listener_client, mob/listener, discontinuous)
	return

/**
 * # Point Ambience
 *
 * Plays persistent sounds near each listener without giving every emitter its own loop. Active
 * sources share an index. service_client() picks the nearest audible source in every category,
 * then slim_send() updates that category's reserved channel as a native repeat.
 * Rivers use a precomputed path-distance fill instead of indexed speakers.
 *
 * ## Update flow
 *
 * Live mode with the movement queue enabled. Playback continues between server updates.
 *
 * ```text
 * SERVER                                                      CLIENT
 * Movement -> interval/step checks -> queue client
 * Door recheck --------------------> queue client
 * Due clip -> queued service, or wait for movement/timeout
 *
 * fire() -> drain_dirty() -------+
 *        -> standing walk ------+-> service_client()
 *                                      |
 *                                      +-> unchanged: return
 *                                      |
 *                              select/refresh categories
 *                                      |
 *                              live occlusion if needed
 *                                      |
 *                                 slim_send() -- packet ----> start/update
 *                                                               |
 *                                                          keep playing
 *
 * run_fades() / stop_for() ---------------------- packet ----> fade/stop
 * ```
 *
 * Selection can reuse cached rankings or refresh only a due clip. A lost source takes the fade
 * or stop path instead of slim_send(). fire() runs river refills, fades and door rechecks before
 * the queue drain and standing walk, so a fade can finish even without another movement request.
 *
 * ## A service
 *
 * Movement requests are throttled and normally queued. A periodic walk catches skipped final
 * steps. Same-floor selection can read a ranking from tile_cache. On a miss, rank_tile() ranks
 * buckets within max_range of that turf. With the tile cache bypassed, nearest_sources() probes
 * the buckets directly. Ranking uses squared distance and keeps one
 * winner per category. A source's volume override can make a farther source louder, so nearest
 * does not mean loudest. Standing listeners can reuse their last answer. unregister_source()
 * stops a playing source immediately outside a bulk update.
 *
 * ## The index
 *
 * Sources enter or leave the positional buckets when they activate, move or are destroyed.
 * buckets_by_z[z][cell] stores flat entries of x, y, category index and source. The index has no
 * initialization dependency, so registration works during Initialize(). Every registered source
 * must unregister in Destroy.
 *
 * ## A category is one voice
 *
 * Only one source in a category plays for a listener at a time. Different categories play
 * together. Per-source file and volume overrides let sources differ without adding a category,
 * which would reserve another channel and add a send whenever both are audible.
 *
 * ## Scheduling and other sound paths
 *
 * POINT_AMBIENCE_MOVE_INTERVAL and POINT_AMBIENCE_MOVE_STEPS in config/sound.txt seed
 * move_service_interval and move_service_steps. Larger gaps reduce services but delay spatial
 * updates. LIVE serves listeners. FALLBACK gives each eligible source a timer loop and leaves
 * torches and rivers silent. OFF stops playback. The admin mode menu offers LIVE and OFF.
 *
 * Music and gameplay-triggered loops use the separate looping-sound and token APIs. They need
 * source-specific playback rather than a shared category voice.
 *
 * ## Files
 *
 * This file declares settings and shared state and constructs the subsystem. processing.dm owns
 * fire(), queue draining and the standing walk. configuration.dm owns boot settings and mode
 * changes. recovery.dm carries state through subsystem replacement.
 *
 * index.dm maintains emitters, ranking.dm selects candidates and tile_cache.dm shares rankings.
 * service.dm resolves the listener's choices. send.dm builds packets. playback_lifecycle.dm owns
 * clip advancement and stops. fades.dm runs transitions. Listener state and lifecycle live in
 * listener_state.dm and listeners.dm, with detached hearing in hearing.dm.
 *
 * categories.dm defines the voices. river_fill.dm maintains water reach. bulk.dm combines mass
 * source updates. doors.dm queues affected listeners when nearby openings change.
 *
 * ## Diagnostics
 *
 * Point Ambience Server reports activity and timed fire() phases from subsystem counters.
 * Optional local survey and counter hooks are stubs in a normal checkout.
 */
SUBSYSTEM_DEF(point_ambience)
	name = "Point Ambience"
	/// Runs every tick in the background priority bracket, using the remaining tick budget
	wait = 1
	flags = SS_BACKGROUND | SS_TICKER
	/// Initialize builds the river fill, which needs every map and template in place
	init_order = INIT_ORDER_POINT_AMBIENCE

	/// POINT_AMBIENCE_LIVE, FALLBACK or OFF. Use set_mode() to start and stop the required
	/// playback
	var/mode = POINT_AMBIENCE_LIVE
	/// Minimum deciseconds between move-hook services of one client. 0 serves every step
	var/move_service_interval = 0
	/// RUN-intent interval in deciseconds. Zero uses move_service_interval. move_service_steps can
	/// shorten either interval
	var/move_service_interval_running_override = 0
	/// Maximum natural steps between services. Zero disables it. Can shorten the time interval but
	/// never lengthen it
	var/move_service_steps = 0
	/// Whether a listener stepping faster than a natural run hears no point ambience while moving
	var/speed_cutoff = FALSE
	/// Minimum natural running step delay, in deciseconds: configured run delay minus the
	/// speed-stat allowance
	var/natural_run_step = 0
	/// Movement service cap per tick. Zero disables it and the inline tick-usage gate.
	/// Queued work waits for another drain. The standing sweep has its own MC tick checks
	var/max_services_per_tick = 0
	/// Queues requests for fire(), oldest first, up to max_services_per_tick.
	/// Keeps the first request time but serves the client's current position
	var/use_queue = FALSE
	/// Deciseconds between client sweeps, which catch movement skipped by the move hook
	var/standing_walk_interval = 1 SECONDS
	/// Deciseconds the standing sweep skips recently serviced clients. Zero disables it.
	/// Can delay the final position update after a listener stops
	var/standing_skip = 0
	var/clip_coalesce_window = 0.5 SECONDS
	/// Uses shared per-turf source rankings from tile_cache
	var/use_tile_cache = TRUE
	/// Re-ranks cache hits, counts mismatches and repairs them
	var/verify_tile_cache = FALSE
	/// Minimum transmitted volume for an active category. Zero disables the cutoff
	var/send_cutoff = 0
	/// Shared decay hardness for unpinned categories, retained across subsystem recovery
	var/falloff_hardness = 1
	/// Preserves direction near a source using a minimum pan depth. FALSE uses the one-tile dead
	/// zone
	var/pan_depth_floor = TRUE
	/// Maximum exit-fade steps for range exits, blocked paths or the speed cutoff. Zero stops at once.
	/// Removed sources, muted listeners and teleports stop immediately
	var/fade_steps = 3
	/// Entry-fade steps. Zero starts playback at its target volume
	var/fade_in_steps = 2
	/// What each fade step multiplies the volume by. 0.5 is 6 dB a step
	var/fade_ratio = 0.5
	/// Minimum fade volume. Exit fades stop below it. Quieter initial fade steps are not sent
	var/fade_skip = 1
	/// Volume updates per run_fades() call. Deferred fades catch up on the next run.
	/// Stops and final fade-in updates bypass this budget
	var/fade_budget = 8
	/// Maximum per-source pitch variation as a fraction, applied to unique_voice categories. Zero
	/// disables it
	var/voice_pitch = 0.04
	/// Starts unique voices at a position-derived playback offset. Handoffs retain the playing
	/// clip's phase
	var/voice_offset = TRUE
	/// Door policy for direct traces and corner probes. See SOUND_DOORS_*.
	var/door_mode = SOUND_DOORS_LIVE
	/// Queues nearby listeners after door changes, including those with valid standing caches.
	/// Changes gathered together share one refresh per listener
	var/door_recheck = TRUE
	/// Deciseconds between door-change gathers. Queued service may add further delay
	var/door_recheck_period = 5

	/// Category singletons indexed by category.index
	var/list/datum/point_ambience_category/categories = list()
	/// Category type path to singleton
	var/list/categories_by_path = list()
	/// Maximum source volume at zero distance, including overrides. Used with send_cutoff to detect
	/// muted listeners
	var/loudest_volume = 0
	/// Bitmask of categories enabled by server configuration
	var/audible_mask = 0
	/// Fill-only category, served without a source-index lookup
	var/datum/point_ambience_category/river/river_category
	/// The category a mob's self source is served under
	var/datum/point_ambience_category/self_category
	/// Shared, immutable echo parameters for muffled playback.
	/// Clear the sound's echo on an unobstructed path
	var/list/storey_echo

	/// Source buckets by floor and POINT_AMBIENCE_CELL_INDEX, holding flat x/y/category/source records.
	/// Cached coordinates avoid resolving each source's turf during ranking
	var/list/buckets_by_z = list()
	/// Stride between bucket columns, set from world.maxy at first registration.
	/// Must cover every floor's height. Later map growth can overlap column indices
	var/cell_stride = 0
	/// Source to bucket-cell index. source_zs supplies the floor
	var/list/source_keys = list()
	/// Source to registered category
	var/list/source_categories = list()
	/// Largest indexed category range, used to gather candidates before each category's exact range
	/// check
	var/max_range = 0
	/// Number of indexed sources per category
	var/list/source_counts = list()
	/// Source to registered turf, shared by playback, occlusion and invalidation
	var/list/source_turfs = list()
	/// Revision of source selection and listener-affecting settings.
	/// Listener caches compare this revision or check source-change history before reuse
	var/static_version = 0
	/// Source to indexed z-level
	var/list/source_zs = list()

	/// Immutable same-floor rankings keyed by turf, using POINT_AMBIENCE_RANK_* records.
	/// TRUE means empty. null marks an invalidated entry whose key remains until a full clear
	var/list/tile_cache = list()
	/// Non-null rankings in tile_cache. Its length also counts invalidated positions
	var/tile_cache_entries = 0
	/// Scratch winner table used only while constructing one tile-cache entry
	var/list/scratch_tile_best = list()
	var/list/source_change_history = list()

	/// Nested bulk-update depth. Only the outermost close performs deferred cache and listener
	/// cleanup
	var/bulk_depth = 0
	/// world.time when the outermost bulk update opened. A scope left open across ticks is closed
	/// as leaked
	var/bulk_opened_at
	/// Outermost bulk-update label, included in reports of leaked scopes
	var/bulk_label
	/// Number of index changes in the open bulk update
	var/bulk_changes = 0
	/// Sources removed or reassigned during the bulk update, awaiting listener cleanup
	var/list/bulk_affected = list()
	/// Index changes outside any scope within one world.time, for the unbatched burst report
	var/burst_changes = 0
	var/burst_time
	/// A burst before this is counted but not reported again
	var/burst_quiet_until = 0

	/// world.time when the next standing sweep may begin
	var/next_standing_walk = 0
	var/list/currentrun = list()
	/// Slots with a fade in progress, each listed once
	var/list/fading = list()
	/// Earliest pending fade step, in whole deciseconds
	var/fade_next_due = 0
	/// Turfs whose door changed since the last gather, each keyed to TRUE
	var/list/changed_doors = list()
	var/next_door_recheck = 0
	/// Where rivers can be heard, in river_fill.dm. Carried across a rebuilt subsystem
	var/datum/point_ambience_river_fill/river_fill
	/// Whether the per-mob move hook has been attached to the global login signals yet. Done on
	/// the first fire() rather than in New(), which may run before SSdcs exists
	var/hooked_logins = FALSE
	/// Whether configuration has been loaded. Recovery keeps live settings.
	/// Separate from hooked_logins so reattaching signals does not overwrite admin changes
	var/settings_seeded = FALSE
	/// world.time for the current services_this_tick count
	var/services_tick_stamp = 0
	var/services_this_tick = 0
	/// Client to first queued world.time. Repeated requests preserve queue order and waiting time
	var/list/dirty_clients = list()
	/// world.time this instance was built. An MC restart resets it along with every counter, so a
	/// reader holding an older snapshot must throw that away rather than subtract from it
	var/started_at = 0
	/// Whether the standing sweep is currently servicing clients
	var/in_standing_walk = FALSE
	/// Source -> its plain loop while in fallback mode
	var/list/fallback_loops = list()

	/// Reusable ranking distances, cleared for each ranking.
	/// Consume shared scratch results before yielding or making a nested ranking call
	var/list/scratch_best_distsq = list()
	var/list/scratch_uncached = list()
	/// Runner-up source per category for occlusion fallback.
	/// Filled by direct ranking or copied from the tile cache for the current service
	var/list/runner_up_by_category = list()
	var/list/runner_up_distsq = list()
	/// Hearing turf for the current listener, including detached-head hearing.
	/// Read serving_* only after prepare_serving() succeeds. Shortcuts leave them unchanged
	var/turf/serving_turf
	var/serving_environment = SOUND_DEFAULT_ENVIRONMENT
	var/serving_volume_scale
	/// Whether the detached hearing head is enclosed and requires muffled playback
	var/serving_muffle_head = FALSE
	/// Whether the current category is audible around an obstruction.
	/// Reset before resolving each category and read by its send. A fully blocked path stops playback
	var/serving_muffle_wall = FALSE

	/// Cumulative service, playback and scheduling metrics
	var/datum/point_ambience_metrics/metrics

/datum/controller/subsystem/point_ambience/New()
	metrics = new
	river_fill = new
	for(var/category_path in subtypesof(/datum/point_ambience_category))
		var/datum/point_ambience_category/category = new category_path
		categories += category
		category.index = length(categories)
		category.mask = (1 << category.index)
		categories_by_path[category_path] = category
		if(category.type != /datum/point_ambience_category/river)
			max_range = max(max_range, category.range)
		loudest_volume = max(loudest_volume, category.volume)
		category.resolve_derived()
		category.floor_ratio = clamp(category.min_volume / max(category.volume, 1), 0.001, 1)
		category.stop_sound = sound(null, channel = category.channel)
	river_category = categories_by_path[/datum/point_ambience_category/river]
	self_category = categories_by_path[/datum/point_ambience_category/torch]
	refresh_audible_mask()
	// A new instance starts a new metrics window. Snapshots from its predecessor cannot be
	// subtracted
	started_at = world.time
	storey_echo = new /list(18)
	storey_echo[7] = SOUND_MUFFLE_OCCLUSION
	storey_echo[8] = SOUND_MUFFLE_OCCLUSION_LF
	// Category tables must exist before the parent constructor calls Recover()
	. = ..()

/**
 * Builds river reach after maps and templates have initialized.
 *
 * Recovery preserves an existing fill, so a replacement subsystem does not rebuild it. Initial
 * construction happens before live tick processing.
 */
/datum/controller/subsystem/point_ambience/Initialize(start_timeofday)
	if(!river_fill.done)
		river_fill.build()
	return ..()
