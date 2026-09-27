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

/**
 * Set while the Counters instrument holds a snapshot, null otherwise, and declared here for the same
 * reason as the survey above. A snapshot turns on the rustg timing pairs in fire() and the drain,
 * and the hook below is the one call it overrides. The Server verb never sets it
 */
GLOBAL_DATUM(point_ambience_counters, /datum/point_ambience_counters)

/datum/point_ambience_counters

/// Sorts a step that passed the interval by whether a silence gate could have skipped it
/datum/point_ambience_counters/proc/observe_move_gate(client/listener_client, mob/listener, discontinuous)
	return

/**
 * # Point Ambience
 *
 * Point-source ambience, served per client. Mapped emitters own no sound loops: each active source
 * sits in one shared index, and this subsystem serves each CLIENT the nearest source per category as
 * a native repeat on that category's reserved channel, through slim_send().
 *
 * ## A service
 *
 * Movement requests are throttled and normally queued. A periodic client walk catches missed moves.
 * A full service reuses a tile ranking or searches the cell buckets in a fixed box, the listener's
 * cell expanded by max_range. It ranks by squared distance, keeps the nearest per category, then
 * sends or updates that channel. A source's volume override can make a farther source louder, so
 * nearest does not guarantee loudest. Standing still reuses the last walk, and deactivating a source
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
 * fixed box and serves at most one source per category. Counters on one client walking a set route
 * at the shipped settings puts a warm service at about 88 us and the walker at 0.18 ms/s warm and
 * 0.20 cold, and a quiet service with nothing in range to send still costs about 33 us. So the
 * lever is FEWER services: as shipped a walker is served every second step, the step count and
 * the move interval set in config/sound.txt, paid for in spatial resolution. MODES are the bigger
 * hammer: FALLBACK gives every source a plain timer loop instead, billed per source, volume only on
 * replay, torches silent. OFF is silent. The Point Ambience Mode verb switches live, config seeds at
 * boot.
 *
 * ## Not here
 *
 * Gameplay-gated loops (boiling, relics, spell charges) are tokens and cost nothing idle. Music
 * restarts on a source handoff. Boat bells alternate two files and cannot native-repeat.
 *
 * ## Files
 *
 * This file holds the settings, the state and fire(). index.dm keeps the source index and ranks the
 * sources a listener can hear, tile_cache.dm shares those rankings by turf, and bulk.dm batches mass
 * source changes. service.dm serves one client and decides occlusion, send.dm builds and sends each
 * sound with its fades and stops, and doors.dm serves again the listeners near a door that changed.
 * move_hook.dm is the move hook and the speed cutoff, listeners.dm handles logins, silencing and a
 * dullahan's ear, categories.dm defines the kinds of sound, and mode.dm switches live, fallback and off
 *
 * ## The measurement verbs are not in the repo
 *
 * Comments cite a Survey, Benchmark, Here, Verify, Send Diff and Counters verb, and the measured_* vars
 * are written by them. They are kept out of git deliberately, so in a plain checkout those vars stay
 * zero and the figures quoted here cannot be reproduced without them.
 *
 * Counters times one client on a set route lap by lap, so its cold laps and warm ones are told
 * apart. Every other verb and bench runs under ideal conditions with its state fully warm, so its
 * figures understate a cold start and a live service, and the comments quoting them say so. Any
 * figure here may be out of date against the code around it. Local timing used up to four clients.
 *
 * Costs at a live population are projections, not load tests. In-game telemetry of live rounds
 * gives how many players there were and how often they moved, and the per-part costs Counters timed
 * on one client price it
 */
