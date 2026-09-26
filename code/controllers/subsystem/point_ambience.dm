/// 8-tile cells: three per axis within max_range 8, nine probes a walk. Larger cells probe fewer and
/// rank nearly twice the sources, smaller invert it. Measured, so change it with the Here verb in hand
#define CELL_SHIFT 3
#define POINT_AMBIENCE_SOURCE_CHANGE_FIELDS 10
#define POINT_AMBIENCE_SOURCE_CHANGE_LIMIT 32
/// Index changes in one tick, outside any bulk update, that get the caller reported. A starting
/// heuristic rather than a measured break even
#define POINT_AMBIENCE_BULK_BURST 64

/**
 * # Point Ambience
 *
 * Point-source ambience, served per client. Mapped emitters own no sound loops: each active source
 * sits in one shared index, and this subsystem serves each CLIENT the nearest source per category as
 * a native repeat on that category's reserved channel, through playsound_local.
 *
 * ## A service
 *
 * Movement requests are throttled and normally queued. A periodic client walk catches missed moves.
 * A full service reads a fixed box, the listener's cell
 * expanded by max_range, 24x24 tiles, out of the cell buckets. Ranks what it finds by squared
 * distance, keeps the nearest per category, then sends or updates that channel. Ranking on distance
 * rather than volume is exact because falloff is monotonic, so the nearest is always the loudest and
 * a reject costs two list reads. Standing still reuses the last walk, and deactivating a source
 * silences its channel at once.
 *
 * ## The index
 *
 * Plain data, written only when a source activates, deactivates, moves or is destroyed. Positional,
 * never string keyed: buckets_by_z[z][cell] holds x, y, category index, source per entry. It has no
 * init dependency, so a source registering from Initialize() lands in a valid bucket. Every source
 * MUST unregister in Destroy.
 *
 * ## A category is one voice
 *
 * Sources in it suppress each other. Different categories play together. Per-source sound and volume
 * overrides give a source its own audio without a new category, which costs a reserved channel and a
 * send per service while audible.
 *
 * ## Cost
 *
 * Billed per service, from eligible moves and the periodic client walk. Each service searches a
 * fixed box and serves at most one source per category. Local timings put most cost in overhead, so
 * the lever is FEWER services: at the shipped 7, regular three-decisecond movement is served
 * about once every three steps, paid for in spatial resolution. MODES are the bigger hammer:
 * FALLBACK gives every source a plain timer loop instead, billed per source, volume only on
 * replay, torches silent. OFF is silent. The Point
 * Ambience Mode verb switches live, config seeds at boot.
 *
 * ## Not here
 *
 * Gameplay-gated loops (boiling, relics, spell charges) are tokens and cost nothing idle. Music
 * restarts on a source handoff. Boat bells alternate two files and cannot native-repeat.
 *
 * ## The measurement verbs are not in the repo
 *
 * Comments below cite a Survey, Benchmark, Here, Verify and Send Diff verb, and the measured_* vars
 * are written by them. They are kept out of git deliberately, so in a plain checkout those vars stay
 * zero and the figures quoted here cannot be reproduced without them. Local timing runs used at
 * most two connected clients. Larger population costs are modeled projections, not load tests.
 */

/**
 * Set while a survey is sampling, null otherwise. Declared here rather than with the survey so
 * the subsystem builds whether or not the measurement tooling is present. The hooks below are
 * the whole interface it calls, and the survey overrides them
 */
GLOBAL_DATUM(point_ambience_survey, /datum/point_ambience_survey)

/datum/point_ambience_survey

/// Counts a step. Called before every early return, since steps TAKEN is the billed quantity
/datum/point_ambience_survey/proc/count_move(atom/movable/mover)
	return

/// Times the service a real step causes, in whatever state the tick is actually in
/datum/point_ambience_survey/proc/time_real_service(client/listener_client)
	return

SUBSYSTEM_DEF(point_ambience)
	name = "Point Ambience"
	/**
	 * Every tick, in the background bracket. The dirty set is drained here, and running only in
	 * the tick's slack is what bounds it on a loaded tick. The once-a-second walk over every client
	 * runs behind standing_walk_interval below, not behind this
	 */
	wait = 1
	flags = SS_BACKGROUND | SS_NO_INIT | SS_TICKER
	/**
	 * Deciseconds between full walks over every client. Also the catch-up for a move that
	 * move_service_interval dropped: a gated move returns without servicing and schedules nothing,
	 * so if the gated step is a listener's LAST one nothing serves them until this fires, and this
	 * IS the worst-case silence on stopping at the edge of a range.
	 *
	 * It is also the only thing here that scales with population rather than with movement, since
	 * every client is visited whether they moved or not. Halving it doubles that term and shortens
	 * the silence above by half. Both are small, so set it by ear
	 */
	var/standing_walk_interval = 1 SECONDS
	var/next_standing_walk = 0
	/**
	 * Deciseconds within which a client a step already served is passed over by the walk above,
	 * 0 for never. A walker served by their steps would otherwise be walked again
	 * here every second, at a tile they are about to leave. On a busy server nearly all of that
	 * walk's cost is those. The price is the catch-up above: a client whose last served step fell
	 * inside this window when they stopped waits for the walk after next, so the worst case becomes
	 * this plus standing_walk_interval rather than standing_walk_interval alone
	 */
	var/standing_skip = 0
	var/skip_active_movers = TRUE
	/// Off sends every standing visit through service_client's shortcut instead of the walk's own
	/// copy of it. Kept so the copy can be priced
	var/standing_hoist = TRUE
	var/clip_coalesce_window = 0.5 SECONDS

	var/list/datum/point_ambience_category/categories = list()
	/// category typepath -> its singleton, the form register/unregister callers use
	var/list/categories_by_path = list()
	var/list/currentrun = list()

	/**
	 * Off makes every walk probe the buckets directly instead of ranking the client's cached
	 * per-cell list, so the Here verb can time both on one tile. Keep the switch: it is the only way
	 * to price the cache
	 */
	var/use_cell_cache = TRUE
	/**
	 * Same-floor source rankings shared by every listener on a turf. Each live entry maps to TRUE for no
	 * answer, or an immutable flat run of category, winner, distance squared, runner-up, runner-up
	 * distance squared. Enabled for testing; cross-floor selection keeps the direct or cell-cache path
	 */
	var/use_tile_cache = TRUE
	/// Re-ranks cache hits and repairs mismatches while counting checks and failures
	var/verify_tile_cache = FALSE
	/// Turf-keyed associative cache. Invalidated positions retain their keys until a full clear
	var/list/tile_cache = list()
	/// Non-null rankings in tile_cache; its length also includes invalidated positions
	var/tile_cache_entries = 0
	/// Scratch winner table used only while constructing one tile-cache entry
	var/list/scratch_tile_best = list()
	var/tile_cache_hits = 0
	var/tile_cache_misses = 0
	var/tile_cache_cleared = 0
	var/tile_cache_checks = 0
	var/tile_cache_mismatches = 0
	var/tile_cache_invalidation_ms = 0
	/**
	 * Open bulk source updates, nested ones folded into the outermost, see
	 * begin_bulk_source_update(). Read by source changes and once a fire, never by a service
	 */
	var/bulk_depth = 0
	/// world.time the outermost scope opened. A scope cannot outlive its tick, so depth still up on
	/// a later one means its caller never closed it
	var/bulk_opened_at
	/// The outermost open scope's label, named if it leaks
	var/bulk_label
	/// Index changes inside the open scope, so one that changed nothing flushes nothing
	var/bulk_changes = 0
	/// Sources removed or moved between categories inside the open scope, which the close checks
	/// against what each listener is playing
	var/list/bulk_affected = list()
	var/bulk_scopes = 0
	var/bulk_changes_total = 0
	var/bulk_stops = 0
	var/bulk_leaks = 0
	/// Each close's flush and stop pass. The flush is also inside tile_cache_invalidation_ms
	var/bulk_close_ms = 0
	var/bulk_close_worst_ms = 0
	/// Index changes outside any scope within one world.time, for the unbatched burst report
	var/burst_changes = 0
	var/burst_time
	var/unbatched_bursts = 0
	/// A burst before this is counted but not reported again
	var/burst_quiet_until = 0
	/// Own-floor candidates ranked this service, null when no fresh ranking ran
	var/ranked_candidates_this_service = null
	/**
	 * Positional, never string keyed: buckets_by_z[z] is a list indexed by cell, where a cell is
	 * (x >> CELL_SHIFT) * cell_stride + (y >> CELL_SHIFT) + 1, and each entry is a flat list of
	 * x, y, category index, source per active source in that cell, or null. The walk reads a
	 * source's position and kind straight out of the bucket, so rejecting one is two list reads
	 * and arithmetic and never a lookup. The lookups happen once, when the source registers
	 */
	var/list/buckets_by_z = list()
	/// Moves per second per player, measured by the Survey verb and kept after it stops. Zero until
	/// one has run. The verbs then fall back to 1.38
	var/measured_moves_per_player = 0
	/// Microseconds per service in the Benchmark verb's synthetic batch. Zero until one has run.
	/// This measures the batch, not a populated server. Real client movement and delivery can differ
	var/measured_batched_service_us = 0
	/**
	 * Microseconds a playsound_local() costs, from the Benchmark verb. Zero until one has run. The
	 * survey multiplies it by the sends it counted to price the rest of the sound system, which is
	 * mostly footsteps and which every ambient figure has historically been quoted without
	 */
	var/measured_playsound_local_us = 0
	/**
	 * Microseconds a real cold service costs above the same service measured in a tight loop, from
	 * the survey's same-tile-same-instant pairs. Zero until one has run. Every looped figure in
	 * every verb understates by this, so a projection built on one is low by it per service
	 */
	var/measured_warm_cold_gap_us = 0
	/**
	 * Tiles across one index cell, 1 << CELL_SHIFT. Exposed because a mover crosses a cell every
	 * this many steps and pays a candidate rebuild when they do. A projection built on the per-step
	 * cost without amortising that in is low by the difference over this number
	 */
	var/cell_size = 1 << CELL_SHIFT
	/**
	 * Whether a listener hears sources one storey up or down, muffled. Off by design, ambience not
	 * carrying between floors. The tile cache covers same-floor rankings only, so this keeps the
	 * direct or cell-cache ranking path for the storey passes. Seeded from POINT_AMBIENCE_CROSS_FLOOR
	 */
	var/cross_floor = FALSE
	/**
	 * Sent volume below which a category stops instead of sending, so an inaudible outer ring costs
	 * no packets. 0 is off. A starting value, tuned by ear in View Variables while playing, and the
	 * range edge already cuts from the category floor, 8 or 3, times the effective listener volume
	 */
	var/send_cutoff = 0
	/// The hard decay exponent every unpinned category is currently on. Held here as well as on
	/// the categories so a recovery and the tuning verb have one place to read and write
	var/falloff_hardness = 1
	/// Whether every category is held at the band power curve with no cutoff, for an A/B by ear
	var/original_sound = FALSE
	/// The loudest any category plays at distance 0, so a slider too low to clear send_cutoff can
	/// be recognised as silence and unhooked
	var/loudest_volume = 0
	/// Whether point ambience holds a source at a minimum depth close in instead of zeroing its
	/// direction inside a one tile box. Off restores the dead zone playsound_local still uses
	var/pan_depth_floor = TRUE
	/// Whether a source's direction leans toward the runner-up as the two trade places, so a road of
	/// braziers slides between ears instead of flipping. Volume is untouched: one voice still plays
	var/pan_blend = TRUE
	/**
	 * How many volume steps a sound takes to die away when its listener walks out of its range or
	 * behind a wall, a tenth of a second apart, each fade_ratio of the one before. A cap: the fade
	 * ends early once it is under fade_skip. 0 stops at once, as every other kind of stop still does
	 */
	var/fade_steps = 3
	/// The same for a sound starting from silence, climbing to its volume. 0 starts at full volume
	var/fade_in_steps = 2
	/// What each fade step multiplies the volume by. 0.5 is 6 dB a step
	var/fade_ratio = 0.5
	/// Sent volume under which a fade has nothing left to say. A fade out ends there, and a sound
	/// already under it stops without one, so a listener with a low slider pays for none of this
	var/fade_skip = 1
	/// client, category, client, category: the fades in progress. Flat, so a fade allocates nothing
	var/list/fading = list()
	/**
	 * Fade steps one run of run_fades may send. A step over the budget is not dropped: it waits, and
	 * the next run takes every step it is behind in one packet, so a busy tick makes a fade coarser
	 * and never cuts it. The stop that ends a fade out is outside the budget
	 */
	var/fade_budget = 8
	/// The earliest step due across fading, so fire() enters run_fades only when there is one to
	/// send. Steps fall on whole deciseconds, which lets fades from different listeners share a run
	var/fade_next_due = 0
	/// How far a source's own pitch may lean either way in a category with unique_voice, as a
	/// fraction: 0.04 is 4% deeper and slower to 4% brighter and faster. 0 is off
	var/voice_pitch = 0.04
	/// Whether such a source also plays from its own place in the loop. Off, every entry opens on
	/// the clip's first second and a change of source carries the clip on unbroken
	var/voice_offset = TRUE
	var/fade_range_starts = 0
	var/fade_wall_starts = 0
	var/fade_in_starts = 0
	/// Exits that stopped at once because the sound was already under fade_skip
	var/fade_skipped = 0
	/// Sounds picked up again mid fade out instead of restarted
	var/fade_takeovers = 0
	/// Exits that asked for a fade and were cut instead: the listener was further off than a walk
	/// allows or on another floor, the list was full, or the slot held nothing to fade from
	var/fade_refused_far = 0
	var/fade_refused_full = 0
	var/fade_refused_state = 0
	/// Steps the budget or a spent tick pushed to a later run
	var/fade_deferred = 0
	var/fade_packets = 0
	/// Time inside run_fades, in ms, only while the Counters datum is active
	var/fade_ms = 0
	var/clip_refreshes = 0
	var/clip_refresh_fast = 0
	var/clip_refresh_full = 0
	var/clip_refresh_coalesced = 0
	var/clip_refresh_deferred = 0
	var/clip_refresh_timeouts = 0
	var/clip_refresh_queued = 0
	var/clip_refresh_ms = 0
	/**
	 * Whether a wall between listener and source muffles or silences it, doors included as door_mode
	 * says. Off, a hearth through a keep wall sounds like one in the open. Costs a line walk per
	 * served category, so switching it off is also how to price it
	 */
	var/occlude_sources = TRUE
	/**
	 * How the wall walk treats doors, a SOUND_DOORS_* value. LIVE stops at a shut door on the line
	 * and at the corners, FLANKS only at the corners, ALWAYS at any door that shuts solid, open or
	 * not. Read live wherever a turf's sound_door_count says a door may stand
	 */
	var/door_mode = SOUND_DOORS_LIVE
	/**
	 * Whether a door opening or shutting has the listeners near it served again. Without it a
	 * listener standing still keeps the answer from their last step until they take another.
	 * Changed doors are collected and gathered once a period, so a door worked back and forth costs
	 * one service per listener per period however fast it goes
	 */
	var/door_recheck = TRUE
	/// Deciseconds between door gathers, and so the longest a listener waits to hear a door change
	var/door_recheck_period = 5
	/**
	 * Serves a listener near a changed door only when the door sits in the box between them and the
	 * winner or runner-up of a category walls can block, widened by a tile. Neither the line nor a
	 * corner probe leaves that box, so a door outside it cannot change their answer
	 */
	var/door_recheck_filter = TRUE
	/// Turfs whose door changed since the last gather, as turf -> TRUE
	var/list/changed_doors = list()
	var/next_door_recheck = 0
	/// (world.maxy >> CELL_SHIFT) + 2, fixed at the first register. Only maxx can grow at
	/// runtime, and a larger x only extends a floor's list
	var/cell_stride = 0
	/// source -> its current cell index, with source_zs holding the floor, for O(1) unregister
	/// and rebucketing on move
	var/list/source_keys = list()
	/// source -> the category it belongs to, since the buckets no longer say
	var/list/source_categories = list()
	/// Widest range any category asks for. The shared walk covers this and each source is then
	/// gated on its own category's range, so a short-range kind is filtered rather than searched
	var/max_range = 0
	/// max_range squared, so the walk can gate on squared distance and never take a root
	var/max_range_sq = 0
	/**
	 * How many categories currently have any source at all, so the walk can stop once every
	 * answerable one is answered. Counting all categories instead would mean a kind with nothing
	 * on the map, a fountainless map say, kept every client walking all three floors forever
	 */
	var/list/source_counts = list()
	var/answerable_categories = 0
	/// Whether the per-mob move hook has been attached to the global login signals yet. Done on
	/// the first fire() rather than in New(), which may run before SSdcs exists
	var/hooked_logins = FALSE
	/**
	 * Whether the settings below have been read from config. Separate from hooked_logins because
	 * Recover() carries the settings but must NOT carry the hooks: those are registered against
	 * the datum being replaced and have to be made again, while re-reading config would throw away
	 * whatever an admin set through the Mode verb, which is usually why the MC was restarted
	 */
	var/settings_seeded = FALSE
	/// The category a mob's self source is served under
	var/datum/point_ambience_category/self_category
	/// Source -> its turf at last register. The scan reads this instead of calling get_turf,
	/// which was the costliest statement on the reject path
	var/list/source_turfs = list()
	/**
	 * Scratch for the walk, cleared and refilled per call rather than allocated. Allocation is one of
	 * the dearest things a service does. Safe to share because the walk is SHOULD_NOT_SLEEP, so a
	 * second one cannot begin while the first is using these
	 */
	var/list/scratch_best_distsq = list()
	var/list/scratch_settled = list()
	var/list/scratch_uncached = list()
	/**
	 * The second nearest source per category from the ranking just loaded, and its distance. It lets
	 * occlusion fall through to a clear source. Cleared per service, then filled by a walk or copied
	 * from an immutable tile-cache entry
	 */
	var/list/scratch_second = list()
	var/list/scratch_second_distsq = list()
	/**
	 * The listener a service is for, resolved once per service and read by every send in it: the
	 * turf they hear FROM, the environment their area gives a sound, their point ambience volume as
	 * a factor (null when they have no prefs), and whether their ear is inside something.
	 *
	 * The turf is the ear's, which for a headless dullahan is wherever the head is. Selection and
	 * pricing both use it, so they cannot disagree the way two paths did
	 */
	var/turf/serving_turf
	var/serving_environment = SOUND_DEFAULT_ENVIRONMENT
	var/serving_volume_scale
	/// The ear is shut in a closet or a bag, so everything this service sends is muffled. Dullahans
	/// only: nobody else's ear is ever inside anything
	var/serving_muffle_head = FALSE
	/**
	 * Set per category while it is being resolved, when the direct line is blocked but a line from
	 * beside the obstruction is not: a corner, rather than an enclosure. Nothing counts walls. A
	 * straight run with no way round silences the category instead. Read by the send that follows
	 * immediately, and cleared at the top of every category so
	 * one category's wall cannot muffle the next one's source
	 */
	var/serving_muffle_wall = FALSE
	/// Whether the listener is under a roof, from the same area the environment above is read off.
	/// Only categories that set indoors_volume_mult look at it, the river being the one that cannot
	/// use occlusion: its voices are a line, so the nearest and the runner-up sit behind one wall
	var/serving_indoors = FALSE
	/**
	 * The direction the pan is about to be taken from, leaned between the nearest source and the
	 * runner up. Subsystem vars rather than a returned list because pan_lean has two numbers to
	 * hand back and the walk cannot afford an allocation per send
	 */
	var/serving_lean_dx = 0
	var/serving_lean_dy = 0
	/**
	 * Sends made by the service running right now, reset at the top of each one, read by the survey
	 * beside every timing. Two tiles with the same candidate count but different audible categories
	 * differ by about a send each, so a cost figure without this cannot be compared to another's
	 */
	var/sends_this_service = 0
	/**
	 * Whether the service running right now reached the walk at all, reset with the send count. A
	 * standing shortcut and a listener with no turf both leave the client's candidate list holding
	 * some other cell's, so anything reading it has to know which services ranked a box
	 */
	var/walked_this_service = FALSE
	/**
	 * Whether the service running right now rebuilt its candidate set, reset with the send count.
	 * One step in cell_size does, so if the dear tail of the cost distribution is mostly these,
	 * the spike is the rebuild. If it looks like everything else, the spike is the server
	 */
	var/rebuilt_this_service = FALSE
	/**
	 * Wall walks this service performed and the turfs they stepped through, reset with the send
	 * count. Both halves are needed: a check that finds a wall on the first step and one that walks
	 * eight tiles to find nothing differ by an order of magnitude
	 */
	var/occlusion_checks_this_service = 0
	var/occlusion_tiles_this_service = 0
	/**
	 * Cumulative across the round, for the survey's rates, and incremented only when a winner turned
	 * out occluded: how often the fall-through was reached, how often the runner-up was clear and
	 * served in its place, and how often both were blocked and the category went silent
	 */
	var/runner_up_offered = 0
	var/runner_up_served = 0
	var/runner_up_silenced = 0
	/**
	 * Cumulative like the three above, and the DENOMINATOR they must be read against: they count
	 * every service including the tick's, so dividing by the survey's own timed (move-hook only)
	 * count once reported 800% blocked winners. Checks also cross-check the arithmetic, since
	 * runner_up_offered only increments after a SOLID check and so can never exceed them
	 */
	var/services_total = 0
	/**
	 * Services that returned at the standing shortcut, from any caller. Fire() reads it around each
	 * of its own to fill the two below. Three counters rather than one because the verbs call
	 * service_client themselves, and a global count cannot tell the tick's walks from theirs
	 */
	var/standing_hits = 0
	var/tick_services = 0
	var/tick_standing_hits = 0
	/// Index changes, counted at the register and unregister sites rather than read off
	/// static_version, which the survey and the benchmark bump themselves to force rebuilds
	var/index_changes = 0
	var/occlusion_checks_total = 0
	/**
	 * Cumulative CORNER verdicts, which the counters above never see because a corner is served
	 * muffled rather than blocked. It prices what corners cost: each one is a blocked direct line
	 * plus the side probes has_open_path() ran to find the way round, so this is how often that
	 * second and third walk are paid for
	 */
	var/occlusion_corners = 0
	/**
	 * Cumulative door counts. Changes counts every door opacity change whether or not the re-check
	 * is on, so it measures how often doors move. Then the gathers run, the listeners found in
	 * reach, those the box filter passed on to a service, and the milliseconds the gathers took
	 */
	var/door_changes = 0
	var/door_gathers = 0
	var/door_listeners_found = 0
	var/door_listeners_marked = 0
	var/door_gather_ms = 0
	/**
	 * The echo array a muffled send carries, whether the muffle came from a storey or a corner.
	 * Built once and never written after, so one
	 * list serves every client. A send is snapshotted, so sharing it is safe
	 */
	var/list/storey_echo
	/// POINT_AMBIENCE_LIVE, FALLBACK or OFF. Change through set_mode(), which starts or stops
	/// what the old and new modes need
	var/mode = POINT_AMBIENCE_LIVE
	/// Minimum deciseconds between move-hook services of one client. 0 serves every step
	var/move_service_interval = 0
	/**
	 * Replaces the interval above for a client whose move intent is RUN. NAMED "override" because 0
	 * here means "runners use move_service_interval", NOT "runners are uncapped" as it does above.
	 *
	 * A time cap gives coarser SPATIAL resolution the faster you move, and what a listener hears
	 * depends on tiles between updates rather than seconds: at speed 15 an interval of 5 is one
	 * service every four tiles, a wall sconce's whole range in one jump from near-silence to full.
	 * 3 holds it to two tiles. Intent rather than measured speed, so both values stay hard ceilings
	 */
	var/move_service_interval_running_override = 0
	/**
	 * Most steps a natural mover takes between move-hook services, 0 for no step limit. It only ever
	 * shortens the two intervals above, which stay as caps. An interval holds the spacing in time, so
	 * a faster mover covers more tiles between services, and tiles are what a listener hears
	 */
	var/move_service_steps = 0
	/// Whether a listener stepping faster than a natural run hears no point ambience while moving
	var/speed_cutoff = FALSE
	/**
	 * The step delay of a natural run at the speed stat's cap: the config run delay less the half
	 * decisecond the stat can take off a step. A faster step is paced as this one and trips
	 * speed_cutoff
	 */
	var/natural_run_step = 0
	/**
	 * Ceiling on move-hook services in one tick, 0 for none. Under the queue it is the drain's budget
	 * per tick. On the inline path the move hook is a signal handler running outside MC_TICK_CHECK,
	 * so a crowd moving at once lands in one tick with nothing to spread it. This and the
	 * TICK_CHECK_LOW gate beside it are that bound, and 0 turns both off. The standing walk is
	 * deliberately not counted: it is MC-governed already, and it is the catch-up for what is
	 * refused or deferred here
	 */
	var/max_services_per_tick = 0
	/// world.time of the tick services_this_tick belongs to. It advances by tick_lag, so it is the
	/// tick stamp
	var/services_tick_stamp = 0
	var/services_this_tick = 0
	/// Move-hook services refused, by which gate, for the survey
	var/services_dropped_tick = 0
	var/services_dropped_count = 0
	/**
	 * Distinct ticks in which a move service was refused, and the longest run of consecutive such
	 * ticks. Totals cannot separate isolated spikes from sustained overload, and that is the whole
	 * case for or against a queue: deferring only helps where the backlog clears before the listener
	 * has walked out of the answer
	 */
	var/ticks_dropping = 0
	var/longest_drop_run = 0
	var/current_drop_run = 0
	/// A tick index rather than world.time, since consecutive ticks differ by tick_lag and comparing
	/// those is a float compare on a number that grows all round
	var/last_drop_tick_index = 0
	/**
	 * The move hook marks the client here instead of servicing inline, and fire() drains the set
	 * every tick back to back, up to max_services_per_tick. A service costs several times less run
	 * straight after another than run on its own, the processor's predictor and cache state for
	 * this path being gone after a tick of other work and back after one pass, so draining a tick's
	 * movers together pays that once. An entry is the CLIENT, served at wherever they are when
	 * their turn comes, so nothing goes stale. 0 leaves the inline path with the two rails above
	 */
	var/use_queue = FALSE
	/// client -> world.time it was marked. Marking is idempotent, so a client keeps its place however
	/// many steps it takes, and the stamp is the wait the survey reports
	var/list/dirty_clients = list()
	var/queue_served = 0
	var/queue_wait_total = 0
	var/queue_wait_max = 0
	var/queue_depth_max = 0
	/// Fires that hit the budget with entries still waiting
	var/queue_deferred_ticks = 0
	/**
	 * Read as deltas, so a populated round can be measured without sampling it. Nothing here may
	 * sample, loop or force a rebuild. The counts are plain increments and run always. The two
	 * rustg pairs that fill the _ms figures are FFI and are NOT free, so they run only while a
	 * snapshot is held. Times are milliseconds, since a round's microseconds outgrow a float's
	 * exact range and every later add would round
	 */
	var/moves_total = 0
	var/move_services = 0
	var/drains = 0
	var/drain_ms = 0
	var/drain_services = 0
	var/drain_sends = 0
	var/drain_paused = 0
	var/drain_tick_usage_total = 0
	/**
	 * Drains bucketed by how many services ran back to back: 1, 2, 3-4, 5-8, 9+. Cost per service
	 * falling across those buckets is what draining together is worth, and the whole case for the
	 * queue, so the ms are kept beside the count to divide
	 */
	var/list/drain_size_services = list(0, 0, 0, 0, 0)
	var/list/drain_size_ms = list(0, 0, 0, 0, 0)
	/// Drained services by the candidate count of the box they ranked, indexed by count + 1 and
	/// clamped to [POINT_AMBIENCE_DENSITY_MAX], a cell with nothing in it being a real answer
	var/list/drain_density_count = new /list(POINT_AMBIENCE_DENSITY_MAX + 1)
	var/standing_walks = 0
	var/standing_walk_ms = 0
	var/standing_skipped = 0
	var/standing_active_skipped = 0
	var/standing_pending_skipped = 0
	var/standing_speed_skipped = 0
	/// Listeners silenced for moving faster than a natural run, the sounds that faded doing it, and
	/// the fast steps passed over while silenced
	var/speed_silences = 0
	var/speed_fades = 0
	var/speed_moves_skipped = 0
	/// world.time this instance was built. An MC restart resets it along with everything above, so a
	/// reader holding an older snapshot must throw that away rather than subtract from it
	var/started_at = 0
	/**
	 * Why a standing-walk service walked instead of taking the shortcut: the listener moved, the
	 * index changed, or their point ambience volume did. Counted only inside fire()'s walk, so the
	 * drain's misses, which are all moves, stay out
	 */
	var/in_standing_walk = FALSE
	var/walks_turf = 0
	var/walks_version = 0
	var/walks_volume = 0
	/// Source -> its plain loop while in fallback mode
	var/list/fallback_loops = list()
	/**
	 * Bumped whenever the index changes in a way a standing listener could hear: a source that
	 * is not carried joins, leaves, moves or changes category or override, or a source changes
	 * carrier. Clients compare it to skip the scan while nothing static changed
	 */
	var/static_version = 0
	var/list/source_change_history = list()
	/// Source -> the z it is bucketed on, so a removal can find its floor tally and cell
	var/list/source_zs = list()
	/// Positional by z: category -> how many sources are bucketed on that floor, or null. An
	/// adjacent-floor pass runs only when some still-unanswered category has sources there
	var/list/floor_counts = list()

