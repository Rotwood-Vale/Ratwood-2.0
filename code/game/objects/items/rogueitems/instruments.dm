/datum/looping_sound/instrument
	mid_length = 120000 // 20 minutes. Previously 4 minutes for no reason. Songs are restricted to 6 megs. If you have twenty minutes of mono low bitrate or one minute of studio quality orchestra, it makes no difference to the server.
	volume = 100
	extra_range = 10	// Increase sound range.
	persistent_loop = TRUE
	var/stress2give = /datum/stressevent/music
	sound_group = null

GLOBAL_LIST_EMPTY(instrument_band_lobbies)

/proc/instrument_band_member_id(mob/living/user)
	if(!user)
		return null
	if(user.mind)
		return "[REF(user.mind)]"
	return "[REF(user)]"

/datum/instrument_band_slot
	var/member_id
	var/member_name
	var/instrument_type
	var/instrument_name
	var/song_file
	var/datum/weakref/instrument_ref
	var/datum/weakref/mob_ref

/datum/instrument_band_lobby
	var/owner_id
	var/owner_name
	var/datum/weakref/owner_ref
	var/list/member_slots = list() // key: instrument instance ref text

/datum/instrument_band_lobby/proc/register_owner(mob/living/user, obj/item/rogue/instrument/instrument, song_file)
	owner_id = instrument_band_member_id(user)
	owner_name = user.real_name
	owner_ref = WEAKREF(user)
	// Registering a new band is a clean slate — wipe ALL previous member slots
	// so instruments from prior sessions don't silently carry over.
	member_slots = list()
	add_or_replace_member(user, instrument, song_file)

/datum/instrument_band_lobby/proc/add_or_replace_member(mob/living/user, obj/item/rogue/instrument/instrument, song_file)
	var/member_id = instrument_band_member_id(user)
	if(!member_id || !instrument || !song_file)
		return FALSE
	var/slot_key = "[REF(instrument)]"
	var/datum/instrument_band_slot/slot = member_slots[slot_key]
	if(!slot)
		slot = new
		member_slots[slot_key] = slot
	var/old_member = slot.member_name
	slot.member_id = member_id
	slot.member_name = user.real_name
	slot.instrument_type = slot_key
	slot.instrument_name = instrument.name
	slot.song_file = song_file
	slot.instrument_ref = WEAKREF(instrument)
	slot.mob_ref = WEAKREF(user)

	if(owner_id && owner_id != member_id)
		var/mob/living/owner_mob = owner_ref?.resolve()
		if(owner_mob)
			if(old_member && old_member != user.real_name)
				to_chat(owner_mob, span_notice("[user.real_name] replaced [old_member] on [instrument.name] in your band lobby."))
			else
				to_chat(owner_mob, span_notice("[user.real_name] joined your band lobby with [instrument.name]."))
	return TRUE

/datum/instrument_band_lobby/proc/remove_member_by_id(member_id)
	for(var/slot_key in member_slots.Copy())
		var/datum/instrument_band_slot/slot = member_slots[slot_key]
		if(slot?.member_id == member_id)
			member_slots -= slot_key

/datum/instrument_band_lobby/proc/remove_member_by_instrument(obj/item/rogue/instrument/instrument)
	if(!instrument)
		return
	var/slot_key = "[REF(instrument)]"
	if(member_slots[slot_key])
		member_slots -= slot_key

/datum/instrument_band_lobby/proc/get_active_slots()
	var/list/active_slots = list()
	for(var/slot_key in member_slots.Copy())
		var/datum/instrument_band_slot/slot = member_slots[slot_key]
		if(!slot)
			member_slots -= slot_key
			continue
		var/obj/item/rogue/instrument/instrument = slot.instrument_ref?.resolve()
		if(!instrument || QDELETED(instrument))
			member_slots -= slot_key
			continue
		active_slots += slot
	return active_slots

/datum/instrument_band_lobby/proc/get_title()
	if(owner_name)
		return "[owner_name]'s Band"
	return "Unnamed Band"

/datum/instrument_band_lobby/proc/is_within_range(atom/reference, range = 10)
	if(!reference)
		return FALSE
	var/turf/reference_turf = get_turf(reference)
	if(!reference_turf)
		return FALSE
	for(var/datum/instrument_band_slot/slot in get_active_slots())
		var/obj/item/rogue/instrument/instrument = slot.instrument_ref?.resolve()
		if(!instrument)
			continue
		var/turf/check_turf = get_turf(instrument)
		// Organs are moved to nullspace on Insert(), so get_turf() returns null.
		// Fall back to the registered mob's turf in that case.
		if(!check_turf)
			var/mob/living/slot_mob = slot.mob_ref?.resolve()
			check_turf = get_turf(slot_mob)
		if(!check_turf)
			continue
		if(get_dist(reference_turf, check_turf) <= range)
			return TRUE
	return FALSE

/datum/instrument_band_lobby/proc/stop_all_playing_members()
	for(var/datum/instrument_band_slot/slot in get_active_slots())
		var/obj/item/rogue/instrument/instrument = slot.instrument_ref?.resolve()
		if(!instrument)
			continue
		if(!instrument.playing && !instrument.groupplaying)
			continue
		var/atom/stop_source = instrument
		if(isliving(instrument.loc))
			stop_source = instrument.loc
		else if(instrument.not_held)
			// not_held organs are in nullspace; resolve the mob from the stored weakref.
			var/mob/living/slot_mob = slot.mob_ref?.resolve()
			if(slot_mob)
				stop_source = slot_mob
		instrument.playing = FALSE
		instrument.groupplaying = FALSE
		instrument.soundloop.stop(stop_source)
		if(isliving(stop_source))
			var/mob/living/holder = stop_source
			holder.remove_status_effect(/datum/status_effect/buff/playing_music)
			if(instrument.not_held)
				holder.remove_status_effect(/datum/status_effect/buff/harpy_sing)

