/// 8-tile cells: three per axis within max_range 8, nine probes a walk. Larger cells probe fewer and
/// rank nearly twice the sources; smaller invert it. Measured; change it with the Here verb in hand.
#define CELL_SHIFT 3

/**
 * # Point Ambience
 *
 * Point-source ambience, served per client. Mapped emitters own no sound loops: each active source
 * sits in one shared index, and this subsystem serves each CLIENT the nearest source per category as
 * a native repeat on that category's reserved channel, through playsound_local.
 *
 * ## A service
 *
 * Movement requests are throttled and normally queued; a periodic client walk catches missed moves.
 * A full service reads a fixed box, the listener's cell
 * expanded by max_range, 24x24 tiles, out of the cell buckets; ranks what it finds by squared
 * distance; keeps the nearest per category; then sends or updates that channel. Ranking on distance
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
 * Sources in it suppress each other; different categories play together. Per-source sound and volume
 * overrides give a source its own audio without a new category, which costs a reserved channel and a
 * send per service while audible.
 *
 * ## Cost
 *
 * Billed per service, from eligible moves and the periodic client walk. Each service searches a
 * fixed box and serves at most one source per category. Local timings put most cost in overhead, so
 * the lever is FEWER services: move_service_interval halves a walker's at the shipped 5, paid for in
 * spatial resolution. MODES are the bigger hammer: FALLBACK gives every source a plain timer loop
 * instead, billed per source, volume only on replay, torches silent; OFF is silent. The Point
 * Ambience Mode verb switches live, config seeds at boot.
 *
 * ## Not here
 *
 * Gameplay-gated loops (boiling, relics, spell charges) are tokens and cost nothing idle; music
 * restarts on a source handoff; boat bells alternate two files and cannot native-repeat.
 *
 * ## The measurement verbs are not in the repo
 *
 * Comments below cite a Survey, Benchmark, Here, Verify and Send Diff verb, and the measured_* vars
 * are written by them. They are kept out of git deliberately, so in a plain checkout those vars stay
 * zero and the figures quoted here cannot be reproduced without them. Local timing runs used at
 * most two connected clients; larger population costs are modeled projections, not load tests.
 */

/// Set while a survey is sampling, null otherwise. Declared here rather than with the survey so
/// the subsystem builds whether or not the measurement tooling is present; the hooks below are
/// the whole interface it calls, and the survey overrides them.
GLOBAL_DATUM(point_ambience_survey, /datum/point_ambience_survey)

/datum/point_ambience_survey

/// Counts a step. Called before every early return, since steps TAKEN is the billed quantity.
/datum/point_ambience_survey/proc/count_move(atom/movable/mover)
	return

/// Times the service a real step causes, in whatever state the tick is actually in.
/datum/point_ambience_survey/proc/time_real_service(client/listener_client)
	return

