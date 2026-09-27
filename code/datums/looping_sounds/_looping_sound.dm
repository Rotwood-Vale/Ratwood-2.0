/**
 * A datum for sounds that need to loop, with a high amount of configurability.
 * Ported from tgstation; scheduling runs on SSsound_loops timers instead of a
 * per-tick subsystem walk. Local deviations are commented where they live.
 */
/datum/looping_sound
	/// (list or soundfile) Since this can be either a list or a single soundfile you can have random sounds. May contain further lists but must contain a soundfile at the end. In a list, path must have also be assigned a value or it will be assigned 0 and not play.
	var/mid_sounds
	/// The length of time to wait between playing mid_sounds. WARNING: Continuously looping sounds don't work very well with this, just don't set this if you are doing a continuous loop of machinery.
	var/mid_length = 10
	/// Amount of time to add/take away from the mid length, randomly
	var/mid_length_vary = 0
	/// If we should always play each sound once per loop of all sounds. Weights here only really effect order, and could be disgarded
	var/each_once = FALSE
	/// Whether if the sounds should be played in order or not. Defaults to FALSE.
	var/in_order = FALSE
	/// Override for volume of start sound.
	var/start_volume
	/// (soundfile) Played before starting the mid_sounds loop.
	var/start_sound
	/// How long to wait before starting the main loop after playing start_sound.
	var/start_length
	/// Override for volume of end sound.
	var/end_volume
	/// (soundfile) The sound played after the main loop has concluded.
	var/end_sound
	/// Chance per loop to play a mid_sound.
	var/chance
	/// Sound output volume.
	var/volume = 100
	/// Whether or not the sounds will vary in pitch when played.
	var/vary = FALSE
	/// Explicit frequency override fed through to playsound.
	var/frequency
	/// The max amount of loops to run for.
	var/max_loops
	/// The extra range of the sound in tiles, defaults to 0.
	var/extra_range = 0
	/// How much the sound will be affected by falloff per tile.
	var/falloff_exponent
	/// The falloff distance of the sound,
	var/falloff_distance
	/// Are the sounds subject to reverb? Defaults to TRUE.
	var/use_reverb = TRUE
	/// Are we ignoring walls? Defaults to TRUE.
	var/ignore_walls = TRUE

	// State stuff
	/// The source of the sound, or the recipient of the sound.
	var/atom/parent
	/// The ID of the timer that's used to loop the sounds.
	var/timer_id
	/// Has the looping started yet?
	var/loop_started = FALSE
	/// If we're using cut_mid, this is the list we cut from
	var/list/cut_list
	///The index of the current song we're playing in the mid_sounds list, only used if in_order is used
	///This is immediately set to 1, so we start the index at 0
	var/audio_index = 0

	// Args
	/// Do we skip the starting sounds?
	var/skip_starting_sounds = FALSE
	/// If true, plays directly to provided atoms instead of from them.
	var/direct
	/// Sound channel to play on, random if not provided
	var/sound_channel
	///If we want to reserve a random channel when we start playing sounds. Good for when there could be several sources of the same looping sound heard by the same
	var/reserve_random_channel = FALSE
	//If we reserve a random sound channel, store the channel number here so we can clean it up later.
	var/reserved_channel
	///Whether this looping sound uses sound tokens. This should only be true for sounds that need to update as the source or listeners move. (Generally long or important sounds)
	var/use_sound_tokens = FALSE
	///The sound token instance for this looping sound.
	var/datum/sound_token/sound_token_instance
	///Opt-out of native sound repeat even if this loop would otherwise qualify for it. Relevant if you need to know timings about when the loop ends for example.
	var/never_native_repeat = FALSE
	///Whether we're currently using native sound.repeat instead of re-firing on the SSsound_loops timer.
	var/native_repeat_active = FALSE

// Deviation from TG's argument order: _channel stays in slot 4 because weather passes
// CHANNEL_WEATHER positionally there, as it always has here.
/datum/looping_sound/New(
	_parent,
	start_immediately = FALSE,
	_direct = FALSE,
	_channel = 0,
	_skip_starting_sounds = FALSE,
)
	set_parent(_parent)
	direct = _direct
	skip_starting_sounds = _skip_starting_sounds
	if(_channel)
		sound_channel = _channel

	if(start_immediately)
		start()

/datum/looping_sound/Destroy()
	stop(TRUE)
	return ..()

