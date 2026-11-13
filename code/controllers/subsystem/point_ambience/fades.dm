/**
 * Starts an exit fade and sends its first volume update immediately.
 *
 * Used for range exits, blocked paths and the speed cutoff. The source leaves the listener's
 * selection while its slot retains playback for run_fades(). Re-entry can resume a continuous loop
 * before the fade ends. Clip sets restart. Removed sources, muted listeners and teleports stop
 * immediately.
 */
/datum/controller/subsystem/point_ambience/proc/fade_out(client/listener_client, datum/point_ambience_category/category, turf/listener_turf)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/index = category.index
	var/datum/point_ambience_listener/listener_state = listener_client.point_ambience
	var/list/slots = listener_state.slots
	var/list/sounds = listener_state.sounds
	var/datum/point_ambience_slot/slot = LAZYACCESS(slots, index)
	var/sound/channel_sound = LAZYACCESS(sounds, index)
	var/turf/source_turf = slot?.source_turf
	var/fade_volume = slot?.last_volume
	var/was_fading = slot?.fade_next
	if(!fade_steps || !listener_turf)
		stop_for(listener_client, category)
		return
	var/nothing_to_fade = !channel_sound || !fade_volume || !source_turf
	var/fade_capacity_reached = !was_fading && length(fading) >= POINT_AMBIENCE_FADE_CAP
	if(nothing_to_fade || fade_capacity_reached)
		stop_for(listener_client, category)
		return
	// More than three tiles beyond range is treated as a teleport and cut immediately.
	// Allow one floor for stairs. Horizontal distance still determines fade_reach
	var/dx = source_turf.x - listener_turf.x
	var/dy = source_turf.y - listener_turf.y
	var/fade_reach = category.range + 3
	if(abs(source_turf.z - listener_turf.z) > 1 || dx * dx + dy * dy > fade_reach * fade_reach)
		stop_for(listener_client, category)
		return
	fade_volume *= fade_ratio
	if(fade_volume < fade_skip)
		stop_for(listener_client, category)
		return
	// Stop selecting this source and advancing its clips, but retain its slot for the fade
	listener_state.sources -= category
	POINT_AMBIENCE_CANCEL_CLIP_TIMER(slot)
	// Reuse an existing fade-in entry when turning it into a fade-out
	begin_fade(slot, null, fade_steps - 1, was_fading)
	// Update volume only. This service owns the first step. fade_packets counts later run_fades()
	// updates
	channel_sound.status = SOUND_UPDATE
	channel_sound.volume = fade_volume
	SEND_SOUND(listener_client, channel_sound)
	slot.last_volume = fade_volume

/**
 * Schedules a slot's next fade step after POINT_AMBIENCE_FADE_STEP.
 *
 * Arguments:
 * * target - null for a fade-out, or the volume a fade-in should reach
 * * steps - remaining steps after any update the caller already sent
 * * listed - reuse the slot's existing runner entry instead of adding a duplicate
 */
/datum/controller/subsystem/point_ambience/proc/begin_fade(datum/point_ambience_slot/slot, target, steps, listed)
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/next_step_at = round(world.time) + POINT_AMBIENCE_FADE_STEP
	slot.fade_next = next_step_at
	slot.fade_target = target
	slot.fade_left = steps
	fade_next_due = length(fading) ? min(fade_next_due, next_step_at) : next_step_at
	if(listed)
		return
	fading += slot

/**
 * Advances due fades and sends their next volume or stop packet.
 *
 * Elapsed world.time determines progress so a delayed fire catches up instead of stretching the
 * fade. elapsed_steps is uncapped. steps_to_apply is limited by remaining_steps for volume
 * calculation. An overdue fade must still finish when its computed volume remains above fade_skip.
 *
 * Budget deferral leaves the slot unchanged. Stops and final fade-in updates bypass the budget.
 * Removing a slot keeps fade_index in place for the entry shifted into it. Fade packets bypass
 * slim_send() so minimum-volume rules cannot prevent their quiet final steps.
 */
/datum/controller/subsystem/point_ambience/proc/run_fades()
	PRIVATE_PROC(TRUE)
	SHOULD_NOT_SLEEP(TRUE)
	var/updates_sent = 0
	var/earliest_step_at = INFINITY
	var/fade_index = 1
	while(fade_index <= length(fading))
		var/datum/point_ambience_slot/slot = fading[fade_index]
		var/client/listener_client = slot.listener_client
		var/datum/point_ambience_category/category = slot.category
		var/step_due_at = slot.fade_next
		// A real send can clear the marker while leaving its runner entry for removal here
		if(!step_due_at || !listener_client)
			fading.Cut(fade_index, fade_index + 1)
			continue
		if(world.time < step_due_at)
			earliest_step_at = min(earliest_step_at, step_due_at)
			fade_index++
			continue

		var/next_volume = slot.last_volume
		var/remaining_steps = slot.fade_left
		var/target_volume = slot.fade_target
		var/elapsed_steps = 1 + round((world.time - step_due_at) / POINT_AMBIENCE_FADE_STEP)
		var/fade_overdue = elapsed_steps > remaining_steps
		var/steps_to_apply = min(remaining_steps, elapsed_steps)
		var/should_stop = FALSE
		var/reached_target = FALSE
		if(isnull(target_volume))
			// Running out of steps must stop playback even when fade_skip is zero
			if(steps_to_apply > 0 && next_volume)
				next_volume *= fade_ratio ** steps_to_apply
			should_stop = (fade_overdue || steps_to_apply <= 0 || !next_volume || next_volume < fade_skip)
		else
			// Land exactly on the target on the last step, even if the ratio does not divide evenly
			next_volume = (steps_to_apply < remaining_steps && next_volume) ? min(next_volume / fade_ratio ** steps_to_apply, target_volume) : target_volume
			reached_target = (next_volume >= target_volume)

		// Keep a deferred slot unchanged so the next run can include all overdue steps
		if(!should_stop && !reached_target && (updates_sent >= fade_budget || TICK_CHECK))
			earliest_step_at = world.time
			fade_index++
			continue
		if(should_stop || reached_target)
			POINT_AMBIENCE_CLEAR_FADE(slot)
			fading.Cut(fade_index, fade_index + 1)
		else
			var/next_step_at = round(world.time) + POINT_AMBIENCE_FADE_STEP
			slot.fade_next = next_step_at
			slot.fade_left = remaining_steps - steps_to_apply
			earliest_step_at = min(earliest_step_at, next_step_at)
			fade_index++

		if(should_stop)
			slot.last_volume = null
			SEND_SOUND(listener_client, category.stop_sound)
			continue
		var/sound/channel_sound = listener_client.point_ambience.sounds[category.index]
		channel_sound.status = SOUND_UPDATE
		channel_sound.volume = next_volume
		SEND_SOUND(listener_client, channel_sound)
		slot.last_volume = next_volume
		metrics.fade_packets++
		updates_sent++
	fade_next_due = earliest_step_at

/**
 * Finishes pending fades before a mode change or subsystem replacement.
 *
 * Fade-out channels are no longer listed in the listener's selected sources, so they must be
 * stopped through their slots.
 */
/datum/controller/subsystem/point_ambience/proc/finish_fades()
	PRIVATE_PROC(TRUE)
	for(var/datum/point_ambience_slot/slot as anything in fading)
		if(!slot.fade_next || !slot.listener_client)
			continue
		if(isnull(slot.fade_target))
			slot.last_volume = null
			SEND_SOUND(slot.listener_client, slot.category.stop_sound)
		POINT_AMBIENCE_CLEAR_FADE(slot)
	fading.Cut()
