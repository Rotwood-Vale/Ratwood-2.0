/// 8-tile cells. The walk probes every cell within max_range, three per axis at max_range 8, so
/// nine cells covering 576 tiles. The trade is probes against sources ranked and ranking is dearer:
/// 16-tile cells probe four but cover 1024, nearly twice the sources read and rejected to save five
/// list reads. 4-tile cells invert it, 400 tiles for 25 probes.
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
 * Runs on every step (the move hook) and every fire(). It reads a fixed box, the listener's cell
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
 * overrides give a source its own audio without a new category, which costs a reserved channel (only
 * 1016 is left) and ~9 to 11 us per service while audible.
 *
 * ## Cost
 *
 * Billed per service, and a service per player MOVEMENT; source count barely enters it, the box
 * being fixed and one source per category served. Measured: ~1100 sources in for +7%, back out for
 * -8%. 35% of services find nothing and still pay, and fixed overhead is 75 to 85% of a service, so
 * the only real lever is FEWER services. move_service_interval removes 49% at the shipped 5 and 78%
 * at 10, paid for in spatial resolution. MODES are the bigger hammer: FALLBACK gives every source a
 * plain timer loop instead, billed per source, volume only on replay, torches silent; OFF is silent.
 * The Point Ambience Mode verb switches live, config seeds at boot.
 *
 * ## Not here
 *
 * Gameplay-gated loops (boiling, relics, spell charges) are tokens and cost nothing idle; music
 * restarts on a source handoff; boat bells alternate two files and cannot native-repeat.
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
	/// Also the catch-up for a move that move_service_interval dropped. A gated move returns without
	/// servicing and schedules nothing, so if the gated step is a listener's LAST one nothing serves
	/// them until this fires, and this IS the worst-case silence on stopping at the edge of a range.
	///
	/// It is the only thing here that scales with population rather than movement, at
	/// `players / wait * 2.2 us`: at 150 that is 0.22 ms/s at 1.5 seconds, 0.33 at this 1, 0.66 at
	/// 0.5. Chosen by ear against that, a third off the worst case for a tenth of a millisecond.
	wait = 1 SECONDS
	flags = SS_BACKGROUND | SS_NO_INIT

	var/list/datum/point_ambience_category/categories = list()
	/// category typepath -> its singleton, the form register/unregister callers use.
	var/list/categories_by_path = list()
	var/list/currentrun = list()

	/// Off makes every walk probe the buckets directly instead of ranking the client's cached
	/// per-cell candidate list, so the Here verb can time both on ONE tile. Keep the switch: deleting
	/// it along with the cache it measures once hid a 5x error in the cost of a bucket probe.
	var/use_cell_cache = TRUE
	/// Positional, never string keyed: buckets_by_z[z] is a list indexed by cell, where a cell is
	/// (x >> CELL_SHIFT) * cell_stride + (y >> CELL_SHIFT) + 1, and each entry is a flat list of
	/// x, y, category index, source per active source in that cell, or null. The walk reads a
	/// source's position and kind straight out of the bucket, so rejecting one is two list reads
	/// and arithmetic and never a lookup; the lookups happen once, when the source registers.
	var/list/buckets_by_z = list()
	/// Moves per second per player, measured by the Survey verb and kept after it stops. Zero until
	/// one has run, and the verbs then fall back to 1.38; three surveys put that guess within a few
	/// percent.
	var/measured_moves_per_player = 0
	/// Microseconds per service when services arrive many per tick, as a populated server's do, from
	/// the Benchmark verb. Zero until one has run. The survey instead times ONE player whose services
	/// are seconds apart, the coldest case there is, and reads about a third high.
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
	/// OFF by design decision, not for cost: Hug does not want ambience carrying between floors.
	/// It is also the single largest cost in the walk, because the storey passes run whenever the
	/// own floor leaves a category unanswered and an inaudible tile answers none: measured at two
	/// town tiles, 48% and 82% of every candidate ranked was on a floor the listener was not on.
	/// The machinery below stays in place behind this so turning it back on is one var.
	var/cross_floor = FALSE
	/// Whether a wall or closed door between listener and source muffles it. Off restores the
	/// behaviour every measurement before 2026-09-04 was taken under, where a hearth six tiles away
	/// through a keep wall sounded exactly like one six tiles away in the open. Costs one can_see()
	/// per send, so switching it off is also how to price it.
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
	/// The SECOND nearest source per category from the walk that just ran, and its distance. Without
	/// somewhere to fall through to, one wall mutes a whole category while another of its sources
	/// stands in the open four tiles away. Valid only between the walk and the sends of the SAME
	/// service, so deliberately not on the client and not in the cache.
	var/list/scratch_second = list()
	var/list/scratch_second_distsq = list()
	/// The listener a service is for, resolved once per service and read by every send in it:
	/// their turf, the environment their area gives a sound, their master volume as a factor
	/// (null when they have no prefs), and whether the slim send may serve them at all. A
	/// dullahan hears from the head, which the slim send does not model, so they take the full
	/// playsound_local path. Only while HEADLESS: with the head on, playsound_local resolves the
	/// listener back to the mob and the two paths agree.
	var/turf/serving_turf
	var/serving_environment = SOUND_DEFAULT_ENVIRONMENT
	var/serving_volume_scale
	var/serving_slim = FALSE
	/// Set per category while it is being resolved, when exactly ONE wall stands between listener and
	/// source. Read by the send that follows immediately, and cleared at the top of every category so
	/// one category's wall cannot muffle the next one's source.
	var/serving_muffle_wall = FALSE
	/// Sends made by the service running right now, reset at the top of each one, read by the survey
	/// beside every timing. Two tiles with the same candidate count but different audible categories
	/// differ by about a send each, so a cost figure without this cannot be compared to another's.
	var/sends_this_service = 0
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
	var/occlusion_checks_total = 0
	/// Cumulative CORNER verdicts, which the counters above never see because a corner is served
	/// muffled rather than blocked. It prices what the walk gives up for them: opacity_between now
	/// remembers a corner and runs the line to its end rather than returning on the first one, so a
	/// wall further along still wins, and this is how often that longer walk is paid for.
	var/occlusion_corners = 0
	/// The echo array a storey-muffled send carries, built once and never written after, so one
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
	. = ..()
	for(var/category_path in subtypesof(/datum/point_ambience_category))
		var/datum/point_ambience_category/category = new category_path
		categories += category
		category.index = length(categories)
		categories_by_path[category_path] = category
		max_range = max(max_range, category.range)
		max_range_sq = max_range * max_range
		category.range_sq = category.range * category.range
		category.falloff_exponent = sound_falloff_for_range(category.range)
		category.inv_falloff_exponent = 1 / category.falloff_exponent
		category.inv_muffled_exponent = 1 / (category.falloff_exponent * SOUND_MUFFLE_EXPONENT_MULT)
		category.stop_sound = sound(null, channel = category.channel)
	self_category = categories_by_path[/datum/point_ambience_category/torch]
	storey_echo = new /list(18)
	storey_echo[7] = SOUND_MUFFLE_OCCLUSION
	storey_echo[8] = SOUND_MUFFLE_OCCLUSION_LF

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
	buckets_by_z = SSpoint_ambience.buckets_by_z
	cell_stride = SSpoint_ambience.cell_stride
	source_keys = SSpoint_ambience.source_keys
	source_turfs = SSpoint_ambience.source_turfs
	mode = SSpoint_ambience.mode
	move_service_interval = SSpoint_ambience.move_service_interval
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
 * A SILENCED category is refused outright rather than merely skipped at send time, because ranking
 * sources for an answer that cannot exist is still work: silencing torch the other way left the walk
 * rejecting 1112 sconces, 0.92 of the 2.64 ms/s the category costs at 150 players. The unregister on
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
	if(volume_override && category.source_volumes[source] != volume_override)
		category.source_volumes[source] = volume_override
		static_version++
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
	if(mode == POINT_AMBIENCE_FALLBACK)
		start_fallback(source)