/datum/looping_sound/instrument/New(_parent, start_immediately=FALSE, _direct=FALSE, _channel = 0)
	. = ..(_parent, FALSE, _direct, _channel)
	// Instruments can be widespread on the map. Reserve channels only while actively playing.
	if(channel)
		SSsounds.free_datum_channels(src)
		channel = null
	if(start_immediately)
		start()

/datum/looping_sound/instrument/start(atom/on_behalf_of, sync_anchor)
	if(sync_anchor)
		starttime = sync_anchor
	if(!channel)
		channel = SSsounds.reserve_sound_channel(src)
		if(!channel)
			var/atom/resolved_parent = parent?.resolve()
			log_game("INSTRUMENT: Failed to reserve sound channel for [resolved_parent] - channels may be exhausted (reserve_high=[SSsounds.channel_reserve_high], random_min=[SSsounds.random_channels_min])")
			return FALSE
	..()
	return TRUE

// Thingshearing was previously cleared BEFORE calling ..() which meant
// the parent stop() had nothing to iterate over and silently did nothing.
// We now let the parent run first, THEN clear thingshearing, and THEN free
// the channel. The manual GLOB.clients loop handles clients whose played_loops
// entry may have been missed by the parent.
/datum/looping_sound/instrument/stop(null_parent)
	if(channel)
		. = ..(null_parent)  // Parent runs first with thingshearing intact.
		for(var/client/C in GLOB.clients)
			if(!(src in C.played_loops))
				continue
			var/list/L = C.played_loops[src]
			var/sound/SD = L?["SOUND"]
			var/stop_channel = SD?.channel || channel
			if(C.mob)
				C.mob.stop_sound_channel(stop_channel)
			else
				SEND_SOUND(C, sound(null, repeat = 0, wait = 0, channel = stop_channel))
			C.played_loops -= src
		thingshearing = list()  // Clear AFTER parent and client loop are done.
		SSsounds.free_datum_channels(src)
		channel = null
	else
		. = ..(null_parent)

/obj/item/rogue/instrument
	name = ""
	desc = ""
	icon = 'icons/roguetown/items/music.dmi'
	icon_state = ""
	slot_flags = ITEM_SLOT_HIP|ITEM_SLOT_BACK_R|ITEM_SLOT_BACK_L
	can_parry = TRUE
	force = 23
	throwforce = 7
	throw_range = 4
	var/lastfilechange = 0
	var/curvol = 100
	var/datum/looping_sound/instrument/soundloop
	var/list/song_list = list()
	var/note_color = "#7f7f7f"
	var/groupplaying = FALSE
	var/curfile = ""
	var/playing = FALSE
	grid_height = 64
	grid_width = 32

	/// Instrument is in some other holder such as an organ or item.
	var/not_held = FALSE
	/// When TRUE, songs will loop (repeat) when they end. Off by default.
	var/loop_enabled = FALSE

// Added null-guard on soundloop. During Initialize() the parent chain
// may trigger equipped() before soundloop is assigned.
/obj/item/rogue/instrument/equipped(mob/living/user, slot)
	. = ..()
	if(playing && !(src in user.held_items) && !not_held)
		playing = FALSE
		groupplaying = FALSE
		if(soundloop)
			soundloop.stop()
		user.remove_status_effect(/datum/status_effect/buff/playing_music)
		_remove_self_from_lobbies()

/obj/item/rogue/instrument/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.4,"sx" = 0,"sy" = 2,"nx" = 1,"ny" = -4,"wx" = -1,"wy" = 2,"ex" = 7,"ey" = 1,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 0,"sturn" = 0,"wturn" = -2,"eturn" = -2,"nflip" = 8,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.3,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogue/instrument/Initialize(mapload)
	soundloop = new(src, FALSE)
	. = ..()

/obj/item/rogue/instrument/Destroy()
	_remove_self_from_lobbies()
	qdel(soundloop)
	. = ..()

/obj/item/rogue/instrument/dropped(mob/living/user, silent)
	..()
	if(user && (src in user.held_items))
		return
	var/was_playing = playing || groupplaying
	groupplaying = FALSE
	playing = FALSE
	if(soundloop && was_playing)
		soundloop.stop()
		if(user)
			user.remove_status_effect(/datum/status_effect/buff/playing_music)
	_remove_self_from_lobbies()

// Helper proc: removes this specific instrument object from every lobby it
// appears in as a member slot. Also prunes empty lobbies from the global list.
// Does NOT destroy lobbies owned by this instrument's player — ownership
// survives the instrument being dropped (the owner can re-register).
/obj/item/rogue/instrument/proc/_remove_self_from_lobbies()
	for(var/lobby_id in GLOB.instrument_band_lobbies.Copy())
		var/datum/instrument_band_lobby/lobby = GLOB.instrument_band_lobbies[lobby_id]
		if(!lobby)
			GLOB.instrument_band_lobbies -= lobby_id
			continue
		lobby.remove_member_by_instrument(src)
		if(!lobby.member_slots.len)
			var/mob/living/owner_mob = lobby.owner_ref?.resolve()
			if(!owner_mob)
				GLOB.instrument_band_lobbies -= lobby_id

