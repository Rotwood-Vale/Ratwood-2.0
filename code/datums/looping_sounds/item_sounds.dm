/datum/looping_sound/reverse_bear_trap
	mid_sounds = list('sound/blank.ogg')
	mid_length = 3.5
	volume = 25


/datum/looping_sound/reverse_bear_trap_beep
	mid_sounds = list('sound/blank.ogg')
	mid_length = 60
	volume = 10


/datum/looping_sound/boilloop
	mid_sounds = list('sound/misc/boiling.ogg')
	mid_length = 98
	volume = 70
	extra_range = 0
	vary = TRUE
	// Tokens update volume during playback. Native repeat keeps the single clip continuous
	use_sound_tokens = TRUE

/// Enables wall muffling for cauldrons independently of the music muffling preference
/datum/looping_sound/boilloop/configure_token(datum/sound_token/token)
	token.muffle_behind_walls = TRUE


/**
 * Timer-driven boat ambience, started when the bell initializes.
 *
 * The loop stays active all round and alternates clips, so token playback would retain a channel
 * and spatial tracking without removing the timer. Volume updates when each clip plays. The bell's
 * ring uses a separate playsound() call.
 */
/datum/looping_sound/boatloop
	mid_sounds = list('sound/ambience/boat (1).ogg','sound/ambience/boat (2).ogg')
	mid_length = 60
	volume = 100
	extra_range = -1

/**
 * Positional playback for the carried Psydon music box.
 *
 * Tokens update the sound as the carrier or listeners move, and native repeat avoids gaps between
 * plays. Uses Sound Effects rather than Instruments because the music accompanies stress and status
 * effects.
 */
/datum/looping_sound/psydonmusicboxsound
	mid_sounds = list('sound/magic/psydonmusicbox.ogg')
	mid_length = 320
	volume = 50
	extra_range = 10
	use_sound_tokens = TRUE

/// Enables wall muffling while retaining Sound Effects volume control
/datum/looping_sound/psydonmusicboxsound/configure_token(datum/sound_token/token)
	token.muffle_behind_walls = !CONFIG_GET(flag/disable_music_wall_muffle)


/// Positional charge loop that follows Pestra's caster and nearby listeners during the cast
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
	// Tokens update volume during the charge rather than waiting for the next clip
	use_sound_tokens = TRUE