/// Whether any source of a category already sits within radius of a turf. Walks the same buckets
/// the listener walk does, exiting on the first hit. Used at mapload to space a run's voices, so
/// the cost is one small walk per candidate turf, once, and never during play.
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

/// Swaps the set of clips a category draws from. Nobody is restarted: each listener's next clip
/// boundary picks from the new set, so a change of time of day lands where a seam already was.
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
	source_keys -= source
	source_zs -= source
	source_turfs -= source
	source_categories -= source
	stop_fallback(source)
	decrement_source_count(category)
	category.source_sounds -= source
	category.source_volumes -= source
	category.source_continuous -= source
	// The channel is the stop handle the old loops never had: a snuffed source goes silent now, not
	// when its replay runs out. One client walk per deactivation.
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
		move_service_interval = CONFIG_GET(number/point_ambience_move_interval)
		move_service_interval_running_override = CONFIG_GET(number/point_ambience_move_interval_running_override)
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
	if(!resumed)
		currentrun = GLOB.clients.Copy()
	while(length(currentrun))
		var/client/listener_client = currentrun[currentrun.len]
		currentrun.len--
		if(listener_client && !isobserver(listener_client.mob))
			service_client(listener_client)
		if(MC_TICK_CHECK)
			return

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
	// Before anything is counted, since a listener who turned this off is not being served and should
	// not appear in the rates. What they had playing was silenced when they set it, by
	// listener_prefs_changed; nothing here can reach them again to do it.
	var/toggles = listener_client.prefs?.toggles
	if(toggles & SOUND_DISABLE_POINT_AMBIENCE)
		return
	services_total++
	sends_this_service = 0
	rebuilt_this_service = FALSE
	occlusion_checks_this_service = 0
	occlusion_tiles_this_service = 0
	// Per SERVICE, not per walk: a standing listener reaching the send loop without walking would
	// otherwise get a runner-up from another turf, and possibly another client.
	scratch_second.Cut()
	scratch_second_distsq.Cut()
	var/mob/listener = listener_client.mob
	var/turf/listener_turf
	// Observers are skipped by the tick and silenced at login; this catches any that arrive
	// another way.
	if(listener && !isnewplayer(listener) && !isobserver(listener) && prepare_serving(listener_client, listener))
		listener_turf = serving_turf
	// The mob's own lit torch, served ahead of whatever the walk found for that category.
	var/atom/self_source = listener_turf ? listener.point_ambience_self_source : null
	// Same turf, same index version, same master volume: the answer cannot have changed. Everything
	// else is a full walk.
	var/list/nearest_by_category
	var/standing = FALSE
	if(listener_turf)
		var/mastervol = listener_client.prefs?.mastervol
		if(listener_turf == listener_client.point_ambience_cache_turf \
			&& static_version == listener_client.point_ambience_cache_version \
			&& mastervol == listener_client.point_ambience_cache_mastervol)
			standing = TRUE
			// Every category below would return unchanged, so skip the loop. The torch is checked
			// separately because lighting one bumps no version.
			if(self_source == listener_client.point_ambience_cache_self)
				return
			nearest_by_category = listener_client.point_ambience_cache_static
		else
			nearest_by_category = nearest_sources(listener_turf, listener_client)
			listener_client.point_ambience_cache_turf = listener_turf
			listener_client.point_ambience_cache_version = static_version
			listener_client.point_ambience_cache_mastervol = mastervol
	else
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
		// A continuous source has no single point to hear it from, so a dullahan's head-relative path
		// has nothing to work with. serving_slim first, so the lookup is only paid for a dullahan.
		var/sent
		sends_this_service++
		if(serving_slim || category.source_continuous[nearest])
			sent = slim_send(listener, listener_client, category, nearest, fresh, !!previous, FALSE)
		else
			sent = full_send(listener, listener_client, category, nearest, fresh)
		// Nothing usable was sent, so null whatever was playing or it repeats client-side at a stale
		// volume. Keyed on previous, not fresh: a failed switch must still silence the live source.
		if(!sent)
			stop_for(listener_client, category, send_null = !!previous)

