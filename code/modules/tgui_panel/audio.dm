/*!
 * Copyright (c) 2020 Aleksej Komarov
 * SPDX-License-Identifier: MIT
 */

/// Admin music volume, from 0 to 1.
/client/var/admin_music_volume = 1

/**
 * public
 *
 * Sends music data to the browser.
 *
 * Optional settings:
 * - pitch: the playback rate
 * - start: the start time of the sound
 * - end: when the musics stops playing
 *
 * required url string Must be an https URL.
 * optional extra_data list Optional settings.
 */
/datum/tgui_panel/proc/play_music(url, extra_data)
	if(!is_ready())
		return
	if(!findtext(url, GLOB.is_http_protocol))
		return
	var/list/payload = list()
	if(length(extra_data) > 0)
		for(var/key in extra_data)
			payload[key] = extra_data[key]
	payload["url"] = url
	window.send_message("audio/playMusic", payload)

/**
 * public
 *
 * Sends the streamed music volume to the browser player.
 *
 * The panel keeps its own settings store, so this writes into it rather than being read from prefs.
 * Master is applied HERE because nothing on the browser side knows about it, and the element wants
 * 0 to 1 where the slider is 0 to 100
 */
/datum/tgui_panel/proc/set_streamed_volume()
	if(!is_ready() || !client?.prefs)
		return
	window.send_message("settings/update", list(
		"adminMusicVolume" = client.prefs.at_overall(client.prefs.streamedmusicvol) / 100,
	))

/**
 * public
 *
 * Stops playing music through the browser.
 */
/datum/tgui_panel/proc/stop_music()
	if(!is_ready())
		return
	window.send_message("audio/stopMusic")