SUBSYSTEM_DEF(point_ambience)
	name = "Point Ambience"
	/**
	 * Every tick, in the background bracket. The dirty set is drained here, and running only in
	 * the tick's slack is what bounds it on a loaded tick. The once-a-second walk over every client
	 * runs behind standing_walk_interval below, not behind this
	 */
	wait = 1
	flags = SS_BACKGROUND | SS_NO_INIT | SS_TICKER

	// Settings. Config seeds most of them at the first fire, and the Mode verb and VV change them live
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
	 * 3 holds it to two tiles. Intent rather than measured speed, so both values stay hard ceilings.
	 * move_service_steps below is what bounds the tiles now: at 2 a natural runner is served every
	 * second step, sooner than this, which then matters only with steps at 0
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
	/**
	 * The move hook marks the client here instead of servicing inline, and fire() drains the set
	 * every tick, oldest first, up to max_services_per_tick. An entry is the CLIENT, served at
	 * wherever they are when their turn comes, so nothing goes stale. Whether a service run straight
	 * after another is cheaper than one run alone was measured and not settled. 0 leaves the inline
	 * path with the two rails above
	 */
	var/use_queue = FALSE
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
	/**
	 * Fade steps one run of run_fades may send. A step over the budget is not dropped: it waits, and
	 * the next run takes every step it is behind in one packet, so a busy tick makes a fade coarser
	 * and never cuts it. The stop that ends a fade out is outside the budget
	 */
	var/fade_budget = 8
	/// How far a source's own pitch may lean either way in a category with unique_voice, as a
	/// fraction: 0.04 is 4% deeper and slower to 4% brighter and faster. 0 is off
	var/voice_pitch = 0.04
	/// Whether such a source also plays from its own place in the loop. Off, every entry opens on
	/// the clip's first second and a change of source carries the clip on unbroken
	var/voice_offset = TRUE
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

	// Categories
	var/list/datum/point_ambience_category/categories = list()
	/// category typepath -> its singleton, the form register/unregister callers use
	var/list/categories_by_path = list()
	/// The loudest any category plays at distance 0, so a slider too low to clear send_cutoff can
	/// be recognised as silence and unhooked
	var/loudest_volume = 0
	/// The bits of every category the config has not silenced, so a listener whose
	/// point_ambience_muted_mask covers all of them has nothing to hear and is unhooked
	var/audible_mask = 0
	/// The category a mob's self source is served under
	var/datum/point_ambience_category/self_category
	/**
	 * The echo array a muffled send carries, whether the muffle came from a storey or a corner.
	 * Built once and never written after, so one
	 * list serves every client. A send is snapshotted, so sharing it is safe
	 */
	var/list/storey_echo

	// The index
	/**
	 * Positional, never string keyed: buckets_by_z[z] is a list indexed by POINT_AMBIENCE_CELL_INDEX,
	 * and each entry is a flat list of x, y, category index, source per active source in that cell,
	 * or null. The walk reads a source's position and kind straight out of the bucket, so rejecting
	 * one is two list reads and arithmetic and never a lookup. The lookups happen once, when the
	 * source registers
	 */
	var/list/buckets_by_z = list()
	/**
	 * Tiles across one index cell, 1 << POINT_AMBIENCE_CELL_SHIFT. Exposed because a mover crosses a
	 * cell every this many steps and pays a candidate rebuild when they do. A projection built on the
	 * per-step cost without amortising that in is low by the difference over this number
	 */
	var/cell_size = 1 << POINT_AMBIENCE_CELL_SHIFT
	/// (world.maxy >> POINT_AMBIENCE_CELL_SHIFT) + 2, fixed at the first register. Only maxx can grow
	/// at runtime, and a larger x only extends a floor's list
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
	/// Source -> its turf at last register. The scan reads this instead of calling get_turf,
	/// which was the costliest statement on the reject path
	var/list/source_turfs = list()
	/**
	 * Bumped whenever the index changes in a way a standing listener could hear: a source that
	 * is not carried joins, leaves, moves or changes category or override, or a source changes
	 * carrier. Clients compare it to skip the scan while nothing static changed
	 */
	var/static_version = 0
	/// Source -> the z it is bucketed on, so a removal can find its floor tally and cell
	var/list/source_zs = list()
	/// Positional by z: category -> how many sources are bucketed on that floor, or null. An
	/// adjacent-floor pass runs only when some still-unanswered category has sources there
	var/list/floor_counts = list()

	// Tile cache
	/// Turf-keyed associative cache. Invalidated positions retain their keys until a full clear
	var/list/tile_cache = list()
	/// Non-null rankings in tile_cache; its length also includes invalidated positions
	var/tile_cache_entries = 0
	/// Scratch winner table used only while constructing one tile-cache entry
	var/list/scratch_tile_best = list()
	var/list/source_change_history = list()

	// Bulk source updates
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
	/// Index changes outside any scope within one world.time, for the unbatched burst report
	var/burst_changes = 0
	var/burst_time
	/// A burst before this is counted but not reported again
	var/burst_quiet_until = 0

	// Scheduling state
	var/next_standing_walk = 0
	var/list/currentrun = list()
	/// client, category, client, category: the fades in progress. Flat, so a fade allocates nothing
	var/list/fading = list()
	/// The earliest step due across fading, so fire() enters run_fades only when there is one to
	/// send. Steps fall on whole deciseconds, which lets fades from different listeners share a run
	var/fade_next_due = 0
	/// Turfs whose door changed since the last gather, as turf -> TRUE
	var/list/changed_doors = list()
	var/next_door_recheck = 0
	/// Whether the per-mob move hook has been attached to the global login signals yet. Done on
	/// the first fire() rather than in New(), which may run before SSdcs exists
	var/hooked_logins = FALSE
	/**
	 * Whether the settings have been read from config. Separate from hooked_logins because
	 * Recover() carries the settings but must NOT carry the hooks: those are registered against
	 * the datum being replaced and have to be made again, while re-reading config would throw away
	 * whatever an admin set through the Mode verb, which is usually why the MC was restarted
	 */
	var/settings_seeded = FALSE
	/// world.time of the tick services_this_tick belongs to. It advances by tick_lag, so it is the
	/// tick stamp
	var/services_tick_stamp = 0
	var/services_this_tick = 0
	var/current_drop_run = 0
	/// A tick index rather than world.time, since consecutive ticks differ by tick_lag and comparing
	/// those is a float compare on a number that grows all round
	var/last_drop_tick_index = 0
	/// client -> world.time it was marked. Marking is idempotent, so a client keeps its place however
	/// many steps it takes, and the stamp is the wait the survey reports
	var/list/dirty_clients = list()
	/// world.time this instance was built. An MC restart resets it along with every counter, so a
	/// reader holding an older snapshot must throw that away rather than subtract from it
	var/started_at = 0
	/// Set while fire()'s standing walk is visiting clients, so a service knows it is a standing one
	var/in_standing_walk = FALSE
	/// Source -> its plain loop while in fallback mode
	var/list/fallback_loops = list()

	// Scratch for the service running now, overwritten by every service
	/// Own-floor candidates ranked this service, null when no fresh ranking ran
	var/ranked_candidates_this_service = null
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
	var/list/runner_up_by_category = list()
	var/list/runner_up_distsq = list()
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
	 * The pan pan_lean worked out for the send running now, leaned between the nearest source and
	 * the runner up and held at the depth floor. Subsystem vars rather than a returned list because
	 * pan_lean has two numbers to hand back and the walk cannot afford an allocation per send
	 */
	var/pan_lean_dx = 0
	var/pan_lean_dy = 0
	/**
	 * Sends made by the service running right now, reset at the top of each one, read by the survey
	 * beside every timing. Two tiles with the same candidate count but different audible categories
	 * differ by about a send each, so a cost figure without this cannot be compared to another's
	 */
	var/sends_this_service = 0
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

	// Counters always on, most of them for the Server verb. Read as deltas, so a round is measured
	// without sampling it: plain increments, and nothing here may sample, loop or force a rebuild
	var/tile_cache_hits = 0
	var/tile_cache_misses = 0
	var/fade_packets = 0
	var/runner_up_silenced = 0
	/**
	 * Every service, the standing walk's included, which is the DENOMINATOR the runner_up_* counts are read
	 * against. Dividing by the survey's own timed count, move-hook services only, overstates them.
	 * Checks also cross-check the arithmetic, since runner_up_offered only increments after a SOLID
	 * check and so can never exceed them
	 */
	var/services_total = 0
	/**
	 * Services that returned at the standing shortcut, from any caller. run_standing_walk() reads it
	 * around each service it calls to fill the two below. Three counters rather than one because the
	 * verbs call service_client themselves, and a global count cannot tell the standing walk's
	 * services from theirs
	 */
	var/shortcut_hits = 0
	var/standing_walk_visits = 0
	var/standing_walk_hits = 0
	/// Index changes, counted at the register and unregister sites rather than read off
	/// static_version, which the survey and the benchmark bump themselves to force rebuilds
	var/index_changes = 0
	var/occlusion_checks_total = 0
	/// Door tile change notifications, before deduplication or recheck filtering
	var/door_changes = 0
	/// Listeners a door gather served again, after the box filter
	var/door_listeners_marked = 0
	/**
	 * Cumulative, always on and never timed, for the Server verb. The four usages sum world.tick_usage
	 * across each phase of fire(), in percent of a tick: a built-in read, not an FFI timer, so they
	 * cost nothing a live server would notice. Inline services, with the queue off, are not in them
	 */
	var/drain_usage = 0
	var/walk_usage = 0
	var/fade_usage = 0
	var/door_usage = 0
	/// Services outside the standing walk that found nothing in range and nothing playing, which is
	/// what a silence gate would skip
	var/moving_silent = 0
	/// Services that reached a muted listener and returned. Only a client queued just before muting
	/// should ever do it, so the Server verb prints it beside the muted count
	var/muted_services_refused = 0
	var/sends_total = 0
	/// Services that ranked their sources afresh, standing walk visits included, rather than taking
	/// the standing shortcut's cached answer. What sends and wall checks happen in, so what the
	/// Server verb divides them by
	var/services_ranked = 0
	/// The longest queue wait since the Server verb last started a window
	var/queue_wait_window_max = 0
	/// Drains, and the services in them, by how many ran together: 1, 2, 3 to 4, 5 to 8, 9 or more
	var/list/drain_size_drains = list(0, 0, 0, 0, 0)
	var/list/drain_size_services_total = list(0, 0, 0, 0, 0)
	/// Move-hook services refused, by which gate, for the survey
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
	var/drain_sends = 0
	var/drain_paused = 0
	var/standing_skipped = 0
	/// Listeners silenced for moving faster than a natural run
	var/speed_silences = 0
	/**
	 * Why a standing-walk service walked instead of taking the shortcut: the listener moved, the
	 * index changed, or their point ambience volume did. Counted only inside run_standing_walk(), so
	 * the drain's misses, which are all moves, stay out
	 */
	var/standing_walk_miss_turf = 0
	var/standing_walk_miss_version = 0
	var/standing_walk_miss_volume = 0

	// Counters only the measurement verbs read
	var/tile_cache_cleared = 0
	var/tile_cache_checks = 0
	var/tile_cache_mismatches = 0
	var/bulk_scopes = 0
	var/bulk_changes_total = 0
	var/bulk_stops = 0
	var/bulk_leaks = 0
	var/unbatched_bursts = 0
	/// Moves per second per player, measured by the Survey verb and kept after it stops. Zero until
	/// one has run. The verbs then fall back to 1.38
	var/measured_moves_per_player = 0
	/// Microseconds per service in the Benchmark verb's synthetic batch. Zero until one has run.
	/// This measures the batch, not a populated server. Real client movement and delivery can differ
	var/measured_batched_service_us = 0
	/**
	 * Microseconds a real cold service costs above the same service measured in a tight loop, from
	 * the survey's same-tile-same-instant pairs. Zero until one has run. Every looped figure in
	 * every verb understates by this, so a projection built on one is low by it per service
	 */
	var/measured_warm_cold_gap_us = 0
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
	var/clip_refreshes = 0
	var/clip_refresh_fast = 0
	var/clip_refresh_full = 0
	var/clip_refresh_coalesced = 0
	var/clip_refresh_deferred = 0
	var/clip_refresh_timeouts = 0
	var/clip_refresh_queued = 0
	/**
	 * Cumulative across the round, for the survey's rates, and incremented only when a winner turned
	 * out occluded: how often the fall-through was reached and how often the runner-up was clear and
	 * served in its place. runner_up_silenced counts the rest, both blocked and the category silent
	 */
	var/runner_up_offered = 0
	var/runner_up_served = 0
	/**
	 * Cumulative CORNER verdicts, which the counters above never see because a corner is served
	 * muffled rather than blocked. It prices what corners cost: each one is a blocked direct line
	 * plus the side probes has_open_path() ran to find the way round, so this is how often that
	 * second and third walk are paid for
	 */
	var/occlusion_corners = 0
	/// Door gathers run, and the listeners they found in reach before the box filter
	var/door_gathers = 0
	var/door_listeners_found = 0
	/**
	 * Distinct ticks in which a move service was refused, and the longest run of consecutive such
	 * ticks. Totals cannot separate isolated spikes from sustained overload, and that is the whole
	 * case for or against a queue: deferring only helps where the backlog clears before the listener
	 * has walked out of the answer
	 */
	var/ticks_dropping = 0
	var/longest_drop_run = 0
	var/queue_wait_max = 0
	var/queue_depth_max = 0
	var/drain_tick_usage_total = 0
	/// Drained services by the candidate count of the box they ranked, indexed by count + 1 and
	/// clamped to [POINT_AMBIENCE_DENSITY_MAX], a cell with nothing in it being a real answer
	var/list/drain_density_count = new /list(POINT_AMBIENCE_DENSITY_MAX + 1)
	var/standing_walks = 0
	var/standing_active_skipped = 0
	var/standing_pending_skipped = 0
	var/standing_speed_skipped = 0
	/// The sounds speed silencing faded, and the fast steps passed over while silenced
	var/speed_fades = 0
	var/speed_moves_skipped = 0

	// Timings, taken only while a Counters snapshot is held, since the rustg pairs are FFI and not
	// free. Milliseconds, as a round's microseconds outgrow a float's exact range
	var/tile_cache_invalidation_ms = 0
	/// Each close's flush and stop pass. The flush is also inside tile_cache_invalidation_ms
	var/bulk_close_ms = 0
	var/bulk_close_worst_ms = 0
	/// Time inside run_fades, in ms, only while the Counters datum is active
	var/fade_ms = 0
	var/clip_refresh_ms = 0
	var/door_gather_ms = 0
	var/drain_ms = 0
	/**
	 * Drains bucketed by how many services ran back to back: 1, 2, 3-4, 5-8, 9+. Cost per service
	 * falling across those buckets is what draining together is worth, and the whole case for the
	 * queue, so the ms are kept beside the count to divide
	 */
	var/list/drain_size_services = list(0, 0, 0, 0, 0)
	var/list/drain_size_ms = list(0, 0, 0, 0, 0)
	var/standing_walk_ms = 0

