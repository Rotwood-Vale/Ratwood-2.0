/**
 * Finds and sends the nearest audible source in each category for one client.
 *
 * Queued movement, periodic standing walks and clip timers can call service_client().
 * POINT_AMBIENCE_STANDING_UNCHANGED lets a listener reuse point_ambience_cache_static instead of
 * ranking again. A due clip in a category without occlusion can take the clip_only path and update
 * just that category when the cached source and room still match.
 *
 * Occlusion runs before slim_send() because a wall can change the winning source. The resolved
 * winner is written back to point_ambience_cache_static for standing services, which still grade
 * it against the current walls.
 */
/datum/controller/subsystem/point_ambience/proc/service_client(client/listener_client)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/clip_advances = listener_client.point_ambience_clip_due ? collect_due_clips(listener_client) : null
	// Before the count, so they stay out of the rates. With no move hook and the walk passing them,
	// only a listener queued just before muting arrives here
	if(listener_client.point_ambience_silenced)
		muted_services_refused++
		return
	services_total++
	sends_this_service = 0
	rebuilt_this_service = FALSE
	ranked_candidates_this_service = null
	occlusion_checks_this_service = 0
	occlusion_tiles_this_service = 0
	var/mob/listener = listener_client.mob
	var/turf/listener_turf
	// A headless dullahan hears from the head, kept current by the watch, null for everyone else
	var/atom/movable/ear = listener_client.point_ambience_ear
	// Observers are skipped by the tick and stopped at login. This catches any that arrive
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
	var/ambience_volume = null
	if(listener_turf)
		var/datum/preferences/prefs = listener_client.prefs
		ambience_volume = prefs ? POINT_AMBIENCE_VOLUME(prefs) : null
		if(POINT_AMBIENCE_STANDING_UNCHANGED(listener_client, listener_turf, ambience_volume))
			standing = TRUE
			listener_client.point_ambience_cache_version = static_version
			// Every category below would return unchanged, so skip the loop. Returns WITHOUT preparing,
			// so the serving_* vars still describe the last client served and nothing may read them
			if(self_source == listener_client.point_ambience_cache_self)
				if(!length(clip_advances))
					shortcut_hits++
					return
				if(clip_category)
					var/atom/current_source = listener_client.point_ambience_sources[clip_category]
					clip_only = !clip_category.occlude && !ear && current_source \
						&& listener_client.point_ambience_cache_static?[clip_category] == current_source
		// Per service, not per walk: later paths may otherwise read another turf or client's runner-up
		runner_up_by_category.Cut()
		// After the shortcut, so an unchanged listener prepares only for a due clip or a changed
		// torch. One who cannot be served counts as having no turf, which stops everything playing
		if(!prepare_serving(listener_client, listener, listener_turf, ambience_volume))
			listener_turf = null
			self_source = null
			clip_only = FALSE
	if(listener_turf)
		if(clip_only)
			var/list/clip_slot = listener_client.point_ambience_slots[clip_category.index]
			clip_only = clip_slot && clip_slot[POINT_AMBIENCE_SLOT_ENVIRONMENT] == serving_environment
		// A due clip walks a standing listener afresh, which is not a shortcut miss and is not counted as one
		var/clip_forced_walk = FALSE
		if(length(clip_advances) && !clip_only)
			clip_forced_walk = standing
			standing = FALSE
		if(standing)
			nearest_by_category = listener_client.point_ambience_cache_static
		else
			if(in_standing_walk && !clip_forced_walk)
				count_standing_walk_miss(listener_client, listener_turf)
			services_ranked++
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
	// Nothing answered, nothing playing and no torch in hand leaves the loop below nothing to do
	if(!self_source && !length(nearest_by_category) && !length(sources))
		if(!in_standing_walk)
			moving_silent++
		return
	var/muted_mask = listener_client.point_ambience_muted_mask
	var/list/fade_slots = listener_client.point_ambience_slots
	for(var/datum/point_ambience_category/category as anything in categories)
		if(clip_only && category != clip_category)
			continue
		var/clip_advance = clip_advances && (category in clip_advances)
		var/atom/nearest
		var/by_wall = FALSE
		serving_muffle_wall = FALSE
		// A category switched off, or one whose due clip has no source, stops at once. Any other loss
		// is the listener having moved out of range or behind a wall, and that fades
		var/switched_off = category.silenced || (muted_mask & category.mask)
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
				if(!clear_source)
					nearest_by_category -= category
					by_wall = TRUE
				else if(clear_source != nearest)
					nearest_by_category[category] = clear_source
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
			// restarting it, which matters past pillars. A clip set restarts
			if(!had_previous && !category.files && length(fade_slots) >= category.index)
				var/list/fade_slot = fade_slots[category.index]
				if(fade_slot?[POINT_AMBIENCE_SLOT_FADE_NEXT] && isnull(fade_slot[POINT_AMBIENCE_SLOT_FADE_TARGET]))
					had_previous = TRUE
					fade_takeovers++
		// A standing listener's unchanged source would get the same numbers as last time. Nothing
		// reaches here having moved: a move within a listener's reach ends their standing
		else if(standing && !clip_advance)
			continue
		// A torch in hand is at distance 0 and centred, so only the room, muffle and volume change it
		else if(!clip_advance && nearest == self_source && self_send_unchanged(listener_client, category, nearest))
			continue
		// Who this category would fall to, BEFORE the send: the pan blend reads it during one and
		// would otherwise lean on the last service's. A failed send drops the category from sources
		var/list/slot = slot_for(listener_client, category.index)
		if(!clip_only)
			slot[POINT_AMBIENCE_SLOT_RUNNER_UP] = runner_up_by_category[category]
		var/sent
		sends_this_service++
		sends_total++
		sent = slim_send(listener, listener_client, category, nearest, fresh, had_previous, FALSE, slot, clip_advance, centre)
		// Nothing usable was sent, so null what was playing or it repeats client-side at a stale
		// volume. Keyed on what was playing, not fresh: a failed switch must still silence it
		if(!sent)
			stop_for(listener_client, category, send_null = had_previous)

