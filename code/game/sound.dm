/**
 * Effective vertical distance in tiles, loaded from configuration by SSsounds.
 *
 * Read by STOREY_ADJUSTED_DISTANCE without a config lookup on each send. Zero disables added
 * distance while retaining separate floor attenuation.
 */
GLOBAL_VAR_INIT(sound_storey_tiles, 0)

/// Selects the falloff exponent for a sound's maximum range
/proc/sound_falloff_for_range(range)
	if(range >= SOUND_RANGE_LONG)
		return SOUND_FALLOFF_EXPONENT_LONG
	if(range >= SOUND_RANGE_MEDIUM)
		return SOUND_FALLOFF_EXPONENT_MEDIUM
	if(range < SOUND_RANGE_CLOSE)
		return SOUND_FALLOFF_EXPONENT_CLOSE
	return SOUND_FALLOFF_EXPONENT

/**
 * playsound is a proc used to play a 3D sound in a specific range. This uses SOUND_RANGE + extra_range to determine that.
 *
 * Arguments:
 * * source - Origin of sound.
 * * soundin - Either a file, or a string that can be used to get an SFX.
 * * vol - The volume of the sound, excluding falloff.
 * * vary - bool that determines if the sound changes pitch every time it plays.
 * * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE. Omitted means 1, see below.
 * * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * * frequency - playback speed of audio.
 * * channel - The channel the sound is played at.
 * * pressure_affected - kept for source compatibility. There is no atmos here, so it does nothing.
 * * ignore_walls - Whether or not the sound can pass through walls.
 * * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * use_reverb - bool default TRUE, determines if our sound has reverb.
 * * soundping - Show the visual sound ping effect on the source.
 * * anthro_noise - an anthro noise, not sent to listeners who mute anthro noise emotes
 * * min_volume - the volume the sound falls off to at max range, instead of to silence.
 * * travel - a SOUND_TRAVEL_* class: what a barrier between source and listener does. UNRESTRICTED
 *   by default. Every other class walks a line per listener when ignore_walls is TRUE.
 * * floor_volume - what a FLOOR does, separately. Null attenuates and halves as usual.
 *   SOUND_FLOOR_NEVER does not cross and skips gathering the floors either side. A positive number
 *   caps the volume there. Forced to NEVER for LEAKING and CONTAINED.
 * * erp - ERP audio: takes the ERP muffle timbre. playsound_erp and emote_erp set it, with CONTAINED
 *   or LEAKING.
 *
 * LEAKING and CONTAINED never cross floors. A soundproof source area also blocks open
 * openings and disables leakage. Resolve that area from the emitting position, including a
 * detached head. ERP traces follow one direct line, without corner searches. A permitted leak
 * still rejects any second barrier.
 *
 * Omitted extrarange defaults to one. Explicit zero must remain zero. Listener gathering uses
 * square distance while volume attenuation is Euclidean, keeping corner listeners at the volume
 * floor instead of excluding them. SOUND_FLOOR_NEVER avoids adjacent-floor gathers entirely.
 *
 * Same-tile and orthogonally adjacent listeners skip the trace. Diagonal listeners still use it,
 * although the trace excludes its endpoints and does not test the two adjacent corner tiles.
 */