/datum/controller/subsystem/point_ambience/New()
	for(var/category_path in subtypesof(/datum/point_ambience_category))
		var/datum/point_ambience_category/category = new category_path
		categories += category
		category.index = length(categories)
		categories_by_path[category_path] = category
		max_range = max(max_range, category.range)
		loudest_volume = max(loudest_volume, category.volume)
		max_range_sq = max_range * max_range
		category.range_sq = category.range * category.range
		if(!category.falloff_exponent)
			category.falloff_exponent = sound_falloff_for_range(category.range)
		category.inv_falloff_exponent = 1 / category.falloff_exponent
		category.inv_muffled_exponent = 1 / (category.falloff_exponent * SOUND_MUFFLE_EXPONENT_MULT)
		category.muffled_hardness = category.falloff_hardness * SOUND_MUFFLE_EXPONENT_MULT
		category.floor_ratio = clamp(category.min_volume / max(category.volume, 1), 0.001, 1)
		category.stop_sound = sound(null, channel = category.channel)
	self_category = categories_by_path[/datum/point_ambience_category/torch]
	// Recover() builds a fresh datum, so this also stamps a restart: a snapshot taken before it
	// cannot be subtracted from what this instance has counted since
	started_at = world.time
	storey_echo = new /list(18)
	storey_echo[7] = SOUND_MUFFLE_OCCLUSION
	storey_echo[8] = SOUND_MUFFLE_OCCLUSION_LF
	// Category tables must exist before the parent constructor calls Recover()
	. = ..()

/**
 * Carries the index across an MC hard-restart.
 *
 * Sources only register on a state transition, so an index that starts empty stays empty and
 * everything lit before the restart is silent for the rest of the round.
 *
 * Categories are REMAPPED rather than carried, the old datums dying with the old subsystem, so a
 * source pointing at one would match nothing in the new list. Tallies are rebuilt from what is
 * actually there, so a drifted count does not survive the restart meant to clear it.
 */
/datum/controller/subsystem/point_ambience/Recover()
	// An open bulk update is not carried. This flush and the stops below cover all it deferred
	SSpoint_ambience.clear_tile_cache()
	// A fade out has already left point_ambience_sources, so the loop below would miss its channel
	SSpoint_ambience.finish_fades()
	// Stop through the old keys before playback is rebuilt against the replacement categories
	for(var/client/listener_client as anything in GLOB.clients)
		for(var/datum/point_ambience_category/old_category as anything in listener_client.point_ambience_sources)
			SSpoint_ambience.stop_for(listener_client, old_category)
		listener_client.point_ambience_cache_turf = null
		listener_client.point_ambience_cache_static = null
		listener_client.point_ambience_profile_until = 0
		listener_client.point_ambience_next_service = 0
		listener_client.point_ambience_last_service = world.time - SSpoint_ambience.standing_skip
		listener_client.point_ambience_last_move = null
		listener_client.point_ambience_speed_moved = null
		listener_client.point_ambience_speed_silenced = FALSE
		listener_client.point_ambience_jump_next = 0
		listener_client.point_ambience_clip_due = FALSE
	buckets_by_z = SSpoint_ambience.buckets_by_z
	cell_stride = SSpoint_ambience.cell_stride
	source_keys = SSpoint_ambience.source_keys
	source_turfs = SSpoint_ambience.source_turfs
	// Carried WITH settings_seeded, or the first fire() reads config over the top of them
	settings_seeded = SSpoint_ambience.settings_seeded
	mode = SSpoint_ambience.mode
	move_service_interval = SSpoint_ambience.move_service_interval
	move_service_interval_running_override = SSpoint_ambience.move_service_interval_running_override
	move_service_steps = SSpoint_ambience.move_service_steps
	speed_cutoff = SSpoint_ambience.speed_cutoff
	natural_run_step = SSpoint_ambience.natural_run_step
	max_services_per_tick = SSpoint_ambience.max_services_per_tick
	use_queue = SSpoint_ambience.use_queue
	use_tile_cache = SSpoint_ambience.use_tile_cache
	verify_tile_cache = SSpoint_ambience.verify_tile_cache
	standing_skip = SSpoint_ambience.standing_skip
	skip_active_movers = SSpoint_ambience.skip_active_movers
	standing_hoist = SSpoint_ambience.standing_hoist
	clip_coalesce_window = SSpoint_ambience.clip_coalesce_window
	cross_floor = SSpoint_ambience.cross_floor
	send_cutoff = SSpoint_ambience.send_cutoff
	falloff_hardness = SSpoint_ambience.falloff_hardness
	pan_depth_floor = SSpoint_ambience.pan_depth_floor
	pan_blend = SSpoint_ambience.pan_blend
	fade_steps = SSpoint_ambience.fade_steps
	fade_in_steps = SSpoint_ambience.fade_in_steps
	fade_ratio = SSpoint_ambience.fade_ratio
	fade_skip = SSpoint_ambience.fade_skip
	fade_budget = SSpoint_ambience.fade_budget
	voice_pitch = SSpoint_ambience.voice_pitch
	voice_offset = SSpoint_ambience.voice_offset
	// The set is not carried: the standing walk catches everyone in it within a second
	fallback_loops = SSpoint_ambience.fallback_loops
	source_zs = SSpoint_ambience.source_zs
	// One past the old value, so every client's cached scan is redone against the new datum
	static_version = SSpoint_ambience.static_version + 1
	for(var/atom/source as anything in SSpoint_ambience.source_categories)
		var/datum/point_ambience_category/old_category = SSpoint_ambience.source_categories[source]
		var/datum/point_ambience_category/category = old_category ? categories_by_path[old_category.type] : null
		if(!category)
			continue
		source_categories[source] = category
		source_counts[category] = (source_counts[category] || 0) + 1
		if(source_counts[category] == 1)
			answerable_categories++
		adjust_floor_count(source_zs[source], category, 1)
	for(var/datum/point_ambience_category/old_category as anything in SSpoint_ambience.categories)
		var/datum/point_ambience_category/category = categories_by_path[old_category.type]
		if(category)
			category.silenced = old_category.silenced
			category.range = old_category.range
			// Live tuning survives a rebuild, or the curve silently reverts under whoever was testing
			category.falloff_hardness = old_category.falloff_hardness
			category.muffled_hardness = old_category.muffled_hardness
			category.min_volume = old_category.min_volume
			category.floor_ratio = old_category.floor_ratio
			category.volume = old_category.volume
			category.hardness_pinned = old_category.hardness_pinned
			category.indoors_volume_mult = old_category.indoors_volume_mult
			for(var/overridden in old_category.source_volumes)
				loudest_volume = max(loudest_volume, category.volume * old_category.source_volumes[overridden])
			category.source_sounds = old_category.source_sounds
			category.source_volumes = old_category.source_volumes
			category.source_continuous = old_category.source_continuous
			category.files = old_category.files
	// The buckets carry each source's category as its index into categories, which the new datums
	// were built with in the same subtypesof order, so the copied buckets stay right
	refresh_category_ranges()

/**
 * Puts an active source into the index, or moves one already in it.
 *
 * Idempotent. A source that can move must call this again from its own Moved() (the rogue lights and
 * handheld torches do). The bone structures are treated as immobile and go stale if dragged. One
 * inside a mob or container is followed through its outermost carrier from here on.
 *
 * A SILENCED category is refused outright rather than skipped at send time, because ranking sources
 * for an answer that cannot exist is still work: silencing torch at send time left the walk
 * rejecting every sconce on the map, measured as most of what the category cost. The unregister on
 * that path covers the one case where sources arrive first, mapload lighting fires before the config
 * is read at the first fire().
 *
 * Any move bumps static_version even when the bucket does not change, or standing listeners keep
 * hearing a source at the volume and pan of the tile it left until it crosses a cell boundary. A
 * dragged corpse or pushed brazier is exactly that, and it hides from whoever tests it because the
 * person dragging is moving and re-walks anyway.
 *
 * Arguments:
 * * category_path - the category's TYPEPATH, not its datum
 * * sound_override - a file this source plays instead of the category's, so it can ride a category
 *   it does not sound like
 * * volume_scale - a MULTIPLE of the category volume, not a volume. 1 is the category's own.
 *   Range stays per-category, being the walk's gate
 */
/datum/controller/subsystem/point_ambience/proc/register_source(atom/source, category_path, sound_override, volume_scale)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/point_ambience_category/category = categories_by_path[category_path]
	if(!category)
		CRASH("register_source(): [category_path] is not a point ambience category")
	if(category.silenced)
		if(source_keys[source])
			unregister_source(source, category_path)
		return
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		unregister_source(source, category_path)
		return
	var/turf/old_turf = source_turfs[source]
	var/datum/point_ambience_category/old_category = source_categories[source]
	var/version_before = static_version
	var/old_range = old_category?.range
	if(old_turf != source_turf || old_category != category)
		// A move or category change can alter every tile reached from either endpoint
		if(old_turf && old_category)
			invalidate_tile_cache(old_turf, old_category.range)
		invalidate_tile_cache(source_turf, category.range)
	source_turfs[source] = source_turf
	// Takes are handed out by position, stable for a fixed source and free of per source state.
	// Under a roof a source draws from the indoor set, read off the area's own outdoors flag
	if(!sound_override && category.voices)
		var/list/takes = category.voices
		if(category.voices_indoors)
			var/area/here = source_turf.loc
			if(!here?.outdoors)
				takes = category.voices_indoors
		sound_override = takes[1 + ((source_turf.x * 73 + source_turf.y * 179 + source_turf.z * 283) % 97) % length(takes)]
	// Reapplied on every call, so a rebucketing move does not drop them
	if(sound_override && category.source_sounds[source] != sound_override)
		category.source_sounds[source] = sound_override
		static_version++
		index_changes++
	var/current_volume_scale = category.source_volumes[source]
	if(volume_scale == 1)
		if(!isnull(current_volume_scale))
			category.source_volumes -= source
			static_version++
			index_changes++
	else if(volume_scale && current_volume_scale != volume_scale)
		category.source_volumes[source] = volume_scale
		loudest_volume = max(loudest_volume, category.volume * volume_scale)
		static_version++
		index_changes++
	if(!cell_stride)
		cell_stride = (world.maxy >> CELL_SHIFT) + 2
	var/cell = (source_turf.x >> CELL_SHIFT) * cell_stride + (source_turf.y >> CELL_SHIFT) + 1
	var/z = source_turf.z
	var/old_cell = source_keys[source]
	var/old_z = source_zs[source]
	if(old_cell == cell && old_z == z && source_categories[source] == category)
		// Same bucket, but the bucket carries the position and a carried source moves inside its
		// bucket on every step
		if(old_turf != source_turf)
			var/list/bucket = buckets_by_z[z][cell]
			var/at = bucket ? bucket.Find(source) : 0
			if(at)
				bucket[at - 3] = source_turf.x
				bucket[at - 2] = source_turf.y
			static_version++
			index_changes++
		record_source_change(version_before, old_turf, old_range, source_turf, category.range)
		return
	if(old_cell)
		remove_from_bucket(source, old_z, old_cell)
		adjust_floor_count(old_z, source_categories[source], -1)
	// Tally both sides: a source can move BETWEEN categories, and these decide whether the storey
	// passes run at all
	var/datum/point_ambience_category/previous_category = source_categories[source]
	if(previous_category != category)
		if(previous_category)
			// Checked at the close against listeners still playing it under the old category
			if(bulk_depth)
				bulk_affected[source] = TRUE
			decrement_source_count(previous_category)
			// The overrides live on the category, so a move leaves them behind holding a hard
			// reference the old category can no longer reach to clear
			previous_category.source_sounds -= source
			previous_category.source_volumes -= source
			previous_category.source_continuous -= source
			stop_fallback(source)
		source_counts[category] = (source_counts[category] || 0) + 1
		if(source_counts[category] == 1)
			answerable_categories++
	source_keys[source] = cell
	source_zs[source] = z
	source_categories[source] = category
	if(length(buckets_by_z) < z)
		buckets_by_z.len = z
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets)
		floor_buckets = list()
		buckets_by_z[z] = floor_buckets
	if(length(floor_buckets) < cell)
		floor_buckets.len = cell
	var/list/bucket = floor_buckets[cell]
	if(!bucket)
		bucket = list()
		floor_buckets[cell] = bucket
	bucket += source_turf.x
	bucket += source_turf.y
	bucket += category.index
	bucket += source
	adjust_floor_count(z, category, 1)
	static_version++
	index_changes++
	record_source_change(version_before, old_turf, old_range, source_turf, category.range)
	if(mode == POINT_AMBIENCE_FALLBACK)
		start_fallback(source)

