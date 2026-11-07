/**
 * Shared playback settings for instruments, the dwarven music box and the jukebox.
 *
 * Applies the Instruments slider, music wall muffling and an optional stress event on becoming
 * audible. Subtypes call the parent before adding their token settings.
 */
/datum/looping_sound/music
	/// Stress event a living listener gets on starting to hear this, null for none
	var/stress2give = /datum/stressevent/music

/datum/looping_sound/music/configure_token(datum/sound_token/token)
	token.respect_instrument_pref = TRUE
	token.muffle_behind_walls = !CONFIG_GET(flag/disable_music_wall_muffle)
	// Stress lands when a listener first comes into earshot, not on every replay of the track
	token.on_listener_audible = CALLBACK(src, PROC_REF(give_stress))

/// Gives stress2give to a living listener as they start hearing the token
/datum/looping_sound/music/proc/give_stress(mob/listener)
	if(stress2give && isliving(listener))
		listener.add_stress(stress2give)