/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff_exponent, frequency = null, channel = 0, pressure_affected = FALSE, ignore_walls = TRUE, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, use_reverb = TRUE, soundping = FALSE, anthro_noise = FALSE, min_volume = SOUND_DEFAULT_MIN_VOLUME, travel = SOUND_TRAVEL_UNRESTRICTED, floor_volume = null, erp = FALSE)
	if(isarea(source))
		CRASH("playsound(): source is an area")
	if(travel >= SOUND_TRAVEL_LEAKING)
		floor_volume = SOUND_FLOOR_NEVER

	// Accept null and list inputs for existing callers handled by get_sfx()
	var/soundfile = soundin
	if(istype(soundin, /sound))
		var/sound/sound = soundin
		soundfile = sound.file
	// Voice over sound, which implies it should come from the head.
	if(isdullahan(source) && findtext("[soundfile]", @"sound/vo"))
		var/mob/living/carbon/human/human = source
		var/datum/species/dullahan/dullahan = human.dna.species
		if(dullahan.headless)
			var/obj/item/bodypart/head/dullahan/head = dullahan.my_head
			source = head

	var/turf/turf_source = get_turf(source)
	if(!turf_source)
		return

	// Use the emitting area, which may differ from the caller's body location
	var/seal_openings = FALSE
	if(travel >= SOUND_TRAVEL_LEAKING)
		var/area/source_area = get_area(turf_source)
		seal_openings = source_area?.soundproof
		if(seal_openings)
			travel = SOUND_TRAVEL_CONTAINED

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	var/sound/S = soundin
	if(!istype(S))
		S = sound(get_sfx(soundin))
	if(isnull(extrarange))
		extrarange = 1
	var/maxdistance = SOUND_RANGE + extrarange
	// Falsy rather than isnull, so a 0 or FALSE in this slot takes the band's curve as an omitted one does
	if(!falloff_exponent)
		falloff_exponent = sound_falloff_for_range(maxdistance)

	if(falloff_distance >= maxdistance)
		// An invalid plateau should fall back to ordinary attenuation rather than suppress the
		// sound
		stack_trace("playsound(): falloff_distance [falloff_distance] >= maxdistance [maxdistance]")
		falloff_distance = 0

	if(vary && !frequency)
		frequency = get_rand_frequency() // skips us having to do it per-sound later

	if(soundping)
		ping_sound(source)

	var/list/listeners

	// Cross-floor gathering does not require a transparent floor
	if(!ignore_walls) //these sounds don't carry through walls or vertically
		listeners = get_hearers_in_view(maxdistance, turf_source, RECURSIVE_CONTENTS_CLIENT_MOBS)
	else
		listeners = get_hearers_in_range(maxdistance, turf_source, RECURSIVE_CONTENTS_CLIENT_MOBS)

		// Skip forbidden floors entirely. Probe allowed floors before building listener lists
		if(floor_volume != SOUND_FLOOR_NEVER)
			var/turf/above_turf = GET_TURF_ABOVE(turf_source)
			if(above_turf && SSspatial_grid.any_client_in_range(above_turf, maxdistance))
				listeners += get_hearers_in_range(maxdistance, above_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

			var/turf/below_turf = GET_TURF_BELOW(turf_source)
			if(below_turf && SSspatial_grid.any_client_in_range(below_turf, maxdistance))
				listeners += get_hearers_in_range(maxdistance, below_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

	var/occlude = ignore_walls ? travel : SOUND_TRAVEL_UNRESTRICTED
	for(var/mob/listening_mob in listeners) // Ignore null entries in the gathered listener list
		var/turf/mob_turf = get_turf(listening_mob)
		// A headless dullahan hears from wherever the head is
		if(isdullahan(listening_mob))
			var/mob/living/carbon/human/human = listening_mob
			var/datum/species/dullahan/dullahan = human.dna.species
			if(dullahan.headless)
				mob_turf = get_turf(dullahan.my_head)
		if(!mob_turf)
			continue
		if(anthro_noise && listening_mob.client?.prefs?.mute_anthro_noises)
			continue
		// get_dist, not euclidean: the gather is a square and a round gate drops its corners
		if(get_dist(mob_turf, turf_source) > maxdistance)
			continue
		var/muffled = SOUND_MUFFLE_NONE
		// Manhattan: nothing fits between a source and a listener on it or orthogonally beside it.
		// A different floor is handled by the storey rule in playsound_local, and this walk is 2D
		if(occlude && mob_turf.z == turf_source.z && (abs(mob_turf.x - turf_source.x) + abs(mob_turf.y - turf_source.y) > 1))
			muffled = occlusion_muffle_for(mob_turf, turf_source, occlude, maxdistance, seal_openings = seal_openings)
			// Blocked listeners remain in the returned gather but receive no sound
			if(isnull(muffled))
				continue
		listening_mob.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb, muffled = muffled, min_volume = min_volume, travel = travel, floor_volume = floor_volume, erp = erp)

	return listeners


/**
 * Plays ERP audio with explicit barrier and floor rules.
 *
 * CONTAINED stops at walls and closed openings. LEAKING permits muffled sound one tile beyond a
 * single closed opening on the direct line. Open openings pass both classes unless the source area
 * is soundproof. Neither class crosses floors.
 *
 * Omitting extrarange uses SOUND_RANGE, unlike playsound()'s additional tile.
 */
/proc/playsound_erp(atom/source, soundin, vol, vary, extrarange = 0, frequency = null, channel = 0, travel = SOUND_TRAVEL_CONTAINED)
	return playsound(source, soundin, vol, vary, extrarange, frequency = frequency, channel = channel, travel = travel, floor_volume = SOUND_TRAVEL_FLOOR(travel), erp = TRUE)


/proc/ping_sound(atom/A)
	var/image/I = image(icon = 'icons/effects/effects.dmi', loc = A, icon_state = "emote", layer = ABOVE_MOB_LAYER)
	if(!I)
		return
	I.pixel_y = 6
	I.mouse_opacity = MOUSE_OPACITY_TRANSPARENT
	flick_overlay(I, GLOB.clients, 6)

/proc/ping_sound_through_walls(turf/T)
	new /obj/effect/temp_visual/soundping(T)

/obj/effect/temp_visual/soundping
	plane = FULLSCREEN_PLANE
	layer = FLASH_LAYER
	icon = 'icons/effects/ore_visuals.dmi'
	icon_state = "zz"
	appearance_flags = 0 //to avoid having TILE_BOUND in the flags, so that the 480x480 icon states let you see it no matter where you are
	duration = 6
	pixel_x = -224
	pixel_y = -218

/*
/obj/effect/temp_visual/soundping/Initialize(mapload)
	. = ..()
	animate(src, alpha = 0, time = duration, easing = EASE_IN)
*/
/**
 * Plays a sound with a specific point of origin for src mob
 *
 * Arguments:
 * * turf_source - The turf our sound originates from, if this is not a turf, the sound is played with no spatial audio
 * * soundin - Either a file, or a string that can be used to get an SFX.
 * * vol - The volume of the sound, excluding falloff.
 * * vary - bool that determines if the sound changes pitch every time it plays.
 * * frequency - playback speed of audio.
 * * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume.
 * * channel - Optional: The channel the sound is played at.
 * * pressure_affected - kept for source compatibility. There is no atmos here, so it does nothing.
 * * S - Optional: the sound datum to send, defaults to building one from soundin.
 * * max_distance - number, determines the maximum distance of our sound. No falloff without it.
 * * falloff_distance - Distance at which falloff begins.
 * * distance_multiplier - Default 1, multiplies the perceived distance of our sound.
 * * use_reverb - bool default TRUE, determines if our sound has reverb.
 * * muffled - a SOUND_MUFFLE_* level: NONE, SOFT (the profile: heavier falloff, quieter, dead room),
 *   ENCLOSED (the profile plus the leak cap) or WALL (the profile with a deeper volume cut).
 *   Boolean callers pass TRUE, which is SOFT.
 * * min_volume - the volume the sound falls off to at max_distance, instead of to silence.
 * * travel - the SOUND_TRAVEL_* class playsound gathered with. Only LEAKING and CONTAINED are read
 *   here, each refusing a storey
 * * floor_volume - a cap on the volume a floor away, replacing the storey multiplier, as in playsound
 * * erp - ERP audio: a muffled send takes the ERP muffle timbre in place of the occlusion echo
 * * volume_pref - when set, replaces the Sound Effects slider under Master as the result's scale
 *
 * Short-range cross-floor sounds use the storey distance and volume rules, shared with
 * point ambience slim_send(). Long-range sounds bypass those rules. ERP containment still
 * rejects other floors, including for direct callers.
 *
 * S may be shared across listeners. Assign environment and echo on every path so one listener's
 * muffling cannot affect the next. Muffling overrides area reverb. An echo array replaces the
 * preset, so muffled ERP audio uses its environment without that array.
 *
 * Clamp min_volume to the source volume before falloff to prevent quiet sounds getting louder
 * with distance. Apply leakage and floor caps after falloff. A floor cap replaces the separate
 * storey multiplier. Listener preferences then scale the result.
 *
 * Pan softening changes direction but preserves magnitude, which BYOND also uses for attenuation.
 * Pass a resolved distance to STOREY_ADJUSTED_DISTANCE because it evaluates its argument repeatedly.
 */
/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent, channel = 0, pressure_affected = FALSE, sound/S, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE, muffled = FALSE, min_volume = SOUND_DEFAULT_MIN_VOLUME, travel = SOUND_TRAVEL_UNRESTRICTED, floor_volume = null, erp = FALSE, volume_pref = null)
	if(!client || !can_hear())
		return FALSE

	if(!S)
		S = sound(get_sfx(soundin))

	S.wait = 0 //No queue
	S.channel = channel || SSsounds.random_available_channel()

	// A headless dullahan listens from the head. A head shut in a container is muffled
	var/obj/item/bodypart/head/dullahan/user_head
	if(isdullahan(src))
		var/mob/living/carbon/human = src
		var/datum/species/dullahan/dullahan = human.dna.species
		if(dullahan.headless)
			user_head = dullahan.my_head
			// Preserve any wall muffling already selected by playsound()
			if(istype(user_head.loc, /obj/structure/closet) || istype(user_head.loc, /obj/item/storage/))
				muffled ||= SOUND_MUFFLE_SOFT
	// Detached heads supply the hearing position. Unpositioned sounds need no turf lookup
	var/atom/movable/tocheck = user_head ? user_head : src
	var/turf/turf_loc
	if(isturf(turf_source))
		turf_loc = get_turf(tocheck)

	var/storeys = (turf_loc && ((max_distance && max_distance < SOUND_RANGE_LONG) || travel >= SOUND_TRAVEL_LEAKING)) ? abs(turf_source.z - turf_loc.z) : 0
	if(storeys >= 2)
		return FALSE
	// Enforce ERP floor containment for direct playsound_local() callers too
	if(storeys && travel >= SOUND_TRAVEL_LEAKING)
		return FALSE
	if(storeys)
		muffled ||= SOUND_MUFFLE_SOFT

	// Resolved before the muffle scaling below, which multiplies it
	if(!falloff_exponent)
		falloff_exponent = sound_falloff_for_range(max_distance || SOUND_RANGE)

	if(muffled)
		falloff_exponent *= SOUND_MUFFLE_EXPONENT_MULT
		vol *= (muffled == SOUND_MUFFLE_WALL) ? SOUND_MUFFLE_WALL_VOLUME_MULT : SOUND_MUFFLE_VOLUME_MULT

	S.volume = vol

	// Assign every listener's environment: the shared sound datum may retain the previous
	// listener's value
	var/area/A = get_area(get_turf(src))
	if(muffled)
		S.environment = erp ? SOUND_ERP_MUFFLE_ENVIRONMENT : SOUND_MUFFLE_ENVIRONMENT
	else if(A && A.soundenv && A.soundenv != SOUND_ENVIRONMENT_NONE)
		// Truthy, not just "not NONE": soundenv defaults to 0, BYOND's generic preset
		S.environment = A.soundenv
	else if(isturf(turf_source))
		// Unpositioned sounds have no area acoustics
		S.environment = SOUND_DEFAULT_ENVIRONMENT
	else
		S.environment = SOUND_ENVIRONMENT_NONE

	if(vary)
		S.frequency = get_rand_frequency()
	if(frequency)
		S.frequency = frequency

	if(isturf(turf_source))
		//sound volume falloff with distance
		var/distance = get_dist_euclidean(turf_loc, turf_source) * distance_multiplier
		distance = STOREY_ADJUSTED_DISTANCE(distance, storeys)

		if(max_distance) // If theres no max_distance we're not a 3D sound, so no falloff
			// Fades to min_volume, not to nothing, and clamped to vol. See the proc doc
			var/volume_floor = min(min_volume, vol)
			S.volume -= CALCULATE_SOUND_VOLUME_RATIO(vol, distance, max_distance, falloff_distance, falloff_exponent) * (vol - volume_floor)

		// Apply caps after falloff so they limit received volume, not the source volume
		if(muffled == SOUND_MUFFLE_ENCLOSED && !storeys)
			S.volume = min(S.volume, SOUND_TRAVEL_LEAK_VOLUME)

		// A floor cap replaces the obstruction multiplier. Added geometric distance still applies
		if(storeys)
			if(isnull(floor_volume))
				S.volume *= SOUND_STOREY_VOLUME_MULT
			else
				S.volume = min(S.volume, floor_volume)

		// Pan from the body's own turf, with a one-tile dead zone that keeps adjacent sounds centered
		var/turf/our_turf = get_turf(src)
		var/dx = turf_source.x - our_turf.x
		if(dx <= 1 && dx >= -1)
			S.x = 0
		else
			S.x = dx
		var/dz = turf_source.y - our_turf.y
		if(dz <= 1 && dz >= -1)
			S.z = 0
		else
			S.z = dz

		// Soften hard panning while preserving magnitude, which BYOND also uses for attenuation
		if(S.x && SOUND_PAN_MIN_DEPTH)
			var/min_depth = abs(S.x) * SOUND_PAN_MIN_DEPTH
			if(abs(S.z) < min_depth)
				var/original = sqrt(S.x * S.x + S.z * S.z)
				S.z = (S.z < 0) ? -min_depth : min_depth
				var/widened = sqrt(S.x * S.x + S.z * S.z)
				if(widened)
					S.x *= original / widened
					S.z *= original / widened

		// Map each z-level to one sound-axis unit for closely stacked floors
		S.y = turf_source.z - our_turf.z

		S.falloff = max_distance || 1 // use max_distance, else just use 1 as we are a direct sound so falloff isnt relevant

		// An echo array replaces the preset. Leave it unset when using the ERP muffling
		// environment
		var/wants_occlusion = muffled && !erp && SOUND_MUFFLE_OCCLUSION
		if(wants_occlusion || !use_reverb || S.environment == SOUND_ENVIRONMENT_NONE)
			S.echo ||= new /list(18)
			if(wants_occlusion)
				S.echo[7] = SOUND_MUFFLE_OCCLUSION
				S.echo[8] = SOUND_MUFFLE_OCCLUSION_LF
			if(!use_reverb || S.environment == SOUND_ENVIRONMENT_NONE)
				S.echo[3] = -10000
				S.echo[4] = -10000
		else
			S.echo = null

	// Apply preferences after attenuation so they scale the entire volume curve
	if(client.prefs)
		S.volume *= (isnull(volume_pref) ? client.prefs.at_overall(client.prefs.mastervol) : volume_pref) * 0.01
	S.volume = min(S.volume, 100)

	if(S.volume <= 0)
		return FALSE //No sound

	SEND_SOUND(src, S)

	return S.volume