/// Resolves what every send in one service needs from the listener, once. Two answers are dear and
/// cannot change within a tick unnoticed, so they are held on the client for one tick: whether they
/// can hear at all (three user procs and an organ walk on a carbon), and whether the slim send may
/// serve them (a HEADLESS dullahan hears from wherever the head is, which it does not model). Turf,
/// area environment and master volume change on a step and are per service. Returns FALSE when there
/// is nothing to serve, leaving the serving_* vars set otherwise.
/datum/controller/subsystem/point_ambience/proc/prepare_serving(client/listener_client, mob/listener)
	SHOULD_NOT_SLEEP(TRUE)
	if(world.time >= listener_client.point_ambience_profile_until)
		listener_client.point_ambience_profile_until = world.time + wait
		listener_client.point_ambience_hearing = listener.can_hear()
		// HEADLESS, not "is a dullahan": playsound_local only substitutes the head's position when
		// headless, and otherwise resolves back to the mob for the same answer the slim send gives.
		var/slim = TRUE
		var/mob/living/carbon/human/human = listener
		if(istype(human) && human.dna)
			var/datum/species/dullahan/dullahan = human.dna.species
			if(istype(dullahan) && dullahan.headless)
				slim = FALSE
		listener_client.point_ambience_slim = slim
	if(!listener_client.point_ambience_hearing)
		return FALSE
	// Checked here so nothing below works for a muted listener. ZERO only, never "low", and null is
	// not zero: no prefs means no scaling rather than silence.
	var/volume_scale = listener_client.prefs ? listener_client.prefs.mastervol * 0.01 : null
	if(volume_scale == 0)
		return FALSE
	var/turf/listener_turf = get_turf(listener)
	if(!listener_turf)
		return FALSE
	serving_turf = listener_turf
	serving_slim = listener_client.point_ambience_slim
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
	if(serving_slim || category.source_continuous[nearest])
		return slim_send(listener, listener_client, category, nearest, fresh, had_previous, dry_run)
	if(dry_run)
		return null
	return full_send(listener, listener_client, category, nearest, fresh)

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
/// however many probes it needed. The probes used to count themselves, which they cannot now they
/// are plain procs shared with the token and one-shot paths.
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
	// Straight to opacity_between(), since source_occluded()'s guards and trace exist for the Here
	// verb. One duplicated condition, not the walk, which stays shared.
	if(!category.occlude)
		return nearest
	var/turf/source_turf = source_turfs[nearest] || get_turf(nearest)
	if(!source_turf || source_turf == serving_turf || source_turf.z != serving_turf.z)
		return nearest
	var/blocked = sound_occlusion_grade(serving_turf, source_turf, category.range, FALSE)
	// Counted immediately, before another walk overwrites what it cost. Without the tile count the
	// survey cannot price occlusion at all.
	count_occlusion_walk()
	if(blocked == OCCLUSION_CLEAR)
		return nearest
	if(blocked == OCCLUSION_MUFFLED)
		occlusion_corners++
		serving_muffle_wall = TRUE
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
	// The same grading as the winner above, or the fall-through would hold a source to a stricter
	// rule than the source it replaced.
	var/runner_blocked = sound_occlusion_grade(serving_turf, runner_turf, category.range, FALSE)
	count_occlusion_walk()
	if(runner_blocked == OCCLUSION_SOLID)
		runner_up_silenced++
		return null
	if(runner_blocked == OCCLUSION_MUFFLED)
		occlusion_corners++
		serving_muffle_wall = TRUE
	runner_up_served++
	return runner_up


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
 * playsound_local itself, for the listener the slim send cannot serve.
 *
 * That is a HEADLESS dullahan, who hears from wherever the head is. Rare, so it looks its source up
 * every time.
 *
 * It selects from the BODY and prices from the HEAD, which disagree: the walk finds sources near the
 * body, then playsound_local measures them from the head. Carry the head further than the category's
 * range from the body and everything selected prices out of range, so they hear nothing. Fixing that
 * means moving serving_turf to the head so both halves agree.
 *
 * Arguments:
 * * fresh - the winning source changed, so the sound restarts rather than taking SOUND_UPDATE
 */
