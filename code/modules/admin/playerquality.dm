#define RCP_CONTRIBUTION_CAP 20 // How much RCP can contribute to PQ gain total.

/proc/get_playerquality(key, text)
	if(!key)
		return
	var/the_pq = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/pq_num.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	if(json[ckey(key)])
		the_pq = json[ckey(key)]
	if(!the_pq)
		the_pq = 0
	if(!text)
		return the_pq
	else
		if(the_pq >= 500)
			return "<span style='color: #FFD700;'>ASCENDANT</span>"
		if(the_pq >= 440)
			return "<span style='color: #B0C4DE;'>UNDYING</span>"
		if(the_pq >= 375)
			return "<span style='color: #9B59B6;'>DIVINE</span>"
		if(the_pq >= 310)
			return "<span style='color: #E8D44D;'>EXALTED</span>"
		if(the_pq >= 250)
			return "<span style='color: #5DADE2;'>RENOWNED</span>"
		if(the_pq >= 200)
			return "<span style='color: #52BE80;'>FABLED</span>"
		if(the_pq >= 160)
			return "<span style='color: #45B39D;'>STORIED</span>"
		if(the_pq >= 130)
			return "<span style='color: #4CAF50;'>PROVEN</span>"
		if(the_pq >= 100)
			return "<span style='color: #617C46;'>VALE DWELLER</span>"
		if(the_pq >= 70)
			return "<span style='color: #00ff00;'>Magnificent!</span>"
		if(the_pq >= 50)
			return "<span style='color: #00ff00;'>Exceptional!</span>"
		if(the_pq >= 30)
			return "<span style='color: #47b899;'>Great!</span>"
		if(the_pq >= 10)
			return "<span style='color: #69c975;'>Good!</span>"
		if(the_pq >= 5)
			return "<span style='color: #58a762;'>Nice</span>"
		if(the_pq >= -4)
			return "Normal"
		if(the_pq >= -30)
			return "<span style='color: #be6941;'>Poor</span>"
		if(the_pq >= -70)
			return "<span style='color: #cd4232;'>Terrible</span>"
		if(the_pq >= -99)
			return "<span style='color: #e2221d;'>Abysmal</span>"
		if(the_pq <= -100)
			return "<span style='color: #ff00ff;'>Shitter</span>"
		return "Normal"

/proc/adjust_playerquality(amt, key, admin, reason)
	var/curpq = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/pq_num.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))
	if(json[key])
		curpq = json[key]
	curpq += amt
	curpq = CLAMP(curpq, -100, PQ_CAP)
	json[key] = curpq
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

	if(reason || admin)
		var/thing = ""
		if(amt > 0)
			thing += "+[amt]"
		if(amt < 0)
			thing += "[amt]"
		if(admin)
			thing += " by [admin]"
		if(reason)
			thing += " for reason: [reason]"
		if(amt == 0)
			if(!reason && !admin)
				return
			if(admin)
				thing = "NOTE from [admin]: [reason]"
			else
				thing = "NOTE: [reason]"
		thing += " ([GLOB.rogue_round_id])"
		thing += "\n"
		text2file(thing,"data/player_saves/[copytext(key,1,2)]/[key]/playerquality.txt")

		var/msg
		if(!amt)
			msg = "[key] triggered event [msg]"
		else
			if(amt > 0)
				msg = "[key] ([amt])"
			else
				msg = "[key] ([amt])"
		if(admin)
			msg += " - GM: [admin]"
		if(reason)
			msg += " - RSN: [reason]"
		message_admins("[admin] adjusted [key]'s PQ by [amt] for reason: [reason]")
		log_admin("[admin] adjusted [key]'s PQ by [amt] for reason: [reason]")

