/**
 * Selects and services the audible source in each category for one client.
 *
 * Consumes due clips, rejects muted listeners, resolves the hearing turf and self source, then
 * checks cached selection. An unchanged listener with no pending playback work returns before
 * preparing serving_* or clearing scratch state.
 *
 * Remaining services prepare listener context, resolve river reach and rank or reuse indexed
 * sources. single_clip_refresh limits work to one due non-occluded category when its source and
 * room still match. Otherwise categories handle mute, source loss, occlusion, handoffs and sends in
 * sequence.
 *
 * Occlusion may replace a winner with its runner-up in the listener's cache. That selection is
 * separate from the shared tile ranking and does not establish current acoustic validity. Losing
 * the hearing turf must still reach playback cleanup. River anchors update before send shortcuts,
 * and re-entry can resume an ordinary loop during its exit fade.
 */
/datum/controller/subsystem/point_ambience/proc/service_client(client/listener_client)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/point_ambience_listener/listener_state = listener_client.point_ambience
	var/list/due_clip_categories = listener_state.clip_due ? collect_due_clips(listener_client) : null
	// Reject muted clients before counting a service, including requests queued before they muted
	if(listener_state.silenced)
		metrics.muted_services_refused++
		return
	metrics.services_total++

	var/mob/listener = listener_client.mob
	var/turf/listener_turf
	var/atom/movable/ear = listener_state.ear
	if(listener && !isnewplayer(listener) && !isobserver(listener))
		listener_turf = get_turf(ear || listener)
	// A held torch belongs to the body and is audible only when the hearing anchor shares its turf
	var/atom/self_source = null
	if(listener_turf && (!ear || listener_turf == get_turf(listener)))
		self_source = listener.point_ambience_self_source
	// Restore ambience once the fast-movement timestamp expires
	if(!isnull(listener_state.speed_moved))
		if(world.time - listener_state.speed_moved < POINT_AMBIENCE_SPEED_STILL)
			speed_silence(listener_client, listener_turf, self_source)
			return
		listener_state.speed_moved = null
	listener_state.speed_silenced = FALSE

	var/list/nearest_by_category
	var/reuse_cached_sources = FALSE
	var/single_clip_refresh = FALSE
	var/datum/point_ambience_category/due_clip_category = (length(due_clip_categories) == 1) ? due_clip_categories[1] : null
	var/ambience_volume = null
	if(listener_turf)
		var/datum/preferences/prefs = listener_client.prefs
		ambience_volume = prefs ? POINT_AMBIENCE_VOLUME(prefs) : null
		if(POINT_AMBIENCE_STANDING_UNCHANGED(listener_state, listener_turf, ambience_volume))
			reuse_cached_sources = TRUE
			listener_state.cache_version = static_version
			// Unchanged categories need no work. serving_* is unprepared and may describe another client
			if(self_source == listener_state.cache_self)
				if(!length(due_clip_categories))
					metrics.shortcut_hits++
					return
				if(due_clip_category)
					var/atom/current_source = listener_state.sources[due_clip_category]
					single_clip_refresh = !due_clip_category.occlude && !ear && current_source \
						&& (due_clip_category == river_category ? current_source == listener_turf : listener_state.cache_static?[due_clip_category] == current_source)
		// Per service, not per walk: later paths may otherwise read another turf or client's runner-up
		runner_up_by_category.Cut()
		// A failed hearing preparation must reach category cleanup to stop existing playback
		if(!prepare_serving(listener_client, listener, listener_turf, ambience_volume))
			listener_turf = null
			self_source = null
			single_clip_refresh = FALSE

	var/muted_mask = listener_state.muted_mask
	var/river_cost
	if(listener_turf)
		if(!river_category.silenced && !(muted_mask & river_category.mask))
			var/river_mark = river_fill.marks[listener_turf]
			if(RIVER_FILL_AUDIBLE(river_mark))
				river_cost = RIVER_FILL_COST(river_mark)
		if(single_clip_refresh)
			var/datum/point_ambience_slot/clip_slot = listener_state.slots[due_clip_category.index]
			single_clip_refresh = clip_slot && clip_slot.environment == serving_environment
			if(due_clip_category == river_category && isnull(river_cost))
				single_clip_refresh = FALSE
		// A due clip can force ranking without counting as a standing-cache miss
		var/clip_forced_ranking = FALSE
		if(length(due_clip_categories) && !single_clip_refresh)
			clip_forced_ranking = reuse_cached_sources
			reuse_cached_sources = FALSE
		if(reuse_cached_sources)
			nearest_by_category = listener_state.cache_static
		else
			if(in_standing_walk && !clip_forced_ranking)
				count_standing_walk_miss(listener_client, listener_turf)
			metrics.services_ranked++
			nearest_by_category = nearest_sources(listener_turf, listener_client)
			listener_state.cache_turf = listener_turf
			listener_state.cache_version = static_version
			listener_state.cache_volume = ambience_volume
	if(!listener_turf)
		listener_state.cache_turf = null
	listener_state.cache_self = self_source
	var/list/selected_sources = listener_state.sources
	var/nothing_answered = isnull(river_cost) && !length(nearest_by_category)
	if(nothing_answered && !length(selected_sources) && !self_source)
		if(!in_standing_walk)
			metrics.moving_silent++
		return

	var/list/category_slots = listener_state.slots
	for(var/datum/point_ambience_category/category as anything in categories)
		if(single_clip_refresh && category != due_clip_category)
			continue
		var/clip_advance = due_clip_categories && (category in due_clip_categories)
		var/atom/selected_source
		serving_muffle_wall = FALSE
		// Mute and expired-clip source loss stop immediately. Ordinary range or occlusion loss
		// fades
		var/category_muted = category.silenced || (muted_mask & category.mask)
		var/is_river = category == river_category
		if(category_muted)
			selected_source = null
		else if(is_river)
			// The hearing turf carries playback state, since river water is not in the source index
			selected_source = isnull(river_cost) ? null : listener_turf
		else if(self_source && category == self_category)
			selected_source = self_source
		else
			selected_source = nearest_by_category?[category]
			// Store the occlusion-selected winner for later standing services
			if(selected_source)
				var/atom/audible_source = unoccluded_source(selected_source, category)
				if(!audible_source)
					nearest_by_category -= category
				else if(audible_source != selected_source)
					nearest_by_category[category] = audible_source
				selected_source = audible_source

		var/atom/previous_source = selected_sources[category]
		if(!selected_source)
			if(!previous_source)
				continue
			if(category_muted || clip_advance || (is_river && previous_source.z != listener_turf?.z))
				stop_for(listener_client, category)
			else
				fade_out(listener_client, category, listener_turf)
			continue
		if(is_river && previous_source && previous_source.z != listener_turf.z)
			// A floor change ends this stretch before starting the destination floor's river
			stop_for(listener_client, category)
			previous_source = null
		var/had_previous = !!previous_source
		var/source_changed = is_river ? !had_previous : (selected_source != previous_source)
		var/centre_handoff = FALSE
		var/datum/point_ambience_slot/slot
		if(is_river)
			slot = slot_for(listener_client, category.index)
			// Update before either shortcut. Otherwise a long bank walk leaves a distant fade anchor
			selected_sources[category] = selected_source
			slot.source_turf = listener_turf
			var/river_playback_is_steady = had_previous && !clip_advance && !slot.fade_next && !serving_muffle_head
			var/river_inputs_unchanged = river_playback_is_steady && !isnull(listener_state.river_cost) && listener_state.river_cost == river_cost \
				&& listener_state.river_scale == serving_volume_scale && listener_state.river_version == static_version \
				&& slot.environment == serving_environment
			if(river_inputs_unchanged)
				continue
		if(source_changed)
			selected_sources[category] = selected_source
			if(previous_source)
				centre_handoff = category.centre_handoff
			// Resume a still-playing exit fade without restarting an ordinary loop. Clip sets
			// restart
			if(!had_previous && !category.files)
				var/datum/point_ambience_slot/fade_slot = LAZYACCESS(category_slots, category.index)
				if(fade_slot?.fade_next && isnull(fade_slot.fade_target))
					had_previous = TRUE
		else if(!is_river && reuse_cached_sources && !clip_advance)
			continue
		// A torch in hand is at distance 0 and centred, so only the room, muffle and volume change it
		else if(!clip_advance && selected_source == self_source && self_send_unchanged(listener_client, category, selected_source))
			continue

		// Set the current runner-up before pan_lean() reads it during the send
		if(!slot)
			slot = slot_for(listener_client, category.index)
		if(!single_clip_refresh)
			slot.runner_up = runner_up_by_category[category]
		metrics.sends_total++
		var/target_volume = slim_send(listener, listener_client, category, selected_source, source_changed, had_previous, FALSE, slot, clip_advance, centre_handoff, river_cost)
		if(is_river)
			listener_state.river_cost = serving_muffle_head ? null : river_cost
			listener_state.river_scale = serving_volume_scale
			listener_state.river_version = static_version
		// A refused send must stop existing playback, including a failed source handoff
		if(!target_volume)
			stop_for(listener_client, category, send_null = had_previous)

