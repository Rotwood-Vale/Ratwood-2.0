/client/proc/play_sound(S as sound)
	set category = "-GameMaster-"
	set name = "Sound - Global"
	if(!check_rights(R_SOUND))
		return

	var/freq = 1
	var/vol = input(usr, "What volume would you like the sound to play at?",, 100) as null|num
	if(!vol)
		return
	vol = CLAMP(vol, 1, 100)

	var/sound/admin_sound = new()
	admin_sound.file = S
	admin_sound.priority = 250
	admin_sound.channel = CHANNEL_ADMIN
	admin_sound.frequency = freq
	admin_sound.wait = 1
	admin_sound.repeat = 0
	admin_sound.status = SOUND_STREAM
	admin_sound.volume = vol

	var/res = alert(usr, "Show the title of this song to the players?",, "Yes","No", "Cancel")
	switch(res)
		if("Yes")
			to_chat(world, span_boldannounce("An admin played: [S]"))
		if("Cancel")
			return

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]")

	for(var/mob/M in GLOB.player_list)
		if(M.client.prefs.toggles & SOUND_MIDI)
			// Set volume for every listener so the shared sound cannot retain another player's
			// preference
			admin_sound.volume = vol * M.client.prefs.at_overall(M.client.prefs.adminmusicvol) * 0.01
			SEND_SOUND(M, admin_sound)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Global Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/verb/change_music_vol()
	set category = "Options"
	set name = "ChangeMusicPower"
	set hidden = 1

	if(prefs)
/*		if(blacklisted() == 1)
			var/vol = input(usr, "Current music power: [prefs.musicvol]",, 100) as null|num
			vol = 100
			prefs.musicvol = vol
			prefs.save_preferences()
			mob.update_music_volume(CHANNEL_MUSIC, prefs.musicvol)
			mob.update_music_volume(CHANNEL_LOBBYMUSIC, prefs.musicvol)
			mob.update_music_volume(CHANNEL_ADMIN, prefs.musicvol)
		else*/
		var/vol = input(usr, "Current music power: [prefs.musicvol]",, 100) as null|num
		if(!vol)
			if(vol != 0)
				return
		vol = min(vol, 100)
		prefs.musicvol = vol
		prefs.save_preferences()

		mob.update_music_volume(CHANNEL_MUSIC, prefs.at_overall(prefs.musicvol))
		mob.update_music_volume(CHANNEL_ADMIN, prefs.at_overall(prefs.adminmusicvol))

/client/verb/volume_power_menu()
	set category = "Options"
	set name = "Audio Settings"

	if(!prefs)
		return

	if(!volume_power_menu)
		volume_power_menu = new(src)

	volume_power_menu.ui_interact(mob)

/**
 * Applies an Audio Settings slider and schedules a preference save.
 *
 * Point ambience changes notify listener_prefs_changed(), which handles muting and registration.
 * Repeated changes share one deferred save. Closing the menu also saves the final value.
 */