/obj/item/rogue/instrument/attack_self(mob/living/user)
	var/stressevent = /datum/stressevent/music
	. = ..()
	if(.)
		return
	user.changeNext_move(CLICK_CD_MELEE)
	if(playing)
		var/member_id = instrument_band_member_id(user)
		var/datum/instrument_band_lobby/owned_lobby = member_id ? GLOB.instrument_band_lobbies[member_id] : null
		if(groupplaying && owned_lobby && owned_lobby.owner_id == member_id)
			owned_lobby.stop_all_playing_members()
			to_chat(user, span_notice("You ended the band performance."))
			return
		playing = FALSE
		groupplaying = FALSE
		soundloop.stop(user)
		user.remove_status_effect(/datum/status_effect/buff/playing_music)
		if(not_held)
			user.remove_status_effect(/datum/status_effect/buff/harpy_sing)
		return
	else
		var/playdecision
		var/loop_state
		var/loop_label
		var/volume_label
		var/loop_notice
		var/volume_selection
		while(TRUE)
			loop_state = "Off"
			if(loop_enabled)
				loop_state = "On"
			loop_label = "Song Loop: [loop_state]"
			volume_label = "Volume: [curvol]"
			playdecision = input(user, "How do you want to play?", "Music") as null|anything in list("Play Song", " ", "Band Lobby", "  ", loop_label, "   ", volume_label)
			if(!playdecision)
				return
			if(playdecision == " " || playdecision == "  " || playdecision == "   ")
				continue
			if(playdecision == loop_label)
				loop_enabled = !loop_enabled
				loop_notice = "disabled"
				if(loop_enabled)
					loop_notice = "enabled"
				to_chat(user, span_notice("Song loop [loop_notice]."))
				continue
			if(playdecision == volume_label)
				volume_selection = input(user, "How loud should this instrument be? (10-100)", "Music Volume", curvol) as num|null
				if(isnull(volume_selection) || !user)
					return
				volume_selection = clamp(round(volume_selection), 10, 100)
				if(volume_selection == curvol)
					to_chat(user, span_notice("Volume is already set to [curvol]."))
				else
					curvol = volume_selection
					to_chat(user, span_notice("Instrument volume set to [curvol]."))
				continue
			break
		groupplaying = (playdecision == "Band Lobby")
		if(!groupplaying)
			var/choice
			while(TRUE)
				var/list/options = song_list.Copy()
				if(user.mind && user.get_skill_level(/datum/skill/misc/music) >= 4)
					options[" "] = " "
					options["Upload New Song"] = "upload"
				choice = input(user, "Which song?", "Music", name) as null|anything in options
				if(!choice || !user)
					return
				if(choice == " ")
					continue
				break
			
			if(playing || !(src in user.held_items) && !(not_held) || user.get_inactive_held_item())
				return
				
			if(choice == "Upload New Song" || choice == "upload")
				if(lastfilechange && world.time < lastfilechange + 3 MINUTES)
					say("NOT YET!")
					return
				playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
				var/infile = input(user, "CHOOSE A NEW SONG", src) as null|file

				if(!infile)
					return
				if(playing || !(src in user.held_items) && !(not_held) || user.get_inactive_held_item())
					return

				var/filename = "[infile]"
				var/file_ext = LOWER_TEXT(copytext(filename, -4))
				var/file_size = length(infile)
				message_admins("[ADMIN_LOOKUPFLW(user)] uploaded a song [filename] of size [file_size / 1000000] (~MB).")
				if(file_ext != ".ogg")
					to_chat(user, span_warning("SONG MUST BE AN OGG."))
					return
				if(file_size > 6485760)
					to_chat(user, span_warning("TOO BIG. 6 MEGS OR LESS."))
					return
				lastfilechange = world.time
				fcopy(infile,"data/jukeboxuploads/[user.ckey]/[filename]")
				curfile = file("data/jukeboxuploads/[user.ckey]/[filename]")
				var/songname = input(user, "Name your song:", "Song Name") as text|null
				if(songname)
					song_list[songname] = curfile
				return
			curfile = song_list[choice]
			if(!user || playing || !(src in user.held_items) && !(not_held))
				return
			note_color = "#7f7f7f"
			if(user.mind)
				switch(user.get_skill_level(/datum/skill/misc/music))
					if(1)
						stressevent = /datum/stressevent/music
					if(2)
						note_color = "#ffffff"
						stressevent = /datum/stressevent/music/two
					if(3)
						note_color = "#1eff00"
						stressevent = /datum/stressevent/music/three
					if(4)
						note_color = "#0070dd"
						stressevent = /datum/stressevent/music/four
					if(5)
						note_color = "#a335ee"
						stressevent = /datum/stressevent/music/five
					if(6)
						note_color = "#ff8000"
						stressevent = /datum/stressevent/music/six
			soundloop.stress2give = stressevent
			if(!(src in user.held_items) && !(not_held))
				return
			if(user.get_inactive_held_item())
				playing = FALSE
				soundloop.stop(user)
				user.remove_status_effect(/datum/status_effect/buff/playing_music)
				return
			if(curfile)
				soundloop.mid_sounds = list(curfile)
				soundloop.cursound = null
				soundloop.volume = clamp(curvol, 10, 100)
				soundloop.repeat_sound = loop_enabled
				if(!soundloop.start(user))
					to_chat(user, span_warning("Could not play - no sound channels available. Try again in a moment."))
					return
				playing = TRUE
				user.apply_status_effect(/datum/status_effect/buff/playing_music, stressevent, note_color)
				if(not_held)
					user.apply_status_effect(/datum/status_effect/buff/harpy_sing)
				record_round_statistic(STATS_SONGS_PLAYED)
			else
				playing = FALSE
				groupplaying = FALSE
				soundloop.stop(user)
				user.remove_status_effect(/datum/status_effect/buff/playing_music)
		if(groupplaying)
			open_band_lobby_menu(user, stressevent, note_color)