/**
 * Whether any source of a category already sits within radius of a turf. Walks the same buckets
 * the listener walk does, exiting on the first hit. Spaces a run's voices: mostly at mapload, and
 * again per candidate neighbour whenever a river voice's turf is destroyed and the run re-seeds
 */
/datum/controller/subsystem/point_ambience/proc/any_source_within(turf/check_turf, datum/point_ambience_category/category, radius)
	PRIVATE_PROC(TRUE)
	if(length(buckets_by_z) < check_turf.z)
		return FALSE
	var/list/floor_buckets = buckets_by_z[check_turf.z]
	if(!floor_buckets)
		return FALSE
	var/cells = length(floor_buckets)
	var/radius_sq = radius * radius
	var/wanted = category.index
	var/by_lo = max(1, check_turf.y - radius) >> CELL_SHIFT
	var/by_hi = (check_turf.y + radius) >> CELL_SHIFT
	for(var/bx in (max(1, check_turf.x - radius) >> CELL_SHIFT) to ((check_turf.x + radius) >> CELL_SHIFT))
		var/row = bx * cell_stride + 1
		for(var/by in by_lo to by_hi)
			var/cell = row + by
			if(cell > cells)
				break
			var/list/bucket = floor_buckets[cell]
			if(!bucket)
				continue
			var/count = length(bucket)
			for(var/i = 1, i <= count, i += 4)
				if(bucket[i + 2] != wanted)
					continue
				var/dx = bucket[i] - check_turf.x
				var/dy = bucket[i + 1] - check_turf.y
				if(dx * dx + dy * dy <= radius_sq)
					return TRUE
	return FALSE

/**
 * Registers one tile of something much larger, returning whether this source was the one taken.
 *
 * A river is thousands of turfs and wants one voice every few tiles, so a turf registers only when
 * no voice of its category is already within spread of it.
 *
 * THE COVERAGE RULE IS `spread + 1 <= category.range`, not the obvious one. A tile can sit a full
 * spread from its nearest voice and a listener stands one tile off the run's edge, so the worst case
 * is spread + 1. Treating voices as evenly spaced and halving the gap is about twice as generous as
 * the truth, since claiming is greedy over a 2D area in mapload order.
 *
 * Arguments:
 * * category_path - the category's TYPEPATH, not its datum
 * * spread - tiles a voice covers, so no second voice is claimed within this of one
 * * sound_override, volume_scale - as register_source, letting a source ride a category it does
 *   not sound like
 * * continuous - the source is one voice of a long thing, so it must not restart or pan on a
 *   handoff. TRUE by default, since anything spread over a run is a line.
 */
/datum/controller/subsystem/point_ambience/proc/register_spread_source(atom/source, category_path, spread, sound_override, volume_scale, continuous = TRUE)
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		return FALSE
	// By DISTANCE, not a grid of spread-sized blocks: a grid bounds spacing at 2*spread-1, which at
	// spread 8 put voices 15 tiles apart against a range of 5 and left the bank silent in the middle
	var/datum/point_ambience_category/claim_category = categories_by_path[category_path]
	if(!claim_category)
		return FALSE
	if(any_source_within(source_turf, claim_category, spread))
		return FALSE
	// Continuous by default: anything spread over a run is a line, and a line played as a point
	// source restarts and flips its stereo image every time the nearest voice changes
	if(continuous)
		claim_category.source_continuous[source] = TRUE
	register_source(source, category_path, sound_override, volume_scale)
	return TRUE

/**
 * ONE VOICE, TWO FIRES. A category plays its nearest source only, so walking a road of braziers
 * flips the whole sound from one ear to the other the moment the nearest changes: measured on a Lap
 * of that road, eleven flips in 91 steps, each the full span in one packet.
 *
 * So the direction is weighted between the nearest and the runner-up the walk already found, each
 * weighted by how far INSIDE its range the other one is, which sends the weight to the nearer
 * source and to zero at either range edge. Walking past, the image slides from one through the
 * middle to the other instead of snapping, and at the moment they swap they are equidistant, so the
 * blend is already centred and the swap changes nothing.
 *
 * The volume is not blended: one voice still plays, so the dip between two fires stays. The
 * runner-up is graded only when the winner was occluded, so this can lean toward a fire behind a
 * wall. If that is heard, grade it for occluding categories
 */
/datum/controller/subsystem/point_ambience/proc/pan_lean(list/slot, datum/point_ambience_category/category, atom/nearest, turf/source_turf, dx, dy)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	serving_lean_dx = dx
	serving_lean_dy = dy
	if(!pan_blend)
		return
	var/atom/second = slot[POINT_AMBIENCE_SLOT_RUNNER_UP]
	if(!second || second == nearest || source_categories[second] != category)
		return
	var/turf/second_turf = source_turfs[second]
	if(!second_turf || second_turf.z != source_turf.z)
		return
	var/rdx = second_turf.x - serving_turf.x
	var/rdy = second_turf.y - serving_turf.y
	var/d1sq = dx * dx + dy * dy
	var/d2sq = rdx * rdx + rdy * rdy
	if(!d1sq || d2sq > category.range_sq)
		return
	var/w1 = (category.range_sq - d1sq) * d2sq
	var/w2 = (category.range_sq - d2sq) * d1sq
	var/total = w1 + w2
	if(total <= 0)
		return
	serving_lean_dx = (w1 * dx + w2 * rdx) / total
	serving_lean_dy = (w1 * dy + w2 * rdy) / total

/// Whether a carried source's send matches its slot exactly. Distance and pan are held at zero
/// on one, so only the volume scale, the area environment and the muffle can change it
/datum/controller/subsystem/point_ambience/proc/self_send_unchanged(client/listener_client, datum/point_ambience_category/category, atom/source)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/slots = listener_client.point_ambience_slots
	if(length(slots) < category.index)
		return FALSE
	var/list/slot = slots[category.index]
	if(!slot || slot[POINT_AMBIENCE_SLOT_ENVIRONMENT] != serving_environment)
		return FALSE
	if(serving_muffle_wall || serving_muffle_head)
		return FALSE
	var/vol = category.volume * (category.source_volumes[source] || 1)
	// The same cut the send applies, or a carried source would hold its outdoor volume through a door
	if(serving_indoors && category.indoors_volume_mult != 1)
		vol *= category.indoors_volume_mult
	if(!isnull(serving_volume_scale))
		vol *= serving_volume_scale
	return slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] == min(vol, 100)

/**
 * Flips every knob the curve work touched, so hearing the before and after is one prompt rather
 * than four. The original is the band power curve with no cutoff. The floors are the same either
 * way, being what they always were
 */
/datum/controller/subsystem/point_ambience/proc/set_original_sound(original)
	original_sound = original
	send_cutoff = original ? 0 : initial(send_cutoff)
	falloff_hardness = original ? 0 : initial(falloff_hardness)
	for(var/datum/point_ambience_category/category as anything in categories)
		category.falloff_hardness = original ? 0 : initial(category.falloff_hardness)
		category.muffled_hardness = category.falloff_hardness * SOUND_MUFFLE_EXPONENT_MULT
	invalidate_listener_cache()

/**
 * Sets the hard decay exponent on every category whose curve is not pinned, null restoring each
 * category's own default. Written into the categories rather than read through the subsystem per
 * send, so the curve costs a plain var read. Takes effect on the next send to each listener
 */
/datum/controller/subsystem/point_ambience/proc/set_falloff_hardness(value)
	falloff_hardness = value
	for(var/datum/point_ambience_category/category as anything in categories)
		if(category.hardness_pinned)
			continue
		category.falloff_hardness = isnull(value) ? initial(category.falloff_hardness) : value
		category.muffled_hardness = category.falloff_hardness * SOUND_MUFFLE_EXPONENT_MULT
	invalidate_listener_cache()

/**
 * Marks one expired clip for replacement. An already queued movement service consumes the same
 * marker; otherwise the callback queues this category. The old clip repeats until it is served
 */
/datum/controller/subsystem/point_ambience/proc/advance_clip(client/listener_client, datum/point_ambience_category/category, deferred = FALSE)
	PRIVATE_PROC(TRUE)
	// A client that disconnected arrives as null. Leaving live mode stops every category and
	// deletes these timers with them, so the mode test is only for a timer that outlived that
	if(mode != POINT_AMBIENCE_LIVE || !listener_client || !listener_client.point_ambience_sources[category])
		return
	var/list/slot = slot_for(listener_client, category.index)
	if(deferred && !slot[POINT_AMBIENCE_SLOT_CLIP_DUE])
		return
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_clip_refresh")
	// The old clip repeats natively until either this callback or an already queued movement
	// service replaces it, so coalescing cannot open a silent gap
	slot[POINT_AMBIENCE_SLOT_TIMER] = null
	if(deferred)
		clip_refresh_timeouts++
		if(!isnull(dirty_clients[listener_client]))
			clip_refresh_coalesced++
		else if(use_queue)
			dirty_clients[listener_client] = world.time
			clip_refresh_queued++
		else
			service_client(listener_client)
	else
		clip_refreshes++
		slot[POINT_AMBIENCE_SLOT_CLIP_DUE] = TRUE
		listener_client.point_ambience_clip_due = TRUE
		var/pending = !isnull(dirty_clients[listener_client])
		var/last_move = listener_client.point_ambience_last_move
		var/expect_movement = use_queue && !listener_client.point_ambience_ear \
			&& !isnull(last_move) && world.time - last_move < clip_coalesce_window
		if(pending)
			clip_refresh_coalesced++
		else if(clip_coalesce_window > 0 && expect_movement)
			clip_refresh_deferred++
			slot[POINT_AMBIENCE_SLOT_TIMER] = addtimer(CALLBACK(src, PROC_REF(advance_clip), listener_client, category, TRUE), clip_coalesce_window, TIMER_STOPPABLE)
		else if(use_queue)
			dirty_clients[listener_client] = world.time
			clip_refresh_queued++
		else
			service_client(listener_client)
	if(timing)
		clip_refresh_ms += rustg_time_microseconds("pa_clip_refresh") / 1000

/**
 * Takes a source out of the index and silences it for anyone currently hearing it.
 *
 * Safe on something never registered, the common case for a mapped emitter that was never lit.
 *
 * Arguments:
 * * category_path - accepted for call-site clarity and then IGNORED. The category is read from the
 *   index, since a caller passing the wrong path would decrement the wrong tally.
 */
/datum/controller/subsystem/point_ambience/proc/unregister_source(atom/source, category_path)
	SHOULD_NOT_SLEEP(TRUE)
	// From the index, not the argument: a caller passing the wrong path would decrement the wrong
	// tally and leave the sound playing. category_path stays in the signature for call-site clarity
	var/datum/point_ambience_category/category = source_categories[source] || categories_by_path[category_path]
	if(!category)
		return
	var/old_cell = source_keys[source]
	if(!old_cell)
		// Never registered, so it cannot be anyone's current source: skips the client walk for the
		// mapped-off majority whose Initialize lands here
		return
	var/turf/old_turf = source_turfs[source]
	var/version_before = static_version
	invalidate_tile_cache(old_turf, category.range)
	remove_from_bucket(source, source_zs[source], old_cell)
	adjust_floor_count(source_zs[source], category, -1)
	static_version++
	index_changes++
	record_source_change(version_before, old_turf, category.range, null, 0)
	source_keys -= source
	source_zs -= source
	source_turfs -= source
	source_categories -= source
	stop_fallback(source)
	decrement_source_count(category)
	category.source_sounds -= source
	category.source_volumes -= source
	category.source_continuous -= source
	// Inside a bulk update the close makes this walk once for every source the scope changed
	if(bulk_depth)
		bulk_affected[source] = TRUE
		return
	// The channel is the stop handle: a snuffed source goes silent now, not when its replay runs
	// out. One client walk per deactivation
	for(var/client/listener_client in GLOB.clients)
		if(listener_client.point_ambience_sources[category] == source)
			stop_for(listener_client, category)

/// Guarded against going negative, since answerable_categories drifting below the truth would
/// stop the storey passes early and quietly lose every source a floor away
/datum/controller/subsystem/point_ambience/proc/decrement_source_count(datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	var/remaining = max(0, (source_counts[category] || 0) - 1)
	source_counts[category] = remaining
	if(!remaining)
		answerable_categories = max(0, answerable_categories - 1)

/**
 * Cuts a source's four-entry quad out of one bucket. The rare path, so a linear Find is fine.
 *
 * Arguments:
 * * cell - the bucket index, `(x >> CELL_SHIFT) * cell_stride + (y >> CELL_SHIFT) + 1`
 */
/datum/controller/subsystem/point_ambience/proc/remove_from_bucket(atom/source, z, cell)
	PRIVATE_PROC(TRUE)
	if(isnull(z) || length(buckets_by_z) < z)
		return
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets || length(floor_buckets) < cell)
		return
	var/list/bucket = floor_buckets[cell]
	if(!bucket)
		return
	// The source is the last of its four entries
	var/at = bucket.Find(source)
	if(at)
		bucket.Cut(at - 3, at + 1)
	if(!length(bucket))
		floor_buckets[cell] = null

/**
 * Keeps the per-floor tally of sources in a category.
 *
 * It decides whether a storey pass runs at all, so it MUST be paired with every bucket add and
 * remove, or a floor is searched forever, or never searched again.
 *
 * Arguments:
 * * delta - +1 as a source joins the floor, -1 as it leaves
 */
/datum/controller/subsystem/point_ambience/proc/adjust_floor_count(z, datum/point_ambience_category/category, delta)
	PRIVATE_PROC(TRUE)
	if(isnull(z) || !category)
		return
	if(length(floor_counts) < z)
		floor_counts.len = z
	var/list/counts = floor_counts[z]
	if(!counts)
		counts = list()
		floor_counts[z] = counts
	counts[category] = max(0, (counts[category] || 0) + delta)

/// The floor above or below z, or 0 when the map links nothing there. The linkage is a
/// boolean per floor and the neighbour is always the next z, which is what get_step(UP) walks
/datum/controller/subsystem/point_ambience/proc/floor_above(z)
	PRIVATE_PROC(TRUE)
	var/list/levels = SSmapping.multiz_levels
	if(length(levels) < z)
		return 0
	var/list/links = levels[z]
	return (links && links[Z_LEVEL_UP]) ? z + 1 : 0

/// The z one storey down, or 0 where nothing connects. Arithmetic rather than a turf lookup, since
/// the walk only ever wants the number
/datum/controller/subsystem/point_ambience/proc/floor_below(z)
	PRIVATE_PROC(TRUE)
	var/list/levels = SSmapping.multiz_levels
	if(length(levels) < z)
		return 0
	var/list/links = levels[z]
	return (links && links[Z_LEVEL_DOWN]) ? z - 1 : 0

/**
 * Silences one category for one listener and forgets what it was playing.
 *
 * Arguments:
 * * send_null - actually stop the channel. FALSE when the caller is about to send something else on
 *   it, where a stop first would be an audible gap.
 */
/datum/controller/subsystem/point_ambience/proc/stop_for(client/listener_client, datum/point_ambience_category/category, send_null = TRUE)
	listener_client.point_ambience_sources -= category
	var/list/slots = listener_client.point_ambience_slots
	if(length(slots) >= category.index)
		var/list/slot = slots[category.index]
		if(slot)
			// Cleared, or a continuous run re-entered at the volume it left at would match the stale
			// value and never be started again
			slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = null
			if(slot[POINT_AMBIENCE_SLOT_TIMER])
				deltimer(slot[POINT_AMBIENCE_SLOT_TIMER])
				slot[POINT_AMBIENCE_SLOT_TIMER] = null
			slot[POINT_AMBIENCE_SLOT_CLIP_DUE] = null
			if(slot[POINT_AMBIENCE_SLOT_FADE_NEXT])
				// A fade out has the channel still playing and, with its marker gone, nothing left
				// to silence it, so the stop goes out whatever the caller asked
				if(isnull(slot[POINT_AMBIENCE_SLOT_FADE_TARGET]))
					send_null = TRUE
				slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = null
				slot[POINT_AMBIENCE_SLOT_FADE_TARGET] = null
				slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = null
	if(send_null)
		SEND_SOUND(listener_client, category.stop_sound)

/**
 * Lets a category die away for one listener instead of cutting it, for the two ways a listener
 * leaves a sound by moving: out of its range, or behind a wall. A snuffed source, a mute, deafness
 * and a teleport still stop at once through stop_for.
 *
 * The first step goes out here, the exit already being a step late, and fire() sends the rest. The
 * category leaves point_ambience_sources now, so the walk treats it as gone, and coming back into
 * earshot before the fade ends picks the playing clip up again
 */
/datum/controller/subsystem/point_ambience/proc/fade_out(client/listener_client, datum/point_ambience_category/category, turf/listener_turf, by_wall)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/index = category.index
	var/list/slots = listener_client.point_ambience_slots
	var/list/slot = (length(slots) >= index) ? slots[index] : null
	var/list/sounds = listener_client.point_ambience_sounds
	var/sound/S = (length(sounds) >= index) ? sounds[index] : null
	var/turf/source_turf = slot?[POINT_AMBIENCE_SLOT_TURF]
	var/volume = slot?[POINT_AMBIENCE_SLOT_LAST_VOLUME]
	var/listed = slot?[POINT_AMBIENCE_SLOT_FADE_NEXT]
	// Fades off, or a listener who cannot be served at all, deaf or muted: a plain stop, not a refusal
	if(!fade_steps || !listener_turf)
		stop_for(listener_client, category)
		return
	// Every other cut is counted by its reason, so "it did not trail off" can be read off Counters
	var/refused = FALSE
	if(!S || !volume || !source_turf)
		fade_refused_state++
		refused = TRUE
	else if(!listed && length(fading) >= POINT_AMBIENCE_FADE_CAP * 2)
		fade_refused_full++
		refused = TRUE
	else
		// Further than two steps past the edge is a teleport, and a sound trailing after one is
		// wrong. A stair is not, so one floor is allowed and the test stays planar
		var/dx = source_turf.x - listener_turf.x
		var/dy = source_turf.y - listener_turf.y
		var/reach = category.range + 3
		if(abs(source_turf.z - listener_turf.z) > 1 || dx * dx + dy * dy > reach * reach)
			fade_refused_far++
			refused = TRUE
	if(refused)
		stop_for(listener_client, category)
		return
	volume *= fade_ratio
	if(volume < fade_skip)
		fade_skipped++
		stop_for(listener_client, category)
		return
	// What stop_for does, short of the stop itself
	listener_client.point_ambience_sources -= category
	if(slot[POINT_AMBIENCE_SLOT_TIMER])
		deltimer(slot[POINT_AMBIENCE_SLOT_TIMER])
		slot[POINT_AMBIENCE_SLOT_TIMER] = null
	var/due = round(world.time) + POINT_AMBIENCE_FADE_STEP
	slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = due
	slot[POINT_AMBIENCE_SLOT_FADE_TARGET] = null
	slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = fade_steps - 1
	fade_next_due = length(fading) ? min(fade_next_due, due) : due
	// Already listed when it was still fading IN, and that entry carries on as this fade out
	if(!listed)
		fading += listener_client
		fading += category
	if(by_wall)
		fade_wall_starts++
	else
		fade_range_starts++
	// Volume alone. Position, room and pitch stay as the last real send left them.
	// Not in fade_packets, which is run_fades' own so its timer divides by what it paid for
	S.status = SOUND_UPDATE
	S.volume = volume
	SEND_SOUND(listener_client, S)
	slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = volume