/// Plays a sound to every player in the round, unpositioned
/proc/sound_to_playing_players(soundin, volume = 100, vary = FALSE, frequency = 0, falloff_exponent, channel = 0, pressure_affected = FALSE, sound/S)
	if(!S)
		S = sound(get_sfx(soundin))
	for(var/m in GLOB.player_list)
		if(ismob(m) && !isnewplayer(m))
			var/mob/M = m
			M.playsound_local(M, null, volume, vary, frequency, falloff_exponent, channel, pressure_affected, S)

/mob/proc/stop_sound_channel(chan)
	SHOULD_NOT_SLEEP(TRUE)
	SEND_SOUND(src, sound(null, repeat = 0, wait = 0, channel = chan))

/mob/proc/set_sound_channel_volume(channel, volume)
	var/sound/S = sound(null, FALSE, FALSE, channel, volume)
	S.status = SOUND_UPDATE
	SEND_SOUND(src, S)

/mob/proc/mute_sound_channel(chan)
	if(!client)
		return
	for(var/sound/S in client.SoundQuery())
		if(S.channel == chan)
			S.status |= SOUND_MUTE | SOUND_UPDATE
			SEND_SOUND(src, S)
			S.status &= ~SOUND_UPDATE

/mob/proc/unmute_sound_channel(chan)
	if(!client)
		return
	for(var/sound/S in client.SoundQuery())
		if(S.channel == chan)
			S.status |= SOUND_UPDATE
			S.status &= ~SOUND_MUTE
			SEND_SOUND(src, S)
			S.status &= ~SOUND_UPDATE