/datum/controller/subsystem/point_ambience/proc/full_send(mob/listener, client/listener_client, datum/point_ambience_category/category, atom/nearest, fresh)
	PRIVATE_PROC(TRUE)
	var/turf/source_turf = source_turfs[nearest] || get_turf(nearest)
	if(!source_turf)
		return FALSE
	var/list/slot = slot_for(listener_client, category.index)
	if(fresh)
		slot[POINT_AMBIENCE_SLOT_FILE] = category.files ? pick(category.files) : (category.source_sounds[nearest] || category.sound_file)
		// One roll per stretch, re-sent on every update: frequency 0 on a SOUND_UPDATE would
		// snap the pitch back to normal mid-loop.
		slot[POINT_AMBIENCE_SLOT_FREQUENCY] = category.vary_pitch ? get_rand_frequency() : 0
	var/sound/repeat_sound = sound(slot[POINT_AMBIENCE_SLOT_FILE])
	repeat_sound.repeat = TRUE
	if(!fresh)
		repeat_sound.status = SOUND_UPDATE
	var/vol = category.source_volumes[nearest] || category.volume
	// Storeys it works out itself; a corner verdict is ours and nothing else would carry it. Passing
	// TRUE when it already muffled for storeys changes nothing, the multipliers applying once.
	return listener.playsound_local(source_turf, vol = vol, frequency = slot[POINT_AMBIENCE_SLOT_FREQUENCY], channel = category.channel, S = repeat_sound, max_distance = category.range, muffled = serving_muffle_wall, min_volume = category.min_volume)

