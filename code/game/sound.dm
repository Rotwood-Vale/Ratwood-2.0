/**
 * Tiles of effective distance a crossed floor adds, cached from config at SSsounds init.
 *
 * A global rather than a CONFIG_GET because STOREY_ADJUSTED_DISTANCE reads it on every cross-floor
 * send, in playsound_local and in SSpoint_ambience's slim_send. 0 leaves a floor as the flat storey
 * halving and nothing else.
 */
GLOBAL_VAR_INIT(sound_storey_tiles, 0)

/**
 * Picks the falloff curve for a sound from how far it carries. See SOUND_FALLOFF_EXPONENT.
 *
 * Four curves for four bands, up to three comparisons. playsound() resolves it once per call.
 * playsound_local() resolves it on each send for a direct caller that names no exponent, which
 * includes every token a looping_sound builds. Each point ambience category resolves it once.
 */
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
 * Decisions a reader would otherwise undo:
 *
 * LEAKING and CONTAINED never cross a floor, a guarantee rather than a default, so the floor volume is
 * forced with them here, and playsound_local refuses a storey for them as well. A caller naming either
 * class must not be able to hand it a floor volume that lets the sound upstairs.
 *
 * A soundproof source area makes LEAKING CONTAINED and treats even open doors and windows as
 * barriers for both ERP classes. Read from the area the sound LEAVES, which for a headless
 * dullahan's voice is wherever the head is rather than where the body stands.
 *
 * OMITTING extrarange gives 1, so a bare playsound() reaches SOUND_RANGE + 1. The bare
 * call sites were tuned against that and it stays. Guarded on isnull rather than falsiness so an
 * explicit 0 means what it says. Mapped -1/-2/-3 values are unaffected either way.
 *
 * SOUND_FLOOR_NEVER skips the above and below gather entirely, which is what makes it a guarantee
 * rather than a volume of zero: nobody upstairs is ever considered. Ratwood deliberately lets sound
 * leak through ceilings and players navigate by it, so this is opt-out rather than opt-in. Each
 * floor is probed before it is gathered, any_client_in_range walking the same cells with no list to
 * build and an early return on the first hit, and a floor either side is often empty.
 *
 * Occlusion walks a line per listener, reading live contents so door changes affect the next sound.
 * ERP uses only that direct line. LEAKING may cross one shut opening immediately beside the
 * listener, then continues to reject any further barrier. It does not search around corners.
 *
 * Listeners are gated on get_dist, not euclidean distance. The gather is an orthogonal square, so an
 * euclidean gate silently discards the corners, about a third of the tiles at ranges 7 and 8. Volume
 * is still computed euclidean below, so a corner listener sits at min_volume rather than dropped.
 *
 * Nothing can stand between the source and a listener on it or orthogonally beside it, since a wall
 * is a turf, and those two cases are most of ERP: the sex actions put both participants on one tile
 * or in a grab one tile apart. Manhattan rather than get_dist, which is chebyshev and would call a
 * diagonal adjacent. A diagonal neighbour is walked and reads clear, because the walk reaches it in
 * one step without testing the corner tiles, save ERP audio with a window or door on either tile.
 */
