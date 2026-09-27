// Sound tokens, a datumized handler for spatial sound.
// Uses the spatial grid to track clients in range and add them as listeners
// Updated by the SSsound_tokens subsystem every tick when requested by client so that if the source or listener moves, the sound updates accordingly.
/**
 * # Sound token
 *
 * A token re-sends per listener as either side moves, so volume and pan follow them mid-play.
 *
 * Deviations from TG are marked where they live: the multi-z rule and one cell tracker per z,
 * polled can_hear(), per-move listener refresh, holder tracking, wall muffling, one shared pitch
 * roll, a start_time shared by a band, and a logged refusal rather than a CRASH when the channel
 * pool is dry.
 */
/datum/sound_token
	/// The atom playing the sound.
	var/atom/source
	/// k:v list of mob : sound status
	var/list/listeners = list()
	/**
	 * Listeners whose client is playing this token's current file on its channel, audible or muted.
	 *
	 * An update only changes a sound already playing, so an update sent to anyone missing from here
	 * plays nothing. They get a full send at the current offset instead. A listener who enters a grid
	 * cell out of earshot is sent nothing, so their first audible send must be a full one. A new file
	 * empties it, since the channel is still playing the old one
	 */
	var/list/started_listeners
	///k:v list of mobs : bool. Used to quickly check whether a mob is allowed to hear this noise. This is null by default which means ANY MOB can hear this.
	var/list/allowed_listeners
	/// Sound maximum range
	var/range
	/// Sound volume
	var/volume
	/// Sound falloff
	var/falloff_exponent
	/// Sound falloff distance
	var/falloff_distance

	/**
	 * Roll a random pitch for this token, as playsound's vary does.
	 *
	 * ONE roll per token, shared by every listener, because a token is one sound in the world rather
	 * than a sound per listener. It rides the master datum below, so it survives every SOUND_UPDATE
	 * instead of snapping back.
	 */
	var/vary = FALSE
	/// The master copy of the playing sound.
	var/sound/sound
	/// Null sound for cancelling the sound entirely.
	var/sound/null_sound

	/// The channel being used.
	var/sound_channel
	/// REALTIMEOFDAY when the sound started (or when the sound file was last changed). Used to calculate playback offset for new listeners
	var/start_time
	/// Duration of the current sound file in deciseconds. Used to wrap offset for looping sounds.
	var/sound_duration
	/// Caller-provided duration override for when the length cannot be sniffed from the file
	var/sound_duration_override
	/**
	 * Cell trackers for the source z plus the z above and below it.
	 *
	 * The spatial grid is per-z and our sounds leak one storey each way, so one tracker cannot cover
	 * the audience. Index 1 is always the source z.
	 */
	var/list/datum/cell_tracker/cell_trackers
	///Should we destroy the datum when the sound is done?
	var/delete_on_end = FALSE
	///Do we repeat the sound using sound.repeat?
	var/repeating = FALSE
	/// When TRUE, this token is priced by the listener's Instruments slider instead of Sound
	/// Effects, so a slider at 0 is silence
	var/respect_instrument_pref = FALSE
	/**
	 * When TRUE, a listener with no line of sight to the source hears the sound muffled.
	 *
	 * The continuous counterpart of playsound()'s SOUND_TRAVEL_CARRYING. Same floor only: cross-floor
	 * listeners are muffled by the storey rule in playsound_local() regardless.
	 */
	var/muffle_behind_walls = FALSE
	/// Optional callback invoked with (listener) each time a listener crosses from muted to audible
	var/datum/callback/on_listener_audible
	/// The outermost movable the source is inside, if any, watched for INDIRECT movement.
	/// A carried item does not fire Moved() when its holder walks, only the holder does
	var/atom/movable/tracked_holder