/obj/item/rogue/instrument/proc/open_band_lobby_menu(mob/living/user, stressevent, note_color)
	var/choice = input(user, "Band Lobby", "Band Lobby") as null|anything in list("Register My Band", "Search Bands", "Start My Band", "Leave Band")
	if(!choice)
		return

	if(choice == "Register My Band")
		if(src.playing)
			to_chat(user, span_warning("Stop playing first."))
			return
		var/song_choice = input(user, "Pick your song for this band slot", "Band Lobby", name) as null|anything in song_list
		if(!song_choice)
			return
		var/song_file = song_list[song_choice]
		if(!song_file)
			return
		curfile = song_file
		var/member_id = instrument_band_member_id(user)
		if(!member_id)
			return
		var/datum/instrument_band_lobby/lobby = GLOB.instrument_band_lobbies[member_id]
		if(!lobby)
			lobby = new
			GLOB.instrument_band_lobbies[member_id] = lobby
		lobby.register_owner(user, src, song_file)
		groupplaying = TRUE
		to_chat(user, span_notice("Registered [lobby.get_title()] with [name]."))
		return

	if(choice == "Search Bands")
		var/list/search_results = list()
		var/member_id = instrument_band_member_id(user)
		for(var/lobby_id in GLOB.instrument_band_lobbies)
			var/datum/instrument_band_lobby/lobby = GLOB.instrument_band_lobbies[lobby_id]
			if(!lobby)
				continue
			if(!lobby.is_within_range(user, 10))
				continue
			var/list/active_slots = lobby.get_active_slots()
			if(!active_slots.len)
				continue
			var/own_suffix = (lobby.owner_id == member_id) ? " (Your Band)" : ""
			search_results["[lobby.get_title()][own_suffix] ([active_slots.len] members)"] = lobby
		if(!search_results.len)
			to_chat(user, span_warning("No active band lobbies found within 10 tiles."))
			return
		var/picked_lobby_name = input(user, "Choose a band to join", "Band Lobby") as null|anything in search_results
		if(!picked_lobby_name)
			return
		var/datum/instrument_band_lobby/chosen_lobby = search_results[picked_lobby_name]
		if(!chosen_lobby)
			return
		var/join_song_choice = input(user, "Pick your song for this band slot", "Band Lobby", name) as null|anything in song_list
		if(!join_song_choice)
			return
		var/join_song = song_list[join_song_choice]
		if(!join_song)
			return
		curfile = join_song
		chosen_lobby.add_or_replace_member(user, src, join_song)
		groupplaying = TRUE
		to_chat(user, span_notice("Joined [chosen_lobby.get_title()] with [name]."))
		return

	if(choice == "Start My Band")
		var/member_id = instrument_band_member_id(user)
		if(!member_id)
			return
		var/datum/instrument_band_lobby/owned_lobby = GLOB.instrument_band_lobbies[member_id]
		if(!owned_lobby || owned_lobby.owner_id != member_id)
			to_chat(user, span_warning("You do not own a band lobby."))
			return
		if(!curfile)
			var/owner_song_choice = input(user, "Pick your song for this band slot", "Band Lobby", name) as null|anything in song_list
			if(!owner_song_choice)
				return
			curfile = song_list[owner_song_choice]
		if(!curfile)
			return
		owned_lobby.add_or_replace_member(user, src, curfile)

		var/list/slots = owned_lobby.get_active_slots()
		if(!slots.len)
			to_chat(user, span_warning("Nobody is registered in your band lobby."))
			return

		var/list/instruments_to_start = list()
		// FIX: Track bandmates AND their individual stressevent/note_color so
		// each player gets status effects based on their OWN skill level, not
		// the band leader's. Previously all bandmates received the leader's
		// stressevent and note_color regardless of their own skill.
		var/list/bandmate_stressevents = list()  // mob -> stressevent type
		var/list/bandmate_notecolors = list()    // mob -> note_color string
		var/list/instrument_to_bandmate = list() // instrument -> mob (for status effect lookup)

		for(var/datum/instrument_band_slot/slot in slots)
			var/obj/item/rogue/instrument/slot_instrument = slot.instrument_ref?.resolve()
			if(!slot_instrument || slot_instrument.playing || !slot.song_file)
				continue
			var/mob/living/bandmate_mob
			if(slot_instrument.not_held)
				// Organs are in nullspace; resolve the mob from the stored weakref.
				bandmate_mob = slot.mob_ref?.resolve()
				if(!bandmate_mob)
					continue
			else
				if(!isliving(slot_instrument.loc))
					continue
				bandmate_mob = slot_instrument.loc
				if(!(slot_instrument in bandmate_mob.held_items))
					continue
			slot_instrument.curfile = slot.song_file

			var/this_stress = /datum/stressevent/music
			var/this_color = "#7f7f7f"
			if(bandmate_mob.mind)
				switch(bandmate_mob.get_skill_level(/datum/skill/misc/music))
					if(2)
						this_color = "#ffffff"
						this_stress = /datum/stressevent/music/two
					if(3)
						this_color = "#1eff00"
						this_stress = /datum/stressevent/music/three
					if(4)
						this_color = "#0070dd"
						this_stress = /datum/stressevent/music/four
					if(5)
						this_color = "#a335ee"
						this_stress = /datum/stressevent/music/five
					if(6)
						this_color = "#ff8000"
						this_stress = /datum/stressevent/music/six
			slot_instrument.soundloop.stress2give = this_stress
			bandmate_stressevents[bandmate_mob] = this_stress
			bandmate_notecolors[bandmate_mob] = this_color
			instrument_to_bandmate[slot_instrument] = bandmate_mob

			instruments_to_start += slot_instrument

		if(!instruments_to_start.len)
			to_chat(user, span_warning("No ready band members to start."))
			return

		if(!do_after(user, 1))
			return

		var/sync_anchor = world.time

		for(var/obj/item/rogue/instrument/band_instrument in instruments_to_start)
			if(band_instrument.playing || !band_instrument.curfile)
				continue
			var/atom/play_source = band_instrument
			if(isliving(band_instrument.loc))
				play_source = band_instrument.loc
			else if(band_instrument.not_held)
				// not_held organs are in nullspace; use the registered mob as the sound source.
				var/mob/living/band_mob = instrument_to_bandmate[band_instrument]
				if(band_mob)
					play_source = band_mob
			band_instrument.soundloop.mid_sounds = list(band_instrument.curfile)
			band_instrument.soundloop.cursound = null
			band_instrument.soundloop.volume = clamp(band_instrument.curvol, 10, 100)
			band_instrument.soundloop.repeat_sound = band_instrument.loop_enabled
			if(!band_instrument.soundloop.start(play_source, sync_anchor))
				if(isliving(play_source))
					to_chat(play_source, span_warning("Could not play [band_instrument.name] - no sound channels available."))
				continue
			band_instrument.playing = TRUE
			band_instrument.groupplaying = TRUE

		// Apply per-bandmate status effects only for those whose instruments actually started.
		// Use the instrument_to_bandmate mapping to handle both held and not_held instruments correctly.
		for(var/mob/living/bandmate_mob in bandmate_stressevents)
			var/has_playing_instrument = FALSE
			for(var/obj/item/rogue/instrument/started_inst in instruments_to_start)
				if(!started_inst.playing)
					continue
				// Check if this instrument belongs to this bandmate
				if(instrument_to_bandmate[started_inst] == bandmate_mob)
					has_playing_instrument = TRUE
					break
			if(!has_playing_instrument)
				continue
			var/this_stress = bandmate_stressevents[bandmate_mob]
			var/this_color = bandmate_notecolors[bandmate_mob]
			bandmate_mob.apply_status_effect(/datum/status_effect/buff/playing_music, this_stress, this_color)

		to_chat(user, span_notice("Your band has started playing."))
		return

	if(choice == "Leave Band")
		var/member_id = instrument_band_member_id(user)
		if(!member_id)
			return
		for(var/lobby_id in GLOB.instrument_band_lobbies.Copy())
			var/datum/instrument_band_lobby/lobby = GLOB.instrument_band_lobbies[lobby_id]
			if(!lobby)
				GLOB.instrument_band_lobbies -= lobby_id
				continue
			if(lobby.owner_id == member_id)
				GLOB.instrument_band_lobbies -= lobby_id
				continue
			lobby.remove_member_by_id(member_id)
			if(!lobby.member_slots.len)
				GLOB.instrument_band_lobbies -= lobby_id
		if(isliving(user))
			for(var/obj/item/rogue/instrument/held_instrument in user.held_items)
				held_instrument.groupplaying = FALSE
		groupplaying = FALSE
		to_chat(user, span_notice("Left all band lobbies."))

