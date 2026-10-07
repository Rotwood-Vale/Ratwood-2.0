
/**
 * Positional sound tracked through the spatial grid.
 *
 * Source and listener movement queue updates to volume and pan without restarting playback. Tokens
 * also track carried sources, enforce hearing and floor restrictions, and synchronize new listeners
 * using the playback offset.
 */
/datum/sound_token
	/// The atom playing the sound.
	var/atom/source
	/// k:v list of mob : sound status
	var/list/listeners = list()
	/// Listener to sound datum already started on their channel, including muted playback.
	/// A missing or different sound requires a full send instead of SOUND_UPDATE
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

	/// Whether to roll one random pitch shared by all listeners and retained across positional
	/// updates
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
	/// File time advanced per real-time decisecond, resolved when the file or frequency changes
	var/playback_speed = 1
	/// Caller-provided duration override for when the length cannot be sniffed from the file
	var/sound_duration_override
	/// Spatial trackers for audible floors. Index one always tracks the source floor. Adjacent
	/// floors are omitted for same_floor_only
	var/list/datum/cell_tracker/cell_trackers
	///Should we destroy the datum when the sound is done?
	var/delete_on_end = FALSE
	///Do we repeat the sound using sound.repeat?
	var/repeating = FALSE
	/// Uses the listener's Instruments slider instead of Sound Effects
	var/respect_instrument_pref = FALSE
	/// Muffles same-floor listeners behind walls, like playsound() with SOUND_TRAVEL_CARRYING.
	/// Allowed cross-floor listeners receive storey muffling in playsound_local()
	var/muffle_behind_walls = FALSE
	/// Restricts listener tracking and playback to the source floor.
	var/same_floor_only = FALSE
	/// Optional callback invoked with (listener) each time a listener crosses from muted to audible
	var/datum/callback/on_listener_audible
	/// Outermost movable containing the source. Its movement signal tracks carried items whose own
	/// loc does not change
	var/atom/movable/tracked_holder
	/// Song name to file map used when a listener replaces uploaded songs with built-in music
	var/list/stand_in_songs
	/// Whether the playing file is a player upload
	var/uploaded = FALSE
	/// One of stand_in_songs, picked per file so every listener who turned uploads off hears the same one
	var/sound/stand_in
	/// The stand in's length in deciseconds, for its offset
	var/stand_in_duration

/datum/sound_token/New(atom/_source, _sound, _range = 10, _volume = 50, _falloff_exponent, _falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, _allowed_listeners, _sound_duration_override, _delete_on_end, _repeating, start_time_override, _vary = FALSE, _sample_rate = 44100)
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

	if(!update_sound(_sound, sample_rate = _sample_rate))
		return // No channel left, and update_sound() already qdel'd us

	// A shared start time gives band members the same playback offset
	if(start_time_override)
		start_time = start_time_override

	null_sound = sound(channel = sound_channel)

	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGIN, PROC_REF(player_login))
	RegisterSignal(SSdcs, COMSIG_GLOB_PLAYER_LOGOUT, PROC_REF(player_logout))
	update_holder_tracking()


/**
 * Gathers initial listeners and begins playback after token configuration.
 *
 * Adding a listener sends immediately, so this runs separately from New() to let callers set
 * preferences and callbacks before the first send.
 */
/datum/sound_token/proc/start_tracking()
	// Callers can set stand_in_songs after New()
	refresh_stand_in()
	update_tracked_cells()

/datum/sound_token/Destroy(force, ...)
	for(var/listener in listeners)
		remove_listener(listener)
	listeners = null
	source = null
	// Drain cell membership before dropping trackers. Token teardown removes their signal
	// registrations
	for(var/datum/cell_tracker/tracker as anything in cell_trackers)
		tracker.member_cells.Cut()
	cell_trackers = null
	on_listener_audible = null
	tracked_holder = null
	stand_in = null
	stand_in_songs = null
	return ..()

/**
 * Replaces the current sound and returns FALSE if no channel is available.
 *
 * Arguments:
 * * sample_rate - Original file rate in Hz, used to calculate playback speed when frequency is
 *   absolute. Relative frequencies already specify speed. Zero uses normal speed.
 */
/datum/sound_token/proc/update_sound(_sound, start_playing = FALSE, _repeating = null, sample_rate = 44100)
	if(!isnull(_repeating))
		repeating = _repeating
	sound = sound(_sound)
	sound.repeat = repeating
	if(vary)
		sound.frequency = get_rand_frequency()
	playback_speed = abs(sound.frequency) || 1
	if(playback_speed > 100)
		playback_speed /= sample_rate
	if(!sound_channel)
		sound_channel = SSsounds.reserve_sound_channel_for_datum(src)
		if(!sound_channel)
			// Report channel exhaustion and let the caller handle the failed token
			stack_trace("sound_token for [source] found no free sound channel; deleting itself")
			sound_channel = null
			qdel(src)
			return FALSE
	sound.channel = sound_channel
	sound_duration = sound_duration_override || SSsounds.get_sound_length(_sound)
	start_time = REALTIMEOFDAY
	started_listeners = null
	refresh_stand_in()
	if(start_playing)
		force_update_all_listeners(FALSE)
	if(delete_on_end && !repeating)
		// A low pitch roll plays slower than the file, so its length alone would cut the end off
		addtimer(CALLBACK(src, PROC_REF(on_sound_ended)), sound_duration / playback_speed, TIMER_UNIQUE | TIMER_OVERRIDE)
	return TRUE