/**
 * Takes every clip that came due off the client's slots, returning the categories still playing
 * whose clip must advance, or null.
 *
 * A deferred timer still waiting on one is cancelled, this service being the one it waited for.
 */
/datum/controller/subsystem/point_ambience/proc/collect_due_clips(client/listener_client)
	PRIVATE_PROC(TRUE)
	var/list/due
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
			LAZYADD(due, due_category)
	return due

/// Counts why a standing walk visit missed the shortcut and walked: its turf, the index or its
/// volume changed
/datum/controller/subsystem/point_ambience/proc/count_standing_walk_miss(client/listener_client, turf/listener_turf)
	PRIVATE_PROC(TRUE)
	if(listener_turf != listener_client.point_ambience_cache_turf)
		standing_walk_miss_turf++
	else if(static_version != listener_client.point_ambience_cache_version)
		standing_walk_miss_version++
	else
		standing_walk_miss_volume++

/**
 * Resolves what every send in one service needs from the listener, once.
 *
 * Whether they can hear at all, a chain of procs and an organ slot read on a carbon, is held on the
 * client for one standing_walk_interval. Turf, area environment, whether their ear is shut inside
 * something and their point ambience volume are per service, and a caller that already has the turf
 * passes it.
 *
 * Runs after the standing shortcut, never before it: a listener standing still pays nothing here,
 * and one who goes deaf while standing keeps what is playing until a service passes the shortcut
 * after the hearing cache expires. A step, index change or volume change before expiry can still
 * reuse the old hearing result.
 *
 * Returns TRUE with serving_turf, serving_environment, serving_indoors, serving_volume_scale and
 * the muffle flags prepared for this listener. FALSE leaves no usable context, even if fields still
 * hold values from a previous call. A caller must consume the context before preparing another
 * listener. service_client() resets serving_muffle_wall before grading each category.
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
	serving_indoors = A && !A.outdoors && !A.river_underground
	serving_environment = (A && A.soundenv && A.soundenv != SOUND_ENVIRONMENT_NONE) ? A.soundenv : SOUND_DEFAULT_ENVIRONMENT
	// No prefs leaves this null, so no scaling. A zero never gets here, having returned above
	serving_volume_scale = volume_scale
	return TRUE

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
 * How a wall between source and listener grades a send, as an OCCLUSION_* value.
 *
 * OCCLUSION_CLEAR, OCCLUSION_MUFFLED round a corner, or OCCLUSION_SOLID. For check_sound_area. The
 * live path grades through unoccluded_source(), which shares the walk and these
 * guards, occlude_sources aside, and leaves out the trace.
 *
 * A cut-down can_see(), reading turf opacity and doors, plus under FLANKS every opaque object on a
 * corner probe's first tile. Doors are objects where
 * walls are turfs, so a turf's contents are looped only where its sound_door_count says one may
 * stand. A listener standing still never re-sends an unchanged static source, so a door's state
 * would freeze into the sound until they moved. recheck_doors() serves them again when one changes.
 *
 * Arguments:
 * * trace - filled with the turfs the line crossed, for a caller to print
 */