/client/proc/check_pq()
	set category = "-Special Verbs-"
	set name = "PQ - Check"
	if(!holder)
		return
	var/selection = alert(src, "Check VIA...", "Check PQ", "Character List", "Player List", "Player Name")
	if(!selection)
		return
	var/list/selections = list()
	var/theykey
	if(selection == "Character List")
		for(var/mob/living/H in GLOB.player_list)
			selections[H.real_name] = H.ckey
		if(!selections.len)
			to_chat(src, span_boldwarning("No characters found."))
			return
		selection = input("Which Character?") as null|anything in sortList(selections)
		if(!selection)
			return
		theykey = selections[selection]
	if(selection == "Player List")
		for(var/client/C in GLOB.clients)
			var/usedkey = C.ckey
			selections[usedkey] = C.ckey
		selection = input("Which Player?") as null|anything in sortList(selections)
		if(!selection)
			return
		theykey = selections[selection]
	if(selection == "Player Name")
		selection = input("Which Player?", "CKEY", "") as text|null
		if(!selection)
			return
		theykey = selection
	check_pq_menu(theykey)

/proc/check_pq_menu(ckey)
	if(!fexists("data/player_saves/[copytext(ckey,1,2)]/[ckey]/preferences.sav"))
		to_chat(usr, span_boldwarning("User does not exist."))
		return
	var/popup_window_data = "<center>[ckey]</center>"
	popup_window_data += "<center>PQ: [get_playerquality(ckey, TRUE, TRUE)] ([get_playerquality(ckey, FALSE, TRUE)])</center>"

//	dat += "<table width=100%><tr><td width=33%><div style='text-align:left'><a href='?_src_=prefs;preference=playerquality;task=menu'><b>PQ:</b></a> [get_playerquality(user.ckey, text = TRUE)]</div></td><td width=34%><center><a href='?_src_=prefs;preference=triumphs;task=menu'><b>TRIUMPHS:</b></a> [user.get_triumphs() ? "\Roman [user.get_triumphs()]" : "None"]</center></td><td width=33%></td></tr></table>"
	popup_window_data += "<center><a href='?_src_=holder;[HrefToken()];cursemenu=[ckey]'>CURSES</a></center>"
	popup_window_data += "<table width=100%><tr><td width=33%><div style='text-align:left'>"
	popup_window_data += "Commends: <a href='?_src_=holder;[HrefToken()];readcommends=[ckey]'>[get_commends(ckey)]</a></div></td>"
	popup_window_data += "<td width=34%><center>Round Contributor Points: [get_roundpoints(ckey)]</center></td>"
	popup_window_data += "<td width=33%><div style='text-align:right'>Rounds Survived: [get_roundsplayed(ckey)]</div></td></tr></table>"
	var/list/listy = world.file2list("data/player_saves/[copytext(ckey,1,2)]/[ckey]/playerquality.txt")
	if(!listy.len)
		popup_window_data += span_info("No data on record. Create some.")
	else
		for(var/i = listy.len to 1 step -1)
			var/ya = listy[i]
			if(ya)
				popup_window_data += "<span class='info'>[listy[i]]</span><br>"
	var/datum/browser/noclose/popup = new(usr, "playerquality", "", 390, 320)
	popup.set_content(popup_window_data)
	popup.open()

/client/proc/adjust_pq()
	set category = "-Special Verbs-"
	set name = "PQ - Adjust"
	if(!holder)
		return
	var/selection = alert(src, "Adjust VIA...", "MODIFY PQ", "Character List", "Player List", "Player Name")
	var/list/selections = list()
	var/theykey
	if(selection == "Character List")
		for(var/mob/living/H in GLOB.player_list)
			selections[H.real_name] = H.ckey
		if(!selections.len)
			to_chat(src, span_boldwarning("No characters found."))
			return
		selection = input("Which Character?") as null|anything in sortList(selections)
		if(!selection)
			return
		theykey = selections[selection]
	if(selection == "Player List")
		for(var/client/C in GLOB.clients)
			var/usedkey = C.ckey
