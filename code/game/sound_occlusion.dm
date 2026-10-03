/*
 * SOUND OCCLUSION: whether anything stands between a listener and what they are hearing.
 *
 * The callers, deliberately not identical:
 *   SSpoint_ambience  turf opacity and doors, graded, and an enclosed source fades out. A door is
 *                     read only where a turf's door count says one may stand, and a listener
 *                     standing still never re-sends, so a door that changes has the listeners near
 *                     it served again
 *   /datum/sound_token turf CONTENTS too, so doors count. It re-evaluates whenever either side
 *                     moves, so a door that changes while both stand still is heard as it was
 *                     until one of them moves.
 *   playsound()       a class per call (SOUND_TRAVEL_*), turf CONTENTS read, recomputed on every
 *                     shot. occlusion_muffle_for() below is its whole decision.
 *
 * WHAT DOES the muffling stays where it is applied, in playsound_local and slim_send. Those two are
 * hand-maintained mirrors and nothing in the repo checks that they agree, so change them together.
 * A shared proc would put a call on every listener of every sound in the game to save duplicating
 * a few lines.
 */

/// Tiles the last opacity_between() walked, for callers pricing the walk. Valid only until the
/// NEXT call from anywhere, so read it straight after the call that set it and never across one
GLOBAL_VAR_INIT(opacity_walk_tiles, 0)

/**
 * Where the last opacity_between() was blocked, and the tile it stepped from to get there.
 *
 * Written ONLY on OCCLUSION_SOLID, so read them only when that is what came back. A caller looking
 * for a way round needs the obstruction's position, not the listener's: the two tiles a DIAGONAL
 * step cut between are where a corner opens, and they are derived from these four numbers.
 */
GLOBAL_VAR_INIT(opacity_block_x, 0)
GLOBAL_VAR_INIT(opacity_block_y, 0)
GLOBAL_VAR_INIT(opacity_block_from_x, 0)
GLOBAL_VAR_INIT(opacity_block_from_y, 0)

/// What the last has_open_path() cost, since opacity_walk_tiles is per CALL and that proc makes up
/// to two. Reset on entry to it, so read them straight after and never across another
GLOBAL_VAR_INIT(occlusion_probe_walks, 0)
GLOBAL_VAR_INIT(occlusion_probe_tiles, 0)

/**
 * Whether anything opaque stands between two turfs, for sound occlusion.
 *
 * OCCLUSION_CLEAR or OCCLUSION_SOLID: any opaque tile on the line blocks it, and the walk stops
 * there. This says only whether THIS line is clear, which cannot distinguish a source enclosed
 * behind a wall from one round a corner with an open path to it. Callers that care ask again from a
 * tile to the side. That is has_open_path() below, and sound_occlusion_grade() does both.
 *
 * A REAL LINE, unlike can_see(), which walks with get_step_towards: that goes through get_dir,
 * which returns a compound direction whenever both deltas are non-zero, so it steps diagonally until
 * one axis runs out and then straight along the other. From (0,0) to (5,1) it walks y=1 the whole
 * way and never touches (2,0) or (3,0), which is where a wall between the two actually stands.
 * Shallow angles are the worst case and the common one indoors.
 *
 * erp_muffle_for() uses the same stepping for ERP audio, kept apart so no other sound pays for
 * its opening checks. Change the stepping in both.
 *
 * Arguments:
 * * steps_allowed - tiles walked before giving up and calling it SOLID, silence being the safer
 *   failure. Only a target further than this on either axis gets there, and callers pass their
 *   range
 * * check_contents - also read opacity on each turf's CONTENTS, which is what catches doors and
 *   shutters. Costs a contents loop per tile, so it is for callers that re-evaluate as things move:
 *   a door opens and closes, and a caller that will not re-check freezes its state into the sound.
 * * trace - collects the turfs crossed, so a debug verb reports the walk that actually happened
 *   rather than a second implementation of it
 * * doors - SOUND_DOORS_LIVE or ALWAYS also stops at a door, looping a turf's contents only where
 *   its sound_door_count says one may stand. Blind to every other opaque object, which is the
 *   point: trees, reeds and fences do not stop sound
 *
 * On the give-up path the block position is written as well, or a caller reading it after a SOLID
 * gets the PREVIOUS call's block. Giving up is a block, and where the walk stopped is the honest
 * answer for it. from == block leaves has_open_path on its straight-on branch, which is the right
 * guess when there is no step to have been diagonal
 */
