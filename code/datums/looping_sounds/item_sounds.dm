/datum/looping_sound/reverse_bear_trap
	mid_sounds = list('sound/blank.ogg')
	mid_length = 3.5
	volume = 25


/datum/looping_sound/reverse_bear_trap_beep
	mid_sounds = list('sound/blank.ogg')
	mid_length = 60
	volume = 10

// Fire crackle, bone rattle and torch crackle (sconce and handheld) have no looping_sounds: their owners
// register with SSpoint_ambience under a /datum/point_ambience_category and the subsystem
// serves each client the nearest source per category. See its header for why these must
// never own loops or tokens again.

/datum/looping_sound/boilloop
	mid_sounds = list('sound/misc/boiling.ogg')
	mid_length = 98
	volume = 70
	extra_range = 0
	vary = TRUE
	// Token-driven: as a plain loop its volume was frozen for 9.8s at a time across a
	// 7 tile range, so a cauldron never got quieter as you walked off. Native repeat also
	// makes it seamless, and vary went with it, since there are no restarts left to reroll on.
	use_sound_tokens = TRUE

// A cauldron is a kitchen sound, so the line to a listener is short and meets a wall almost at
// once, which is the cheap end of this check. Nothing tactical rides on hearing a pot, and one
// boiling through a wall is what made this worth doing. No config gate: disable_music_wall_muffle
// is about music, and this is not music.
/datum/looping_sound/boilloop/configure_token(datum/sound_token/token)
	token.muffle_behind_walls = TRUE


/datum/looping_sound/boatloop
	mid_sounds = list('sound/ambience/boat (1).ogg','sound/ambience/boat (2).ogg')
	mid_length = 60
	volume = 100
	extra_range = -1
	// Not token-driven. boatbell starts this in Initialize() and never stops it, so 12 of them
	// would hold a channel and their grid registrations all round for docks that are usually
	// empty. Having several mid_sounds it also cannot native-repeat, so it would keep its timer
	// as well and pay both costs.
	// The cost is that volume only updates when the loop replays. Building the token only while
	// a client is in range would fix that, and may be revisited later.
	// The bell's audible ring is a separate plain playsound, not this.

/datum/looping_sound/psydonmusicboxsound
	mid_sounds = list('sound/magic/psydonmusicbox.ogg')
	mid_length = 320
	volume = 50
	extra_range = 10
	// Token-driven, like the other two music boxes. This one is carried: a player cranks it
	// and walks, so both the source and the listeners move during a 28-second track. On the
	// plain playsound path the volume would be fixed at the moment each loop started.
	// Native repeat also closes the 3.2s silent gap the 320 mid_length left over the 288
	// deciseconds of audio.
	// Deliberately NOT respect_instrument_pref: this relic drives stress and status effects, so
	// letting the Instruments slider price it would let a player silence a gameplay cue
	use_sound_tokens = TRUE

// Wall muffle only. The pref gate stays off, see above; a muffled cue is still a cue.
/datum/looping_sound/psydonmusicboxsound/configure_token(datum/sound_token/token)
	token.muffle_behind_walls = !CONFIG_GET(flag/disable_music_wall_muffle)


/// Pestra's charge loop, and ONLY that since rot moved to point ambience. A charge is held for
/// seconds while both the caster and everyone near them move, and there is one per caster mid-cast,
/// so it is a token for the same reasons the other charge loops are.
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
	// Token-driven: 3s frozen volume over a 4 tile range as a plain loop.
	use_sound_tokens = TRUE