/datum/controller/subsystem/point_ambience/New()
	for(var/category_path in subtypesof(/datum/point_ambience_category))
		var/datum/point_ambience_category/category = new category_path
		categories += category
		category.index = length(categories)
		category.mask = (1 << category.index)
		categories_by_path[category_path] = category
		max_range = max(max_range, category.range)
		loudest_volume = max(loudest_volume, category.volume)
		max_range_sq = max_range * max_range
		category.resolve_derived()
		category.floor_ratio = clamp(category.min_volume / max(category.volume, 1), 0.001, 1)
		category.stop_sound = sound(null, channel = category.channel)
	self_category = categories_by_path[/datum/point_ambience_category/torch]
	refresh_audible_mask()
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
	var/datum/controller/subsystem/point_ambience/old = SSpoint_ambience
	// An open bulk update is not carried. This flush and the stops in reset_listener_state cover
	// all it deferred
	old.clear_tile_cache()
	// Finish fades before replacing their categories and clearing the old slots.
	old.finish_fades()
	reset_listener_state(old)
	carry_settings(old)
	buckets_by_z = old.buckets_by_z
	cell_stride = old.cell_stride
	source_keys = old.source_keys
	source_turfs = old.source_turfs
	// dirty_clients is not carried: the standing walk catches everyone in it within a second
	fallback_loops = old.fallback_loops
	source_zs = old.source_zs
	// One past the old value, so every client's cached scan is redone against the new datum
	static_version = old.static_version + 1
	recount_sources(old)
	carry_category_tuning(old)
	refresh_audible_mask()
	// The buckets carry each source's category as its index into categories, which the new datums
	// were built with in the same subtypesof order, so the copied buckets stay right
	refresh_category_ranges()

