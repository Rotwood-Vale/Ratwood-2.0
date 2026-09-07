#define DATUMLESS "NO_DATUM"

SUBSYSTEM_DEF(sounds)
	name = "Sounds"
	flags = SS_NO_FIRE
	init_order = INIT_ORDER_SOUNDS
	var/static/using_channels_max = CHANNEL_HIGHEST_AVAILABLE		//BYOND max channels
	/// Amount of channels to reserve for random usage rather than reservations being allowed to reserve all channels. Also a nice safeguard for when someone screws up.
	var/static/random_channels_min = 50

	// Hey uh these two needs to be initialized fast because the whole "things get deleted before init" thing.
	/// Assoc list, `"[channel]" =` either the datum using it or TRUE for an unsafe-reserved (datumless reservation) channel
	var/list/using_channels
	/// Assoc list datum = list(channel1, channel2, ...) for what channels something reserved.
	var/list/using_channels_by_datum
	// Special datastructure for fast channel management
	/// List of all channels as numbers
	var/list/channel_list
	/// Associative list of all reserved channels associated to their position. `"[channel_number]" =` index as number
	var/list/reserved_channels
	/// lower iteration position - Incremented and looped to get "random" sound channels for normal sounds. The channel at this index is returned when asking for a random channel.
	var/channel_random_low
	/// higher reserve position - decremented and incremented to reserve sound channels, anything above this is reserved. The channel at this index is the highest unreserved channel.
	var/channel_reserve_high

	/// all sound files
	var/list/all_sounds = list()
	/// all music files
	var/list/all_music_sounds = list()

/datum/controller/subsystem/sounds/Initialize()
	// Cached here rather than read per send: playsound_local runs on every footstep in the game and
	// a CONFIG_GET is a proc call. A change needs a restart, which is what tuning it wants anyway.
	GLOB.sound_storey_tiles = CONFIG_GET(number/sound_storey_tiles)
	setup_available_channels()
	find_all_available_sounds()
	. = ..()

	preload_music_for_clients()

/datum/controller/subsystem/sounds/proc/setup_available_channels()
	channel_list = list()
	reserved_channels = list()
	using_channels = list()
	using_channels_by_datum = list()
	for(var/i in 1 to using_channels_max)
		channel_list += i
	channel_random_low = 1
	channel_reserve_high = length(channel_list)

/datum/controller/subsystem/sounds/proc/find_all_available_sounds()
	all_sounds = list()
	// Put more common extensions first to speed this up a bit
	var/static/list/valid_file_extensions = list(
		".ogg",
		".wav",
		".mid",
		".midi",
		".mod",
		".it",
		".s3m",
		".xm",
		".oxm",
		".raw",
		".wma",
		".aiff",
	)

	all_sounds = pathwalk("sound/", valid_file_extensions)

	all_music_sounds = pathwalk("sound/ambience/", valid_file_extensions)
	all_music_sounds += pathwalk("sounds/music/", valid_file_extensions)

/datum/controller/subsystem/sounds/proc/preload_music_for_clients()
	for(var/client/player as anything in GLOB.clients)
		player.preload_music()

/// Removes a channel from using list.
/datum/controller/subsystem/sounds/proc/free_sound_channel(channel)
	var/text_channel = num2text(channel)
	var/using = using_channels[text_channel]
	using_channels -= text_channel
	if(using != DATUMLESS) // datum channel
		using_channels_by_datum[using] -= channel
		if(!length(using_channels_by_datum[using]))
			stop_tracking_datum(using)
	else
		// Deviation from TG, which leaves the entry behind: DATUMLESS channels are tracked
		// in using_channels_by_datum too, so freeing one individually should drop it there.
		// No stop_tracking_datum for these, as there is no datum and no signal to unregister.
		using_channels_by_datum[DATUMLESS] -= channel
	free_channel(channel)

/// Frees all the channels a datum is using.
/datum/controller/subsystem/sounds/proc/free_datum_channels(datum/D)
	var/list/L = using_channels_by_datum[D]
	if(!L)
		return
	for(var/channel in L)
		using_channels -= num2text(channel)
		free_channel(channel)
	stop_tracking_datum(D)

/// Frees all datumless channels
/datum/controller/subsystem/sounds/proc/free_datumless_channels()
	free_datum_channels(DATUMLESS)

