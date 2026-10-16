/// Right-click admin verb. Built only when asked for, from what the forensics component already holds, so it costs nothing until used.
/client/proc/view_forensics(obj/O as obj in view())
	set category = null
	set name = "View Forensics"
	set desc = "List the players who have opened, locked, picked, broken or touched this."
	if(!check_rights(R_ADMIN))
		return
	if(QDELETED(O))
		return
	log_admin("[key_name(usr)] viewed the forensics of [O] at [AREACOORD(O)].")
	var/datum/browser/popup = new(usr, "view_forensics", "Forensics: [O]", 640, 520)
	popup.set_content(forensics_report(O))
	popup.open()

/proc/forensics_report(atom/A)
	var/datum/component/forensics/D = A.GetComponent(/datum/component/forensics)
	var/list/dat = list()
	dat += "<b>[A]</b> ([A.type]) [ADMIN_COORDJMP(A)]<br>"

	dat += "<h3>Actions</h3>"
	if(!LAZYLEN(D?.actions))
		dat += "<i>None recorded.</i>"
	else
		dat += "<table width='100%'><tr><th align='left'>Round time</th><th align='left'>Ckey</th><th align='left'>Action</th><th></th></tr>"
		// Newest first
		for(var/i in length(D.actions) to 1 step -1)
			var/list/entry = D.actions[i]
			var/repeats = entry["count"] > 1 ? " (x[entry["count"]])" : ""
			dat += "<tr><td>[forensics_round_time(entry["time"])]</td>"
			dat += "<td>[entry["ckey"]] ([html_encode(entry["name"])])</td>"
			dat += "<td>[html_encode(entry["action"])][repeats]</td>"
			dat += "<td>[forensics_player_links(entry["ckey"])]</td></tr>"
		dat += "</table>"
		dat += "<small>Only the latest [length(D.actions)] are kept. Repeats in a row are counted on one line, with the time of the latest.</small>"

	dat += "<h3>Touched by hand</h3>"
	if(!LAZYLEN(D?.hiddenprints))
		dat += "<i>None recorded.</i>"
	else
		dat += "<table width='100%'>"
		// Keyed by BYOND key, with real times from time_stamp()
		for(var/print_key in D.hiddenprints)
			dat += "<tr><td>[html_encode(D.hiddenprints[print_key])]</td><td>[forensics_player_links(ckey(print_key))]</td></tr>"
		dat += "</table>"
	if(A.fingerprintslast)
		dat += "<br>Last touched by: [A.fingerprintslast] [forensics_player_links(A.fingerprintslast)]"
	return jointext(dat, "")

/proc/forensics_round_time(time)
	return time2text(max(time - SSticker.round_start_time, 0), "hh:mm:ss", 0)

/// The mob is looked up when PP is clicked, so the link still works after the player changes mob.
/proc/forensics_player_links(target_ckey)
	return "<a href='?_src_=holder;[HrefToken()];forensics_pp=[target_ckey]'>PP</a> <a href='?priv_msg=[target_ckey]'>PM</a>"