/// Stops every client's playback through the old categories and clears what each one cached, so
/// its first service against the new datum walks afresh
/datum/controller/subsystem/point_ambience/proc/reset_listener_state(datum/controller/subsystem/point_ambience/old)
	PRIVATE_PROC(TRUE)
	// Stop through the old keys before playback is rebuilt against the replacement categories
	for(var/client/listener_client as anything in GLOB.clients)
		old.stop_all_for(listener_client)
		listener_client.point_ambience_profile_until = 0
		listener_client.point_ambience_next_service = 0
		listener_client.point_ambience_last_service = world.time - old.standing_skip
		listener_client.point_ambience_speed_moved = null
		listener_client.point_ambience_speed_silenced = FALSE
		listener_client.point_ambience_jump_next = 0

/// Every setting the config, the Mode verb or VV can change, so a rebuild keeps what was chosen
/datum/controller/subsystem/point_ambience/proc/carry_settings(datum/controller/subsystem/point_ambience/old)
	PRIVATE_PROC(TRUE)
	// Carried WITH settings_seeded, or the first fire() reads config over the top of them
	settings_seeded = old.settings_seeded
	mode = old.mode
	move_service_interval = old.move_service_interval
	move_service_interval_running_override = old.move_service_interval_running_override
	move_service_steps = old.move_service_steps
	speed_cutoff = old.speed_cutoff
	natural_run_step = old.natural_run_step
	max_services_per_tick = old.max_services_per_tick
	use_queue = old.use_queue
	use_tile_cache = old.use_tile_cache
	verify_tile_cache = old.verify_tile_cache
	standing_skip = old.standing_skip
	skip_active_movers = old.skip_active_movers
	standing_hoist = old.standing_hoist
	standing_walk_interval = old.standing_walk_interval
	clip_coalesce_window = old.clip_coalesce_window
	use_cell_cache = old.use_cell_cache
	cross_floor = old.cross_floor
	occlude_sources = old.occlude_sources
	door_mode = old.door_mode
	door_recheck = old.door_recheck
	door_recheck_period = old.door_recheck_period
	door_recheck_filter = old.door_recheck_filter
	send_cutoff = old.send_cutoff
	falloff_hardness = old.falloff_hardness
	original_sound = old.original_sound
	pan_depth_floor = old.pan_depth_floor
	pan_blend = old.pan_blend
	fade_steps = old.fade_steps
	fade_in_steps = old.fade_in_steps
	fade_ratio = old.fade_ratio
	fade_skip = old.fade_skip
	fade_budget = old.fade_budget
	voice_pitch = old.voice_pitch
	voice_offset = old.voice_offset