/**
 * The proc to actually kickstart the whole sound sequence. This is what you should call to start the `looping_sound`.
 *
 * Arguments:
 * * on_behalf_of - The new object to set as a parent.
 */
/datum/looping_sound/proc/start(on_behalf_of)
	if(on_behalf_of)
		set_parent(on_behalf_of)
	if(timer_id || loop_started)
		return

	if(!use_sound_tokens && !sound_channel && reserve_random_channel)
		sound_channel = SSsounds.reserve_sound_channel()
		reserved_channel = sound_channel
	on_start()

/**
 * The proc to call to stop the sound loop.
 *
 * Arguments:
 * * null_parent - Whether or not we should set the parent to null (useful when destroying the `looping_sound` itself). Defaults to FALSE.
 */
/datum/looping_sound/proc/stop(null_parent = FALSE)
	stop_current()
	if(null_parent)
		set_parent(null)
	if(!timer_id && !loop_started)
		return
	on_stop()
	if(timer_id)
		deltimer(timer_id, SSsound_loops)
		timer_id = null
	loop_started = FALSE
	native_repeat_active = FALSE

	if(reserved_channel)
		sound_channel = null
		SSsounds.free_sound_channel(reserved_channel)
		reserved_channel = null

/// The proc that handles starting the actual core sound loop.
/datum/looping_sound/proc/start_sound_loop()
	loop_started = TRUE
	if(can_native_repeat())
		native_repeat_active = TRUE
		play(resolve_single_sound(), repeat_sound = TRUE)
		if(max_loops)
			timer_id = addtimer(CALLBACK(src, PROC_REF(stop)), mid_length * max_loops, TIMER_CLIENT_TIME | TIMER_DELETE_ME | TIMER_STOPPABLE, SSsound_loops)
		return
	// Pass world.time on this first call too. Upstream calls sound_loop() bare here, which
	// leaves start_time null, so the max_loops guard below evaluates world.time >= 0 + the
	// loop duration, true in any round past that many deciseconds. A max_loops loop would
	// stop before playing once. Only rat_alarm sets max_loops here, and it never fired.
	sound_loop(world.time)
	timer_id = addtimer(CALLBACK(src, PROC_REF(sound_loop), world.time), mid_length, TIMER_CLIENT_TIME | TIMER_STOPPABLE | TIMER_LOOP | TIMER_DELETE_ME, SSsound_loops)

/**
 * A simple proc handling the looping of the sound itself.
 *
 * Arguments:
 * * start_time - The time at which the `mid_sounds` started being played (so we know when to stop looping).
 */
/datum/looping_sound/proc/sound_loop(start_time)
	if(max_loops && world.time >= start_time + mid_length * max_loops)
		stop()
		return
	// If we have a timer, we're varying mid length, and this is happening while we're runnin mid_sounds
	if(timer_id && mid_length_vary && start_time)
		updatetimedelay(timer_id, mid_length + rand(-mid_length_vary, mid_length_vary), timer_subsystem = SSsound_loops)
	if(!chance || prob(chance))
		play(get_sound())

/**
 * Applies a new mid length to the sound
 */
/datum/looping_sound/proc/set_mid_length(new_mid)
	mid_length = new_mid
	if(native_repeat_active) // Native repeat is driven by the sound file's own length, not mid_length
		return
	if(!timer_id)
		return
	updatetimedelay(timer_id, mid_length + rand(-mid_length_vary, mid_length_vary), timer_subsystem = SSsound_loops)

/**
 * Replaces the mid_sounds list, resetting the each_once/in_order state that
 * referenced the old one. Kept from the old file for the music boxes and instruments.
 */
/datum/looping_sound/proc/set_mid_sounds(new_mid_sounds)
	mid_sounds = new_mid_sounds
	cut_list = null
	audio_index = 0

/**
 * Sets the loop's volume mid-flight, for weather severity.
 * Token loops re-send at the new volume; direct mob loops adjust their channel in place.
 */
/datum/looping_sound/proc/set_volume(new_volume)
	volume = new_volume
	if(sound_token_instance)
		sound_token_instance.set_volume(new_volume)
		return
	if(direct && ismob(parent) && sound_channel)
		var/mob/mob_parent = parent
		var/datum/preferences/listener_prefs = mob_parent.client?.prefs
		// The first send went through playsound_local, its sliders and its cap of 100, so the update
		// has to as well
		mob_parent.update_channel_volume(sound_channel, min(listener_prefs ? listener_prefs.at_overall(new_volume * listener_prefs.mastervol * 0.01) : new_volume, 100))

