/// Cancels the clip timer a slot holds, if it holds one, and forgets it
#define CANCEL_CLIP_TIMER(slot) if(slot[POINT_AMBIENCE_SLOT_TIMER]) { deltimer(slot[POINT_AMBIENCE_SLOT_TIMER]); slot[POINT_AMBIENCE_SLOT_TIMER] = null; }
/// Forgets a slot's fade, in or out, without sending anything
#define CLEAR_FADE(slot) slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = null; slot[POINT_AMBIENCE_SLOT_FADE_TARGET] = null; slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = null

/// The client's send state for one category, allocated on first use and dropped by stop_all_for,
/// unlike the sound datum beside it, which is kept. Every slim_send takes its slot from here
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
 * Builds and sends one point ambience update without calling playsound_local().
 *
 * slim_send() uses a turf source and the category's range, without an ERP class. Each client
 * reuses one sound datum per category. Playback start writes the file, channel, falloff range and
 * pitch. A source handoff can re-lean the pitch for unique_voice, but does not replace or seek the
 * loaded file. Listener-dependent volume, pan and environment are recalculated on each send.
 *
 * Point ambience adds its own falloff, pan blending, source voices and playback continuity.
 *
 * Arguments:
 * * fresh - the winning source changed, requiring a source-specific update
 * * had_previous - playback already exists on this category's channel
 * * dry_run - fill the datum and return what it would send, without sending
 * * clip_advance - choose the next file in a clip set without treating it as a new arrival
 * * centre - centre the handoff update before later sends pan toward the source
 *
 * Without unique_voice, nearby sconces sound identical. It gives each source a pitch lean and
 * starting place fixed by its turf. voice_place applies that offset only when playback begins,
 * because an offset on SOUND_UPDATE seeks the running clip. A held torch keeps its plain voice.
 *
 * falloff_hardness 1 drops the same proportion per tile, giving an even fade in decibels through
 * the range edge. Higher values separate nearby sources faster. At 0, the band power curve
 * matches CALCULATE_SOUND_VOLUME_RATIO, using inv_falloff_exponent instead of dividing per send.
 * With the authored category settings, its largest per-tile drop in decibels is at the range edge.
 *
 * Refusals precede restart work. A rejected send must not choose a file, roll pitch or start a
 * clip timer.
 */