/client/proc/apply_volume_power_setting(setting_id, volume_value)
	if(!prefs)
		return

	var/vol = clamp(round(volume_value), 0, 100)
	switch(setting_id)
		if("master")
			prefs.overallvol = vol
			update_slider_channels()
			if(volume_power_menu)
				volume_power_menu.effects_changed = TRUE
		if("effects")
			prefs.mastervol = vol
			if(volume_power_menu)
				volume_power_menu.effects_changed = TRUE
		if("instruments")
			prefs.instrumentvol = vol
			sync_instrument_volume()
		if("music")
			prefs.musicvol = vol
			mob?.update_music_volume(CHANNEL_MUSIC, prefs.at_overall(prefs.musicvol))
		if("adminmusic")
			prefs.adminmusicvol = vol
			mob?.update_music_volume(CHANNEL_ADMIN, prefs.at_overall(prefs.adminmusicvol))
		if("streamedmusic")
			prefs.streamedmusicvol = vol
			tgui_panel?.set_streamed_volume()
		if("combat")
			prefs.combatmusicvol = vol
			if(mob?.cmode)
				var/combat_volume = prefs.at_overall(prefs.combatmusicvol)
				mob.update_music_volume(CHANNEL_BUZZ, combat_volume)
				mob.update_music_volume(CHANNEL_CMUSIC1, combat_volume)
				mob.update_music_volume(CHANNEL_CMUSIC2, combat_volume)
				mob.update_music_volume(CHANNEL_CMUSIC3, combat_volume)
				mob.update_music_volume(CHANNEL_CMUSIC4, combat_volume)
		if("ambience")
			prefs.ambiencevol = vol
			mob?.update_channel_volume(CHANNEL_AMBIENCE, prefs.at_overall(prefs.ambiencevol))
			mob?.update_channel_volume(CHANNEL_RAIN, prefs.at_overall(prefs.ambiencevol))
		if("lobby")
			prefs.lobbymusicvol = vol
			if(isnewplayer(mob))
				mob.update_music_volume(CHANNEL_LOBBYMUSIC, prefs.at_overall(prefs.lobbymusicvol))
		if("point_ambience_volume")
			prefs.pointambiencevol = vol
		else
			return

	if(setting_id == "point_ambience_volume" || setting_id == "master")
		SSpoint_ambience.listener_prefs_changed(src)
	// Coalesce repeated slider changes into one disk write
	addtimer(CALLBACK(prefs, TYPE_PROC_REF(/datum/preferences, save_preferences)), 2 SECONDS, TIMER_UNIQUE | TIMER_OVERRIDE)

/datum/volume_power_menu
	var/client/owner
	/// Whether Master or Sound Effects changed, requiring one token and weather refresh when the
	/// menu closes
	var/effects_changed = FALSE

/datum/volume_power_menu/New(client/C)
	. = ..()
	owner = C

/datum/volume_power_menu/Destroy(force)
	if(owner?.volume_power_menu == src)
		owner.volume_power_menu = null
	owner = null
	return ..()

/datum/volume_power_menu/ui_close(mob/user)
	// Save before closing so disconnecting before the deferred write cannot lose the last change
	owner?.prefs?.save_preferences()
	if(effects_changed)
		effects_changed = FALSE
		owner?.resend_effect_sounds()
	return ..()

/datum/volume_power_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "VolumePowerMenu", "Audio Settings")
		ui.set_state(GLOB.always_state)
		ui.open()

/datum/volume_power_menu/ui_data(mob/user)
	var/list/data = list()
	if(!owner?.prefs)
		return data

	data["master"] = isnum(owner.prefs.overallvol) ? owner.prefs.overallvol : initial(owner.prefs.overallvol)
	data["effects"] = isnum(owner.prefs.mastervol) ? owner.prefs.mastervol : initial(owner.prefs.mastervol)
	data["instruments"] = isnum(owner.prefs.instrumentvol) ? owner.prefs.instrumentvol : initial(owner.prefs.instrumentvol)
	data["replace_uploaded_songs"] = !(owner.prefs.toggles & SOUND_UPLOADED_SONGS)
	data["music"] = isnum(owner.prefs.musicvol) ? owner.prefs.musicvol : initial(owner.prefs.musicvol)
	data["adminmusic"] = isnum(owner.prefs.adminmusicvol) ? owner.prefs.adminmusicvol : initial(owner.prefs.adminmusicvol)
	data["streamedmusic"] = isnum(owner.prefs.streamedmusicvol) ? owner.prefs.streamedmusicvol : initial(owner.prefs.streamedmusicvol)
	data["combat"] = isnum(owner.prefs.combatmusicvol) ? owner.prefs.combatmusicvol : initial(owner.prefs.combatmusicvol)
	data["ambience"] = isnum(owner.prefs.ambiencevol) ? owner.prefs.ambiencevol : initial(owner.prefs.ambiencevol)
	data["lobby"] = isnum(owner.prefs.lobbymusicvol) ? owner.prefs.lobbymusicvol : initial(owner.prefs.lobbymusicvol)
	data["point_ambience_volume"] = isnum(owner.prefs.pointambiencevol) ? owner.prefs.pointambiencevol : initial(owner.prefs.pointambiencevol)
	data["point_ambience_independent"] = owner.prefs.pointambience_independent
	// Stored flags disable features. Expose positive enabled values to the UI
	data["point_ambience"] = !(owner.prefs.point_ambience_toggles & SOUND_DISABLE_POINT_AMBIENCE)
	data["point_ambience_torch"] = !(owner.prefs.point_ambience_toggles & SOUND_DISABLE_TORCH_AMBIENCE)
	return data

