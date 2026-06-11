#define PING_BUFFER_TIME 25

SUBSYSTEM_DEF(server_maint)
	name = "Server Tasks"
	wait = 6
	flags = SS_POST_FIRE_TIMING
	priority = FIRE_PRIORITY_SERVER_MAINT
	init_order = INIT_ORDER_SERVER_MAINT
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
	var/list/currentrun
	var/cleanup_ticker = 0
	var/next_mob_processing_validation = 0

/datum/controller/subsystem/server_maint/PreInit()
	world.hub_password = "" //quickly! before the hubbies see us.

/datum/controller/subsystem/server_maint/Initialize(timeofday)
	if (CONFIG_GET(flag/hub))
		world.update_hub_visibility(TRUE)
	next_mob_processing_validation = world.time + 60 SECONDS
	return ..()

/datum/controller/subsystem/server_maint/fire(resumed = FALSE)
	if(!resumed)
		if(world.time >= next_mob_processing_validation)
			validate_mob_processing_lists()
			next_mob_processing_validation = world.time + 60 SECONDS

		if(listclearnulls(GLOB.clients))
			log_world("Found a null in clients list!")
		src.currentrun = GLOB.clients.Copy()

		switch (cleanup_ticker) // do only one of these at a time, once per 5 fires
			if (0)
				if(listclearnulls(GLOB.player_list))
					log_world("Found a null in player_list!")
				cleanup_ticker++
			if (5)
				if(listclearnulls(GLOB.mob_list))
					log_world("Found a null in mob_list!")
				cleanup_ticker++
			if (10)
				if(listclearnulls(GLOB.alive_mob_list))
					log_world("Found a null in alive_mob_list!")
				cleanup_ticker++
			if (15)
				if(listclearnulls(GLOB.suicided_mob_list))
					log_world("Found a null in suicided_mob_list!")
				cleanup_ticker++
			if (20)
				if(listclearnulls(GLOB.dead_mob_list))
					log_world("Found a null in dead_mob_list!")
				cleanup_ticker++
			if (25)
				cleanup_ticker = 0
			else
				cleanup_ticker++

	var/list/currentrun = src.currentrun
	var/round_started = SSticker.HasRoundStarted()

	var/kick_inactive = CONFIG_GET(flag/kick_inactive)
	var/afk_period
	if(kick_inactive)
		afk_period = CONFIG_GET(number/afk_period)
	for(var/I in currentrun)
		var/client/C = I
		//handle kicking inactive players
		if(round_started && kick_inactive && !C.holder && C.is_afk(afk_period))
			var/cmob = C.mob
			if (!isnewplayer(cmob) || !SSticker.queued_players.Find(cmob))
				log_access("AFK: [key_name(C)]")
				to_chat(C, span_danger("I have been inactive for more than [DisplayTimeText(afk_period)] and have been disconnected.</span><br><span class='danger'>I may reconnect via the button in the file menu or by <b><u><a href='byond://winset?command=.reconnect'>clicking here to reconnect</a></u></b>."))
				QDEL_IN(C, 1) //to ensure they get our message before getting disconnected
				continue

//		if (!(!C || world.time - C.connection_time < PING_BUFFER_TIME || C.inactivity >= (wait-1)))
//			winset(C, null, "command=.update_ping+[world.time+world.tick_lag*TICK_USAGE_REAL/100]")

		if (MC_TICK_CHECK) //one day, when ss13 has 1000 people per server, you guys are gonna be glad I added this tick check
			return

/datum/controller/subsystem/server_maint/proc/record_mob_processing_issue(list/issues_by_ref, datum/entry, issue)
	if(!entry)
		return

	var/ref_id = REF(entry)
	var/list/issue_data = issues_by_ref[ref_id]
	if(!issue_data)
		issue_data = list(
			"entry" = entry,
			"issues" = list(),
		)
		issues_by_ref[ref_id] = issue_data

	var/list/entry_issues = issue_data["issues"]
	entry_issues |= issue

