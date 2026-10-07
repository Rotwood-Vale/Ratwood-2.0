/// Returns a category's playback slot, allocating it on first use. stop_all_for() releases these
/// slots
/datum/controller/subsystem/point_ambience/proc/slot_for(client/listener_client, index)
	PRIVATE_PROC(TRUE)
	var/list/slots = listener_client.point_ambience.slots
	if(length(slots) < index)
		slots.len = index
	var/datum/point_ambience_slot/slot = slots[index]
	if(!slot)
		slot = new(listener_client, categories[index])
		slots[index] = slot
	return slot

/**
 * Builds and sends a category's point-ambience packet, returning its target volume or zero on
 * refusal.
 *
 * Uses the prepared serving_* context and a reusable sound datum. Attenuation, muffling and the
 * cutoff are resolved before file selection, pitch rolls or clip timers. Playback starts set the
 * file and channel. Handoffs update position and optional pitch without replacing or seeking the
 * current recording.
 *
 * unique_voice derives pitch and starting phase from source position. voice_place applies phase
 * only when playback begins because an offset on SOUND_UPDATE seeks the active clip. A held torch
 * uses its ordinary voice.
 *
 * Entry fades may send less than the returned target volume. The slot records the volume actually
 * sent, and temporary offsets are cleared before the next update.
 *
 * Arguments:
 * * fresh - the selected source changed
 * * had_previous - this category already has playback on its channel
 * * dry_run - update the sound datum and slot without sending, starting fades or creating clip
 *   timers
 * * clip_advance - replace a due clip without an entry fade
 * * centre - centre this handoff packet instead of panning toward the new source
 * * river_cost - river path distance in half-steps. null reads it from the fill
 */