/// Points every indexed source at its replacement category and rebuilds the tallies from them
/datum/controller/subsystem/point_ambience/proc/recount_sources(datum/controller/subsystem/point_ambience/old)
	PRIVATE_PROC(TRUE)
	for(var/atom/source as anything in old.source_categories)
		var/datum/point_ambience_category/old_category = old.source_categories[source]
		var/datum/point_ambience_category/category = old_category ? categories_by_path[old_category.type] : null
		if(!category)
			continue
		source_categories[source] = category
		increment_source_count(category)
		adjust_floor_count(source_zs[source], category, 1)

/// Copies each category's live tuning and per source overrides onto its replacement
/datum/controller/subsystem/point_ambience/proc/carry_category_tuning(datum/controller/subsystem/point_ambience/old)
	PRIVATE_PROC(TRUE)
	for(var/datum/point_ambience_category/old_category as anything in old.categories)
		var/datum/point_ambience_category/category = categories_by_path[old_category.type]
		if(!category)
			continue
		category.silenced = old_category.silenced
		category.range = old_category.range
		// Live tuning survives a rebuild, or the curve silently reverts under whoever was testing
		category.falloff_hardness = old_category.falloff_hardness
		category.min_volume = old_category.min_volume
		category.floor_ratio = old_category.floor_ratio
		category.volume = old_category.volume
		loudest_volume = max(loudest_volume, category.volume)
		category.hardness_pinned = old_category.hardness_pinned
		category.indoors_volume_mult = old_category.indoors_volume_mult
		category.occlude = old_category.occlude
		category.centre_handoff = old_category.centre_handoff
		category.resolve_derived()
		for(var/overridden in old_category.source_volumes)
			loudest_volume = max(loudest_volume, category.volume * old_category.source_volumes[overridden])
		category.source_sounds = old_category.source_sounds
		category.source_volumes = old_category.source_volumes
		category.source_continuous = old_category.source_continuous
		category.files = old_category.files