/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff_exponent, frequency = null, channel = 0, pressure_affected = FALSE, ignore_walls = TRUE, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, use_reverb = TRUE, soundping = FALSE, anthro_noise = FALSE, min_volume = SOUND_DEFAULT_MIN_VOLUME, travel = SOUND_TRAVEL_UNRESTRICTED, floor_volume = null, erp = FALSE)
	if(isarea(source))
		CRASH("playsound(): source is an area")
	// LEAKING and CONTAINED, the top of the ladder, never cross a floor. See the proc doc
	if(travel >= SOUND_TRAVEL_LEAKING)
		floor_volume = SOUND_FLOOR_NEVER

	// TG CRASHes on a list or a null soundin. Kept tolerant here because get_sfx()
	// accepts lists and long-standing callers rely on that
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

	// Here rather than in playsound_erp, so it reads the area the sound leaves from
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
	// OMITTING extrarange gives 1, so a bare call reaches SOUND_RANGE + 1. See the proc doc
	if(isnull(extrarange))
		extrarange = 1
	var/maxdistance = SOUND_RANGE + extrarange
	// Falsy rather than isnull, so a 0 or FALSE in this slot takes the band's curve as an omitted one does
	if(!falloff_exponent)
		falloff_exponent = sound_falloff_for_range(maxdistance)

	if(falloff_distance >= maxdistance)
		// TG CRASHes here. Degrade instead so a bad caller loses its plateau, not its sound
		stack_trace("playsound(): falloff_distance [falloff_distance] >= maxdistance [maxdistance]")
		falloff_distance = 0

	if(vary && !frequency)
		frequency = get_rand_frequency() // skips us having to do it per-sound later

	if(soundping)
		ping_sound(source)

	var/list/listeners

	// Deviation from TG: no istransparentturf() gate on the above/below gathering.
	// Taverns leak sound through their floors and players navigate by it
	if(!ignore_walls) //these sounds don't carry through walls or vertically
		listeners = get_hearers_in_view(maxdistance, turf_source, RECURSIVE_CONTENTS_CLIENT_MOBS)
	else
		listeners = get_hearers_in_range(maxdistance, turf_source, RECURSIVE_CONTENTS_CLIENT_MOBS)

		// Skipping the gather is what makes SOUND_FLOOR_NEVER a guarantee. Probed before gathered,
		// since a floor either side is often empty. See the proc doc
		if(floor_volume != SOUND_FLOOR_NEVER)
			var/turf/above_turf = GET_TURF_ABOVE(turf_source)
			if(above_turf && SSspatial_grid.any_client_in_range(above_turf, maxdistance))
				listeners += get_hearers_in_range(maxdistance, above_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

			var/turf/below_turf = GET_TURF_BELOW(turf_source)
			if(below_turf && SSspatial_grid.any_client_in_range(below_turf, maxdistance))
				listeners += get_hearers_in_range(maxdistance, below_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

	// What a wall does to an ignore_walls sound, opt-in because it is a line walk PER LISTENER
	var/occlude = ignore_walls ? travel : SOUND_TRAVEL_UNRESTRICTED
	for(var/mob/listening_mob in listeners) // had nulls sneak in here, hence the typecheck
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
			// STOP behind a wall. Still in the returned gather, as anyone out of range is
			if(isnull(muffled))
				continue
		listening_mob.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb, muffled = muffled, min_volume = min_volume, travel = travel, floor_volume = floor_volume, erp = erp)

	return listeners


/**
 * Sound made by ERP, or caused by it, with the wall and floor policy in one place.
 *
 * CONTAINED by default, stopping at walls and closed openings. Name SOUND_TRAVEL_LEAKING for a sound
 * that should also be heard one tile past a shut window or door on the direct line. Open ones
 * pass both classes unless the source area is soundproof. Neither crosses a floor; SOUND_TRAVEL_FLOOR
 * picks that rule. emote_erp is its counterpart for vocalisations.
 *
 * Omitting extrarange means SOUND_RANGE here, not playsound's SOUND_RANGE + 1.
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
 * Decisions a reader would otherwise undo:
 *
 * The storey count is resolved once at the top because the muffle and the scaling both depend on it.
 * The vertical rule lives here and in its hand-kept mirror in SSpoint_ambience's slim_send, with
 * sound_token deferring to it rather than halving twice. It is skipped for the LONG band, which
 * models hearing something through the floor above you and stops meaning anything once a sound
 * carries across the map, where it would silence a town-wide sound for anyone two floors up. Keyed
 * on the band so any future long-range sound inherits that. A storey with LEAKING or CONTAINED
 * returns outright, the second half of their guarantee: playsound never gathers the other floors for
 * them, so nothing should arrive here with storeys at all, and a direct caller passing either with no
 * floor cap would otherwise get the halving and be SENT.
 *
 * The environment comes from the listener's area, and the muffle environment wins over it. A muffled
 * sound keeping the cathedral's reverb would lose the dead-room character, which is what actually
 * reads as "behind something", where the volume drop alone just reads as "further away". That only
 * works because the default is a live space, so the muffle has something to deaden. Muffled ERP audio
 * takes the heavier environment. The area test is truthy rather than "not NONE": /area/soundenv
 * defaults to 0, BYOND's generic preset rather than a missing value, which would give every unset
 * area a reverb. The turf branch keeps weather, music and UI sounds dry, having no place in the
 * world to echo in. Assigned on every branch, since playsound() builds ONE sound datum and hands it
 * to every listener in turn, so a value left set by one follows the rest.
 *
 * min_volume is clamped to vol before the falloff subtracts it. Without the floor the curve reaches
 * 0 short of the edge and the sound disappears inside its own range, and a sound already quieter
 * than the floor would subtract a negative and get LOUDER the further away you stood.
 *
 * The leak cap and the storey cap are both applied AFTER the falloff, so the number is what a
 * listener hears rather than where the curve starts. Capping first would put the figure at distance 0,
 * which is inside the wall. A floor cap REPLACES the storey multiplier rather than stacking with it,
 * holding a capped sound at that volume wherever the listener stands on the floor above, which is
 * the point of capping rather than attenuating.
 *
 * Extreme stereo panning is softened: a sound due east or west has S.z == 0, so BYOND drops it
 * entirely into one ear. The front-back axis gets a floor proportional to the sideways offset and
 * both are rescaled to the original magnitude, so ONLY the angle changes and the distance BYOND
 * sees, and therefore its own attenuation on top of ours, is untouched.
 *
 * echo REPLACES the environment preset rather than layering over it, so a partly filled array costs
 * the room its reverb and zeroing slots does not give it back. S is shared across every listener, so
 * it is cleared outright when the preset should apply, and the array is only built when something
 * will actually be written into it. A muffled ERP sound therefore gets no array at all, its
 * character coming from SOUND_ERP_MUFFLE_ENVIRONMENT. That also makes SOUND_MUFFLE_OCCLUSION a real
 * switch: set it to 0 and muffled sounds fall back to the environment preset.
 *
 * The distance goes through a local, never straight into STOREY_ADJUSTED_DISTANCE. The macro
 * names its first argument three times, and get_dist_euclidean is a proc call that would then be
 * made twice on every cross-floor send.
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
			// ||=, never =: a plain assignment discards what playsound has already decided about walls
			if(istype(user_head.loc, /obj/structure/closet) || istype(user_head.loc, /obj/item/storage/))
				muffled ||= SOUND_MUFFLE_SOFT
	// Distance is measured from the head if it is detached. Resolved only for positional
	// sounds, since a direct or UI sound has no turf_source and should not pay for a get_turf()
	var/atom/movable/tocheck = user_head ? user_head : src
	var/turf/turf_loc
	if(isturf(turf_source))
		turf_loc = get_turf(tocheck)

	// Resolved here because the muffle and the scaling both depend on it. See the proc doc
	var/storeys = (turf_loc && ((max_distance && max_distance < SOUND_RANGE_LONG) || travel >= SOUND_TRAVEL_LEAKING)) ? abs(turf_source.z - turf_loc.z) : 0
	if(storeys >= 2)
		return FALSE
	// The second half of the LEAKING and CONTAINED guarantee, and the backstop for a direct caller
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

	// From the listener's area. Assigned on EVERY branch, or one listener's reverb follows the
	// rest: playsound builds one datum and hands it to each in turn. See the proc doc
	var/area/A = get_area(get_turf(src))
	if(muffled)
		// Wins over the area, the dead room being what reads as behind something
		S.environment = erp ? SOUND_ERP_MUFFLE_ENVIRONMENT : SOUND_MUFFLE_ENVIRONMENT
	else if(A && A.soundenv && A.soundenv != SOUND_ENVIRONMENT_NONE)
		// Truthy, not just "not NONE": soundenv defaults to 0, BYOND's generic preset
		S.environment = A.soundenv
	else if(isturf(turf_source))
		// Positional only. Weather, music and UI sounds have no room to echo in, so they stay dry
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

		// After the falloff, so the number is what a listener hears, not where the curve starts
		if(muffled == SOUND_MUFFLE_ENCLOSED && !storeys)
			S.volume = min(S.volume, SOUND_TRAVEL_LEAK_VOLUME)

		// The multiplier is the floor as an obstruction, on top of the distance it adds. A floor cap
		// REPLACES it rather than stacking. See the proc doc
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

		// Soften extreme panning: due east or west, BYOND drops a sound into one ear entirely.
		// Only the angle changes, the magnitude being rescaled back. See the proc doc
		if(S.x && SOUND_PAN_MIN_DEPTH)
			var/min_depth = abs(S.x) * SOUND_PAN_MIN_DEPTH
			if(abs(S.z) < min_depth)
				var/original = sqrt(S.x * S.x + S.z * S.z)
				S.z = (S.z < 0) ? -min_depth : min_depth
				var/widened = sqrt(S.x * S.x + S.z * S.z)
				if(widened)
					S.x *= original / widened
					S.z *= original / widened

		// One storey per z here, not TG's x5: towns stack their floors directly
		S.y = turf_source.z - our_turf.z

		S.falloff = max_distance || 1 // use max_distance, else just use 1 as we are a direct sound so falloff isnt relevant

		// echo REPLACES the preset, so the array is built only when something goes into it, and a
		// muffled ERP sound gets none at all. See the proc doc
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

	// The sliders apply after falloff so the falloff curve is computed on the caller's numbers,
	// then the whole result is scaled to the player's Sound Effects under Master
	if(client.prefs)
		S.volume *= (isnull(volume_pref) ? client.prefs.at_overall(client.prefs.mastervol) : volume_pref) * 0.01
	S.volume = min(S.volume, 100)

	if(S.volume <= 0)
		return FALSE //No sound

	SEND_SOUND(src, S)

	// The volume sent, so a caller can report it. FALSE when nothing was sent
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

/// A slider's volume under the Master slider, for anything sent at that slider's level
/datum/preferences/proc/at_overall(slider_volume)
	return slider_volume * overallvol * 0.01

/// Point ambience at the listener's chosen scale, independent or under Master Volume
/datum/preferences/proc/point_ambience_volume()
	return POINT_AMBIENCE_VOLUME(src)

/**
 * A volume for a sound that no slider of its own covers, under the listener's Master slider.
 *
 * For stingers and alerts sent straight to a mob or a client. A listener without preferences gets
 * the volume as passed.
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
	mob.update_music_volume(CHANNEL_MUSIC, prefs.at_overall(prefs.musicvol))
	mob.update_music_volume(CHANNEL_ADMIN, prefs.at_overall(prefs.adminmusicvol))
	// The browser player is a separate audio system and holds its own copy, so Master reaches it
	// only by being pushed
	tgui_panel?.set_streamed_volume()
	if(mob.cmode)
		var/combat_volume = prefs.at_overall(prefs.combatmusicvol)
		mob.update_music_volume(CHANNEL_BUZZ, combat_volume)
		mob.update_music_volume(CHANNEL_CMUSIC1, combat_volume)
		mob.update_music_volume(CHANNEL_CMUSIC2, combat_volume)
		mob.update_music_volume(CHANNEL_CMUSIC3, combat_volume)
		mob.update_music_volume(CHANNEL_CMUSIC4, combat_volume)
	mob.update_channel_volume(CHANNEL_AMBIENCE, prefs.at_overall(prefs.ambiencevol))
	mob.update_channel_volume(CHANNEL_RAIN, prefs.at_overall(prefs.ambiencevol))
	if(isnewplayer(mob))
		mob.update_music_volume(CHANNEL_LOBBYMUSIC, prefs.at_overall(prefs.lobbymusicvol))

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

/client/proc/playtitlemusic()
	set waitfor = FALSE
	UNTIL(SSticker.login_music) //wait for SSticker init to set the login music

	if(prefs && (prefs.toggles & SOUND_LOBBY))
		SEND_SOUND(src, sound(SSticker.login_music, repeat = 1, wait = 0, volume = prefs.at_overall(prefs.lobbymusicvol), channel = CHANNEL_LOBBYMUSIC)) // MAD JAMS

/// Re-prices every instrument token this mob hears. Tokens are not channels the volume menu can
/// re-send, so each one is poked to recompute its own volume for this listener
/client/proc/sync_instrument_volume()
	if(!prefs || !mob)
		return

	for(var/datum/sound_token/token as anything in mob.sound_tokens)
		if(token.respect_instrument_pref)
			token.update_listener(mob)

/// Swaps every upload this mob hears for its stand in, or back, after the Uploaded Songs toggle
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
 *
 * Does not make the caller wait for SoundQuery(), which the weather volume update can call.
 * This matters because ui_close() is marked SIGNAL_HANDLER and must not sleep.
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