SUBSYSTEM_DEF(point_ambience)
	name = "Point Ambience"
	/// Every tick, in the background bracket. The dirty set is drained here, and running only in
	/// the tick's slack is what bounds it on a loaded tick. The once-a-second walk over every client
	/// runs behind standing_walk_interval below, not behind this.
	wait = 1
	flags = SS_BACKGROUND | SS_NO_INIT | SS_TICKER
	/// Deciseconds between full walks over every client. Also the catch-up for a move that
	/// move_service_interval dropped: a gated move returns without servicing and schedules nothing,
	/// so if the gated step is a listener's LAST one nothing serves them until this fires, and this
	/// IS the worst-case silence on stopping at the edge of a range.
	///
	/// It is also the only thing here that scales with population rather than with movement, since
	/// every client is visited whether they moved or not. Halving it doubles that term and shortens
	/// the silence above by half; both are small, so set it by ear.
	var/standing_walk_interval = 1 SECONDS
	var/next_standing_walk = 0
	/// Deciseconds within which a client a step already served is passed over by the walk above,
	/// 0 for never. A walker is served by their steps every other step and would be walked again
	/// here every second, at a tile they are about to leave; on a busy server nearly all of that
	/// walk's cost is those. The price is the catch-up above: a client whose last served step fell
	/// inside this window when they stopped waits for the walk after next, so the worst case becomes
	/// this plus standing_walk_interval rather than standing_walk_interval alone.
	var/standing_skip = 0

	var/list/datum/point_ambience_category/categories = list()
	/// category typepath -> its singleton, the form register/unregister callers use.
	var/list/categories_by_path = list()
	var/list/currentrun = list()

	/// Off makes every walk probe the buckets directly instead of ranking the client's cached
	/// per-cell list, so the Here verb can time both on one tile. Keep the switch: it is the only way
	/// to price the cache.
	var/use_cell_cache = TRUE
	/// Positional, never string keyed: buckets_by_z[z] is a list indexed by cell, where a cell is
	/// (x >> CELL_SHIFT) * cell_stride + (y >> CELL_SHIFT) + 1, and each entry is a flat list of
	/// x, y, category index, source per active source in that cell, or null. The walk reads a
	/// source's position and kind straight out of the bucket, so rejecting one is two list reads
	/// and arithmetic and never a lookup; the lookups happen once, when the source registers.
	var/list/buckets_by_z = list()
	/// Moves per second per player, measured by the Survey verb and kept after it stops. Zero until
	/// one has run; the verbs then fall back to 1.38.
	var/measured_moves_per_player = 0
	/// Microseconds per service in the Benchmark verb's synthetic batch. Zero until one has run.
	/// This measures the batch, not a populated server; real client movement and delivery can differ.
	var/measured_batched_service_us = 0
	/// Microseconds a playsound_local() costs, from the Benchmark verb. Zero until one has run. The
	/// survey multiplies it by the sends it counted to price the rest of the sound system, which is
	/// mostly footsteps and which every ambient figure has historically been quoted without.
	var/measured_playsound_local_us = 0
	/// Microseconds a real cold service costs above the same service measured in a tight loop, from
	/// the survey's same-tile-same-instant pairs. Zero until one has run. Every looped figure in
	/// every verb understates by this, so a projection built on one is low by it per service.
	var/measured_warm_cold_gap_us = 0
	/// Tiles across one index cell, 1 << CELL_SHIFT. Exposed because a mover crosses a cell every
	/// this many steps and pays a candidate rebuild when they do; a projection built on the per-step
	/// cost without amortising that in is low by the difference over this number.
	var/cell_size = 1 << CELL_SHIFT
	/// Whether a listener hears sources one storey up or down, muffled. Off by design, ambience not
	/// carrying between floors; it is also the largest cost in the walk, measured, since the storey
	/// passes run whenever the own floor leaves a category unanswered. Seeded from
	/// POINT_AMBIENCE_CROSS_FLOOR, and the floor counts the passes read are kept either way.
	var/cross_floor = FALSE
	/**
	 * Sent volume below which a category stops instead of sending, so an inaudible outer ring costs
	 * no packets. 0 is off. A starting value, tuned by ear in View Variables while playing, and the
	 * range edge already cuts from the category floor, 8 or 3, times the slider under Master
	 */
	var/send_cutoff = 5
	/// Whether a wall between listener and source muffles or silences it; doors do not count, since a
	/// standing listener never re-sends. Off, a hearth through a keep wall sounds like one in the
	/// open. Costs a line walk per served category, so switching it off is also how to price it.
	var/occlude_sources = TRUE
	/// (world.maxy >> CELL_SHIFT) + 2, fixed at the first register. Only maxx can grow at
	/// runtime, and a larger x only extends a floor's list.
	var/cell_stride = 0
	/// source -> its current cell index, with source_zs holding the floor, for O(1) unregister
	/// and rebucketing on move.
	var/list/source_keys = list()
	/// source -> the category it belongs to, since the buckets no longer say.
	var/list/source_categories = list()
	/// Widest range any category asks for. The shared walk covers this and each source is then
	/// gated on its own category's range, so a short-range kind is filtered rather than searched.
	var/max_range = 0
	/// max_range squared, so the walk can gate on squared distance and never take a root.
	var/max_range_sq = 0
	/// How many categories currently have any source at all, so the walk can stop once every
	/// answerable one is answered. Counting all categories instead would mean a kind with nothing
	/// on the map, a fountainless map say, kept every client walking all three floors forever.
	var/list/source_counts = list()
	var/answerable_categories = 0
	/// Whether the per-mob move hook has been attached to the global login signals yet. Done on
	/// the first fire() rather than in New(), which may run before SSdcs exists.
	var/hooked_logins = FALSE
	/// Whether the settings below have been read from config. Separate from hooked_logins because
	/// Recover() carries the settings but must NOT carry the hooks: those are registered against
	/// the datum being replaced and have to be made again, while re-reading config would throw away
	/// whatever an admin set through the Mode verb, which is usually why the MC was restarted.
	var/settings_seeded = FALSE
	/// The category a mob's self source is served under.
	var/datum/point_ambience_category/self_category
	/// Source -> its turf at last register. The scan reads this instead of calling get_turf,
	/// which was the costliest statement on the reject path.
	var/list/source_turfs = list()
	/// Scratch for the walk, cleared and refilled per call rather than allocated; allocation is one of
	/// the dearest things a service does. Safe to share because the walk is SHOULD_NOT_SLEEP, so a
	/// second one cannot begin while the first is using these.
	var/list/scratch_best_distsq = list()
	var/list/scratch_settled = list()
	var/list/scratch_uncached = list()
	/// The SECOND nearest source per category from the walk that just ran, and its distance. Without
	/// somewhere to fall through to, one wall mutes a whole category while another of its sources
	/// stands in the open four tiles away. Valid only between the walk and the sends of the SAME
	/// service, so deliberately not on the client and not in the cache.
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
	/// Set per category while it is being resolved, when the direct line is blocked but a line from
	/// beside the obstruction is not: a corner, rather than an enclosure. Nothing counts walls; a
	/// straight run with no way round silences the category instead. Read by the send that follows
	/// immediately, and cleared at the top of every category so
	/// one category's wall cannot muffle the next one's source.
	var/serving_muffle_wall = FALSE
	/// Sends made by the service running right now, reset at the top of each one, read by the survey
	/// beside every timing. Two tiles with the same candidate count but different audible categories
	/// differ by about a send each, so a cost figure without this cannot be compared to another's.
	var/sends_this_service = 0
	/// Whether the service running right now reached the walk at all, reset with the send count. A
	/// standing shortcut and a listener with no turf both leave the client's candidate list holding
	/// some other cell's, so anything reading it has to know which services ranked a box.
	var/walked_this_service = FALSE
	/// Whether the service running right now rebuilt its candidate set, reset with the send count.
	/// One step in cell_size does, so if the dear tail of the cost distribution is mostly these,
	/// the spike is the rebuild; if it looks like everything else, the spike is the server.
	var/rebuilt_this_service = FALSE
	/// Wall walks this service performed and the turfs they stepped through, reset with the send
	/// count. Both halves are needed: a check that finds a wall on the first step and one that walks
	/// eight tiles to find nothing differ by an order of magnitude.
	var/occlusion_checks_this_service = 0
	var/occlusion_tiles_this_service = 0
	/// Cumulative across the round, for the survey's rates, and incremented only when a winner turned
	/// out occluded: how often the fall-through was reached, how often the runner-up was clear and
	/// served in its place, and how often both were blocked and the category went silent.
	var/runner_up_offered = 0
	var/runner_up_served = 0
	var/runner_up_silenced = 0
	/// Cumulative like the three above, and the DENOMINATOR they must be read against: they count
	/// every service including the tick's, so dividing by the survey's own timed (move-hook only)
	/// count once reported 800% blocked winners. Checks also cross-check the arithmetic, since
	/// runner_up_offered only increments after a SOLID check and so can never exceed them.
	var/services_total = 0
	/// Services that returned at the standing shortcut, from any caller; fire() reads it around each
	/// of its own to fill the two below. Three counters rather than one because the verbs call
	/// service_client themselves, and a global count cannot tell the tick's walks from theirs.
	var/standing_hits = 0
	var/tick_services = 0
	var/tick_standing_hits = 0
	/// Index changes, counted at the register and unregister sites rather than read off
	/// static_version, which the survey and the benchmark bump themselves to force rebuilds.
	var/index_changes = 0
	var/occlusion_checks_total = 0
	/// Cumulative CORNER verdicts, which the counters above never see because a corner is served
	/// muffled rather than blocked. It prices what corners cost: each one is a blocked direct line
	/// plus the side probes has_open_path() ran to find the way round, so this is how often that
	/// second and third walk are paid for.
	var/occlusion_corners = 0
	/// The echo array a muffled send carries, whether the muffle came from a storey or a corner.
	/// Built once and never written after, so one
	/// list serves every client. A send is snapshotted, so sharing it is safe.
	var/list/storey_echo
	/// POINT_AMBIENCE_LIVE, FALLBACK or OFF. Change through set_mode(), which starts or stops
	/// what the old and new modes need.
	var/mode = POINT_AMBIENCE_LIVE
	/// Minimum deciseconds between move-hook services of one client. 0 serves every step.
	var/move_service_interval = 0
	/// Replaces the interval above for a client whose move intent is RUN. NAMED "override" because 0
	/// here means "runners use move_service_interval", NOT "runners are uncapped" as it does above.
	///
	/// A time cap gives coarser SPATIAL resolution the faster you move, and what a listener hears
	/// depends on tiles between updates rather than seconds: at speed 15 an interval of 5 is one
	/// service every four tiles, a wall sconce's whole range in one jump from near-silence to full.
	/// 3 holds it to two tiles. Intent rather than measured speed, so both values stay hard ceilings.
	var/move_service_interval_running_override = 0
	/// Ceiling on move-hook services in one tick, 0 for none. Under the queue it is the drain's budget
	/// per tick. On the inline path the move hook is a signal handler running outside MC_TICK_CHECK,
	/// so a crowd moving at once lands in one tick with nothing to spread it; this and the
	/// TICK_CHECK_LOW gate beside it are that bound, and 0 turns both off. The standing walk is
	/// deliberately not counted: it is MC-governed already, and it is the catch-up for what is
	/// refused or deferred here.
	var/max_services_per_tick = 0
	/// world.time of the tick services_this_tick belongs to; it advances by tick_lag, so it is the
	/// tick stamp.
	var/services_tick_stamp = 0
	var/services_this_tick = 0
	/// Move-hook services refused, by which gate, for the survey.
	var/services_dropped_tick = 0
	var/services_dropped_count = 0
	/// Distinct ticks in which a move service was refused, and the longest run of consecutive such
	/// ticks. Totals cannot separate isolated spikes from sustained overload, and that is the whole
	/// case for or against a queue: deferring only helps where the backlog clears before the listener
	/// has walked out of the answer.
	var/ticks_dropping = 0
	var/longest_drop_run = 0
	var/current_drop_run = 0
	/// A tick index rather than world.time, since consecutive ticks differ by tick_lag and comparing
	/// those is a float compare on a number that grows all round.
	var/last_drop_tick_index = 0
	/// The move hook marks the client here instead of servicing inline, and fire() drains the set
	/// every tick back to back, up to max_services_per_tick. A service costs several times less run
	/// straight after another than run on its own, the processor's predictor and cache state for
	/// this path being gone after a tick of other work and back after one pass, so draining a tick's
	/// movers together pays that once. An entry is the CLIENT, served at wherever they are when
	/// their turn comes, so nothing goes stale. 0 leaves the inline path with the two rails above.
	var/use_queue = FALSE
	/// client -> world.time it was marked. Marking is idempotent, so a client keeps its place however
	/// many steps it takes, and the stamp is the wait the survey reports.
	var/list/dirty_clients = list()
	var/queue_served = 0
	var/queue_wait_total = 0
	var/queue_wait_max = 0
	var/queue_depth_max = 0
	/// Fires that hit the budget with entries still waiting.
	var/queue_deferred_ticks = 0
	/// Read as deltas, so a populated round can be measured without sampling it. Nothing here may
	/// sample, loop or force a rebuild; the counts are plain increments and run always. The two
	/// rustg pairs that fill the _ms figures are FFI and are NOT free, so they run only while a
	/// snapshot is held. Times are milliseconds, since a round's microseconds outgrow a float's
	/// exact range and every later add would round.
	var/moves_total = 0
	var/move_services = 0
	var/drains = 0
	var/drain_ms = 0
	var/drain_services = 0
	var/drain_sends = 0
	var/drain_paused = 0
	var/drain_tick_usage_total = 0
	/// Drains bucketed by how many services ran back to back: 1, 2, 3-4, 5-8, 9+. Cost per service
	/// falling across those buckets is what draining together is worth, and the whole case for the
	/// queue, so the ms are kept beside the count to divide.
	var/list/drain_size_services = list(0, 0, 0, 0, 0)
	var/list/drain_size_ms = list(0, 0, 0, 0, 0)
	/// Drained services by the candidate count of the box they ranked, indexed by count + 1 and
	/// clamped to [POINT_AMBIENCE_DENSITY_MAX], a cell with nothing in it being a real answer.
	var/list/drain_density_count = new /list(POINT_AMBIENCE_DENSITY_MAX + 1)
	var/standing_walks = 0
	var/standing_walk_ms = 0
	var/standing_skipped = 0
	/// world.time this instance was built. An MC restart resets it along with everything above, so a
	/// reader holding an older snapshot must throw that away rather than subtract from it.
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
	/// Source -> its plain loop while in fallback mode.
	var/list/fallback_loops = list()
	/// Bumped whenever the index changes in a way a standing listener could hear: a source that
	/// is not carried joins, leaves, moves or changes category or override, or a source changes
	/// carrier. Clients compare it to skip the scan while nothing static changed.
	var/static_version = 0
	/// Source -> the z it is bucketed on, so a removal can find its floor tally and cell.
	var/list/source_zs = list()
	/// Positional by z: category -> how many sources are bucketed on that floor, or null. An
	/// adjacent-floor pass runs only when some still-unanswered category has sources there.
	var/list/floor_counts = list()