/**
 * Runs the fades, the door gathers, the queue and the standing walk, in that order, each timed into
 * its own usage counter for the Server verb. On its first run it also seeds the config and then
 * hooks logins, in that order so the first muting check of every client sees the silenced
 * categories, and it closes a bulk update some caller left open
 */
/datum/controller/subsystem/point_ambience/fire(resumed)
	if(bulk_depth && bulk_opened_at != world.time)
		close_leaked_bulk()
	if(!settings_seeded)
		seed_settings()
	if(!hooked_logins)
		hook_logins()
	if(mode != POINT_AMBIENCE_LIVE)
		return
	// Ahead of the drain and the walk, since a listener who stops walking the moment they leave a
	// range is never served again and their fade still has to finish
	var/started
	if(length(fading) && world.time >= fade_next_due)
		started = TICK_USAGE
		run_fades()
		fade_usage += TICK_USAGE - started
	// Before the drain, so the listeners a door marks are served this fire
	if(length(changed_doors) && world.time >= next_door_recheck)
		started = TICK_USAGE
		recheck_doors()
		door_usage += TICK_USAGE - started
	// Whatever is marked, whether or not the queue is still on: switching it off must not strand
	// anyone already in the set. A paused drain still lets a due or unfinished walk go on, and the
	// walk's own tick check limits it
	if(length(dirty_clients))
		started = TICK_USAGE
		drain_dirty()
		drain_usage += TICK_USAGE - started
	if(!length(currentrun) && world.time >= next_standing_walk)
		next_standing_walk = world.time + standing_walk_interval
		currentrun = GLOB.clients.Copy()
		standing_walks++
		// Every walk rather than once at boot, since a localhost admin's login sets the move delays
		// after it. The speed stat's cap takes half a decisecond off a step
		natural_run_step = CONFIG_GET(number/movedelay/run_delay) - 0.5
	if(!length(currentrun))
		return
	started = TICK_USAGE
	run_standing_walk()
	walk_usage += TICK_USAGE - started

