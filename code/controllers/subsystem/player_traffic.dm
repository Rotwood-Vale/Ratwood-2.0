#define PLAYER_TRAFFIC_SCHEMA_VERSION 4
#ifdef LOCALTEST
/// Local testing builds collect at any population, so a lone tester sees every record
#define PLAYER_TRAFFIC_MIN_CLIENTS 0
#else
/// Collection runs above this connected count, so the first collecting population is 101
#define PLAYER_TRAFFIC_MIN_CLIENTS 100
#endif
/**
 * As invisible as a ghost or more means not really present on the map: an admin on invisimin, a
 * character still in class selection, a stored werewolf body. Gnoll stealth sits at 28 and stays
 * in, because that is a player genuinely standing there.
 */
#define PLAYER_TRAFFIC_ELIGIBLE(player) (isliving(player) && player.stat != DEAD && player.invisibility < INVISIBILITY_OBSERVER)

/**
 * Player movement telemetry.
 *
 * Records coordinate counts, movement counts, movement endpoints and player deaths so an offline
 * tool can build heat maps, timelapses, death overlays, movement rates and sound coverage
 * comparisons afterwards. Nothing here renders or interprets the samples. Movement is counted as it
 * happens by a call in /mob/living/Moved() and written once per sweep window.
 *
 * Everything written is aggregate and carries no identifying information.
 * Players sharing a tile are merged into one count, movement is totalled per tile or block, and
 * coordinate lists are shuffled in every record.
 *
 * One record per line, fields split by |, times in round relative deciseconds: H header, Z z-level,
 * T state change, S sweep, M movement counts, V movement endpoints, D death, E completion footer.
 *
 * The recorder is off every round until an R_SERVER admin turns it on, and it writes one file in
 * the round log directory. A missing completion footer is what marks a recording as interrupted,
 * so no path is ever copied or renamed.
 */
SUBSYSTEM_DEF(player_traffic)
	name = "Player Movement Telemetry"
	wait = 2 SECONDS
	// SS_NO_TICK_CHECK because the sweep never pauses, so the MC should hold it back a tick rather
	// than start it with too little budget left
	flags = SS_BACKGROUND|SS_NO_INIT|SS_NO_TICK_CHECK
	runlevels = RUNLEVEL_GAME

	/// Set by the admin toggle and cleared on finalization or recorder failure
	var/enabled = FALSE
	/// Blocks further recording after completion, recovery or recorder failure
	var/finalized = FALSE
	/// A recorder error leaves the file incomplete and prevents retries this round
	var/failed = FALSE
	/// One pending error report, stored as text so it retains no exception or movement references
	var/pending_failure
	/// Shared collection gate, sampled at enable and each sweep from the connected client count
	var/collecting = FALSE

	var/log_path
	var/header_written = FALSE
	var/roundend_registered = FALSE

	/// Death time and coordinate to count, drained by the next append
	var/list/pending_deaths = list()
	/// Highest z-level a Z record has described
	var/zlevels_written = 0

	/// world.time the current movement window opened
	var/window_start = 0
	/// Movement events counted this window
	var/window_moves = 0
	/// How many of those were made walking, running or sneaking
	var/walk_moves = 0
	var/run_moves = 0
	var/sneak_moves = 0
	/// Forced moves and ones that skipped tiles or changed level, which a silence gate would not skip
	var/bypass_moves = 0
	/// Repeated Moved() calls from diagonal presses, kept out of the movement totals
	var/diagonal_echoes = 0
	/// Tiles per side of each V endpoint bucket: 1 for exact tiles, 4 for the coverage grid's blocks.
	/// Chosen at each enable, so a window never mixes the two
	var/endpoint_block = 1
	/// Movement events this window per destination bucket, released when the window is written
	var/list/continuous_ends = list()
	var/list/bypass_ends = list()

	var/sweeps_attempted = 0
	var/sweeps_written = 0
	var/samples_recorded = 0
	var/deaths_recorded = 0
	var/bytes_written = 0
	var/population_pauses = 0
	var/admin_gaps = 0

	var/sample_ms_total = 0
	var/encode_ms_total = 0
	var/append_ms_total = 0
	var/append_ms_max = 0
	var/sweep_ms_total = 0
	var/sweep_ms_max = 0