/**
 * The proc that handles actually playing the sound.
 *
 * Arguments:
 * * soundfile - The soundfile we want to play.
 * * volume_override - The volume we want to play the sound at, overriding the `volume` variable.
 * * repeat_sound - Whether the sound should loop natively via sound.repeat (token path only).
 * * delete_when_finished - Whether a freshly created sound token should self-delete once the sound ends (token path only).
 */
/datum/looping_sound/proc/play(soundfile, volume_override, repeat_sound = FALSE, delete_when_finished = FALSE)
	if(use_sound_tokens)
		if(QDELETED(sound_token_instance)) // self-deleted (source gone, or a finished one-shot)
			sound_token_instance = null
		if(sound_token_instance)
			sound_token_instance.set_volume(volume_override || volume, FALSE) // Don't update, we'll do that after
			sound_token_instance.update_sound(soundfile, TRUE, repeat_sound)
		else
			sound_token_instance = new /datum/sound_token(parent, soundfile, SOUND_RANGE + extra_range, volume_override || volume, falloff_exponent, falloff_distance || SOUND_DEFAULT_FALLOFF_DISTANCE, _delete_on_end = delete_when_finished, _repeating = repeat_sound)
			if(QDELETED(sound_token_instance)) // channel pool ran dry; refused politely
				sound_token_instance = null
			else
				// Configure BEFORE listeners are gathered: start_tracking() is what sends the
				// sound out, so anything set after it would arrive a beat late (and re-send).
				configure_token(sound_token_instance)
				sound_token_instance.start_tracking()
		return
	if(!parent)
		return
	var/sound/sound_to_play = sound(soundfile)
	sound_to_play.channel = sound_channel || SSsounds.random_available_channel()
	sound_to_play.volume = volume_override || volume //Use volume as fallback if theres no override
	if(direct)
		// Mob-directed loops go through playsound_local rather than TG's bare SEND_SOUND, so the
		// volume sliders and the listener's area environment keep applying as they always have here
		if(ismob(parent))
			var/mob/mob_parent = parent
			mob_parent.playsound_local(null, null, volume_override || volume, vary, frequency, channel = sound_to_play.channel, S = sound_to_play)
		else
			SEND_SOUND(parent, sound_to_play)
	else
		// Most loops play to nobody most of the time, so probe the spatial grid before paying
		// for playsound()
		if(!any_possible_listeners())
			return
		playsound(
			parent,
			sound_to_play,
			volume_override || volume,
			vary,
			extra_range,
			falloff_exponent = falloff_exponent,
			frequency = frequency,
			channel = sound_to_play.channel,
			ignore_walls = ignore_walls,
			falloff_distance = falloff_distance || SOUND_DEFAULT_FALLOFF_DISTANCE,
			use_reverb = use_reverb,
		)

/// Hook for subtypes to decorate a freshly created sound token (pref gates,
/// audibility callbacks) before its first listener update goes out.
/datum/looping_sound/proc/configure_token(datum/sound_token/token)
	return

/**
 * Over-approximate test for "could playsound() possibly reach anyone from here".
 *
 * Answers at spatial-grid-cell granularity and skips the per-turf distance filter, so
 * anyone actually in range always passes. The range is SOUND_RANGE plus extra_range, what
 * playsound() reaches.
 */
/datum/looping_sound/proc/any_possible_listeners()
	var/turf/source_turf = get_turf(parent)
	if(!source_turf)
		return FALSE

	// playsound() treats an omitted extrarange as 1 and keeps 0 as 0, so match that or we probe a
	// different box than it reaches
	var/probe_range = SOUND_RANGE + (isnull(extra_range) ? 1 : extra_range)

	if(SSspatial_grid.any_client_in_range(source_turf, probe_range))
		return TRUE

	if(!ignore_walls) // playsound() only reaches the other z-levels when the sound carries through walls
		return FALSE

	var/turf/above_turf = GET_TURF_ABOVE(source_turf)
	if(above_turf && SSspatial_grid.any_client_in_range(above_turf, probe_range))
		return TRUE

	var/turf/below_turf = GET_TURF_BELOW(source_turf)
	if(below_turf && SSspatial_grid.any_client_in_range(below_turf, probe_range))
		return TRUE

	return FALSE