/**
 * Seeds the settings from config on the first fire.
 *
 * Both of the bulk reads here are boot-only on purpose, because each must not land on a running
 * server. Entering fallback gives every source a plain looping sound at once, upward of 1800
 * TIMER_CLIENT_TIME entries into a linearly scanned list, which delays every other timer in
 * SSsound_loops. That is why the Mode verb does not offer it and only this does. Silencing
 * de-indexes, and 1112 sconces leaving the buckets is the same shape of pass. Run once before a
 * round with nobody connected, both are fine.
 *
 * Mapload registers everything before this runs, and fires light themselves during it, so a category
 * silenced here already holds several hundred sources: register_source refuses them from now on but
 * cannot reach back, and this has to clear them out
 */
/datum/controller/subsystem/point_ambience/proc/seed_settings()
	PRIVATE_PROC(TRUE)
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
	if(any_silenced)
		begin_bulk_source_update("config silencing")
		// Copied because unregister_source mutates the list it walks
		for(var/atom/source as anything in source_categories.Copy())
			var/datum/point_ambience_category/category = source_categories[source]
			if(category?.silenced)
				unregister_source(source, category.type)
		end_bulk_source_update()
	refresh_audible_mask()
	static_version++

/**
 * The once-a-second visit to every client, resumed where the last fire paused. Most visits end at a
 * skip or at service_client's standing shortcut, which is repeated here so an answer that still holds
 * costs no proc call and no per service setup. It moves the same counters, so Counters still reads a
 * cached hit, and the fields that setup resets are only read by callers straight after their own
 * service. standing_hoist turns the copy off, which is how it is priced.
 *
 * The tick check heads the loop, so a skip reaches it the same as a service. Breaking rather than
 * returning keeps the segment timed and the walk flag cleared
 */
