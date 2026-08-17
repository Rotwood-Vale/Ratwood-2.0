/client/proc/fenysha_change_title_screen()
	set category = "Fun"
	set name = "Title Screen: Change"
	set desc = "Upload a new title screen image, or reroll the configured pool."
	if(!check_rights(R_FUN))
		return

	log_admin("[key_name(src)] is changing the title screen.")
	message_admins("[key_name_admin(src)] is changing the title screen.")

	switch(alert(usr, "Please select a new title screen.", "Title Screen", "Change", "Reset", "Cancel"))
		if("Change")
			var/file = input(usr) as icon|null
			if(!file)
				return
			SStitlescreen.change_title_screen(fcopy_rsc(file))
		if("Reset")
			SStitlescreen.change_title_screen()

/client/proc/fenysha_set_title_notice()
	set category = "Fun"
	set name = "Title Screen: Set Notice"
	set desc = "Sets a big red notice across the title screen."
	if(!check_rights(R_FUN))
		return

	var/new_notice = input(usr, "Notice to display on the title screen:", "Title Screen Notice") as text|null

	log_admin("[key_name(src)] set the title screen notice to: [new_notice]")
	message_admins("[key_name_admin(src)] set the title screen notice.")

	SStitlescreen.set_notice(new_notice)
	if(!new_notice)
		return
	for(var/mob/dead/new_player/player in GLOB.new_player_list)
		to_chat(player, span_boldannounce("TITLE NOTICE UPDATED: [new_notice]"))

/client/proc/fenysha_fix_title_screen()
	set category = "Admin"
	set name = "Fix Title Screen"
	set desc = "Re-sends the title screen if it has broken for someone."
	if(!check_rights(R_ADMIN))
		return

	if(istype(mob, /mob/dead/new_player))
		var/mob/dead/new_player/player = mob
		player.show_title_screen()
	else
		winset(src, TITLE_BROWSER_ID, "is-disabled=true;is-visible=false")

/client/proc/fenysha_set_title_html()
	set category = "Debug"
	set name = "Title Screen: Set HTML"
	set desc = "Replace the title screen preamble markup at runtime."
	if(!check_rights(R_DEBUG))
		return

	var/new_html = input(usr, "Desired preamble HTML. This will break the screen if you get it wrong.", "Title HTML Edit") as message|null
	if(!new_html)
		return

	SStitlescreen.title_html = new_html
	SStitlescreen.show_title_screen()

	log_admin("[key_name(src)] changed the title screen HTML.")
	message_admins("[key_name_admin(src)] changed the title screen HTML.")