/// Counts a standing-cache miss caused by changed hearing turf, source revision or volume
/datum/controller/subsystem/point_ambience/proc/count_standing_walk_miss(client/listener_client, turf/listener_turf)
	PRIVATE_PROC(TRUE)
	if(listener_turf != listener_client.point_ambience.cache_turf)
		metrics.standing_walk_miss_turf++
	else if(static_version != listener_client.point_ambience.cache_version)
		metrics.standing_walk_miss_version++
	else
		metrics.standing_walk_miss_volume++

/**
 * Prepares hearing, environment, volume and enclosure state for one listener's sends.
 *
 * Returns TRUE with usable serving_* fields, or FALSE without a valid context. Call only after the
 * standing shortcut, and consume the context before preparing another listener. service_client()
 * resets wall muffling for each category.
 *
 * can_hear() is cached until profile_until. Unchanged standing listeners do not refresh it. An
 * active service refreshes an expired profile. Turf, area, enclosure and volume are resolved for
 * each prepared service. A null volume means no preference scaling. Zero prevents playback.
 */
/datum/controller/subsystem/point_ambience/proc/prepare_serving(client/listener_client, mob/listener, turf/listener_turf, ambience_volume = null)
	SHOULD_NOT_SLEEP(TRUE)
	var/datum/point_ambience_listener/listener_state = listener_client.point_ambience
	if(world.time >= listener_state.profile_until)
		listener_state.profile_until = world.time + standing_walk_interval
		listener_state.hearing = listener.can_hear()
	if(!listener_state.hearing)
		return FALSE
	// Null means no supplied volume. Explicit zero means muted
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
	// Reset per-service muffling so a previous listener's state cannot carry over
	serving_muffle_wall = FALSE
	// Only detached hearing needs the enclosure chain checked
	serving_muffle_head = FALSE
	var/atom/movable/ear = listener_state.ear
	if(ear)
		var/atom/holder = ear.loc
		while(holder && !isturf(holder))
			if(istype(holder, /obj/structure/closet) || istype(holder, /obj/item/storage))
				serving_muffle_head = TRUE
				break
			holder = holder.loc
	var/area/listener_area = listener_turf.loc
	var/area_environment = listener_area?.soundenv
	serving_environment = (area_environment && area_environment != SOUND_ENVIRONMENT_NONE) ? area_environment : SOUND_DEFAULT_ENVIRONMENT
	serving_volume_scale = volume_scale
	return TRUE