/obj/item/rogue/instrument/accord //made all the instruments in alphabetical order bcuz why not?
	name = "accordion"
	desc = "A harmonious vessel of nostalgia and celebration."
	icon_state = "accordion"
	song_list = list("Her Healing Tears" = 'sound/music/instruments/accord (1).ogg',
	"Peddler's Tale" = 'sound/music/instruments/accord (2).ogg',
	"We Toil Together" = 'sound/music/instruments/accord (3).ogg',
	"Just One More, Tavern Wench" = 'sound/music/instruments/accord (4).ogg',
	"Moonlight Carnival" = 'sound/music/instruments/accord (5).ogg',
	"'Ye Best Be Goin'" = 'sound/music/instruments/accord (6).ogg',
	"Beloved Blue" = 'sound/music/instruments/accord (7).ogg')

/obj/item/rogue/instrument/drum
	name = "drum"
	desc = "Fashioned from taut skins across a sturdy frame, pulses like a giant heartbeat."
	icon_state = "drum"
	song_list = list("Barbarian's Moot" = 'sound/music/instruments/drum (1).ogg',
	"Muster the Wardens" = 'sound/music/instruments/drum (2).ogg',
	"The Earth That Quakes" = 'sound/music/instruments/drum (3).ogg',
	"The Power" = 'sound/music/instruments/drum (4).ogg', //BG3 Song
	"Bard Dance" = 'sound/music/instruments/drum (5).ogg', // BG3 Song
	"Old Time Battles" = 'sound/music/instruments/drum (6).ogg') // BG3 Song

