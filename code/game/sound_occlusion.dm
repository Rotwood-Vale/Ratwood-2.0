/*
 * SOUND OCCLUSION: whether anything stands between a listener and what they are hearing.
 *
 * Ours, not TG's. So, it's not quite proven.
 *
 * Three callers, deliberately not identical:
 *   SSpoint_ambience  turf opacity only, graded, silence for enclosed sources. A listener standing
 *                     still never re-sends, so a door's state would freeze into the sound.
 *   /datum/sound_token turf CONTENTS too, so doors count. It re-evaluates whenever either side
 *                     moves, so nothing can freeze.
 *   playsound()       a class per call (SOUND_TRAVEL_*), turf CONTENTS read, recomputed on every
 *                     shot. occlusion_muffle_for() below is its whole decision.
 *
 * WHAT DOES the muffling stays where it is applied, in playsound_local and slim_send. Those two are
 * hand-maintained mirrors and nothing in the repo checks that they agree, so change them together;
 * a shared proc would put a call on every listener of every sound in the game to save duplicating
 * four lines.
 */

/// Tiles the last opacity_between() walked, for callers pricing the walk. Valid only until the
/// NEXT call from anywhere, so read it straight after the call that set it and never across one.
GLOBAL_VAR_INIT(opacity_walk_tiles, 0)

/// Where the last opacity_between() was blocked, and the tile it stepped from to get there. Written
/// ONLY on OCCLUSION_SOLID, so read them only when that is what came back. A caller looking for a
/// way round needs the obstruction's position, not the listener's: the two tiles a DIAGONAL step cut
/// between are where a corner opens, and they are derived from these four numbers.
GLOBAL_VAR_INIT(opacity_block_x, 0)
GLOBAL_VAR_INIT(opacity_block_y, 0)
GLOBAL_VAR_INIT(opacity_block_from_x, 0)
GLOBAL_VAR_INIT(opacity_block_from_y, 0)

/// What the last has_open_path() cost, since opacity_walk_tiles is per CALL and that proc makes up
/// to two. Reset on entry to it, so read them straight after and never across another.
GLOBAL_VAR_INIT(occlusion_probe_walks, 0)
GLOBAL_VAR_INIT(occlusion_probe_tiles, 0)

/**
 * Whether anything opaque stands between two turfs, for sound occlusion.
 *
 * OCCLUSION_CLEAR or OCCLUSION_SOLID: any opaque tile on the line blocks it, and the walk stops
 * there. This says only whether THIS line is clear, which cannot distinguish a source enclosed
 * behind a wall from one round a corner with an open path to it. Callers that care ask again from a
 * tile to the side; that is has_open_path() below, and sound_occlusion_grade() does both.
 *
 * A REAL LINE, unlike can_see(), which walks with get_step_towards: that goes through get_dir,
 * which returns a compound direction whenever both deltas are non-zero, so it steps diagonally until
 * one axis runs out and then straight along the other. From (0,0) to (5,1) it walks y=1 the whole
 * way and never touches (2,0) or (3,0), which is where a wall between the two actually stands.
 * Shallow angles are the worst case and the common one indoors.
 *
 * Arguments:
 * * steps_allowed - give up after this many tiles and call it SOLID, silence being the safer
 *   failure for a line that will not terminate
 * * check_contents - also read opacity on each turf's CONTENTS, which is what catches doors and
 *   shutters. Costs a contents loop per tile, so it is for callers that re-evaluate as things move:
 *   a door opens and closes, and a caller that will not re-check freezes its state into the sound.
 * * trace - collects the turfs crossed, so a debug verb reports the walk that actually happened
 *   rather than a second implementation of it
 */