/datum/controller/subsystem/point_ambience/New()
	for(var/category_path in subtypesof(/datum/point_ambience_category))
		var/datum/point_ambience_category/category = new category_path
		categories += category
		category.index = length(categories)
		categories_by_path[category_path] = category
		max_range = max(max_range, category.range)
		max_range_sq = max_range * max_range
		category.range_sq = category.range * category.range
		if(!category.falloff_exponent)
			category.falloff_exponent = sound_falloff_for_range(category.range)
		category.inv_falloff_exponent = 1 / category.falloff_exponent
		category.inv_muffled_exponent = 1 / (category.falloff_exponent * SOUND_MUFFLE_EXPONENT_MULT)
		category.stop_sound = sound(null, channel = category.channel)
	self_category = categories_by_path[/datum/point_ambience_category/torch]
	// Recover() builds a fresh datum, so this also stamps a restart: a snapshot taken before it
	// cannot be subtracted from what this instance has counted since.
	started_at = world.time
	storey_echo = new /list(18)
	storey_echo[7] = SOUND_MUFFLE_OCCLUSION
	storey_echo[8] = SOUND_MUFFLE_OCCLUSION_LF
	// Category tables must exist before the parent constructor calls Recover().
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
	// Stop through the old keys before playback is rebuilt against the replacement categories.
	for(var/client/listener_client as anything in GLOB.clients)
		for(var/datum/point_ambience_category/old_category as anything in listener_client.point_ambience_sources)
			SSpoint_ambience.stop_for(listener_client, old_category)
		listener_client.point_ambience_cache_turf = null
		listener_client.point_ambience_cache_static = null
		listener_client.point_ambience_profile_until = 0
		listener_client.point_ambience_next_service = 0
		listener_client.point_ambience_last_service = world.time - SSpoint_ambience.standing_skip
	buckets_by_z = SSpoint_ambience.buckets_by_z
	cell_stride = SSpoint_ambience.cell_stride
	source_keys = SSpoint_ambience.source_keys
	source_turfs = SSpoint_ambience.source_turfs
	// Carried WITH settings_seeded, or the first fire() reads config over the top of them.
	settings_seeded = SSpoint_ambience.settings_seeded
	mode = SSpoint_ambience.mode
	move_service_interval = SSpoint_ambience.move_service_interval
	move_service_interval_running_override = SSpoint_ambience.move_service_interval_running_override
	max_services_per_tick = SSpoint_ambience.max_services_per_tick
	use_queue = SSpoint_ambience.use_queue
	standing_skip = SSpoint_ambience.standing_skip
	cross_floor = SSpoint_ambience.cross_floor
	send_cutoff = SSpoint_ambience.send_cutoff
	// The set is not carried: the standing walk catches everyone in it within a second.
	fallback_loops = SSpoint_ambience.fallback_loops
	source_zs = SSpoint_ambience.source_zs
	// One past the old value, so every client's cached scan is redone against the new datum.
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
			category.source_sounds = old_category.source_sounds
			category.source_volumes = old_category.source_volumes
			category.source_continuous = old_category.source_continuous
			category.files = old_category.files
	// The buckets carry each source's category as its index into categories, which the new datums
	// were built with in the same subtypesof order, so the copied buckets stay right.

/**
 * Puts an active source into the index, or moves one already in it.
 *
 * Idempotent. A source that can move must call this again from its own Moved() (the rogue lights and
 * handheld torches do); the bone structures are treated as immobile and go stale if dragged. One
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
 * * volume_override - the same for volume; range stays per-category, being the walk's gate
 */
/datum/controller/subsystem/point_ambience/proc/register_source(atom/source, category_path, sound_override, volume_override)
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
	source_turfs[source] = source_turf
	// Reapplied on every call, so a rebucketing move does not drop them.
	if(sound_override && category.source_sounds[source] != sound_override)
		category.source_sounds[source] = sound_override
		static_version++
		index_changes++
	if(volume_override && category.source_volumes[source] != volume_override)
		category.source_volumes[source] = volume_override
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
		// bucket on every step.
		if(old_turf != source_turf)
			var/list/bucket = buckets_by_z[z][cell]
			var/at = bucket ? bucket.Find(source) : 0
			if(at)
				bucket[at - 3] = source_turf.x
				bucket[at - 2] = source_turf.y
			static_version++
			index_changes++
		return
	if(old_cell)
		remove_from_bucket(source, old_z, old_cell)
		adjust_floor_count(old_z, source_categories[source], -1)
	// Tally both sides: a source can move BETWEEN categories, and these decide whether the storey
	// passes run at all.
	var/datum/point_ambience_category/previous_category = source_categories[source]
	if(previous_category != category)
		if(previous_category)
			decrement_source_count(previous_category)
			// The overrides live on the category, so a move leaves them behind holding a hard
			// reference the old category can no longer reach to clear.
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
	if(mode == POINT_AMBIENCE_FALLBACK)
		start_fallback(source)

/// Whether any source of a category already sits within radius of a turf. Walks the same buckets
/// the listener walk does, exiting on the first hit. Spaces a run's voices: mostly at mapload, and
/// again per candidate neighbour whenever a river voice's turf is destroyed and the run re-seeds.
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
 * * sound_override, volume_override - as register_source, letting a source ride a category it does
 *   not sound like
 * * continuous - the source is one voice of a long thing, so it must not restart or pan on a
 *   handoff. TRUE by default, since anything spread over a run is a line.
 */
/datum/controller/subsystem/point_ambience/proc/register_spread_source(atom/source, category_path, spread, sound_override, volume_override, continuous = TRUE)
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		return FALSE
	// By DISTANCE, not a grid of spread-sized blocks: a grid bounds spacing at 2*spread-1, which at
	// spread 8 put voices 15 tiles apart against a range of 5 and left the bank silent in the middle.
	var/datum/point_ambience_category/claim_category = categories_by_path[category_path]
	if(!claim_category)
		return FALSE
	if(any_source_within(source_turf, claim_category, spread))
		return FALSE
	// Continuous by default: anything spread over a run is a line, and a line played as a point
	// source restarts and flips its stereo image every time the nearest voice changes.
	if(continuous)
		claim_category.source_continuous[source] = TRUE
	register_source(source, category_path, sound_override, volume_override)
	return TRUE

/**
 * Swaps a category's whole clip set, which is how day and night change.
 *
 * Nothing playing is restarted: each listener picks from the new set at their next clip boundary, so
 * the change arrives without a seam.
 *
 * Arguments:
 * * category_path - the category's TYPEPATH, not its datum
 */
/datum/controller/subsystem/point_ambience/proc/set_category_files(category_path, list/files)
	var/datum/point_ambience_category/category = categories_by_path[category_path]
	if(!category)
		return
	category.files = length(files) ? files : null