/obj/item/rogue/instrument/flute
	name = "flute"
	desc = "A row of slender hollow tubes of varying lengths that produce a light airy sound when blown across."
	icon_state = "flute"
	song_list = list("Half-Dragon's Ten Mammon" = 'sound/music/instruments/flute (1).ogg',
	"'The Local Favorite'" = 'sound/music/instruments/flute (2).ogg',
	"Rous in the Cellar" = 'sound/music/instruments/flute (3).ogg',
	"Her Boots, So Incandescent" = 'sound/music/instruments/flute (4).ogg',
	"Moondust Minx" = 'sound/music/instruments/flute (5).ogg',
	"Quest to the Ends" = 'sound/music/instruments/flute (6).ogg',
	"Spit Shine" = 'sound/music/instruments/flute (7).ogg',
	"The Power" = 'modular_azurepeak/sound/music/instruments/flute (8).ogg', //Baldur's Gate 3 Song
	"Bard Dance" = 'modular_azurepeak/sound/music/instruments/flute (9).ogg', //Baldur's Gate 3 Song
	"Old Time Battles" = 'modular_azurepeak/sound/music/instruments/flute (10).ogg') //Baldur's Gate 3 Song

/obj/item/rogue/instrument/guitar
	name = "guitar"
	desc = "This is a guitar, chosen instrument of wanderers and the heartbroken." // YIPPEE I LOVE GUITAR
	icon_state = "guitar"
	song_list = list("Fire-Cast Shadows" = 'sound/music/instruments/guitar (1).ogg',
	"The Forced Hand" = 'sound/music/instruments/guitar (2).ogg',
	"Regrets Unpaid" = 'sound/music/instruments/guitar (3).ogg',
	"'Took the Mammon and Ran'" = 'sound/music/instruments/guitar (4).ogg',
	"Poor Man's Tithe" = 'sound/music/instruments/guitar (5).ogg',
	"In His Arms Ye'll Find Me" = 'sound/music/instruments/guitar (6).ogg',
	"El Odio" = 'sound/music/instruments/guitar (7).ogg',
	"Danza De Las Lanzas" = 'sound/music/instruments/guitar (8).ogg',
	"The Feline, Forever Returning" = 'sound/music/instruments/guitar (9).ogg',
	"El Beso Carmesí" = 'sound/music/instruments/guitar (10).ogg',
	"The Queen's High Seas" = 'sound/music/instruments/guitar (11).ogg',
	"Harsh Testimony" = 'sound/music/instruments/guitar (12).ogg',
	"Someone Fair" = 'sound/music/instruments/guitar (13).ogg',
	"Daisies in Bloom" = 'sound/music/instruments/guitar (14).ogg')

/obj/item/rogue/instrument/harp
	name = "harp"
	desc = "A harp of elven craftsmanship."
	icon_state = "harp"
	song_list = list("Through Thine Window, He Glanced" = 'sound/music/instruments/harb (1).ogg',
	"The Lady of Red Silks" = 'sound/music/instruments/harb (2).ogg',
	"Eora Doth Watches" = 'sound/music/instruments/harb (3).ogg',
	"On the Breeze" = 'sound/music/instruments/harb (4).ogg',
	"Never Enough" = 'sound/music/instruments/harb (5).ogg',
	"Sundered Heart" = 'sound/music/instruments/harb (6).ogg',
	"Corridors of Time" = 'sound/music/instruments/harb (7).ogg',
	"Determination" = 'sound/music/instruments/harb (8).ogg')

/obj/item/rogue/instrument/hurdygurdy
	name = "hurdy-gurdy"
	desc = "A knob-driven, wooden string instrument that reminds you of the oceans far."
	icon_state = "hurdygurdy"
	song_list = list("Ruler's One Ring" = 'sound/music/instruments/hurdy (1).ogg',
	"Tangled Trod" = 'sound/music/instruments/hurdy (2).ogg',
	"Motus" = 'sound/music/instruments/hurdy (3).ogg',
	"Becalmed" = 'sound/music/instruments/hurdy (4).ogg',
	"The Bloody Throne" = 'sound/music/instruments/hurdy (5).ogg',
	"We Shall Sail Together" = 'sound/music/instruments/hurdy (6).ogg')

/obj/item/rogue/instrument/lute
	name = "lute"
	desc = "Its graceful curves were designed to weave joyful melodies."
	icon_state = "lute"
	song_list = list("A Knight's Return" = 'sound/music/instruments/lute (1).ogg',
	"Amongst Fare Friends" = 'sound/music/instruments/lute (2).ogg',
	"The Road Traveled by Few" = 'sound/music/instruments/lute (3).ogg',
	"Tip Thine Tankard" = 'sound/music/instruments/lute (4).ogg',
	"A Reed On the Wind" = 'sound/music/instruments/lute (5).ogg',
	"Jests On Steel Ears" = 'sound/music/instruments/lute (6).ogg',
	"Merchant in the Mire" = 'sound/music/instruments/lute (7).ogg',
	"The Power" = 'modular_azurepeak/sound/music/instruments/lute (8).ogg', //Baldur's Gate 3 Song
	"Bard Dance" = 'modular_azurepeak/sound/music/instruments/lute (9).ogg', //Baldur's Gate 3 Song
	"Old Time Battles" = 'modular_azurepeak/sound/music/instruments/lute (10).ogg') //Baldur's Gate 3 Song