/// Scales a channel's slider volume by the Master preference
/datum/preferences/proc/at_overall(slider_volume)
	return slider_volume * overallvol * 0.01

/// Returns effective Point Ambience volume, optionally scaled by Master
/datum/preferences/proc/point_ambience_volume()
	return POINT_AMBIENCE_VOLUME(src)

/**
 * Scales a direct sound by the target's Master preference.
 *
 * Used for sounds without a dedicated slider. Targets without preferences retain the supplied
 * volume.
 */
/proc/overall_volume(target, volume = 100)
	var/client/listener = target
	if(ismob(target))
		var/mob/target_mob = target
		listener = target_mob.client
	if(!istype(listener) || !listener.prefs)
		return volume
	return listener.prefs.at_overall(volume)

/// Re-sends each playing music and ambience channel at its slider under Master, after a Master change
/client/proc/update_slider_channels()
	if(!mob || !prefs)
		return
	// The browser player stores its own volume and needs the updated Master scale pushed to it
	tgui_panel?.set_streamed_volume()
	var/list/channel_volumes = list(
		"[CHANNEL_MUSIC]" = prefs.at_overall(prefs.musicvol),
		"[CHANNEL_ADMIN]" = prefs.at_overall(prefs.adminmusicvol),
	)
	if(mob.cmode)
		var/combat_volume = prefs.at_overall(prefs.combatmusicvol)
		for(var/channel in list(CHANNEL_BUZZ, CHANNEL_CMUSIC1, CHANNEL_CMUSIC2, CHANNEL_CMUSIC3, CHANNEL_CMUSIC4))
			channel_volumes["[channel]"] = combat_volume
	if(isnewplayer(mob))
		channel_volumes["[CHANNEL_LOBBYMUSIC]"] = prefs.at_overall(prefs.lobbymusicvol)
	// A fade in progress keeps music above its level where it is, as update_music_volume() does
	if(musicfading)
		for(var/channel in channel_volumes.Copy())
			if(channel_volumes[channel] > musicfading)
				channel_volumes -= channel
	var/ambience_volume = prefs.at_overall(prefs.ambiencevol)
	channel_volumes["[CHANNEL_AMBIENCE]"] = ambience_volume
	channel_volumes["[CHANNEL_RAIN]"] = ambience_volume
	mob.set_channel_volumes(channel_volumes)

