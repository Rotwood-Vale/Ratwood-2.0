/// Right-click admin verb. Opens an empty window; nothing is read until the admin presses Generate Logs.
/client/proc/view_forensics(obj/O as obj in view())
	set category = null
	set name = "View Forensics"
	set desc = "List the players who have opened, locked, picked, broken or touched this."
	if(!check_rights(R_ADMIN))
		return
	if(QDELETED(O))
		return
	var/datum/forensics_viewer/viewer = new(O)
	viewer.ui_interact(usr)

/// One admin's View Forensics window on one object, deleted when the window closes.
/datum/forensics_viewer
	var/datum/weakref/target_ref
	var/target_name
	/// Snapshot from the last Generate Logs press, or null before the first
	var/list/report

/datum/forensics_viewer/New(atom/target)
	target_ref = WEAKREF(target)
	target_name = "[target]"

/datum/forensics_viewer/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/forensics_viewer/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "ViewForensics", "Forensics: [target_name]")
		ui.set_autoupdate(FALSE)
		ui.open()

/datum/forensics_viewer/ui_close(mob/user)
	qdel(src)

/datum/forensics_viewer/ui_data(mob/user)
	return list(
		"target_name" = target_name,
		"report" = report,
	)

/datum/forensics_viewer/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/user = ui.user

	switch(action)
		if("generate")
			var/atom/target = target_ref.resolve()
			if(QDELETED(target))
				to_chat(user, span_warning("[target_name] no longer exists."))
				return TRUE
			log_admin("[key_name(user)] generated the forensics of [target] at [AREACOORD(target)].")
			report = forensics_report(target)
			return TRUE

		if("jump")
			var/atom/target = target_ref.resolve()
			var/turf/T = get_turf(target)
			if(!T)
				to_chat(user, span_warning("[target_name] no longer exists."))
				return FALSE
			// Mirror the behaviour of the adminplayerobservecoodjump href
			var/client/C = user.client
			if(!isobserver(user))
				C.admin_ghost()
			C.jumptocoord(T.x, T.y, T.z)
			return FALSE

		if("pp")
			var/target_ckey = ckey(params["ckey"])
			var/mob/target_mob = forensics_find_mob(target_ckey)
			if(!target_mob)
				to_chat(user, span_warning("[target_ckey] has no mob in the round."))
				return FALSE
			user.client.holder.show_player_panel(target_mob)
			return FALSE

		if("pm")
			user.client.cmd_admin_pm(ckey(params["ckey"]), null)
			return FALSE

	return FALSE

/// Text goes to tgui decoded, which escapes it itself. Stored text is a mix of raw and html_encoded, see log_normalize_html().
/proc/forensics_report(atom/A)
	var/datum/component/forensics/D = A.GetComponent(/datum/component/forensics)
	var/list/actions = list()
	for(var/list/entry as anything in forensics_actions_newest_first(D))
		actions += list(list(
			// Same format as the stat panel's ROUND TIME
			"time" = time2text(entry["time"], "hh:mm:ss", 0),
			"ckey" = entry["ckey"],
			"name" = html_decode(entry["name"]),
			"action" = html_decode(entry["action"]),
			"count" = entry["count"],
		))
	var/list/touches = list()
	var/list/touches_by_ckey = forensics_touches_by_ckey(D)
	for(var/touch_ckey in touches_by_ckey)
		var/list/touch = touches_by_ckey[touch_ckey]
		touches += list(list(
			"ckey" = touch_ckey,
			"first" = html_decode(touch["First"]),
			"last" = touch["Last"] ? html_decode(touch["Last"]) : null,
		))
	return list(
		"generated_at" = time2text(STATION_TIME_PASSED(), "hh:mm:ss", 0),
		"type" = "[A.type]",
		"location" = AREACOORD(A),
		"actions" = actions,
		"touches" = touches,
		"last_toucher" = A.fingerprintslast,
	)

/// Both action lists interleaved by time, newest first. Each list is already oldest first.
/proc/forensics_actions_newest_first(datum/component/forensics/D)
	. = list()
	var/evidence_index = LAZYLEN(D?.actions)
	var/routine_index = LAZYLEN(D?.routine_actions)
	while(evidence_index || routine_index)
		var/list/evidence = evidence_index ? D.actions[evidence_index] : null
		var/list/routine = routine_index ? D.routine_actions[routine_index] : null
		if(evidence && (!routine || evidence["time"] >= routine["time"]))
			. += list(evidence)
			evidence_index--
		else
			. += list(routine)
			routine_index--

/// Hidden prints grouped by ckey, each list("First" = "name time", "Last" = "name time").
/// They are keyed by BYOND key, so one player can hold two, such as their own and an aghost's "@key".
/proc/forensics_touches_by_ckey(datum/component/forensics/D)
	var/list/touches = list()
	for(var/print_key in D?.hiddenprints)
		var/print_text = D.hiddenprints[print_key]
		if(!print_text)
			continue
		var/print_ckey = ckey(print_key)
		var/list/parsed = forensics_parse_touches(print_text)
		var/list/existing = touches[print_ckey]
		if(existing)
			existing["Last"] = parsed["Last"] || parsed["First"]
		else
			touches[print_ckey] = parsed
	return touches

/// Splits a hidden print, written by /datum/component/forensics/proc/add_hiddenprint(), into its first and last touch.
/// Anything that does not match that format is shown whole as the first touch.
/proc/forensics_parse_touches(print_text)
	var/static/regex/touch_regex = regex(@"(First|Last): (.*?)\[([^\]]*)\](\(gloves\))?\. Ckey: ", "g")
	var/list/parsed = list()
	var/start = 1
	while(touch_regex.Find(print_text, start))
		parsed[touch_regex.group[1]] = "[touch_regex.group[2]] [touch_regex.group[3]][touch_regex.group[4] ? " (gloves)" : ""]"
		start = touch_regex.next
	if(!length(parsed))
		parsed["First"] = print_text
	return parsed

/// Looked up when PP is pressed, not when the logs were generated, so it follows the player to whatever mob they are in now.
/proc/forensics_find_mob(target_ckey)
	var/client/target_client = GLOB.directory[target_ckey]
	if(target_client?.mob)
		return target_client.mob
	for(var/mob/candidate as anything in GLOB.mob_list)
		if(candidate.ckey == target_ckey)
			return candidate