/proc/opacity_between(turf/start, turf/target, steps_allowed, check_contents = FALSE, list/trace)
	// Cleared before either early return, or a caller reads the previous call's count.
	GLOB.opacity_walk_tiles = 0
	if(!start || !target || start.z != target.z)
		return OCCLUSION_CLEAR
	var/x = start.x
	var/y = start.y
	var/z = start.z
	var/target_x = target.x
	var/target_y = target.y
	var/dx = abs(target_x - x)
	var/dy = -abs(target_y - y)
	if(!dx && !dy)
		return OCCLUSION_CLEAR
	var/step_x = (x < target_x) ? 1 : -1
	var/step_y = (y < target_y) ? 1 : -1
	var/err = dx + dy
	var/steps = 0
	// ONE exit, so the tile count is written once rather than per iteration; it is only ever read
	// straight after the call.
	. = OCCLUSION_CLEAR
	while(TRUE)
		steps++
		// Erring toward blocked: silent is the safer failure for a line that will not terminate.
		if(steps > steps_allowed)
			// Written here too, or a caller reading the position after a SOLID gets the PREVIOUS
			// call's block. Giving up is a block, and where we stopped is the honest answer for it.
			// from == block leaves has_open_path on its straight-on branch, which is the right
			// guess when there is no step to have been diagonal.
			GLOB.opacity_block_x = x
			GLOB.opacity_block_y = y
			GLOB.opacity_block_from_x = x
			GLOB.opacity_block_from_y = y
			. = OCCLUSION_SOLID
			break
		var/e2 = err * 2
		var/from_x = x
		var/from_y = y
		if(e2 >= dy)
			err += dy
			x += step_x
		if(e2 <= dx)
			err += dx
			y += step_y
		if(x == target_x && y == target_y)
			break
		var/turf/current = locate(x, y, z)
		if(!current)
			break
		if(trace)
			trace += current
		var/opaque = current.opacity
		if(!opaque && check_contents)
			for(var/atom/thing as anything in current)
				if(thing.opacity)
					opaque = TRUE
					break
		if(opaque)
			GLOB.opacity_block_x = x
			GLOB.opacity_block_y = y
			GLOB.opacity_block_from_x = from_x
			GLOB.opacity_block_from_y = from_y
			. = OCCLUSION_SOLID
			break
	GLOB.opacity_walk_tiles = steps

/**
 * Whether a blocked line has a way round it, which is what separates a corner from an enclosure.
 *
 * BESIDE THE OBSTRUCTION, not beside the listener. Where a diagonal step lands on a wall, the two
 * tiles it cut between are where the corner opens, and they can be nowhere near the listener; probing
 * beside the listener misses a fire in plain view round a corner. Where the step was straight on,
 * the sideways neighbours of the blocking tile stand in: a lone pillar has open ground either side,
 * a wall run does not.
 *
 * Testing the flanks for openness alone is NOT enough, and is why each one is walked. The flank on
 * the listener's side of a wall is open by definition, since they are standing next to it, so a
 * straight wall approached diagonally would carry sound straight through.
 *
 * Costs up to two walks, and only ever runs on a line already known to be blocked.
 *
 * Arguments:
 * * target - the source. The obstruction comes from GLOB.opacity_block_*, valid only because the
 *   caller has just had OCCLUSION_SOLID back; read into locals here before any probe overwrites it.
 * * steps_allowed - passed to each probe, so a corner cannot be found further away than the sound
 *   could be heard anyway
 */