//			if(!check_rights(R_ADMIN,0))
//				if(C.ckey in GLOB.anonymize)
//					usedkey = get_fake_key(C.ckey)
			selections[usedkey] = C.ckey
		selection = input("Which Player?") as null|anything in sortList(selections)
		if(!selection)
			return
		theykey = selections[selection]
	if(selection == "Player Name")
		selection = input("Which Player?", "CKEY", "") as text|null
		if(!selection)
			return
		theykey = selection
	if(!fexists("data/player_saves/[copytext(theykey,1,2)]/[theykey]/preferences.sav"))
		to_chat(src, span_boldwarning("User does not exist."))
		return
	var/amt2change = input("How much to modify the PQ by? (20 to -20, or 0 to just add a note)") as null|num
	if(!check_rights(R_ADMIN,0))
		amt2change = CLAMP(amt2change, -20, 20)
	var/raisin = stripped_input("State a short reason for this change", "Game Master", "", null)
	if(!amt2change && !raisin)
		return
	adjust_playerquality(amt2change, theykey, src.ckey, raisin)
	for(var/client/C in GLOB.clients) // I hate this, but I'm not refactoring the cancer above this point.
		if(LOWER_TEXT(C.key) == LOWER_TEXT(theykey))
			to_chat(C, "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">Your PQ has been adjusted by [amt2change] by [key] for reason: [raisin]</span></span>")
			return

/proc/add_commend(key, giver)
	if(!giver || !key)
		return
	var/curcomm = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/commends.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))
	if(json[giver])
		curcomm = json[giver]
	curcomm++
	json[giver] = curcomm
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

	var/cur_pq = get_playerquality(ckey(key))
	if(cur_pq >= 100)
		if(curcomm == 1)
			adjust_playerquality(0.5, ckey(key))
		else
			adjust_playerquality(0.05, ckey(key))
	else if(curcomm == 1)
		adjust_playerquality(1, ckey(key))

/proc/get_commends(key)
	if(!key)
		return
	var/curcomm = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/commends.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	for(var/X in json)
		curcomm += json[X]
	if(!curcomm)
		curcomm = 0
	return curcomm

/proc/add_roundpoints(amt, key) //Each round contributor point counts as 0.1 of a PQ.
	if(!key)
		return
	if(get_playerquality(key) >= 100)
		return
	var/curcomm = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/rcp.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))
	if(json["RCP"])
		curcomm = json["RCP"]

	curcomm += amt
	json["RCP"] = curcomm
	fdel(json_file)
	WRITE_FILE(json_file, json_encode(json))

	if(curcomm < 100 || get_playerquality(key) < RCP_CONTRIBUTION_CAP)
		adjust_playerquality(round(amt/10,0.1), ckey(key))

/proc/get_roundpoints(key)
	if(!key)
		return
	var/curcomm = 0
	var/json_file = file("data/player_saves/[copytext(key,1,2)]/[key]/rcp.json")
	if(!fexists(json_file))
		WRITE_FILE(json_file, "{}")
	var/list/json = json_decode(file2text(json_file))

	if(json["RCP"])
		curcomm = json["RCP"]
	if(!curcomm)
		curcomm = 0
	return curcomm

/// Recalculates the unrewarded portion of a player's commends using the post-rework formula.
/// Givers contribute 0.5 for the first commend and 0.05 for each subsequent one, mirroring add_commend()
/// when PQ is at or above 100. A marker file ensures this only ever runs once per ckey.
/// Sub-100 players are skipped because their commends were already awarded under the old rules.
/proc/recalc_pq_from_commends(ckey, admin)
	if(!ckey)
		return 0
	var/prefix = copytext(ckey, 1, 2)
	var/marker = "data/player_saves/[prefix]/[ckey]/pq_recalc_v1.json"
	if(fexists(marker))
		return 0
	if(get_playerquality(ckey) < 100)
		return 0
	var/commend_path = "data/player_saves/[prefix]/[ckey]/commends.json"
	if(!fexists(commend_path))
		return 0
	var/list/commend_json = json_decode(file2text(commend_path))
	if(!length(commend_json))
		return 0
	var/bonus = 0
	for(var/giver in commend_json)
		var/count = commend_json[giver]
		if(count <= 0)
			continue
		bonus += 0.5 + (0.05 * (count - 1))
	bonus = round(bonus, 0.01)
	if(bonus <= 0)
		return 0
	adjust_playerquality(bonus, ckey, admin, "PQ rework backfill from [length(commend_json)] commenders")
	WRITE_FILE(file(marker), json_encode(list("applied" = bonus, "round" = GLOB.rogue_round_id)))
	return bonus