/// Movement events this client made in the current telemetry window, cleared whenever the window is
/// written. Kept on the client so it follows the player through a mob swap
/client/var/tmp/traffic_moves = 0

/**
 * One sweep every two seconds, which closes the movement window that just ended and writes it out.
 *
 * 1. While off, do nothing except report a stored failure once.
 * 2. Queued deaths and any new z-levels start the batch, so every line goes out in one write.
 * 3. At or below the population threshold, close the open window, mark a pause and stop.
 * 4. Back above it after a pause, open a fresh window and mark the resume.
 * 5. For each client, save the finished window's move count and reset it for the next window.
 * 6. Add that count to the histogram, then count the players present on each tile.
 * 7. Shuffle the tile counts into the S line, and write_window() adds the M and V lines.
 * 8. Append the batch in one write, then add each stage's time to the timing totals.
 * 9. Any error goes to abort_recording(), which switches the recorder off for the round.
 *
 * The histogram's position is the move count plus one, since DM lists start at 1:
 * histogram[1] counts the players who made 0 moves
 * histogram[2] counts the players who made 1 move
 * histogram[8] counts the players who made 7 moves
 * It is written as a comma list (like a csv), so 1,0,0,1,0,0,0,1 is one idle player, one who made 3 moves and one
 * who made 7.
 */
/datum/controller/subsystem/player_traffic/fire()
	if(!enabled)
		if(pending_failure)
			report_failure()
		return

	try
		var/sweep_start = TICK_USAGE_REAL
		sweeps_attempted++

		var/connected = length(GLOB.clients)
		var/list/batch = list()
		// Drained before the gate is read, so a death queued just before a pause is never stranded
		drain_deaths(batch)
		// Described before the gate too, so a level added during a pause is named before anything on it
		describe_zlevels(batch)

		if(connected <= PLAYER_TRAFFIC_MIN_CLIENTS)
			if(collecting)
				collecting = FALSE
				close_window(batch)
				population_pauses++
				batch += "T|[relative_time()]|pause"
			append_batch(batch)
			return

		if(!collecting)
			collecting = TRUE
			open_window()
			batch += "T|[relative_time()]|resume"

		var/sweep_time = relative_time()
		var/list/tally = list()
		var/eligible = 0
		// histogram[n + 1] counts the players who moved n times this window
		var/list/histogram = list()
		for(var/client/viewer as anything in GLOB.clients)
			var/moves_this_window = viewer.traffic_moves
			viewer.traffic_moves = 0
			var/mob/living/player = viewer.mob
			var/turf/spot
			if(PLAYER_TRAFFIC_ELIGIBLE(player))
				// Nearly every player mob stands directly on a turf, so the builtin walk is only needed for
				// the ones inside something
				spot = isturf(player.loc) ? player.loc : get_turf(player)
			// A player who moved and then died or left the map this window still made those moves
			if(spot || moves_this_window)
				if(length(histogram) <= moves_this_window)
					histogram.len = moves_this_window + 1
				histogram[moves_this_window + 1] += 1
			if(!spot)
				continue
			eligible++
			tally["[spot.x],[spot.y],[spot.z]"] += 1

		var/after_sample = TICK_USAGE_REAL

		var/list/fragments = list()
		for(var/coordinate in tally)
			fragments += "[coordinate],[tally[coordinate]]"

		// Shuffled to put emphasis on overall server movement and position, not individual tracking
		shuffle_inplace(fragments)

		// An empty sweep still gets a record, otherwise the offline reader cannot tell an observed
		// empty map from a collection gap
		batch += "S|[sweep_time]|[connected]|[eligible]|[fragments.Join(";")]"
		write_window(batch, histogram, eligible)
		var/after_encode = TICK_USAGE_REAL

		if(append_batch(batch))
			sweeps_written++
			samples_recorded += eligible

		var/after_append = TICK_USAGE_REAL
		sample_ms_total += TICK_DELTA_TO_MS(after_sample - sweep_start)
		encode_ms_total += TICK_DELTA_TO_MS(after_encode - after_sample)
		var/append_ms = TICK_DELTA_TO_MS(after_append - after_encode)
		append_ms_total += append_ms
		append_ms_max = max(append_ms_max, append_ms)
		var/sweep_ms = TICK_DELTA_TO_MS(after_append - sweep_start)
		sweep_ms_total += sweep_ms
		sweep_ms_max = max(sweep_ms_max, sweep_ms)
	catch(var/exception/error)
		abort_recording(error)