/// Returns the sound we should now be playing.
/datum/looping_sound/proc/get_sound(_mid_sounds)
	var/list/play_from = _mid_sounds || mid_sounds
	if(!each_once)
		. = play_from
		while(!is_playable_sound(.) && !isnull(.))
			. = pick_weight_recursive(.)
		return .

	if(in_order)
		. = play_from
		audio_index++
		if(audio_index > length(play_from))
			audio_index = 1
		return .[audio_index]

	if(!length(cut_list))
		cut_list = shuffle(play_from.Copy())
	var/list/tree = list()
	. = cut_list
	while(!is_playable_sound(.) && !isnull(.))
		// Tree is a list of lists containign files
		// If an entry in the tree goes to 0 length, we cut it from the list
		tree += list(.)
		. = pick_weight_recursive(.)

	if(!is_playable_sound(.))
		return

	// Remove the sound file
	tree[length(tree)] -= .

	// Walk the tree bottom up, remove any lists that are empty
	// Don't do anything for the topmost list, cause we do not care
	for(var/i in length(tree) to 2 step -1)
		var/list/branch = tree[i]
		if(length(branch))
			break
		tree[i - 1] -= list(branch) // Remove the empty list
	return .

/// TG stops descending on isfile(); several subtypes here hold /sound datums too.
/datum/looping_sound/proc/is_playable_sound(candidate)
	return isfile(candidate) || istype(candidate, /sound)

/// Returns the lone soundfile mid_sounds resolves to, or null if it can pick between more than one file.
/datum/looping_sound/proc/resolve_single_sound()
	if(is_playable_sound(mid_sounds) || istext(mid_sounds))
		return mid_sounds
	if(islist(mid_sounds) && length(mid_sounds) == 1)
		var/only_sound = mid_sounds[1]
		if(is_playable_sound(only_sound) || istext(only_sound))
			return only_sound
	return null

/// Whether this loop qualifies for native sound.repeat instead of re-firing on a timer every mid_length.
/datum/looping_sound/proc/can_native_repeat()
	if(!use_sound_tokens || never_native_repeat)
		return FALSE
	if(chance || mid_length_vary || each_once || in_order)
		return FALSE
	return !!resolve_single_sound()

/// A proc that's there to handle delaying the main sounds if there's a start_sound, and simply starting the sound loop in general.
/datum/looping_sound/proc/on_start()
	var/start_wait = 0
	if(start_sound && !skip_starting_sounds)
		play(start_sound, start_volume)
		start_wait = start_length
	if(start_wait)
		timer_id = addtimer(CALLBACK(src, PROC_REF(start_sound_loop)), start_wait, TIMER_CLIENT_TIME | TIMER_DELETE_ME | TIMER_STOPPABLE, SSsound_loops)
	else
		start_sound_loop()

/// Stops sound playing on current channel, if specified
/datum/looping_sound/proc/stop_current()
	QDEL_NULL(sound_token_instance)
	if(!sound_channel || !ismob(parent))
		return
	var/mob/mob_parent = parent
	mob_parent.stop_sound_channel(sound_channel)

/// Simple proc that's executed when the looping sound is stopped, so that the `end_sound` can be played, if there's one.
/datum/looping_sound/proc/on_stop()
	if(end_sound && loop_started)
		play(end_sound, end_volume, delete_when_finished = TRUE)

/// A simple proc to change who our parent is set to, also handling registering and unregistering the QDELETING signals on the parent.
/datum/looping_sound/proc/set_parent(new_parent)
	if(parent)
		UnregisterSignal(parent, COMSIG_QDELETING)
	parent = new_parent
	if(parent)
		RegisterSignal(parent, COMSIG_QDELETING, PROC_REF(handle_parent_del))

/// A simple proc that lets us know whether the sounds are currently active or not.
/datum/looping_sound/proc/is_active()
	return loop_started || !!timer_id

/// A simple proc to handle the deletion of the parent, so that it does not force it to hard-delete.
/datum/looping_sound/proc/handle_parent_del(datum/source)
	SIGNAL_HANDLER
	set_parent(null)
	// Deviation from TG, which leaves an orphaned loop idling on its timer with play()
	// bailing every fire: a loop whose source is gone has nothing left to say.
	stop()