/proc/opacity_between(turf/start, turf/target, steps_allowed, check_contents = FALSE, list/trace, doors = SOUND_DOORS_NONE)
	// Cleared before either early return, or a caller reads the previous call's count
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
	var/door_walk = doors >= SOUND_DOORS_LIVE
	// Every break lands on the one write after the loop
	. = OCCLUSION_CLEAR
	while(TRUE)
		steps++
		if(steps > steps_allowed)
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
		else if(!opaque && door_walk && current.sound_door_count > 0)
			opaque = door_blocks_sound(current, doors)
		if(opaque)
			GLOB.opacity_block_x = x
			GLOB.opacity_block_y = y
			GLOB.opacity_block_from_x = from_x
			GLOB.opacity_block_from_y = from_y
			. = OCCLUSION_SOLID
			break
	GLOB.opacity_walk_tiles = steps

/**
 * Whether a door on this turf stops sound, a door being any object with sound_door set.
 *
 * LIVE reads each as it stands, so a donjon door with its viewport slid open passes. ALWAYS also
 * stops at a mineral door that is open or opening and would shut solid. Opening clears its opacity
 * before the animation and marks it open after, so isSwitchingStates covers the gap.
 */
/proc/door_blocks_sound(turf/door_turf, doors)
	SHOULD_NOT_SLEEP(TRUE)
	for(var/obj/door in door_turf)
		if(!door.sound_door)
			continue
		if(door.opacity)
			return TRUE
		if(doors != SOUND_DOORS_ALWAYS || !istype(door, /obj/structure/mineral_door))
			continue
		var/obj/structure/mineral_door/mineral = door
		if((mineral.door_opened || mineral.isSwitchingStates) && !mineral.windowed && !mineral.brokenstate && initial(mineral.opacity))
			return TRUE
	return FALSE

/**
 * Whether a blocked line has a way round it, which is what separates a corner from an enclosure.
 *
 * BESIDE THE OBSTRUCTION, not beside the listener. Where a diagonal step lands on a wall, the two
 * tiles it cut between are where the corner opens, and they can be nowhere near the listener. Probing
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
 *   caller has just had OCCLUSION_SOLID back. Read into locals here before any probe overwrites it.
 * * steps_allowed - passed to each probe, so a corner cannot be found further away than the sound
 *   could be heard anyway
 */
/proc/has_open_path(turf/target, steps_allowed, check_contents = FALSE, doors = SOUND_DOORS_NONE)
	SHOULD_NOT_SLEEP(TRUE)
	GLOB.occlusion_probe_walks = 0
	GLOB.occlusion_probe_tiles = 0
	var/block_x = GLOB.opacity_block_x
	var/block_y = GLOB.opacity_block_y
	var/from_x = GLOB.opacity_block_from_x
	var/from_y = GLOB.opacity_block_from_y
	var/z = target.z
	if(block_x != from_x && block_y != from_y)
		if(probe_open_path(locate(block_x, from_y, z), target, steps_allowed, check_contents, doors))
			return TRUE
		return probe_open_path(locate(from_x, block_y, z), target, steps_allowed, check_contents, doors)
	// Straight on, so step sideways past the obstruction
	var/side_x = (block_y == from_y) ? 0 : 1
	var/side_y = (block_y == from_y) ? 1 : 0
	if(probe_open_path(locate(block_x + side_x, block_y + side_y, z), target, steps_allowed, check_contents, doors))
		return TRUE
	return probe_open_path(locate(block_x - side_x, block_y - side_y, z), target, steps_allowed, check_contents, doors)

/**
 * One origin for has_open_path(). Separate so neither side allocates a list to iterate over.
 *
 * The gap beside a wall is very often a doorway, and a shut door is a wall, but the walk never tests
 * the tile it starts from, so what this tile holds is read here, by doors mode. NONE reads only the
 * turf's own opacity, even when check_contents is set, which is how playsound calls it. FLANKS
 * reads every opaque object on the tile, about 1 us on 5% of checks, the contents read measured at
 * 0.4 to 1.7 us. That was a bench, run warm under ideal conditions, which understates a cold live
 * read and may be out of date. LIVE and ALWAYS read the door count and loop only where it says a
 * door may stand.
 */
/proc/probe_open_path(turf/beside, turf/target, steps_allowed, check_contents = FALSE, doors = SOUND_DOORS_NONE)
	SHOULD_NOT_SLEEP(TRUE)
	// A wall to the side is not somewhere the sound could have come through either
	if(!beside || beside.opacity)
		return FALSE
	if(doors == SOUND_DOORS_FLANKS)
		for(var/atom/movable/thing as anything in beside)
			if(thing.opacity)
				return FALSE
	else if(doors >= SOUND_DOORS_LIVE && beside.sound_door_count > 0 && door_blocks_sound(beside, doors))
		return FALSE
	GLOB.occlusion_probe_walks++
	. = opacity_between(beside, target, steps_allowed, check_contents, null, doors) == OCCLUSION_CLEAR
	GLOB.occlusion_probe_tiles += GLOB.opacity_walk_tiles