/obj/item/rogue/instrument/psyaltery
	name = "psyaltery"
	desc = "A traditional form of boxed zither or box-harp that may be played plucked, with a plectrum or with hammers. They are particularly associated with divine beings, aasimars and liturgies."
	icon_state = "psyaltery"
	song_list = list(
	"Disciples Tower" = 'sound/music/instruments/psyaltery (1).ogg',
	"Green Sleeves" = 'sound/music/instruments/psyaltery (2).ogg',
	"Midyear Melancholy" = 'sound/music/instruments/psyaltery (3).ogg',
	"Santa Psydonia" = 'sound/music/instruments/psyaltery (4).ogg',
	"Le Venardine" = 'sound/music/instruments/psyaltery (5).ogg',
	"Azurea Fair" = 'sound/music/instruments/psyaltery (6).ogg',
	"Amoroso" = 'sound/music/instruments/psyaltery (7).ogg',
	"Lupian's Lullaby" = 'sound/music/instruments/psyaltery (8).ogg',
	"White Wine Before Breakfast" = 'sound/music/instruments/psyaltery (9).ogg',
	"Chevalier de Naledi" = 'sound/music/instruments/psyaltery (10).ogg')

/obj/item/rogue/instrument/shamisen
	name = "shamisen"
	desc = "The shamisen, or simply «three strings», is an kazengunese stringed instrument with a washer, which is usually played with the help of a bachi."
	icon_state = "shamisen"
	lefthand_file = 'icons/mob/inhands/items_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/items_righthand.dmi'
	song_list = list(
	"Cursed Apple" = 'sound/music/instruments/shamisen (1).ogg',
	"Fire Dance" = 'sound/music/instruments/shamisen (2).ogg',
	"Lute" = 'sound/music/instruments/shamisen (3).ogg',
	"Tsugaru Ripple" = 'sound/music/instruments/shamisen (4).ogg',
	"Tsugaru" = 'sound/music/instruments/shamisen (5).ogg',
	"Season" = 'sound/music/instruments/shamisen (6).ogg',
	"Parade" = 'sound/music/instruments/shamisen (7).ogg',
	"Koshiro" = 'sound/music/instruments/shamisen (8).ogg')

/obj/item/rogue/instrument/vocals/harpy_vocals
	name = "harpy's song"
	desc = "The blessed essence of harpysong. How did you get this... you monster!"
	icon = 'icons/obj/surgery.dmi'
	icon_state = "harpysong"		//Pulsating heart energy thing.
	not_held = TRUE

/obj/item/rogue/instrument/trumpet
	name = "trumpet"
	desc = "A long brass tube twisted around with a flared end. It has a few valves to press on the top."
	icon_state = "trumpet"
	song_list = list("Royal Entrance" = 'sound/music/instruments/trumpet (1).ogg',
	"Royal Exit" = 'sound/music/instruments/trumpet (2).ogg',
	"Royal News" = 'sound/music/instruments/trumpet (3).ogg',
	"Royal Fanfare" = 'sound/music/instruments/trumpet (4).ogg',
	"Royal Fanfare 2" = 'sound/music/instruments/trumpet (5).ogg',
	"Royal Wedding" = 'sound/music/instruments/trumpet (6).ogg', //It has a little bit of organ in the background that I couldn't completely remove
	"Honoring the Fallen" = 'sound/music/instruments/trumpet (7).ogg')

/obj/item/rogue/instrument/bagpipe
	name = "bagpipe"
	desc = "A commonly used woodwind instrument using enclosed reeds fed from a constant reservoir of air in the form of a bag."
	grid_width = 64
	grid_height = 32
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "bagpipe"
	song_list = list("Dainty Man" = 'sound/music/instruments/bagpipe (1).ogg',
	"Harpy in the Morning" = 'sound/music/instruments/bagpipe (2).ogg',
	"Heartfelt Forever" = 'sound/music/instruments/bagpipe (3).ogg',
	"Homeward Jig" = 'sound/music/instruments/bagpipe (4).ogg',
	"On the Sea Shore" = 'sound/music/instruments/bagpipe (5).ogg',
	"Soldier's Rest" = 'sound/music/instruments/bagpipe (6).ogg',
	"Otavan Madame" = 'sound/music/instruments/bagpipe (7).ogg')

/obj/item/rogue/instrument/banjo
	name = "banjo"
	desc = "A stringed instrument with a thin membrane stretched over a circular-bodied frame, typically played by plucking or strumming. It has a certain twangy sound commonly heard in folk music."
	grid_width = 64
	grid_height = 32
	w_class = WEIGHT_CLASS_NORMAL
	icon_state = "banjo"
	song_list = list("Bog Man's Jig" = 'sound/music/instruments/banjo (1).ogg',
	"Pockets Full o' Mammon" = 'sound/music/instruments/banjo (2).ogg',
	"Kickin' the Muck Off" = 'sound/music/instruments/banjo (3).ogg',
	"Soggy Shoes n' Bilgewater Boots" = 'sound/music/instruments/banjo (4).ogg',
	"Nothin' but Fog" = 'sound/music/instruments/banjo (5).ogg',
	"The Tipsy Toad" = 'sound/music/instruments/banjo (6).ogg',
	"Tangled in th' Reeds" = 'sound/music/instruments/banjo (7).ogg')

