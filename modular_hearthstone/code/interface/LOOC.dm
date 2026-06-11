/datum/keybinding/looc
	category = CATEGORY_CLIENT
	weight = WEIGHT_HIGHEST
	hotkey_keys = list("Y")
	name = "LOOC"
	full_name = "LOOC聊天"
	description = "本地OOC聊天。"

/datum/keybinding/looc/down(client/user)
	user.get_looc()
	return TRUE

/client/proc/get_looc()
	var/msg = input(src, "", "looc") as text|null
	do_looc(msg, FALSE)


/client/verb/looc(msg as text)
	set name = "LOOC"
	set desc = "本地OOC，只有视野内的人能看见。"
	set category = "OOC"

	do_looc(msg, FALSE)

/client/verb/loocwp(msg as text)
	set name = "LOOC（穿墙）"
	set desc = "本地OOC，范围内所有人都能看见。"
	set category = "OOC"

	do_looc(msg, TRUE)

// Subtle LOOC verb
/client/verb/subtlelooc(msg as text)
	set name = "LOOC（细语）"
	set desc = "本地OOC，仅发给特定目标或1格范围。"
	set category = "OOC"
	do_subtlelooc(msg)

/client/proc/do_subtlelooc(msg as text)

	if(GLOB.say_disabled)
		to_chat(usr, span_danger("发言当前已被管理员禁用。"))
		return

	if(prefs.muted & MUTE_LOOC)
		to_chat(src, span_danger("我无法使用LOOC（暂时禁言）。"))
		return

	if(is_banned_from(ckey, "LOOC"))
		to_chat(src, span_danger("我无法使用LOOC（永久禁言）。"))
		return

	if(isobserver(mob) && !holder)
		to_chat(src, span_danger("我死亡时无法使用LOOC。"))
		return

	if(!holder && istype(mob, /mob/dead/new_player))
		to_chat(src, span_danger("我在大厅中无法使用LOOC。请先加入本轮或先观察。"))
		return

	if(!mob)
		return

	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("你已屏蔽OOC。"))
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>不允许宣传其他服务器。</B>")
			log_admin("[key_name(src)] has attempted to advertise in SLOOC: [msg]")
			return

	var/mob/S = mob
	var/s_name = S.name
	var/s_ckey = ckey
	var/pfx = "SLOOC"
	var/distance = 4
	var/list/hearers = get_hearers_in_view(distance, S)
	var/list/recipient_choices = list("1格范围", "同一格")

	for(var/mob/living/L in hearers)
		if(L.stat == CONSCIOUS && L != S)
			if(!L.rogue_sneaking && L.name != "Unknown")
				recipient_choices += L

	var/recipient_choice = input(src, "选择一个目标？", "细语表情") in recipient_choices
	if(!recipient_choice)
		return

	mob.log_talk(msg, LOG_LOOC)

	var/recipient_label
	var/recipient_admin_label
	if(recipient_choice == "1格范围")
		recipient_label = "1格"
		recipient_admin_label = recipient_label
	else if(recipient_choice == "同一格")
		recipient_label = "同一格"
		recipient_admin_label = recipient_label
	else
		var/mob/target = recipient_choice
		recipient_label = target.name
		if(target.ckey)
			recipient_admin_label = "[recipient_label] ([target.ckey])"
		else
			recipient_admin_label = recipient_label

	var/admin_info = " ([s_ckey]) [ADMIN_FLW(S)] <A href='?_src_=holder;[HrefToken()];mute=[s_ckey];mute_type=[MUTE_LOOC]'><font color='[(prefs.muted & MUTE_LOOC) ? "red" : "blue"]'>\[MUTE\]</font></a>"
	var/prefix_text = span_prefix("[pfx]:")

	var/msg_reg = "<font color='#9DCCFF'><b>[prefix_text] <EM>[s_name] → [recipient_label]:</EM> <span class='message'>[msg]</span></b></font>"
	var/msg_adm = "<font color='#9DCCFF'><b>[prefix_text] <EM>[s_name][admin_info] → [recipient_admin_label]:</EM> <span class='message'>[msg]</span></b></font>"
	var/msg_rem = "<font color='#2F74A8'><b>(R) [prefix_text] <EM>[s_name][admin_info] → [recipient_admin_label]:</EM> <span class='message'>[msg]</span></b></font>"

	var/list/seen = list()

	if(recipient_choice == "1格范围" || recipient_choice == "同一格")
		var/limit = (recipient_choice == "1格范围") ? 1 : 0
		for(var/mob/M in hearers)
			if(get_dist(get_turf(M), get_turf(S)) > limit)
				continue
			var/client/C = M.client
			if(!C || !(C.prefs.chat_toggles & CHAT_OOC))
				continue

			seen[C] = TRUE
			var/outgoing_msg = ((C in GLOB.admins) && (C.prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(C, outgoing_msg)
	else
		var/mob/target = recipient_choice
		if(get_dist(get_turf(target), get_turf(S)) > distance)
			to_chat(src, span_boldwarning("细语LOOC的目标已离开视野，请重试。"))
			return
		var/client/target_client = target?.client
		if(target_client && (target_client.prefs.chat_toggles & CHAT_OOC))
			seen[target_client] = TRUE
			var/target_msg = ((target_client in GLOB.admins) && (target_client.prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(target_client, target_msg)

		if((prefs.chat_toggles & CHAT_OOC) && !(src in seen))
			seen[src] = TRUE
			var/self_msg = ((src in GLOB.admins) && (prefs.admin_chat_toggles & CHAT_ADMINLOOC)) ? msg_adm : msg_reg
			to_chat(src, self_msg)

	for(var/client/C in GLOB.admins)
		if(seen[C] || !(C.prefs.admin_chat_toggles & CHAT_ADMINLOOC) || !(C.prefs.chat_toggles & CHAT_OOC))
			continue

		to_chat(C, msg_rem)

/client/proc/do_looc(msg as text, wp)
	msg = copytext_char(sanitize(msg), 1, MAX_MESSAGE_LEN)
	if(!msg)
		return

	// If LOOC message starts with @, treat as SLOOC
	if(copytext(msg, 1, 2) == "@")
		var/slooc_msg = copytext(msg, 2)
		if(length(slooc_msg) && copytext(slooc_msg, 1, 2) == " ")
			slooc_msg = copytext(slooc_msg, 2)
		do_subtlelooc(slooc_msg)
		return

	if(GLOB.say_disabled)	//This is here to try to identify lag problems
		to_chat(usr, span_danger("发言当前已被管理员禁用。"))
		return

	if(prefs.muted & MUTE_LOOC)
		to_chat(src, span_danger("我无法使用LOOC（暂时禁言）。"))
		return

	if(is_banned_from(ckey, "LOOC"))
		to_chat(src, span_danger("我无法使用LOOC（永久禁言）。"))
		return

	if(isobserver(mob) && !holder)
		to_chat(src, span_danger("我死亡时无法使用LOOC。"))
		return

	// Lobby restriction: disable LOOC for normal players still in the lobby (new_player)
	if(!holder && istype(mob, /mob/dead/new_player))
		to_chat(src, span_danger("我在大厅中无法使用LOOC。请先加入本轮或先观察。"))
		return

	if(!mob)
		return

	if(!(prefs.chat_toggles & CHAT_OOC))
		to_chat(src, span_danger("你已屏蔽OOC。"))
		return

	if(!holder)
		if(findtext(msg, "byond://"))
			to_chat(src, "<B>不允许宣传其他服务器。</B>")
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

	for(var/client/C in GLOB.admins)
		if(seen[C] || !(C.prefs.admin_chat_toggles & CHAT_ADMINLOOC) || !(C.prefs.chat_toggles & CHAT_OOC))
			continue
		
		to_chat(C, msg_rem)