/**
 * The full three-state answer: CLEAR, MUFFLED round a corner, or SOLID and properly enclosed.
 *
 * One walk when the line is clear, and up to two more when it is not. A caller wanting only "is
 * anything in the way" should call opacity_between() directly and save the probes. This is for
 * callers that treat a corner differently from a wall.
 *
 * Leaves GLOB.opacity_walk_tiles holding the DIRECT walk and the probe accumulators holding the
 * probes, so a caller pricing the work reads all three straight after rather than timing around it.
 * The direct count is restored deliberately, and the block position with it: the probes overwrite
 * both on their way past, and a caller measuring a leak wants the direct walk's block.
 */
/proc/sound_occlusion_grade(turf/listener_turf, turf/source_turf, steps_allowed, check_contents = FALSE, list/trace, doors = SOUND_DOORS_NONE)
	SHOULD_NOT_SLEEP(TRUE)
	GLOB.occlusion_probe_walks = 0
	GLOB.occlusion_probe_tiles = 0
	. = opacity_between(listener_turf, source_turf, steps_allowed, check_contents, trace, doors)
	if(. != OCCLUSION_SOLID)
		return
	// The probes overwrite the direct walk's result. See the proc doc
	var/direct_tiles = GLOB.opacity_walk_tiles
	var/block_x = GLOB.opacity_block_x
	var/block_y = GLOB.opacity_block_y
	var/from_x = GLOB.opacity_block_from_x
	var/from_y = GLOB.opacity_block_from_y
	if(has_open_path(source_turf, steps_allowed, check_contents, doors))
		. = OCCLUSION_MUFFLED
	GLOB.opacity_walk_tiles = direct_tiles
	GLOB.opacity_block_x = block_x
	GLOB.opacity_block_y = block_y
	GLOB.opacity_block_from_x = from_x
	GLOB.opacity_block_from_y = from_y

/**
 * What playsound_local should be told about one listener, from the caller's SOUND_TRAVEL_* class.
 *
 * SOUND_MUFFLE_NONE, SOFT or ENCLOSED, or NULL for "do not send". CARRYING is one opacity_between()
 * and anything on the line is SOFT. CONTAINED and LEAKING are ERP's and walk their own way, see
 * erp_muffle_for().
 *
 * The caller has already decided this listener is worth walking to: same floor, more than one
 * orthogonal step away, class not SOUND_TRAVEL_UNRESTRICTED. A diagonal neighbour passes that gate
 * and reads clear, the walk landing on the target at its first step, unless ERP audio has a window
 * or door on either tile, see erp_muffle_for(). Those gates stay in
 * playsound so the common case costs no proc call at all. Contents are read on the line, since a
 * one-shot recomputes from scratch and a door's state cannot freeze into it.
 *
 * The GLOB walk counters belong to the shared walkers; ERP does not update them.
 *
 * Arguments:
 * * seal_openings - soundproof ERP containment, including open doors and windows
 */
