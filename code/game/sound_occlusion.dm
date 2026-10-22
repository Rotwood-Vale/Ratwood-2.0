/*
 * Sound occlusion checks the path between a listener and a source.
 *
 * Callers use different policies:
 *   SSpoint_ambience   grades turf opacity and configured door checks. Enclosed sources fade out.
 *                     Door counts avoid contents scans on empty tiles. A door change queues nearby
 *                     listeners because the standing shortcut could otherwise reuse an old answer.
 *   /datum/sound_token checks turf contents too, including doors, when either side moves. Door
 *                     changes alone do not refresh a token whose source and listener stay still.
 *   playsound()       selects a SOUND_TRAVEL_* class per call and checks contents for each shot.
 *                     occlusion_muffle_for() chooses the muffling policy for that class.
 *
 * Volume changes stay in playsound_local and slim_send. Keep their corresponding muffling rules
 * aligned when editing either. The small calculation stays inline to avoid an extra call for each
 * listener receiving a sound.
 */

/**
 * Coordinates of the last direct obstruction and the tile immediately preceding it.
 *
 * Valid only after opacity_between() returns OCCLUSION_SOLID. Corner probes use these coordinates
 * to find flanks beside the blocking step. Copy them before another trace overwrites them.
 */
GLOBAL_VAR_INIT(opacity_block_x, 0)
GLOBAL_VAR_INIT(opacity_block_y, 0)
GLOBAL_VAR_INIT(opacity_block_from_x, 0)
GLOBAL_VAR_INIT(opacity_block_from_y, 0)

/// Walks made by the last has_open_path(), up to two. Read before another probe overwrites it
GLOBAL_VAR_INIT(occlusion_probe_walks, 0)

/**
 * Traces a straight line between two turfs and returns OCCLUSION_CLEAR or OCCLUSION_SOLID.
 *
 * Stops at the first opaque intermediate tile. This tests only the direct line. A blocked line
 * cannot distinguish an enclosed source from one audible around a corner. has_open_path() probes
 * the obstruction's flanks, and sound_occlusion_grade() combines both checks.
 *
 * Uses Bresenham stepping rather than can_see()'s get_step_towards: that goes through get_dir,
 * which returns a compound direction whenever both deltas are non-zero, so it steps diagonally until
 * one axis runs out and then straight along the other. From (0,0) to (5,1) it walks y=1 the whole
 * way and never touches (2,0) or (3,0), which is where a wall between the two actually stands.
 * Shallow angles expose this difference and are common indoors.
 *
 * walk_x and walk_y track the current tile. delta_x is the absolute X span. negative_delta_y is
 * the negated Y span used by this form of Bresenham's algorithm. line_error accumulates how far
 * the walk deviates from the line. Both axis decisions use the same doubled_error before either
 * changes line_error, so do not combine them into an if/else or recalculate between them.
 * Neither endpoint is tested. previous_x and previous_y identify the approach to an obstruction
 * so corner probes can choose the correct flank tiles.
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
 * Exceeding steps_allowed also records a block position. Otherwise a SOLID result would expose
 * coordinates left by an earlier call. It records the current tile as both the block and its
 * approach, so has_open_path() uses perpendicular flanks when no blocking step was taken.
 */
