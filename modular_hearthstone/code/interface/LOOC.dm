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

/client/proc/get_looc()
	var/msg = input(src, "", "looc") as text|null
	do_looc(msg, FALSE)


/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "Local OOC, seen only by those in view."
	set category = "OOC"

	do_looc(msg, FALSE)

/client/verb/loocwp(msg as text)
	set name = "LOOC (Wall Pierce)"
	set desc = "Local OOC, seen by all in range."
	set category = "OOC"

	do_looc(msg, TRUE)

/client/proc/do_looc(msg as text, wp)

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("Speech is currently admin-disabled."))
		return

	if(prefs.muted & MUTE_LOOC)
		to_chat(src, span_danger("I cannot use LOOC (temp muted)."))
		return

	if(is_banned_from(ckey, "LOOC"))
		to_chat(src, span_danger("I cannot use LOOC (perma muted)."))
		return

	if(isobserver(mob) && !holder)
		to_chat(src, span_danger("I cannot use LOOC while dead."))
		return

	// Lobby restriction: disable LOOC for normal players still in the lobby (new_player)
	if(!holder && istype(mob, /mob/dead/new_player))
		to_chat(src, span_danger("I cannot use LOOC while in the lobby. Join the round or observe first."))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
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
		if((C in GLOB.admins) && (C.prefs.admin_chat_toggles & CHAT_ADMINLOOC))
			to_chat(C, msg_adm)
		else
			to_chat(C, msg_reg)

	for(var/client/C in GLOB.admins)
		if(seen[C] || !(C.prefs.admin_chat_toggles & CHAT_ADMINLOOC) || !(C.prefs.chat_toggles & CHAT_OOC))
			continue
		
		to_chat(C, msg_rem)