/datum/sound_token/New(atom/_source, _sound, _range = 10, _volume = 50, _falloff_exponent, _falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, _allowed_listeners, _sound_duration_override, _delete_on_end, _repeating, start_time_override, _vary = FALSE)
	source = _source
	// Before update_sound() below, which is what builds the sound datum the pitch is rolled onto
	vary = _vary
	RegisterSignal(source, COMSIG_QDELETING, PROC_REF(source_deleted))
	RegisterSignal(source, COMSIG_MOVABLE_MOVED, PROC_REF(source_moved))

	range = _range
	volume = _volume
	falloff_exponent = _falloff_exponent
	falloff_distance = _falloff_distance
	sound_duration_override = _sound_duration_override
	if(_delete_on_end)
		delete_on_end = _delete_on_end
	repeating = _repeating

	if(_allowed_listeners)
		allowed_listeners = list()
		for(var/allowed_mob in _allowed_listeners)
			allowed_listeners[allowed_mob] = TRUE

	if(!update_sound(_sound))
		return // No channel left, and update_sound() already qdel'd us

	// Band members share one anchor: identical stamps mean every member's listeners
	// compute the same offset, so the whole band stays in lockstep for free
	if(start_time_override)
		start_time = start_time_override

	null_sound = sound(channel = sound_channel)

	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGIN, PROC_REF(player_login))
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGOUT, PROC_REF(player_logout))
	update_holder_tracking()

	// NOT update_tracked_cells() here. See start_tracking(). TG gathers listeners inside
	// New(), which is fine there because it has nothing to configure afterwards

/**
 * Finds the initial listeners and starts playing to them.
 *
 * Separate from New() so a caller can set fields like respect_instrument_pref first. Adding a
 * listener sends the sound at once, so a field set afterwards costs a second send, and the first
 * goes out at the wrong volume.
 */
/datum/sound_token/proc/start_tracking()
	update_tracked_cells()

/datum/sound_token/Destroy(force, ...)
	for(var/listener in listeners)
		remove_listener(listener)
	listeners = null
	source = null
	// The cell trackers hold no refs to us, and their cell signals die with our signal
	// registrations. Drain them so lingering cell membership can't confuse anything
	for(var/datum/cell_tracker/tracker as anything in cell_trackers)
		tracker.member_cells.Cut()
	cell_trackers = null
	on_listener_audible = null
	tracked_holder = null // Its signal registration is dropped by the datum teardown below
	return ..()

/// Lets us update the sound to a new one. Returns FALSE (after scheduling our own deletion) if no channel could be reserved
/datum/sound_token/proc/update_sound(_sound, start_playing = FALSE, _repeating = null)
	if(!isnull(_repeating))
		repeating = _repeating
	sound = sound(_sound)
	sound.repeat = repeating
	if(vary)
		sound.frequency = get_rand_frequency()
	if(!sound_channel)
		sound_channel = SSsounds.reserve_sound_channel_for_datum(src)
		if(!sound_channel)
			// Deviation from TG, which CRASHes: a full pool logs, deletes the token and returns FALSE,
			// which a caller can show as "no sound channels"
			stack_trace("sound_token for [source] found no free sound channel; deleting itself")
			sound_channel = null
			qdel(src)
			return FALSE
	sound.channel = sound_channel
	sound_duration = sound_duration_override || SSsounds.get_sound_length(_sound)
	start_time = REALTIMEOFDAY
	started_listeners = null
	if(start_playing)
		force_update_all_listeners(FALSE)
	if(delete_on_end && !repeating)
		addtimer(CALLBACK(src, PROC_REF(on_sound_ended)), sound_duration, TIMER_UNIQUE | TIMER_OVERRIDE)
	return TRUE

/// Updates the data of a listener, or adds them if they are not present.
/datum/sound_token/proc/add_or_update_listener(mob/listener_mob)
	if(isnull(listeners[listener_mob]))
		if(!add_listener(listener_mob))
			return FALSE
	else
		update_listener(listener_mob)