/// A clip of a category's set has run its length for this listener: serve them afresh, so the
/// next one is picked. The client is still native-repeating the old clip until the new one
/// lands, so a late timer costs a cut and never silence.
/datum/controller/subsystem/point_ambience/proc/advance_clip(client/listener_client, datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	// A client that disconnected arrives as null. Leaving live mode stops every category and
	// deletes these timers with them, so the mode test is only for a timer that outlived that.
	if(mode != POINT_AMBIENCE_LIVE || !listener_client || !listener_client.point_ambience_sources[category])
		return
	// Cleared without a stop, so the fresh send replaces the clip rather than following a gap. The
	// cached turf goes too, or a standing listener takes the shortcut past the loop that re-sends.
	stop_for(listener_client, category, send_null = FALSE)
	listener_client.point_ambience_cache_turf = null
	service_client(listener_client)
	if(!listener_client.point_ambience_sources[category])
		SEND_SOUND(listener_client, category.stop_sound)

/**
 * Takes a source out of the index and silences it for anyone currently hearing it.
 *
 * Safe on something never registered, the common case for a mapped emitter that was never lit.
 *
 * Arguments:
 * * category_path - accepted for call-site clarity and then IGNORED; the category is read from the
 *   index, since a caller passing the wrong path would decrement the wrong tally.
 */
/datum/controller/subsystem/point_ambience/proc/unregister_source(atom/source, category_path)
	SHOULD_NOT_SLEEP(TRUE)
	// From the index, not the argument: a caller passing the wrong path would decrement the wrong
	// tally and leave the sound playing. category_path stays in the signature for call-site clarity.
	var/datum/point_ambience_category/category = source_categories[source] || categories_by_path[category_path]
	if(!category)
		return
	var/old_cell = source_keys[source]
	if(!old_cell)
		// Never registered, so it cannot be anyone's current source: skips the client walk for the
		// mapped-off majority whose Initialize lands here.
		return
	remove_from_bucket(source, source_zs[source], old_cell)
	adjust_floor_count(source_zs[source], category, -1)
	static_version++
	index_changes++
	source_keys -= source
	source_zs -= source
	source_turfs -= source
	source_categories -= source
	stop_fallback(source)
	decrement_source_count(category)
	category.source_sounds -= source
	category.source_volumes -= source
	category.source_continuous -= source
	// The channel is the stop handle: a snuffed source goes silent now, not when its replay runs
	// out. One client walk per deactivation.
	for(var/client/listener_client in GLOB.clients)
		if(listener_client.point_ambience_sources[category] == source)
			stop_for(listener_client, category)

/// Guarded against going negative, since answerable_categories drifting below the truth would
/// stop the storey passes early and quietly lose every source a floor away.
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
	// The source is the last of its four entries.
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
/// boolean per floor and the neighbour is always the next z, which is what get_step(UP) walks.
/datum/controller/subsystem/point_ambience/proc/floor_above(z)
	PRIVATE_PROC(TRUE)
	var/list/levels = SSmapping.multiz_levels
	if(length(levels) < z)
		return 0
	var/list/links = levels[z]
	return (links && links[Z_LEVEL_UP]) ? z + 1 : 0

/// The z one storey down, or 0 where nothing connects. Arithmetic rather than a turf lookup, since
/// the walk only ever wants the number.
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
			// value and never be started again.
			slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = null
			if(slot[POINT_AMBIENCE_SLOT_TIMER])
				deltimer(slot[POINT_AMBIENCE_SLOT_TIMER])
				slot[POINT_AMBIENCE_SLOT_TIMER] = null
	if(send_null)
		SEND_SOUND(listener_client, category.stop_sound)

/// A lit torch in a hand is heard by its carrier alone. It never enters the index: it is marked on
/// its carrier as that mob's self source and served to them at distance 0, so no walk ever scans it
/// and no standing listener has to be rechecked because someone walked past. A lit torch lying on
/// the ground is an ordinary source that everyone nearby hears, and a torch in a sconce is not a
/// source at all: the sconce is.
/datum/controller/subsystem/point_ambience/proc/set_self_source(mob/carrier, atom/source)
	carrier.point_ambience_self_source = source

/// Clears the mob's self source if it is this one, and silences it at once, as an unregister does
/// for an indexed source.
/datum/controller/subsystem/point_ambience/proc/clear_self_source(mob/carrier, atom/source)
	if(carrier.point_ambience_self_source != source)
		return
	carrier.point_ambience_self_source = null
	var/client/listener_client = carrier.client
	if(listener_client && listener_client.point_ambience_sources[self_category] == source)
		stop_for(listener_client, self_category)

/**
 * Services every non-observer client, and on its FIRST run only, seeds the config.
 *
 * Both config reads are boot-only on purpose, because each is a bulk operation that must not land on
 * a running server. Entering fallback gives every source a plain looping sound at once, upward of
 * 1800 TIMER_CLIENT_TIME entries into a linearly scanned list, which delays every other timer in
 * SSsound_loops and is audible as weather stuttering; that is why the Mode verb does not offer it
 * and only this does. Silencing now de-indexes, and 1112 sconces leaving the buckets is the same
 * shape of pass. Run once before a round with nobody connected, both are fine.
 *
 * Mapload registers everything before this runs, and fires light themselves during it, so a category
 * silenced here already holds several hundred sources: register_source refuses them from now on but
 * cannot reach back, and this has to clear them out.
 */
/datum/controller/subsystem/point_ambience/fire(resumed)
	if(!hooked_logins)
		hook_logins()
	if(!settings_seeded)
		settings_seeded = TRUE
		move_service_interval = CONFIG_GET(number/point_ambience_move_interval)
		move_service_interval_running_override = CONFIG_GET(number/point_ambience_move_interval_running_override)
		max_services_per_tick = CONFIG_GET(number/point_ambience_max_services_per_tick)
		use_queue = CONFIG_GET(number/point_ambience_queue)
		standing_skip = CONFIG_GET(number/point_ambience_standing_skip)
		cross_floor = CONFIG_GET(number/point_ambience_cross_floor)
		set_mode(CONFIG_GET(number/point_ambience_mode))
		var/list/silenced_names = CONFIG_GET(keyed_list/silence_point_ambience)
		var/any_silenced = FALSE
		for(var/datum/point_ambience_category/category as anything in categories)
			category.silenced = !!silenced_names[category.config_name]
			if(category.silenced)
				any_silenced = TRUE
		// Copied because unregister_source mutates the list it walks.
		if(any_silenced)
			for(var/atom/source as anything in source_categories.Copy())
				var/datum/point_ambience_category/category = source_categories[source]
				if(category?.silenced)
					unregister_source(source, category.type)
		static_version++
	if(mode != POINT_AMBIENCE_LIVE)
		return
	// Whatever is marked, whether or not the queue is still on: switching it off must not strand
	// anyone already in the set.
	var/drained = TRUE
	if(length(dirty_clients))
		drained = drain_dirty()
	// A paused drain must still allow a due or unfinished standing walk to progress.
	// Its own tick check limits the work and currentrun retains the remaining clients.
	if(!drained && !length(currentrun) && world.time < next_standing_walk)
		return
	if(!length(currentrun) && world.time >= next_standing_walk)
		next_standing_walk = world.time + standing_walk_interval
		currentrun = GLOB.clients.Copy()
		standing_walks++
	if(!length(currentrun))
		return
	in_standing_walk = TRUE
	// Timed only while a snapshot is held. The pair is two FFI calls, worth paying to answer a
	// question and not worth paying when nobody is asking.
	var/timing = !isnull(GLOB.point_ambience_counters)
	if(timing)
		rustg_time_reset("pa_walk")
	while(length(currentrun))
		var/client/listener_client = currentrun[currentrun.len]
		currentrun.len--
		if(listener_client && !listener_client.point_ambience_silenced && !isobserver(listener_client.mob))
			// A step served them within the window, so the next one will too; this walk would land
			// on a tile they are leaving. Stamped by steps only, so a client waiting in the set past
			// the budget still reads as unserved and is caught here.
			if(standing_skip && world.time - listener_client.point_ambience_last_service < standing_skip)
				standing_skipped++
			else
				var/standing_before = standing_hits
				service_client(listener_client)
				tick_services++
				if(standing_hits != standing_before)
					tick_standing_hits++
		// break rather than return, or a paused walk leaves the segment untimed and the flag set.
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
	// See fire(): the FFI pair is paid only while a snapshot is held.
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
		// A disconnected client leaves a null key, and one between mobs is picked up by the standing
		// walk instead. Both still cost the pop, so both fall through to the tick check below rather
		// than skipping it: a set full of either would otherwise drain in one burst.
		var/marked = listener_client ? dirty_clients[listener_client] : world.time
		dirty_clients.Cut(1, 2)
		if(listener_client?.mob)
			var/waited = world.time - marked
			queue_wait_total += waited
			queue_wait_max = max(queue_wait_max, waited)
			queue_served++
			served++
			var/services_before = services_total
			// Timed in place when a survey runs.
			if(GLOB.point_ambience_survey)
				GLOB.point_ambience_survey.time_real_service(listener_client)
			else
				service_client(listener_client)
			listener_client.point_ambience_last_service = world.time
			// A client with the sound off returns before counting, leaving the send figure stale.
			if(services_total != services_before)
				drain_services++
				drain_sends += sends_this_service
				// Only a service that actually ranked a box has a candidate count. A standing
				// shortcut, which is common once the budget binds, still holds the list from
				// whatever cell it was last in.
				if(use_cell_cache && walked_this_service)
					drain_density_count[min(round(length(listener_client.point_ambience_cell_candidates) / 4), POINT_AMBIENCE_DENSITY_MAX) + 1]++
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
 * The whole cost of the subsystem is here, and it runs once per step from the move hook and once per
 * tick from fire(). A listener who has not moved and whose index version is unchanged takes the
 * cached answer and skips the walk entirely.
 *
 * Occlusion resolves BEFORE the sends, since a wall changes which source wins rather than only how
 * it sounds, and the resolved winner is written back so a later standing service does not redo it.
 */
/datum/controller/subsystem/point_ambience/proc/service_client(client/listener_client)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	// Before the count, so they stay out of the rates. With no move hook and the walk passing them,
	// only a listener queued just before going silent arrives here
	if(listener_client.point_ambience_silenced)
		return
	var/toggles = listener_client.prefs?.toggles
	services_total++
	sends_this_service = 0
	walked_this_service = FALSE
	rebuilt_this_service = FALSE
	occlusion_checks_this_service = 0
	occlusion_tiles_this_service = 0
	// Per SERVICE, not per walk: a standing listener reaching the send loop without walking would
	// otherwise get a runner-up from another turf, and possibly another client.
	scratch_second.Cut()
	scratch_second_distsq.Cut()
	var/mob/listener = listener_client.mob
	var/turf/listener_turf
	// A headless dullahan hears from the head, kept current by the watch, null for everyone else
	var/atom/movable/ear = listener_client.point_ambience_ear
	// Observers are skipped by the tick and silenced at login; this catches any that arrive
	// another way.
	if(listener && !isnewplayer(listener) && !isobserver(listener))
		listener_turf = get_turf(ear || listener)
	// The mob's own lit torch, served ahead of what the walk found. It is in the body's hand, so
	// it is only theirs to hear while the ear is on that turf
	var/atom/self_source = null
	if(listener_turf && (!ear || listener_turf == get_turf(listener)))
		self_source = listener.point_ambience_self_source
	// Same turf, same index version, same point ambience volume: the answer cannot have changed.
	// Everything else is a full walk
	var/list/nearest_by_category
	var/standing = FALSE
	if(listener_turf)
		var/ambience_volume = listener_client.prefs ? listener_client.prefs.at_overall(listener_client.prefs.pointambiencevol) : null
		if(listener_turf == listener_client.point_ambience_cache_turf \
			&& static_version == listener_client.point_ambience_cache_version \
			&& ambience_volume == listener_client.point_ambience_cache_volume)
			standing = TRUE
			// Every category below would return unchanged, so skip the loop. The torch is checked
			// separately because lighting one bumps no version. This returns without preparing, so
			// the serving_* vars still describe the last client served and nothing may read them.
			if(self_source == listener_client.point_ambience_cache_self)
				standing_hits++
				return
		// Hearing and the send environment, after the shortcut so a listener standing still never
		// pays for them. One who cannot be served is treated as having no turf, which stops
		// everything they had playing.
		if(!prepare_serving(listener_client, listener, listener_turf))
			listener_turf = null
			self_source = null
		else if(standing)
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
	if(!listener_turf)
		listener_client.point_ambience_cache_turf = null
	listener_client.point_ambience_cache_self = self_source
	var/list/sources = listener_client.point_ambience_sources
	// Nothing answered, nothing playing and no torch in hand is most of the map, and every
	// iteration below would find nothing to do.
	if(!self_source && !length(nearest_by_category) && !length(sources))
		return
	// Sconces, standing fires and the listener's own torch are all this category, so one test turns
	// off every torch they can hear rather than only the ones on the map.
	var/no_torch = (toggles & SOUND_DISABLE_TORCH_AMBIENCE)
	for(var/datum/point_ambience_category/category as anything in categories)
		var/atom/nearest
		serving_muffle_wall = FALSE
		if(category.silenced || (no_torch && category == self_category))
			nearest = null
		else if(self_source && category == self_category)
			nearest = self_source
		else
			nearest = nearest_by_category?[category]
			// Occlusion changes WHICH source is served, so it runs before the send. Written back
			// because a later standing service re-reads this list without walking.
			if(nearest && occlude_sources)
				var/atom/clear_source = unoccluded_source(nearest, category)
				if(clear_source != nearest)
					if(clear_source)
						nearest_by_category[category] = clear_source
					else
						nearest_by_category -= category
					nearest = clear_source
		if(!nearest)
			if(sources[category])
				stop_for(listener_client, category)
			continue
		var/atom/previous = sources[category]
		var/fresh = (nearest != previous)
		if(fresh)
			sources[category] = nearest
		// A standing listener's unchanged source would get the same numbers as last time. Nothing
		// reaches here having moved: anything that moves bumps static_version, which ends standing.
		else if(standing)
			continue
		var/sent
		sends_this_service++
		sent = slim_send(listener, listener_client, category, nearest, fresh, !!previous, FALSE)
		// Nothing usable was sent, so null whatever was playing or it repeats client-side at a stale
		// volume. Keyed on previous, not fresh: a failed switch must still silence the live source.
		if(!sent)
			stop_for(listener_client, category, send_null = !!previous)

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
/datum/controller/subsystem/point_ambience/proc/prepare_serving(client/listener_client, mob/listener, turf/listener_turf)
	SHOULD_NOT_SLEEP(TRUE)
	if(world.time >= listener_client.point_ambience_profile_until)
		listener_client.point_ambience_profile_until = world.time + standing_walk_interval
		listener_client.point_ambience_hearing = listener.can_hear()
	if(!listener_client.point_ambience_hearing)
		return FALSE
	// Checked here so nothing below works for a muted listener. ZERO only, never "low", and null is
	// not zero: no prefs means no scaling rather than silence.
	var/volume_scale = listener_client.prefs ? listener_client.prefs.at_overall(listener_client.prefs.pointambiencevol) * 0.01 : null
	if(volume_scale == 0)
		return FALSE
	if(!listener_turf)
		listener_turf = get_turf(listener)
		if(!listener_turf)
			return FALSE
	serving_turf = listener_turf
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
	serving_environment = (A && A.soundenv && A.soundenv != SOUND_ENVIRONMENT_NONE) ? A.soundenv : SOUND_DEFAULT_ENVIRONMENT
	// null when there are no prefs, so no scaling; a prefs datum with no volume scales to 0,
	// which rejects the send, as playsound_local does.
	serving_volume_scale = volume_scale
	return TRUE

/**
 * The verbs' entry to a send, being the dispatch the service otherwise makes inline.
 *
 * Returns the volume sent, FALSE when nothing usable could be, or null when the listener would take
 * playsound_local and there is nothing to dry-run.
 *
 * Arguments:
 * * fresh - the winning source changed, so the sound restarts rather than taking SOUND_UPDATE
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
 * A cut-down can_see(), reading turf opacity only and skipping each turf's contents loop. DOORS ARE
 * LEFT OUT DELIBERATELY, not to save time. Doors are objects where walls are turfs, so only that
 * contents loop would catch them, and a listener standing still never re-sends an unchanged static
 * source, so a door's state would freeze into the sound until they moved. Walls do not move, so a
 * frozen answer stays right. The price is that sound crosses a doorway shut or open, along the lines
 * that pass through that turf.
 *
 * Arguments:
 * * trace - filled with the turfs the line crossed, for the Here verb to print. The live path
 *   passes null, which keeps the reported line and the tested line one walk rather than two.
 */
/datum/controller/subsystem/point_ambience/proc/source_occluded(turf/source_turf, turf/listener_turf, datum/point_ambience_category/category, list/trace)
	if(!occlude_sources || !category.occlude || source_turf == listener_turf || source_turf.z != listener_turf.z)
		return OCCLUSION_CLEAR
	// FALSE: a door's state would freeze into the sound of a listener who is standing still. Tokens
	// re-check per step and pass TRUE. Graded rather than a bare walk, or this verb reports SOLID for
	// a source the service is serving muffled and the two disagree about what you can hear.
	. = sound_occlusion_grade(listener_turf, source_turf, category.range, FALSE, trace)
	count_occlusion_walk()

/// Folds what the last sound_occlusion_grade() cost into this service's totals: one direct walk plus
/// however many probes it needed. The probes are plain procs shared with the token and one-shot
/// paths, so they cannot count into a service themselves.
/datum/controller/subsystem/point_ambience/proc/count_occlusion_walk()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/walks = 1 + GLOB.occlusion_probe_walks
	occlusion_checks_this_service += walks
	occlusion_checks_total += walks
	occlusion_tiles_this_service += GLOB.opacity_walk_tiles + GLOB.occlusion_probe_tiles

/// NO LEAK HERE, DELIBERATELY. playsound's SOUND_TRAVEL_LEAKING lets an enclosed listener hear a
/// one-shot faintly for a few tiles past the barrier, and that is right for a one-shot and wrong for
/// a loop. A hearth leaking at a fixed volume through every wall in a town is a permanent drone, and
/// since only the nearest source per category is served it would be a GHOST of a fire nobody can
/// reach, displacing the runner-up below, which is a real one with a real path to it. It would also
/// turn silence into a send on the one system billed per moving listener, and the surveys measured
/// blocked winners as almost always ending in silence.
///
/// The two states a category actually wants both exist: walls stop it, or `occlude = FALSE` and
/// walls do not apply (the river). If one ever wants the third, it is a `category.leak` flag
/// evaluated AFTER the runner-up fails, so a clear source always wins. Wait for a category to ask.
///
/// The nearest source of a category that is not behind a wall: the winner where it is clear, the
/// walk's runner-up where the winner is blocked and the runner-up is not, and null where both are.
/// Null silences the category, which is the point — a wall stops the sound rather than dulling it.
/datum/controller/subsystem/point_ambience/proc/unoccluded_source(atom/nearest, datum/point_ambience_category/category)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/atom)
	// source_occluded()'s guards and trace are for the Here verb; the walk itself stays shared.
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
	// On the listener's own turf, or a floor away: nothing can stand between, so it is served.
	if(runner_turf == serving_turf || runner_turf.z != serving_turf.z)
		runner_up_served++
		return runner_up
	if(grade_from_listener(runner_turf, category.range) == OCCLUSION_SOLID)
		runner_up_silenced++
		return null
	runner_up_served++
	return runner_up

