// this code is fun. the typescript was not. I fucking hate typescript bro.
/datum/ui_state/fax_panel_state

/datum/ui_state/fax_panel_state/can_use_topic(src_object, mob/user)
	if(check_rights_for(user.client, R_ADMIN))
		return UI_INTERACTIVE
	return UI_CLOSE

GLOBAL_DATUM_INIT(fax_panel_state, /datum/ui_state/fax_panel_state, new)
GLOBAL_DATUM_INIT(fax_panel, /datum/fax_panel, new)

/datum/fax_panel

/datum/fax_panel/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "FaxPanel", "Admin Letter Panel")
		ui.open()

/datum/fax_panel/ui_data(mob/user)
	var/list/data = list()

	// Build HERMES machine list
	var/list/hermes_list = list()
	for(var/obj/structure/roguemachine/mail/H in SSroguemachine.hermailers)
		hermes_list += list(list(
			"num" = H.ournum,
			"tag" = H.mailtag || "",
		))
	data["hermes_list"] = hermes_list

	// Build online player list (by real_name)
	var/list/player_list = list()
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.real_name && H.client)
			player_list |= H.real_name
	data["player_list"] = player_list

	data["master_exists"] = SSroguemachine.hermailermaster ? TRUE : FALSE

	return data

/datum/fax_panel/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	if(..())
		return TRUE

	switch(action)
		if("send")
			var/mob/user = ui.user
			if(!check_rights_for(user.client, R_ADMIN))
				return TRUE

			var/sender    = sanitize(params["sender"])
			// Body comes through as raw text from tgui; so we allow HTML.
			// Only convert newlines → <br> so line breaks survive BYOND's dogshit browser.
			var/body=replacetext(params["body"] || "", "\n", "<br>")
			body=copytext(body, 1, 5001) // cap at 5000 chars
			var/stamp=params["stamp"]
			var/rim=params["rim"]
			var/send_mode=params["send_mode"]    // "player" or "hermes"
			var/recipient=sanitize(params["recipient"])
			var/hermes_num=text2num(params["hermes_num"])
			var/item_path_str=trim(params["item_path"] || "")
			var/item_name_override=sanitize(params["item_name"] || "")
			var/item_desc_override=sanitize(params["item_desc"] || "")
			var/package_size=max(1, min(6, text2num(params["package_size"]) || 0))

			if(!sender)
				sender = "Anonymous"
			if(!body && !stamp && !item_path_str)
				return TRUE

			var/note_content = (body || stamp) ? fax_build_content(body, stamp, sender) : null
			var/rim_css = fax_rim_body_css(rim)

			if(item_path_str)
				var/parcel_type = text2path(item_path_str)
				if(!parcel_type || !ispath(parcel_type, /obj/item))
					to_chat(user, span_warning("Invalid item path: '[item_path_str]'"))
					return TRUE
				if(send_mode == "hermes")
					return fax_send_parcel_to_hermes(user, note_content, rim_css, sender, parcel_type, hermes_num, item_name_override, item_desc_override, package_size)
				else
					return fax_send_parcel_to_player(user, note_content, rim_css, sender, parcel_type, recipient, item_name_override, item_desc_override, package_size)

			var/dest_label = send_mode == "hermes" ? "HERMES #[hermes_num]" : recipient
			if(send_mode == "hermes")
				return fax_send_to_hermes(user, note_content, rim_css, sender, hermes_num, dest_label)
			else
				return fax_send_to_player(user, note_content, rim_css, sender, recipient)

	return FALSE

/// Builds the letter HTML: parchment bg + sender header + body + stamp. You wouldn't believe where I copypasted this from.
/datum/fax_panel/proc/fax_build_content(body, stamp, sender)
	var/inner = ""

	// Sender header
	inner += "<p style='margin:0 0 6px 0;font-style:italic;color:#5a3e1b;border-bottom:1px solid #c8aa7a;padding-bottom:4px;'>From: [sender]</p>"

	// Body
	if(body)
		inner += "<p style='margin:8px 0;font-family:serif;color:#2c1a0e;'>[body]</p>"

	// Stamp
	var/stamp_html = fax_stamp_html(stamp)
	if(stamp_html)
		inner += stamp_html

	return "<div style='background:#fdf6e3;padding:12px;font-family:serif;min-height:100%;box-sizing:border-box;'>[inner]</div>"

/datum/fax_panel/proc/fax_rim_body_css(rim)
	switch(rim)
		if("simple")
			return "border:8px solid #2c1a0e;"
		if("ornate")
			return "border:12px double #8b6914;box-shadow:inset 0 0 14px #c9a84c;"
		if("royal")
			return "border:10px solid #4a1a6e;box-shadow:inset 0 0 16px #7a3db5;"
		if("inquisition")
			return "border:10px solid #6b0000;box-shadow:inset 0 0 14px #8b0000;"
	return ""