/**
 * Adds a listener to the sound. returns TRUE if we already were added, or for some reason couldnt be added.
 *
 * Seeded muted, not NONE. on_listener_audible fires only on a muted to audible edge, and a grid
 * cell, SPATIAL_GRID_CELLSIZE tiles across, is wider than most token ranges, so a listener often
 * enters a cell already in earshot and would cross no edge from NONE. A listener who enters out of
 * range also gets no muted send, so their first audible send is a full one, see started_listeners.
 *
 * Deviation from TG, which re-evaluates a listener only when the source moves. SSsound_tokens also
 * refreshes a listener on their own movement, or a static source such as a music box stays at the
 * volume it had on arrival. The subsystem registers that once per mob, see track_listener(), for
 * every client mob in a tracked cell, in earshot or not.
 */
/datum/sound_token/proc/add_listener(mob/listener_mob)
	if(!isnull(listeners[listener_mob]))
		return TRUE

	if(!listener_mob.client || isnewplayer(listener_mob))
		return FALSE

	if(allowed_listeners && !allowed_listeners[listener_mob])
		return FALSE

	// Seeded muted. See the proc doc
	listeners[listener_mob] = SOUND_MUTE
	LAZYOR(listener_mob.sound_tokens, src)
	if(source != listener_mob) //this is possible...yea... :/
		RegisterSignal(listener_mob, COMSIG_QDELETING, PROC_REF(listener_deleted))
	// Per-move refresh, registered once per mob. See the proc doc
	SSsound_tokens.track_listener(listener_mob)
	update_listener(listener_mob, FALSE)
	return TRUE

/// Remove a listener from the sound.
/datum/sound_token/proc/remove_listener(mob/listener_mob)
	listeners -= listener_mob
	LAZYREMOVE(started_listeners, listener_mob)
	LAZYREMOVE(listener_mob.sound_tokens, src)

	if(source != listener_mob)
		UnregisterSignal(listener_mob, COMSIG_QDELETING)
	SSsound_tokens.untrack_listener(listener_mob) // Drops movement tracking on the last token
	SEND_SOUND(listener_mob, null_sound)

/**
 * Re-evaluates one listener and sends them the sound at their current volume, pan and muffle.
 *
 * Only the mute half of the multi-z rule lives here, as an early out for a listener two floors
 * away. The halving and muffle for one floor belong to playsound_local(), which every send goes
 * through, so doing them here as well would halve twice.
 *
 * A finished non-repeating sound stays muted for a late arrival. The token outlives the audio
 * until its owner stops, so without this an instrument whose song ended replays from the top.
 *
 * The wall muffle is recomputed on every update rather than edge tracked, since an unmuted listener
 * is re-sent whenever either side moves. opacity_between(), not can_see(), whose get_step_towards
 * walk tests the wrong tiles at shallow angles. It never tests either end, so the same tile and all
 * eight neighbours read clear, which keeps the musicians clear. Every opaque object is read, where
 * point ambience reads only doors, and a grazed corner muffles too. Skipped across floors, where the
 * storey rule muffles instead.
 */
/datum/sound_token/proc/update_listener(mob/listener_mob, update_sound = TRUE)
	if(QDELETED(src))
		return
	if(isnull(listeners[listener_mob]))
		return

	var/turf/source_turf = get_turf(source)
	var/turf/listener_turf = get_turf(listener_mob)

	if(!source_turf || !listener_turf)
		return

	var/was_muted = listeners[listener_mob] & SOUND_MUTE
	var/should_be_muted = FALSE
	var/effective_volume = volume

	// Two or more floors away hears nothing. The one-floor rule is playsound_local's
	var/dz = abs(source_turf.z - listener_turf.z)
	if(dz >= 2)
		should_be_muted = TRUE

	if(get_dist_euclidean(source_turf, listener_turf) > range)
		should_be_muted = TRUE

	// Polled rather than TG's TRAIT_DEAF signals, deafness here being ear state. A change lands
	// on the next movement or replay
	if(!listener_mob.can_hear())
		should_be_muted = TRUE

	// A finished non-repeating sound stays muted for a late arrival. See the proc doc
	if(!repeating && sound_duration && (REALTIMEOFDAY - start_time) >= sound_duration)
		should_be_muted = TRUE

	if(should_be_muted && was_muted)
		return

	// Wall muffle, same floor only. See the proc doc
	var/muffled = FALSE
	if(muffle_behind_walls && !should_be_muted && !dz)
		muffled = (opacity_between(listener_turf, source_turf, range, TRUE) != OCCLUSION_CLEAR) ? SOUND_MUFFLE_WALL : SOUND_MUFFLE_NONE

	set_listener_status(listener_mob, should_be_muted ? SOUND_MUTE : NONE)
	if(!should_be_muted && was_muted && on_listener_audible)
		on_listener_audible.Invoke(listener_mob)
	send_listener_sound(listener_mob, update_sound, effective_volume, muffled)