/proc/has_open_path(turf/target, steps_allowed, check_contents = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	GLOB.occlusion_probe_walks = 0
	GLOB.occlusion_probe_tiles = 0
	var/block_x = GLOB.opacity_block_x
	var/block_y = GLOB.opacity_block_y
	var/from_x = GLOB.opacity_block_from_x
	var/from_y = GLOB.opacity_block_from_y
	var/z = target.z
	if(block_x != from_x && block_y != from_y)
		// A DIAGONAL step cut between these two, so they are where a corner opens.
		if(probe_open_path(locate(block_x, from_y, z), target, steps_allowed, check_contents))
			return TRUE
		return probe_open_path(locate(from_x, block_y, z), target, steps_allowed, check_contents)
	// Straight on, so step sideways past the obstruction instead: a lone pillar has open ground
	// either side of it, a wall run does not.
	var/side_x = (block_y == from_y) ? 0 : 1
	var/side_y = (block_y == from_y) ? 1 : 0
	if(probe_open_path(locate(block_x + side_x, block_y + side_y, z), target, steps_allowed, check_contents))
		return TRUE
	return probe_open_path(locate(block_x - side_x, block_y - side_y, z), target, steps_allowed, check_contents)

/// One origin for has_open_path(). Separate so neither side allocates a list to iterate over.
/proc/probe_open_path(turf/beside, turf/target, steps_allowed, check_contents = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	// A wall to the side is not somewhere the sound could have come through either.
	if(!beside || beside.opacity)
		return FALSE
	GLOB.occlusion_probe_walks++
	. = opacity_between(beside, target, steps_allowed, check_contents) == OCCLUSION_CLEAR
	GLOB.occlusion_probe_tiles += GLOB.opacity_walk_tiles

/**
 * The full three-state answer: CLEAR, MUFFLED round a corner, or SOLID and properly enclosed.
 *
 * One walk when the line is clear, which is most of them, and up to two more when it is not. A
 * caller wanting only "is anything in the way" should call opacity_between() directly and save the
 * probes; this is for callers that treat a corner differently from a wall.
 *
 * Leaves GLOB.opacity_walk_tiles holding the DIRECT walk and the probe accumulators holding the
 * probes, so a caller pricing the work reads all three straight after rather than timing around it.
 * The direct count is restored deliberately: the probes overwrite it on their way past.
 */
/proc/sound_occlusion_grade(turf/listener_turf, turf/source_turf, steps_allowed, check_contents = FALSE, list/trace)
	SHOULD_NOT_SLEEP(TRUE)
	GLOB.occlusion_probe_walks = 0
	GLOB.occlusion_probe_tiles = 0
	. = opacity_between(listener_turf, source_turf, steps_allowed, check_contents, trace)
	if(. != OCCLUSION_SOLID)
		return
	// The probes overwrite all of this on their way past, and a caller that wants to know WHERE the
	// line was blocked has only the direct walk's answer to work from: the probes start beside the
	// obstruction and find their own. Saved and put back, the tile count with them.
	var/direct_tiles = GLOB.opacity_walk_tiles
	var/block_x = GLOB.opacity_block_x
	var/block_y = GLOB.opacity_block_y
	var/from_x = GLOB.opacity_block_from_x
	var/from_y = GLOB.opacity_block_from_y
	if(has_open_path(source_turf, steps_allowed, check_contents))
		. = OCCLUSION_MUFFLED
	GLOB.opacity_walk_tiles = direct_tiles
	GLOB.opacity_block_x = block_x
	GLOB.opacity_block_y = block_y
	GLOB.opacity_block_from_x = from_x
	GLOB.opacity_block_from_y = from_y

/**
 * What playsound_local should be told about one listener, from the caller's SOUND_TRAVEL_* class.
 *
 * SOUND_MUFFLE_NONE, SOFT or ENCLOSED, or NULL for "do not send", which only CONTAINED can return.
 * CARRYING is one opacity_between() and anything on the line is SOFT. LEAKING and CONTAINED grade,
 * one walk when the line is clear and up to three when it is not, and differ only in what an
 * enclosure becomes.
 *
 * The caller has already decided this listener is worth walking to: same floor, not adjacent, mode
 * not NONE. Those gates stay in playsound so the common case costs no proc call at all. Contents are
 * read, since a one-shot recomputes from scratch and a door's state cannot freeze into it.
 *
 * Leaves the GLOB walk counters as the walk it made left them, for the falloff verb to print, and
 * bumps GLOB.sound_occlusion_walks/tiles so the survey can price the whole thing.
 */
/proc/occlusion_muffle_for(turf/listener_turf, turf/source_turf, occlusion, steps_allowed, list/trace)
	SHOULD_NOT_SLEEP(TRUE)
	switch(occlusion)
		if(SOUND_TRAVEL_CARRYING)
			. = (opacity_between(listener_turf, source_turf, steps_allowed, TRUE, trace) == OCCLUSION_CLEAR) ? SOUND_MUFFLE_NONE : SOUND_MUFFLE_SOFT
			GLOB.sound_occlusion_walks++
			GLOB.sound_occlusion_tiles += GLOB.opacity_walk_tiles
			return
		if(SOUND_TRAVEL_LEAKING, SOUND_TRAVEL_CONTAINED)
			switch(sound_occlusion_grade(listener_turf, source_turf, steps_allowed, TRUE, trace))
				if(OCCLUSION_MUFFLED)
					. = SOUND_MUFFLE_SOFT
				if(OCCLUSION_SOLID)
					if(occlusion == SOUND_TRAVEL_CONTAINED)
						. = null
					else
						// MEASURED FROM THE BARRIER, not the source. The walk ran listener -> source,
						// so the tile it stopped on is the first wall on the LISTENER'S side, and
						// this is how far past it they are standing. A source deeper into the room
						// no longer changes what someone just outside hears, which is what the
						// source-measured version got wrong: a bed three tiles in was inaudible
						// from the far side of its own wall.
						var/bdx = listener_turf.x - GLOB.opacity_block_x
						var/bdy = listener_turf.y - GLOB.opacity_block_y
						. = ((bdx * bdx + bdy * bdy) > (SOUND_TRAVEL_LEAK_RANGE * SOUND_TRAVEL_LEAK_RANGE)) ? null : SOUND_MUFFLE_ENCLOSED
				else
					. = SOUND_MUFFLE_NONE
			GLOB.sound_occlusion_walks += 1 + GLOB.occlusion_probe_walks
			GLOB.sound_occlusion_tiles += GLOB.opacity_walk_tiles + GLOB.occlusion_probe_tiles
			return
	return SOUND_MUFFLE_NONE
