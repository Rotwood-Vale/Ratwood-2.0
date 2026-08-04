#define BARD_TRACK_MAX_LYRICS 6000
#define BARD_TRACK_MAX_PHRASES 200
#define BARD_TRACK_DEFAULT_LOOP_TICKS 2400
#define BARD_TRACK_DEFAULT_DURATION_SECONDS 240
#define BARD_TRACK_DEFAULT_SPACING_SECONDS 2

SUBSYSTEM_DEF(bard_music)
	name = "bard music"
	wait = 1
	flags = SS_NO_INIT
	priority = FIRE_PRIORITY_CHAT
	var/list/active_instruments = list()

/datum/controller/subsystem/bard_music/proc/register(obj/item/rogue/instrument/instrument)
	if(!instrument || QDELETED(instrument))
		return
	active_instruments |= instrument

/datum/controller/subsystem/bard_music/proc/unregister(obj/item/rogue/instrument/instrument)
	if(!instrument)
		return
	active_instruments -= instrument

/datum/controller/subsystem/bard_music/fire(resumed = 0)
	if(!active_instruments.len)
		return
	var/list/current = active_instruments.Copy()
	while(current.len)
		var/obj/item/rogue/instrument/instrument = current[current.len]
		current.len--
		if(!instrument || QDELETED(instrument) || !instrument.process_auto_song())
			active_instruments -= instrument
		if(MC_TICK_CHECK)
			break

/datum/bard_timed_phrase
	var/time = 0
	var/text = ""

/datum/bard_timed_phrase/proc/export_data()
	return list("time" = time, "text" = text)

/datum/bard_band_member
	var/mob/living/player
	var/obj/item/rogue/instrument/instrument
	var/track_title = ""
	var/sing = FALSE

/datum/bard_band_member/proc/export_data()
	return list(
		"name" = player ? player.real_name : "Unknown",
		"instrument" = instrument ? instrument.name : "unknown",
		"track" = track_title,
		"mode" = sing ? "Sing" : "Mute"
	)

/mob/living
	var/tmp/bard_music_playing = FALSE
	var/tmp/bard_auto_singing = FALSE
	var/tmp/bard_auto_song_token = 0

/mob/living/proc/is_blocked_by_music_consumption()
	return bard_music_playing || has_status_effect(/datum/status_effect/buff/playing_music)

/mob/living/proc/is_blocked_by_auto_song()
	return bard_auto_singing

/datum/bard_timed_track
	var/title = ""
	var/file_path = null
	var/duration_seconds = 0
	var/lyrics = ""
	var/custom = FALSE
	var/analyzed_duration = FALSE
	var/phrase_spacing_seconds = BARD_TRACK_DEFAULT_SPACING_SECONDS
	var/list/phrases = list()

/datum/bard_timed_track/proc/set_song(song_title, song_file, custom_track = FALSE)
	title = song_title
	file_path = song_file
	duration_seconds = bard_track_file_duration_seconds(song_file)
	analyzed_duration = (duration_seconds != BARD_TRACK_DEFAULT_DURATION_SECONDS)
	custom = custom_track

/datum/bard_timed_track/proc/rebuild_from_lyrics(raw_lyrics)
	lyrics = copytext(raw_lyrics ? raw_lyrics : "", 1, BARD_TRACK_MAX_LYRICS)
	phrases = bard_track_build_phrases(lyrics, phrase_spacing_seconds)

/datum/bard_timed_track/proc/set_spacing(new_spacing)
	phrase_spacing_seconds = clamp(round(bard_track_num(new_spacing)), 1, 120)
	rebuild_from_lyrics(lyrics)

/datum/bard_timed_track/proc/set_phrase_time(index, new_time)
	index = round(bard_track_num(index))
	if(index < 1 || index > phrases.len)
		return FALSE
	var/datum/bard_timed_phrase/base_phrase = phrases[index]
	var/old_time = base_phrase.time
	var/target_time = max(round(bard_track_num(new_time)), 0)
	var/delta = target_time - old_time
	for(var/i in index to phrases.len)
		var/datum/bard_timed_phrase/phrase = phrases[i]
		phrase.time = max(round(phrase.time + delta, 0.1), 0)
	return TRUE