/datum/controller/subsystem/point_ambience/proc/source_occluded(turf/source_turf, turf/listener_turf, datum/point_ambience_category/category, list/trace)
	if(!occlude_sources || !category.occlude || source_turf == listener_turf || source_turf.z != listener_turf.z)
		return OCCLUSION_CLEAR
	// Graded rather than a bare walk, or this reports SOLID for a source the service is serving muffled
	. = sound_occlusion_grade(listener_turf, source_turf, category.range, FALSE, trace, door_mode)
	count_occlusion_walk()

/**
 * Folds what the last sound_occlusion_grade() cost into this service's totals.
 *
 * That is one direct walk plus however many probes it needed. The walk and its probes are plain
 * procs shared with the one-shot path, and the walk with the token too, so they cannot count into
 * a service themselves.
 */
/datum/controller/subsystem/point_ambience/proc/count_occlusion_walk()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/walks = 1 + GLOB.occlusion_probe_walks
	occlusion_checks_this_service += walks
	occlusion_checks_total += walks
	occlusion_tiles_this_service += GLOB.opacity_walk_tiles + GLOB.occlusion_probe_tiles

/**
 * The nearest source of a category that is not behind a wall, or null.
 *
 * The winner where it is clear, the walk's runner-up where the winner is blocked and the runner-up
 * is not, and null where both are. Null fades the category out, which is the point, a wall stopping
 * the sound rather than dulling it.
 *
 * Runs ONCE per category per service, on the source that already won, never during the walk, whose
 * inner loop runs once per candidate. Checking after selection means a blocked source would hold
 * the channel and cut off a campfire you can see, so this falls through to the walk's runner-up,
 * stopping at one. A different floor is never graded: the walk is 2D and returns CLEAR across
 * floors, and the send's storey rule muffles those sources instead.
 *
 * NO LEAK HERE, DELIBERATELY. playsound's SOUND_TRAVEL_LEAKING lets an enclosed listener hear a
 * one-shot faintly just past a window or door, and that is right for a one-shot and wrong for a
 * loop. A hearth leaking at a fixed volume past every window in a town is a permanent drone, and
 * since only the nearest source per category is served it would be a GHOST of a fire nobody can
 * reach, displacing the runner-up below, which is a real one with a real path to it. It would also
 * turn silence into a send on the one system billed per moving listener.
 *
 * The two states a category actually wants both exist: walls stop it, or `occlude = FALSE` and
 * walls do not apply (the river). If one ever wants the third, it is a `category.leak` flag
 * evaluated AFTER the runner-up fails, so a clear source always wins. Wait for a category to ask.
 */
/datum/controller/subsystem/point_ambience/proc/unoccluded_source(atom/nearest, datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/atom)
	// The same guards as source_occluded(), except occlude_sources, which the caller checks
	if(!category.occlude)
		return nearest
	var/turf/source_turf = source_turfs[nearest] || get_turf(nearest)
	if(!source_turf || source_turf == serving_turf || source_turf.z != serving_turf.z)
		return nearest
	if(grade_from_listener(source_turf, category.range) != OCCLUSION_SOLID)
		return nearest
	runner_up_offered++
	var/atom/runner_up = runner_up_by_category[category]
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