/// Grades one line from the listener, folds its cost into the service and sets the corner muffle,
/// so the winner and the runner-up are held to one rule.
/datum/controller/subsystem/point_ambience/proc/grade_from_listener(turf/source_turf, range)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	. = sound_occlusion_grade(serving_turf, source_turf, range, FALSE)
	// Counted before another walk overwrites what this one cost.
	count_occlusion_walk()
	if(. == OCCLUSION_MUFFLED)
		occlusion_corners++
		serving_muffle_wall = TRUE

/// The client's send state for one category, allocated once per client per category like the
/// sound datum beside it. The slim send inlines this; the rare paths call it.
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
 * falloff range, pitch) is written when the source changes and left alone on an update, a send being
 * a snapshot that nothing else writes; everything the LISTENER's position decides is per send.
 *
 * playsound_local is the specification and this is a hand-maintained mirror of it: change one and
 * the other has to change with it, field for field. Nothing in the repo checks that. The Send Diff
 * verb does, and it is one of the measurement verbs kept out of git.
 *
 * Arguments:
 * * fresh - the winning source changed, so the sound restarts rather than taking SOUND_UPDATE
 * * had_previous - this category was already playing, which decides whether a failed send has to
 *   silence it
 * * dry_run - fill the datum and return what it would send, without sending
 */