/datum/bard_timed_track/proc/set_phrase_text(index, new_text)
	index = round(bard_track_num(index))
	if(index < 1 || index > phrases.len)
		return FALSE
	var/datum/bard_timed_phrase/phrase = phrases[index]
	var/text = istext(new_text) ? new_text : "[new_text]"
	phrase.text = trimtext(copytext(text, 1, MAX_MESSAGE_LEN))
	sync_lyrics_from_phrases()
	return TRUE

/datum/bard_timed_track/proc/export_data()
	var/list/out_phrases = list()
	for(var/datum/bard_timed_phrase/phrase as anything in phrases)
		out_phrases += list(phrase.export_data())
	return list(
		"title" = title,
		"file" = "[file_path]",
		"duration_seconds" = duration_seconds,
		"spacing_seconds" = phrase_spacing_seconds,
		"phrases" = out_phrases
	)

/datum/bard_timed_track/proc/export_json()
	return json_encode(export_data())

/datum/bard_timed_track/proc/import_json(raw_json)
	if(!raw_json)
		return FALSE
	var/list/data = safe_json_decode(raw_json)
	if(!islist(data))
		return FALSE
	var/list/imported_phrases = data["phrases"]
	if(!islist(imported_phrases))
		return FALSE
	if(data["spacing_seconds"])
		var/imported_spacing = data["spacing_seconds"]
		phrase_spacing_seconds = clamp(round(bard_track_num(imported_spacing), 0.1), 0.1, 120)
	phrases = list()
	for(var/list/entry as anything in imported_phrases)
		if(!islist(entry))
			continue
		var/imported_text = entry["text"]
		var/text = trimtext(istext(imported_text) ? imported_text : "[imported_text]")
		if(!text)
			continue
		var/datum/bard_timed_phrase/phrase = new
		var/imported_time = entry["time"]
		phrase.time = max(bard_track_num(imported_time), 0)
		phrase.text = text
		phrases += phrase
		if(phrases.len >= BARD_TRACK_MAX_PHRASES)
			break
	sync_lyrics_from_phrases()
	return TRUE

/datum/bard_timed_track/proc/sync_lyrics_from_phrases()
	var/list/imported_lines = list()
	for(var/datum/bard_timed_phrase/phrase as anything in phrases)
		imported_lines += phrase.text
	lyrics = jointext(imported_lines, "\n")

/proc/bard_track_file_duration_seconds(song_file)
	. = BARD_TRACK_DEFAULT_DURATION_SECONDS
	if(!song_file)
		return
	var/length_ticks = rustg_sound_length("[song_file]")
	if(length_ticks)
		. = max(round(length_ticks / 10), 1)

/proc/bard_track_num(value, fallback = 0)
	if(isnum(value))
		return value
	if(istext(value))
		var/parsed = text2num(value)
		return isnum(parsed) ? parsed : fallback
	return fallback

/proc/bard_track_format_duration(total_seconds)
	total_seconds = max(round(bard_track_num(total_seconds)), 0)
	var/minutes = round(total_seconds / 60)
	var/seconds = total_seconds % 60
	return "[minutes]:[seconds < 10 ? "0[seconds]" : seconds]"

/proc/bard_track_strip_tags(raw_text)
	var/static/regex/tag_regex = regex(@"\[[^\]]*\]", "g")
	return trimtext(tag_regex.Replace(raw_text ? raw_text : "", ""))