/datum/volume_power_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	if(!owner?.prefs)
		return FALSE

	if(action == "set_volume")
		var/setting_id = params["id"]
		var/volume_value = text2num(params["value"])
		owner.apply_volume_power_setting(setting_id, volume_value)
		SStgui.update_uis(src)
		return TRUE

	if(action == "toggle")
		if(params["id"] == "replace_uploaded_songs")
			owner.prefs.toggles ^= SOUND_UPLOADED_SONGS
			owner.prefs.save_preferences()
			// Refresh stationary listeners immediately when their selected file changes
			owner.sync_uploaded_songs()
			SStgui.update_uis(src)
			return TRUE
		if(params["id"] == "point_ambience_independent")
			owner.prefs.pointambience_independent = !owner.prefs.pointambience_independent
			owner.prefs.save_preferences()
			SSpoint_ambience.listener_prefs_changed(owner)
			SStgui.update_uis(src)
			return TRUE
		var/flag
		switch(params["id"])
			if("point_ambience")
				flag = SOUND_DISABLE_POINT_AMBIENCE
			if("point_ambience_torch")
				flag = SOUND_DISABLE_TORCH_AMBIENCE
			else
				return FALSE
		owner.prefs.point_ambience_toggles ^= flag
		owner.prefs.save_preferences()
		// Handle both stopping disabled categories and starting re-enabled ones for stationary
		// listeners
		SSpoint_ambience.listener_prefs_changed(owner)
		SStgui.update_uis(src)
		return TRUE

	return FALSE


/client/verb/show_rolls()
	set category = "Options"
	set name = "ShowRolls"
	set hidden = 1

	if(prefs)
		prefs.showrolls = !prefs.showrolls
		prefs.save_preferences()
		if(prefs.showrolls)
			to_chat(src, "ShowRolls Enabled")
		else
			to_chat(src, "ShowRolls Disabled")

/client/verb/change_master_vol()
	set category = "Options"
	set name = "ChangeVolPower"
	set hidden = 1

	if(prefs)
		var/vol = input(usr, "Current sound effects power (every sound but music and ambience, under Master): [prefs.mastervol]",, 100) as null|num
		if(!vol)
			if(vol != 0)
				return
		vol = min(vol, 100)
		prefs.mastervol = vol
		prefs.save_preferences()

/client/verb/change_ambience_vol()
	set category = "Options"
	set name = "ChangeAmbiencePower"
	set hidden = 1

	if(prefs)
		var/vol = input(usr, "Current ambience power: [prefs.ambiencevol]",, 100) as null|num
		if(!vol)
			if(vol != 0)
				return
		vol = min(vol, 100)
		prefs.ambiencevol = vol
		prefs.save_preferences()

		mob.update_channel_volume(CHANNEL_AMBIENCE, prefs.at_overall(prefs.ambiencevol))
		mob.update_channel_volume(CHANNEL_RAIN, prefs.at_overall(prefs.ambiencevol))

/client/verb/change_lobby_music_vol()
	set category = "Options"
	set name = "ChangeLobbyMusicPower"
	set hidden = 1

	if(prefs)
		var/vol = input(usr, "Current lobby music power: [prefs.lobbymusicvol]",, 100) as null|num
		if(!vol)
			if(vol != 0)
				return
		vol = min(vol, 100)
		prefs.lobbymusicvol = vol
		prefs.save_preferences()

		if(isnewplayer(mob))
			mob.update_music_volume(CHANNEL_LOBBYMUSIC, prefs.at_overall(prefs.lobbymusicvol))