/proc/opacity_between(turf/start, turf/target, steps_allowed, check_contents = FALSE, list/trace, doors = SOUND_DOORS_NONE)
	if(!start || !target || start.z != target.z)
		return OCCLUSION_CLEAR
	var/walk_x = start.x
	var/walk_y = start.y
	var/walk_z = start.z
	var/target_x = target.x
	var/target_y = target.y
	var/delta_x = abs(target_x - walk_x)
	var/negative_delta_y = -abs(target_y - walk_y)
	if(!delta_x && !negative_delta_y)
		return OCCLUSION_CLEAR
	var/step_x = (walk_x < target_x) ? 1 : -1
	var/step_y = (walk_y < target_y) ? 1 : -1
	var/line_error = delta_x + negative_delta_y
	var/steps_taken = 0
	var/check_doors = doors >= SOUND_DOORS_LIVE
	. = OCCLUSION_CLEAR
	while(TRUE)
		steps_taken++
		if(steps_taken > steps_allowed)
			GLOB.opacity_block_x = walk_x
			GLOB.opacity_block_y = walk_y
			GLOB.opacity_block_from_x = walk_x
			GLOB.opacity_block_from_y = walk_y
			. = OCCLUSION_SOLID
			break

		var/doubled_error = line_error * 2
		var/previous_x = walk_x
		var/previous_y = walk_y
		if(doubled_error >= negative_delta_y)
			line_error += negative_delta_y
			walk_x += step_x
		if(doubled_error <= delta_x)
			line_error += delta_x
			walk_y += step_y
		if(walk_x == target_x && walk_y == target_y)
			break

		var/turf/checked_turf = locate(walk_x, walk_y, walk_z)
		if(!checked_turf)
			break
		if(trace)
			trace += checked_turf
		var/blocks_line = checked_turf.opacity
		if(!blocks_line && check_contents)
			for(var/atom/obstacle as anything in checked_turf)
				if(obstacle.opacity)
					blocks_line = TRUE
					break
		else if(!blocks_line && check_doors && checked_turf.sound_door_count > 0)
			blocks_line = door_blocks_sound(checked_turf, doors)
		if(blocks_line)
			GLOB.opacity_block_x = walk_x
			GLOB.opacity_block_y = walk_y
			GLOB.opacity_block_from_x = previous_x
			GLOB.opacity_block_from_y = previous_y
			. = OCCLUSION_SOLID
			break

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
		var/open_or_opening = mineral.door_opened || mineral.isSwitchingStates
		var/shuts_solid = !mineral.windowed && !mineral.brokenstate && initial(mineral.opacity)
		if(open_or_opening && shuts_solid)
			return TRUE
	return FALSE

/**
 * Whether a blocked line has a way round it, which is what separates a corner from an enclosure.
 *
 * Probes beside the obstruction. Where a diagonal step lands on a wall, the two tiles it cut
 * between are where the corner opens, and they can be nowhere near the listener. Probing
 * beside the listener misses a fire in plain view round a corner. Where the step was straight on,
 * the sideways neighbours of the blocking tile stand in: a lone pillar has open ground either side,
 * a wall run does not.
 *
 * Each open flank still needs a trace to the source. An open tile on the listener's side of a wall
 * does not establish a path to the other side. Accepting it without tracing would let sound cross
 * a straight wall approached diagonally.
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
	var/block_x = GLOB.opacity_block_x
	var/block_y = GLOB.opacity_block_y
	var/approach_x = GLOB.opacity_block_from_x
	var/approach_y = GLOB.opacity_block_from_y
	var/source_z = target.z
	if(block_x != approach_x && block_y != approach_y)
		if(probe_open_path(locate(block_x, approach_y, source_z), target, steps_allowed, check_contents, doors))
			return TRUE
		return probe_open_path(locate(approach_x, block_y, source_z), target, steps_allowed, check_contents, doors)

	// Straight on, so step sideways past the obstruction
	var/flank_dx = (block_y == approach_y) ? 0 : 1
	var/flank_dy = (block_y == approach_y) ? 1 : 0
	if(probe_open_path(locate(block_x + flank_dx, block_y + flank_dy, source_z), target, steps_allowed, check_contents, doors))
		return TRUE
	return probe_open_path(locate(block_x - flank_dx, block_y - flank_dy, source_z), target, steps_allowed, check_contents, doors)

/**
 * Checks a flank tile and traces from it to the source for has_open_path().
 *
 * The trace excludes its origin, so the flank needs a separate obstruction check. NONE checks turf
 * opacity only. FLANKS also checks opaque contents. LIVE and ALWAYS inspect doors only where the
 * turf's door count is nonzero.
 *
 * Each flank is passed separately to avoid allocating a list of probe origins.
 */
/proc/probe_open_path(turf/beside, turf/target, steps_allowed, check_contents = FALSE, doors = SOUND_DOORS_NONE)
	SHOULD_NOT_SLEEP(TRUE)
	if(!beside || beside.opacity)
		return FALSE
	if(doors == SOUND_DOORS_FLANKS)
		for(var/atom/movable/obstacle as anything in beside)
			if(obstacle.opacity)
				return FALSE
	else if(doors >= SOUND_DOORS_LIVE && beside.sound_door_count > 0 && door_blocks_sound(beside, doors))
		return FALSE
	GLOB.occlusion_probe_walks++
	. = opacity_between(beside, target, steps_allowed, check_contents, null, doors) == OCCLUSION_CLEAR

/**
 * Returns CLEAR for a direct path, MUFFLED for an open corner probe, or SOLID if neither passes.
 *
 * One walk when the line is clear, and up to two more when it is not. A caller wanting only "is
 * anything in the way" should call opacity_between() directly and save the probes. This is for
 * callers that treat a corner differently from a wall.
 *
 * Leaves occlusion_probe_walks holding the number of extra walks. The direct block position is
 * restored after probing, since the probes overwrite it and callers can still need that obstruction.
 */