/// Reserve a sound channel. NO AUTOMATIC CLEANUP, free it later with free_sound_channel(). Returns an integer for channel.
/datum/controller/subsystem/sounds/proc/reserve_sound_channel()
	. = reserve_channel()
	if(!.)		//oh no..
		return FALSE
	var/text_channel = num2text(.)
	using_channels[text_channel] = DATUMLESS
	LAZYINITLIST(using_channels_by_datum[DATUMLESS])
	using_channels_by_datum[DATUMLESS] += .

/// Reserves a channel for a datum. Automatic cleanup when the datum is deleted. Returns an integer for channel.
/datum/controller/subsystem/sounds/proc/reserve_sound_channel_for_datum(datum/D)
	if(!D)		//i don't like typechecks but someone will fuck it up
		CRASH("Attempted to reserve sound channel without datum using the managed proc.")
	.= reserve_channel()
	if(!.)
		// Deviation from TG, which CRASHes here: instruments need a polite refusal path
		// so a full pool reads as "no sound channels" to the player, not a runtime.
		return FALSE
	var/text_channel = num2text(.)
	using_channels[text_channel] = D
	LAZYINITLIST(using_channels_by_datum[D])
	using_channels_by_datum[D] += .

	RegisterSignal(D, COMSIG_QDELETING, PROC_REF(tracked_datum_deleted))

/// Stops tracking a datum's channels. Private proc.
/datum/controller/subsystem/sounds/proc/stop_tracking_datum(datum/D)
	PRIVATE_PROC(TRUE)

	using_channels_by_datum -= D
	if(isdatum(D)) // DATUMLESS is a string key with nothing to unregister
		UnregisterSignal(D, COMSIG_QDELETING)

/// Handles a tracked datum being deleted, automatically freeing the channels.
/// This is why reservations no longer root their datum against garbage collection:
/// the deletion itself clears the hard refs out of using_channels/using_channels_by_datum.
/datum/controller/subsystem/sounds/proc/tracked_datum_deleted(datum/source)
	SIGNAL_HANDLER
	PRIVATE_PROC(TRUE)

	free_datum_channels(source)

/**
 * Reserves a channel and updates the datastructure. Private proc.
 */
/datum/controller/subsystem/sounds/proc/reserve_channel()
	PRIVATE_PROC(TRUE)
	if(channel_reserve_high <= random_channels_min)		// out of channels
		return
	var/channel = channel_list[channel_reserve_high]
	reserved_channels[num2text(channel)] = channel_reserve_high--
	return channel

/**
 * Frees a channel and updates the datastructure. Private proc.
 */
/datum/controller/subsystem/sounds/proc/free_channel(number)
	PRIVATE_PROC(TRUE)
	var/text_channel = num2text(number)
	var/index = reserved_channels[text_channel]
	if(!index)
		CRASH("Attempted to (internally) free a channel that wasn't reserved.")
	reserved_channels -= text_channel
	// push reserve index up, which makes it now on a channel that is reserved
	channel_reserve_high++
	// swap the reserved channel wtih the unreserved channel so the reserve index is now on an unoccupied channel and the freed channel is next to be used.
	channel_list.Swap(channel_reserve_high, index)
	// now, an existing reserved channel will likely (exception: unreserving last reserved channel) be at index
	// get it, and update position.
	var/text_reserved = num2text(channel_list[index])
	if(!reserved_channels[text_reserved])				//if it isn't already reserved make sure we don't accidently mistakenly put it on reserved list!
		return
	reserved_channels[text_reserved] = index

/// Random available channel, returns text.
/datum/controller/subsystem/sounds/proc/random_available_channel_text()
	if(channel_random_low > channel_reserve_high)
		channel_random_low = 1
	. = "[channel_list[channel_random_low++]]"

/// Random available channel, returns number
/datum/controller/subsystem/sounds/proc/random_available_channel()
	if(channel_random_low > channel_reserve_high)
		channel_random_low = 1
	. = channel_list[channel_random_low++]

/// How many channels we have left.
/datum/controller/subsystem/sounds/proc/available_channels_left()
	return length(channel_list) - random_channels_min

/// Returns the duration of a sound file in deciseconds, cached. Thin wrapper keeping TG's
/// SSsounds.get_sound_length() call surface; the cache itself is rustg_sound_length()'s
/// static list rather than a duplicate one here.
/datum/controller/subsystem/sounds/proc/get_sound_length(file_path)
	return rustg_sound_length(file_path)

#undef DATUMLESS
