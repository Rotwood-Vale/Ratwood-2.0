/// Tiles of effective distance a crossed floor adds, cached from config at SSsounds init. Read on
/// every positional send, which is every footstep in the game, so it is a global read rather than a
/// CONFIG_GET. 0 is the old behaviour: a floor is a flat halving and nothing else.
GLOBAL_VAR_INIT(sound_storey_tiles, 0)

/**
 * playsound is a proc used to play a 3D sound in a specific range. This uses SOUND_RANGE + extra_range to determine that.
 *
 * Arguments:
 * * source - Origin of sound.
 * * soundin - Either a file, or a string that can be used to get an SFX.
 * * vol - The volume of the sound, excluding falloff.
 * * vary - bool that determines if the sound changes pitch every time it plays.
 * * extrarange - modifier for sound range. This gets added on top of SOUND_RANGE. A falsy value means 1, see below.
 * * falloff_exponent - Rate of falloff for the audio. Higher means quicker drop to low volume. Should generally be over 1 to indicate a quick dive to 0 rather than a slow dive.
 * * frequency - playback speed of audio.
 * * channel - The channel the sound is played at.
 * * pressure_affected - Whether or not difference in pressure affects the sound (defaults FALSE here; there is no atmos to speak of).
 * * ignore_walls - Whether or not the sound can pass through walls.
 * * falloff_distance - Distance at which falloff begins. Sound is at peak volume (in regards to falloff) aslong as it is in this range.
 * * soundping - Show the visual sound ping effect on the source.
 * * animal_pref - Filter the sound away from clients with mute_animal_emotes set.
 * * min_volume - the volume the sound falls off to at max range, instead of to silence.
 * * travel - a SOUND_TRAVEL_* class: what a barrier between source and listener does. UNRESTRICTED
 *   by default; every other class costs a line walk per listener.
 * * floor_volume - what a FLOOR does, separately. Null attenuates and halves as usual;
 *   SOUND_FLOOR_NEVER does not cross and skips gathering the floors either side; a positive number
 *   caps the volume there. Forced to NEVER for SOUND_TRAVEL_CONTAINED.
 * * erp - sex audio: takes the ERP muffle timbre, and obeys an area's soundproof flag.
 */
/**
 * Picks the falloff curve for a sound from how far it carries. See SOUND_FALLOFF_EXPONENT.
 *
 * Called by playsound() and playsound_local() whenever a caller does not name an exponent
 * itself, which is nearly all of them. Resolved once per call, not per listener, so the three
 * models cost a pair of comparisons against however many people end up hearing the sound.
 */
/proc/sound_falloff_for_range(range)
	if(range >= SOUND_RANGE_LONG)
		return SOUND_FALLOFF_EXPONENT_LONG
	if(range >= SOUND_RANGE_MEDIUM)
		return SOUND_FALLOFF_EXPONENT_MEDIUM
	return SOUND_FALLOFF_EXPONENT

/// Positional sounds started, counted for the whole round. A one-shot is one call however many
/// people hear it, so read this against the sends below to get listeners per sound: the two
/// together are what the ambient slice has always been quoted without.
GLOBAL_VAR_INIT(sound_positional_calls, 0)
/// Every playsound_local(), whatever started it: one-shots reaching one listener, the ambience
/// fallback path, and direct callers. The point ambience slim send is NOT here, having its own path.
GLOBAL_VAR_INIT(sound_local_sends, 0)
/// Occlusion line walks made for one-shots, and the tiles they crossed. Against
/// sound_positional_calls these price what `occlusion` costs per sound, which was argued from
/// counts before it was ever measured.
GLOBAL_VAR_INIT(sound_occlusion_walks, 0)
GLOBAL_VAR_INIT(sound_occlusion_tiles, 0)