/client/proc/recalc_pq_bulk()
	set category = "-Special Verbs-"
	set name = "PQ - Recalc From Commends (Bulk)"
	set waitfor = FALSE
	if(!holder || !check_rights(R_ADMIN, 0))
		return
	if(alert(src, "This will scan every player save and grant missing PQ from existing commends using the rework formula. Only players already at PQ 100+ are affected. Each ckey is processed once. Continue?", "PQ Bulk Recalc", "Yes", "No") != "Yes")
		return
	var/total_players = 0
	var/total_bonus = 0
	var/scanned = 0
	for(var/prefix in flist("data/player_saves/"))
		if(copytext(prefix, length(prefix)) != "/")
			continue
		for(var/ckey_dir in flist("data/player_saves/[prefix]"))
			if(copytext(ckey_dir, length(ckey_dir)) != "/")
				continue
			var/the_ckey = ckey(copytext(ckey_dir, 1, length(ckey_dir)))
			scanned++
			if(!the_ckey)
				continue
			var/granted = recalc_pq_from_commends(the_ckey, src.ckey)
			if(granted > 0)
				total_players++
				total_bonus += granted
			CHECK_TICK
	var/bulk_msg = "[src.ckey] ran PQ bulk recalc from commends: [scanned] scanned, [total_players] adjusted, +[round(total_bonus, 0.01)] PQ total."
	to_chat(world, "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">[bulk_msg]</span></span>")
	message_admins(bulk_msg)
	log_admin(bulk_msg)

/client/proc/recalc_pq_single()
	set category = "-Special Verbs-"
	set name = "PQ - Recalc From Commends (Single)"
	if(!holder || !check_rights(R_ADMIN, 0))
		return
	var/the_ckey = ckey(stripped_input(src, "Which ckey?", "PQ Recalc", ""))
	if(!the_ckey)
		return
	if(!fexists("data/player_saves/[copytext(the_ckey,1,2)]/[the_ckey]/preferences.sav"))
		to_chat(src, span_boldwarning("User does not exist."))
		return
	var/marker = "data/player_saves/[copytext(the_ckey,1,2)]/[the_ckey]/pq_recalc_v1.json"
	if(fexists(marker) && alert(src, "[the_ckey] has already been recalc'd. Force again? (this will double-pay them)", "PQ Recalc", "No", "Yes") != "Yes")
		return
	if(fexists(marker))
		fdel(marker)
	var/granted = recalc_pq_from_commends(the_ckey, src.ckey)
	if(granted <= 0)
		to_chat(src, span_boldwarning("No PQ granted to [the_ckey] (sub-100, no commends, or already processed)."))
		return
	var/single_msg = "[src.ckey] recalc'd [the_ckey]'s PQ from commends: +[round(granted, 0.01)]."
	to_chat(world, "<span class=\"admin\"><span class=\"prefix\">ADMIN LOG:</span> <span class=\"message linkify\">[single_msg]</span></span>")
	message_admins("[src.ckey] recalc'd [the_ckey]'s PQ from commends: +[round(granted, 0.01)].")
	log_admin("[src.ckey] recalc'd [the_ckey]'s PQ from commends: +[round(granted, 0.01)].")