/**
 * Sends whatever fade steps have come due. Driven by world.time, not by one step a fire, because
 * this subsystem runs in the tick's slack and a late fire has to catch up rather than stretch the
 * fade: every overdue step is taken at once, which is also what keeps the ending firm.
 *
 * A step never goes through slim_send. That would pin a listener past the range at the floor and
 * refuse the last quiet steps
 */
/datum/controller/subsystem/point_ambience/proc/run_fades()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_fade")
	var/sent = 0
	var/earliest = INFINITY
	var/i = 1
	while(i < length(fading))
		var/client/listener_client = fading[i]
		var/datum/point_ambience_category/category = fading[i + 1]
		var/list/slots = listener_client?.point_ambience_slots
		var/list/slot = (length(slots) >= category.index) ? slots[category.index] : null
		var/due = slot?[POINT_AMBIENCE_SLOT_FADE_NEXT]
		// Logged out, finished, or ended by a real send, which clears the marker and leaves this
		if(!due)
			fading.Cut(i, i + 2)
			continue
		if(world.time < due)
			earliest = min(earliest, due)
			i += 2
			continue
		var/volume = slot[POINT_AMBIENCE_SLOT_LAST_VOLUME]
		var/left = slot[POINT_AMBIENCE_SLOT_FADE_LEFT]
		var/target = slot[POINT_AMBIENCE_SLOT_FADE_TARGET]
		// Uncapped as well as capped, so a run arriving after the whole fade was due can tell that
		// it is over. Read only through the cap, the last step recomputes the same volume however
		// late the run is, stays above fade_skip, and a budget refusal defers it again writing
		// nothing, so more elapsed time never ends it
		var/elapsed_steps = 1 + round((world.time - due) / POINT_AMBIENCE_FADE_STEP)
		var/expired = elapsed_steps > left
		var/steps = min(left, elapsed_steps)
		var/stopping = FALSE
		var/arrived = FALSE
		if(isnull(target))
			// Out of steps is the end whatever the volume, so a fade_skip of 0 cannot run forever
			if(steps > 0 && volume)
				volume *= fade_ratio ** steps
			stopping = (expired || steps <= 0 || !volume || volume < fade_skip)
		else
			// The last step lands on the target itself, so a ratio that does not divide evenly
			// cannot leave it a hair short
			volume = (steps < left && volume) ? min(volume / fade_ratio ** steps, target) : target
			arrived = (volume >= target)
		// Over the budget a step waits, nothing written, and the next run takes it with whatever
		// else it is behind by then. An ENDING is never held back, out or in: it is what leaves the
		// sound at the volume it is meant to hold, and holding it back is what stalled a fade out
		if(!stopping && !arrived && (sent >= fade_budget || TICK_CHECK))
			fade_deferred++
			earliest = world.time
			i += 2
			continue
		if(stopping || arrived)
			slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = null
			slot[POINT_AMBIENCE_SLOT_FADE_TARGET] = null
			slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = null
			fading.Cut(i, i + 2)
		else
			var/next_due = round(world.time) + POINT_AMBIENCE_FADE_STEP
			slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = next_due
			slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = left - steps
			earliest = min(earliest, next_due)
			i += 2
		if(stopping)
			slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = null
			SEND_SOUND(listener_client, category.stop_sound)
			continue
		var/sound/S = listener_client.point_ambience_sounds[category.index]
		S.status = SOUND_UPDATE
		S.volume = volume
		SEND_SOUND(listener_client, S)
		slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = volume
		fade_packets++
		sent++
	fade_next_due = earliest
	if(timing)
		fade_ms += rustg_time_microseconds("pa_fade") / 1000

/// Ends every fade now. A fade out is the one thing playing that point_ambience_sources no longer
/// lists, so whatever stops everyone, a mode change or a rebuilt subsystem, calls this first
/datum/controller/subsystem/point_ambience/proc/finish_fades()
	for(var/i in 1 to length(fading) step 2)
		var/client/listener_client = fading[i]
		var/datum/point_ambience_category/category = fading[i + 1]
		var/list/slots = listener_client?.point_ambience_slots
		var/list/slot = (length(slots) >= category.index) ? slots[category.index] : null
		if(!slot?[POINT_AMBIENCE_SLOT_FADE_NEXT])
			continue
		if(isnull(slot[POINT_AMBIENCE_SLOT_FADE_TARGET]))
			slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = null
			SEND_SOUND(listener_client, category.stop_sound)
		slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = null
		slot[POINT_AMBIENCE_SLOT_FADE_TARGET] = null
		slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = null
	fading.Cut()

/**
 * A lit torch in a hand is heard by its carrier alone. It never enters the index: it is marked on
 * its carrier as that mob's self source and served to them at distance 0, so no walk ever scans it
 * and no standing listener has to be rechecked because someone walked past. A lit torch lying on
 * the ground is not indexed either. The only torch anyone else hears is one in a sconce, and
 * then the sconce is the source
 */
/datum/controller/subsystem/point_ambience/proc/set_self_source(mob/carrier, atom/source)
	carrier.point_ambience_self_source = source

/**
 * Clears the mob's self source if it is this one. A source that went out is silenced at once, as an
 * unregister does for an indexed source.
 *
 * One still burning has only left the hand, into a sconce, onto the floor or to someone else, and
 * its channel is left playing for the next service to re-price. A sconce now holding it is the same
 * clip on the same channel, so it carries on as a change of source where a stop here made it go
 * silent for up to a second and then restart. With nothing in earshot it fades like any other exit
 */
/datum/controller/subsystem/point_ambience/proc/clear_self_source(mob/carrier, atom/source, still_lit = FALSE)
	if(carrier.point_ambience_self_source != source)
		return
	carrier.point_ambience_self_source = null
	if(still_lit)
		return
	var/client/listener_client = carrier.client
	if(listener_client && listener_client.point_ambience_sources[self_category] == source)
		stop_for(listener_client, self_category)

/**
 * Services every non-observer client, and on its FIRST run only, seeds the config.
 *
 * Both config reads are boot-only on purpose, because each is a bulk operation that must not land on
 * a running server. Entering fallback gives every source a plain looping sound at once, upward of
 * 1800 TIMER_CLIENT_TIME entries into a linearly scanned list, which delays every other timer in
 * SSsound_loops and is audible as weather stuttering. That is why the Mode verb does not offer it
 * and only this does. Silencing now de-indexes, and 1112 sconces leaving the buckets is the same
 * shape of pass. Run once before a round with nobody connected, both are fine.
 *
 * Mapload registers everything before this runs, and fires light themselves during it, so a category
 * silenced here already holds several hundred sources: register_source refuses them from now on but
 * cannot reach back, and this has to clear them out.
 */
/datum/controller/subsystem/point_ambience/fire(resumed)
	if(bulk_depth && bulk_opened_at != world.time)
		close_leaked_bulk()
	if(!hooked_logins)
		hook_logins()
	if(!settings_seeded)
		settings_seeded = TRUE
		move_service_interval = CONFIG_GET(number/point_ambience_move_interval)
		move_service_interval_running_override = CONFIG_GET(number/point_ambience_move_interval_running_override)
		move_service_steps = CONFIG_GET(number/point_ambience_move_steps)
		speed_cutoff = CONFIG_GET(number/point_ambience_speed_cutoff)
		max_services_per_tick = CONFIG_GET(number/point_ambience_max_services_per_tick)
		use_queue = CONFIG_GET(number/point_ambience_queue)
		standing_skip = CONFIG_GET(number/point_ambience_standing_skip)
		cross_floor = CONFIG_GET(number/point_ambience_cross_floor)
		set_falloff_hardness(CONFIG_GET(number/point_ambience_falloff_hardness))
		pan_depth_floor = CONFIG_GET(number/point_ambience_pan_depth_floor)
		set_mode(CONFIG_GET(number/point_ambience_mode))
		var/list/silenced_names = CONFIG_GET(keyed_list/silence_point_ambience)
		var/any_silenced = FALSE
		for(var/datum/point_ambience_category/category as anything in categories)
			category.silenced = !!silenced_names[category.config_name]
			if(category.silenced)
				any_silenced = TRUE
		// Copied because unregister_source mutates the list it walks
		if(any_silenced)
			begin_bulk_source_update("config silencing")
			for(var/atom/source as anything in source_categories.Copy())
				var/datum/point_ambience_category/category = source_categories[source]
				if(category?.silenced)
					unregister_source(source, category.type)
			end_bulk_source_update()
		static_version++
	if(mode != POINT_AMBIENCE_LIVE)
		return
	// Ahead of both early returns below, since a listener who stops walking the moment they leave a
	// range is never served again and their fade still has to finish
	if(length(fading) && world.time >= fade_next_due)
		run_fades()
	// Before the drain, so the listeners a door marks are served this fire
	if(length(changed_doors) && world.time >= next_door_recheck)
		recheck_doors()
	// Whatever is marked, whether or not the queue is still on: switching it off must not strand
	// anyone already in the set
	var/drained = TRUE
	if(length(dirty_clients))
		drained = drain_dirty()
	// A paused drain must still allow a due or unfinished standing walk to progress.
	// Its own tick check limits the work and currentrun retains the remaining clients
	if(!drained && !length(currentrun) && world.time < next_standing_walk)
		return
	if(!length(currentrun) && world.time >= next_standing_walk)
		next_standing_walk = world.time + standing_walk_interval
		currentrun = GLOB.clients.Copy()
		standing_walks++
		// Every walk rather than once at boot, since a localhost admin's login sets the move delays
		// after it. The speed stat's cap takes half a decisecond off a step
		natural_run_step = CONFIG_GET(number/movedelay/run_delay) - 0.5
	if(!length(currentrun))
		return
	in_standing_walk = TRUE
	// Timed only while a snapshot is held. The pair is two FFI calls, worth paying to answer a
	// question and not worth paying when nobody is asking
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_walk")
	while(length(currentrun))
		var/client/listener_client = currentrun[currentrun.len]
		currentrun.len--
		if(listener_client && !listener_client.point_ambience_silenced && !isobserver(listener_client.mob))
			// A step served them within the window, so this walk would land on a tile they are
			// leaving. Stamped by steps only, so one waiting past the budget still reads unserved
			if(standing_skip && world.time - listener_client.point_ambience_last_service < standing_skip)
				standing_skipped++
			// Silenced for speed and still moving that fast. A step at a natural pace brings them
			// back, and so does the first walk after they stop
			else if(listener_client.point_ambience_speed_silenced && !isnull(listener_client.point_ambience_speed_moved) \
				&& world.time - listener_client.point_ambience_speed_moved < POINT_AMBIENCE_SPEED_STILL)
				standing_skipped++
				standing_speed_skipped++
			else if(skip_active_movers && standing_skip && !listener_client.point_ambience_clip_due \
				&& !listener_client.point_ambience_ear && !isnull(listener_client.point_ambience_last_move) \
				&& world.time - listener_client.point_ambience_last_move < standing_skip \
				&& world.time - listener_client.point_ambience_last_service < standing_skip + standing_walk_interval \
				&& listener_client.point_ambience_cache_turf \
				&& (listener_client.point_ambience_cache_version == static_version \
					|| can_reuse_tile_listener(get_turf(listener_client.mob), listener_client.point_ambience_cache_version)) \
				&& listener_client.point_ambience_cache_self == listener_client.mob?.point_ambience_self_source)
				standing_skipped++
				standing_active_skipped++
			else if(!isnull(dirty_clients[listener_client]))
				standing_skipped++
				standing_pending_skipped++
			// The standing shortcut in service_client, taken before the call so an answer that still
			// holds costs no proc call and no per service setup. The conditions must match that shortcut
			// exactly, and it moves the same counters so Counters still reads a cached hit. The fields
			// that setup resets are only read by callers straight after their own service
			else if(standing_hoist && !listener_client.point_ambience_clip_due && !listener_client.point_ambience_ear \
				&& listener_client.point_ambience_cache_turf \
				&& get_turf(listener_client.mob) == listener_client.point_ambience_cache_turf \
				&& !isnewplayer(listener_client.mob) \
				&& listener_client.mob.point_ambience_self_source == listener_client.point_ambience_cache_self \
				&& (listener_client.prefs ? POINT_AMBIENCE_VOLUME(listener_client.prefs) : null) == listener_client.point_ambience_cache_volume \
				&& (listener_client.point_ambience_cache_version == static_version \
					|| can_reuse_tile_listener(listener_client.point_ambience_cache_turf, listener_client.point_ambience_cache_version)))
				listener_client.point_ambience_cache_version = static_version
				services_total++
				standing_hits++
				tick_services++
				tick_standing_hits++
			else
				var/standing_before = standing_hits
				service_client(listener_client)
				tick_services++
				if(standing_hits != standing_before)
					tick_standing_hits++
		// break rather than return, or a paused walk leaves the segment untimed and the flag set
		if(MC_TICK_CHECK)
			break
	if(timing)
		standing_walk_ms += rustg_time_microseconds("pa_walk") / 1000
	in_standing_walk = FALSE

/**
 * Serves the clients marked by the move hook, back to back, oldest mark first, up to the budget.
 *
 * Yields to the MC between them, and returns FALSE when it yielded with work still marked. The next
 * fire() drains again from where this left off, the set being the queue's own state rather than
 * something rebuilt per tick, so a pause costs a tick of waiting and nothing else.
 */
/datum/controller/subsystem/point_ambience/proc/drain_dirty()
	PRIVATE_PROC(TRUE)
	queue_depth_max = max(queue_depth_max, length(dirty_clients))
	drains++
	drain_tick_usage_total += world.tick_usage
	// See fire(): the FFI pair is paid only while a snapshot is held
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_drain")
	. = TRUE
	var/served = 0
	var/services_at_start = drain_services
	while(length(dirty_clients))
		if(max_services_per_tick && served >= max_services_per_tick)
			queue_deferred_ticks++
			break
		var/client/listener_client = dirty_clients[1]
		// A disconnected client leaves a null key, one between mobs goes to the standing walk. Both
		// still cost the pop, so both fall through to the tick check or a set of them bursts
		var/marked = listener_client ? dirty_clients[listener_client] : world.time
		dirty_clients.Cut(1, 2)
		if(listener_client?.mob)
			var/waited = world.time - marked
			queue_wait_total += waited
			queue_wait_max = max(queue_wait_max, waited)
			queue_served++
			served++
			var/services_before = services_total
			// Timed in place when a survey runs
			if(GLOB.point_ambience_survey)
				GLOB.point_ambience_survey.time_real_service(listener_client)
			else
				service_client(listener_client)
			listener_client.point_ambience_last_service = world.time
			// A client with the sound off returns before counting, leaving the send figure stale
			if(services_total != services_before)
				drain_services++
				drain_sends += sends_this_service
				// Only actual rankings contribute; a cache-only hit has no density sample
				if(!isnull(ranked_candidates_this_service))
					drain_density_count[min(ranked_candidates_this_service, POINT_AMBIENCE_DENSITY_MAX) + 1]++
		if(MC_TICK_CHECK)
			drain_paused++
			. = FALSE
			break
	var/ran = drain_services - services_at_start
	if(!timing || !ran)
		return
	var/took = rustg_time_microseconds("pa_drain") / 1000
	drain_ms += took
	var/bucket = ran <= 2 ? ran : (ran <= 4 ? 3 : (ran <= 8 ? 4 : 5))
	drain_size_services[bucket] += ran
	drain_size_ms[bucket] += took

/**
 * Serves one client: resolves the listener, finds the nearest source per category, sends each.
 *
 * Called by queued movement, periodic standing walks and clip timers. A listener who has not moved
 * and whose index version is unchanged takes the cached answer and skips the walk entirely. One due
 * non-occluding clip can reuse that answer and send only its category.
 *
 * Occlusion resolves BEFORE the sends, since a wall changes which source wins rather than only how
 * it sounds, and the resolved winner is written back so a later standing service does not redo it.
 */
/datum/controller/subsystem/point_ambience/proc/service_client(client/listener_client)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/clip_advances
	if(listener_client.point_ambience_clip_due)
		listener_client.point_ambience_clip_due = FALSE
		var/list/slots = listener_client.point_ambience_slots
		for(var/datum/point_ambience_category/due_category as anything in categories)
			var/list/due_slot = (length(slots) >= due_category.index) ? slots[due_category.index] : null
			if(!due_slot?[POINT_AMBIENCE_SLOT_CLIP_DUE])
				continue
			due_slot[POINT_AMBIENCE_SLOT_CLIP_DUE] = null
			if(due_slot[POINT_AMBIENCE_SLOT_TIMER])
				deltimer(due_slot[POINT_AMBIENCE_SLOT_TIMER])
				due_slot[POINT_AMBIENCE_SLOT_TIMER] = null
				clip_refresh_coalesced++
			if(listener_client.point_ambience_sources[due_category])
				LAZYADD(clip_advances, due_category)
	// Before the count, so they stay out of the rates. With no move hook and the walk passing them,
	// only a listener queued just before going silent arrives here
	if(listener_client.point_ambience_silenced)
		return
	services_total++
	sends_this_service = 0
	walked_this_service = FALSE
	rebuilt_this_service = FALSE
	ranked_candidates_this_service = null
	occlusion_checks_this_service = 0
	occlusion_tiles_this_service = 0
	var/mob/listener = listener_client.mob
	var/turf/listener_turf
	// A headless dullahan hears from the head, kept current by the watch, null for everyone else
	var/atom/movable/ear = listener_client.point_ambience_ear
	// Observers are skipped by the tick and silenced at login. This catches any that arrive
	// another way
	if(listener && !isnewplayer(listener) && !isobserver(listener))
		listener_turf = get_turf(ear || listener)
	// The mob's own lit torch, served ahead of what the walk found. It is in the body's hand, so
	// it is only theirs to hear while the ear is on that turf
	var/atom/self_source = null
	if(listener_turf && (!ear || listener_turf == get_turf(listener)))
		self_source = listener.point_ambience_self_source
	// Still moving faster than a natural run, so everything fades where it plays. The service that
	// finds the stamp gone old clears the silence and serves them as normal
	if(!isnull(listener_client.point_ambience_speed_moved))
		if(world.time - listener_client.point_ambience_speed_moved < POINT_AMBIENCE_SPEED_STILL)
			speed_silence(listener_client, listener_turf, self_source)
			return
		listener_client.point_ambience_speed_moved = null
	listener_client.point_ambience_speed_silenced = FALSE
	var/list/nearest_by_category
	var/standing = FALSE
	var/clip_only = FALSE
	var/datum/point_ambience_category/clip_category = (length(clip_advances) == 1) ? clip_advances[1] : null
	if(listener_turf)
		var/ambience_volume = listener_client.prefs ? POINT_AMBIENCE_VOLUME(listener_client.prefs) : null
		// The standing walk in fire() repeats this shortcut before calling here, so change both together
		if(listener_turf == listener_client.point_ambience_cache_turf \
			&& ambience_volume == listener_client.point_ambience_cache_volume \
			&& (static_version == listener_client.point_ambience_cache_version \
				|| can_reuse_tile_listener(listener_turf, listener_client.point_ambience_cache_version)))
			standing = TRUE
			listener_client.point_ambience_cache_version = static_version
			// Every category below would return unchanged, so skip the loop. Returns WITHOUT preparing,
			// so the serving_* vars still describe the last client served and nothing may read them
			if(self_source == listener_client.point_ambience_cache_self)
				if(!length(clip_advances))
					standing_hits++
					return
				if(clip_category)
					var/atom/current_source = listener_client.point_ambience_sources[clip_category]
					clip_only = !clip_category.occlude && !ear && current_source \
						&& listener_client.point_ambience_cache_static?[clip_category] == current_source
		// Per service, not per walk: later paths may otherwise read another turf or client's runner-up
		scratch_second.Cut()
		// After the shortcut, so an unchanged listener prepares only when a clip is due. One who
		// cannot be served is treated as having no turf, which stops everything they had playing
		if(!prepare_serving(listener_client, listener, listener_turf, ambience_volume))
			listener_turf = null
			self_source = null
			clip_only = FALSE
		else
			if(clip_only)
				var/list/clip_slot = listener_client.point_ambience_slots[clip_category.index]
				clip_only = clip_slot && clip_slot[POINT_AMBIENCE_SLOT_ENVIRONMENT] == serving_environment
			if(length(clip_advances) && !clip_only)
				standing = FALSE
			if(standing)
				nearest_by_category = listener_client.point_ambience_cache_static
			else
				if(in_standing_walk)
					if(listener_turf != listener_client.point_ambience_cache_turf)
						walks_turf++
					else if(static_version != listener_client.point_ambience_cache_version)
						walks_version++
					else
						walks_volume++
				walked_this_service = TRUE
				nearest_by_category = nearest_sources(listener_turf, listener_client)
				listener_client.point_ambience_cache_turf = listener_turf
				listener_client.point_ambience_cache_version = static_version
				listener_client.point_ambience_cache_volume = ambience_volume
	if(length(clip_advances))
		if(clip_only)
			clip_refresh_fast += length(clip_advances)
		else
			clip_refresh_full += length(clip_advances)
	if(!listener_turf)
		listener_client.point_ambience_cache_turf = null
	listener_client.point_ambience_cache_self = self_source
	var/list/sources = listener_client.point_ambience_sources
	// Nothing answered, nothing playing and no torch in hand is most of the map, and every
	// iteration below would find nothing to do
	if(!self_source && !length(nearest_by_category) && !length(sources))
		return
	var/toggles = listener_client.prefs?.toggles
	// Sconces, standing fires and the listener's own torch are all this category, so one test turns
	// off every torch they can hear rather than only the ones on the map
	var/no_torch = (toggles & SOUND_DISABLE_TORCH_AMBIENCE)
	var/list/fade_slots = listener_client.point_ambience_slots
	for(var/datum/point_ambience_category/category as anything in categories)
		if(clip_only && category != clip_category)
			continue
		var/clip_advance = clip_advances && (category in clip_advances)
		var/atom/nearest
		var/by_wall = FALSE
		serving_muffle_wall = FALSE
		// A category switched off stops at once. Anything else that leaves one with no source is the
		// listener having moved, out of range or behind a wall, and that fades
		var/switched_off = category.silenced || (no_torch && category == self_category)
		if(switched_off)
			nearest = null
		else if(self_source && category == self_category)
			nearest = self_source
		else
			nearest = nearest_by_category?[category]
			// Occlusion changes WHICH source is served, so it runs before the send. Written back
			// because a later standing service re-reads this list without walking
			if(nearest && occlude_sources)
				var/atom/clear_source = unoccluded_source(nearest, category)
				if(clear_source != nearest)
					if(clear_source)
						nearest_by_category[category] = clear_source
					else
						nearest_by_category -= category
						by_wall = TRUE
					nearest = clear_source
		if(!nearest)
			if(sources[category])
				if(switched_off || clip_advance)
					stop_for(listener_client, category)
				else
					fade_out(listener_client, category, listener_turf, by_wall)
			continue
		var/atom/previous = sources[category]
		var/had_previous = !!previous
		var/fresh = (nearest != previous)
		var/centre = FALSE
		if(fresh)
			sources[category] = nearest
			if(previous)
				category.handoffs++
				centre = category.centre_handoff
			// Back in earshot mid fade out, so the send carries on with the playing clip rather than
			// restarting it, which matters past pillars. A clip set restarts as it always has
			if(!had_previous && !category.files && length(fade_slots) >= category.index)
				var/list/fade_slot = fade_slots[category.index]
				if(fade_slot?[POINT_AMBIENCE_SLOT_FADE_NEXT] && isnull(fade_slot[POINT_AMBIENCE_SLOT_FADE_TARGET]))
					had_previous = TRUE
					fade_takeovers++
		// A standing listener's unchanged source would get the same numbers as last time. Nothing
		// reaches here having moved: anything that moves bumps static_version, which ends standing
		else if(standing && !clip_advance)
			continue
		// A torch in hand is at distance 0 and centred, so walking cannot change how it sounds
		else if(!clip_advance && nearest == self_source && self_send_unchanged(listener_client, category, nearest))
			continue
		// Who this category would fall to, BEFORE the send: the pan blend reads it during one and
		// would otherwise lean on the last service's. A failed send drops the category from sources
		var/list/slot = slot_for(listener_client, category.index)
		if(!clip_only)
			slot[POINT_AMBIENCE_SLOT_RUNNER_UP] = scratch_second[category]
		var/sent
		sends_this_service++
		sent = slim_send(listener, listener_client, category, nearest, fresh, had_previous, FALSE, slot, clip_advance, centre)
		// Nothing usable was sent, so null what was playing or it repeats client-side at a stale
		// volume. Keyed on what was playing, not fresh: a failed switch must still silence it
		if(!sent)
			stop_for(listener_client, category, send_null = had_previous)