/// Picks the stand in for an upload, or clears it for a stock file. Once per file, so every listener
/// who turned uploads off hears the same one
/datum/sound_token/proc/refresh_stand_in()
	PRIVATE_PROC(TRUE)
	uploaded = IS_UPLOADED_SONG(sound.file)
	stand_in = null
	if(!uploaded || !length(stand_in_songs))
		return
	var/song_file = stand_in_songs[pick(stand_in_songs)]
	stand_in = sound(song_file)
	stand_in.channel = sound_channel
	stand_in.repeat = repeating
	// The token's one pitch roll, so a stand in sounds as varied as the upload would
	stand_in.frequency = sound.frequency
	stand_in_duration = SSsounds.get_sound_length(song_file)

/**
 * Returns the sound this listener is allowed to hear.
 *
 * Listeners who replace uploads receive the stand-in, or null if no stand-in is available. They are
 * never sent the uploaded file.
 */
/datum/sound_token/proc/sound_for(mob/listener_mob)
	PRIVATE_PROC(TRUE)
	if(!uploaded)
		return sound
	var/datum/preferences/prefs = listener_mob.client?.prefs
	if(!prefs || (prefs.toggles & SOUND_UPLOADED_SONGS))
		return sound
	return stand_in

/// Updates the data of a listener, or adds them if they are not present.
/datum/sound_token/proc/add_or_update_listener(mob/listener_mob)
	if(isnull(listeners[listener_mob]))
		if(!add_listener(listener_mob))
			return FALSE
	else
		update_listener(listener_mob)

/**
 * Adds a listener to the sound. returns TRUE if we already were added, or for some reason couldnt
 * be added.
 *
 * Initial status is SOUND_MUTE so the first audible update triggers on_listener_audible, including
 * when a listener enters a grid cell already in earshot. Listeners outside audible range receive no
 * initial sound. started_listeners records when a full send is needed.
 *
 * SSsound_tokens registers movement once per listening mob, including listeners currently out of
 * earshot, so stationary sources update when their audience moves.
 */
/datum/sound_token/proc/add_listener(mob/listener_mob)
	if(!isnull(listeners[listener_mob]))
		return TRUE

	if(!listener_mob.client || isnewplayer(listener_mob))
		return FALSE

	if(allowed_listeners && !allowed_listeners[listener_mob])
		return FALSE

	listeners[listener_mob] = SOUND_MUTE
	LAZYOR(listener_mob.sound_tokens, src)
	if(source != listener_mob) //this is possible...yea... :/
		RegisterSignal(listener_mob, COMSIG_QDELETING, PROC_REF(listener_deleted))
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
	if(listener_mob.client)
		SEND_SOUND(listener_mob, null_sound)

/**
 * Updates a listener's hearing state, volume, position and muffling.
 *
 * Applies token floor restrictions here. playsound_local() handles attenuation for an allowed
 * adjacent floor. Applying that attenuation here too would reduce volume twice.
 *
 * Same-floor wall muffling uses opacity_between(), which excludes the endpoints and reads opaque
 * objects along the line. Hearing and obstruction are rechecked on updates. Finished non-repeating
 * sounds do not restart for late arrivals.
 *
 * started_listeners records the sound established on each listener's channel, including muted
 * playback. SOUND_UPDATE needs that existing sound. New or replaced sounds require a full send at
 * the current offset. File changes clear the map, and uploaded-song substitutes are tracked per
 * listener.
 *
 * If either end has no turf, stop any established channel so playback cannot remain at its last
 * valid position.
 */
/datum/sound_token/proc/update_listener(mob/listener_mob, update_sound = TRUE)
	if(QDELETED(src))
		return
	if(isnull(listeners[listener_mob]))
		return

	var/turf/source_turf = get_turf(source)
	var/turf/listener_turf = get_turf(listener_mob)

	if(!source_turf || !listener_turf)
		if(LAZYACCESS(started_listeners, listener_mob))
			SEND_SOUND(listener_mob, null_sound)
			LAZYREMOVE(started_listeners, listener_mob)
		set_listener_status(listener_mob, SOUND_MUTE)
		return

	var/was_muted = listeners[listener_mob] & SOUND_MUTE
	var/should_be_muted = FALSE
	var/effective_volume = volume

	var/dz = abs(source_turf.z - listener_turf.z)
	if(dz >= 2 || (same_floor_only && dz))
		should_be_muted = TRUE

	if(get_dist_euclidean(source_turf, listener_turf) > range)
		should_be_muted = TRUE

	// Hearing depends on current ear state and is rechecked on movement or replay
	if(!listener_mob.can_hear())
		should_be_muted = TRUE

	if(!repeating && sound_duration && (REALTIMEOFDAY - start_time) * playback_speed >= sound_duration)
		should_be_muted = TRUE

	if(should_be_muted && was_muted)
		return

	var/muffled = FALSE
	if(muffle_behind_walls && !should_be_muted && !dz)
		muffled = (opacity_between(listener_turf, source_turf, range, TRUE) != OCCLUSION_CLEAR) ? SOUND_MUFFLE_WALL : SOUND_MUFFLE_NONE

	set_listener_status(listener_mob, should_be_muted ? SOUND_MUTE : NONE)
	// Async, since this runs from signal handlers and the callback is the caller's code
	if(!should_be_muted && was_muted && on_listener_audible)
		on_listener_audible.InvokeAsync(listener_mob)
	send_listener_sound(listener_mob, update_sound, effective_volume, muffled)