/mob/proc/update_music_volume(chan, vol)
	if(!client)
		return
	if(client.musicfading)
		if(vol > client.musicfading)
			return
	if(vol)
		for(var/sound/S in client.SoundQuery())
			if(S.channel == chan)
				unmute_sound_channel(chan)
				S.volume = vol
				S.status |= SOUND_UPDATE
				SEND_SOUND(src, S)
				S.status &= ~SOUND_UPDATE
	else
		mute_sound_channel(chan)

/mob/proc/update_channel_volume(chan, vol)
	if(!client)
		return
	if(vol)
		for(var/sound/S in client.SoundQuery())
			if(S.channel == chan)
				unmute_sound_channel(chan)
				S.volume = vol
				S.status |= SOUND_UPDATE
				SEND_SOUND(src, S)
				S.status &= ~SOUND_UPDATE
	else
		mute_sound_channel(chan)

/**
 * Updates listed active channels using one SoundQuery(), which waits for the client.
 *
 * channel_volumes maps text channel IDs to volumes. Numeric keys would index the list instead. Zero
 * mutes a channel. Nonzero values unmute and set its volume.
 */
/mob/proc/set_channel_volumes(list/channel_volumes)
	if(!client || !length(channel_volumes))
		return
	for(var/sound/playing as anything in client.SoundQuery())
		var/volume = channel_volumes["[playing.channel]"]
		if(isnull(volume))
			continue
		if(volume)
			playing.volume = volume
			playing.status &= ~SOUND_MUTE
		else
			playing.status |= SOUND_MUTE
		playing.status |= SOUND_UPDATE
		SEND_SOUND(src, playing)