/*
/client/verb/help_rpguide()
	set category = "Options"
	set name = "zHelp-RPGuide"

	src << link("https://cdn.discordapp.com/attachments/844865105040506891/938971395445112922/rpguide.jpg")

/client/verb/help_uihelp()
	set category = "Options"
	set name = "zHelp-UIGuide"

	src << link("https://cdn.discordapp.com/attachments/844865105040506891/938275090414579762/unknown.png")
*/

/client/proc/play_local_sound(S as sound)
	set category = "-GameMaster-"
	set name = "Sound - Local"
	if(!check_rights(R_SOUND))
		return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]")
	playsound(get_turf(src.mob), S, 50, FALSE, FALSE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Local Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_local_sound_variable(S as sound)
	set category = "-GameMaster-"
	set name = "Sound - Variable Dist"
	if(!check_rights(R_SOUND))
		return

	var/dist = input(usr, "How far do you want this sound to extend?",, 50) as null|num
	if(!dist)
		return
	dist = CLAMP(dist, 1, 100)

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]")
	playsound(get_turf(src.mob), S, dist, FALSE, FALSE)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Local Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_web_sound()
	set category = "-GameMaster-"
	set name = "Sound - Internet"
	if(!check_rights(R_SOUND))
		return

	var/ytdl = CONFIG_GET(string/invoke_youtubedl)
	if(!ytdl)
		to_chat(src, span_boldwarning("Youtube-dl was not configured, action unavailable")) //Check config.txt for the INVOKE_YOUTUBEDL value
		return

	var/web_sound_input = input("Enter content URL (supported sites only, leave blank to stop playing)", "PASS THE AUX CORD, MILORD.") as text|null
	if(istext(web_sound_input))
		var/web_sound_url = ""
		var/stop_web_sounds = FALSE
		var/list/music_extra_data = list()
		if(length(web_sound_input))

			web_sound_input = trim(web_sound_input)
			if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
				to_chat(src, span_boldwarning("Non-http(s) URIs are not allowed."))
				to_chat(src, span_warning("For youtube-dl shortcuts like ytsearch: please use the appropriate full url from the website."))
				return
			var/shell_scrubbed_input = shell_url_scrub(web_sound_input)
			var/list/output = world.shelleo("[ytdl] --geo-bypass --format \"bestaudio\[ext=mp3]/best\[ext=mp4]\[height<=360]/bestaudio\[ext=m4a]/bestaudio\[ext=aac]\" --dump-single-json --no-playlist -- \"[shell_scrubbed_input]\"")
			var/errorlevel = output[SHELLEO_ERRORLEVEL]
			var/stdout = output[SHELLEO_STDOUT]
			var/stderr = output[SHELLEO_STDERR]
			if(!errorlevel)
				var/list/data
				try
					data = json_decode(stdout)
				catch(var/exception/e)
					to_chat(src, span_boldwarning("Youtube-dl JSON parsing FAILED:"))
					to_chat(src, span_warning("[e]: [stdout]"))
					return

				if (data["url"])
					web_sound_url = data["url"]
					var/title = "[data["title"]]"
					var/webpage_url = title
					if (data["webpage_url"])
						webpage_url = "<a href=\"[data["webpage_url"]]\">[title]</a>"
					music_extra_data["start"] = data["start_time"]
					music_extra_data["end"] = data["end_time"]

					var/artist = data["uploader"]
					var/album = data["album"]
					var/upload_date = data["upload_date"]
					var/duration_value = data["duration"]
					var/link_meta = web_sound_input
					if (data["webpage_url"])
						link_meta = "[data["webpage_url"]]"

					// Base metadata for the TGUI media player
					music_extra_data["title"] = title
					music_extra_data["link"] = link_meta
					if(artist)
						music_extra_data["artist"] = artist
					if(album)
						music_extra_data["album"] = album
					if(upload_date)
						music_extra_data["upload_date"] = upload_date
					if(isnum(duration_value))
						music_extra_data["duration"] = "[duration_value] seconds"

					var/res = alert(usr, "Show the title of and link to this song to the players?\n[title]", "PASS THE AUX CORD, MILORD.", "No", "Yes", "Cancel")
					switch(res)
						if("Yes")
							to_chat(world, span_boldannounce("An admin played: [webpage_url]"))
						if("No")
							// Hide detailed metadata in the chat media widget while still playing the song
							music_extra_data["title"] = null
							music_extra_data["link"] = "Song Link Hidden"
							music_extra_data["duration"] = "Song Duration Hidden"
							music_extra_data["artist"] = "Song Artist Hidden"
							music_extra_data["album"] = "Song Album Hidden"
							music_extra_data["upload_date"] = "Song Upload Date Hidden"
						if("Cancel")
							return

					SSblackbox.record_feedback("nested tally", "played_url", 1, list("[ckey]", "[web_sound_input]"))
					log_admin("[key_name(src)] played web sound: [web_sound_input]")
					message_admins("[key_name(src)] played web sound: [web_sound_input]")
			else
				to_chat(src, span_boldwarning("Youtube-dl URL retrieval FAILED:"))
				to_chat(src, span_warning("[stderr]"))

		else //pressed ok with blank
			log_admin("[key_name(src)] stopped web sound")
			message_admins("[key_name(src)] stopped web sound")
			web_sound_url = null
			stop_web_sounds = TRUE

		if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning("BLOCKED: Content URL not using http(s) protocol"))
			to_chat(src, span_warning("The media provider returned a content URL that isn't using the HTTP or HTTPS protocol"))
			return
		if(web_sound_url || stop_web_sounds)
			for(var/m in GLOB.player_list)
				var/mob/M = m
				var/client/C = M.client
				if(C.prefs.toggles & SOUND_MIDI)
					// Stops playing lobby music and admin loaded music automatically.
					SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
					SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
					if(!stop_web_sounds)
						C.tgui_panel?.play_music(web_sound_url, music_extra_data)
					else
						C.tgui_panel?.stop_music()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Internet Sound")