/datum/sound_token/proc/send_listener_sound(mob/listener_mob, update_sound, effective_volume, muffled = FALSE)
	PRIVATE_PROC(TRUE)

	if(isnull(effective_volume))
		effective_volume = volume

	// Changing the upload preference requires a full send when the selected file differs from the
	// playing file
	var/sound/playing = LAZYACCESS(started_listeners, listener_mob)
	var/sound/listener_sound = sound_for(listener_mob)

	if(listeners[listener_mob] & SOUND_MUTE)
		// Only a channel that started has anything to mute, and the packet names its file
		if(!playing)
			return
		playing.status = SOUND_UPDATE|SOUND_MUTE
		SEND_SOUND(listener_mob, playing)
		return

	// Uploads off and no stand in, so stop anything playing and send nothing else
	if(!listener_sound)
		if(playing)
			SEND_SOUND(listener_mob, null_sound)
			LAZYREMOVE(started_listeners, listener_mob)
		return

	// An update reaches only a channel already playing this file. See started_listeners
	if(update_sound && playing == listener_sound)
		listener_sound.status = SOUND_UPDATE
	else
		var/offset = calculate_offset((listener_sound == stand_in) ? stand_in_duration : sound_duration)
		// A sound that does not loop and has ended starts nothing, and anything else playing stops
		if(isnull(offset))
			if(playing)
				SEND_SOUND(listener_mob, null_sound)
				LAZYREMOVE(started_listeners, listener_mob)
			return
		listener_sound.status = NONE
		listener_sound.offset = offset

	var/datum/preferences/prefs = listener_mob.client?.prefs
	var/volume_pref = (respect_instrument_pref && prefs) ? prefs.at_overall(prefs.instrumentvol) : null
	// Apply spatial settings and preferences to updates as well as initial sends
	var/sent = listener_mob.playsound_local(get_turf(source), vol = effective_volume, falloff_exponent = falloff_exponent, channel = sound_channel, S = listener_sound, max_distance = range, falloff_distance = falloff_distance, use_reverb = TRUE, muffled = muffled, volume_pref = volume_pref)
	listener_sound.offset = null
	if(sent)
		LAZYSET(started_listeners, listener_mob, listener_sound)
		return
	// Mute an established channel if playsound_local() rejected the send
	if(!playing)
		return
	playing.status = SOUND_UPDATE|SOUND_MUTE
	SEND_SOUND(listener_mob, playing)

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
	var/dz = abs(player_turf.z - source_turf.z)
	if(dz >= 2 || (same_floor_only && dz))
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
 * Tracks movement of the outermost movable containing the sound source.
 *
 * Moving a container does not send Moved() to its contents, so carried sources must follow the
 * carrier's signal. Re-evaluate after the source itself moves, including pickup and drop, to
 * replace the tracked holder.
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
 * Calculates the offset to give a sound for people who start hearing it mid-play
 *
 * Uses the supplied file duration and the token's playback speed. Unknown duration returns zero
 * because seeking past an unknown end could produce silence. Finished non-repeating sounds return
 * null instead, preventing a restart.
 *
 * The supplied duration and intermediate offset are in deciseconds. sound.offset requires seconds.
 */
/datum/sound_token/proc/calculate_offset(duration)
	var/elapsed = REALTIMEOFDAY - start_time
	var/offset = elapsed * playback_speed
	if(!duration)
		return 0
	if(repeating)
		offset %= duration
	else if(offset >= duration)
		return null
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

	// Use one tracker per audible floor. Cells on different floors cannot share membership
	var/list/track_turfs = list(source_turf)
	if(!same_floor_only)
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
	while(length(cell_trackers) > length(track_turfs))
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

	// Retired trackers do not contribute removed_cells, but their listeners still need removal
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
 * sample_rate is the file's original Hz, for timing a varied sound without changing its pitch.
 */
/proc/playsoundtoken(atom/source, soundin, volume, range, falloff_exponent, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, allowed_listeners, sound_length, vary = FALSE, sample_rate = 44100)
	var/datum/sound_token/token = new /datum/sound_token(source, soundin, range, volume, falloff_exponent, falloff_distance, allowed_listeners, sound_length, _delete_on_end = TRUE, _vary = vary, _sample_rate = sample_rate)
	if(QDELETED(token))
		return null
	token.start_tracking()
	return token