/**
 * The ambience send: builds the datum playsound_local would and sends it, without the proc call.
 *
 * Exactly the ambience input shape, a turf source at the category's range with no pitch vary and no
 * ERP class. One datum per client per category is reused. What the SOURCE decides (file, channel,
 * falloff range, pitch) is written when the source changes and left alone on an update, a send being
 * a snapshot that nothing else writes; everything the LISTENER's position decides is per send.
 *
 * playsound_local is the specification, and the Point Ambience Send Diff verb holds this to it field
 * for field. Change one without the other and the verb will say so.
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
	if(fresh)
		// Everything the source decides, resolved once. The get_turf fallback is for the verbs, which
		// send from bare turfs; a registered source is always in source_turfs.
		var/continuous = category.source_continuous[nearest]
		slot[POINT_AMBIENCE_SLOT_TURF] = source_turfs[nearest] || get_turf(nearest)
		slot[POINT_AMBIENCE_SLOT_VOLUME] = category.source_volumes[nearest] || category.volume
		slot[POINT_AMBIENCE_SLOT_CONTINUOUS] = continuous
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
	else if(nearest == listener.point_ambience_self_source)
		// The self source is never indexed, so source_turfs has nothing to re-read and it would stay
		// at the tile it was first served from. It is in their hand, so this service's turf is it.
		slot[POINT_AMBIENCE_SLOT_TURF] = serving_turf
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
	// storey away or ONE wall away reaches it; two walls is enclosed and not served at all.
	var/muffled = storeys || serving_muffle_wall
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
	if(volume <= 0)
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
/// The cells the walk probes, counted rather than ranked. For the verbs.
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
	RegisterSignal(player, COMSIG_MOVABLE_MOVED, PROC_REF(on_moved), override = TRUE)

/// Silences every category for one listener and clears their cached walk, so the next service is
/// fresh. Leaving the cache would let a stationary listener take the shortcut and stay silent.
/**
 * A listener changed their point ambience preferences. Silences their channels and drops their
 * standing cache, so the next service rebuilds whatever they should hear now from nothing.
 *
 * BOTH directions need this, for different reasons. Turning something OFF leaves the sound playing
 * with nothing that will ever service them again to stop it. Turning it back ON leaves their turf
 * and version unchanged, so the standing shortcut returns before the send loop and they stay silent
 * until they happen to walk. That second one has already shipped here once, as a mode switch back to
 * Live that left every stationary player silent.
 */
/datum/controller/subsystem/point_ambience/proc/listener_prefs_changed(client/listener_client)
	stop_all_for(listener_client)

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
	UnregisterSignal(player, COMSIG_MOVABLE_MOVED)

/// A full service on every step, so a source starts the moment its radius is entered and sweeps as
/// the listener closes. A refresh of only the sources already heard was tried first and left
/// discovery to the tick, which at walking speed is slower than crossing a 4 tile radius: the sound
/// started after arrival. The walk is a few bucket lookups, cheaper than the sends.
/datum/controller/subsystem/point_ambience/proc/on_moved(atom/movable/mover)
	SIGNAL_HANDLER
	// Before every early return and the mode check, because the survey wants steps TAKEN: sampling
	// position instead misses corners turned and steps retraced, and this is billed per Move().
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
	if(move_service_interval)
		if(world.time < listener_client.point_ambience_next_service)
			return
		// Read when the next service is scheduled, not when this one is gated, so a change of intent
		// takes hold from the following step rather than retroactively.
		var/interval = (move_service_interval_running_override && listener.m_intent == MOVE_INTENT_RUN) ? move_service_interval_running_override : move_service_interval
		listener_client.point_ambience_next_service = world.time + interval
	// Timed in place when a survey runs: this is THE service a real step causes, in whatever state
	// the tick is actually in. A verb looping it 2000 times reads about 30% low.
	if(GLOB.point_ambience_survey)
		GLOB.point_ambience_survey.time_real_service(listener_client)
		return
	service_client(listener_client)

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