/// Whether a carried source's send matches its slot exactly. Distance and pan are held at zero
/// on one, so only the volume scale, the area environment and the muffle can change it
/datum/controller/subsystem/point_ambience/proc/self_send_unchanged(client/listener_client, datum/point_ambience_category/category, atom/source)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/list/slots = listener_client.point_ambience.slots
	var/datum/point_ambience_slot/slot = LAZYACCESS(slots, category.index)
	if(!slot || slot.environment != serving_environment)
		return FALSE
	if(serving_muffle_wall || serving_muffle_head)
		return FALSE
	var/target_volume = category.volume * (category.source_volumes[source] || 1)
	if(!isnull(serving_volume_scale))
		target_volume *= serving_volume_scale
	return slot.last_volume == min(target_volume, 100)

/**
 * Returns a source's OCCLUSION_* grade for diagnostics, optionally recording the traced turfs.
 *
 * Uses the same guards and corner grading as live selection in unoccluded_source(). Door policy
 * controls live contents checks. Nearby door changes invalidate stationary listener selections.
 *
 * Arguments:
 * * trace - receives the turfs crossed by the direct line
 */
/datum/controller/subsystem/point_ambience/proc/source_occluded(turf/source_turf, turf/listener_turf, datum/point_ambience_category/category, list/trace)
	if(!category.occlude || source_turf == listener_turf || source_turf.z != listener_turf.z)
		return OCCLUSION_CLEAR
	. = sound_occlusion_grade(listener_turf, source_turf, category.range, FALSE, trace, door_mode)
	count_occlusion_walk()