/**
 * Resolves what every send in one service needs from the listener, once. Whether they can hear at
 * all (three user procs and an organ walk on a carbon) is held on the client for one
 * standing_walk_interval. Turf, area environment, whether their ear is shut inside something and
 * their point ambience volume are per service, and a caller that already has the turf passes it. Runs after the standing shortcut,
 * never before it: a listener standing still pays nothing here, and one who goes deaf while
 * standing keeps what is playing until a service passes the shortcut after the hearing cache
 * expires. A step, index change or volume change before expiry can still reuse the old hearing
 * result. Returns FALSE when there is nothing to serve, leaving the serving_* vars set otherwise
 */
/datum/controller/subsystem/point_ambience/proc/prepare_serving(client/listener_client, mob/listener, turf/listener_turf, ambience_volume = null)
	SHOULD_NOT_SLEEP(TRUE)
	if(world.time >= listener_client.point_ambience_profile_until)
		listener_client.point_ambience_profile_until = world.time + standing_walk_interval
		listener_client.point_ambience_hearing = listener.can_hear()
	if(!listener_client.point_ambience_hearing)
		return FALSE
	// Checked here so nothing below works for a muted listener. ZERO only, never "low", and null is
	// not zero: no prefs means no scaling rather than silence
	if(isnull(ambience_volume) && listener_client.prefs)
		ambience_volume = listener_client.prefs.point_ambience_volume()
	var/volume_scale = isnull(ambience_volume) ? null : ambience_volume * 0.01
	if(volume_scale == 0)
		return FALSE
	if(!listener_turf)
		listener_turf = get_turf(listener)
		if(!listener_turf)
			return FALSE
	serving_turf = listener_turf
	// Both muffle flags start clear for every service. The wall one is set per category by the
	// grade, and a caller that grades nothing must not inherit the last service's answer
	serving_muffle_wall = FALSE
	// Only a dullahan has an ear that can be inside anything, so nobody else walks a loc chain
	serving_muffle_head = FALSE
	var/atom/movable/ear = listener_client.point_ambience_ear
	if(ear)
		var/atom/holder = ear.loc
		while(holder && !isturf(holder))
			if(istype(holder, /obj/structure/closet) || istype(holder, /obj/item/storage))
				serving_muffle_head = TRUE
				break
			holder = holder.loc
	var/area/A = listener_turf.loc
	serving_indoors = A && !A.outdoors
	serving_environment = (A && A.soundenv && A.soundenv != SOUND_ENVIRONMENT_NONE) ? A.soundenv : SOUND_DEFAULT_ENVIRONMENT
	// null when there are no prefs, so no scaling. A prefs datum with no volume scales to 0,
	// which rejects the send, as playsound_local does
	serving_volume_scale = volume_scale
	return TRUE

/**
 * The verbs' entry to a send, being the dispatch the service otherwise makes inline.
 *
 * Returns the volume sent, FALSE when nothing usable could be, or null when the listener would take
 * playsound_local and there is nothing to dry-run.
 *
 * Arguments:
 * * fresh - the winning source changed, so its source-specific state must be refreshed
 * * had_previous - this category was already playing on the channel, which decides whether a failed
 *   send has to silence it
 * * dry_run - build the datum and return what it would send, without sending
 */
/datum/controller/subsystem/point_ambience/proc/send_source(client/listener_client, mob/listener, datum/point_ambience_category/category, atom/nearest, fresh, had_previous, dry_run = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	return slim_send(listener, listener_client, category, nearest, fresh, had_previous, dry_run)

/**
 * Whether a wall stands between source and listener, so the send should be muffled.
 *
 * Runs ONCE per send, on the source that already won its category, never during the walk, which is
 * the hottest code here. Checking after selection means a blocked source would hold the channel and
 * silence a campfire you can see, so unoccluded_source() falls through to the walk's runner-up,
 * stopping at one. A different floor is never occluded: the line is 2D, so an off-z target would run
 * to the step limit and call everything upstairs a wall.
 *
 * A cut-down can_see(), reading turf opacity and doors but no other object. Doors are objects where
 * walls are turfs, so a turf's contents are looped only where its sound_door_count says one may
 * stand. A listener standing still never re-sends an unchanged static source, so a door's state
 * would freeze into the sound until they moved. recheck_doors() serves them again when one changes.
 *
 * Arguments:
 * * trace - filled with the turfs the line crossed, for the Here verb to print. The live path
 *   passes null, which keeps the reported line and the tested line one walk rather than two.
 */
/datum/controller/subsystem/point_ambience/proc/source_occluded(turf/source_turf, turf/listener_turf, datum/point_ambience_category/category, list/trace)
	if(!occlude_sources || !category.occlude || source_turf == listener_turf || source_turf.z != listener_turf.z)
		return OCCLUSION_CLEAR
	// Graded rather than a bare walk, or this reports SOLID for a source the service is serving muffled
	. = sound_occlusion_grade(listener_turf, source_turf, category.range, FALSE, trace, door_mode)
	count_occlusion_walk()

/**
 * Folds what the last sound_occlusion_grade() cost into this service's totals: one direct walk plus
 * however many probes it needed. The probes are plain procs shared with the token and one-shot
 * paths, so they cannot count into a service themselves
 */
/datum/controller/subsystem/point_ambience/proc/count_occlusion_walk()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/walks = 1 + GLOB.occlusion_probe_walks
	occlusion_checks_this_service += walks
	occlusion_checks_total += walks
	occlusion_tiles_this_service += GLOB.opacity_walk_tiles + GLOB.occlusion_probe_tiles

/**
 * NO LEAK HERE, DELIBERATELY. playsound's SOUND_TRAVEL_LEAKING lets an enclosed listener hear a
 * one-shot faintly for a few tiles past the barrier, and that is right for a one-shot and wrong for
 * a loop. A hearth leaking at a fixed volume through every wall in a town is a permanent drone, and
 * since only the nearest source per category is served it would be a GHOST of a fire nobody can
 * reach, displacing the runner-up below, which is a real one with a real path to it. It would also
 * turn silence into a send on the one system billed per moving listener, and the surveys measured
 * blocked winners as almost always ending in silence.
 *
 * The two states a category actually wants both exist: walls stop it, or `occlude = FALSE` and
 * walls do not apply (the river). If one ever wants the third, it is a `category.leak` flag
 * evaluated AFTER the runner-up fails, so a clear source always wins. Wait for a category to ask.
 *
 * The nearest source of a category that is not behind a wall: the winner where it is clear, the
 * walk's runner-up where the winner is blocked and the runner-up is not, and null where both are.
 * Null silences the category, which is the point, a wall stopping the sound rather than dulling it
 */
/datum/controller/subsystem/point_ambience/proc/unoccluded_source(atom/nearest, datum/point_ambience_category/category)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/atom)
	// source_occluded()'s guards and trace are for the Here verb. The walk itself stays shared
	if(!category.occlude)
		return nearest
	var/turf/source_turf = source_turfs[nearest] || get_turf(nearest)
	if(!source_turf || source_turf == serving_turf || source_turf.z != serving_turf.z)
		return nearest
	if(grade_from_listener(source_turf, category.range) != OCCLUSION_SOLID)
		return nearest
	runner_up_offered++
	var/atom/runner_up = scratch_second[category]
	if(!runner_up || runner_up == nearest)
		runner_up_silenced++
		return null
	var/turf/runner_turf = source_turfs[runner_up] || get_turf(runner_up)
	if(!runner_turf)
		runner_up_silenced++
		return null
	// On the listener's own turf, or a floor away: nothing can stand between, so it is served
	if(runner_turf == serving_turf || runner_turf.z != serving_turf.z)
		runner_up_served++
		return runner_up
	if(grade_from_listener(runner_turf, category.range) == OCCLUSION_SOLID)
		runner_up_silenced++
		return null
	runner_up_served++
	return runner_up

/// Grades one line from the listener, folds its cost into the service and sets the corner muffle,
/// so the winner and the runner-up are held to one rule
/datum/controller/subsystem/point_ambience/proc/grade_from_listener(turf/source_turf, range)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	. = sound_occlusion_grade(serving_turf, source_turf, range, FALSE, null, door_mode)
	// Counted before another walk overwrites what this one cost
	count_occlusion_walk()
	if(. == OCCLUSION_MUFFLED)
		occlusion_corners++
		serving_muffle_wall = TRUE

/// The client's send state for one category, allocated once per client per category like the
/// sound datum beside it. The slim send inlines this. The rare paths call it
/datum/controller/subsystem/point_ambience/proc/slot_for(client/listener_client, index)
	PRIVATE_PROC(TRUE)
	var/list/slots = listener_client.point_ambience_slots
	if(length(slots) < index)
		slots.len = index
	var/list/slot = slots[index]
	if(!slot)
		slot = new /list(POINT_AMBIENCE_SLOT_FIELDS)
		slots[index] = slot
	return slot

/**
 * The ambience send: builds the datum playsound_local would and sends it, without the proc call.
 *
 * Exactly the ambience input shape, a turf source at the category's range with no pitch vary and no
 * ERP class. One datum per client per category is reused. What the SOURCE decides (file, channel,
 * falloff range, pitch) is written when playback begins. A source handoff updates pitch without
 * replacing or seeking the loaded file. Everything the LISTENER's position decides is per send.
 *
 * playsound_local was the specification and this was a field for field mirror of it. It now
 * diverges on purpose in two places, the hard decay curve and the depth floor pan, and matches
 * it everywhere else. Nothing in the repo checks that. The Send Diff verb does, in a legacy
 * configuration that removes both divergences, and it is one of the measurement verbs kept
 * out of git.
 *
 * Arguments:
 * * fresh - the winning source changed, so its source-specific state must be refreshed
 * * had_previous - this category was already playing, which decides whether a failed send has to
 *   silence it
 * * dry_run - fill the datum and return what it would send, without sending
 * * clip_advance - choose the next file in a clip set without treating it as a new arrival
 * * centre - send this one centred, the send that switches source under centre_handoff
 *
 * Decisions a reader would otherwise undo:
 *
 * One file a category means every sconce on a wall is the same sconce. A category asking for
 * unique_voice gives each source a voice fixed by WHERE IT STANDS, so it always sounds like itself
 * and never like its neighbour: a lean on the pitch, and its own starting place in the loop. The
 * place is applied only when playback begins because offset on SOUND_UPDATE seeks the playing clip.
 * A torch in the hand keeps the plain voice.
 *
 * At hardness 1 every tile drops the same PROPORTION, so the fade is even in decibels, which is what
 * the ear measures. It also lands on the floor with slope still on it, where the band power curve
 * approaches the floor asymptotically and spends its last tiles within a decibel of it. Above 1
 * front-loads the drop, trading that evenness for separation close in. Hardness 0 is the band power
 * curve, CALCULATE_SOUND_VOLUME_RATIO with the reciprocal read rather than divided.
 *
 * The pan is taken from the listener's turf, then held at a minimum depth so a sideways source stays
 * out of one ear, only the angle changing and not the magnitude. A plain dead zone zeroes an axis
 * within a tile, which puts a source 1.4 tiles off the shoulder dead ahead and then snaps it to 45
 * degrees on the next step. The direction is also leaned toward the runner-up, so a road of braziers
 * slides between ears instead of flipping as the nearest changes.
 */