/proc/bard_track_build_phrases(raw_lyrics, spacing_seconds)
	var/list/out = list()
	var/clean = bard_track_strip_tags(raw_lyrics)
	clean = replacetext(clean, ascii2text(13), "")
	clean = replacetext(clean, "\t", " ")
	var/list/source_lines = splittext(clean, "\n")
	var/list/final_lines = list()
	for(var/line in source_lines)
		var/trimmed = trimtext(line)
		if(trimmed)
			final_lines += trimmed
	if(!final_lines.len && clean)
		var/list/words = splittext(clean, " ")
		var/list/chunk = list()
		for(var/word in words)
			var/trimmed_word = trimtext(word)
			if(!trimmed_word)
				continue
			chunk += trimmed_word
			if(chunk.len >= 8)
				final_lines += jointext(chunk, " ")
				chunk = list()
		if(chunk.len)
			final_lines += jointext(chunk, " ")
	if(final_lines.len > BARD_TRACK_MAX_PHRASES)
		final_lines.Cut(BARD_TRACK_MAX_PHRASES + 1)
	var/step = max(spacing_seconds, 0.1)
	for(var/i in 1 to final_lines.len)
		var/datum/bard_timed_phrase/phrase = new
		phrase.time = round((i - 1) * step)
		phrase.text = final_lines[i]
		out += phrase
	return out

/obj/item/rogue/instrument
	var/repeat_enabled = FALSE
	var/mob/living/current_player = null
	var/datum/bard_timed_track/current_track = null
	var/current_track_title = null
	var/music_started_at = 0
	var/music_realtime_started_at = 0
	var/music_playback_id = 0
	var/music_stop_token = 0
	var/auto_song_enabled = FALSE
	var/auto_singing_title = null
	var/datum/bard_timed_track/auto_song_track = null
	var/auto_song_next_phrase_index = 1
	var/auto_song_cycle_started_at = 0
	var/band_invite_active = FALSE
	var/band_invite_until = 0
	var/mob/living/band_invite_leader = null
	var/list/band_members = list()
	var/list/timed_tracks = list()
	var/music_panel_selected = null

/obj/item/rogue/instrument/proc/ensure_timed_tracks()
	if(!timed_tracks)
		timed_tracks = list()
	for(var/song_title in song_list)
		if(timed_tracks[song_title])
			continue
		var/datum/bard_timed_track/track = new
		track.set_song(song_title, song_list[song_title])
		timed_tracks[song_title] = track
	if(!music_panel_selected && song_list.len)
		for(var/song_title in song_list)
			music_panel_selected = song_title
			break

/obj/item/rogue/instrument/proc/get_selected_track()
	ensure_timed_tracks()
	if(!music_panel_selected || !timed_tracks[music_panel_selected])
		if(song_list.len)
			for(var/song_title in song_list)
				music_panel_selected = song_title
				break
	return timed_tracks[music_panel_selected]

/obj/item/rogue/instrument/proc/music_skill_event(mob/living/user)
	var/stressevent = /datum/stressevent/music
	note_color = "#7f7f7f"
	if(user?.mind)
		switch(user.get_skill_level(/datum/skill/misc/music))
			if(2)
				note_color = "#ffffff"; stressevent = /datum/stressevent/music/two
			if(3)
				note_color = "#1eff00"; stressevent = /datum/stressevent/music/three
			if(4)
				note_color = "#0070dd"; stressevent = /datum/stressevent/music/four
			if(5)
				note_color = "#a335ee"; stressevent = /datum/stressevent/music/five
			if(6)
				note_color = "#ff8000"; stressevent = /datum/stressevent/music/six
	soundloop.stress2give = stressevent
	return stressevent

/obj/item/rogue/instrument/proc/stop_music(mob/living/user)
	music_stop_token++
	playing = FALSE
	groupplaying = FALSE
	if(soundloop)
		soundloop.stop()
	var/mob/living/player = user || current_player
	if(player)
		player.bard_music_playing = FALSE
		player.bard_auto_singing = FALSE
		player.bard_auto_song_token++
		player.remove_status_effect(/datum/status_effect/buff/playing_music)
	current_player = null
	current_track = null
	current_track_title = null
	music_started_at = 0
	music_realtime_started_at = 0
	music_playback_id++
	auto_singing_title = null
	auto_song_track = null
	auto_song_next_phrase_index = 1
	auto_song_cycle_started_at = 0
	SSbard_music.unregister(src)