/datum/sound_token/proc/send_listener_sound(mob/listener_mob, update_sound, effective_volume, muffled = FALSE)
	PRIVATE_PROC(TRUE)

	if(isnull(effective_volume))
		effective_volume = volume

	sound.status = listeners[listener_mob]
	// Always an update, so it mutes whatever the channel is playing and does nothing to an idle one
	if(sound.status & SOUND_MUTE)
		sound.status |= SOUND_UPDATE
		SEND_SOUND(listener_mob, sound)
		return

	// An update reaches only a channel already playing this file. See started_listeners
	if(update_sound && LAZYACCESS(started_listeners, listener_mob))
		sound.status |= SOUND_UPDATE
	else
		sound.offset = calculate_offset()

	// The Instruments slider under Master stands in for Sound Effects on bards and music boxes
	var/datum/preferences/prefs = listener_mob.client?.prefs
	var/volume_pref = (respect_instrument_pref && prefs) ? prefs.at_overall(prefs.instrumentvol) : null
	// Routed through playsound_local, which applies falloff, panning and the player's
	// volume sliders on every send, updates included, so re-sends stay pref-scaled
	var/sent = listener_mob.playsound_local(get_turf(source), vol = effective_volume, falloff_exponent = falloff_exponent, channel = sound_channel, S = sound, max_distance = range, falloff_distance = falloff_distance, use_reverb = TRUE, muffled = muffled, volume_pref = volume_pref)
	sound.offset = null
	if(sent)
		LAZYSET(started_listeners, listener_mob, TRUE)
		return
	// Refused, so muted where it plays. A channel that never started stays out of started_listeners
	sound.status = SOUND_UPDATE|SOUND_MUTE
	SEND_SOUND(listener_mob, sound)

/// Queues every listener for a refresh. Used when the SOURCE moved or the volume changed
/datum/sound_token/proc/update_all_listeners()
	for(var/mob/listener_mob in listeners)
		if(listener_mob.client)
			SSsound_tokens.clients_needing_update[listener_mob.client] = TRUE

/datum/sound_token/proc/force_update_all_listeners(update_sound = TRUE)
	for(var/mob/listener_mob in listeners)
		if(listener_mob.client)
			update_listener(listener_mob, update_sound)

/// Setter for volume
/datum/sound_token/proc/set_volume(new_volume, update_listeners = TRUE)
	volume = new_volume
	if(update_listeners)
		update_all_listeners()

/// Set the status of a listener. Does not update the sound.
/datum/sound_token/proc/set_listener_status(mob/listener_mob, new_status)
	if(isnull(listeners[listener_mob]))
		return

	listeners[listener_mob] = new_status

/datum/sound_token/proc/listener_deleted(datum/source)
	SIGNAL_HANDLER
	remove_listener(source)

/// Respond to any mob in the world being logged into. Only adds if the mob is within range.
/datum/sound_token/proc/player_login(datum/source, mob/player)
	SIGNAL_HANDLER
	var/turf/player_turf = get_turf(player)
	var/turf/source_turf = get_turf(src.source)
	if(!player_turf || !source_turf)
		return
	if(abs(player_turf.z - source_turf.z) >= 2) // Matches the multi-z audibility rule
		return
	if(get_dist_euclidean(source_turf, player_turf) > range)
		return
	add_or_update_listener(player)

