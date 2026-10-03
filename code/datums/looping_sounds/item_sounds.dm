/datum/looping_sound/reverse_bear_trap
	mid_sounds = list('sound/blank.ogg')
	mid_length = 3.5
	volume = 25


/datum/looping_sound/reverse_bear_trap_beep
	mid_sounds = list('sound/blank.ogg')
	mid_length = 60
	volume = 10

// Fire crackle, bone rattle and torch crackle have no loop type here. SSpoint_ambience serves each
// client the nearest source per /datum/point_ambience_category, and its FALLBACK mode gives each
// source a point_ambience_fallback loop

/datum/looping_sound/boilloop
	mid_sounds = list('sound/misc/boiling.ogg')
	mid_length = 98
	volume = 70
	extra_range = 0
	vary = TRUE
	// Token-driven: a plain loop would freeze its volume for each 9.8s mid_length across its whole
	// range. Native repeat also makes it seamless, and leaves vary above with no effect
	use_sound_tokens = TRUE

/**
 * Muffles a cauldron behind walls.
 *
 * A kitchen sound meets a wall almost at once, the cheap end of this check, and nothing tactical
 * rides on hearing a pot. No config gate: disable_music_wall_muffle is about music, and this is not.
 */
/datum/looping_sound/boilloop/configure_token(datum/sound_token/token)
	token.muffle_behind_walls = TRUE


/**
 * The boat bell's ambient loop, a plain timer loop rather than a token.
 *
 * boatbell starts it in Initialize() and never stops it, so tokens would hold a channel and grid
 * registrations all round for docks that are usually empty. With two mid_sounds it cannot
 * native-repeat, so it would keep its timer as well and pay both costs. Volume therefore updates
 * only when the loop replays, and building the token only while a client is in range may be
 * revisited later. The bell's audible ring is a separate playsound.
 */
/datum/looping_sound/boatloop
	mid_sounds = list('sound/ambience/boat (1).ogg','sound/ambience/boat (2).ogg')
	mid_length = 60
	volume = 100
	extra_range = -1

/**
 * The Psydon music box's tune, token-driven like the other two music boxes.
 *
 * It is carried: a player cranks it and walks, so both sides move during the track, and a plain
 * loop would freeze the volume when each play started. Native repeat plays the file back to back,
 * where the 320 mid_length would leave a silent gap after it.
 *
 * Deliberately NOT respect_instrument_pref: this relic drives stress and status effects, and the
 * Instruments slider pricing it would let a player silence a gameplay cue.
 */
/datum/looping_sound/psydonmusicboxsound
	mid_sounds = list('sound/magic/psydonmusicbox.ogg')
	mid_length = 320
	volume = 50
	extra_range = 10
	use_sound_tokens = TRUE

/// Wall muffle only. The Instruments slider stays off it, see above, since a muffled cue is still a cue
/datum/looping_sound/psydonmusicboxsound/configure_token(datum/sound_token/token)
	token.muffle_behind_walls = !CONFIG_GET(flag/disable_music_wall_muffle)


/// Pestra's charge loop. Held for seconds while the caster and everyone near them move, one per
/// caster mid-cast, so a token like the other charge loops
/datum/looping_sound/fliesloop
	mid_sounds = list('sound/misc/fliesloop.ogg')
	mid_length = 60
	volume = 50
	extra_range = 0
	use_sound_tokens = TRUE

/datum/looping_sound/blackmirror
	mid_sounds = list('sound/items/blackmirror_amb.ogg')
	mid_length = 30
	volume = 100
	extra_range = -3
	// Token-driven: a plain loop would freeze its volume for each 3s mid_length
	use_sound_tokens = TRUE