/datum/controller/subsystem/point_ambience/proc/slim_send(mob/listener, client/listener_client, datum/point_ambience_category/category, atom/nearest, fresh, had_previous, dry_run, datum/point_ambience_slot/slot, clip_advance = FALSE, centre = FALSE, river_cost = null)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/index = category.index
	var/list/sounds = listener_client.point_ambience.sounds
	if(length(sounds) < index)
		sounds.len = index
	var/sound/channel_sound = sounds[index]
	if(!channel_sound)
		channel_sound = sound()
		sounds[index] = channel_sound
	var/is_river = category == river_category
	if(is_river && isnull(river_cost))
		var/river_mark = river_fill.marks[serving_turf]
		if(!RIVER_FILL_AUDIBLE(river_mark))
			return FALSE
		river_cost = RIVER_FILL_COST(river_mark)
	// River playback is anchored to the hearing turf rather than an indexed emitter
	var/turf/source_turf = is_river ? serving_turf : (source_turfs[nearest] || get_turf(nearest))
	slot.source_turf = source_turf
	if(!source_turf)
		return FALSE
	// Short-range cross-floor sends muffle one floor of separation and reject two
	var/storeys = (category.range < SOUND_RANGE_LONG) ? abs(source_turf.z - serving_turf.z) : 0
	if(storeys >= 2)
		return FALSE
	var/source_volume = is_river ? category.volume : category.volume * (category.source_volumes[nearest] || 1)
	// Derive the floor before muffling so clear and muffled playback retain the same range-edge
	// level
	var/volume_floor = source_volume * category.floor_ratio
	var/muffled = storeys || serving_muffle_wall || serving_muffle_head
	var/environment = serving_environment
	var/list/echo = null
	if(muffled)
		// Corner muffling uses the stronger volume reduction. Floor and head enclosure use the
		// lighter one
		source_volume *= serving_muffle_wall ? SOUND_MUFFLE_WALL_VOLUME_MULT : SOUND_MUFFLE_VOLUME_MULT
		environment = SOUND_MUFFLE_ENVIRONMENT
		echo = storey_echo
	var/falloff_hardness = muffled ? category.muffled_hardness : category.falloff_hardness
	var/inverse_falloff_exponent = muffled ? category.inv_muffled_exponent : category.inv_falloff_exponent
	var/dx = source_turf.x - serving_turf.x
	var/dy = source_turf.y - serving_turf.y
	// Keep this local: STOREY_ADJUSTED_DISTANCE names its first argument three times
	var/distance = is_river ? river_cost * 0.5 : sqrt(dx * dx + dy * dy)
	distance = STOREY_ADJUSTED_DISTANCE(distance, storeys)
	var/falloff_progress = max(distance - SOUND_DEFAULT_FALLOFF_DISTANCE, 0) / (max(category.range, distance) - SOUND_DEFAULT_FALLOFF_DISTANCE)
	var/target_volume
	if(falloff_hardness && source_volume > 1)
		var/clamped_floor_volume = max(min(volume_floor, source_volume), 0.01)
		target_volume = source_volume * (clamped_floor_volume / source_volume) ** (falloff_hardness == 1 ? falloff_progress : falloff_progress ** (1 / falloff_hardness))
	else
		target_volume = source_volume - (falloff_progress ** inverse_falloff_exponent) * (source_volume - volume_floor)
	if(storeys)
		target_volume *= SOUND_STOREY_VOLUME_MULT
	if(!isnull(serving_volume_scale))
		target_volume *= serving_volume_scale
	target_volume = min(target_volume, 100)
	// Apply the cutoff after listener-volume scaling. Zero disables the configured cutoff
	if(target_volume <= 0 || target_volume < send_cutoff)
		return FALSE

	// River playback represents the surrounding water, so it stays centred along the bank
	if(is_river || centre)
		channel_sound.x = 0
		channel_sound.z = 0
	else
		pan_lean(channel_sound, slot, category, nearest, source_turf, dx, dy, distance)

	var/refresh_source = fresh || clip_advance
	var/restarting = refresh_source && (clip_advance || !had_previous)
	// Starting phase within the loop, from 0 to 1. null means no seek
	var/voice_phase = null
	// A source handoff keeps the loaded file. Only a playback start or clip advance replaces it
	if(restarting)
		var/previous_file = slot.file
		var/next_file
		if(category.files)
			var/list/clip_choices = (length(category.files) > 1) ? (category.files - previous_file) : category.files
			next_file = pick(clip_choices)
		else
			next_file = category.source_sounds[nearest] || category.sound_file
		slot.file = next_file
		// Retain the pitch roll on SOUND_UPDATE. Frequency zero would restore the recording's
		// normal rate
		slot.frequency = category.vary_pitch ? get_rand_frequency() : 0
		channel_sound.file = next_file
		channel_sound.repeat = TRUE
		channel_sound.wait = 0
		channel_sound.channel = category.channel
		channel_sound.falloff = category.range
		channel_sound.frequency = slot.frequency
		// Repeat bridges a late clip callback. The timer requests the next file when this one ends
		if(category.files && !dry_run)
			POINT_AMBIENCE_CANCEL_CLIP_TIMER(slot)
			slot.timer = addtimer(CALLBACK(src, PROC_REF(advance_clip), listener_client, category), max(SSsounds.get_sound_length(next_file), 10), TIMER_STOPPABLE)

	// Handoffs can change the source's pitch, but only a restart may apply its starting offset
	if(refresh_source && category.unique_voice)
		var/pitch = slot.frequency
		if(nearest != listener.point_ambience_self_source)
			if(voice_pitch)
				var/pitch_multiplier = 1 + voice_pitch * (((source_turf.x * 37 + source_turf.y * 101 + source_turf.z * 59) % 21) - 10) / 10
				// Preserve an existing absolute rate. Otherwise send the lean as a relative
				// multiplier
				pitch = pitch ? pitch * pitch_multiplier : pitch_multiplier
			if(restarting && voice_offset && category.voice_place)
				voice_phase = POINT_AMBIENCE_VOICE_SEED(source_turf) / 97
		// Overwrite pitch so a previous source's variation cannot carry into this source
		channel_sound.frequency = pitch

	// The early river shortcut misses changed inputs that resolve to an identical send. Do not
	// skip a fade completion or leave a previous head-container muffle on the reused sound datum
	if(is_river)
		var/playback_is_steady = had_previous && !restarting && !slot.fade_next
		var/river_send_unchanged = playback_is_steady && channel_sound.echo == echo && slot.last_volume == target_volume && slot.environment == environment
		if(river_send_unchanged)
			return target_volume

	// File selection and packet status must agree on whether this send restarts playback
	channel_sound.status = restarting ? 0 : SOUND_UPDATE
	channel_sound.environment = environment
	channel_sound.y = source_turf.z - serving_turf.z
	channel_sound.echo = echo
	channel_sound.volume = target_volume
	if(dry_run)
		return target_volume

	// A normal update completes an active fade. A new arrival may start an entry fade
	var/was_fading = slot.fade_next
	var/fade_steps = 0
	var/should_fade_in = restarting && fade_in_steps && !clip_advance
	if(should_fade_in && (was_fading || length(fading) < POINT_AMBIENCE_FADE_CAP))
		var/opening_volume = target_volume
		while(fade_steps < fade_in_steps && opening_volume * fade_ratio >= fade_skip)
			opening_volume *= fade_ratio
			fade_steps++
		if(fade_steps)
			channel_sound.volume = opening_volume
			begin_fade(slot, target_volume, fade_steps, was_fading)
	if(!fade_steps && was_fading)
		POINT_AMBIENCE_CLEAR_FADE(slot)

	// Restore the offset after this packet so later updates cannot repeatedly seek the clip
	var/previous_offset = channel_sound.offset
	if(!isnull(voice_phase))
		var/clip_length_ds = SSsounds.get_sound_length(slot.file)
		if(clip_length_ds)
			channel_sound.offset = voice_phase * clip_length_ds / 10
	SEND_SOUND(listener, channel_sound)
	channel_sound.offset = previous_offset
	// What was actually sent, which a climb makes lower than what is returned
	slot.last_volume = channel_sound.volume
	slot.environment = environment
	return target_volume

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
 * Sets sound x/z coordinates, blending direction toward the same-category runner-up.
 *
 * Weights favor the nearer source and fall to zero at each source's range edge. Only direction is
 * blended. Volume still comes from one source. A centred handoff bypasses this calculation.
 *
 * The runner-up is not independently occlusion-tested unless source selection needed it, so panning
 * may lean toward an obstructed source. With pan_depth_floor, minimum lateral depth preserves
 * nearby direction. The result is rescaled to retain its original magnitude.
 */