/// Walks the shared buckets once and keeps the nearest source of every category it meets, in best.
/// skip holds the categories the own floor already answered, which is what makes the listener's own
/// floor beat one a storey away rather than merely competing with it.
/datum/controller/subsystem/point_ambience/proc/collect_nearest_on_z(x, y, z, list/best, list/best_distsq, list/skip)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(length(buckets_by_z) < z)
		return
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets)
		return
	var/cells = length(floor_buckets)
	var/by_lo = max(1, y - max_range) >> CELL_SHIFT
	var/by_hi = (y + max_range) >> CELL_SHIFT
	for(var/bx in (max(1, x - max_range) >> CELL_SHIFT) to ((x + max_range) >> CELL_SHIFT))
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
				// EUCLIDEAN, unlike playsound()'s chebyshev get_dist: a square admits corners past
				// the falloff's range, which pin at min volume and hold the channel inaudibly.
				var/dx = bucket[i] - x
				var/dy = bucket[i + 1] - y
				var/distsq = dx * dx + dy * dy
				if(distsq > max_range_sq)
					continue
				var/datum/point_ambience_category/category = categories[bucket[i + 2]]
				if(skip && skip[category])
					continue
				// The exact gate is the CATEGORY's range, so a short-range kind is filtered here.
				if(distsq > category.range_sq)
					continue
				var/atom/source = bucket[i + 3]
				var/existing = best_distsq[category]
				if(isnull(existing) || distsq < existing)
					// Same runner-up bookkeeping as rank_candidates; both accept paths have to feed
					// it or the occlusion fall-through works on one of them and not the other.
					if(!isnull(existing))
						scratch_second_distsq[category] = existing
						scratch_second[category] = best[category]
					best_distsq[category] = distsq
					best[category] = source
				else
					var/runner_up = scratch_second_distsq[category]
					if(isnull(runner_up) || distsq < runner_up)
						scratch_second_distsq[category] = distsq
						scratch_second[category] = source

/**
 * Everything the own-floor walk could reach from anywhere in the caller's CELL.
 *
 * Appended straight out of the buckets, which already hold x, y, category index, source, so this is
 * a native list append per bucket and no lookups at all. That is what makes a rebuild cheap enough
 * to do once per cell instead of probing nine buckets on every step.
 *
 * Bounded by the CELL expanded by max_range, NEVER by the caller's position. The set is kept for
 * every step taken inside the cell, and 8 tiles of walking moves the reach box clean off anything
 * computed from a single tile in it, so sources approached from that side would never be in the
 * list. That shipped once and made sconces and fountains arrive seconds late, and every timing taken
 * that day reported the bug as a speed-up, because dropping sources is fast.
 */
/datum/controller/subsystem/point_ambience/proc/collect_candidates(x, y, z, list/out)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	if(length(buckets_by_z) < z)
		return
	var/list/floor_buckets = buckets_by_z[z]
	if(!floor_buckets)
		return
	var/cells = length(floor_buckets)
	var/cell_min_x = (x >> CELL_SHIFT) << CELL_SHIFT
	var/cell_min_y = (y >> CELL_SHIFT) << CELL_SHIFT
	var/cell_max_x = cell_min_x + (1 << CELL_SHIFT) - 1
	var/cell_max_y = cell_min_y + (1 << CELL_SHIFT) - 1
	var/by_lo = max(1, cell_min_y - max_range) >> CELL_SHIFT
	var/by_hi = (cell_max_y + max_range) >> CELL_SHIFT
	for(var/bx in (max(1, cell_min_x - max_range) >> CELL_SHIFT) to ((cell_max_x + max_range) >> CELL_SHIFT))
		var/row = bx * cell_stride + 1
		for(var/by in by_lo to by_hi)
			var/cell = row + by
			if(cell > cells)
				break
			var/list/bucket = floor_buckets[cell]
			if(bucket)
				out += bucket

/// Ranks a flattened candidate list exactly as collect_nearest_on_z ranks a bucket, same order and
/// same gates, so a storey pass reaches the same answer either way. Both read the same quads; the
/// only difference is that this one was handed them and does not have to find the buckets first.
/datum/controller/subsystem/point_ambience/proc/rank_candidates(x, y, list/candidates, list/best, list/best_distsq, list/skip)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/count = length(candidates)
	for(var/i = 1, i <= count, i += 4)
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
	/// The falloff band for this range, resolved once. The same answer playsound_local would
	/// compute per send from the range.
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
 * Flies and clocks used to ride this. A category is ONE voice, so a body rotting in a room with a
 * clock muted one of them, and ~70 clocks a map muted each other across a manor. RANGE is what
 * forced separate categories rather than overrides, being the one property that is per-category.
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

/// Grandfather and wall clocks, about 70 a map. Volume 10 over 4 tiles restores exactly what the
/// old clockloop had, which reached 4 through an extra_range of -3; riding misc gave them 6 and a
/// reach they never used to have.
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
	/// UNTESTED, and a bisection rather than a reading: 3 is confirmed inaudible here and the 14.8
	/// this curve gives at three tiles is confirmed audible, so start between them. A crackle is
	/// broadband and needs far more level than the clock's ticks to register at all.
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