/datum/controller/subsystem/point_ambience/proc/slim_send(mob/listener, client/listener_client, datum/point_ambience_category/category, atom/nearest, fresh, had_previous, dry_run, list/slot, clip_advance = FALSE, centre = FALSE)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/index = category.index
	if(!slot)
		var/list/slots = listener_client.point_ambience_slots
		if(length(slots) < index)
			slots.len = index
		slot = slots[index]
		if(!slot)
			slot = new /list(POINT_AMBIENCE_SLOT_FIELDS)
			slots[index] = slot
	var/list/sounds = listener_client.point_ambience_sounds
	if(length(sounds) < index)
		sounds.len = index
	var/sound/S = sounds[index]
	if(!S)
		S = sound()
		sounds[index] = S
	var/restarting = FALSE
	// Re-read on every send because a dragged or retuned source may still be the winning atom
	slot[POINT_AMBIENCE_SLOT_TURF] = source_turfs[nearest] || get_turf(nearest)
	var/vol = category.volume * (category.source_volumes[nearest] || 1)
	var/continuous = category.source_continuous[nearest]
	// Where in the loop this source plays from, 0 to 1. Null when the send is not moving to a source
	// with a voice of its own
	var/voice_phase = null
	if(fresh || clip_advance)
		// A change of source is not a restart: playback carries through the handoff. A clip set picks
		// another file only when its current clip advances
		var/loaded = slot[POINT_AMBIENCE_SLOT_FILE]
		if(clip_advance || !had_previous)
			restarting = TRUE
			var/file
			if(category.files)
				// Never the clip just played, where there is a choice
				var/list/choices = (length(category.files) > 1) ? (category.files - loaded) : category.files
				file = pick(choices)
			else
				file = category.source_sounds[nearest] || category.sound_file
			slot[POINT_AMBIENCE_SLOT_FILE] = file
			// One roll per stretch, re-sent on every update: frequency 0 on a SOUND_UPDATE would
			// snap the pitch back to normal mid-loop
			slot[POINT_AMBIENCE_SLOT_FREQUENCY] = category.vary_pitch ? get_rand_frequency() : 0
			S.file = file
			S.repeat = TRUE
			S.wait = 0
			S.channel = category.channel
			S.falloff = category.range
			S.frequency = slot[POINT_AMBIENCE_SLOT_FREQUENCY]
			// A set of clips is advanced from here: when this one ends the listener is served
			// afresh and picks another. repeat stays on above so a late timer leaves no silence
			if(category.files && !dry_run)
				if(slot[POINT_AMBIENCE_SLOT_TIMER])
					deltimer(slot[POINT_AMBIENCE_SLOT_TIMER])
				slot[POINT_AMBIENCE_SLOT_TIMER] = addtimer(CALLBACK(src, PROC_REF(advance_clip), listener_client, category), max(SSsounds.get_sound_length(file), 10), TIMER_STOPPABLE)
		// A voice fixed by where the source stands, so a sconce never sounds like its neighbour.
		// Rides the packet a change of source already sends. See the proc doc
		if(category.unique_voice)
			var/pitch = slot[POINT_AMBIENCE_SLOT_FREQUENCY]
			var/turf/voice_turf = slot[POINT_AMBIENCE_SLOT_TURF]
			if(voice_turf && nearest != listener.point_ambience_self_source)
				if(voice_pitch)
					var/lean = 1 + voice_pitch * (((voice_turf.x * 37 + voice_turf.y * 101 + voice_turf.z * 59) % 21) - 10) / 10
					// Onto the rolled rate where there is one. Without one the lean goes out as a
					// plain multiple, which is right at any sample rate
					pitch = pitch ? pitch * lean : lean
				if(restarting && voice_offset && category.voice_place)
					voice_phase = ((voice_turf.x * 73 + voice_turf.y * 179 + voice_turf.z * 283) % 97) / 97
			// Always written, so a lean left over from the last source never outlives it
			S.frequency = pitch
	var/turf/source_turf = slot[POINT_AMBIENCE_SLOT_TURF]
	if(!source_turf)
		return FALSE
	// Before the floor, so a category cut indoors keeps its dB per tile and only drops a level
	if(serving_indoors && category.indoors_volume_mult != 1)
		vol *= category.indoors_volume_mult
	// A share of THIS source's volume, so the walk keeps its dB per tile at any level. Taken
	// before the muffle cut, so a muffled send lands on the same edge level as a clear one
	var/volume_floor = vol * category.floor_ratio
	// Two floors away is silent, one is muffled. Only ranges under the long band muffle by
	// storey, so the band test stays even though every category is under it today
	var/storeys = (category.range < SOUND_RANGE_LONG) ? abs(source_turf.z - serving_turf.z) : 0
	if(storeys >= 2)
		return FALSE
	// Heavier falloff, a quarter off the volume, a dead room and the occlusion echo. A wall with
	// no way round it is not served at all and never reaches here
	var/muffled = storeys || serving_muffle_wall || serving_muffle_head
	var/environment = serving_environment
	var/list/echo = null
	if(muffled)
		// A wall takes the heavier cut, as playsound_local's wall profile does. At the -34 dB the
		// clips now sit at, a quarter off is a hearth heard through a wall
		vol *= serving_muffle_wall ? SOUND_MUFFLE_WALL_VOLUME_MULT : SOUND_MUFFLE_VOLUME_MULT
		environment = SOUND_MUFFLE_ENVIRONMENT
		echo = storey_echo
	var/hardness = muffled ? category.muffled_hardness : category.falloff_hardness
	var/inv_exponent = muffled ? category.inv_muffled_exponent : category.inv_falloff_exponent
	var/dx = source_turf.x - serving_turf.x
	var/dy = source_turf.y - serving_turf.y
	// Keep this local: STOREY_ADJUSTED_DISTANCE names its first argument three times
	var/distance = sqrt(dx * dx + dy * dy)
	distance = STOREY_ADJUSTED_DISTANCE(distance, storeys)
	var/fall_ratio = max(distance - SOUND_DEFAULT_FALLOFF_DISTANCE, 0) / (max(category.range, distance) - SOUND_DEFAULT_FALLOFF_DISTANCE)
	var/volume
	if(hardness && vol > 1)
		var/reach_floor = max(min(volume_floor, vol), 0.01)
		volume = vol * (reach_floor / vol) ** (hardness == 1 ? fall_ratio : fall_ratio ** (1 / hardness))
	else
		volume = vol - (fall_ratio ** inv_exponent) * (vol - volume_floor)
	var/pan_x = 0
	var/pan_z = 0
	// Continuous source handoffs would reverse between opposite voices, so their stereo image stays centred
	if(!continuous && !centre)
		pan_lean(slot, category, nearest, source_turf, dx, dy)
		var/lean_dx = serving_lean_dx
		var/lean_dy = serving_lean_dy
		pan_x = pan_depth_floor ? lean_dx : ((lean_dx <= 1 && lean_dx >= -1) ? 0 : lean_dx)
		pan_z = pan_depth_floor ? lean_dy : ((lean_dy <= 1 && lean_dy >= -1) ? 0 : lean_dy)
		if(pan_x && SOUND_PAN_MIN_DEPTH)
			var/min_depth = pan_depth_floor \
				? max(abs(pan_x) * max(1, SOUND_PAN_NEAR_DEPTH / max(distance, 1)), SOUND_PAN_MIN_DEPTH_ABS) \
				: abs(pan_x) * SOUND_PAN_MIN_DEPTH
			if(abs(pan_z) < min_depth)
				var/original = sqrt(pan_x * pan_x + pan_z * pan_z)
				pan_z = (pan_z < 0) ? -min_depth : min_depth
				var/widened = sqrt(pan_x * pan_x + pan_z * pan_z)
				if(widened)
					var/ratio = original / widened
					pan_x *= ratio
					pan_z *= ratio
	if(storeys)
		volume *= SOUND_STOREY_VOLUME_MULT
	if(!isnull(serving_volume_scale))
		volume *= serving_volume_scale
	volume = min(volume, 100)
	// Against what the listener actually receives, and set to the volume a category's floor
	// fades to, so this refuses what is under hearing and never anything above it
	if(volume <= 0 || volume < send_cutoff)
		return FALSE
	// Same volume, same room, no restart due, and a continuous run has no pan to have changed, so
	// there is nothing to tell the client. A vertical change at matched volume is not caught
	if(continuous && had_previous && !restarting && slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] == volume && slot[POINT_AMBIENCE_SLOT_ENVIRONMENT] == environment)
		return volume
	// Status 0 restarts the file and the block above already decided that. Both must give the SAME
	// answer, since a rewritten file with SOUND_UPDATE is half a restart either way
	S.status = restarting ? 0 : SOUND_UPDATE
	S.environment = environment
	S.x = pan_x
	S.z = pan_z
	S.y = source_turf.z - serving_turf.z
	S.echo = echo
	S.volume = volume
	if(!dry_run)
		// A real packet ends whatever fade this was in. One from silence opens quietly instead and
		// fire() brings it up, a service landing inside the climb ending it at the true volume
		var/was_fading = slot[POINT_AMBIENCE_SLOT_FADE_NEXT]
		var/climb = 0
		// Every restart except a clip advance climbs, including a new stretch after silence
		if(restarting && fade_in_steps && !clip_advance && (was_fading || length(fading) < POINT_AMBIENCE_FADE_CAP * 2))
			var/opening = volume
			while(climb < fade_in_steps && opening * fade_ratio >= fade_skip)
				opening *= fade_ratio
				climb++
			if(climb)
				S.volume = opening
				var/due = round(world.time) + POINT_AMBIENCE_FADE_STEP
				slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = due
				slot[POINT_AMBIENCE_SLOT_FADE_TARGET] = volume
				slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = climb
				fade_next_due = length(fading) ? min(fade_next_due, due) : due
				if(!was_fading)
					fading += listener_client
					fading += category
				fade_in_starts++
		if(!climb && was_fading)
			slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = null
			slot[POINT_AMBIENCE_SLOT_FADE_TARGET] = null
			slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = null
		// The seek goes out on this one packet and is taken straight back off the datum, or every
		// later update would drag the clip back to the same second
		var/rest_offset = S.offset
		if(!isnull(voice_phase))
			var/clip_length = SSsounds.get_sound_length(slot[POINT_AMBIENCE_SLOT_FILE])
			if(clip_length)
				S.offset = voice_phase * clip_length / 10
		SEND_SOUND(listener, S)
		S.offset = rest_offset
		// What was actually sent, which a climb makes lower than what is returned
		slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = S.volume
		slot[POINT_AMBIENCE_SLOT_ENVIRONMENT] = environment
	return volume

/// How many sources a walk from a turf would rank, and per category name when a list is given.
/// Counts what the cells the walk probes hold, without ranking any of it. For the verbs
/datum/controller/subsystem/point_ambience/proc/count_walked(turf/from, list/by_category)
	. = 0
	if(!from || length(buckets_by_z) < from.z)
		return
	var/list/floor_buckets = buckets_by_z[from.z]
	if(!floor_buckets)
		return
	var/cells = length(floor_buckets)
	var/by_lo = max(1, from.y - max_range) >> CELL_SHIFT
	var/by_hi = (from.y + max_range) >> CELL_SHIFT
	for(var/bx in (max(1, from.x - max_range) >> CELL_SHIFT) to ((from.x + max_range) >> CELL_SHIFT))
		var/row = bx * cell_stride + 1
		for(var/by in by_lo to by_hi)
			var/cell = row + by
			if(cell > cells)
				break
			var/list/bucket = floor_buckets[cell]
			if(!bucket)
				continue
			. += length(bucket) / 4
			if(by_category)
				for(var/i = 3, i <= length(bucket), i += 4)
					var/datum/point_ambience_category/category = categories[bucket[i]]
					by_category[category.config_name] += 1

/**
 * Attaches the move hook to every mob a player is in, now and on every future login. Moving
 * listeners are served by the hook. The tick covers the ones standing still and sources that
 * change state beside them
 */
/datum/controller/subsystem/point_ambience/proc/hook_logins()
	PRIVATE_PROC(TRUE)
	hooked_logins = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGIN, PROC_REF(player_login))
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGOUT, PROC_REF(player_logout))
	for(var/client/listener_client as anything in GLOB.clients)
		if(listener_client.mob)
			player_login(null, listener_client.mob)

/// Observers get no ambience: whatever the client was hearing stops here, on the transition
/// itself, and no move hook is attached to the ghost
/datum/controller/subsystem/point_ambience/proc/player_login(datum/source, mob/player)
	SIGNAL_HANDLER
	if(isobserver(player))
		stop_all_for(player.client)
		return
	if(player.client)
		player.client.point_ambience_last_move = null
		player.client.point_ambience_speed_moved = null
		player.client.point_ambience_speed_silenced = FALSE
		update_silenced(player.client)

/**
 * Recomputes whether a listener hears point ambience at all and attaches or detaches their move
 * hook to match, so a silenced listener's steps cost nothing, the same as an observer's. Only
 * called when the answer can change: at login and from the volume menu. Nothing on a per step or
 * per walk path reads preferences for this
 */
/datum/controller/subsystem/point_ambience/proc/update_silenced(client/listener_client)
	PRIVATE_PROC(TRUE)
	var/datum/preferences/prefs = listener_client.prefs
	// A slider low enough that even the loudest category at distance 0 would be dropped by the
	// cutoff is silence in practice, so it unhooks like a zero rather than costing a service a step
	var/effective_volume = prefs ? prefs.point_ambience_volume() : 0
	var/scaled = effective_volume * 0.01
	listener_client.point_ambience_silenced = prefs && ((prefs.toggles & SOUND_DISABLE_POINT_AMBIENCE) || !effective_volume || (send_cutoff && loudest_volume * scaled < send_cutoff))
	var/mob/player = listener_client.mob
	if(!player || isobserver(player))
		// A ghost has no ear, and a watch left behind would go on holding the old body's head
		if(listener_client.point_ambience_head_watch)
			qdel(listener_client.point_ambience_head_watch)
		return
	if(listener_client.point_ambience_silenced)
		UnregisterSignal(player, COMSIG_MOVABLE_MOVED)
	else
		RegisterSignal(player, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)
	// Kept whether they are silenced or not: it costs nothing while nothing moves, and an ear
	// resolved only on unsilencing would be wrong for the first service after it
	update_head_watch(listener_client, player)
	RegisterSignal(player, COMSIG_SPECIES_GAIN, PROC_REF(on_species_changed), override = TRUE)
	RegisterSignal(player, COMSIG_SPECIES_LOSS, PROC_REF(on_species_changed), override = TRUE)

/**
 * A listener changed their point ambience preferences. Silences their channels, drops their
 * standing cache so the next service rebuilds whatever they should hear now from nothing, and
 * attaches or detaches their move hook to match.
 *
 * BOTH directions need this, for different reasons. Turning something OFF leaves the sound playing
 * with nothing that will ever service them again to stop it. Turning it back ON leaves their turf
 * and version unchanged, so the standing shortcut returns before the send loop and they stay silent
 * until they happen to walk.
 */
/datum/controller/subsystem/point_ambience/proc/listener_prefs_changed(client/listener_client)
	stop_all_for(listener_client)
	update_silenced(listener_client)

/// Silences every category for one listener and clears their cached walk, so the next service is
/// fresh. Leaving the cache would let a stationary listener take the shortcut and stay silent
/datum/controller/subsystem/point_ambience/proc/stop_all_for(client/listener_client)
	PRIVATE_PROC(TRUE)
	if(!listener_client)
		return
	listener_client.point_ambience_clip_due = FALSE
	listener_client.point_ambience_last_move = null
	var/list/slots = listener_client.point_ambience_slots
	for(var/datum/point_ambience_category/category as anything in categories)
		if(listener_client.point_ambience_sources[category])
			stop_for(listener_client, category)
			continue
		// A fade out has left point_ambience_sources while its channel still plays, so the loop above
		// cannot see it and the runner would send its remaining steps into a muted listener
		var/list/slot = (length(slots) >= category.index) ? slots[category.index] : null
		if(slot)
			slot[POINT_AMBIENCE_SLOT_CLIP_DUE] = null
		if(slot?[POINT_AMBIENCE_SLOT_FADE_NEXT])
			stop_for(listener_client, category)
	// The cached turf goes too, or a listener who was standing still is silenced until they walk:
	// their turf and version still match, so the next service returns before the send loop
	listener_client.point_ambience_cache_turf = null

/datum/controller/subsystem/point_ambience/proc/player_logout(datum/source, mob/player)
	SIGNAL_HANDLER
	UnregisterSignal(player, list(COMSIG_MOVABLE_MOVED, COMSIG_SPECIES_GAIN, COMSIG_SPECIES_LOSS))
	// The set is deliberately not touched: a client that merely changed mobs is still owed a
	// service, and one that truly left leaves a null key for drain_dirty() to drop

/**
 * Marks a listener for a service after something the move hook cannot see: their ear moved, or what
 * carries it did. Drops the standing cache too, or the walk would shortcut straight past the change.
 */
/datum/controller/subsystem/point_ambience/proc/mark_listener(client/listener_client)
	if(!listener_client || mode != POINT_AMBIENCE_LIVE || listener_client.point_ambience_silenced)
		return
	listener_client.point_ambience_cache_turf = null
	listener_client.point_ambience_last_move = null
	if(use_queue && !dirty_clients[listener_client])
		dirty_clients[listener_client] = world.time

/// A door's opacity changed, through set_opacity or one of the writes that bypass it. Collected
/// rather than acted on, so a door worked back and forth is gathered once a period
/datum/controller/subsystem/point_ambience/proc/door_changed(obj/structure/mineral_door/door)
	door_changes++
	if(!door_recheck || door_mode < SOUND_DOORS_LIVE || mode != POINT_AMBIENCE_LIVE)
		return
	var/turf/door_turf = get_turf(door)
	if(door_turf)
		changed_doors[door_turf] = TRUE

/**
 * Serves again every listener a changed door could stand between and one of their sources. The
 * spatial grid finds who is in reach, the box filter drops those whose sources lie elsewhere, and
 * mark_listener() queues the rest past the standing shortcut.
 *
 * The grid follows bodies, so a detached head near the door is not found. Its listener catches up
 * when the head or the body next moves
 */
/datum/controller/subsystem/point_ambience/proc/recheck_doors()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	next_door_recheck = world.time + door_recheck_period
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_door_recheck")
	for(var/turf/door_turf as anything in changed_doors)
		door_gathers++
		for(var/mob/listener as anything in SSspatial_grid.orthogonal_range_search(door_turf, SPATIAL_GRID_CONTENTS_TYPE_CLIENTS, max_range))
			var/client/listener_client = listener.client
			if(!listener_client || isobserver(listener))
				continue
			// The ear is the head, somewhere else, so the body's position says nothing
			if(listener_client.point_ambience_ear)
				mark_listener(listener_client)
				continue
			var/turf/listener_turf = get_turf(listener)
			// The grid answers in whole 17 tile cells, so this is the actual reach
			if(!listener_turf || listener_turf.z != door_turf.z \
				|| abs(listener_turf.x - door_turf.x) > max_range || abs(listener_turf.y - door_turf.y) > max_range)
				continue
			door_listeners_found++
			if(door_recheck_filter && !door_in_reach(listener_turf, door_turf))
				continue
			door_listeners_marked++
			mark_listener(listener_client)
	changed_doors.Cut()
	if(timing)
		door_gather_ms += rustg_time_microseconds("pa_door_recheck") / 1000

/**
 * Whether a door could stand on a line a service walks from this turf: inside the box between the
 * listener and the winner or runner-up of a category walls can block, widened by one tile for the
 * corner probes. Reads the tile cache's ranking, which is taken before occlusion. A service writes
 * its occlusion answer into the listener's own list, so a source a shut door silenced is gone from
 * there and opening the door would never bring it back. No ranking to read means no way to rule
 * the door out
 */
/datum/controller/subsystem/point_ambience/proc/door_in_reach(turf/listener_turf, turf/door_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!use_tile_cache || cross_floor)
		return TRUE
	var/entry = tile_cache[listener_turf]
	if(isnull(entry))
		return TRUE
	// TRUE is an empty ranking, nothing in range to block
	if(!islist(entry))
		return FALSE
	var/list/ranking = entry
	for(var/i = 1, i <= length(ranking), i += 5)
		var/datum/point_ambience_category/category = ranking[i]
		if(!category.occlude)
			continue
		if(door_in_box(listener_turf, ranking[i + 1], door_turf) || door_in_box(listener_turf, ranking[i + 3], door_turf))
			return TRUE
	return FALSE

/datum/controller/subsystem/point_ambience/proc/door_in_box(turf/listener_turf, atom/source, turf/door_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!source)
		return FALSE
	var/turf/source_turf = source_turfs[source] || get_turf(source)
	if(!source_turf)
		return FALSE
	return door_turf.x >= min(listener_turf.x, source_turf.x) - 1 && door_turf.x <= max(listener_turf.x, source_turf.x) + 1 \
		&& door_turf.y >= min(listener_turf.y, source_turf.y) - 1 && door_turf.y <= max(listener_turf.y, source_turf.y) + 1

/// One watch per dullahan client and none for anybody else, so nothing on everyone's path resolves
/// a species. Called at login and whenever the species changes
/datum/controller/subsystem/point_ambience/proc/update_head_watch(client/listener_client, mob/player)
	PRIVATE_PROC(TRUE)
	var/datum/point_ambience_head_watch/watch = listener_client.point_ambience_head_watch
	var/mob/living/carbon/human/human = player
	if(!istype(human) || !istype(human.dna?.species, /datum/species/dullahan))
		if(watch)
			qdel(watch)
		return
	if(watch)
		watch.retarget(human)
	else
		listener_client.point_ambience_head_watch = new /datum/point_ambience_head_watch(listener_client, human)

/// The gain signal is sent before the dullahan assigns my_head, so the watch is built a tick later
/datum/controller/subsystem/point_ambience/proc/on_species_changed(mob/player)
	SIGNAL_HANDLER
	addtimer(CALLBACK(src, PROC_REF(rebuild_head_watch), player), 0)

/datum/controller/subsystem/point_ambience/proc/rebuild_head_watch(mob/player)
	PRIVATE_PROC(TRUE)
	var/client/listener_client = player?.client
	if(listener_client)
		update_head_watch(listener_client, player)

/**
 * Requests source discovery and positional updates on eligible steps, normally through the queue.
 * The interval can skip moves. The periodic client walk catches a skipped final step. Discovery
 * must include new sources, since refreshing only those already heard delays entry into range.
 *
 * The inline path carries two rails, which the queue does not need because the drain applies the
 * budget in the tick's slack. TICK_USAGE bounds the peak tick, rising with what a service costs and
 * with whatever else is loading the tick, which is the tick a crowd makes. The count bounds the
 * second, which tick usage alone does not. Both sit AFTER the interval gate, so a move it was
 * dropping anyway never spends the budget, and BEFORE the stamp, so a refused step does not also
 * spend the client's interval: they retry next move and fire() catches them within a second.
 * TICK_CHECK_LOW rather than the MC limit, since this runs inside Move(), and Move() runs in the
 * verb slot at the END of the tick, after the MC, gc and SendMaps have spent their share. The usage
 * read there is already high whenever the server is busy at all, so on a loaded server this path
 * refuses most steps. That is why the queue is the default and this is the fallback
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
	// A teleport or a floor change lands where the last budget knows nothing, so it goes to a
	// full service without a gated step being spent on it. One a second: whatever carries a player
	// by forced moves, tile after tile, would otherwise buy a service every tick. A jump held back
	// counts as a step from here on, so keep "was it a jump" apart from "is it served now"
	var/turf/old_turf = old_loc
	var/discontinuous = forced || (old_turf && old_turf.z != listener.z)
	var/jump_served = discontinuous && world.time >= listener_client.point_ambience_jump_next
	if(jump_served)
		listener_client.point_ambience_jump_next = world.time + POINT_AMBIENCE_JUMP_GAP
	listener_client.point_ambience_last_move = jump_served ? null : world.time
	// A plain read for anyone on foot, the proc only for a rider
	var/step_delay = listener.buckled ? step_delay_of(listener) : listener.cached_multiplicative_slowdown
	var/urgent = jump_served
	// Faster than a natural run hears nothing while moving. The first such step and the first one
	// back at a natural pace pass the interval, so neither the silence nor the return waits for it.
	// Not for a headless dullahan, whose ear is the head rather than the body doing the running, and
	// not for a mob whose pace was never computed, which a null would otherwise read as fastest
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
	if(GLOB.point_ambience_counters && measure_move_gate)
		observe_move_gate(listener_client, listener, discontinuous)
	// Two rails, for the inline path only. Both sit after the interval gate and before the stamp.
	// See the proc doc
	if(!use_queue && max_services_per_tick)
		if(TICK_CHECK_LOW)
			services_dropped_tick++
			note_drop()
			return
		if(world.time != services_tick_stamp)
			services_tick_stamp = world.time
			services_this_tick = 0
		if(services_this_tick >= max_services_per_tick)
			services_dropped_count++
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
	// Timed in place when a survey runs
	move_services++
	listener_client.point_ambience_last_service = world.time
	if(GLOB.point_ambience_survey)
		GLOB.point_ambience_survey.time_real_service(listener_client)
		return
	service_client(listener_client)

/// Deciseconds between this listener's steps as the movement code spaces them: a rider at the
/// mount's pace, anyone else at their own. A diagonal or a strafe adds to one step after this is read
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

/**
 * Finds the nearest and second-nearest source per category for this listener position.
 *
 * Same-floor selection may load an immutable turf ranking. Cross-floor selection retains the
 * direct or cell-cache path, where the listener's own floor wins and adjacent floors only fill
 * unanswered categories. The returned winner table belongs to the client and may be changed by
 * live occlusion after this proc returns. Volume and preferences are applied per listener
 */