/datum/controller/subsystem/player_traffic/stat_entry(msg)
	if(!enabled)
		msg += "|[failed ? "FAILED" : (finalized ? "DONE" : "OFF")]"
		return ..()
	msg += "|[collecting ? "REC" : "WAIT"]|SW:[sweeps_written]/[sweeps_attempted]|SA:[samples_recorded]|D:[deaths_recorded]"
	msg += "|KB:[round(bytes_written / 1024, 0.1)]|MAX:[round(sweep_ms_max, 0.01)]ms"
	return ..()

/**
 * Carries over any failure report but none of the recording, and stays off.
 *
 * A recovery means the old instance died mid round and its death registration still points at it.
 * Carrying the file forward would risk a second header, a footer on an interrupted recording or a
 * doubled death listener, none of which is worth it for a diagnostic recorder, so the existing file
 * is left footerless and the replacement stays finalized.
 */
/datum/controller/subsystem/player_traffic/Recover()
	failed = SSplayer_traffic.failed
	pending_failure = SSplayer_traffic.pending_failure
	SSplayer_traffic.pending_failure = null
	if(!SSplayer_traffic.header_written && !failed)
		return
	SSplayer_traffic.enabled = FALSE
	SSplayer_traffic.collecting = FALSE
	SSplayer_traffic.finalized = TRUE
	SSplayer_traffic.UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	log_path = SSplayer_traffic.log_path
	header_written = SSplayer_traffic.header_written
	finalized = TRUE

/**
 * Disables a failed recorder for the rest of the round.
 *
 * Movement and death callbacks can reach this proc. Close both gates immediately and leave the
 * report and signal cleanup to the sweep, so neither does logging from a gameplay callback.
 * Do not flush the damaged window or write a completion footer.
 */
/datum/controller/subsystem/player_traffic/proc/abort_recording(exception/error)
	if(failed)
		return
	collecting = FALSE
	enabled = FALSE
	finalized = TRUE
	failed = TRUE
	pending_failure = "Player Movement Telemetry Disabled after a recorder error. Recording left incomplete."

	try
		var/location = istype(error) ? "[error.file]:[error.line]" : "unknown"
		pending_failure = "Player Movement Telemetry Disabled after a recorder error: [copytext("[location]: [error]", 1, 513)]. Recording left incomplete."
	catch
		return

/**
 * Reports a recorder failure from the sweep or round end.
 *
 * Consume the pending message before cleanup or logging. Failures here must not escape into the
 * caller or retry on every sweep, and collection stays disabled even if signal cleanup fails.
 */
/datum/controller/subsystem/player_traffic/proc/report_failure()
	if(!pending_failure)
		return
	var/message = pending_failure
	pending_failure = null
	continuous_ends = null
	bypass_ends = null
	pending_deaths = null

	try
		UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
	catch
		message += " Death signal cleanup also failed."

	try
		message_admins("Player Movement Telemetry failed and was disabled for this round. The recording is incomplete.")
	catch
		message += " Administrator notification also failed."

	try
		log_runtime(message)
	catch
		return

/// Round relative time in deciseconds, the origin every record is written against
/datum/controller/subsystem/player_traffic/proc/relative_time()
	return max(0, world.time - SSticker.round_start_time)

/datum/controller/subsystem/player_traffic/proc/start_recording(block = 1)
	if(enabled || finalized)
		return FALSE
	try
		if(!open_log())
			return FALSE

		endpoint_block = block
		enabled = TRUE
		collecting = length(GLOB.clients) > PLAYER_TRAFFIC_MIN_CLIENTS
		if(collecting)
			open_window()
		RegisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH, PROC_REF(on_mob_death))
		append_batch(list("T|[relative_time()]|enabled|[collecting ? "collecting" : "paused"]"))
		return TRUE
	catch(var/exception/error)
		abort_recording(error)
		return FALSE