/obj/item/rogue/instrument/proc/song_duration_loop(mob/living/user, token)
	set waitfor = FALSE
	if(!user || !current_player || token != music_stop_token)
		return
	var/datum/bard_timed_track/track = current_track || get_selected_track()
	var/duration_ticks = max(round((track?.duration_seconds || BARD_TRACK_DEFAULT_DURATION_SECONDS) * 10), 1)
	sleep(duration_ticks)
	if(QDELETED(src) || QDELETED(user) || token != music_stop_token || !playing || current_player != user)
		return
	if(repeat_enabled)
		music_started_at = world.time
		music_playback_id++
		SStgui.update_uis(src)
		INVOKE_ASYNC(src, PROC_REF(song_duration_loop), user, token)
	else
		stop_music(user)
		SStgui.update_uis(src)

/obj/item/rogue/instrument/proc/play_track(mob/living/user, datum/bard_timed_track/track)
	if(!user || !track || playing || !(src in user.held_items) || user.get_inactive_held_item())
		return
	var/stressevent = music_skill_event(user)
	curfile = track.file_path
	if(!curfile)
		stop_music(user)
		return
	playing = TRUE
	soundloop.set_mid_sounds(list(curfile))
	soundloop.mid_length = max(track.duration_seconds * 10, 1)
	soundloop.start()
	user.apply_status_effect(/datum/status_effect/buff/playing_music, stressevent, note_color)
	user.bard_music_playing = TRUE
	current_player = user
	current_track = track
	current_track_title = track.title
	music_started_at = world.time
	music_realtime_started_at = REALTIMEOFDAY
	music_playback_id++
	music_stop_token++
	INVOKE_ASYNC(src, PROC_REF(song_duration_loop), user, music_stop_token)
	if(auto_song_enabled)
		start_auto_song(user, track)
	record_round_statistic(STATS_SONGS_PLAYED)

/obj/item/rogue/instrument/proc/start_auto_song(mob/living/user, datum/bard_timed_track/track)
	if(!track || !track.custom)
		return
	if(!playing || current_player != user || current_track != track)
		return
	if(!track.phrases.len)
		return
	var/elapsed_seconds = max((REALTIMEOFDAY - music_realtime_started_at) / 10, 0)
	if(track.duration_seconds > 0 && repeat_enabled)
		elapsed_seconds = elapsed_seconds % track.duration_seconds
	else if(track.duration_seconds > 0 && elapsed_seconds >= track.duration_seconds)
		return
	user.bard_auto_singing = TRUE
	user.bard_auto_song_token++
	auto_singing_title = track.title
	auto_song_track = track
	auto_song_cycle_started_at = music_realtime_started_at
	auto_song_next_phrase_index = get_auto_song_phrase_index(track, elapsed_seconds)
	SSbard_music.register(src)

/obj/item/rogue/instrument/proc/stop_auto_song(mob/living/user)
	if(user)
		user.bard_auto_singing = FALSE
		user.bard_auto_song_token++
	auto_singing_title = null
	auto_song_track = null
	auto_song_next_phrase_index = 1
	auto_song_cycle_started_at = 0
	SSbard_music.unregister(src)

/obj/item/rogue/instrument/proc/start_band_invite(mob/living/user)
	if(!user || band_invite_active)
		return
	band_invite_active = TRUE
	band_invite_until = world.time + 30 SECONDS
	band_invite_leader = user
	band_members = list()
	for(var/mob/living/carbon/human/candidate in view(7, user))
		if(candidate == user)
			continue
		var/obj/item/held = candidate.get_active_held_item()
		if(istype(held, /obj/item/rogue/instrument))
			INVOKE_ASYNC(src, PROC_REF(prompt_band_member), candidate, held)
	addtimer(CALLBACK(src, PROC_REF(finish_band_invite)), 30 SECONDS)
	to_chat(user, span_notice("Band invite started. Waiting 30 seconds for performers."))