/datum/controller/subsystem/point_ambience/proc/nearest_sources(turf/listener_turf, client/listener_client)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list)
	var/z = listener_turf.z
	// Ranked straight into the list the client keeps, so a walk allocates nothing
	var/list/best = listener_client.point_ambience_cache_static
	if(best)
		best.Cut()
	else
		best = list()
	if(use_tile_cache && !cross_floor)
		// Tile hits never refresh the per-client candidate lists. Release their source references and
		// force a rebuild if selection returns to the cell path
		if(listener_client.point_ambience_cell_candidates)
			listener_client.point_ambience_cell_candidates = null
			listener_client.point_ambience_cell_above = null
			listener_client.point_ambience_cell_below = null
			listener_client.point_ambience_cell_version = null
		var/entry = get_tile_ranking(listener_turf)
		if(islist(entry))
			var/list/ranking = entry
			for(var/i = 1, i <= length(ranking), i += 5)
				var/datum/point_ambience_category/category = ranking[i]
				best[category] = ranking[i + 1]
				if(ranking[i + 3])
					scratch_second[category] = ranking[i + 3]
		listener_client.point_ambience_cache_static = best
		return best
	var/list/best_distsq = scratch_best_distsq
	best_distsq.Cut()
	scratch_second_distsq.Cut()
	if(!use_cell_cache)
		collect_nearest_on_z(listener_turf.x, listener_turf.y, z, best, best_distsq)
		ranked_candidates_this_service = round(length(scratch_uncached) / 4)
	else
		// The SAME expression register_source() keys a bucket with, + 1 included. That + 1 also keeps
		// it non-zero, since the cell index starts null and DM compares null equal to 0
		var/cell = (listener_turf.x >> CELL_SHIFT) * cell_stride + (listener_turf.y >> CELL_SHIFT) + 1
		if(listener_client.point_ambience_cell_index != cell \
			|| listener_client.point_ambience_cell_z != z \
			|| listener_client.point_ambience_cell_version != static_version)
			rebuilt_this_service = TRUE
			listener_client.point_ambience_cell_index = cell
			listener_client.point_ambience_cell_z = z
			listener_client.point_ambience_cell_version = static_version
			var/list/candidates = listener_client.point_ambience_cell_candidates
			if(candidates)
				candidates.Cut()
			else
				candidates = list()
				listener_client.point_ambience_cell_candidates = candidates
			collect_candidates(listener_turf.x, listener_turf.y, z, candidates)
			// Dropped rather than rebuilt: the storey passes run only when the own floor leaves
			// a category unanswered, so most cells never ask for these
			listener_client.point_ambience_cell_above = null
			listener_client.point_ambience_cell_below = null
		rank_candidates(listener_turf.x, listener_turf.y, listener_client.point_ambience_cell_candidates, best, best_distsq)
		ranked_candidates_this_service = round(length(listener_client.point_ambience_cell_candidates) / 4)

	if(cross_floor && length(best) < answerable_categories)
		// A snapshot, taken before the storey passes so an own-floor answer cannot be replaced by one
		// a storey away, while a category answered only above can still lose to a nearer one below
		var/list/settled = scratch_settled
		settled.Cut()
		for(var/datum/point_ambience_category/category as anything in best)
			settled[category] = TRUE
		var/above = floor_above(z)
		if(above && floor_needs_pass(above, settled))
			if(!use_cell_cache)
				collect_nearest_on_z(listener_turf.x, listener_turf.y, above, best, best_distsq, settled)
			else
				if(isnull(listener_client.point_ambience_cell_above))
					listener_client.point_ambience_cell_above = list()
					collect_candidates(listener_turf.x, listener_turf.y, above, listener_client.point_ambience_cell_above)
				rank_candidates(listener_turf.x, listener_turf.y, listener_client.point_ambience_cell_above, best, best_distsq, settled)
		var/below = floor_below(z)
		if(below && floor_needs_pass(below, settled))
			if(!use_cell_cache)
				collect_nearest_on_z(listener_turf.x, listener_turf.y, below, best, best_distsq, settled)
			else
				if(isnull(listener_client.point_ambience_cell_below))
					listener_client.point_ambience_cell_below = list()
					collect_candidates(listener_turf.x, listener_turf.y, below, listener_client.point_ambience_cell_below)
				rank_candidates(listener_turf.x, listener_turf.y, listener_client.point_ambience_cell_below, best, best_distsq, settled)

	listener_client.point_ambience_cache_static = best
	return best

/// Returns a turf's cached same-floor ranking, optionally verifying and repairing a hit
/datum/controller/subsystem/point_ambience/proc/get_tile_ranking(turf/listener_turf)
	SHOULD_NOT_SLEEP(TRUE)
	var/cached = tile_cache[listener_turf]
	if(isnull(cached))
		tile_cache_misses++
		var/computed = rank_tile(listener_turf)
		tile_cache[listener_turf] = computed
		tile_cache_entries++
		return computed
	tile_cache_hits++
	if(!verify_tile_cache)
		return cached
	tile_cache_checks++
	var/expected = rank_tile(listener_turf)
	var/matches = (cached == expected)
	if(islist(cached) && islist(expected))
		var/list/cached_ranking = cached
		var/list/expected_ranking = expected
		matches = (length(cached_ranking) == length(expected_ranking))
		for(var/i = 1, matches && i <= length(cached_ranking), i++)
			if(cached_ranking[i] != expected_ranking[i])
				matches = FALSE
	if(matches)
		return cached
	tile_cache_mismatches++
	tile_cache[listener_turf] = expected
	return expected

/**
 * Builds one immutable same-floor ranking for the tile cache.
 *
 * TRUE represents an empty ranking because null means a missing associative entry. Non-empty
 * rankings are flat runs of category, winner, distance squared, runner-up and its distance squared
 */