/proc/sound_occlusion_grade(turf/listener_turf, turf/source_turf, steps_allowed, check_contents = FALSE, list/trace, doors = SOUND_DOORS_NONE)
	SHOULD_NOT_SLEEP(TRUE)
	GLOB.occlusion_probe_walks = 0
	. = opacity_between(listener_turf, source_turf, steps_allowed, check_contents, trace, doors)
	if(. != OCCLUSION_SOLID)
		return
	var/direct_block_x = GLOB.opacity_block_x
	var/direct_block_y = GLOB.opacity_block_y
	var/direct_previous_x = GLOB.opacity_block_from_x
	var/direct_previous_y = GLOB.opacity_block_from_y
	if(has_open_path(source_turf, steps_allowed, check_contents, doors))
		. = OCCLUSION_MUFFLED
	GLOB.opacity_block_x = direct_block_x
	GLOB.opacity_block_y = direct_block_y
	GLOB.opacity_block_from_x = direct_previous_x
	GLOB.opacity_block_from_y = direct_previous_y

/**
 * Returns the muffling level for a travel class, or null when sound must not be sent.
 *
 * CARRYING uses a direct opacity trace and returns SOFT when blocked. CONTAINED and LEAKING use
 * erp_muffle_for().
 *
 * Callers handle the unrestricted, adjacent and cross-floor cases before entering this proc. ERP
 * tracing does not update the shared opacity-walk counters.
 *
 * Arguments:
 * * seal_openings - Treats open doors and windows as barriers for soundproof ERP containment.
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
 * As in opacity_between(), both axis tests use doubled_error from before either axis advances.
 * muffle_level records whether the single permitted leak has already been used, so a second
 * shut opening must reject the listener even if the first was on an endpoint.
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
	var/muffle_level = SOUND_MUFFLE_NONE
	if(source_turf.sound_opening_count || listener_turf.sound_opening_count)
		var/source_blocked = source_turf.sound_opening_count && (seal_openings || sound_opening_blocks(source_turf))
		var/listener_blocked = listener_turf.sound_opening_count && (seal_openings || sound_opening_blocks(listener_turf))
		if(source_blocked || listener_blocked)
			if(get_dist(listener_turf, source_turf) <= 1)
				return leaking ? SOUND_MUFFLE_ENCLOSED : SOUND_MUFFLE_NONE
			if(!leaking || source_blocked)
				return null
			muffle_level = SOUND_MUFFLE_ENCLOSED

	var/walk_x = listener_turf.x
	var/walk_y = listener_turf.y
	var/walk_z = listener_turf.z
	var/target_x = source_turf.x
	var/target_y = source_turf.y
	var/delta_x = abs(target_x - walk_x)
	var/negative_delta_y = -abs(target_y - walk_y)
	if(!delta_x && !negative_delta_y)
		return muffle_level
	var/step_x = (walk_x < target_x) ? 1 : -1
	var/step_y = (walk_y < target_y) ? 1 : -1
	var/line_error = delta_x + negative_delta_y
	var/steps_taken = 0
	while(TRUE)
		steps_taken++
		if(steps_taken > steps_allowed)
			return null

		var/doubled_error = line_error * 2
		if(doubled_error >= negative_delta_y)
			line_error += negative_delta_y
			walk_x += step_x
		if(doubled_error <= delta_x)
			line_error += delta_x
			walk_y += step_y
		if(walk_x == target_x && walk_y == target_y)
			return muffle_level

		var/turf/checked_turf = locate(walk_x, walk_y, walk_z)
		if(!checked_turf || checked_turf.opacity)
			return null
		var/has_opening = checked_turf.sound_opening_count
		if(seal_openings && has_opening)
			return null
		var/shut_opening = has_opening ? sound_opening_blocks(checked_turf) : isclosedturf(checked_turf)
		if(shut_opening)
			if(!leaking || steps_taken != 1 || muffle_level == SOUND_MUFFLE_ENCLOSED)
				return null
			muffle_level = SOUND_MUFFLE_ENCLOSED

		for(var/atom/obstacle as anything in checked_turf)
			if(!obstacle.opacity)
				continue
			if(!shut_opening || !isobj(obstacle))
				return null
			// Only the crossed opening may be opaque; other contents must still block the line.
			var/obj/opening = obstacle
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