/client/proc/playtitlemusic()
	set waitfor = FALSE
	UNTIL(SSticker.login_music) //wait for SSticker init to set the login music

	if(prefs && (prefs.toggles & SOUND_LOBBY))
		SEND_SOUND(src, sound(SSticker.login_music, repeat = 1, wait = 0, volume = prefs.at_overall(prefs.lobbymusicvol), channel = CHANNEL_LOBBYMUSIC)) // MAD JAMS

/// Refreshes instrument tokens for this listener after the Instruments volume changes
/client/proc/sync_instrument_volume()
	if(!prefs || !mob)
		return

	for(var/datum/sound_token/token as anything in mob.sound_tokens)
		if(token.respect_instrument_pref)
			token.update_listener(mob)

/// Refreshes playing uploads or their substitutes after the uploaded-song preference changes
/client/proc/sync_uploaded_songs()
	if(!prefs || !mob)
		return

	for(var/datum/sound_token/token as anything in mob.sound_tokens)
		if(token.uploaded)
			token.update_listener(mob)

/**
 * Refreshes this listener's sound tokens and active weather loop after a Master or Sound Effects change.
 *
 * These sounds apply volume preferences when sent, so a stationary listener can otherwise keep
 * hearing the old volume until another update or replay. Instrument tokens retain their separate
 * Instruments setting under Master. The weather loop retains its current severity-adjusted volume.
 */
/client/proc/resend_effect_sounds()
	set waitfor = FALSE
	if(!prefs || !mob)
		return
	for(var/datum/sound_token/token as anything in mob.sound_tokens)
		token.update_listener(mob)
	var/datum/particle_weather/weather = SSParticleWeather.runningWeather
	if(!weather)
		return
	var/datum/looping_sound/weather_loop = weather.currentSounds[mob]
	weather_loop?.set_volume(weather_loop.volume)