/obj/item/rogue/instrument/proc/prompt_band_member(mob/living/candidate, obj/item/rogue/instrument/candidate_instrument)
	if(!band_invite_active || !candidate || !candidate_instrument)
		return
	if(alert(candidate, "[band_invite_leader] invites you to perform in a band.", "Band Play", "Accept", "Decline") != "Accept" || !band_invite_active)
		return
	candidate_instrument.ensure_timed_tracks()
	var/choice = input(candidate, "Which track will you perform?", "Band Track") as null|anything in candidate_instrument.song_list
	if(!choice || !band_invite_active)
		return
	var/datum/bard_timed_track/track = candidate_instrument.timed_tracks[choice]
	var/sing = FALSE
	if(track?.custom && track.phrases.len)
		sing = alert(candidate, "Use timed singing for this track?", "Band Mode", "Sing", "Mute") == "Sing"
	var/datum/bard_band_member/member = new
	member.player = candidate
	member.instrument = candidate_instrument
	member.track_title = choice
	member.sing = sing
	band_members += member
	to_chat(candidate, span_notice("You are ready for [band_invite_leader]'s band."))
	if(band_invite_leader)
		to_chat(band_invite_leader, span_notice("[candidate] is ready with [candidate_instrument.name]: [choice] ([sing ? "Sing" : "Mute"])."))
	SStgui.update_uis(src)

/obj/item/rogue/instrument/proc/finish_band_invite()
	if(!band_invite_active)
		return
	if(band_invite_leader)
		to_chat(band_invite_leader, span_notice("Band invite finished. Ready performers: [band_members.len]. Start or cancel from the music panel."))
	SStgui.update_uis(src)

/obj/item/rogue/instrument/proc/cancel_band_invite()
	band_invite_active = FALSE
	band_invite_until = 0
	band_invite_leader = null
	band_members = list()
	SStgui.update_uis(src)

/obj/item/rogue/instrument/proc/start_synced_band(mob/living/user)
	if(!band_invite_active || user != band_invite_leader)
		return
	var/datum/bard_timed_track/leader_track = get_selected_track()
	var/leader_sings = auto_song_enabled
	stop_music(user)
	auto_song_enabled = leader_sings
	play_track(user, leader_track)
	if(leader_sings)
		start_auto_song(user, leader_track)
	for(var/datum/bard_band_member/member as anything in band_members)
		if(!member.player || !member.instrument || QDELETED(member.instrument))
			continue
		member.instrument.ensure_timed_tracks()
		var/datum/bard_timed_track/member_track = member.instrument.timed_tracks[member.track_title]
		if(!member_track)
			continue
		member.instrument.stop_music(member.player)
		member.instrument.music_panel_selected = member.track_title
		member.instrument.auto_song_enabled = member.sing
		member.instrument.play_track(member.player, member_track)
		if(member.sing)
			member.instrument.start_auto_song(member.player, member_track)
	cancel_band_invite()

/obj/item/rogue/instrument/proc/get_auto_song_phrase_index(datum/bard_timed_track/track, elapsed_seconds)
	if(!track?.phrases?.len)
		return 1
	for(var/i in 1 to track.phrases.len)
		var/datum/bard_timed_phrase/phrase = track.phrases[i]
		if(phrase.time >= elapsed_seconds)
			return i
	return track.phrases.len + 1

/obj/item/rogue/instrument/proc/process_auto_song()
	var/mob/living/user = current_player
	var/datum/bard_timed_track/track = auto_song_track
	if(QDELETED(src) || QDELETED(user) || QDELETED(track) || !playing || current_track != track || current_player != user || !user.bard_auto_singing || !track.phrases.len)
		stop_auto_song(user)
		return FALSE
	if(auto_song_cycle_started_at != music_realtime_started_at)
		auto_song_cycle_started_at = music_realtime_started_at
		auto_song_next_phrase_index = 1
	var/elapsed_ticks = REALTIMEOFDAY - music_realtime_started_at
	var/duration_ticks = round(track.duration_seconds * 10)
	if(duration_ticks > 0 && elapsed_ticks >= duration_ticks)
		if(!repeat_enabled)
			stop_auto_song(user)
			return FALSE
		var/cycles_passed = max(floor(elapsed_ticks / duration_ticks), 1)
		music_realtime_started_at += cycles_passed * duration_ticks
		auto_song_cycle_started_at = music_realtime_started_at
		auto_song_next_phrase_index = 1
		elapsed_ticks = REALTIMEOFDAY - music_realtime_started_at
	while(auto_song_next_phrase_index <= track.phrases.len)
		var/datum/bard_timed_phrase/phrase = track.phrases[auto_song_next_phrase_index]
		if(!phrase)
			auto_song_next_phrase_index++
			continue
		if(round(phrase.time * 10) > elapsed_ticks)
			break
		auto_song_next_phrase_index++
		if(phrase.text)
			user.say(phrase.text, forced = "bard auto song")
	if(!repeat_enabled && auto_song_next_phrase_index > track.phrases.len)
		stop_auto_song(user)
		return FALSE
	return TRUE