/datum/controller/subsystem/point_ambience/proc/slim_send(mob/listener, client/listener_client, datum/point_ambience_category/category, atom/nearest, fresh, had_previous, dry_run, list/slot, clip_advance = FALSE, centre = FALSE)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/index = category.index
	var/list/sounds = listener_client.point_ambience_sounds
	if(length(sounds) < index)
		sounds.len = index
	var/sound/S = sounds[index]
	if(!S)
		S = sound()
		sounds[index] = S
	// Re-read on every send because a dragged or retuned source may still be the winning atom
	var/turf/source_turf = source_turfs[nearest] || get_turf(nearest)
	slot[POINT_AMBIENCE_SLOT_TURF] = source_turf
	if(!source_turf)
		return FALSE
	// Two floors away is silent, one is muffled. Only ranges under the long band muffle by
	// storey, so the band test stays even though no category's range reaches it
	var/storeys = (category.range < SOUND_RANGE_LONG) ? abs(source_turf.z - serving_turf.z) : 0
	if(storeys >= 2)
		return FALSE
	var/vol = category.volume * (category.source_volumes[nearest] || 1)
	var/continuous = category.source_continuous[nearest]
	// Before the floor, so a category cut indoors keeps its dB per tile and only drops a level
	if(serving_indoors && category.indoors_volume_mult != 1)
		vol *= category.indoors_volume_mult
	// A share of THIS source's volume, so the walk keeps its dB per tile at any level. Taken
	// before the muffle cut, so a muffled send lands on the same edge level as a clear one
	var/volume_floor = vol * category.floor_ratio
	// Heavier falloff, a volume cut, a dead room and the occlusion echo. A wall with no way round it
	// is not served at all and never reaches here
	var/muffled = storeys || serving_muffle_wall || serving_muffle_head
	var/environment = serving_environment
	var/list/echo = null
	if(muffled)
		// A wall takes the heavier cut, as playsound_local's wall profile does. A storey or an ear
		// shut inside something takes the lighter one
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
	if(storeys)
		volume *= SOUND_STOREY_VOLUME_MULT
	if(!isnull(serving_volume_scale))
		volume *= serving_volume_scale
	volume = min(volume, 100)
	// Against what the listener actually receives, after the slider. A send_cutoff of 0 is off and
	// refuses only silence
	if(volume <= 0 || volume < send_cutoff)
		return FALSE
	var/pan_x = 0
	var/pan_z = 0
	// Continuous source handoffs would reverse between opposite voices, so their stereo image stays centred
	if(!continuous && !centre)
		pan_lean(slot, category, nearest, source_turf, dx, dy, distance)
		pan_x = pan_lean_dx
		pan_z = pan_lean_dy
	var/restarting = FALSE
	// Where in the loop this source plays from, 0 to 1. Null unless playback begins on a source with
	// its own place in the loop
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
				CANCEL_CLIP_TIMER(slot)
				slot[POINT_AMBIENCE_SLOT_TIMER] = addtimer(CALLBACK(src, PROC_REF(advance_clip), listener_client, category), max(SSsounds.get_sound_length(file), 10), TIMER_STOPPABLE)
		// A voice fixed by where the source stands, so a sconce never sounds like its neighbour.
		// Rides the packet a change of source already sends. See the proc doc
		if(category.unique_voice)
			var/pitch = slot[POINT_AMBIENCE_SLOT_FREQUENCY]
			if(nearest != listener.point_ambience_self_source)
				if(voice_pitch)
					var/lean = 1 + voice_pitch * (((source_turf.x * 37 + source_turf.y * 101 + source_turf.z * 59) % 21) - 10) / 10
					// Onto the rolled rate where there is one. Without one the lean goes out as a
					// plain multiple, which is right at any sample rate
					pitch = pitch ? pitch * lean : lean
				if(restarting && voice_offset && category.voice_place)
					voice_phase = ((source_turf.x * 73 + source_turf.y * 179 + source_turf.z * 283) % 97) / 97
			// Always written, so a lean left over from the last source never outlives it
			S.frequency = pitch
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
	if(dry_run)
		return volume
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
			begin_fade(listener_client, category, slot, volume, climb, was_fading)
			fade_in_starts++
	if(!climb && was_fading)
		CLEAR_FADE(slot)
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

/**
 * Sends one source using an already prepared listener context.
 *
 * The caller must first succeed at prepare_serving() for this listener. It must also reset
 * serving_muffle_wall and grade the category if needed, and supply any runner-up in the slot.
 * This wrapper does none of that preparation. No other service or preparation may run between
 * preparing the context and consuming it here.
 *
 * dry_run suppresses packets and clip-timer creation, but still changes the client's sound datum
 * and slot, including file and pitch on a start. It is not an isolated preview. Diagnostics must
 * use disposable playback state or restore what they change before live servicing resumes.
 *
 * Returns the target volume, or FALSE when the send is refused.
 *
 * Arguments:
 * * fresh - the winning source changed, so its source-specific state must be refreshed
 * * had_previous - this category was already playing on the channel, so the send updates what is
 *   loaded rather than starting playback
 * * dry_run - build the datum and return what it would send, without sending
 */
/datum/controller/subsystem/point_ambience/proc/send_source(client/listener_client, mob/listener, datum/point_ambience_category/category, atom/nearest, fresh, had_previous, dry_run = FALSE)
	SHOULD_NOT_SLEEP(TRUE)
	return slim_send(listener, listener_client, category, nearest, fresh, had_previous, dry_run, slot_for(listener_client, category.index))

/**
 * Works out a send's stereo direction, leaned toward the runner-up and held at a minimum depth.
 *
 * A category plays its nearest source only, so walking a road of braziers flips the whole sound from
 * one ear to the other the moment the nearest changes: measured on one client walking that road,
 * eleven flips in 91 steps, each the full span in one packet.
 *
 * So the direction is weighted between the nearest and the runner-up the walk already found, each
 * weighted by how far inside the range it is, times the other one's squared distance. That sends the
 * weight to the nearer source and to zero at either range edge, so walking past, the image slides
 * from one toward the other instead of snapping. The switch itself is centre_handoff's: under it the
 * switching send skips this and goes out centred.
 *
 * The volume is not blended: one voice still plays, so the dip between two fires stays. The
 * runner-up is graded only when the winner was occluded, so this can lean toward a fire behind a
 * wall. If that is heard, grade it for occluding categories.
 *
 * The pan is taken from the listener's turf, then held at a minimum depth so a sideways source stays
 * out of one ear, only the angle changing and not the magnitude. A plain dead zone zeroes an axis
 * within a tile, which puts a source 1.4 tiles off the shoulder dead ahead and then snaps it to 45
 * degrees on the next step.
 *
 * Both numbers go back through pan_lean_dx and pan_lean_dy
 */