/proc/get_rand_frequency()
	return rand(43100, 45100) //Frequency stuff only works with 45kbps oggs.

/proc/get_sfx(soundin)
	if(islist(soundin))
		soundin = pick(soundin)
	if(istext(soundin))
		switch(soundin)
			if ("rustle")
				soundin = pick('sound/foley/equip/rummaging-01.ogg','sound/foley/equip/rummaging-02.ogg','sound/foley/equip/rummaging-03.ogg')
			if ("bodyfall")
				soundin = pick('sound/foley/bodyfall (1).ogg','sound/foley/bodyfall (2).ogg','sound/foley/bodyfall (3).ogg','sound/foley/bodyfall (4).ogg')
			if ("clothwipe")
				soundin = pick('sound/foley/cloth_wipe (1).ogg','sound/foley/cloth_wipe (2).ogg','sound/foley/cloth_wipe (3).ogg')
			if ("glassbreak")
				soundin = pick('sound/combat/hits/onglass/glassbreak (1).ogg','sound/combat/hits/onglass/glassbreak (2).ogg','sound/combat/hits/onglass/glassbreak (3).ogg')
			if ("parrywood")
				soundin = pick('sound/combat/parry/wood/parrywood (1).ogg', 'sound/combat/parry/wood/parrywood (2).ogg', 'sound/combat/parry/wood/parrywood (3).ogg')
			if ("unarmparry")
				soundin = pick('sound/combat/parry/pugilism/unarmparry (1).ogg','sound/combat/parry/pugilism/unarmparry (2).ogg','sound/combat/parry/pugilism/unarmparry (3).ogg')
			if ("dagger")
				soundin = pick('sound/combat/parry/bladed/bladedsmall (1).ogg', 'sound/combat/parry/bladed/bladedsmall (2).ogg', 'sound/combat/parry/bladed/bladedsmall (3).ogg')
			if ("rapier")
				soundin = pick('sound/combat/parry/bladed/bladedthin (1).ogg', 'sound/combat/parry/bladed/bladedthin (2).ogg', 'sound/combat/parry/bladed/bladedthin (3).ogg')
			if ("sword")
				soundin = pick('sound/combat/parry/bladed/bladedmedium (1).ogg', 'sound/combat/parry/bladed/bladedmedium (2).ogg', 'sound/combat/parry/bladed/bladedmedium (3).ogg')
			if ("largeblade")
				soundin = pick('sound/combat/parry/bladed/bladedlarge (1).ogg', 'sound/combat/parry/bladed/bladedlarge (2).ogg', 'sound/combat/parry/bladed/bladedlarge (3).ogg')
			if ("unsheathe_sword")
				soundin = pick('sound/foley/equip/swordsmall1.ogg', 'sound/foley/equip/swordsmall2.ogg')
			if ("brandish_blade")
				soundin = pick('sound/foley/equip/swordlarge1.ogg', 'sound/foley/equip/swordlarge2.ogg')
			if ("burn")
				soundin = pick('sound/combat/hits/burn (1).ogg','sound/combat/hits/burn (2).ogg')
			if ("nodmg")
				soundin = pick('sound/combat/hits/nodmg (1).ogg','sound/combat/hits/nodmg (2).ogg')
			if ("plantcross")
				soundin = pick('sound/foley/plantcross1.ogg','sound/foley/plantcross2.ogg','sound/foley/plantcross3.ogg','sound/foley/plantcross4.ogg')
			if ("smashlimb")
				soundin = pick('sound/combat/hits/smashlimb (1).ogg','sound/combat/hits/smashlimb (2).ogg','sound/combat/hits/smashlimb (3).ogg')
			if("genblunt")
				soundin = pick('sound/combat/hits/blunt/genblunt (1).ogg','sound/combat/hits/blunt/genblunt (2).ogg','sound/combat/hits/blunt/genblunt (3).ogg')
			if("wetbreak")
				soundin = pick('sound/combat/fracture/fracturewet (1).ogg',
'sound/combat/fracture/fracturewet (2).ogg',
'sound/combat/fracture/fracturewet (3).ogg')
			if("fracturedry")
				soundin = pick('sound/combat/fracture/fracturedry (1).ogg',
'sound/combat/fracture/fracturedry (2).ogg',
'sound/combat/fracture/fracturedry (3).ogg')
			if("headcrush")
				soundin = pick('sound/combat/fracture/headcrush (1).ogg',
'sound/combat/fracture/headcrush (2).ogg',
'sound/combat/fracture/headcrush (3).ogg',
'sound/combat/fracture/headcrush (4).ogg')
			if("punch")
				soundin = pick('sound/combat/hits/punch/punch (1).ogg','sound/combat/hits/punch/punch (2).ogg','sound/combat/hits/punch/punch (3).ogg')
			if("punch_hard")
				soundin = pick('sound/combat/hits/punch/punch_hard (1).ogg','sound/combat/hits/punch/punch_hard (2).ogg','sound/combat/hits/punch/punch_hard (3).ogg')
			if("smallslash")
				soundin = pick('sound/combat/hits/bladed/smallslash (1).ogg', 'sound/combat/hits/bladed/smallslash (2).ogg', 'sound/combat/hits/bladed/smallslash (3).ogg')
			if("woodimpact")
				soundin = pick('sound/combat/hits/onwood/woodimpact (1).ogg','sound/combat/hits/onwood/woodimpact (2).ogg')
			if("bubbles")
				soundin = pick('sound/foley/bubb (1).ogg','sound/foley/bubb (2).ogg','sound/foley/bubb (3).ogg','sound/foley/bubb (4).ogg','sound/foley/bubb (5).ogg')
			if("parrywood")
				soundin = pick('sound/combat/parry/wood/parrywood (1).ogg','sound/combat/parry/wood/parrywood (2).ogg','sound/combat/parry/wood/parrywood (3).ogg')
			if("whiz")
				soundin = pick('sound/foley/whiz (1).ogg','sound/foley/whiz (2).ogg','sound/foley/whiz (3).ogg','sound/foley/whiz (4).ogg')
			if("genslash")
				soundin = pick('sound/combat/hits/bladed/genslash (1).ogg','sound/combat/hits/bladed/genslash (2).ogg','sound/combat/hits/bladed/genslash (3).ogg')
			if("bladewooshsmall")
				soundin = pick('sound/combat/wooshes/bladed/wooshsmall (1).ogg','sound/combat/wooshes/bladed/wooshsmall (2).ogg','sound/combat/wooshes/bladed/wooshsmall (3).ogg')
			if("bluntwooshmed")
				soundin = pick('sound/combat/wooshes/blunt/wooshmed (1).ogg','sound/combat/wooshes/blunt/wooshmed (2).ogg','sound/combat/wooshes/blunt/wooshmed (3).ogg')
			if("bluntwooshlarge")
				soundin = pick('sound/combat/wooshes/blunt/wooshlarge (1).ogg','sound/combat/wooshes/blunt/wooshlarge (2).ogg','sound/combat/wooshes/blunt/wooshlarge (3).ogg')
			if("punchwoosh")
				soundin = pick('sound/combat/wooshes/punch/punchwoosh (1).ogg','sound/combat/wooshes/punch/punchwoosh (2).ogg','sound/combat/wooshes/punch/punchwoosh (3).ogg')
			if(SFX_CHAIN_STEP)
				soundin = pick(
							'sound/foley/footsteps/armor/chain (1).ogg',
							'sound/foley/footsteps/armor/chain (2).ogg',
							'sound/foley/footsteps/armor/chain (3).ogg',
							)
			if(SFX_PLATE_STEP)
				soundin = pick(
							'sound/foley/footsteps/armor/plate (1).ogg',
							'sound/foley/footsteps/armor/plate (2).ogg',
							'sound/foley/footsteps/armor/plate (3).ogg',
							)
			if(SFX_PLATE_COAT_STEP)
				soundin = pick(
							'sound/foley/footsteps/armor/coatplates (1).ogg',
							'sound/foley/footsteps/armor/coatplates (2).ogg',
							'sound/foley/footsteps/armor/coatplates (3).ogg',
							)
			if(SFX_JINGLE_BELLS)
				soundin = pick(
							'sound/items/jinglebell1.ogg',
							'sound/items/jinglebell2.ogg',
							'sound/items/jinglebell3.ogg',
							'sound/items/jinglebell4.ogg',
							)
			if(SFX_WOOD_ARMOR)
				soundin = pick(
							'sound/foley/footsteps/armor/woodarmor (1).ogg',
							'sound/foley/footsteps/armor/woodarmor (2).ogg',
							'sound/foley/footsteps/armor/woodarmor (3).ogg',
							)
	return soundin