/obj/item/rogue/instrument/ui_state(mob/user)
	return GLOB.hold_or_view_state

/obj/item/rogue/instrument/ui_interact(mob/user, datum/tgui/ui)
	ensure_timed_tracks()
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "BardMusicLibrary", "Music")
		ui.open()
	ui.set_autoupdate(band_invite_active)

/obj/item/rogue/instrument/ui_data(mob/user)
	ensure_timed_tracks()
	var/datum/bard_timed_track/selected = get_selected_track()
	var/datum/bard_timed_track/playing_track = current_track || selected
	var/list/tracks = list()
	for(var/song_title in song_list)
		var/datum/bard_timed_track/track = timed_tracks[song_title]
		tracks += list(list(
			"title" = song_title,
			"selected" = (song_title == music_panel_selected),
			"duration_seconds" = track?.duration_seconds || 0,
			"duration_label" = bard_track_format_duration(track?.duration_seconds || 0),
			"phrase_count" = track?.phrases?.len || 0,
			"custom" = track?.custom || FALSE,
			"analyzed_duration" = track?.analyzed_duration || FALSE
		))
	var/list/selected_data = null
	if(selected)
		var/list/phrase_data = list()
		for(var/datum/bard_timed_phrase/phrase as anything in selected.phrases)
			phrase_data += list(list("time" = phrase.time, "text" = phrase.text))
		selected_data = list(
			"title" = selected.title,
			"custom" = selected.custom,
			"duration_seconds" = selected.duration_seconds,
			"duration_label" = bard_track_format_duration(selected.duration_seconds),
			"analyzed_duration" = selected.analyzed_duration,
			"spacing_seconds" = selected.phrase_spacing_seconds,
			"lyrics" = selected.lyrics,
			"json" = selected.export_json(),
			"phrases" = phrase_data
		)
	var/list/member_data = list()
	for(var/datum/bard_band_member/member as anything in band_members)
		member_data += list(member.export_data())
	return list(
		"tracks" = tracks,
		"selected" = selected_data,
		"is_expert" = user?.mind && user.get_skill_level(/datum/skill/misc/music) >= SKILL_LEVEL_EXPERT,
		"playing" = playing,
		"repeat_enabled" = repeat_enabled,
		"repeat_mode" = repeat_enabled ? "repeat" : "once",
		"elapsed_seconds" = playing ? max(round((REALTIMEOFDAY - music_realtime_started_at) / 10), 0) : 0,
		"progress_ratio" = (playing && playing_track?.duration_seconds) ? min(max(((REALTIMEOFDAY - music_realtime_started_at) / 10) / playing_track.duration_seconds, 0), 1) : 0,
		"playback_id" = music_playback_id,
		"auto_song_enabled" = auto_song_enabled,
		"auto_singing_title" = auto_singing_title,
		"playing_track_title" = current_track_title,
		"playing_duration_seconds" = playing_track?.duration_seconds || 0,
		"playing_duration_label" = bard_track_format_duration(playing_track?.duration_seconds || 0),
		"band_invite_active" = band_invite_active,
		"band_invite_seconds_left" = band_invite_active ? max(round((band_invite_until - world.time) / 10), 0) : 0,
		"band_members" = member_data,
		"is_band_leader" = band_invite_leader == user
	)