/datum/controller/subsystem/player_traffic/proc/stop_recording()
	if(!enabled)
		return

	try
		var/list/batch = list()
		drain_deaths(batch)
		if(collecting)
			close_window(batch)
		batch += "T|[relative_time()]|disabled"

		enabled = FALSE
		collecting = FALSE
		admin_gaps++
		UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
		append_batch(batch)
	catch(var/exception/error)
		abort_recording(error)

/// Writes the completion footer once, which is the only thing that marks a recording complete
/datum/controller/subsystem/player_traffic/proc/finalize()
	if(finalized || !header_written)
		return

	try
		// The drain and the last window go ahead of the footer, so the footer is the last record and its
		// totals include what was queued at round end. Its byte total cannot include its own line
		var/list/batch = list()
		drain_deaths(batch)
		if(collecting)
			close_window(batch)
		var/bytes_before_footer = bytes_written
		for(var/line in batch)
			bytes_before_footer += length(line) + 1
		batch += "E|[relative_time()]|[sweeps_written]|[samples_recorded]|[deaths_recorded]|[bytes_before_footer]|complete"

		finalized = TRUE
		enabled = FALSE
		collecting = FALSE
		UnregisterSignal(SSdcs, COMSIG_GLOB_MOB_DEATH)
		append_batch(batch)
	catch(var/exception/error)
		abort_recording(error)

/**
 * Round end entry point.
 *
 * Resolving the subsystem through the global rather than holding it in the callback matters because
 * NEW_SS_GLOBAL qdels the old instance right after Recover(). A CALLBACK(src) would still be sitting
 * in SSticker.round_end_events at that point and would turn that qdel into a hard delete.
 */
/proc/player_traffic_finalize()
	SSplayer_traffic.finalize()
	SSplayer_traffic.report_failure()

/// Opens the round file on the first enable and writes the header, later enables reuse both
/datum/controller/subsystem/player_traffic/proc/open_log()
	if(log_path)
		return TRUE
	if(!GLOB.log_directory)
		return FALSE

	log_path = "[GLOB.log_directory]/player_movement_telemetry.log"
	var/revision = GLOB.revdata?.commit || "unknown"
	var/map_name = SSmapping.current_map?.map_name || "unknown"
	var/list/opening = list("H|[PLAYER_TRAFFIC_SCHEMA_VERSION]|[GLOB.round_id || "unknown"]|[map_name]|[revision]|[wait]|[PLAYER_TRAFFIC_MIN_CLIENTS]|[world.maxx]|[world.maxy]|[world.maxz]")
	describe_zlevels(opening)
	append_batch(opening)
	header_written = TRUE

	if(!roundend_registered)
		roundend_registered = TRUE
		SSticker.OnRoundend(CALLBACK(GLOBAL_PROC, GLOBAL_PROC_REF(player_traffic_finalize)))
	return TRUE

/// Describes each z-level the file has not described yet, so a reader can name levels and stack
/// floors instead of guessing from numbers that change with the map and its load order
/datum/controller/subsystem/player_traffic/proc/describe_zlevels(list/lines)
	// z_list rather than world.maxz, which add_new_zlevel raises before the level is filed
	var/level_count = length(SSmapping.z_list)
	for(var/z in (zlevels_written + 1) to level_count)
		var/datum/space_level/level = SSmapping.z_list[z]
		var/list/traits = level.traits || list()
		// The name mapping gave the level when it loaded, like Station 2 or Wretched Fortress
		var/level_name = replacetext(level.name, "|", "/")
		lines += "Z|[relative_time()]|[z]|[level_name]|[traits[ZTRAIT_STATION] ? 1 : 0]|[traits[ZTRAIT_UP] ? 1 : 0]|[traits[ZTRAIT_DOWN] ? 1 : 0]"
	zlevels_written = max(zlevels_written, level_count)

/**
 * Records movement callbacks and their destination tiles while collecting.
 *
 * A non-forced diagonal callback ending one cardinal tile away repeats the split Move() step.
 * Forced moves and true diagonal displacements must retain their destination records.
 */