/proc/playsound(atom/source, soundin, vol as num, vary, extrarange as num, falloff_exponent, frequency = null, channel = 0, pressure_affected = FALSE, ignore_walls = TRUE, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, use_reverb = TRUE, soundping = FALSE, animal_pref = FALSE, min_volume = SOUND_DEFAULT_MIN_VOLUME, travel = SOUND_TRAVEL_UNRESTRICTED, floor_volume = null, erp = FALSE)
	if(isarea(source))
		CRASH("playsound(): source is an area")
	GLOB.sound_positional_calls++
	// CONTAINED is a guarantee rather than a default, so it is forced here and not merely defaulted:
	// "stays in the room" has to mean the floor too, and a caller naming the class must not be able
	// to hand it a floor volume that lets it upstairs. playsound_local enforces the same thing for
	// anyone who reaches it another way.
	if(travel == SOUND_TRAVEL_CONTAINED)
		floor_volume = SOUND_FLOOR_NEVER

	// TG CRASHes on a list or a null soundin; kept tolerant here because get_sfx()
	// accepts lists and long-standing callers rely on that.
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

	// ERP audio obeys the area's speech rule: line of sight only where soundproof is set. Checked
	// here rather than in playsound_erp so it reads the area the sound actually leaves from, which
	// for a headless dullahan is wherever the head is rather than where the body stands.
	// The class is cleared with it: nothing gathered can be behind a wall or on another floor, so
	// there is no muffle to shape and no cap to apply.
	if(erp)
		var/area/source_area = get_area(turf_source)
		if(source_area?.soundproof)
			ignore_walls = FALSE
			travel = SOUND_TRAVEL_UNRESTRICTED
			floor_volume = SOUND_FLOOR_NEVER
			erp = FALSE

	//allocate a channel if necessary now so its the same for everyone
	channel = channel || SSsounds.random_available_channel()

	var/sound/S = soundin
	if(!istype(S))
		S = sound(get_sfx(soundin))
	// Historical quirk: OMITTING extrarange gives 1, so a bare playsound() reaches 8 rather
	// than SOUND_RANGE. Some 1400 call sites were tuned against that and it stays.
	// Guarded on isnull rather than falsiness so an explicit 0 now means what it says. Before
	// this, asking for the default range gave you MORE reach than the default, and there was no
	// way to request SOUND_RANGE at all. Mapped -1/-2/-3 values are unaffected either way.
	if(isnull(extrarange))
		extrarange = 1
	var/maxdistance = SOUND_RANGE + extrarange
	// Falsy rather than isnull: a caller passing 0 here would be a divide by zero below, and
	// historically a couple passed FALSE into this slot when it meant something else.
	if(!falloff_exponent)
		falloff_exponent = sound_falloff_for_range(maxdistance)

	if(falloff_distance >= maxdistance)
		// TG CRASHes here; degrade instead so a bad caller loses its plateau, not its sound
		stack_trace("playsound(): falloff_distance [falloff_distance] >= maxdistance [maxdistance]")
		falloff_distance = 0

	if(vary && !frequency)
		frequency = get_rand_frequency() // skips us having to do it per-sound later

	if(soundping)
		ping_sound(source)

	var/list/listeners

	// Deviation from TG: no istransparentturf() gate on the above/below gathering.
	// Taverns leak sound through their floors today and players navigate by it.
	if(!ignore_walls) //these sounds don't carry through walls or vertically
		listeners = get_hearers_in_view(maxdistance, turf_source, RECURSIVE_CONTENTS_CLIENT_MOBS)
	else
		listeners = get_hearers_in_range(maxdistance, turf_source, RECURSIVE_CONTENTS_CLIENT_MOBS)

		// SOUND_FLOOR_NEVER keeps a sound on its own floor, and skipping the gather is what makes it
		// a guarantee rather than a volume of zero: nobody upstairs is ever considered. Ratwood
		// deliberately lets sound leak through ceilings and players navigate by it, so this is
		// opt-out rather than opt-in.
		// Probed before gathering. any_client_in_range walks the same grid cells but only asks
		// whether each holds a client, with no list to build and an early return on the first hit.
		// Most floors above and below a given spot are empty, so this usually replaces the gather
		// rather than adding to it. _looping_sound.dm uses it the same way.
		if(floor_volume != SOUND_FLOOR_NEVER)
			var/turf/above_turf = GET_TURF_ABOVE(turf_source)
			if(above_turf && SSspatial_grid.any_client_in_range(above_turf, maxdistance))
				listeners += get_hearers_in_range(maxdistance, above_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

			var/turf/below_turf = GET_TURF_BELOW(turf_source)
			if(below_turf && SSspatial_grid.any_client_in_range(below_turf, maxdistance))
				listeners += get_hearers_in_range(maxdistance, below_turf, RECURSIVE_CONTENTS_CLIENT_MOBS)

	// Occlusion. ignore_walls sounds normally pass through walls at full volume, with no way to tell
	// a closed door from open air. `occlusion` says what a wall does instead: MUFFLE dulls, LEAK
	// dulls and collapses the range when properly enclosed, STOP drops the listener when enclosed.
	// Opt-in because it is per listener: fine on something that fires every few seconds, not on
	// footsteps.
	//
	// A LINE WALK PER LISTENER, not a second get_hearers_in_view() gather. Same answer, and it is the
	// mechanism the other two muffling paths already use: point ambience and /datum/sound_token both
	// call opacity_between(). The gather was one call for everyone, so it won at high listener counts
	// and lost at low ones, and it could only ever answer yes or no. A walk also says WHERE the line
	// was blocked, which is what grading a corner against an enclosure needs.
	//
	// check_contents catches doors, matching what the view gather did. A one-shot recomputes from
	// scratch every time, so a door's state cannot freeze into it the way it would for a point
	// ambience listener standing still.
	// A ternary, not &&: DM's && yields its LAST operand, so `occlusion && ignore_walls` would turn
	// every mode into 1 and every caller into MUFFLE.
	var/occlude = ignore_walls ? travel : SOUND_TRAVEL_UNRESTRICTED
	for(var/mob/listening_mob in listeners) //had nulls sneak in here, hence the typecheck
		var/turf/mob_turf = get_turf(listening_mob)
		// A headless dullahan hears from wherever the head is.
		if(isdullahan(listening_mob))
			var/mob/living/carbon/human/human = listening_mob
			var/datum/species/dullahan/dullahan = human.dna.species
			if(dullahan.headless)
				mob_turf = get_turf(dullahan.my_head)
		if(!mob_turf)
			continue
		if(animal_pref && listening_mob.client?.prefs?.mute_animal_emotes)
			continue
		// Gate on get_dist, not euclidean distance. The hearer gather is an orthogonal
		// square, so an euclidean gate silently discards the corners, about a third of
		// everyone the old code played to. Volume is still computed euclidean below, so
		// a corner listener simply sits at min_volume rather than being dropped.
		if(get_dist(mob_turf, turf_source) > maxdistance)
			continue
		var/muffled = SOUND_MUFFLE_NONE
		// Nothing can stand between the source and a listener on it or orthogonally beside it, since
		// a wall is a turf, and those two cases are most of ERP: the sex actions put both
		// participants on one tile or in a grab one tile apart. Manhattan rather than get_dist,
		// which is chebyshev and would call a diagonal adjacent; a diagonal CAN be cut by an inside
		// corner, so those are still walked. A different floor is muffled by the storey rule in
		// playsound_local whatever this decides, and the walk is 2D, so it is not asked.
		if(occlude && mob_turf.z == turf_source.z && (abs(mob_turf.x - turf_source.x) + abs(mob_turf.y - turf_source.y) > 1))
			muffled = occlusion_muffle_for(mob_turf, turf_source, occlude, maxdistance)
			// STOP behind a wall. Still in the returned gather, as anyone out of range is.
			if(isnull(muffled))
				continue
		listening_mob.playsound_local(turf_source, soundin, vol, vary, frequency, falloff_exponent, channel, pressure_affected, S, maxdistance, falloff_distance, 1, use_reverb, muffled = muffled, min_volume = min_volume, travel = travel, floor_volume = floor_volume, erp = erp)

	return listeners


/**
 * Sound made by the sex system: muffled round a corner, collapsed behind a wall for the classes a
 * wall stops, and on its own floor unless told otherwise.
 *
 * A wrapper so the policy lives in one place; emote_erp is its counterpart for vocalisations.
 * Name what the sound is with SOUND_TRAVEL_LEAKING or SOUND_TRAVEL_CARRYING and its behaviour at walls and
 * ceilings follows. The default treats it as vocal, which is the most private of the three.
 *
 * Omitting extrarange means SOUND_RANGE here, not playsound's SOUND_RANGE + 1.
 */
/proc/playsound_erp(atom/source, soundin, vol, vary, extrarange = 0, frequency = null, channel = 0, travel = SOUND_TRAVEL_CONTAINED, floor_volume)
	// The class picks the floor cap unless the caller names one, so a sex sound is still ONE decision
	// at the call site. CONTAINED ignores an override either way; playsound forces it.
	if(isnull(floor_volume))
		floor_volume = SOUND_TRAVEL_FLOOR(travel)
	return playsound(source, soundin, vol, vary, extrarange, frequency = frequency, channel = channel, travel = travel, floor_volume = floor_volume, erp = TRUE)


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
 * * pressure_affected - kept for source compatibility; there is no atmos here, so it does nothing.
 * * S - Optional: the sound datum to send, defaults to building one from soundin.
 * * max_distance - number, determines the maximum distance of our sound; no falloff without it.
 * * falloff_distance - Distance at which falloff begins.
 * * distance_multiplier - Default 1, multiplies the perceived distance of our sound.
 * * use_reverb - bool default TRUE, determines if our sound has reverb.
 * * muffled - a SOUND_MUFFLE_* level: NONE, SOFT (the profile: heavier falloff, quieter, dead room)
 *   or ENCLOSED (the profile plus the wall collapse). Boolean callers pass TRUE, which is SOFT.
 * * min_volume - the volume the sound falls off to at max_distance, instead of to silence.
 * * volume_pref, when set, replaces mastervol as the preference the result is scaled by
 */
/mob/proc/playsound_local(turf/turf_source, soundin, vol as num, vary, frequency, falloff_exponent, channel = 0, pressure_affected = FALSE, sound/S, max_distance, falloff_distance = SOUND_DEFAULT_FALLOFF_DISTANCE, distance_multiplier = 1, use_reverb = TRUE, muffled = FALSE, min_volume = SOUND_DEFAULT_MIN_VOLUME, travel = SOUND_TRAVEL_UNRESTRICTED, floor_volume = null, erp = FALSE, volume_pref = null)
	if(!client || !can_hear())
		return FALSE
	GLOB.sound_local_sends++

	if(!S)
		S = sound(get_sfx(soundin))

	S.wait = 0 //No queue
	S.channel = channel || SSsounds.random_available_channel()

	// A headless dullahan listens from the head; a head shut in a container is muffled.
	var/obj/item/bodypart/head/dullahan/user_head
	if(isdullahan(src))
		var/mob/living/carbon/human = src
		var/datum/species/dullahan/dullahan = human.dna.species
		if(dullahan.headless)
			user_head = dullahan.my_head
			// ||=, never =: this used to discard what playsound had already decided about walls.
			if(istype(user_head.loc, /obj/structure/closet) || istype(user_head.loc, /obj/item/storage/))
				muffled ||= SOUND_MUFFLE_SOFT
	// Distance is measured from the head if it is detached. Resolved only for positional
	// sounds, since a direct or UI sound has no turf_source and should not pay for a get_turf().
	var/atom/movable/tocheck = user_head ? user_head : src
	var/turf/turf_loc
	if(isturf(turf_source))
		turf_loc = get_turf(tocheck)

	// Storeys between us and the source, resolved up here because the muffle and the scaling
	// below both depend on it. This is the only place the vertical rule lives; sound_token
	// defers to it rather than halving as well, which would quarter.
	// Skipped for the LONG band. The rule models hearing something through the floor above you,
	// which stops meaning anything once a sound carries across the map, and applying it there
	// would silence a town-wide sound for anyone two floors up. Keyed on the band so any future
	// long-range sound inherits that.
	var/storeys = (turf_loc && max_distance && max_distance < SOUND_RANGE_LONG) ? abs(turf_source.z - turf_loc.z) : 0
	if(storeys >= 2)
		return FALSE
	// The second half of CONTAINED's guarantee. playsound never gathers the other floors, so nothing
	// should arrive here with storeys at all; this is the backstop for a direct caller, and for the
	// fact that a floor cap of zero would otherwise fall through to the halving below and be SENT.
	if(storeys && travel == SOUND_TRAVEL_CONTAINED)
		return FALSE
	if(storeys)
		muffled ||= SOUND_MUFFLE_SOFT

	// Resolved before the muffle scaling below, which multiplies it.
	if(!falloff_exponent)
		falloff_exponent = sound_falloff_for_range(max_distance || SOUND_RANGE)

	if(muffled)
		falloff_exponent *= SOUND_MUFFLE_EXPONENT_MULT
		vol *= SOUND_MUFFLE_VOLUME_MULT

	S.volume = vol

	// Environment comes from the listener's area, as it always has here; the muffle
	// environment above loses to it when the area sets one, matching the old file.
	// Assigned unconditionally: playsound() builds ONE sound datum and hands it to every
	// listener in turn, so a value left set by one listener follows all the rest. 48 areas
	// set a soundenv, and without the else the first listener standing in one would give
	// their reverb to everybody after them who is standing somewhere plain.
	var/area/A = get_area(get_turf(src))
	if(muffled)
		// Wins over the area. A muffled sound keeping the cathedral's reverb would lose the
		// dead-room character, which is what actually reads as "behind something"; the volume
		// drop on its own just reads as "further away". This only works because the default
		// below is a live space, so the muffle has something to deaden.
		// Every ERP class takes the heavier environment, screams included. A scream through a wall
		// carries at full volume but should still sound like it is coming from somewhere else.
		S.environment = erp ? SOUND_ERP_MUFFLE_ENVIRONMENT : SOUND_MUFFLE_ENVIRONMENT
	else if(A && A.soundenv && A.soundenv != SOUND_ENVIRONMENT_NONE)
		// Truthy, not just "not NONE": /area/soundenv defaults to 0, which is BYOND's flattest
		// preset rather than a missing value, so every unset area was claiming one. No area sets
		// 0 deliberately, so treating it as unset costs nothing and lets the default below apply.
		S.environment = A.soundenv
	else if(isturf(turf_source))
		// Positional sounds only. Weather played straight to the ear, music and UI sounds have
		// no place in the world, so giving them a room to echo in is wrong; they stay dry.
		S.environment = SOUND_DEFAULT_ENVIRONMENT
	else
		S.environment = SOUND_ENVIRONMENT_NONE

	if(vary)
		S.frequency = get_rand_frequency()
	if(frequency)
		S.frequency = frequency

	if(isturf(turf_source))
		//sound volume falloff with distance
		// Through a local, never an expression: the macro names its first argument three times, and
		// get_dist_euclidean is a proc call that would then be made twice on every cross-floor send.
		var/distance = get_dist_euclidean(turf_loc, turf_source) * distance_multiplier
		distance = STOREY_ADJUSTED_DISTANCE(distance, storeys)

		if(max_distance) //If theres no max_distance we're not a 3D sound, so no falloff.
			// Fades to min_volume at max range rather than to nothing. Without the floor the
			// curve reaches 0 short of the edge and the sound disappears inside its own range.
			// Clamped to vol: a sound already quieter than the floor (a vol 3 rustle, or
			// anything under 7 once muffled takes its 25%) would otherwise subtract a negative
			// and get LOUDER the further away you stood.
			var/volume_floor = min(min_volume, vol)
			S.volume -= CALCULATE_SOUND_VOLUME_RATIO(vol, distance, max_distance, falloff_distance, falloff_exponent) * (vol - volume_floor)

		// Capped after the falloff, like the storey cap below, so the number is what a listener
		// hears rather than where the curve starts. Capping first put the figure at distance 0,
		// which is inside the wall: the nearest anyone could actually stand already cost half of it.
		if(muffled == SOUND_MUFFLE_ENCLOSED && !storeys)
			S.volume = min(S.volume, SOUND_TRAVEL_LEAK_VOLUME)

		// Vertical attenuation, on top of the muffling applied above. The distance is horizontal
		// only, so without this a listener directly overhead is at distance 0 and hears the sound
		// at full strength.
		//
		// A floor cap REPLACES the multiplier rather than stacking with it: a capped sound is held
		// at that volume wherever the listener stands on the floor above, which is the point of
		// capping rather than attenuating. Null is the ordinary case and halves.
		if(storeys)
			if(isnull(floor_volume))
				S.volume *= SOUND_STOREY_VOLUME_MULT
			else
				S.volume = min(S.volume, floor_volume)

		// Pan from the body's own turf, as the old file did, complete with the one-tile
		// dead zone that keeps adjacent sounds centered.
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

		// Soften extreme stereo panning. A sound due east or west has S.z == 0, so its
		// direction is purely sideways and BYOND drops it entirely into one ear. Give the
		// front-back axis a floor proportional to the sideways offset, then rescale both back
		// to the original magnitude so ONLY the angle changes. The distance BYOND sees, and
		// therefore its own attenuation on top of ours, is untouched.
		if(S.x && SOUND_PAN_MIN_DEPTH)
			var/min_depth = abs(S.x) * SOUND_PAN_MIN_DEPTH
			if(abs(S.z) < min_depth)
				var/original = sqrt(S.x * S.x + S.z * S.z)
				S.z = (S.z < 0) ? -min_depth : min_depth
				var/widened = sqrt(S.x * S.x + S.z * S.z)
				if(widened)
					S.x *= original / widened
					S.z *= original / widened

		// One storey per z here, not TG's x5: towns stack their floors directly.
		S.y = turf_source.z - our_turf.z

		S.falloff = max_distance || 1 //use max_distance, else just use 1 as we are a direct sound so falloff isnt relevant

		// echo replaces the environment preset rather than layering over it, so a partly filled
		// array costs the room its reverb. S is shared across every listener in the call, so
		// clear it outright when the preset should apply; zeroing slots does not give it back.
		// A muffled ERP sound therefore gets no array at all: its character comes from
		// SOUND_ERP_MUFFLE_ENVIRONMENT, and allocating one here would throw that away.
		// Low-passes the direct path: the part of the muffle that changes the sound itself rather
		// than how loud it is. Allocating the array at all costs the preset, so it is only built
		// when something will actually be written into it. That makes SOUND_MUFFLE_OCCLUSION a
		// real switch: set it to 0 and muffled sounds fall back to the environment preset.
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

	// Master volume applies after falloff so the falloff curve is computed on the
	// caller's numbers, then the whole result is scaled to the player's preference.
	if(client.prefs)
		S.volume *= (isnull(volume_pref) ? client.prefs.mastervol : volume_pref) * 0.01
	S.volume = min(S.volume, 100)

	if(S.volume <= 0)
		return FALSE //No sound

	SEND_SOUND(src, S)

	// The volume actually sent, so a caller can report it rather than recomputing it. Still
	// truthy on success and FALSE when nothing was sent, which is all any caller checks.
	return S.volume

// falloff_exponent, not falloff: this value lands in playsound_local's exponent slot, where a
// 0 would be a divide-by-zero the moment anyone passes a max_distance through here.
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

/mob/proc/mute_sound(sound/S)
	if(!client)
		return
	if(!S)
		return
	S.status |= SOUND_MUTE | SOUND_UPDATE
	SEND_SOUND(src, S)
	S.status &= ~SOUND_UPDATE

/mob/proc/unmute_sound(sound/S)
	if(!client)
		return
	if(!S)
		return
	S.status |= SOUND_UPDATE
	S.status &= ~SOUND_MUTE
	SEND_SOUND(src, S)
	S.status &= ~SOUND_UPDATE

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
		SEND_SOUND(src, sound(SSticker.login_music, repeat = 1, wait = 0, volume = prefs.lobbymusicvol, channel = CHANNEL_LOBBYMUSIC)) // MAD JAMS

/client/proc/sync_instrument_audio_toggle()
	if(!prefs || !mob)
		return

	// Token-driven music re-checks its pref gate per listener; poking each token this mob
	// listens to applies the new preference immediately, muted or unmuted.
	for(var/datum/sound_token/token as anything in mob.sound_tokens)
		if(token.respect_instrument_pref)
			token.update_listener(mob)

	// Legacy jukebox path (musician.dm) still plays raw channel sounds; keep filtering those.
	var/instruments_enabled = !!(prefs.toggles & SOUND_INSTRUMENTS)
	for(var/sound/S in SoundQuery())
		if(!S)
			continue

		var/file_name = "[S.file]"
		if(!(S.channel == CHANNEL_JUKEBOX || findtext(file_name, "sound/instruments/") || findtext(file_name, "sound/music/jukeboxes/") || findtext(file_name, "data/jukeboxuploads/")))
			continue

		if(instruments_enabled)
			mob.unmute_sound(S)
		else
			mob.mute_sound(S)

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
				soundin = pick('sound/combat/hits/onglass/glassbreak (1).ogg','sound/combat/hits/onglass/glassbreak (2).ogg','sound/combat/hits/onglass/glassbreak (3).ogg', 95)
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