/obj/item/rogue/instrument/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!usr || !usr.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
		return FALSE
	var/mob/living/user = usr
	add_fingerprint(user)
	ensure_timed_tracks()
	switch(action)
		if("select")
			var/song_title = params["title"]
			if(song_list[song_title])
				music_panel_selected = song_title
			return TRUE
		if("set_lyrics")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				if(params["spacing"])
					var/spacing = params["spacing"]
					track.phrase_spacing_seconds = clamp(round(bard_track_num(spacing), 0.1), 0.1, 120)
				track.rebuild_from_lyrics(params["lyrics"])
			return TRUE
		if("set_spacing")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				track.set_spacing(params["spacing"])
			return TRUE
		if("set_phrase_time")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				track.set_phrase_time(params["index"], params["time"])
			return TRUE
		if("set_phrase_text")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				track.set_phrase_text(params["index"], params["text"])
			return TRUE
		if("clear_lyrics")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				track.rebuild_from_lyrics("")
			return TRUE
		if("import_json")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom && !track.import_json(params["json"]))
				to_chat(user, span_warning("Invalid track JSON."))
			return TRUE
		if("upload")
			if(!(user.mind && user.get_skill_level(/datum/skill/misc/music) >= SKILL_LEVEL_EXPERT))
				to_chat(user, span_warning("You need expert music skill to add tracks."))
				return TRUE
			if(lastfilechange && world.time < lastfilechange + 3 MINUTES)
				to_chat(user, span_warning("NOT YET!"))
				return TRUE
			playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
			var/infile = input(user, "CHOOSE A NEW SONG", src) as null|file
			if(!infile || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return TRUE
			var/filename = "[infile]"
			var/file_error = check_file(infile, filename, user)
			if(file_error)
				to_chat(user, span_warning(file_error))
				return TRUE
			lastfilechange = world.time
			fcopy(infile, "data/jukeboxuploads/[user.ckey]/[filename]")
			var/song_file = file("data/jukeboxuploads/[user.ckey]/[filename]")
			var/songname = input(user, "Name your song:", "Song Name") as text|null
			if(!songname || !user.canUseTopic(src, BE_CLOSE, FALSE, NO_TK))
				return TRUE
			songname = trimtext(songname)
			if(!songname)
				return TRUE
			song_list[songname] = song_file
			var/datum/bard_timed_track/new_track = new
			new_track.set_song(songname, song_file, TRUE)
			if(params["spacing"])
				var/spacing = params["spacing"]
				new_track.phrase_spacing_seconds = clamp(round(bard_track_num(spacing), 0.1), 0.1, 120)
			new_track.rebuild_from_lyrics(params["lyrics"])
			timed_tracks[songname] = new_track
			music_panel_selected = songname
			return TRUE
		if("play")
			if(playing)
				stop_music(user)
			else
				var/datum/bard_timed_track/track = get_selected_track()
				var/play_mode = alert(user, "How do you want to perform [track?.title]?", "Play Music", "Solo", "Group", "Cancel")
				if(play_mode == "Solo")
					play_track(user, track)
				else if(play_mode == "Group")
					start_band_invite(user)
			return TRUE
		if("toggle_repeat")
			repeat_enabled = !repeat_enabled
			return TRUE
		if("set_repeat_mode")
			repeat_enabled = params["mode"] == "repeat"
			return TRUE
		if("sing_track")
			var/song_title = params["title"]
			if(song_list[song_title])
				music_panel_selected = song_title
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				auto_song_enabled = !auto_song_enabled
				if(!auto_song_enabled)
					stop_auto_song(user)
					return TRUE
				if(playing && current_track == track)
					start_auto_song(user, track)
			return TRUE
		if("toggle_sing")
			var/datum/bard_timed_track/track = get_selected_track()
			if(track?.custom)
				auto_song_enabled = !auto_song_enabled
				if(!auto_song_enabled)
					stop_auto_song(user)
					return TRUE
				if(playing && current_track == track)
					start_auto_song(user, track)
			return TRUE
		if("cancel_band")
			if(user == band_invite_leader)
				cancel_band_invite()
			return TRUE
		if("start_band")
			start_synced_band(user)
			return TRUE
	return FALSE