/// Adds the last direct trace and its corner-probe count to point-ambience metrics
/datum/controller/subsystem/point_ambience/proc/count_occlusion_walk()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	metrics.occlusion_checks_total += 1 + GLOB.occlusion_probe_walks

/**
 * Returns the nearest audible winner or runner-up, or null if neither has an open path.
 *
 * Grades after distance ranking, limiting checks to at most two sources per category. A blocked
 * winner must not hide an audible runner-up. Same-turf sources and categories without occlusion
 * bypass tracing. Cross-floor sends use the separate storey rule.
 *
 * Enclosed point ambience does not use one-shot leakage. A leaking nearest loop could occupy the
 * category's single channel indefinitely and displace another source with an audible path. River
 * barriers are resolved by the fill instead.
 */
/datum/controller/subsystem/point_ambience/proc/unoccluded_source(atom/nearest, datum/point_ambience_category/category)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	RETURN_TYPE(/atom)
	if(!category.occlude)
		return nearest
	var/turf/source_turf = source_turfs[nearest] || get_turf(nearest)
	if(!source_turf || source_turf == serving_turf || source_turf.z != serving_turf.z)
		return nearest
	if(grade_from_listener(source_turf, category.range) != OCCLUSION_SOLID)
		return nearest
	var/atom/runner_up = runner_up_by_category[category]
	if(!runner_up || runner_up == nearest)
		metrics.runner_up_silenced++
		return null
	var/turf/runner_up_turf = source_turfs[runner_up] || get_turf(runner_up)
	if(!runner_up_turf)
		metrics.runner_up_silenced++
		return null
	// Same-turf sources need no trace. Cross-floor attenuation is handled by the send path
	if(runner_up_turf == serving_turf || runner_up_turf.z != serving_turf.z)
		return runner_up
	if(grade_from_listener(runner_up_turf, category.range) == OCCLUSION_SOLID)
		metrics.runner_up_silenced++
		return null
	return runner_up

/// Grades a source from serving_turf, records trace counts and sets the category's corner-muffle
/// flag
/datum/controller/subsystem/point_ambience/proc/grade_from_listener(turf/source_turf, range)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	. = sound_occlusion_grade(serving_turf, source_turf, range, FALSE, null, door_mode)
	// Read probe counters before another trace overwrites them
	count_occlusion_walk()
	if(. == OCCLUSION_MUFFLED)
		serving_muffle_wall = TRUE
