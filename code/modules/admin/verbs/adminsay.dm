/client/proc/cmd_admin_say(msg as text)
	set category = "-Admin-"
	set name = "Asay" //Gave this shit a shorter name so you only have to time out "asay" rather than "admin say" to use it --NeoFite
	set hidden = 0
	admin_say(msg)

/client/proc/admin_say(msg, loud = FALSE)
	if(!check_rights(0))
		return

	msg = emoji_parse(copytext(sanitize(msg), 1, MAX_MESSAGE_LEN))
	if(!msg)
		return

	mob.log_talk(msg, LOG_ASAY)

	var/list/mentioned = list()
	var/regex/mention_regex = regex(@"@([\w.-]+)", "g")
	while(!loud && mention_regex.Find(msg))
		var/partial = ckey(mention_regex.group[1])
		if(length(partial) < 3)
			continue
		for(var/client/admin_client as anything in GLOB.admins)
			if(findtext(admin_client.ckey, partial))
				mentioned |= admin_client

	msg = keywords_lookup(msg)
	var/custom_asay_color = (CONFIG_GET(flag/allow_admin_asaycolor) && prefs.asaycolor) ? "<font color=[prefs.asaycolor]>" : "<font color='#FF4500'>"
	msg = "<span class='adminsay'><span class='prefix'>ADMIN:</span> <EM>[key_name(usr, 1)]</EM> [ADMIN_FLW(mob)]: [custom_asay_color]<span class='message linkify'>[msg]</span></span>[custom_asay_color ? "</font>":null]"
	to_chat(GLOB.admins - mentioned, type = MESSAGE_TYPE_ADMINCHAT, html = loud ? span_big(msg) : msg)
	if(length(mentioned))
		to_chat(mentioned, type = MESSAGE_TYPE_ADMINCHAT, html = span_big(msg))
		for(var/client/mentioned_client as anything in mentioned)
			window_flash(mentioned_client, ignorepref = TRUE)

	if(loud)
		for(var/client/admin_client as anything in GLOB.admins)
			SEND_SOUND(admin_client, sound('sound/misc/duckhonk.ogg'))
			window_flash(admin_client, ignorepref = TRUE)

	SSblackbox.record_feedback("tally", "admin_verb", 1, "[loud ? "LoudAsay" : "Asay"]") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/get_admin_say()
	var/msg = input(src, null, "asay \"text\"") as text|null
	cmd_admin_say(msg)

/client/proc/cmd_loud_admin_say(msg as text)
	set category = "-Admin-"
	set name = "LoudAsay"
	set hidden = 0
	admin_say(msg, loud = TRUE)