/datum/controller/subsystem/player_traffic/proc/count_move(mob/living/mover, atom/old_loc, direction, forced)
	SHOULD_NOT_SLEEP(TRUE)

	try
		if(!PLAYER_TRAFFIC_ELIGIBLE(mover))
			return
		var/turf/destination = isturf(mover.loc) ? mover.loc : get_turf(mover)
		// Every counted move lands in a V record, and a move off the map has no tile to land on
		if(!destination)
			return
		var/turf/origin = get_turf(old_loc)
		if(!forced && (direction & (direction - 1)) && origin && origin.z == destination.z)
			if(abs(destination.x - origin.x) + abs(destination.y - origin.y) == 1)
				diagonal_echoes++
				return
		mover.client.traffic_moves++
		window_moves++

		// A block is keyed by its lowest turf, following the coverage grid's x / block convention, so no
		// coordinate string is built per move
		var/turf/bucket = destination
		if(endpoint_block > 1)
			bucket = locate(max(1, destination.x - destination.x % endpoint_block), max(1, destination.y - destination.y % endpoint_block), destination.z)

		// Forced moves, jumps and level changes would stay on the full service path under a silence gate,
		// so they are counted apart from ordinary walking
		if(forced || !origin || origin.z != destination.z || get_dist(origin, destination) > 1)
			bypass_moves++
			bypass_ends[bucket] += 1
			return
		switch(mover.m_intent)
			if(MOVE_INTENT_RUN)
				run_moves++
			if(MOVE_INTENT_SNEAK)
				sneak_moves++
			else
				walk_moves++
		continuous_ends[bucket] += 1
	catch(var/exception/error)
		abort_recording(error)

/// Starts a movement window with every count at zero, so nothing from before it leaks in
/datum/controller/subsystem/player_traffic/proc/open_window()
	reset_window()
	for(var/client/viewer as anything in GLOB.clients)
		viewer.traffic_moves = 0

/// Writes the open window early, with its real length, when collection stops
/datum/controller/subsystem/player_traffic/proc/close_window(list/lines)
	var/list/histogram = list()
	var/eligible = 0
	for(var/client/viewer as anything in GLOB.clients)
		var/moves_this_window = viewer.traffic_moves
		viewer.traffic_moves = 0
		var/mob/living/player = viewer.mob
		var/present = PLAYER_TRAFFIC_ELIGIBLE(player) && get_turf(player)
		if(present)
			eligible++
		if(present || moves_this_window)
			if(length(histogram) <= moves_this_window)
				histogram.len = moves_this_window + 1
			histogram[moves_this_window + 1] += 1
	write_window(lines, histogram, eligible)

/**
 * Writes movement totals and endpoints, then resets the window.
 *
 * Eligibility is sampled at the end. Histogram participants also include movers who became
 * ineligible, so active share uses that population. Neither count is integrated player time.
 * Nonempty zero-duration windows keep their counts. Readers must not divide those by duration.
 */
/datum/controller/subsystem/player_traffic/proc/write_window(list/lines, list/histogram, eligible_at_end)
	var/time = relative_time()
	var/window_ds = world.time - window_start
	if(!window_ds && !window_moves && !diagonal_echoes)
		reset_window()
		return

	var/list/players = list()
	var/counted = 0
	var/active = 0
	var/participants = 0
	for(var/bucket in 1 to length(histogram))
		var/count = histogram[bucket] || 0
		players += "[count]"
		participants += count
		counted += count * (bucket - 1)
		if(bucket > 1)
			active += count
	// A player who disconnected before the window was written took their count with them
	var/lost = window_moves - counted
	lines += "M|[time]|[window_ds]|[eligible_at_end]|[participants]|[window_moves]|[active]|[walk_moves]|[run_moves]|[sneak_moves]|[bypass_moves]|[diagonal_echoes]|[lost]|[players.Join(",")]"

	// With blocks, each key turf is written as its block index, x / block rounded down, which is exact
	// integer division once the remainder is taken off
	var/block = endpoint_block
	var/list/ends = list()
	for(var/turf/end as anything in continuous_ends)
		ends += "[(end.x - end.x % block) / block],[(end.y - end.y % block) / block],[end.z],[continuous_ends[end]],[bypass_ends[end] || 0]"
	for(var/turf/end as anything in bypass_ends)
		if(!continuous_ends[end])
			ends += "[(end.x - end.x % block) / block],[(end.y - end.y % block) / block],[end.z],0,[bypass_ends[end]]"
	// Turfs enter these lists in the order they were first reached, which for a lone player is their
	// path through the window
	shuffle_inplace(ends)
	lines += "V|[time]|[window_ds]|[block]|[ends.Join(";")]"
	reset_window()

