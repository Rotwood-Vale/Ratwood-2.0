/*
Real TGUI surface for the mercenary statue. Ported from Azure-Peak's talkstatue_tgui.dm
(Step 9f), replacing the input()-menu stopgap that Step 9e added to talkstatue_mercenary.dm.

ES port note (Step 9f): AP's talkstatue_tgui.dm is a *shared* surface across three roles -
Mercenary, Adventurer, and Wretch (bathhouse "wretch for hire" system) - all three talk to a
single /obj/structure/roguemachine/talkstatue/mercenary instance (AP's "mercenary" subtype is
really just "the statue type that has a TGUI", used as the anchor type for all three rosters).
ES has zero Adventurer or Wretch-for-hire framework under any name (confirmed exhaustively in
Step 9e), so this port is MERCENARY-ONLY:
  - adventurer_status / wretch_status registries, role_matches()/role_title() adventurer+wretch
    branches, message_single_adventurer(), message_single_wretch(), edit_wretch_nom_de_guerre(),
    leave_roster(), and the is_adv/is_wretch/is_bathhouse ui_data flags are ALL stubbed out below.
  - set_role_status()/edit_role_message() are kept as generic helpers (AP wrote them generically
    against "a registry" already) but are only ever called with mercenary_status here.
  - ui_data()/ui_act() only expose the mercenary fields/actions the frontend actually uses.
Porting the Adventurer/Wretch framework itself is out of scope for this step - flagged for a
future port if that framework is ever wanted in ES.
*/

/obj/structure/roguemachine/talkstatue/mercenary/ui_state(mob/user)
	return GLOB.human_adjacent_state

/obj/structure/roguemachine/talkstatue/mercenary/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "Talkstatue", name)
		ui.open()

/// Generic "set my status" helper - kept generic like AP's original since it takes the
/// registry/options as arguments, but only ever invoked against mercenary_status in ES.
/obj/structure/roguemachine/talkstatue/mercenary/proc/set_role_status(mob/living/carbon/human/user, list/registry, list/states, default_state, new_status)
	if(!(new_status in states))
		return
	var/list/data = registry[user.real_name]
	var/first_registration = FALSE
	if(!data)
		data = list("status" = default_state, "mob" = user, "message" = "")
		registry[user.real_name] = data
		first_registration = TRUE
	data["status"] = new_status
	data["mob"] = user
	// First mercenary registration via the TGUI also grants the from-afar message-recall link,
	// mirroring the old (now-superseded) register= Topic branch in talkstatue_mercenary.dm.
	if(first_registration && registry == mercenary_status && user.key)
		to_chat(user, span_notice("I can visit the statue in person to change my status, or <a href='?src=[REF(src)];set_message_remote=[REF(user)]'>recall my mercenary message</a> from afar. (This link expires in 2 minutes)"))
		pending_message_links[user.key] = user
		addtimer(CALLBACK(src, PROC_REF(expire_message_link), user.key), 2 MINUTES)
	to_chat(user, span_notice("I set my status to: <b>[new_status]</b>"))
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	log_admin_private("[key_name(user)] set statue status to [new_status]")

/// Generic "edit my custom message" helper - same story as set_role_status(), mercenary-only
/// in practice here.
/obj/structure/roguemachine/talkstatue/mercenary/proc/edit_role_message(mob/living/carbon/human/user, list/registry, default_state)
	var/list/data = registry[user.real_name]
	if(!data)
		data = list("status" = default_state, "mob" = user, "message" = "")
		registry[user.real_name] = data
	var/current_msg = data["message"] || ""
	var/new_msg = stripped_input(user, "Enter my custom message (max [message_char_limit] characters):", "Statue Message", current_msg, message_char_limit)
	if(new_msg == null)
		return
	if(!Adjacent(user))
		to_chat(user, span_warning("I moved too far from the statue."))
		return
	data["message"] = new_msg
	to_chat(user, span_notice("My statue message has been updated."))
	playsound(loc, 'sound/misc/beep.ogg', 100, FALSE, -1)
	log_admin_private("[key_name(user)] set statue custom message: \"[new_msg]\"")

/// AP's role_title()/role_matches() also handled Adventurer/migrant-role/Wretch/Bathhouse
/// matching. ES has none of that machinery, so this is trimmed to just "is this user
/// currently registered/assigned as a Mercenary" via mind.assigned_role, matching the check
/// already used elsewhere in talkstatue_mercenary.dm (Topic() register handler).
/obj/structure/roguemachine/talkstatue/mercenary/proc/is_mercenary_role(mob/M)
	if(!ishuman(M) || !M.mind)
		return FALSE
	return M.mind.assigned_role == "Mercenary"

/obj/structure/roguemachine/talkstatue/mercenary/ui_data(mob/user)
	var/list/data = list()
	var/is_merc = is_mercenary_role(user)
	data["is_merc"] = is_merc ? TRUE : FALSE
	var/mob/living/carbon/human/HU = user
	data["my_key"] = ishuman(user) ? HU.real_name : ""
	data["message_char_limit"] = message_char_limit

	data["merc_status_options"] = list("Available", "Contracted", "Do not Disturb")
	data["mercenaries"] = roster_payload(mercenary_status)
	return data

/obj/structure/roguemachine/talkstatue/mercenary/proc/roster_payload(list/registry)
	var/list/out = list()
	for(var/key in registry)
		var/list/d = registry[key]
		var/mob/living/carbon/human/M = d["mob"]
		if(!M)
			continue
		out += list(list(
			"key" = key,
			"name" = M.real_name,
			"status" = d["status"] || "Available",
			"message" = d["message"] || "",
			"advjob" = M.advjob || "",
		))
	return out

/obj/structure/roguemachine/talkstatue/mercenary/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()
	if(.)
		return
	if(!ishuman(usr))
		return
	var/mob/living/carbon/human/H = usr
	if(!Adjacent(H))
		to_chat(H, span_warning("I need to be closer to the statue."))
		return
	var/is_merc = is_mercenary_role(H)
	switch(action)
		if("set_merc_status")
			if(!is_merc)
				return
			set_role_status(H, mercenary_status, list("Available", "Contracted", "Do not Disturb"), "Available", params["status"])
			return TRUE
		if("edit_merc_message")
			if(!is_merc)
				return
			edit_role_message(H, mercenary_status, "Available")
			return TRUE
		if("contact_merc")
			message_single_mercenary(H)
			return TRUE
		if("broadcast_mercs")
			broadcast_to_mercenaries(H)
			return TRUE
