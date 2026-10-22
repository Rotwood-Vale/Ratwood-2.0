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

/datum/disconnected_players_panel/ui_data(mob/user)
	var/list/players = list()
	// Not just humans: a spell shapeshift form is a simple mob carrying the caster's body.
	for(var/mob/living/L as anything in GLOB.mob_living_list)
		if(!L.is_disconnected_player())
			continue
		var/mob/living/carbon/human/body = L.get_real_body()
		if(!body)
			continue
		var/time_away = world.time - L.last_logout_time
		players += list(list(
			"ref" = REF(L),
			"ckey" = L.ckey,
			// Wildshape forms already name themselves "form (real name)".
			"name" = (body == L || findtext(L.real_name, body.real_name)) ? L.real_name : "[body.real_name] (as [L.real_name])",
			"role" = L.get_disconnected_admin_alert_job_name(),
			"time_away" = time_away,
			"time_away_text" = DisplayTimeText(time_away, 1),
		))
	return list("players" = players)

/datum/disconnected_players_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE
	var/mob/user = ui.user

	switch(action)
		if("refresh")
			return TRUE

		if("player_panel")
			var/mob/living/L = locate(params["ref"])
			if(!istype(L) || QDELETED(L))
				to_chat(user, span_warning("That character no longer exists."))
				return TRUE
			user.client.holder.show_player_panel(L)
			return FALSE

		if("follow")
			var/mob/living/L = locate(params["ref"])
			if(!istype(L) || QDELETED(L))
				to_chat(user, span_warning("That character no longer exists."))
				return TRUE
			// Mirror the behaviour of the adminplayerobservefollow href
			var/client/C = user.client
			if(!isobserver(user) && !C.admin_ghost())
				return FALSE
			var/mob/dead/observer/A = C.mob
			if(!istype(A))
				return FALSE
			A.ManualFollow(L)
			return FALSE

		if("fartravel")
			var/list/targets = params["targets"]
			if(!islist(targets) || !length(targets))
				return TRUE
			fartravel(user, targets)
			return TRUE

	return FALSE

/// Returns the mobs in targets (REF -> ckey) that are still in a deep slumber.
/// The panel does not auto-update and refs are reused once a mob is deleted, so the ckey must still match.
/datum/disconnected_players_panel/proc/resolve_targets(list/targets)
	. = list()
	for(var/ref in targets)
		var/mob/living/L = locate(ref)
		if(!istype(L) || QDELETED(L) || L.ckey != targets[ref])
			continue
		if(L.is_disconnected_player() && L.get_real_body())
			. |= L

/// Fartravels every character in targets (REF -> ckey) that is still in a deep slumber.
/datum/disconnected_players_panel/proc/fartravel(mob/user, list/targets)
	var/list/slumbering = resolve_targets(targets)
	if(!length(slumbering))
		to_chat(user, span_warning("None of the selected players are still in a deep slumber."))
		return

	var/list/names = list()
	for(var/mob/living/L as anything in slumbering)
		var/mob/living/carbon/human/body = L.get_real_body()
		names += "[L.ckey] ([body.real_name])"
	var/prompt = length(slumbering) == 1 ? "Fartravel slumbering [names[1]] and delete their character?" : "Fartravel these [length(slumbering)] slumbering players and delete their characters? [jointext(names, ", ")]"
	if(tgui_alert(user, prompt, "Fartravel", list("Yes", "No")) != "Yes")
		return

	// They may have reconnected or been removed while the confirmation was open.
	slumbering &= resolve_targets(targets)
	var/list/fartraveled = list()
	for(var/mob/living/L as anything in slumbering)
		var/time_away = DisplayTimeText(world.time - L.last_logout_time, 1)
		// Logged before deletion so the record survives a runtime partway through the batch.
		log_admin("[key_name(user)] has fartraveled slumbering [key_name(L)] after [time_away] in a deep slumber.")
		fartraveled += "[L.ckey] ([time_away])"
		L.admin_fartravel(user)
	if(!length(fartraveled))
		to_chat(user, span_warning("None of the selected players are still in a deep slumber."))
		return
	message_admins(span_adminnotice("[key_name_admin(user)] fartraveled [length(fartraveled)] slumbering player\s: [jointext(fartraveled, ", ")]"))