/datum/controller/subsystem/point_ambience/proc/slim_send(mob/listener, client/listener_client, datum/point_ambience_category/category, atom/nearest, fresh, had_previous, dry_run)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/index = category.index
	var/list/slots = listener_client.point_ambience_slots
	if(length(slots) < index)
		slots.len = index
	var/list/slot = slots[index]
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
	// Re-read on EVERY send, not only when the winning atom changes: a dragged corpse or a changed
	// override keeps the same atom, and the slot would serve it from the tile it left
	slot[POINT_AMBIENCE_SLOT_TURF] = source_turfs[nearest] || get_turf(nearest)
	slot[POINT_AMBIENCE_SLOT_VOLUME] = category.source_volumes[nearest] || category.volume
	slot[POINT_AMBIENCE_SLOT_CONTINUOUS] = category.source_continuous[nearest]
	slot[POINT_AMBIENCE_SLOT_VERSION] = static_version
	if(fresh)
		// A CHANGE OF SOURCE IS NOT A RESTART: two braziers share a file, and passing between them
		// restarted playback. Clip sets are excluded, their file being a fresh pick() each time.
		var/loaded = slot[POINT_AMBIENCE_SLOT_FILE]
		var/file = category.files ? loaded : (category.source_sounds[nearest] || category.sound_file)
		if(!had_previous || file != loaded)
			restarting = TRUE
			if(category.files)
				// Never the clip just played, where there is a choice.
				var/list/choices = (length(category.files) > 1) ? (category.files - loaded) : category.files
				file = pick(choices)
			slot[POINT_AMBIENCE_SLOT_FILE] = file
			// One roll per stretch, re-sent on every update: frequency 0 on a SOUND_UPDATE would
			// snap the pitch back to normal mid-loop.
			slot[POINT_AMBIENCE_SLOT_FREQUENCY] = category.vary_pitch ? get_rand_frequency() : 0
			S.file = file
			S.repeat = TRUE
			S.wait = 0
			S.channel = category.channel
			S.falloff = category.range
			S.frequency = slot[POINT_AMBIENCE_SLOT_FREQUENCY]
			// A set of clips is advanced from here: when this one ends the listener is served
			// afresh and picks another. repeat stays on above so a late timer leaves no silence.
			if(category.files && !dry_run)
				if(slot[POINT_AMBIENCE_SLOT_TIMER])
					deltimer(slot[POINT_AMBIENCE_SLOT_TIMER])
				slot[POINT_AMBIENCE_SLOT_TIMER] = addtimer(CALLBACK(src, PROC_REF(advance_clip), listener_client, category), max(SSsounds.get_sound_length(file), 10), TIMER_STOPPABLE)
	var/turf/source_turf = slot[POINT_AMBIENCE_SLOT_TURF]
	if(!source_turf)
		return FALSE
	var/continuous = slot[POINT_AMBIENCE_SLOT_CONTINUOUS]
	var/vol = slot[POINT_AMBIENCE_SLOT_VOLUME]
	// Two floors away is silent, one is muffled. Only ranges under the long band muffle by
	// storey, so the band test stays even though every category is under it today.
	var/storeys = (category.range < SOUND_RANGE_LONG) ? abs(source_turf.z - serving_turf.z) : 0
	if(storeys >= 2)
		return FALSE
	// Muffle is heavier falloff, a quarter off the volume, a dead room and the occlusion echo. A
	// storey away, or a wall with a way round it, reaches this; a wall with no way round is not
	// served at all.
	var/muffled = storeys || serving_muffle_wall || serving_muffle_head
	var/inv_exponent = category.inv_falloff_exponent
	var/environment = serving_environment
	var/list/echo = null
	if(muffled)
		inv_exponent = category.inv_muffled_exponent
		vol *= SOUND_MUFFLE_VOLUME_MULT
		environment = SOUND_MUFFLE_ENVIRONMENT
		echo = storey_echo
	var/dx = source_turf.x - serving_turf.x
	var/dy = source_turf.y - serving_turf.y
	// Through a local, never an expression: the macro names its first argument three times, so
	// handing it a sqrt would compute that sqrt twice.
	var/distance = sqrt(dx * dx + dy * dy)
	distance = STOREY_ADJUSTED_DISTANCE(distance, storeys)
	// Clamped to vol so a category whose floor sits above a quiet source cannot subtract a negative
	// and get LOUDER with distance.
	var/volume_floor = min(category.min_volume, vol)
	// CALCULATE_SOUND_VOLUME_RATIO with the exponent's reciprocal read rather than divided
	// per send. The same arithmetic otherwise, which the diff verb holds it to.
	var/volume = vol - ((max(distance - SOUND_DEFAULT_FALLOFF_DISTANCE, 0) / (max(category.range, distance) - SOUND_DEFAULT_FALLOFF_DISTANCE)) ** inv_exponent) * (vol - volume_floor)
	var/pan_x = 0
	var/pan_z = 0
	// A continuous run does not pan: at a handoff the two voices are equidistant on opposite sides,
	// so the stereo image would flip. Volume is continuous across that moment; direction is not.
	if(!continuous)
		// Pan from the listener's turf with the one-tile dead zone, then the depth floor that
		// keeps a sideways source out of one ear: only the angle changes, not the magnitude.
		pan_x = (dx <= 1 && dx >= -1) ? 0 : dx
		pan_z = (dy <= 1 && dy >= -1) ? 0 : dy
		if(pan_x && SOUND_PAN_MIN_DEPTH)
			var/min_depth = abs(pan_x) * SOUND_PAN_MIN_DEPTH
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
	if(volume <= 0 || volume < send_cutoff)
		return FALSE
	// Already playing at this volume, and a continuous run has no pan to have changed either, so
	// there is nothing to tell the client.
	if(continuous && had_previous && slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] == volume)
		return volume
	// Status 0 restarts the file and the block above already decided that; both must give the SAME
	// answer, since a rewritten file with SOUND_UPDATE is half a restart either way.
	S.status = restarting ? 0 : SOUND_UPDATE
	S.environment = environment
	S.x = pan_x
	S.z = pan_z
	S.y = source_turf.z - serving_turf.z
	S.echo = echo
	S.volume = volume
	if(!dry_run)
		SEND_SOUND(listener, S)
		slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = volume
	return volume