/datum/controller/subsystem/point_ambience/proc/pan_lean(list/slot, datum/point_ambience_category/category, atom/nearest, turf/source_turf, dx, dy, distance)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/pan_x = dx
	var/pan_z = dy
	// Leaned only toward another source of this category on the same floor and inside its range
	var/atom/second = pan_blend ? slot[POINT_AMBIENCE_SLOT_RUNNER_UP] : null
	var/turf/second_turf = (second && second != nearest && source_categories[second] == category) ? source_turfs[second] : null
	if(second_turf && second_turf.z == source_turf.z)
		var/runner_dx = second_turf.x - serving_turf.x
		var/runner_dy = second_turf.y - serving_turf.y
		var/nearest_distsq = dx * dx + dy * dy
		var/runner_distsq = runner_dx * runner_dx + runner_dy * runner_dy
		var/nearest_weight = (category.range_sq - nearest_distsq) * runner_distsq
		var/runner_weight = (category.range_sq - runner_distsq) * nearest_distsq
		var/total = nearest_weight + runner_weight
		if(nearest_distsq && runner_distsq <= category.range_sq && total > 0)
			pan_x = (nearest_weight * dx + runner_weight * runner_dx) / total
			pan_z = (nearest_weight * dy + runner_weight * runner_dy) / total
	if(!pan_depth_floor)
		pan_x = (pan_x <= 1 && pan_x >= -1) ? 0 : pan_x
		pan_z = (pan_z <= 1 && pan_z >= -1) ? 0 : pan_z
	pan_lean_dx = pan_x
	pan_lean_dy = pan_z
	if(!pan_x || !SOUND_PAN_MIN_DEPTH)
		return
	var/min_depth = pan_depth_floor \
		? max(abs(pan_x) * max(1, SOUND_PAN_NEAR_DEPTH / max(distance, 1)), SOUND_PAN_MIN_DEPTH_ABS) \
		: abs(pan_x) * SOUND_PAN_MIN_DEPTH
	if(abs(pan_z) >= min_depth)
		return
	// Pushed out to the floor, then scaled back to the length it had. Never divides by zero, since
	// pan_x is not zero
	var/original = sqrt(pan_x * pan_x + pan_z * pan_z)
	pan_z = (pan_z < 0) ? -min_depth : min_depth
	var/ratio = original / sqrt(pan_x * pan_x + pan_z * pan_z)
	pan_lean_dx = pan_x * ratio
	pan_lean_dy = pan_z * ratio

/**
 * Marks one expired clip for replacement.
 *
 * The client is queued, and the service picks the next clip. A service already queued takes it
 * along. A listener expected to step within clip_coalesce_window waits for that step, and the timer
 * returns with deferred set if the step never comes. With the queue off the service runs inline.
 * The old clip repeats natively until it is served.
 *
 * Arguments:
 * * deferred - the timer after waiting for a step, which serves the client unless a service
 *   already took the clip
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
 * Stops one category for one listener and forgets what it was playing.
 *
 * Arguments:
 * * send_null - FALSE when nothing was playing on the channel, so there is nothing to stop. A fade
 *   out is stopped whatever this says.
 */
