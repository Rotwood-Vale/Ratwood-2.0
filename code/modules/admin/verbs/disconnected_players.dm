GLOBAL_DATUM_INIT(disconnected_players_panel, /datum/disconnected_players_panel, new)

/client/proc/disconnected_players_panel()
	set category = "-Admin-"
	set name = "Disconnected Players"
	set desc = "List players in a deep slumber and fartravel them."

	if(!check_rights(R_ADMIN))
		return
	GLOB.disconnected_players_panel.ui_interact(usr)
	SSblackbox.record_feedback("tally", "admin_verb", 1, "Disconnected Players")

/datum/disconnected_players_panel

/datum/disconnected_players_panel/ui_state(mob/user)
	return ADMIN_STATE(R_ADMIN)

/datum/disconnected_players_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "DisconnectedPlayers", "Disconnected Players")
		ui.set_autoupdate(FALSE)
		ui.open()

/// Returns TRUE if the mob is a character whose player has disconnected (not ghosted, shapeshifted away or scrying).
/datum/disconnected_players_panel/proc/is_disconnected(mob/living/carbon/human/H)
	if(!istype(H) || QDELETED(H))
		return FALSE
	return H.is_disconnected_player()

/datum/disconnected_players_panel/ui_data(mob/user)
	var/list/players = list()
	for(var/mob/living/carbon/human/H as anything in GLOB.human_list)
		if(!is_disconnected(H))
			continue
		var/time_away = world.time - H.last_logout_time
		var/mob/living/carbon/human/body = ishuman(H.stored_mob) ? H.stored_mob : H
		players += list(list(
			"ref" = REF(H),
			"ckey" = H.ckey,
			// Wildshape forms already name themselves "form (real name)".
			"name" = (body == H || findtext(H.real_name, body.real_name)) ? H.real_name : "[body.real_name] (as [H.real_name])",
			"role" = H.get_disconnected_admin_alert_job_name(),
			"time_away" = time_away,
			"time_away_text" = DisplayTimeText(time_away, 1),
		))
	return list("players" = players)

/datum/disconnected_players_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/user = ui.user
	if(!check_rights_for(user.client, R_ADMIN))
		return TRUE

	switch(action)
		if("refresh")
			return TRUE

		if("player_panel")
			var/mob/living/carbon/human/H = locate(params["ref"])
			if(!istype(H) || QDELETED(H))
				to_chat(user, span_warning("That character no longer exists."))
				return TRUE
			user.client.holder.show_player_panel(H)
			return FALSE

		if("fartravel")
			fartravel(user, list(params["ref"]))
			return TRUE

		if("fartravel_selected")
			var/list/refs = params["refs"]
			if(!islist(refs) || !length(refs))
				return TRUE
			fartravel(user, refs)
			return TRUE

	return FALSE

/// Fartravels every still-disconnected character in refs, then writes one condensed admin log line.
/datum/disconnected_players_panel/proc/fartravel(mob/user, list/refs)
	var/list/targets = list()
	for(var/ref in refs)
		var/mob/living/carbon/human/H = locate(ref)
		if(is_disconnected(H))
			targets |= H
	if(!length(targets))
		to_chat(user, span_warning("None of the selected players are still in a deep slumber."))
		return

	var/prompt = length(targets) == 1 ? "Fartravel slumbering [key_name(targets[1])] and delete their character?" : "Fartravel [length(targets)] slumbering players and delete their characters?"
	if(tgui_alert(user, prompt, "Fartravel", list("Yes", "No")) != "Yes")
		return

	var/list/log_entries = list()
	for(var/mob/living/carbon/human/H as anything in targets)
		// They may have reconnected or been removed while the confirmation was open.
		if(!is_disconnected(H))
			continue
		log_entries += "[H.ckey] ([DisplayTimeText(world.time - H.last_logout_time, 1)])"
		H.admin_send_back_to_lobby(user, TRUE)
	if(!length(log_entries))
		to_chat(user, span_warning("None of the selected players are still in a deep slumber."))
		return

	var/entries = jointext(log_entries, ", ")
	log_admin("[key_name(user)] fartraveled [length(log_entries)] slumbering player\s: [entries]")
	message_admins(span_adminnotice("[key_name_admin(user)] fartraveled [length(log_entries)] slumbering player\s: [entries]"))
