/datum/keybinding/looc
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("Y")
	name = "LOOC"
	full_name = "LOOC Chat"
	description = "Local OOC Chat."

/datum/keybinding/looc/down(client/user)
	user.get_looc()
	return TRUE

/client/var/looc_input_generation = 0

/client/proc/get_looc_input(title = "looc")
	var/generation = ++looc_input_generation
	var/mob/typing_mob = mob
	var/mutable_appearance/indicator = typing_mob?.display_looc_typing_indicator()
	var/msg = input(src, "", title) as text|null
	if(generation == looc_input_generation && !QDELETED(typing_mob) && indicator && typing_mob.typing_indicator_current == indicator)
		typing_mob.clear_typing_indicator(length(msg) ? "sent" : "closed input")
	return msg

/client/proc/get_looc()
	do_looc(get_looc_input(), FALSE)


/client/verb/looc(msg = null as text|null)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	if(isnull(msg))
		msg = get_looc_input("looc")
	do_looc(msg, FALSE)

/client/verb/loocwp(msg = null as text|null)
	set name = "LOOC (Wall Pierce)"
	set desc = "Local OOC, seen by all in range."
	set category = "OOC"

	if(isnull(msg))
		msg = get_looc_input("looc (wall pierce)")
	do_looc(msg, TRUE)

// Subtle LOOC verb
/client/verb/subtlelooc(msg = null as text|null)
	set name = "LOOC (Subtle)"
	set desc = "Local OOC only for a specific target or 1 tile range."
	set category = "OOC"
	if(isnull(msg))
		msg = get_looc_input("looc (subtle)")
	do_subtlelooc(msg)