/datum/controller/subsystem/server_maint/proc/validate_mob_processing_lists()
	var/list/lists_to_check = list(
		"mob_living_list" = GLOB.mob_living_list,
		"mob_living_active_list" = GLOB.mob_living_active_list,
		"mob_living_dead_list" = GLOB.mob_living_dead_list,
		"alive_mob_list" = GLOB.alive_mob_list,
		"dead_mob_list" = GLOB.dead_mob_list,
	)
	var/list/living_only_lists = list(
		"mob_living_list" = GLOB.mob_living_list,
		"mob_living_active_list" = GLOB.mob_living_active_list,
		"mob_living_dead_list" = GLOB.mob_living_dead_list,
	)
	var/list/issues_by_ref = list()
	var/list/raw_issue_details = list()
	var/list/living_candidates = list()
	var/list/lookups = list()
	var/null_count = 0
	var/duplicate_count = 0
	var/invalid_entry_count = 0
	var/qdeleted_count = 0
	var/membership_issue_count = 0

	for(var/mob/candidate as anything in GLOB.mob_list)
		if(isliving(candidate))
			living_candidates[candidate] = TRUE

	for(var/list_name in lists_to_check)
		var/list/source_list = lists_to_check[list_name]
		var/check_living_only = !isnull(living_only_lists[list_name])
		var/list/lookup = list()
		var/list_null_count = 0
		for(var/entry as anything in source_list)
			if(isnull(entry))
				list_null_count++
				continue
			if(!isdatum(entry))
				invalid_entry_count++
				raw_issue_details += "[list_name] non-datum entry=[entry]"
				continue
			if(lookup[entry])
				duplicate_count++
				record_mob_processing_issue(issues_by_ref, entry, "duplicate in [list_name]")
			else
				lookup[entry] = TRUE

			if(isliving(entry))
				living_candidates[entry] = TRUE
			else if(check_living_only)
				invalid_entry_count++
				record_mob_processing_issue(issues_by_ref, entry, "non-living entry in [list_name]")
		lookups[list_name] = lookup
		if(list_null_count)
			null_count += list_null_count
			raw_issue_details += "[list_name] nulls=[list_null_count]"

	var/list/living_lookup = lookups["mob_living_list"]
	var/list/active_lookup = lookups["mob_living_active_list"]
	var/list/dead_processing_lookup = lookups["mob_living_dead_list"]
	var/list/alive_lookup = lookups["alive_mob_list"]
	var/list/dead_lookup = lookups["dead_mob_list"]

	for(var/mob/living/living_mob as anything in living_candidates)
		if(QDELETED(living_mob))
			qdeleted_count++
			record_mob_processing_issue(issues_by_ref, living_mob, "QDELETED membership")
			continue

		if(!living_lookup[living_mob])
			membership_issue_count++
			record_mob_processing_issue(issues_by_ref, living_mob, "missing from mob_living_list")

		var/in_active_processing = active_lookup[living_mob]
		var/in_dead_processing = dead_processing_lookup[living_mob]
		var/in_alive_mobs = alive_lookup[living_mob]
		var/in_dead_mobs = dead_lookup[living_mob]

		if(living_mob.stat == DEAD)
			if(in_active_processing)
				membership_issue_count++
				record_mob_processing_issue(issues_by_ref, living_mob, "dead mob in active processing")
			if(!in_dead_processing)
				membership_issue_count++
				record_mob_processing_issue(issues_by_ref, living_mob, "dead mob missing from dead processing")
			if(in_alive_mobs)
				membership_issue_count++
				record_mob_processing_issue(issues_by_ref, living_mob, "dead mob in alive_mob_list")
			if(!in_dead_mobs)
				membership_issue_count++
				record_mob_processing_issue(issues_by_ref, living_mob, "dead mob missing from dead_mob_list")
		else
			if(!in_active_processing)
				membership_issue_count++
				record_mob_processing_issue(issues_by_ref, living_mob, "active mob missing from active processing")
			if(in_dead_processing)
				membership_issue_count++
				record_mob_processing_issue(issues_by_ref, living_mob, "active mob in dead processing")
			if(!in_alive_mobs)
				membership_issue_count++
				record_mob_processing_issue(issues_by_ref, living_mob, "active mob missing from alive_mob_list")
			if(in_dead_mobs)
				membership_issue_count++
				record_mob_processing_issue(issues_by_ref, living_mob, "active mob in dead_mob_list")

	if(!(null_count || duplicate_count || invalid_entry_count || qdeleted_count || membership_issue_count))
		return

	var/list/issue_details = raw_issue_details.Copy()
	for(var/ref_id in issues_by_ref)
		var/list/issue_data = issues_by_ref[ref_id]
		var/datum/entry = issue_data["entry"]
		var/stat_value = "n/a"
		if(ismob(entry))
			var/mob/mob_entry = entry
			stat_value = mob_entry.stat
		var/list/entry_issues = issue_data["issues"]
		var/joined_issues = jointext(entry_issues, ", ")
		issue_details += "[ref_id] type=[entry.type] stat=[stat_value] issues=[joined_issues]"
	var/joined_issue_details = jointext(issue_details, " | ")
	log_world("Mob processing invariant violation: nulls=[null_count], duplicates=[duplicate_count], invalid=[invalid_entry_count], qdeleted=[qdeleted_count], membership=[membership_issue_count]. [joined_issue_details]")

	for(var/list_name in lists_to_check)
		var/list/source_list = lists_to_check[list_name]
		var/list/seen = list()
		var/list/unique_entries = list()
		for(var/entry as anything in source_list)
			if(isnull(entry))
				continue
			if(isdatum(entry))
				if(seen[entry])
					continue
				seen[entry] = TRUE
			unique_entries += entry
		source_list.len = 0
		source_list += unique_entries

	for(var/list_name in living_only_lists)
		var/list/source_list = living_only_lists[list_name]
		for(var/entry as anything in source_list.Copy())
			if(!isliving(entry))
				source_list -= entry
				continue
			var/mob/living/living_entry = entry
			if(QDELETED(living_entry))
				source_list -= living_entry

	for(var/list_name in list("alive_mob_list", "dead_mob_list"))
		var/list/source_list = lists_to_check[list_name]
		for(var/entry as anything in source_list.Copy())
			if(!isdatum(entry))
				continue
			var/datum/datum_entry = entry
			if(QDELETED(datum_entry))
				source_list -= datum_entry

	for(var/mob/living/living_mob as anything in living_candidates)
		if(QDELETED(living_mob))
			continue

		GLOB.mob_living_list |= living_mob
		if(living_mob.stat == DEAD)
			GLOB.mob_living_active_list -= living_mob
			GLOB.mob_living_dead_list |= living_mob
			GLOB.alive_mob_list -= living_mob
			GLOB.dead_mob_list |= living_mob
		else
			GLOB.mob_living_dead_list -= living_mob
			GLOB.mob_living_active_list |= living_mob
			GLOB.dead_mob_list -= living_mob
			GLOB.alive_mob_list |= living_mob

/datum/controller/subsystem/server_maint/Shutdown()
//	kick_clients_in_lobby(span_boldannounce("The round came to an end with you in the lobby."), TRUE) //second parameter ensures only afk clients are kicked
	var/server = CONFIG_GET(string/server)
	for(var/thing in GLOB.clients)
		if(!thing)
			continue
		var/client/C = thing
		C?.tgui_panel?.send_roundrestart()
		if(server) //if you set a server location in config.txt, it sends you there instead of trying to reconnect to the same world address. -- NeoFite
			C << link("byond://[server]")
	var/datum/tgs_version/tgsversion = world.TgsVersion()
	if(tgsversion)
		SSblackbox.record_feedback("text", "server_tools", 1, tgsversion.raw_parameter)

#undef PING_BUFFER_TIME