/// Respond to any cliented mob becoming uncliented
/datum/sound_token/proc/player_logout(datum/source, mob/player)
	SIGNAL_HANDLER
	remove_listener(player)

/// If the sound source moves, update tracked cells then refresh all listener positions.
/// Also fires for INDIRECT movement. See update_holder_tracking()
/datum/sound_token/proc/source_moved()
	SIGNAL_HANDLER
	update_holder_tracking()
	update_tracked_cells()
	update_all_listeners()

/**
 * Watches the outermost movable our source sits inside, so a carried source still tracks.
 *
 * BYOND does not propagate Moved() to contents: a music box in someone's hands never fires
 * COMSIG_MOVABLE_MOVED as they walk, only the carrier does. Without this a carried source
 * keeps the spatial cells it had when it started playing, so people near where it went never
 * become listeners, and people who stand still never hear it approach.
 * Re-evaluated from source_moved() because picking an item up or dropping it DOES change the
 * item's own loc, which is exactly when the holder we should be watching changes.
 */
/datum/sound_token/proc/update_holder_tracking()
	var/atom/movable/new_holder
	var/atom/checking = source?.loc
	while(ismovable(checking))
		new_holder = checking
		checking = checking.loc
	if(new_holder == tracked_holder)
		return
	if(tracked_holder)
		UnregisterSignal(tracked_holder, COMSIG_MOVABLE_MOVED)
	tracked_holder = new_holder
	if(tracked_holder)
		RegisterSignal(tracked_holder, COMSIG_MOVABLE_MOVED, PROC_REF(source_moved))

/datum/sound_token/proc/source_deleted()
	SIGNAL_HANDLER

	qdel(src)

/**
 * Calculates the offset to give the sound for people who start hearing it mid-play
 *
 * sound.frequency holds absolute Hz from get_rand_frequency(), not the percentage TG divides by 100
 * for, so the factor divides by 44100, the rate of a 44.1 kHz file. A 48 kHz file seeks
 * 48000/44100 too far, about 9%.
 *
 * An unknown length returns 0. get_sound_length() answers 0 for a file it cannot measure, and a
 * seek past the end plays nothing, which would leave a returning listener silent for the rest of
 * the round. Offsets are deciseconds until the last line, since sound.offset is in seconds.
 */
/datum/sound_token/proc/calculate_offset()
	var/elapsed = REALTIMEOFDAY - start_time
	var/freq_factor = sound.frequency ? (sound.frequency / 44100) : 1
	var/pitch_factor = (sound.pitch || 100) / 100
	var/offset = elapsed * freq_factor * pitch_factor
	if(!sound_duration)
		// Length unknown, so any seek is a guess. See the proc doc
		return 0
	if(repeating)
		offset %= sound_duration
	else if(offset >= sound_duration)
		return 0 // A finished one-shot, and seeking past its end plays nothing
	// sound.offset is in seconds, everything above in deciseconds
	return offset / 10

/// TRUE if the mob's current spatial grid cell is tracked by any of our trackers
/datum/sound_token/proc/mob_in_tracked_cells(mob/listener_mob)
	PRIVATE_PROC(TRUE)
	var/datum/spatial_grid_cell/mob_cell = SSspatial_grid.get_cell_of(listener_mob)
	if(!mob_cell)
		return FALSE
	for(var/datum/cell_tracker/tracker as anything in cell_trackers)
		if(mob_cell in tracker.member_cells)
			return TRUE
	return FALSE