/datum/controller/subsystem/point_ambience/proc/pan_lean(sound/channel_sound, datum/point_ambience_slot/slot, datum/point_ambience_category/category, atom/nearest, turf/source_turf, dx, dy, distance)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/pan_x = dx
	var/pan_z = dy
	var/atom/runner_up = slot.runner_up
	var/turf/runner_up_turf = (runner_up && runner_up != nearest && source_categories[runner_up] == category) ? source_turfs[runner_up] : null
	if(runner_up_turf && runner_up_turf.z == source_turf.z)
		var/runner_up_dx = runner_up_turf.x - serving_turf.x
		var/runner_up_dy = runner_up_turf.y - serving_turf.y
		var/nearest_distance_sq = dx * dx + dy * dy
		var/runner_up_distance_sq = runner_up_dx * runner_up_dx + runner_up_dy * runner_up_dy
		var/nearest_weight = (category.range_sq - nearest_distance_sq) * runner_up_distance_sq
		var/runner_up_weight = (category.range_sq - runner_up_distance_sq) * nearest_distance_sq
		var/total_weight = nearest_weight + runner_up_weight
		if(nearest_distance_sq && runner_up_distance_sq <= category.range_sq && total_weight > 0)
			pan_x = (nearest_weight * dx + runner_up_weight * runner_up_dx) / total_weight
			pan_z = (nearest_weight * dy + runner_up_weight * runner_up_dy) / total_weight
	if(!pan_depth_floor)
		pan_x = (pan_x <= 1 && pan_x >= -1) ? 0 : pan_x
		pan_z = (pan_z <= 1 && pan_z >= -1) ? 0 : pan_z
	channel_sound.x = pan_x
	channel_sound.z = pan_z
	if(!pan_x || !SOUND_PAN_MIN_DEPTH)
		return
	var/min_depth = pan_depth_floor \
		? max(abs(pan_x) * max(1, SOUND_PAN_NEAR_DEPTH / max(distance, 1)), SOUND_PAN_MIN_DEPTH_ABS) \
		: abs(pan_x) * SOUND_PAN_MIN_DEPTH
	if(abs(pan_z) >= min_depth)
		return
	// Retain the original pan magnitude after applying minimum depth. pan_x is nonzero here
	var/original_pan_length = sqrt(pan_x * pan_x + pan_z * pan_z)
	pan_z = (pan_z < 0) ? -min_depth : min_depth
	var/pan_scale = original_pan_length / sqrt(pan_x * pan_x + pan_z * pan_z)
	channel_sound.x = pan_x * pan_scale
	channel_sound.z = pan_z * pan_scale