/proc/occlusion_muffle_for(turf/listener_turf, turf/source_turf, occlusion, steps_allowed, list/trace, seal_openings = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	if(occlusion == SOUND_TRAVEL_CARRYING)
		return (opacity_between(listener_turf, source_turf, steps_allowed, TRUE, trace) == OCCLUSION_CLEAR) ? SOUND_MUFFLE_NONE : SOUND_MUFFLE_SOFT
	if(occlusion == SOUND_TRAVEL_CONTAINED || occlusion == SOUND_TRAVEL_LEAKING)
		return erp_muffle_for(listener_turf, source_turf, steps_allowed, occlusion == SOUND_TRAVEL_LEAKING, seal_openings)
	return SOUND_MUFFLE_NONE

/**
 * Traces ERP audio directly to its source, returning a muffle level or null for "do not send".
 *
 * Open doors and windows pass sound at its normal range. LEAKING can cross one shut opening on
 * the first step from the listener, muffled and capped. Continue along that same line to reject
 * any further barrier. No corner probes or nearby-opening search run for ERP audio.
 *
 * A closed opening on either endpoint needs its own check because the walk skips its endpoints.
 * A source there is heard only within one tile; a listener there consumes the one allowed leak.
 * Adjacent endpoint exceptions match playsound's unwalked participants. An open doorway has no
 * such limit unless seal_openings is set for a soundproof source area.
 *
 * The stepping matches opacity_between(), but the walks stay separate to keep ERP's opening
 * policy off every tile checked by point ambience and sound tokens. Only counted opening tiles
 * need a live state lookup; an open window can override a transparent window-wall frame.
 *
 * Arguments:
 * * leaking - SOUND_TRAVEL_LEAKING rather than CONTAINED
 * * seal_openings - blocks open openings too and disables leakage for soundproof rooms
 */
/proc/erp_muffle_for(turf/listener_turf, turf/source_turf, steps_allowed, leaking, seal_openings = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!listener_turf || !source_turf || listener_turf.z != source_turf.z)
		return null
	if(seal_openings)
		leaking = FALSE
	var/muffled = SOUND_MUFFLE_NONE
	if(source_turf.sound_opening_count || listener_turf.sound_opening_count)
		var/source_blocked = source_turf.sound_opening_count && (seal_openings || sound_opening_blocks(source_turf))
		var/listener_blocked = listener_turf.sound_opening_count && (seal_openings || sound_opening_blocks(listener_turf))
		if(source_blocked || listener_blocked)
			if(get_dist(listener_turf, source_turf) <= 1)
				return leaking ? SOUND_MUFFLE_ENCLOSED : SOUND_MUFFLE_NONE
			if(!leaking || source_blocked)
				return null
			muffled = SOUND_MUFFLE_ENCLOSED
	var/x = listener_turf.x
	var/y = listener_turf.y
	var/z = listener_turf.z
	var/target_x = source_turf.x
	var/target_y = source_turf.y
	var/dx = abs(target_x - x)
	var/dy = -abs(target_y - y)
	if(!dx && !dy)
		return muffled
	var/step_x = (x < target_x) ? 1 : -1
	var/step_y = (y < target_y) ? 1 : -1
	var/err = dx + dy
	var/steps = 0
	while(TRUE)
		steps++
		if(steps > steps_allowed)
			return null
		var/e2 = err * 2
		if(e2 >= dy)
			err += dy
			x += step_x
		if(e2 <= dx)
			err += dx
			y += step_y
		if(x == target_x && y == target_y)
			return muffled
		var/turf/current = locate(x, y, z)
		if(!current || current.opacity)
			return null
		var/has_opening = current.sound_opening_count
		if(seal_openings && has_opening)
			return null
		var/shut_opening = has_opening ? sound_opening_blocks(current) : isclosedturf(current)
		if(shut_opening)
			if(!leaking || steps != 1 || muffled == SOUND_MUFFLE_ENCLOSED)
				return null
			muffled = SOUND_MUFFLE_ENCLOSED
		for(var/atom/thing as anything in current)
			if(!thing.opacity)
				continue
			if(!shut_opening || !isobj(thing))
				return null
			// Only the crossed opening may be opaque; other contents must still block the line.
			var/obj/opening = thing
			if(!opening.sound_opening)
				return null

/**
 * Whether any opening on this turf is acoustically shut.
 *
 * Callers check sound_opening_count first. Check all openings so an open gate or curtain cannot
 * hide a closed one sharing its tile. The same rule serves endpoints and walks.
 * Some maps put a window object over a transparent window-wall turf. Read the window's state
 * there instead of treating its frame as a second shut barrier. A frame without a window object
 * retains its containment rule; an open curtain alone must not override it.
 */
/proc/sound_opening_blocks(turf/checked)
	SHOULD_NOT_SLEEP(TRUE)
	var/frame_without_window = isclosedturf(checked)
	for(var/obj/opening in checked)
		if(!opening.sound_opening)
			continue
		if(opening.sound_opening_is_shut())
			return TRUE
		if(frame_without_window && istype(opening, /obj/structure/roguewindow))
			frame_without_window = FALSE
	return frame_without_window

/**
 * Whether this opening muffles ERP audio as a shut barrier.
 *
 * Transparent doors still shut solid, so density matters alongside opacity. Types whose open
 * state differs from these fields override this read-only check; it never changes collision.
 */
/obj/proc/sound_opening_is_shut()
	SHOULD_NOT_SLEEP(TRUE)
	return opacity || density

/// Gate blockers retain density when a vertical gate opens; opacity follows the gate's state.
/obj/gblock/sound_opening_is_shut()
	return opacity

/// An open or broken window is climbable but stays dense, so its sash state decides containment.
/obj/structure/roguewindow/sound_opening_is_shut()
	return opacity || !climbable