/client/proc/play_music_global_url()
	set category = "-GameMaster-"
	set name = "Music - Global URL"
	if(!check_rights(R_SOUND))
		return

	var/web_sound_input = input("Enter direct HTTPS audio URL (leave blank to stop playing)", "PASS THE AUX CORD, MILORD.") as text|null
	if(isnull(web_sound_input))
		return

	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/list/music_extra_data = list()

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning("Non-http(s) URIs are not allowed."))
			return

		web_sound_url = web_sound_input

		var/title = input(usr, "Optional: song title to display (leave blank for Unknown Track)", "Song Title") as null|text
		var/artist = input(usr, "Optional: song artist to display (leave blank to hide)", "Song Artist") as null|text

		music_extra_data["title"] = title
		music_extra_data["link"] = web_sound_input
		if(artist)
			music_extra_data["artist"] = artist

		var/res = alert(usr, "Show the title and link of this song to the players?\n[title ? title : web_sound_input]", "PASS THE AUX CORD, MILORD.", "No", "Yes", "Cancel")
		switch(res)
			if("Yes")
				to_chat(world, span_boldannounce("An admin played: [title ? title : web_sound_input]"))
			if("No")
				music_extra_data["title"] = null
				music_extra_data["link"] = "Song Link Hidden"
				music_extra_data["duration"] = "Song Duration Hidden"
				music_extra_data["artist"] = "Song Artist Hidden"
				music_extra_data["album"] = "Song Album Hidden"
				music_extra_data["upload_date"] = "Song Upload Date Hidden"
			if("Cancel")
				return
	else
		log_admin("[key_name(src)] stopped global URL music")
		message_admins("[key_name_admin(src)] stopped global URL music")
		stop_web_sounds = TRUE

	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		to_chat(src, span_boldwarning("BLOCKED: Content URL not using http(s) protocol"))
		return

	if(web_sound_url || stop_web_sounds)
		log_admin("[key_name(src)] played global URL music: [web_sound_input]")
		message_admins("[key_name(src)] played global URL music: [web_sound_input]")
		for(var/mob/M in GLOB.player_list)
			var/client/C = M.client
			if(!C)
				continue
			if(C.prefs.toggles & SOUND_MIDI)
				SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
				SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
				if(!stop_web_sounds)
					C.tgui_panel?.play_music(web_sound_url, music_extra_data)
				else
					C.tgui_panel?.stop_music()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Global Music URL")