/datum/controller/subsystem/point_ambience/proc/stop_for(client/listener_client, datum/point_ambience_category/category, send_null = TRUE)
	listener_client.point_ambience_sources -= category
	var/list/slots = listener_client.point_ambience_slots
	var/list/slot = (length(slots) >= category.index) ? slots[category.index] : null
	if(slot)
		slot[POINT_AMBIENCE_SLOT_RUNNER_UP] = null
		// Cleared with the rest of the stretch, so nothing later reads the volume it ended at
		slot[POINT_AMBIENCE_SLOT_LAST_VOLUME] = null
		CANCEL_CLIP_TIMER(slot)
		slot[POINT_AMBIENCE_SLOT_CLIP_DUE] = null
		if(slot[POINT_AMBIENCE_SLOT_FADE_NEXT])
			// A fade out has the channel still playing and, with its marker gone, nothing left
			// to end it, so the stop goes out whatever the caller asked
			if(isnull(slot[POINT_AMBIENCE_SLOT_FADE_TARGET]))
				send_null = TRUE
			CLEAR_FADE(slot)
	if(send_null)
		SEND_SOUND(listener_client, category.stop_sound)

/// Stops every category for one listener and clears their cached walk, so the next service is
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
			CANCEL_CLIP_TIMER(slot)
		if(slot?[POINT_AMBIENCE_SLOT_FADE_NEXT])
			stop_for(listener_client, category)
	// Muted listeners and ghosts may never service these lists again, so release their sources now
	slots.Cut()
	listener_client.point_ambience_cache_static?.Cut()
	listener_client.point_ambience_cache_self = null
	listener_client.point_ambience_cell_candidates = null
	listener_client.point_ambience_cell_version = null
	listener_client.point_ambience_cache_turf = null

/**
 * Lets a category die away for one listener instead of cutting it.
 *
 * For a listener who leaves a sound by moving: out of its range, behind a wall, or faster than a
 * natural run. A snuffed source, a mute, deafness and a teleport stop at once through stop_for.
 *
 * The first step goes out here, the exit already being a step late, and fire() sends the rest. The
 * category leaves point_ambience_sources now, so the walk treats it as gone, and coming back into
 * earshot before the fade ends picks the playing clip up again. A clip set restarts instead
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
	// Every other cut is counted by its reason, so "it did not trail off" can be traced to one
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
	// Out of point_ambience_sources and off the clip timer, as stop_for does. The rest of the slot
	// stays for the fade to read
	listener_client.point_ambience_sources -= category
	CANCEL_CLIP_TIMER(slot)
	// Already listed when it was still fading IN, and that entry carries on as this fade out
	begin_fade(listener_client, category, slot, null, fade_steps - 1, listed)
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

/// Puts one slot on the fade runner with its first step due one POINT_AMBIENCE_FADE_STEP from now.
/// A null target fades out and a volume fades in to it. A slot already listed keeps its one entry
/datum/controller/subsystem/point_ambience/proc/begin_fade(client/listener_client, datum/point_ambience_category/category, list/slot, target, steps, listed)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/due = round(world.time) + POINT_AMBIENCE_FADE_STEP
	slot[POINT_AMBIENCE_SLOT_FADE_NEXT] = due
	slot[POINT_AMBIENCE_SLOT_FADE_TARGET] = target
	slot[POINT_AMBIENCE_SLOT_FADE_LEFT] = steps
	fade_next_due = length(fading) ? min(fade_next_due, due) : due
	if(listed)
		return
	fading += listener_client
	fading += category

/**
 * Sends whatever fade steps have come due.
 *
 * Driven by world.time, not by one step a fire, because this subsystem runs in the tick's slack and
 * a late fire has to catch up rather than stretch the fade: every overdue step is taken at once,
 * which is also what keeps the ending firm.
 *
 * A step never goes through slim_send. That would pin a listener past the range at the floor and
 * refuse the last quiet steps.
 *
 * A step reads both the capped and the uncapped count of steps elapsed. Read only through the cap,
 * the last step of a fade out recomputes the same volume however late the run is, stays above
 * fade_skip, and a budget refusal defers it again writing nothing, so it would never end. The
 * uncapped count ends it
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
		// Uncapped as well, so a run arriving after the whole fade was due ends it. See the proc doc
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
		// Over the budget a step waits, and the next run takes it with the rest. An ending never
		// waits, since it leaves the sound at the volume it must hold
		if(!stopping && !arrived && (sent >= fade_budget || TICK_CHECK))
			fade_deferred++
			earliest = world.time
			i += 2
			continue
		if(stopping || arrived)
			CLEAR_FADE(slot)
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
	PRIVATE_PROC(TRUE)
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
		CLEAR_FADE(slot)
	fading.Cut()

#undef CANCEL_CLIP_TIMER
#undef CLEAR_FADE