/// How many sources a walk from a turf would rank, and per category name when a list is given.
/// Counts what the cells the walk probes hold, without ranking any of it. For the verbs.
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

/// Attaches the move hook to every mob a player is in, now and on every future login. Moving
/// listeners are served by the hook; the tick covers the ones standing still and sources that
/// change state beside them.
/datum/controller/subsystem/point_ambience/proc/hook_logins()
	PRIVATE_PROC(TRUE)
	hooked_logins = TRUE
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGIN, PROC_REF(player_login))
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGOUT, PROC_REF(player_logout))
	for(var/client/listener_client as anything in GLOB.clients)
		if(listener_client.mob)
			player_login(null, listener_client.mob)

/// Observers get no ambience: whatever the client was hearing stops here, on the transition
/// itself, and no move hook is attached to the ghost.
/datum/controller/subsystem/point_ambience/proc/player_login(datum/source, mob/player)
	SIGNAL_HANDLER
	if(isobserver(player))
		stop_all_for(player.client)
		return
	if(player.client)
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
	listener_client.point_ambience_silenced = prefs && ((prefs.toggles & SOUND_DISABLE_POINT_AMBIENCE) || !prefs.pointambiencevol || !prefs.overallvol)
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
/// fresh. Leaving the cache would let a stationary listener take the shortcut and stay silent.
/datum/controller/subsystem/point_ambience/proc/stop_all_for(client/listener_client)
	PRIVATE_PROC(TRUE)
	if(!listener_client)
		return
	for(var/datum/point_ambience_category/category as anything in categories)
		if(listener_client.point_ambience_sources[category])
			stop_for(listener_client, category)
	// The cached turf goes too, or a listener who was standing still is silenced until they walk:
	// their turf and version still match, so the next service returns before the send loop.
	listener_client.point_ambience_cache_turf = null

/datum/controller/subsystem/point_ambience/proc/player_logout(datum/source, mob/player)
	SIGNAL_HANDLER
	UnregisterSignal(player, list(COMSIG_MOVABLE_MOVED, COMSIG_SPECIES_GAIN, COMSIG_SPECIES_LOSS))
	// The set is deliberately not touched here. BYOND has already taken the client off the mob by
	// the time this fires, and a client that merely changed mobs is still owed a service; a client
	// that truly left leaves a null key, which drain_dirty() drops on its way past.

/**
 * Marks a listener for a service after something the move hook cannot see: their ear moved, or what
 * carries it did. Drops the standing cache too, or the walk would shortcut straight past the change.
 */
/datum/controller/subsystem/point_ambience/proc/mark_listener(client/listener_client)
	if(!listener_client || mode != POINT_AMBIENCE_LIVE || listener_client.point_ambience_silenced)
		return
	listener_client.point_ambience_cache_turf = null
	if(use_queue && !dirty_clients[listener_client])
		dirty_clients[listener_client] = world.time

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

/// Requests source discovery and positional updates on eligible steps, normally through the queue.
/// The interval can skip moves; the periodic client walk catches a skipped final step. Discovery
/// must include new sources, since refreshing only those already heard delays entry into range.
/datum/controller/subsystem/point_ambience/proc/on_moved(atom/movable/mover)
	SIGNAL_HANDLER
	// Before every early return: the survey counts steps taken, which is what a service is billed by.
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
	if(move_service_interval && world.time < listener_client.point_ambience_next_service)
		return
	// Two rails, for the inline path only: under the queue the drain applies the budget and runs in
	// the tick's slack. TICK_USAGE bounds the peak tick, rising with what a service actually costs
	// and with whatever else is loading the tick, which is the tick a crowd makes; the count bounds
	// the second, which tick usage alone does not. Both sit AFTER the interval gate, so a move it was
	// dropping anyway never spends the budget, and BEFORE the stamp, so a refused step does not also
	// spend the client's interval: they retry next move and fire() catches them within a second.
	// TICK_CHECK_LOW rather than the MC limit, since this runs inside Move(). And Move() runs in the
	// verb slot at the END of the tick, after the MC, gc and SendMaps have spent their share, so the
	// usage read here is already high whenever the server is busy at all: on a loaded server this
	// path refuses most steps. That is why the queue is the default and this is the fallback.
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
		// takes hold from the following step rather than retroactively.
		var/interval = (move_service_interval_running_override && listener.m_intent == MOVE_INTENT_RUN) ? move_service_interval_running_override : move_service_interval
		listener_client.point_ambience_next_service = world.time + interval
	if(use_queue)
		// Idempotent: a client already marked keeps its place, so ten steps in a tick are one entry
		// and nobody moves up the set by moving more. The stamp is the wait the survey reports.
		if(!dirty_clients[listener_client])
			dirty_clients[listener_client] = world.time
		return
	// Timed in place when a survey runs.
	move_services++
	listener_client.point_ambience_last_service = world.time
	if(GLOB.point_ambience_survey)
		GLOB.point_ambience_survey.time_real_service(listener_client)
		return
	service_client(listener_client)

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

/// Nearest active source per category, audible from the turf: own floor first, then one storey
/// either way at 2D distance, matching how playsound_local measures before its storey cap.
/// Returns category -> source, and leaves the nearest STATIC source per category in the
/// client's cache for the standing-listener path. Own floor wins outright, so a storey pass
/// only looks for categories with no own-floor answer, and only on a floor that has sources of
/// such a category at all.
/datum/controller/subsystem/point_ambience/proc/nearest_sources(turf/listener_turf, client/listener_client)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/list)
	var/z = listener_turf.z
	var/list/best_distsq = scratch_best_distsq
	best_distsq.Cut()
	// Ranked straight into the list the client keeps, so a walk allocates nothing.
	var/list/best = listener_client.point_ambience_cache_static
	if(best)
		best.Cut()
	else
		best = list()
	if(!use_cell_cache)
		collect_nearest_on_z(listener_turf.x, listener_turf.y, z, best, best_distsq)
	else
		// The SAME expression register_source() keys a bucket with, + 1 included. That + 1 also keeps
		// it non-zero, since the cell index starts null and DM compares null equal to 0.
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
			// a category unanswered, so most cells never ask for these.
			listener_client.point_ambience_cell_above = null
			listener_client.point_ambience_cell_below = null
		rank_candidates(listener_turf.x, listener_turf.y, listener_client.point_ambience_cell_candidates, best, best_distsq)

	if(cross_floor && length(best) < answerable_categories)
		// A snapshot, taken before the storey passes so an own-floor answer cannot be replaced by one
		// a storey away, while a category answered only above can still lose to a nearer one below.
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

/// Whether a storey pass on z can change anything: some category not in skip has sources there.
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
/// the categories the own floor already answered, so a floor a storey away only fills gaps.
/datum/controller/subsystem/point_ambience/proc/collect_nearest_on_z(x, y, z, list/best, list/best_distsq, list/skip)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/gathered = scratch_uncached
	gathered.Cut()
	gather_buckets(x - max_range, x + max_range, y - max_range, y + max_range, z, gathered)
	rank_candidates(x, y, gathered, best, best_distsq, skip)

/// Appends every quad in the buckets whose cells the box touches, straight out of the buckets as
/// they are stored: one native append per bucket, no lookups.
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