/client/proc/play_music_local_url()
	set category = "-GameMaster-"
	set name = "Music - Local URL"
	if(!check_rights(R_SOUND))
		return

	var/web_sound_input = input("Enter direct HTTPS audio URL (leave blank to stop playing)", "Play Local Music (URL)") as text|null
	if(isnull(web_sound_input))
		return

	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/dist = 0
	var/list/music_extra_data = list()

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning("Non-http(s) URIs are not allowed."))
			return

		web_sound_url = web_sound_input

		dist = input(usr, "How far do you want this music to extend?",, 50) as null|num
		if(!dist)
			return
		dist = CLAMP(dist, 1, 100)

		var/title = input(usr, "Optional: song title to display (leave blank for Unknown Track)", "Song Title") as null|text
		var/artist = input(usr, "Optional: song artist to display (leave blank to hide)", "Song Artist") as null|text

		music_extra_data["title"] = title
		music_extra_data["link"] = web_sound_input
		if(artist)
			music_extra_data["artist"] = artist

		var/res = alert(usr, "Show the title and link of this song to nearby players?\n[title ? title : web_sound_input]", "PASS THE AUX CORD, MILORD.", "No", "Yes", "Cancel")
		switch(res)
			if("Yes")
				to_chat(world, span_boldannounce("An admin played locally: [title ? title : web_sound_input]"))
			if("No")
				music_extra_data["title"] = null
				music_extra_data["link"] = "Song Link Hidden"
				music_extra_data["duration"] = "Song Duration Hidden"
				music_extra_data["artist"] = "Song Artist Hidden"
				music_extra_data["album"] = "Song Album Hidden"
				music_extra_data["upload_date"] = "Song Upload Date Hidden"
			if("Cancel")
				return
	else
		log_admin("[key_name(src)] stopped local URL music")
		message_admins("[key_name_admin(src)] stopped local URL music")
		stop_web_sounds = TRUE

	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		to_chat(src, span_boldwarning("BLOCKED: Content URL not using http(s) protocol"))
		return

	if(web_sound_url || stop_web_sounds)
		log_admin("[key_name(src)] played local URL music: [web_sound_input]")
		message_admins("[key_name(src)] played local URL music: [web_sound_input]")
		var/turf/source_turf = get_turf(src.mob)
		for(var/mob/M in GLOB.player_list + GLOB.dead_mob_list)
			var/client/C = M.client
			if(!C)
				continue
			if(!(C.prefs.toggles & SOUND_MIDI))
				continue
			if(get_dist(source_turf, get_turf(M)) > dist)
				continue
			SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
			SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
			if(!stop_web_sounds)
				C.tgui_panel?.play_music(web_sound_url, music_extra_data)
			else
				C.tgui_panel?.stop_music()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Local Music URL")