/obj/item/rogue/instrument/harmonica
	name = "harmonica"
	desc = "A small, rectangular wind instrument played by blowing air through reeds."
	grid_width = 32
	grid_height = 32
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "harmonica"
	song_list = list("Deep in the Peat" = 'sound/music/instruments/harmonica (1).ogg',
	"Militia Man's Woes" = 'sound/music/instruments/harmonica (2).ogg',
	"My Chilly Bones" = 'sound/music/instruments/harmonica (3).ogg',
	"Lonesome by the Campfire" = 'sound/music/instruments/harmonica (4).ogg',
	"Herding in the Heat" = 'sound/music/instruments/harmonica (5).ogg',
	"Soaked to the Bone" = 'sound/music/instruments/harmonica (6).ogg',
	"To Our Friends Felled" = 'sound/music/instruments/harmonica (7).ogg')

/obj/item/rogue/instrument/jawharp
	name = "jaw harp"
	desc = "A vibrating reed attached to a sturdy frame, originally crafted in the Gronn Steppes. It produces a buzzing sound that mimics the winds of the plains."
	dropshrink = 0.6
	grid_width = 32
	grid_height = 32
	w_class = WEIGHT_CLASS_SMALL
	icon_state = "jawharp"
	song_list = list("Fly Away" = 'sound/music/instruments/jawharp (1).ogg',
	"Nomad's Call" = 'sound/music/instruments/jawharp (2).ogg',
	"Spirit of the Steppes" = 'sound/music/instruments/jawharp (3).ogg',
	"The Mountain of Wisdom" = 'sound/music/instruments/jawharp (4).ogg',
	"Who Told You" = 'sound/music/instruments/jawharp (5).ogg')
/obj/item/rogue/instrument/jawharp/getonmobprop(tag)
	. = ..()
	if(tag)
		switch(tag)
			if("gen")
				return list("shrink" = 0.2,"sx" = -7,"sy" = -4,"nx" = 7,"ny" = -4,"wx" = -3,"wy" = -4,"ex" = 1,"ey" = -4,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0,"nturn" = 110,"sturn" = -110,"wturn" = -110,"eturn" = 110,"nflip" = 0,"sflip" = 8,"wflip" = 8,"eflip" = 0)
			if("onbelt")
				return list("shrink" = 0.1,"sx" = -2,"sy" = -5,"nx" = 4,"ny" = -5,"wx" = 0,"wy" = -5,"ex" = 2,"ey" = -5,"nturn" = 0,"sturn" = 0,"wturn" = 0,"eturn" = 0,"nflip" = 0,"sflip" = 0,"wflip" = 0,"eflip" = 0,"northabove" = 0,"southabove" = 1,"eastabove" = 1,"westabove" = 0)

/obj/item/rogue/instrument/viola
	name = "viola"
	desc = "The prim and proper Viola, every prince's first instrument taught."
	icon_state = "viola"
	song_list = list("Far Flung Tale" = 'sound/music/instruments/viola (1).ogg',
	"G Major Cello Suite No. 1" = 'sound/music/instruments/viola (2).ogg',
	"Ursine's Home" = 'sound/music/instruments/viola (3).ogg',
	"Mead, Gold and Blood" = 'sound/music/instruments/viola (4).ogg',
	"Gasgow's Reel" = 'sound/music/instruments/viola (5).ogg',
	"The Power" = 'sound/music/instruments/viola (6).ogg', //BG3 Song, I KNOW THIS ISNT A VIOLIN, LEAVE ME ALONE
	"Bard Dance" = 'sound/music/instruments/viola (7).ogg', // BG3 Song
	"Old Time Battles" = 'sound/music/instruments/viola (8).ogg') // BG3 Song


/obj/item/rogue/instrument/vocals
	name = "vocalist's talisman"
	desc = "This talisman emanates a soft shimmer of light. When held, it can amplify and even change a bard's voice."
	icon_state = "vtalisman"
	song_list = list("Harpy's Call (Feminine)" = 'sound/music/instruments/vocalsf (1).ogg',
	"Necra's Lullaby (Feminine)" = 'sound/music/instruments/vocalsf (2).ogg',
	"Death Touched Aasimar (Feminine)" = 'sound/music/instruments/vocalsf (3).ogg',
	"Our Mother, Our Divine (Feminine)" = 'sound/music/instruments/vocalsf (4).ogg',
	"Wed, Forever More (Feminine)" = 'sound/music/instruments/vocalsf (5).ogg',
	"Paper Boats (Feminine + Vocals)" = 'sound/music/instruments/vocalsf (6).ogg',
	"The Dragon's Blood Surges (Masculine)" = 'sound/music/instruments/vocalsm (1).ogg',
	"Timeless Temple (Masculine)" = 'sound/music/instruments/vocalsm (2).ogg',
	"Angel's Earnt Halo (Masculine)" = 'sound/music/instruments/vocalsm (3).ogg',
	"A Fabled Choir (Masculine)" = 'sound/music/instruments/vocalsm (4).ogg',
	"A Pained Farewell (Masculine + Feminine)" = 'sound/music/instruments/vocalsx (1).ogg',
	"The Power (Whistling)" = 'sound/music/instruments/vocalsx (2).ogg',
	"Bard Dance (Whistling)" = 'sound/music/instruments/vocalsx (3).ogg',
	"Old Time Battles (Whistling)" = 'sound/music/instruments/vocalsx (4).ogg')