/// Takes raw text and sanitizes it on the first line, before anything else in here can read it.
/// Callers must pass the message unsanitized, encoding it twice turns apostrophes into a
/// literal &#39; in chat.
/client/proc/do_subtlelooc(msg as text)
	mob?.clear_looc_typing_indicator("submitted LOOC")

	// Sanitizes here. IDK why it was just randomly all the way down there.
	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)

	if(!msg)
		return

	if(GLOB.say_disabled)
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	// SLOOC has its own mute, the LOOC one doesn't reach it and this one doesn't reach LOOC
	if(prefs.muted & MUTE_SLOOC)
		to_chat(src, span_danger("I cannot use SLOOC (temp muted)."))
		return

	if(!holder && istype(mob, /mob/dead/new_player))
		to_chat(src, span_danger("I cannot use LOOC while in the lobby. Join the round or observe first."))
		return

	if(!mob)
		return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("You have OOC muted."))
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in SLOOC: [msg]")
			return

	var/mob/S = mob
	var/s_name = S.name
	var/s_ckey = ckey
	var/pfx = "SLOOC"
	var/distance = 4
	var/list/hearers = get_hearers_in_view(distance, S)
	var/list/recipient_choices = list("1-Tile Range", "Same Tile")

	// L.client, so NPCs and disconnected bodies stay out of the picker
	for(var/mob/living/L in hearers)
		if(L.client && L.stat < DEAD && L != S)
			if(!L.rogue_sneaking && L.name != "Unknown")
				recipient_choices += L

	var/recipient_choice = input(src, "Pick a target?", "SLOOC") in recipient_choices
	if(!recipient_choice || QDELETED(S) || mob != S)
		return

	mob.log_talk(msg, LOG_LOOC)

	var/recipient_label
	var/recipient_admin_label
	if(recipient_choice == "1-Tile Range")
		recipient_label = "1-Tile"
		recipient_admin_label = recipient_label
	else if(recipient_choice == "Same Tile")
		recipient_label = "Same Tile"
		recipient_admin_label = recipient_label
	else
		var/mob/living/target = recipient_choice
		if(!istype(target) || QDELETED(target) || target.stat == DEAD || !target.client)
			to_chat(src, span_boldwarning("The subtle LOOC target is no longer available, try again."))
			return
		recipient_label = target.name
		if(target.ckey)
			recipient_admin_label = "[recipient_label] ([target.ckey])"
		else
			recipient_admin_label = recipient_label

	// Both links, so a SLOOC line can shut down SLOOC alone or LOOC alongside it
	var/mute_slooc_link = "<A href='?_src_=holder;[HrefToken()];mute=[s_ckey];mute_type=[MUTE_SLOOC]'><font color='[(prefs.muted & MUTE_SLOOC) ? "red" : "blue"]'>\[MUTE SLOOC\]</font></a>"
	var/mute_looc_link = "<A href='?_src_=holder;[HrefToken()];mute=[s_ckey];mute_type=[MUTE_LOOC]'><font color='[(prefs.muted & MUTE_LOOC) ? "red" : "blue"]'>\[MUTE LOOC\]</font></a>"
	var/admin_info = " ([s_ckey]) [ADMIN_FLW(S)] [mute_slooc_link] [mute_looc_link]"
	var/prefix_text = span_prefix("[pfx]:")

	var/msg_reg = "<font color='#9DCCFF'><b>[prefix_text] <EM>[s_name] → [recipient_label]:</EM> <span class='message'>[msg]</span></b></font>"
	var/msg_adm = "<font color='#2F74A8'><b>[prefix_text] <EM>[s_name][admin_info] → [recipient_admin_label]:</EM> <span class='message'>[msg]</span></b></font>"
	var/msg_rem = "<font color='#2F74A8'><b>(R) [prefix_text] <EM>[s_name][admin_info] → [recipient_admin_label]:</EM> <span class='message'>[msg]</span></b></font>"

	var/list/seen = list()

	if(recipient_choice == "1-Tile Range" || recipient_choice == "Same Tile")
		var/limit = (recipient_choice == "1-Tile Range") ? 1 : 0
		for(var/mob/M in hearers)
			if(get_dist(get_turf(M), get_turf(S)) > limit)
				continue
			var/client/C = M.client
			if(!C || !(C.prefs.chat_toggles & CHAT_OOC))
				continue

			SEND_SOUND(C, sound('sound/misc/subtle_looc.ogg', volume = max(C.prefs.mastervol * 0.5, 0)))
			seen[C] = TRUE
			var/outgoing_msg = ((C in GLOB.admins) && (C.prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(C, outgoing_msg)
	else
		var/mob/target = recipient_choice
		if(target.z != S.z || get_dist(get_turf(target), get_turf(S)) > distance)
			to_chat(src, span_boldwarning("The subtle LOOC target moved out of view, try again."))
			return
		var/client/target_client = target?.client
		if(target_client && (target_client.prefs.chat_toggles & CHAT_OOC))
			SEND_SOUND(target_client, sound('sound/misc/subtle_looc.ogg', volume = max(target_client.prefs.mastervol * 0.5, 0)))
			seen[target_client] = TRUE
			var/target_msg = ((target_client in GLOB.admins) && (target_client.prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(target_client, target_msg)

		if((prefs.chat_toggles & CHAT_OOC) && !(src in seen))
			SEND_SOUND(src, sound('sound/misc/subtle_looc.ogg', volume = max(prefs.mastervol * 0.5, 0)))
			seen[src] = TRUE
			var/self_msg = ((src in GLOB.admins) && (prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(src, self_msg)

	for(var/client/C in GLOB.admins)
		if(seen[C] || !(C.prefs.admin_chat_toggles & CHAT_ADMINLOOC) || !(C.prefs.chat_toggles & CHAT_OOC))
			continue

		to_chat(C, msg_rem)

/client/proc/do_looc(msg as text, wp)
	mob?.clear_looc_typing_indicator("submitted LOOC")
	if(!msg)
		return

	// If LOOC message starts with @, treat as SLOOC. Hand over the raw text, do_subtlelooc
	// sanitizes its own input and encoding it a second time here would mangle apostrophes
	if(copytext(msg, 1, 2) == "@")
		var/slooc_msg = copytext(msg, 2)
		if(length(slooc_msg) && copytext(slooc_msg, 1, 2) == " ")
			slooc_msg = copytext(slooc_msg, 2)
		do_subtlelooc(slooc_msg)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(prefs.muted & MUTE_LOOC)
		to_chat(src, span_danger("I cannot use LOOC (temp muted)."))
		return

	if(is_banned_from(ckey, "LOOC"))
		to_chat(src, span_danger("I cannot use LOOC (perma muted)."))
		return

	// Lobby restriction: disable LOOC for normal players still in the lobby (new_player)
	if(istype(mob, /mob/dead/new_player))
		if(!holder)
			to_chat(src, span_danger("I cannot use LOOC while in the lobby. Join the round or observe first."))
			return

	else if((mob?.stat == DEAD || isobserver(mob)) && !(holder && istype(mob, /mob/dead/observer/admin)))
		var/refusal = isobserver(mob) ? "I cannot use LOOC while ghosted." : "I cannot use LOOC while dead, only SLOOC."
		to_chat(src, span_danger(refusal))
		return

	if(!mob)
		return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("You have OOC muted."))
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>Advertising other servers is not allowed.</B>")
			log_admin("[key_name(src)] has attempted to advertise in LOOC: [msg]")
			return

	//msg = emoji_parse(msg)

	var/mob/S = mob
	var/s_name = S.name
	var/s_ckey = ckey
	var/pfx = wp ? "LOOC (WP)" : "LOOC"

	mob.log_talk(msg, LOG_LOOC)

	var/admin_info = " ([s_ckey]) [ADMIN_FLW(S)] <A href='?_src_=holder;[HrefToken()];mute=[s_ckey];mute_type=[MUTE_LOOC]'><font color='[(prefs.muted & MUTE_LOOC) ? "red" : "blue"]'>\[MUTE\]</font></a>"

	var/msg_reg = "<font color='#6699CC'><b><span class='prefix'>[pfx]:</span> <EM>[s_name]:</EM> <span class='message'>[msg]</span></b></font>"
	var/msg_adm = "<font color='#6699CC'><b><span class='prefix'>[pfx]:</span> <EM>[s_name][admin_info]:</EM> <span class='message'>[msg]</span></b></font>"
	var/msg_rem = "<font color='#003458'><b>(R) <span class='prefix'>[pfx]:</span> <EM>[s_name][admin_info]:</EM> <span class='message'>[msg]</span></b></font>"

	var/list/hearers = wp ? get_hearers_in_range(7, S) : get_hearers_in_view(7, S)
	var/list/seen = list()

	for(var/mob/M in hearers)
		var/client/C = M.client
		if(!C || !(C.prefs.chat_toggles & CHAT_OOC))
			continue
		
		seen[C] = TRUE
		var/outgoing_msg = ((C in GLOB.admins) && (C.prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
		to_chat(C, outgoing_msg)
		M.playsound_local(get_turf(M), 'sound/misc/looc_smol.ogg', 30, TRUE)

	for(var/client/C in GLOB.admins)
		if(seen[C] || !(C.prefs.admin_chat_toggles & CHAT_ADMINLOOC) || !(C.prefs.chat_toggles & CHAT_OOC))
			continue
		
		to_chat(C, msg_rem)
