/client/proc/cmd_admin_say(msg as text)
	set category = "-Admin-"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 0
	if(!check_rights(0))
		return

	msg = emoji_parse(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)
		return

	mob.log_talk(msg, LOG_ASAY)
	var/raw_msg = msg // Store the raw message before keyword lookup for cross-server relay
	msg = keywords_lookup(msg)
	var/custom_asay_color = (CONFIG_GET(flag/allow_admin_asaycolor) && prefs.asaycolor) ? "<font color=[prefs.asaycolor]>" : "<font color='#FF4500'>"
	msg = "<span class='adminsay'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> [ADMIN_FLW(mob)]: [custom_asay_color]<span class='message linkify'>[msg]</span></span>[custom_asay_color ? "</font>":null]"
	to_chat(GLOB.admins, msg)

	// Send to other servers
	send_asay_to_other_servers(key_name(usr), raw_msg)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "Asay") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/// Sends admin say message to all configured cross-servers
/proc/send_asay_to_other_servers(sender, msg)
	var/comms_key = CONFIG_GET(string/comms_key)
	if(!comms_key)
		return
	var/list/message = list()
	message["sender"] = sender
	message["message"] = msg
	message["source"] = CONFIG_GET(string/cross_comms_name)
	message["key"] = comms_key
	message += "asay_relay"

	var/list/servers = CONFIG_GET(keyed_list/cross_server)
	for(var/server_name in servers)
		world.Export("[servers[server_name]]?[list2params(message)]")

/client/proc/get_admin_say()
	var/msg = input(src, null, "asay \"text\"") as text|null
	cmd_admin_say(msg)