/datum/fax_panel/proc/fax_stamp_html(stamp)
	switch(stamp)
		if("royal")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-block;width:72px;height:72px;border-radius:50%;border:3px solid #4a1a6e;background:#f9f3e3;line-height:66px;font-size:9px;font-weight:bold;color:#4a1a6e;letter-spacing:1px;'>** ROYAL **</div></div>"
		if("inquisitor")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-block;width:72px;height:72px;border-radius:50%;border:3px solid #6b0000;background:#fff8f5;line-height:66px;font-size:9px;font-weight:bold;color:#6b0000;'>+ OTAVAN +</div></div>"
		if("merchant")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-block;width:72px;height:72px;border-radius:50%;border:3px solid #8b6914;background:#fdfbe8;line-height:66px;font-size:9px;font-weight:bold;color:#8b6914;'>~ GUILD ~</div></div>"
		if("steward")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-block;width:72px;height:72px;border-radius:50%;border:3px solid #1a3a1a;background:#f5fdf5;line-height:66px;font-size:9px;font-weight:bold;color:#1a3a1a;'>~ STEWARD ~</div></div>"
		if("kingsfield")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-flex;width:72px;height:72px;border-radius:50%;border:3px solid #1a2e4a;background:#eef4ff;flex-direction:column;align-items:center;justify-content:center;font-size:8px;font-weight:bold;color:#1a2e4a;'><span>CITY OF</span><span>KINGSFIELD</span></div></div>"
		if("kf_academy")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-flex;width:72px;height:72px;border-radius:50%;border:3px double #2a0a6e;background:#f4f0ff;flex-direction:column;align-items:center;justify-content:center;font-size:7px;font-weight:bold;color:#2a0a6e;box-shadow:inset 0 0 8px #8060d0;'><span>KINGSFIELD</span><span>ACADEMY</span></div></div>"
		if("kf_army")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-flex;width:72px;height:72px;border-radius:50%;border:3px solid #1c1c1c;background:#e8e8ec;flex-direction:column;align-items:center;justify-content:center;font-size:7px;font-weight:bold;color:#1c1c1c;letter-spacing:1px;'><span>KINGSFIELD</span><span>ARMY</span></div></div>"
		if("kf_tax")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-flex;width:72px;height:72px;border-radius:50%;border:2px solid #6b4400;background:#fffae8;flex-direction:column;align-items:center;justify-content:center;font-size:6px;font-weight:bold;color:#6b4400;line-height:1.5;'><span>KINGSFIELD</span><span>TAXATION</span><span>OFFICE</span></div></div>"
		if("kf_council")
			return "<div style='text-align:center;margin-top:12px;'><div style='display:inline-flex;width:88px;height:88px;border-radius:50%;border:4px double #8b6914;background:#fffdf0;flex-direction:column;align-items:center;justify-content:center;font-size:9px;font-weight:bold;color:#7a5500;box-shadow:inset 0 0 12px #e0b840,0 0 6px #c9a84c;'><span>HIGH</span><span>COUNCIL</span></div></div>"
	return ""

/// Routes a fax directly to a HERMES machine by number.
/datum/fax_panel/proc/fax_send_to_hermes(mob/user, content, rim_css, sender, hermes_num, dest_label)
	var/found = FALSE
	for(var/obj/structure/roguemachine/mail/X in SSroguemachine.hermailers)
		if(X.ournum == hermes_num)
			var/obj/item/paper/P = new(X.loc)
			P.info = content
			P.window_rim_style = rim_css
			P.mailer = sender
			P.mailedto = "#[hermes_num][X.mailtag ? " ([X.mailtag])" : ""]"
			P.update_icon()
			X.say("New mail!")
			playsound(X, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			found = TRUE
			break
	if(!found)
		to_chat(user, span_warning("HERMES #[hermes_num] not found."))
		return FALSE
	log_admin("[key_name(user)] sent admin letter to HERMES #[hermes_num] from '[sender]'.")
	message_admins("[key_name_admin(user)] sent an admin letter to HERMES #[hermes_num] from '[sender]'.")
	return TRUE

/// Routes a fax to a player by name through the mastermail.
/datum/fax_panel/proc/fax_send_to_player(mob/user, content, rim_css, sender, recipient)
	if(!recipient)
		return FALSE
	if(!SSroguemachine.hermailermaster)
		to_chat(user, span_warning("The master mailer doesn't exist. Can't send by name."))
		return FALSE
	var/obj/item/roguemachine/mastermail/X = SSroguemachine.hermailermaster
	var/obj/item/paper/P = new(X.loc)
	P.info = content
	P.window_rim_style = rim_css
	P.mailer = sender
	P.mailedto = recipient
	P.update_icon()
	var/datum/component/storage/STR = X.GetComponent(/datum/component/storage)
	STR.handle_item_insertion(P, prevent_warning=TRUE)
	X.new_mail = TRUE
	X.update_icon()
	send_ooc_note("New letter from <b>[sender].</b>", name = recipient)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.real_name == recipient)
			H.apply_status_effect(/datum/status_effect/ugotmail)
			H.playsound_local(H, 'sound/misc/mail.ogg', 100, FALSE, -1)
			break
	log_admin("[key_name(user)] sent admin letter to '[recipient]' from '[sender]'.")
	message_admins("[key_name_admin(user)] sent an admin letter to '[recipient]' from '[sender]'.")
	return TRUE