/// Ranks a flattened candidate list exactly as collect_nearest_on_z ranks a bucket, same order and
/// same gates, so a storey pass reaches the same answer either way. Both read the same quads; the
/// only difference is that this one was handed them and does not have to find the buckets first.
/datum/controller/subsystem/point_ambience/proc/rank_candidates(x, y, list/candidates, list/best, list/best_distsq, list/skip)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/count = length(candidates)
	for(var/i = 1, i <= count, i += 4)
		// EUCLIDEAN, unlike playsound()'s chebyshev get_dist: a square admits corners past the
		// falloff's range, which pin at min volume and hold the channel inaudibly.
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
			// range reach here, a handful a service.
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
	/// The name a SILENCE_POINT_AMBIENCE line in config.txt names this category by.
	var/config_name
	var/sound_file
	/// A set of short clips to draw from instead of sound_file, advanced per listener: when the
	/// clip a listener is hearing runs out they are served afresh and pick another, never the one
	/// just played. For a sound whose files are a few seconds each, which native-repeated one at a
	/// time is one clip forever. Swapped whole by set_category_files.
	var/list/files
	var/volume = 100
	/// Volume this category fades TO at its range edge, and what a range tail holds it at. Per
	/// category because audibility is a property of the SOUND, not of the number: a clock's ticks
	/// carry at 3 where a torch's crackle at 3 is inaudible, and ERP audio is clear at 1 where no
	/// ambient loop is. Tune by ear against the category's own file; there is no rule to derive it
	/// from, and volume is not it either, since misc at 100 and clock at 10 both fade to something
	/// you can just hear rather than to a fraction of themselves.
	var/min_volume = SOUND_DEFAULT_MIN_VOLUME
	var/range = 5
	/// range squared. The walk gates on squared distance, so this is the comparison it makes.
	var/range_sq = 0
	var/channel
	/// Roll a random pitch per stretch, like the old loops' vary flag.
	var/vary_pitch = FALSE
	/// Whether sources of this category get a plain loop in fallback mode. Torches do not:
	/// hundreds of them on timers is the load that got torch crackle disabled in the first place.
	var/fallback = TRUE
	/// source -> its own file and volume, where it wants something other than the category's.
	/// A category is a channel and a slot, not necessarily one sound, so things that share
	/// neither theme nor loudness can still share one. Range stays per-category, since it is
	/// the per-source gate the shared walk filters on.
	var/list/source_sounds = list()
	var/list/source_volumes = list()
	/// source -> TRUE where the source is one voice of something long rather than a thing at a point.
	/// A river's nearest voice keeps changing as you walk, so the sound must NOT restart on a handoff
	/// and must NOT pan, the two voices being equidistant on opposite sides at that moment. Falloff
	/// still applies, so the run swells as you approach.
	var/list/source_continuous = list()
	/// Position in categories, the index into each client's per-category sound datums. Set on New().
	var/index = 0
	/// The falloff curve. Left at 0, it is the band for this range, resolved once on New() and the
	/// same answer playsound_local computes per send. A category can set its own instead
	var/falloff_exponent = 0
	/// 1 / falloff_exponent, so a send reads it rather than dividing.
	var/inv_falloff_exponent = 0
	/// The same for a muffled send, which uses a shallower curve. Cached beside it because muffling
	/// is no longer rare: every source heard round a corner takes this path.
	var/inv_muffled_exponent = 0
	/// The null sound that stops this category's channel, built once and sent as is.
	var/sound/stop_sound
	/// This category makes NO sound at all and its sources are kept out of the index. Set from
	/// SILENCE_POINT_AMBIENCE at the first fire() only, since de-indexing hundreds of sources is a
	/// bulk operation that must not land on a running server.
	var/silenced = FALSE
	/// Whether a wall between listener and source silences this category. Off for anything whose
	/// sources are one long thing rather than a point: consecutive voices of a line sit close enough
	/// that one rock face takes both, so the whole run goes quiet from a spot where plenty of it is
	/// in the open. It is also the dearest check on the map, the widest range walking furthest.
	var/occlude = TRUE

/datum/point_ambience_category/fire
	config_name = "fire"
	sound_file = 'sound/misc/fire_place.ogg'
	volume = 60
	range = 6
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED.
	min_volume = 8
	channel = CHANNEL_FIRE_AMBIENCE
	vary_pitch = TRUE

/**
 * Bone piles, evil trees and goblin portals.
 *
 * Supernatural landmarks meant to be felt before they are seen, hence the long range and full
 * volume; only a handful are mapped, so they never crowd each other.
 *
 * A category is ONE voice: flies and clocks on this one muted each other, and RANGE, the one
 * property that is per-category, is why they are separate categories rather than overrides.
 */
/datum/point_ambience_category/misc
	config_name = "misc"
	sound_file = 'sound/vo/mobs/ghost/skullpile_loop.ogg'
	volume = 100
	range = 6
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED.
	min_volume = 8
	channel = CHANNEL_MISC_AMBIENCE

/// Flies on a rotting body. Short range on purpose: a fly cloud is an intimate sound, tighter than
/// the four tiles a hand-held torch carries, and at misc's six you heard a corpse two rooms away.
/// Corpses are the one source here that turns up ANYWHERE, indoors included, and there is no fixed
/// count of them: it scales with how much dying happens.
/datum/point_ambience_category/rot
	config_name = "rot"
	sound_file = 'sound/misc/fliesloop.ogg'
	volume = 50
	range = 3
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED.
	min_volume = 8
	channel = CHANNEL_ROT_AMBIENCE

/// Grandfather and wall clocks. Volume 10 over 4 tiles, matching the loop this replaced; at misc's
/// 6 a manor's clocks reached each other.
/datum/point_ambience_category/clock
	config_name = "clock"
	sound_file = 'sound/misc/clockloop.ogg'
	volume = 10
	range = 4
	/// The one floor with a confirmed reading behind it: a clock at 3.5 is audible in play. Ticks are
	/// transients with a sharp attack and carry far lower than the crackles and hiss below.
	min_volume = 3
	channel = CHANNEL_CLOCK_AMBIENCE

/// Fountains and wells. The waterwheel rode this briefly and came back out: it never had a sound to
/// restore, and a fountain nearer than the wheel silenced it. Rivers split off for the same reason
/// plus a longer range; see /river below.
///
/// SEVEN COSTS NOTHING. max_range is the largest range of any category and it sizes the walk's box
/// for every service on the map, so this is free at anything up to the river's eight and would be
/// paid by everyone above it. It buys audible tiles rather than a gentler ending: the curve is
/// proportional to range, so raising it stretches the same shape and the last tile still drops from
/// about eleven to the floor. That last step is the exponent's, not this one's.
/datum/point_ambience_category/water
	config_name = "water"
	sound_file = 'sound/misc/waterloop.ogg'
	volume = 35
	range = 7
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED, and the
	/// one most reported as cutting out, so this is the first to raise if 8 is not enough.
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
 * file looped; SSnightshift swaps the set between day and night.
 */
/datum/point_ambience_category/river
	config_name = "river"
	sound_file = 'sound/ambience/riverday (1).ogg'
	files = AMB_RIVERDAY
	volume = 55
	range = 8
	/// The old curve, kept on purpose. The steeper band suits something walked past, and a river is
	/// a bed of sound stood beside: at 1 it fell away within a few tiles of the bank
	falloff_exponent = 0.5
	/// Sustained and broadband like the torch, so it starts where the torch does. UNTESTED.
	min_volume = 8
	channel = CHANNEL_RIVER_AMBIENCE
	occlude = FALSE

/// Wall sconces and standing fires. A handheld torch is heard by its carrier alone, off the index.
/datum/point_ambience_category/torch
	config_name = "torch"
	fallback = FALSE
	sound_file = 'sound/items/torchloop.ogg'
	volume = 30
	range = 4
	/**
	 * UNTESTED, and a bisection rather than a reading: 3 is confirmed inaudible here and the 14.8
	 * the old 0.5 curve gave at three tiles is confirmed audible, so start between them. A crackle is
	 * broadband and needs far more level than the clock's ticks to register at all
	 */
	min_volume = 8
	channel = CHANNEL_TORCH_AMBIENCE
	vary_pitch = TRUE

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
	var/old_mode = mode
	mode = new_mode
	if(old_mode == POINT_AMBIENCE_LIVE)
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
/// the live path would. Cannot native-repeat without a token, so it replays every file length.
/datum/looping_sound/point_ambience_fallback

/// Gives one source its fallback loop, if its category takes one and it has none already.
/datum/controller/subsystem/point_ambience/proc/start_fallback(atom/source)
	PRIVATE_PROC(TRUE)
	var/datum/point_ambience_category/category = source_categories[source]
	if(!category?.fallback || fallback_loops[source])
		return
	// A category with a set of clips gets one of them; the plain loop cannot advance through a set.
	var/sound_file = category.source_sounds[source] || (category.files ? pick(category.files) : category.sound_file)
	var/datum/looping_sound/point_ambience_fallback/loop = new(source)
	loop.mid_sounds = sound_file
	loop.volume = category.source_volumes[source] || category.volume
	loop.vary = category.vary_pitch
	// playsound's reach is SOUND_RANGE + extra_range.
	loop.extra_range = category.range - SOUND_RANGE
	loop.mid_length = SSsounds.get_sound_length(sound_file) || 35
	fallback_loops[source] = loop
	loop.start()

/// Ends and forgets one source's fallback loop.
/datum/controller/subsystem/point_ambience/proc/stop_fallback(atom/source)
	PRIVATE_PROC(TRUE)
	var/datum/looping_sound/loop = fallback_loops[source]
	if(!loop)
		return
	fallback_loops -= source
	qdel(loop)

#undef CELL_SHIFT


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