/client/proc/play_music_direct_url(mob/M)
	set category = "-GameMaster-"
	set name = "Music - Direct URL"
	if(!check_rights(R_SOUND))
		return

	if(!M)
		M = input("Play to whom?", "Active Players") as null|anything in (GLOB.player_list + GLOB.dead_mob_list)

	if(!M)
		return

	var/client/C = M.client
	if(!C)
		return

	var/web_sound_input = input("Enter direct HTTPS audio URL (leave blank to stop playing)", "PASS THE AUX CORD, MILORD.") as text|null
	if(isnull(web_sound_input))
		return

	var/web_sound_url = ""
	var/stop_web_sounds = FALSE
	var/list/music_extra_data = list()

	if(length(web_sound_input))
		web_sound_input = trim(web_sound_input)
		if(findtext(web_sound_input, ":") && !findtext(web_sound_input, GLOB.is_http_protocol))
			to_chat(src, span_boldwarning("Non-http(s) URIs are not allowed."))
			return

		web_sound_url = web_sound_input

		var/title = input(usr, "Optional: song title to display (leave blank for Unknown Track)", "Song Title") as null|text
		var/artist = input(usr, "Optional: song artist to display (leave blank to hide)", "Song Artist") as null|text

		music_extra_data["title"] = title
		music_extra_data["link"] = web_sound_input
		if(artist)
			music_extra_data["artist"] = artist

		var/res = alert(usr, "Show the title and link of this song to [M]?\n[title ? title : web_sound_input]", "PASS THE AUX CORD, MILORD.", "No", "Yes", "Cancel")
		switch(res)
			if("Yes")
				to_chat(M, span_boldannounce("An admin played: [title ? title : web_sound_input]"))
			if("No")
				music_extra_data["title"] = null
				music_extra_data["link"] = "Song Link Hidden"
				music_extra_data["duration"] = "Song Duration Hidden"
				music_extra_data["artist"] = "Song Artist Hidden"
				music_extra_data["album"] = "Song Album Hidden"
				music_extra_data["upload_date"] = "Song Upload Date Hidden"
			if("Cancel")
				return
	else
		log_admin("[key_name(src)] stopped direct URL music for [M]")
		message_admins("[key_name_admin(src)] stopped direct URL music for [M]")
		stop_web_sounds = TRUE

	if(web_sound_url && !findtext(web_sound_url, GLOB.is_http_protocol))
		to_chat(src, span_boldwarning("BLOCKED: Content URL not using http(s) protocol"))
		return

	if(web_sound_url || stop_web_sounds)
		log_admin("[key_name(src)] played direct URL music for [M]: [web_sound_input]")
		message_admins("[key_name(src)] played direct URL music for [M]: [web_sound_input]")
		if(C.prefs.toggles & SOUND_MIDI)
			SEND_SOUND(C, sound(null, channel = CHANNEL_LOBBYMUSIC))
			SEND_SOUND(C, sound(null, channel = CHANNEL_ADMIN))
			if(!stop_web_sounds)
				C.tgui_panel?.play_music(web_sound_url, music_extra_data)
			else
				C.tgui_panel?.stop_music()

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Play Direct Music URL")

/client/proc/set_round_end_sound(S as sound)
	set category = "-GameMaster-"
	set name = "Sound - Round End"
	if(!check_rights(R_SOUND))
		return

	SSticker.SetRoundEndSound(S)

	log_admin("[key_name(src)] set the round end sound to [S]")
	message_admins("[key_name_admin(src)] set the round end sound to [S]")
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Set Round End Sound") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/stop_sounds()
	set category = "-GameMaster-"
	set name = "Sound - Stop All Playing"
	if(!src.holder)
		return

	log_admin("[key_name(src)] stopped all currently playing sounds.")
	message_admins("[key_name_admin(src)] stopped all currently playing sounds.")
	for(var/mob/M in GLOB.player_list)
		SEND_SOUND(M, sound(null))
		var/client/C = M.client
		C?.tgui_panel?.stop_music()
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Stop All Playing Sounds") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

GLOBAL_LIST_INIT(ambience_files, list(
	'sound/music/area/bath.ogg',
	'sound/music/area/bog.ogg',
	'sound/music/area/catacombs.ogg',
	'sound/music/area/caves.ogg',
	'sound/music/area/church.ogg',
	'sound/music/area/decap.ogg',
	'sound/music/area/dungeon.ogg',
	'sound/music/area/dwarf.ogg',
	'sound/music/area/field.ogg',
	'sound/music/area/forest.ogg',
	'sound/music/area/magiciantower.ogg',
	'sound/music/area/manorgarri.ogg',
	'sound/music/area/sargoth.ogg',
	'sound/music/area/septimus.ogg',
	'sound/music/area/sewers.ogg',
	'sound/music/area/shop.ogg',
	'sound/music/area/spidercave.ogg',
	'sound/music/area/towngen.ogg',
	'sound/music/area/townstreets.ogg'
	))