/datum/fax_panel/ui_state(mob/user)
	return GLOB.fax_panel_state

/// Sends a parcel (item + optional letter note) to a HERMES machine.
/datum/fax_panel/proc/fax_send_parcel_to_hermes(mob/user, note_content, rim_css, sender, item_type, hermes_num, item_name_override, item_desc_override, package_size)
	var/found = FALSE
	for(var/obj/structure/roguemachine/mail/X in SSroguemachine.hermailers)
		if(X.ournum == hermes_num)
			var/turf/T = get_turf(X)
			var/obj/item/smallDelivery/D = new(T)
			var/obj/item/I = new item_type(T)
			if(item_name_override)
				I.name = item_name_override
			if(item_desc_override)
				I.desc = item_desc_override
			var/size = package_size ? package_size : max(1, min(5, round(I.w_class)))
			D.name = "[weightclass2text(min(size,5))] package"
			D.w_class = size
			D.icon_state = "deliverypackage[min(size,5)]"
			I.forceMove(D)
			if(note_content)
				var/obj/item/paper/note = new(T)
				note.info = note_content
				note.window_rim_style = rim_css
				note.update_icon()
				note.forceMove(D)
				D.note = note
			D.mailer = sender
			D.mailedto = "#[hermes_num][X.mailtag ? " ([X.mailtag])" : ""]"
			X.say("New mail!")
			playsound(X, 'sound/misc/hiss.ogg', 100, FALSE, -1)
			found = TRUE
			break
	if(!found)
		to_chat(user, span_warning("HERMES #[hermes_num] not found."))
		return FALSE
	log_admin("[key_name(user)] sent admin parcel ([item_type]) to HERMES #[hermes_num] from '[sender]'.")
	message_admins("[key_name_admin(user)] sent an admin parcel ([item_type]) to HERMES #[hermes_num] from '[sender]'.")
	return TRUE

/// Sends a parcel (item + optional letter note) to a player through the mastermail.
/datum/fax_panel/proc/fax_send_parcel_to_player(mob/user, note_content, rim_css, sender, item_type, recipient, item_name_override, item_desc_override, package_size)
	if(!recipient)
		return FALSE
	if(!SSroguemachine.hermailermaster)
		to_chat(user, span_warning("The master mailer doesn't exist. Can't send by name."))
		return FALSE
	var/obj/item/roguemachine/mastermail/X = SSroguemachine.hermailermaster
	var/turf/T = get_turf(X)
	var/obj/item/smallDelivery/D = new(T)
	var/obj/item/I = new item_type(T)
	if(item_name_override)
		I.name = item_name_override
	if(item_desc_override)
		I.desc = item_desc_override
	var/size = package_size ? package_size : max(1, min(5, round(I.w_class)))
	D.name = "[weightclass2text(min(size,5))] package"
	D.w_class = size
	D.icon_state = "deliverypackage[min(size,5)]"
	I.forceMove(D)
	if(note_content)
		var/obj/item/paper/note = new(T)
		note.info = note_content
		note.window_rim_style = rim_css
		note.update_icon()
		note.forceMove(D)
		D.note = note
	D.mailer = sender
	D.mailedto = recipient
	var/datum/component/storage/STR = X.GetComponent(/datum/component/storage)
	STR.handle_item_insertion(D, prevent_warning=TRUE)
	X.new_mail = TRUE
	X.update_icon()
	send_ooc_note("New parcel from <b>[sender].</b>", name = recipient)
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.real_name == recipient)
			H.apply_status_effect(/datum/status_effect/ugotmail)
			H.playsound_local(H, 'sound/misc/mail.ogg', 100, FALSE, -1)
			break
	log_admin("[key_name(user)] sent admin parcel ([item_type]) to '[recipient]' from '[sender]'.")
	message_admins("[key_name_admin(user)] sent an admin parcel ([item_type]) to '[recipient]' from '[sender]'.")
	return TRUE

// Admin verb
/client/proc/open_fax_panel()
	set category = "-Admin-"
	set name = "Letter Panel"
	if(!check_rights(R_ADMIN))
		return
	GLOB.fax_panel.ui_interact(mob)