/// Zeroes the window totals and starts the window from now
/datum/controller/subsystem/player_traffic/proc/reset_window()
	window_start = world.time
	window_moves = 0
	walk_moves = 0
	run_moves = 0
	sneak_moves = 0
	bypass_moves = 0
	diagonal_echoes = 0
	continuous_ends.Cut()
	bypass_ends.Cut()

/// Moves queued deaths into a batch, which is what lets them keep their own timestamps
/datum/controller/subsystem/player_traffic/proc/drain_deaths(list/lines)
	for(var/record in pending_deaths)
		var/count = pending_deaths[record]
		lines += "D|[record],[count]"
		deaths_recorded += count
	pending_deaths.Cut()

/// One append per batch of complete lines, never one per client
/datum/controller/subsystem/player_traffic/proc/append_batch(list/lines)
	if(!log_path)
		return FALSE
	drain_deaths(lines)
	if(!length(lines))
		return FALSE

	// The unformatted writer adds no line ending, so every append has to end its own last line
	var/payload = "[lines.Join("\n")]\n"
	WRITE_LOG_NO_FORMAT(log_path, payload)
	bytes_written += length(payload)
	return TRUE

/datum/controller/subsystem/player_traffic/proc/on_mob_death(datum/source, mob/dying, gibbed)
	SIGNAL_HANDLER

	if(!collecting)
		return

	try
		// No repeat call guard is needed, since human death() returns once stat is DEAD and gib() only
		// calls it on the living. Invisible mobs are skipped here too, as the sweep never saw them
		if(!isliving(dying) || !dying.client || dying.invisibility >= INVISIBILITY_OBSERVER)
			return

		var/turf/spot = get_turf(dying)
		if(!spot)
			return
		// The key carries the death's own relative time so batching it does not move the record
		pending_deaths["[relative_time()]|[spot.x],[spot.y],[spot.z]"] += 1
	catch(var/exception/error)
		abort_recording(error)

/client/proc/toggle_player_traffic_telemetry()
	set category = "-Server-"
	set name = "Toggle Player Movement Telemetry"

	if(!check_rights(R_SERVER))
		return

	if(SSplayer_traffic.finalized)
		to_chat(usr, span_adminnotice(SSplayer_traffic.failed ? "Player movement telemetry failed and is disabled for this round." : "Player movement telemetry has already finished this round."))
		return

	if(SSplayer_traffic.enabled)
		SSplayer_traffic.stop_recording()
		log_admin("[key_name(usr)] disabled player movement telemetry.")
		message_admins("[key_name_admin(usr)] disabled player movement telemetry.")
		to_chat(usr, "Player Movement Telemetry Disabled.")
		return

	if(SSticker.current_state != GAME_STATE_PLAYING)
		to_chat(usr, span_adminnotice("Player movement telemetry only records during a running round."))
		return

	var/resolution = alert(usr, "Record where moves end per tile or in 4x4 blocks?", "Player Movement Telemetry", "Cancel", "Per tile", "4x4")
	if(resolution != "Per tile" && resolution != "4x4")
		return
	var/block = resolution == "4x4" ? 4 : 1
	// The prompt waits on the admin, so the recorder or the round may have moved on in the meantime
	if(SSplayer_traffic.enabled || SSplayer_traffic.finalized || SSticker.current_state != GAME_STATE_PLAYING)
		return

	if(!SSplayer_traffic.start_recording(block))
		to_chat(usr, span_adminnotice(SSplayer_traffic.failed ? "Player movement telemetry failed and is disabled for this round." : "Player movement telemetry could not open its log file."))
		return

	log_admin("[key_name(usr)] enabled player movement telemetry with [block == 4 ? "4x4" : "per-tile"] endpoints.")
	message_admins("[key_name_admin(usr)] enabled player movement telemetry with [block == 4 ? "4x4" : "per-tile"] endpoints.")
	to_chat(usr, "Player Movement Telemetry Enabled.")

#undef PLAYER_TRAFFIC_SCHEMA_VERSION
#undef PLAYER_TRAFFIC_MIN_CLIENTS
#undef PLAYER_TRAFFIC_ELIGIBLE