/datum/controller/subsystem/point_ambience/proc/run_standing_walk()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	in_standing_walk = TRUE
	// Timed only while a snapshot is held. The pair is two FFI calls, worth paying to answer a
	// question and not worth paying when nobody is asking
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_walk")
	while(length(currentrun))
		if(MC_TICK_CHECK)
			break
		var/client/listener_client = currentrun[currentrun.len]
		currentrun.len--
		if(!listener_client || listener_client.point_ambience_silenced || isobserver(listener_client.mob))
			continue
		// A step served them within the window, so this walk would land on a tile they are leaving.
		// Stamped by steps only, so one waiting past the budget still reads unserved
		if(standing_skip && world.time - listener_client.point_ambience_last_service < standing_skip)
			standing_skipped++
			continue
		// Silenced for speed and still moving that fast. A step at a natural pace brings them back, and
		// so does the first walk after they stop
		if(listener_client.point_ambience_speed_silenced && !isnull(listener_client.point_ambience_speed_moved) \
			&& world.time - listener_client.point_ambience_speed_moved < POINT_AMBIENCE_SPEED_STILL)
			standing_skipped++
			standing_speed_skipped++
			continue
		var/mob/listener = listener_client.mob
		// Still walking, and nothing near where they are now has changed since their last step was
		// served. The reuse test reads their current turf, the shortcut below their cached one
		if(skip_active_movers && standing_skip && !listener_client.point_ambience_clip_due \
			&& !listener_client.point_ambience_ear && !isnull(listener_client.point_ambience_last_move) \
			&& world.time - listener_client.point_ambience_last_move < standing_skip \
			&& world.time - listener_client.point_ambience_last_service < standing_skip + standing_walk_interval \
			&& listener_client.point_ambience_cache_turf \
			&& (listener_client.point_ambience_cache_version == static_version \
				|| can_reuse_tile_listener(get_turf(listener), listener_client.point_ambience_cache_version)) \
			&& listener_client.point_ambience_cache_self == listener?.point_ambience_self_source)
			standing_skipped++
			standing_active_skipped++
			continue
		if(!isnull(dirty_clients[listener_client]))
			standing_skipped++
			standing_pending_skipped++
			continue
		// service_client's shortcut without the call. The terms before the macro stand for what
		// service_client settles before its own shortcut: a due clip, an ear elsewhere, a lobby mob, a
		// stale speed stamp and a changed held torch all need the full service
		var/turf/listener_turf = get_turf(listener)
		var/datum/preferences/prefs = listener_client.prefs
		if(standing_hoist && !listener_client.point_ambience_clip_due && !listener_client.point_ambience_ear \
			&& listener_turf && !isnewplayer(listener) && isnull(listener_client.point_ambience_speed_moved) \
			&& listener.point_ambience_self_source == listener_client.point_ambience_cache_self \
			&& POINT_AMBIENCE_STANDING_UNCHANGED(listener_client, listener_turf, (prefs ? POINT_AMBIENCE_VOLUME(prefs) : null)))
			listener_client.point_ambience_cache_version = static_version
			services_total++
			shortcut_hits++
			standing_walk_visits++
			standing_walk_hits++
			continue
		var/standing_before = shortcut_hits
		service_client(listener_client)
		standing_walk_visits++
		if(shortcut_hits != standing_before)
			standing_walk_hits++
	if(timing)
		standing_walk_ms += rustg_time_microseconds("pa_walk") / 1000
	in_standing_walk = FALSE

/**
 * Serves the clients marked by the move hook, back to back, oldest mark first, up to the budget.
 *
 * Yields to the MC between them. The next fire() drains again from where this left off, the set
 * being the queue's own state rather than something rebuilt per tick, so a pause costs a tick of
 * waiting and nothing else
 */
/datum/controller/subsystem/point_ambience/proc/drain_dirty()
	PRIVATE_PROC(TRUE)
	queue_depth_max = max(queue_depth_max, length(dirty_clients))
	drains++
	drain_tick_usage_total += world.tick_usage
	// See run_standing_walk(): the FFI pair is paid only while a snapshot is held
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_drain")
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
			queue_wait_window_max = max(queue_wait_window_max, waited)
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
			break
	var/ran = drain_services - services_at_start
	if(!ran)
		if(timing)
			drain_ms += rustg_time_microseconds("pa_drain") / 1000
		return
	var/bucket
	switch(ran)
		if(1, 2)
			bucket = ran
		if(3 to 4)
			bucket = 3
		if(5 to 8)
			bucket = 4
		else
			bucket = 5
	drain_size_drains[bucket]++
	drain_size_services_total[bucket] += ran
	if(!timing)
		return
	var/took = rustg_time_microseconds("pa_drain") / 1000
	drain_ms += took
	drain_size_services[bucket] += ran
	drain_size_ms[bucket] += took

/datum/controller/subsystem/point_ambience/vv_edit_var(var_name, var_value)
	var/old_mode = mode
	. = ..()
	if(!.)
		return
	switch(var_name)
		// set_mode() stops what the old mode played and starts what the new one needs, so it runs
		// from the old mode rather than finding the write already done and returning
		if("mode")
			var/new_mode = mode
			mode = old_mode
			set_mode(new_mode)
		if("pan_blend", "pan_depth_floor")
			invalidate_listener_cache()
		// Occlusion is written into each listener's own answer, so a standing one keeps the old walls
		// until this drops it. The tile rankings are taken before occlusion and stay good
		if("door_mode", "occlude_sources")
			invalidate_listener_cache()
			if(door_mode == SOUND_DOORS_NONE)
				changed_doors.Cut()
		if("door_recheck")
			if(!door_recheck)
				changed_doors.Cut()
		if("original_sound")
			set_original_sound(var_value)
		if("falloff_hardness")
			set_falloff_hardness(var_value)
		if("send_cutoff")
			set_send_cutoff(var_value)
		if("use_tile_cache", "verify_tile_cache", "use_cell_cache", "cross_floor", "max_range", "max_range_sq")
			clear_tile_cache()
