//Dead mobs can exist whenever. This is needful

INITIALIZE_IMMEDIATE(/mob/dead)

/mob/dead
	sight = SEE_TURFS | SEE_MOBS | SEE_OBJS | SEE_SELF
	move_resist = INFINITY
	throwforce = 0

/mob/dead/Initialize()
	SHOULD_CALL_PARENT(FALSE)
	if(flags_1 & INITIALIZED_1)
		stack_trace("Warning: [src]([type]) initialized multiple times!")
	flags_1 |= INITIALIZED_1
	tag = "mob_[next_mob_id++]"
	GLOB.mob_list += src

	prepare_huds()

	if(length(CONFIG_GET(keyed_list/cross_server)))
		verbs += /mob/dead/proc/server_hop
	set_focus(src)
	return INITIALIZE_HINT_NORMAL

/mob/dead/Destroy()
	GLOB.mob_list -= src
	return ..()

/mob/dead/canUseStorage()
	return FALSE

/mob/dead/dust(just_ash, drop_items, force)	//ghosts can't be vaporised.
	return

/mob/dead/gib()		//ghosts can't be gibbed.
	return

/mob/dead/ConveyorMove()	//lol
	return

/mob/dead/forceMove(atom/destination)
	var/turf/old_turf = get_turf(src)
	var/turf/new_turf = get_turf(destination)
	if (old_turf?.z != new_turf?.z)
		onTransitZ(old_turf?.z, new_turf?.z)
	var/oldloc = loc
	loc = destination
	Moved(oldloc, NONE, TRUE)


/mob/dead/new_player/proc/lobby_refresh()
	set waitfor = 0
	if(!client)
		return

	if(client.is_new_player())
		return

	if(SSticker.HasRoundStarted())
		src << browse(null, "window=lobby_window")
		return
	if(!winexists(src, "lobby_window"))
		open_lobby()  // creates window + browser control
		sleep(0)
	var/lobby_visible = winget(src, "lobby_window", "is-visible")
	if(lobby_visible == "false") // winget returns a string...
		src << browse(null, "window=lobby_window")
		open_lobby()
		sleep(0)

	// UPDATE TIMER -- Script in html\lobby\lobby.html / .js
	var/timer_text
	var/time_remaining = SSticker.GetTimeLeft()
	if (time_remaining > 0)
		timer_text = "Time To Start: [round(time_remaining/10)]s"
	else if (time_remaining == -10)
		timer_text = "Time To Start: DELAYED"
	else
		timer_text = "Time To Start: SOON"
		src << browse(null, "window=lobby_window")
		return
	src << output(timer_text, "lobby_window.browser:update_timer")

	// Update players ready!!
	src << output(
	"Total players ready: [SSticker.totalPlayersReady]",
	"lobby_window.browser:update_ready_count"
	)
	// Ready bonus
	var/bonus_html
	if (src.ready)
		bonus_html = span_good("Ready Bonus!")
	else
		bonus_html = span_highlight("No bonus! Ready up!")
	src << output(bonus_html, "lobby_window.browser:update_ready_bonus")
	var/list/dat = list()
	var/list/ready_players_by_job = list()
	var/list/wanderer_jobs = list(
		"Adventurer",
		"Wretch",
		"Court Agent"
	)
	dat += "<center><b>Classes:</b></center><hr>"
	for (var/mob/dead/new_player/player in GLOB.player_list)
		if (player.client?.ckey in GLOB.hiderole)
			continue
		var/job_choice = player.client?.prefs?.job_preferences
		if (job_choice)
			for (var/job_name in job_choice)
				if (job_choice[job_name] == JP_HIGH)
					if (job_name in wanderer_jobs)
						job_name = "Wanderer"
					if (player.ready == PLAYER_READY_TO_PLAY)
						if (!ready_players_by_job[job_name])
							ready_players_by_job[job_name] = list()
						ready_players_by_job[job_name] += player.client.prefs.real_name
						break

	var/list/job_list_by_department = list( // Oorah Key value pair
		"Noblemen" = list(), // High nobility
		"Courtiers" = list(), // Low Nobility
		"Garrison" = list(), // Retinue
		"Church" = list(), // Clergy
		"Inquisition" = list(), // Inq
		"Yeomen" = list(), // Workers
		"Guildsmen" = list(), // Guildsmen
		"Peasants" = list(), // Pheasants (the birb)
		"Sidefolk" = list(), // Side strugglers
		"Wanderers" = list(), // Nobodies.
	)
	for(var/job_name in ready_players_by_job)
		var/datum/job/J = SSjob.GetJob(job_name)
		var/key
		if(!J)
			key = SSjob.bitflag_to_department(WANDERER, TRUE)
		else
			key = SSjob.bitflag_to_department(J.department_flag)

		var/list/job_players = ready_players_by_job[job_name]
		job_list_by_department[key] += "<B>[job_name]</B> ([job_players.len]) - [job_players.Join(", ")]<br>"

	for(var/department in job_list_by_department)
		var/list/jobs_under_department = job_list_by_department[department]
		if(jobs_under_department.len)
			sortTim(jobs_under_department, cmp = GLOBAL_PROC_REF(cmp_text_asc))
			dat += "<h3><center><font color='[JCOLOR_BY_DEPARTMENT[department]]'>----- [department] -----</font></center></h3>"
			dat += jobs_under_department

	src << output(dat.Join(), "lobby_window.browser:update_jobs")

/mob/dead/new_player/proc/open_lobby()
	if (!client)
		return
	src << browse(
		file("html/lobby/lobby.html"),
		"window=lobby_window;size=330x430"
	)
/mob/dead/proc/server_hop()
	set category = "OOC"
	set name = "Server Hop!"
	set desc= "Jump to the other server"
	set hidden = 1
	if(notransform)
		return
	var/list/csa = CONFIG_GET(keyed_list/cross_server)
	var/pick
	switch(csa.len)
		if(0)
			verbs -= /mob/dead/proc/server_hop
			to_chat(src, span_notice("Server Hop has been disabled."))
		if(1)
			pick = csa[1]
		else
			pick = input(src, "Pick a server to jump to", "Server Hop") as null|anything in csa

	if(!pick)
		return

	var/addr = csa[pick]

	if(alert(src, "Jump to server [pick] ([addr])?", "Server Hop", "Yes", "No") != "Yes")
		return

	var/client/C = client
	to_chat(C, span_notice("Sending you to [pick]."))
	new /atom/movable/screen/splash(C)

	notransform = TRUE
	sleep(29)	//let the animation play
	notransform = FALSE

	if(!C)
		return

	winset(src, null, "command=.options") //other wise the user never knows if byond is downloading resources

	C << link("[addr]?server_hop=[key]")

/mob/dead/proc/update_z(new_z) // 1+ to register, null to unregister
	if (registered_z != new_z)
		if (registered_z)
			SSmobs.dead_players_by_zlevel[registered_z] -= src
		if (client)
			if (new_z)
				SSmobs.dead_players_by_zlevel[new_z] += src
			registered_z = new_z
		else
			registered_z = null

/mob/dead/Login()
	. = ..()
	var/turf/T = get_turf(src)
	if (isturf(T))
		update_z(T.z)

/mob/dead/auto_deadmin_on_login()
	return

/mob/dead/Logout()
	update_z(null)
	return ..()

/mob/dead/onTransitZ(old_z,new_z)
	..()
	update_z(new_z)