///Update tracked cells; happens on movement. We need to check if anyone is now out of cell range and kick them out.
/datum/sound_token/proc/update_tracked_cells()
	var/turf/source_turf = get_turf(source)
	if(!source_turf)
		return

	// One tracker per z we can be heard on. Cells never overlap between z's, so the
	// per-cell signal bookkeeping below cannot double up across trackers
	var/list/track_turfs = list(source_turf)
	var/turf/above_turf = GET_TURF_ABOVE(source_turf)
	if(above_turf)
		track_turfs += above_turf
	var/turf/below_turf = GET_TURF_BELOW(source_turf)
	if(below_turf)
		track_turfs += below_turf

	if(!cell_trackers)
		cell_trackers = list()
	while(length(cell_trackers) < length(track_turfs))
		cell_trackers += new /datum/cell_tracker(range, range)
	var/retired_a_tracker = FALSE
	while(length(cell_trackers) > length(track_turfs)) // Crossed to somewhere with fewer visible z's
		retired_a_tracker = TRUE
		var/datum/cell_tracker/retired = cell_trackers[length(cell_trackers)]
		for(var/datum/spatial_grid_cell/cell as anything in retired.member_cells)
			UnregisterSignal(cell, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS)))
		retired.member_cells.Cut() // cell_tracker/Destroy refuses qdel. Drained, it just drops with our ref
		cell_trackers.len--

	var/list/datum/spatial_grid_cell/added_cells = list()
	var/list/datum/spatial_grid_cell/removed_cells = list()
	for(var/i in 1 to length(track_turfs))
		var/datum/cell_tracker/tracker = cell_trackers[i]
		var/list/new_and_old = tracker.recalculate_cells(track_turfs[i])
		added_cells += new_and_old[1]
		removed_cells += new_and_old[2]

	for(var/datum/spatial_grid_cell/cell as anything in removed_cells)
		UnregisterSignal(cell, list(SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS),))

	// Remove listeners whose mob is no longer in any remaining member cell
	// A retired tracker's cells never reach removed_cells, so retiring one runs this too
	if(removed_cells.len || retired_a_tracker)
		for(var/mob/listener_mob as anything in listeners)
			if(!mob_in_tracked_cells(listener_mob))
				remove_listener(listener_mob)

	for(var/datum/spatial_grid_cell/cell as anything in added_cells)
		RegisterSignal(cell, SPATIAL_GRID_CELL_ENTERED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_cell_client_entered))
		RegisterSignal(cell, SPATIAL_GRID_CELL_EXITED(SPATIAL_GRID_CONTENTS_TYPE_CLIENTS), PROC_REF(on_cell_client_exited))
		for(var/mob/listener_mob as anything in cell.client_contents)
			add_or_update_listener(listener_mob)

/// Signal handler for SPATIAL_GRID_CELL_ENTERED on tracked cells. Adds newly arriving mobs as listeners.
/datum/sound_token/proc/on_cell_client_entered(datum/source, list/entering_mobs)
	SIGNAL_HANDLER

	for(var/mob/listener_mob as anything in entering_mobs)
		if(!isnull(listeners[listener_mob])) // already added
			continue
		add_or_update_listener(listener_mob)

/// Signal handler for SPATIAL_GRID_CELL_EXITED on tracked cells. Removes mobs who have left all member cells.
/datum/sound_token/proc/on_cell_client_exited(datum/source, list/exiting_mobs)
	SIGNAL_HANDLER
	for(var/mob/listener_mob as anything in exiting_mobs)
		if(!mob_in_tracked_cells(listener_mob))
			remove_listener(listener_mob)

///The sound should have ended on all clients. Time to destroy the sound token.
/datum/sound_token/proc/on_sound_ended()
	qdel(src)

/**
 * Creates a soundtoken datum (a sound that updates for movement).
 * allowed_listeners is an optional list of mobs that are the only ones that can hear this sound ever.
 * sound_length is an optional length of the sound. Things like TTS need to pass this since we can't dynamically grab the length in that case.
 * vary is an optional pitch roll, one for the token and shared by every listener.
 */
/proc/playsoundtoken(atom/source, soundin, volume, range, falloff_exponent, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, allowed_listeners, sound_length, vary = FALSE)
	var/datum/sound_token/token = new /datum/sound_token(source, soundin, range, volume, falloff_exponent, falloff_distance, allowed_listeners, sound_length, _delete_on_end = TRUE, _vary = vary)
	if(QDELETED(token)) // No sound channel was free
		return null
	token.start_tracking()
	return token