/datum/controller/subsystem/point_ambience/proc/rank_tile(turf/listener_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	scratch_tile_best.Cut()
	scratch_best_distsq.Cut()
	scratch_second.Cut()
	scratch_second_distsq.Cut()
	collect_nearest_on_z(listener_turf.x, listener_turf.y, listener_turf.z, scratch_tile_best, scratch_best_distsq)
	ranked_candidates_this_service = round(length(scratch_uncached) / 4)
	// The entry keeps only its ranking, so release the gathered source references after counting them
	scratch_uncached.Cut()
	if(!length(scratch_tile_best))
		return TRUE
	var/list/ranking = new /list(length(scratch_tile_best) * 5)
	var/i = 1
	for(var/datum/point_ambience_category/category as anything in scratch_tile_best)
		ranking[i] = category
		ranking[i + 1] = scratch_tile_best[category]
		ranking[i + 2] = scratch_best_distsq[category]
		ranking[i + 3] = scratch_second[category]
		ranking[i + 4] = scratch_second_distsq[category]
		i += 5
	scratch_tile_best.Cut()
	return ranking

/**
 * Invalidates live ranking entries within a source's reach on its current floor.
 *
 * Values become null rather than removing their keys, preserving visited positions without
 * reindexing the associative lists. Their entry counters track live entries independently
 */
/datum/controller/subsystem/point_ambience/proc/invalidate_tile_cache(turf/center, radius)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// Inside a bulk update the close flushes every entry at once
	if(!center || !tile_cache_entries || bulk_depth)
		return
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_tile_invalidate")
	var/turf/lower = locate(max(1, center.x - radius), max(1, center.y - radius), center.z)
	var/turf/upper = locate(min(world.maxx, center.x + radius), min(world.maxy, center.y + radius), center.z)
	for(var/turf/affected as anything in block(lower, upper))
		if(!isnull(tile_cache[affected]))
			tile_cache[affected] = null
			tile_cache_entries--
			tile_cache_cleared++
	if(timing)
		tile_cache_invalidation_ms += rustg_time_microseconds("pa_tile_invalidate") / 1000

/**
 * Every register and unregister that changes the index ends here exactly once, so this is where an
 * actual change is known and counted. Records it in the history can_reuse_tile_listener() reads,
 * except inside a bulk update, whose close empties that history
 */
/datum/controller/subsystem/point_ambience/proc/record_source_change(version_before, turf/old_turf, old_range, turf/new_turf, new_range)
	SHOULD_NOT_SLEEP(TRUE)
	if(version_before == static_version)
		return
	if(bulk_depth)
		bulk_changes++
		return
	// Mapload registers every mapped source within a few ticks by design, so only live play counts
	if(SSatoms.initialized == INITIALIZATION_INNEW_REGULAR)
		if(burst_time != world.time)
			burst_time = world.time
			burst_changes = 0
		burst_changes++
		if(burst_changes == POINT_AMBIENCE_BULK_BURST)
			report_unbatched_burst()
	if(!use_tile_cache || cross_floor)
		return
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_source_history")
	source_change_history.Add(version_before, static_version, old_turf?.x, old_turf?.y, old_turf?.z, old_range, new_turf?.x, new_turf?.y, new_turf?.z, new_range)
	var/overflow = length(source_change_history) - POINT_AMBIENCE_SOURCE_CHANGE_FIELDS * POINT_AMBIENCE_SOURCE_CHANGE_LIMIT
	if(overflow > 0)
		source_change_history.Cut(1, overflow + 1)
	if(timing)
		tile_cache_invalidation_ms += rustg_time_microseconds("pa_source_history") / 1000

/datum/controller/subsystem/point_ambience/proc/can_reuse_tile_listener(turf/listener_turf, cached_version)
	SHOULD_NOT_SLEEP(TRUE)
	if(!use_tile_cache || cross_floor || !listener_turf || isnull(cached_version))
		return FALSE
	if(cached_version == static_version)
		return TRUE
	if(length(source_change_history) && cached_version < source_change_history[1])
		return FALSE
	var/expected_version = static_version
	for(var/i = length(source_change_history) - POINT_AMBIENCE_SOURCE_CHANGE_FIELDS + 1, i >= 1, i -= POINT_AMBIENCE_SOURCE_CHANGE_FIELDS)
		if(source_change_history[i + 1] != expected_version)
			return FALSE
		if(listener_turf.z == source_change_history[i + 4] \
			&& abs(listener_turf.x - source_change_history[i + 2]) <= source_change_history[i + 5] \
			&& abs(listener_turf.y - source_change_history[i + 3]) <= source_change_history[i + 5])
			return FALSE
		if(listener_turf.z == source_change_history[i + 8] \
			&& abs(listener_turf.x - source_change_history[i + 6]) <= source_change_history[i + 9] \
			&& abs(listener_turf.y - source_change_history[i + 7]) <= source_change_history[i + 9])
			return FALSE
		expected_version = source_change_history[i]
		if(cached_version == expected_version)
			return TRUE
		if(cached_version > expected_version)
			return FALSE
	return FALSE

/// Clears all shared tile rankings and invalidates every client's static-version cache
/datum/controller/subsystem/point_ambience/proc/clear_tile_cache()
	SHOULD_NOT_SLEEP(TRUE)
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_tile_invalidate")
	tile_cache_cleared += tile_cache_entries
	tile_cache.Cut()
	tile_cache_entries = 0
	scratch_tile_best.Cut()
	invalidate_listener_cache()
	if(timing)
		tile_cache_invalidation_ms += rustg_time_microseconds("pa_tile_invalidate") / 1000

/// Changes tile-cache and verification modes after clearing all cached rankings
/datum/controller/subsystem/point_ambience/proc/set_tile_cache(enabled, verify = FALSE)
	clear_tile_cache()
	use_tile_cache = !!enabled
	verify_tile_cache = !!verify

/// Invalidates per-listener answers while preserving shared tile rankings
/datum/controller/subsystem/point_ambience/proc/invalidate_listener_cache()
	SHOULD_NOT_SLEEP(TRUE)
	source_change_history.Cut()
	static_version++

/**
 * Opens a bulk source update, for a caller about to change many sources in one go.
 *
 * Until the matching close, every register and unregister still keeps the index, the counts, the
 * overrides and the fallback loops exact and bumps static_version. What it defers is the work that
 * repeats across overlapping sources: its ranking invalidation, its history entry and its walk over
 * every client. The outermost close does each once, see finish_bulk(). Unbatched, the Index only
 * snuff's 1699 overlapping removals took 38.4 ms in one tick with one client connected, and cleared
 * 69 cached entries between them
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

/datum/controller/subsystem/point_ambience/vv_edit_var(var_name, var_value)
	. = ..()
	if(!.)
		return
	switch(var_name)
		if("pan_blend", "pan_depth_floor")
			invalidate_listener_cache()
		if("original_sound")
			set_original_sound(var_value)
		if("falloff_hardness")
			set_falloff_hardness(var_value)
		if("use_tile_cache", "verify_tile_cache", "use_cell_cache", "cross_floor", "max_range", "max_range_sq")
			clear_tile_cache()

/// Recomputes every category's squared reach and the subsystem bounds, then invalidates all rankings
/datum/controller/subsystem/point_ambience/proc/refresh_category_ranges()
	max_range = 0
	for(var/datum/point_ambience_category/category as anything in categories)
		category.range_sq = category.range * category.range
		max_range = max(max_range, category.range)
	max_range_sq = max_range * max_range
	clear_tile_cache()

/// Whether a storey pass on z can change anything: some category not in skip has sources there
/datum/controller/subsystem/point_ambience/proc/floor_needs_pass(z, list/skip)
	PRIVATE_PROC(TRUE)
	if(length(floor_counts) < z)
		return FALSE
	var/list/counts = floor_counts[z]
	if(!counts)
		return FALSE
	for(var/datum/point_ambience_category/category as anything in categories)
		if(!skip[category] && counts[category])
			return TRUE
	return FALSE

/// The uncached walk: the buckets within max_range of the POSITION, gathered and ranked. skip holds
/// the categories the own floor already answered, so a floor a storey away only fills gaps
/datum/controller/subsystem/point_ambience/proc/collect_nearest_on_z(x, y, z, list/best, list/best_distsq, list/skip)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/gathered = scratch_uncached
	gathered.Cut()
	gather_buckets(x - max_range, x + max_range, y - max_range, y + max_range, z, gathered)
	rank_candidates(x, y, gathered, best, best_distsq, skip)

/// Appends every quad in the buckets whose cells the box touches, straight out of the buckets as
/// they are stored: one native append per bucket, no lookups
/datum/controller/subsystem/point_ambience/proc/gather_buckets(min_x, max_x, min_y, max_y, z, list/out)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(length(buckets_by_z) < z)
		return
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets)
		return
	var/cells = length(floor_buckets)
	var/by_lo = max(1, min_y) >> CELL_SHIFT
	var/by_hi = max_y >> CELL_SHIFT
	for(var/bx in (max(1, min_x) >> CELL_SHIFT) to (max_x >> CELL_SHIFT))
		var/row = bx * cell_stride + 1
		for(var/by in by_lo to by_hi)
			var/cell = row + by
			if(cell > cells)
				break
			var/list/bucket = floor_buckets[cell]
			if(bucket)
				out += bucket

/**
 * Everything the own-floor walk could reach from anywhere in the caller's CELL, gathered once per
 * cell rather than probed on every step.
 *
 * Bounded by the CELL expanded by max_range, NEVER by the caller's position. The list is kept for
 * every step taken inside the cell, and a box computed from one tile in it drops the sources a
 * listener walks toward from the far side. Dropping sources is fast, so a timing will not catch that.
 */
/datum/controller/subsystem/point_ambience/proc/collect_candidates(x, y, z, list/out)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/cell_min_x = (x >> CELL_SHIFT) << CELL_SHIFT
	var/cell_min_y = (y >> CELL_SHIFT) << CELL_SHIFT
	var/cell_max_x = cell_min_x + (1 << CELL_SHIFT) - 1
	var/cell_max_y = cell_min_y + (1 << CELL_SHIFT) - 1
	gather_buckets(cell_min_x - max_range, cell_max_x + max_range, cell_min_y - max_range, cell_max_y + max_range, z, out)

/**
 * Ranks a flattened candidate list exactly as collect_nearest_on_z ranks a bucket, same order and
 * same gates, so a storey pass reaches the same answer either way. Both read the same quads. The
 * only difference is that this one was handed them and does not have to find the buckets first
 */
/datum/controller/subsystem/point_ambience/proc/rank_candidates(x, y, list/candidates, list/best, list/best_distsq, list/skip)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/count = length(candidates)
	for(var/i = 1, i <= count, i += 4)
		// EUCLIDEAN, unlike playsound()'s chebyshev get_dist: a square admits corners past the
		// falloff's range, which pin at min volume and hold the channel inaudibly
		var/dx = candidates[i] - x
		var/dy = candidates[i + 1] - y
		var/distsq = dx * dx + dy * dy
		if(distsq > max_range_sq)
			continue
		var/datum/point_ambience_category/category = categories[candidates[i + 2]]
		if(skip && skip[category])
			continue
		if(distsq > category.range_sq)
			continue
		var/existing = best_distsq[category]
		if(isnull(existing) || distsq < existing)
			// The displaced winner becomes the runner-up. Only sources already inside the category's
			// range reach here, a handful a service
			if(!isnull(existing))
				scratch_second_distsq[category] = existing
				scratch_second[category] = best[category]
			best_distsq[category] = distsq
			best[category] = candidates[i + 3]
		else
			var/runner_up = scratch_second_distsq[category]
			if(isnull(runner_up) || distsq < runner_up)
				scratch_second_distsq[category] = distsq
				scratch_second[category] = candidates[i + 3]

/**
 * # Point Ambience Category
 *
 * One kind of ambient sound: what plays, how loud, how far, and on which reserved channel.
 *
 * Sources register under a category TYPEPATH, and each category serves its nearest source to a
 * listener independently, so a hearth and a wall sconce are heard at the same time while two
 * hearths are not. A category is therefore one voice and one reserved channel, which is what makes
 * splitting one expensive and sharing one lossy.
 *
 * File and volume can be overridden per source, so things that share neither theme nor loudness can
 * still share a category. RANGE cannot: it is the gate the shared walk filters on, so a kind that
 * needs its own reach needs its own category.
 */
/datum/point_ambience_category
	/// The name a SILENCE_POINT_AMBIENCE line in config.txt names this category by
	var/config_name
	var/sound_file
	/**
	 * A set of short clips to draw from instead of sound_file, advanced per listener: when the
	 * clip a listener is hearing runs out they are served afresh and pick another, never the one
	 * just played. For a sound whose files are a few seconds each, which native-repeated one at a
	 * time is one clip forever
	 */
	var/list/files
	var/volume = 100
	/**
	 * Volume this category fades TO at its range edge, AT THE VOLUME AUTHORED BESIDE IT. What is
	 * kept is the ratio between the two, floor_ratio below, and that is what the send reads: the
	 * floor sets the walk's shape, dB per tile across the range, and a shape is a proportion. Held as
	 * a number here because 8 at 60 reads and 0.133 does not.
	 *
	 * A ratio rather than an absolute, for two reasons. Every clip is normalised to one level, so a
	 * number means the same loudness in any category, and the fade owns the ending, so the edge does
	 * not have to land at the threshold of hearing. An absolute floor under a lowered volume crushes
	 * the walk:
	 * fire at 20 over a floor of 8 has 8 dB of falloff where 60 over 8 has 17.5, and at or below the
	 * floor it has none
	 */
	var/min_volume = SOUND_DEFAULT_MIN_VOLUME
	/// min_volume / volume as authored, resolved on New(). The Volume knob leaves it alone, so the
	/// floor follows. The Floor knob rewrites it from the number typed
	var/floor_ratio = 0
	var/range = 5
	/// range squared. The walk gates on squared distance, so this is the comparison it makes
	var/range_sq = 0
	var/channel
	/// Roll a random pitch per stretch, like the old loops' vary flag
	var/vary_pitch = FALSE
	/// Whether sources of this category get a plain loop in fallback mode. Torches do not:
	/// hundreds of them on timers is the load that got torch crackle disabled in the first place
	var/fallback = TRUE
	/**
	 * source -> its own file, where it wants something other than the category's. A category is a
	 * channel and a slot, not necessarily one sound, so things that share neither theme nor loudness
	 * can still share one. Range stays per-category, since it is the per-source gate the shared walk
	 * filters on
	 */
	var/list/source_sounds = list()
	/**
	 * source -> a MULTIPLE of the category volume, not a volume. A kind of fire two dB under the
	 * rest keeps that offset when the category moves, and min_volume keeps meaning the edge for
	 * every source, the floor being a share of whatever this resolves to. An absolute here made a
	 * category's own volume unreachable for any source carrying one, and made the floor a lie for it
	 */
	var/list/source_volumes = list()
	/**
	 * source -> TRUE where the source is one voice of something long rather than a thing at a point.
	 * A river's nearest voice keeps changing as you walk, so the sound must NOT restart on a handoff
	 * and must NOT pan, the two voices being equidistant on opposite sides at that moment. Falloff
	 * still applies, so the run swells as you approach
	 */
	var/list/source_continuous = list()
	/**
	 * What this category is multiplied by for a listener under a roof. 1 is no change and is the
	 * default, since everything else answers a wall with occlusion, which is the finer instrument:
	 * it asks about THIS line and finds a doorway with its corner probe, where a roof is all this
	 * knows. For the river occlusion is the wrong question, so this is the only one it can ask
	 */
	var/indoors_volume_mult = 1
	/// Position in categories, the index into each client's per-category sound datums. Set on New()
	var/index = 0
	/// The falloff curve. Left at 0, it is the band for this range, resolved once on New() and the
	/// same answer playsound_local computes per send. A category can set its own instead
	var/falloff_exponent = 0
	/// 1 / falloff_exponent, so a send reads it rather than dividing
	var/inv_falloff_exponent = 0
	/// The same for a muffled send, which uses a shallower curve. Cached beside it because muffling
	/// is no longer rare: every source heard round a corner takes this path
	var/inv_muffled_exponent = 0
	/**
	 * How this category decays with distance. 1 drops the same proportion every tile, an even
	 * fade in decibels, ending on min_volume with slope still on it. Above 1 front-loads the
	 * drop for separation close in, less evenly. 0 keeps the band power curve above, which is
	 * what a category whose shape was chosen deliberately wants
	 */
	var/falloff_hardness = 1
	/// falloff_hardness for a muffled send, resolved with the exponents rather than per send
	var/muffled_hardness = 0
	/// Set where the curve is deliberate, so a global hardness override leaves it alone
	var/hardness_pinned = FALSE
	/// The null sound that stops this category's channel, built once and sent as is
	var/sound/stop_sound
	/**
	 * This category makes NO sound at all and its sources are kept out of the index. Set from
	 * SILENCE_POINT_AMBIENCE at the first fire() only, since de-indexing hundreds of sources is a
	 * bulk operation that must not land on a running server
	 */
	var/silenced = FALSE
	/**
	 * Whether a wall between listener and source silences this category. Off for anything whose
	 * sources are one long thing rather than a point: consecutive voices of a line sit close enough
	 * that one rock face takes both, so the whole run goes quiet from a spot where plenty of it is
	 * in the open. It is also the dearest check on the map, the widest range walking furthest
	 */
	var/occlude = TRUE
	/**
	 * Whether each source gets a voice of its own, a pitch lean and a place in the loop fixed by
	 * where it stands. Off for anything with a rhythm to keep, a clock must tick once a second,
	 * and for a clip set, whose file changes under it
	 */
	var/unique_voice = FALSE
	/**
	 * Files a source picks ONE of by where it stands, registered as its own sound, so neighbours
	 * play different takes. Not a set the listener rotates through: that is files, above, and it
	 * costs a timer per listener where this costs nothing. A listener keeps its loaded take across
	 * handoffs, while a new stretch starts from the winning source's take
	 */
	var/list/voices
	/// The takes for a source whose area is not outdoors, where a category wants a fire in a room to
	/// be a different sound from one in the open. voices is then the outdoor set
	var/list/voices_indoors
	/**
	 * Whether unique_voice also gives each source its own starting place in the loop. Off where the
	 * takes above already tell sources apart, since a new stretch already differs by its file
	 */
	var/voice_place = TRUE
	/**
	 * The send that switches this category from one source to the next goes out centred, and the next
	 * update pans to the new source. So a switch between two sources on opposite sides passes through
	 * the middle rather than leaping from one ear to the other. The clip carries on either way.
	 *
	 * A listener who stops right after a switch keeps the centre until they move, since standing still
	 * sends nothing. Not refreshed on purpose: a switch lands on the first update past the halfway
	 * point, so they are within a few tiles of it, where centred is close to right, and clearing the
	 * cached answer to re-pan them cost a full service on about a third of switches for anyone walking
	 */
	var/centre_handoff = TRUE
	/// Since boot, the source changing while this category plays
	var/handoffs = 0

/// Validates live range edits, protects derived range_sq, and invalidates rankings after accepted edits
/datum/point_ambience_category/vv_edit_var(var_name, var_value)
	if(var_name == "range" && (!isnum(var_value) || var_value <= SOUND_DEFAULT_FALLOFF_DISTANCE))
		return FALSE
	if(var_name == "range_sq")
		return FALSE
	. = ..()
	if(!. || SSpoint_ambience?.categories_by_path[type] != src)
		return
	if(var_name == "range")
		SSpoint_ambience.refresh_category_ranges()
	else
		SSpoint_ambience.clear_tile_cache()

/datum/point_ambience_category/fire
	config_name = "fire"
	/**
	 * Two sets of three takes, and each fire plays the take its position picks, so two hearths are
	 * two fires and not one. OUTSIDE, braziers and campfires: the old torch recording as the bed
	 * (heavier than the old fire recording, which the torch has now), WHOLE and uncut, looped with
	 * one crossfade at its own seam, 7 dB off its lows, 12 dB off everything over 2 kHz, no flares,
	 * and stretches of the old fire recording's crackle laced on top, 6 dB under the bed, swelling
	 * gently busier and calmer. Cutting a continuous roar into short shuffled pieces was heard as
	 * drops and a loop that did not join, and the roar's own even hiss up top, as loud there as the
	 * crackle, was heard as back to back crackle with no variety. INSIDE, hearths, ovens and forges:
	 * the other way round, the crackle recording as the base, pitched down a tenth as a whole so a
	 * hearth crackles deeper than a sconce, re-laced whole into 14 s, and the roar 12 dB under it
	 * with 9 dB off its lows and flares of 2 dB at most, crossfaded back into its own start so it
	 * loops. Takes differ in where the roar starts and where the crackles fall. A listener keeps the
	 * loaded take across a handoff, while a new stretch uses the nearest fire
	 */
	sound_file = 'sound/ambience/point/fire_1.ogg'
	voices = list('sound/ambience/point/fire_1.ogg', 'sound/ambience/point/fire_2.ogg', 'sound/ambience/point/fire_3.ogg')
	voices_indoors = list('sound/ambience/point/fire_in_1.ogg', 'sound/ambience/point/fire_in_2.ogg', 'sound/ambience/point/fire_in_3.ogg')
	/// Halved by ear. 60 was chosen against a recording 16 dB under the rest of the set, so once
	/// every clip was normalised it put a hearth above a fountain. This puts it just under one
	volume = 30
	range = 6
	unique_voice = TRUE
	voice_place = FALSE
	/**
	 * Sustained and broadband like the torch, so it starts where the torch does. Follows the
	 * halved volume above, the floor being read as a fraction of it: left at 8 it would flatten
	 * the walk from 17.5 dB to 11.5
	 */
	min_volume = 4
	channel = CHANNEL_FIRE_AMBIENCE
	vary_pitch = TRUE

/**
 * Bone piles, evil trees and goblin portals.
 *
 * Supernatural landmarks meant to be felt before they are seen, hence the long range and full
 * volume. Only a handful are mapped, so they never crowd each other.
 *
 * A category is ONE voice: flies and clocks on this one muted each other, and RANGE, the one
 * property that is per-category, is why they are separate categories rather than overrides.
 */
/datum/point_ambience_category/misc
	config_name = "misc"
	sound_file = 'sound/vo/mobs/ghost/skullpile_loop.ogg'
	volume = 100
	range = 6
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED
	min_volume = 8
	channel = CHANNEL_MISC_AMBIENCE

/**
 * Flies on a rotting body. Short range on purpose: a fly cloud is an intimate sound, tighter than
 * the four tiles a hand-held torch carries, and at misc's six you heard a corpse two rooms away.
 * Corpses are the one source here that turns up ANYWHERE, indoors included, and there is no fixed
 * count of them: it scales with how much dying happens
 */
/datum/point_ambience_category/rot
	config_name = "rot"
	/// Its own copy normalised with the other point ambience clips, the original is shared with
	/// spells that were tuned against it
	sound_file = 'sound/ambience/point/flies.ogg'
	volume = 50
	range = 3
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED
	min_volume = 8
	channel = CHANNEL_ROT_AMBIENCE

/// Grandfather and wall clocks over 4 tiles. At misc's 6 a manor's clocks reached each other. The
/// loop this replaced played at 10 and read too quiet once the clips were normalised
/datum/point_ambience_category/clock
	config_name = "clock"
	/// Its own normalised copy, the original is shared with the trap and contraption ticks
	sound_file = 'sound/ambience/point/clock.ogg'
	volume = 14
	range = 4
	/// The one floor with a confirmed reading behind it: a clock at 3.5 is audible in play. Ticks are
	/// transients with a sharp attack and carry far lower than the crackles and hiss below
	min_volume = 3
	channel = CHANNEL_CLOCK_AMBIENCE

/**
 * Fountains and wells. The waterwheel rode this briefly and came back out: it never had a sound to
 * restore, and a fountain nearer than the wheel silenced it. Rivers split off for the same reason
 * plus a longer range. See /river below.
 *
 * SEVEN COSTS NOTHING. max_range is the largest range of any category and it sizes the walk's box
 * for every service on the map, so this is free at anything up to the river's eight and would be
 * paid by everyone above it. It buys audible tiles rather than a gentler ending: the curve is
 * proportional to range, so raising it stretches the same shape and the last tile still drops from
 * about eleven to the floor. That last step is the exponent's, not this one's
 */
/datum/point_ambience_category/water
	config_name = "water"
	sound_file = 'sound/misc/waterloop.ogg'
	volume = 35
	range = 7
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED, and the
	/// one most reported as cutting out, so this is the first to raise if 8 is not enough
	min_volume = 8
	channel = CHANNEL_WATER_AMBIENCE

/**
 * Rivers only, split off water for range and for a channel of its own.
 *
 * Voices sit on river TURFS, mid-water, so the range pays for crossing to the bank before it reaches
 * anyone: at water's range of 5 a seven-tile river leaves about a tile and a half of audible bank,
 * which is why you had to stand on the edge to hear it.
 *
 * RANGE 8 IS NOT FREE. It is the widest of any category and max_range sets the walk's box for every
 * service on the map, so this is ~30% more sources ranked per step by everyone, water or not. 8
 * specifically: voices sit at most RIVER_SPREAD apart, so a listener midway between two is
 * hypot(spread/2, half the width) from the nearer, which 8 covers on rivers up to 14 tiles wide
 * where 6 gives out at 9. It is also the largest range still fitting three cells per axis.
 *
 * The clips are four to seven seconds each, so they are a set advanced per listener rather than one
 * file looped. The same set plays at every hour, POINT_AMBIENCE_RIVER says why there is no day set
 */
/datum/point_ambience_category/river
	config_name = "river"
	/// Its own normalised copies, the originals are the river areas' ambience beds. Matches the set
	/// rather than the day takes, or an empty set would fall back to a clip with calls on it
	sound_file = 'sound/ambience/point/river_night_1.ogg'
	files = POINT_AMBIENCE_RIVER
	volume = 45
	range = 8
	/// Its voices are one continuous line and always sent centred, so a switch has nothing to centre
	centre_handoff = FALSE
	/// The old curve, kept on purpose. The steeper band suits something walked past, and a river is
	/// a bed of sound stood beside: at 1 it fell away within a few tiles of the bank
	falloff_exponent = 0.5
	/// A bank is stood beside rather than walked past, so it keeps the curve above and a global
	/// hardness override does not reach it
	falloff_hardness = 0
	hardness_pinned = TRUE
	/**
	 * The band curve above holds near full volume and then drops at the edge, so the floor is where
	 * it lands rather than what it fades through. 6.5 keeps the last tile's step at 7.5 dB, and moved
	 * with the volume above so the whole curve dropped a level without changing shape
	 */
	min_volume = 6.5
	channel = CHANNEL_RIVER_AMBIENCE
	occlude = FALSE
	/// Faint through a roof. A river carries through a wall in a way a fountain does not, so this
	/// is a level rather than a silence, and it is what a riverside house gets instead of occlusion
	indoors_volume_mult = 0.3

/**
 * Wall sconces and standing fires. A handheld torch is heard by its carrier alone, off the index.
 *
 * No vary_pitch, unlike fire: the clip carries its own flicker and a roll on top of it doubles up.
 * Each sconce still sounds unlike its neighbour through unique_voice below, which leans the pitch
 * and sets the starting loop position from where playback begins
 */
/datum/point_ambience_category/torch
	config_name = "torch"
	fallback = FALSE
	/// The old fire recording, swapped with the torch's by ear. See the fire category above
	sound_file = 'sound/ambience/point/torch.ogg'
	/**
	 * Halved by ear for the same reason as fire above, then another quarter off. A sconce is meant
	 * to be faint against the rest, and this still leaves it ~7 dB over the level that was
	 * inaudible before normalising
	 */
	volume = 11
	range = 4
	unique_voice = TRUE
	/**
	 * Follows the volume above, the floor being read as a fraction of it, so a sconce keeps the
	 * ~11.5 dB walk it had at 30 over 8.
	 *
	 * Point ambience clips are normalised to about -30 dB A-weighted, as loud as the set goes
	 * without clipping, so a volume or a floor is the same loudness on any category and the numbers
	 * alone carry how loud each one is
	 */
	min_volume = 3
	channel = CHANNEL_TORCH_AMBIENCE

/**
 * Switches mode, silencing what the old one had playing and starting what the new one needs.
 *
 * The index keeps updating in every mode, so switching back is immediate.
 *
 * Arguments:
 * * new_mode - POINT_AMBIENCE_LIVE, POINT_AMBIENCE_FALLBACK or POINT_AMBIENCE_OFF
 */
/datum/controller/subsystem/point_ambience/proc/set_mode(new_mode)
	if(new_mode == mode)
		return
	clear_tile_cache()
	var/old_mode = mode
	mode = new_mode
	if(old_mode == POINT_AMBIENCE_LIVE)
		finish_fades()
		for(var/client/listener_client as anything in GLOB.clients)
			stop_all_for(listener_client)
		dirty_clients.Cut()
	if(old_mode == POINT_AMBIENCE_FALLBACK)
		for(var/atom/source as anything in fallback_loops)
			qdel(fallback_loops[source])
		fallback_loops = list()
	if(mode == POINT_AMBIENCE_FALLBACK)
		for(var/atom/source as anything in source_categories)
			start_fallback(source)

/// The plain loop a source runs in fallback mode, configured from its category so it sounds as
/// the live path would. Cannot native-repeat without a token, so it replays every file length
/datum/looping_sound/point_ambience_fallback

/// Gives one source its fallback loop, if its category takes one and it has none already
/datum/controller/subsystem/point_ambience/proc/start_fallback(atom/source)
	PRIVATE_PROC(TRUE)
	var/datum/point_ambience_category/category = source_categories[source]
	if(!category?.fallback || fallback_loops[source])
		return
	// A category with a set of clips gets one of them. The plain loop cannot advance through a set
	var/sound_file = category.source_sounds[source] || (category.files ? pick(category.files) : category.sound_file)
	var/datum/looping_sound/point_ambience_fallback/loop = new(source)
	loop.mid_sounds = sound_file
	loop.volume = category.volume * (category.source_volumes[source] || 1)
	loop.vary = category.vary_pitch
	// playsound's reach is SOUND_RANGE + extra_range
	loop.extra_range = category.range - SOUND_RANGE
	loop.mid_length = SSsounds.get_sound_length(sound_file) || 35
	fallback_loops[source] = loop
	loop.start()

/// Ends and forgets one source's fallback loop
/datum/controller/subsystem/point_ambience/proc/stop_fallback(atom/source)
	PRIVATE_PROC(TRUE)
	var/datum/looping_sound/loop = fallback_loops[source]
	if(!loop)
		return
	fallback_loops -= source
	qdel(loop)

#undef CELL_SHIFT
#undef POINT_AMBIENCE_SOURCE_CHANGE_FIELDS
#undef POINT_AMBIENCE_SOURCE_CHANGE_LIMIT
#undef POINT_AMBIENCE_BULK_BURST


/**
 * Keeps a headless dullahan's listening point on their head.
 *
 * One per dullahan client, made at login and dropped when they stop being one. It follows the head
 * and whatever carries it, so a head in a bag on somebody's back still moves the ear, and writes
 * client.point_ambience_ear. Everyone else has no watch and no ear, and a service reads one var
 * rather than resolving a species.
 *
 * What it does not see: a container moved between holders without the tracked holder moving, a
 * pushed closet, and a muffle change on the same turf. The once-a-second walk catches a turf change
 * on its next visit, subject to the skip and the budget. A muffle change on the same turf waits
 * for the next service either way
 */
/datum/point_ambience_head_watch
	var/client/owner
	var/mob/living/carbon/human/body
	var/obj/item/bodypart/head/dullahan/head
	/// The outermost movable carrying the head, so a carried head moves the ear with no head MOVED
	var/atom/movable/holder

/datum/point_ambience_head_watch/New(client/listener_client, mob/living/carbon/human/human)
	owner = listener_client
	retarget(human)

/datum/point_ambience_head_watch/Destroy(force)
	drop_head()
	if(owner?.point_ambience_head_watch == src)
		owner.point_ambience_head_watch = null
	owner = null
	body = null
	return ..()

/// Points the watch at a mob's head, seeded from its CURRENT state, so a client logging in with the
/// head already off is served from it rather than waiting for the head to move
/datum/point_ambience_head_watch/proc/retarget(mob/living/carbon/human/human)
	body = human
	var/datum/species/dullahan/species = human?.dna?.species
	if(!istype(species))
		drop_head()
		return
	var/obj/item/bodypart/head/dullahan/new_head = species.my_head
	if(head && head != new_head)
		drop_head()
	if(!new_head)
		return
	if(head != new_head)
		head = new_head
		RegisterSignal(head, COMSIG_MOVABLE_MOVED, PROC_REF(on_head_moved))
		RegisterSignal(head, COMSIG_QDELETING, PROC_REF(on_head_deleted))
	set_ear(species.headless)

/// The ear on or off, the holder hooked to match, and the listener served again either way
/datum/point_ambience_head_watch/proc/set_ear(headless)
	if(!owner)
		return
	if(headless && head)
		owner.point_ambience_ear = head
		hook_holder()
	else
		owner.point_ambience_ear = null
		unhook_holder()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/drop_head()
	unhook_holder()
	if(head)
		UnregisterSignal(head, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
		head = null
	if(owner)
		owner.point_ambience_ear = null

/// The outermost movable holding the head: a pouch inside a backpack on a mob moves with the mob,
/// and only the mob's own MOVED will fire
/datum/point_ambience_head_watch/proc/hook_holder()
	var/atom/movable/outermost
	var/atom/above = head?.loc
	while(ismovable(above))
		outermost = above
		above = above.loc
	if(outermost == holder)
		return
	unhook_holder()
	holder = outermost
	if(holder)
		RegisterSignal(holder, COMSIG_MOVABLE_MOVED, PROC_REF(on_holder_moved))
		RegisterSignal(holder, COMSIG_QDELETING, PROC_REF(on_holder_deleted))

/datum/point_ambience_head_watch/proc/unhook_holder()
	if(!holder)
		return
	UnregisterSignal(holder, list(COMSIG_MOVABLE_MOVED, COMSIG_QDELETING))
	holder = null

/// Reads the species, not the head's loc: doMove fires Moved BEFORE loc is null, so where the head
/// is cannot tell a detachment from a reattachment. Both paths set headless before they move it
/datum/point_ambience_head_watch/proc/on_head_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	var/datum/species/dullahan/species = body?.dna?.species
	set_ear(istype(species) && species.headless)

/datum/point_ambience_head_watch/proc/on_holder_moved(datum/source, atom/old_loc, dir, forced)
	SIGNAL_HANDLER
	// A bag picked up changes the chain without the head moving, so it is re-read on every carry
	hook_holder()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/on_head_deleted(datum/source)
	SIGNAL_HANDLER
	drop_head()
	SSpoint_ambience.mark_listener(owner)

/datum/point_ambience_head_watch/proc/on_holder_deleted(datum/source)
	SIGNAL_HANDLER
	unhook_holder()
