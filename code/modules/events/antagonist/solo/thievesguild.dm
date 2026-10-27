/datum/round_event_control/antagonist/solo/thievesguild
	name = "Thieves' Guild"
	tags = list(
		TAG_VILLIAN,
		TAG_LOOT
	)
	roundstart = TRUE
	antag_flag = ROLE_THIEVESGUILD
	shared_occurence_type = SHARED_MINOR_THREAT

	// Allow adventurers and towners to be Thieves' Guild members
	needed_job = list("Adventurer", "Towner")

	// Restrict from important roles
	restricted_roles = list(
		"Grand Duke",
		"Grand Duchess",
		"Consort",
		"Dungeoneer",
		"Sergeant",
		"Man at Arms",
		"Marshal",
		"Merchant",
		"Priest",
		"Acolyte",
		"Martyr",
		"Templar",
		"Councillor",
		"Prince",
		"Princess",
		"Hand",
		"Steward",
		"Court Physician",
		"Town Elder",
		"Captain",
		"Archivist",
		"Knight",
		"Court Magician",
		"Inquisitor",
		"Orthodoxist",
		"Warden",
		"Squire",
		"Veteran",
		"Apothecary"
	)

	base_antags = 1
	maximum_antags = 5
	max_occurrences = 1 // fuck you
	earliest_start = 0 SECONDS

	weight = 10

	min_players = 0

	typepath = /datum/round_event/antagonist/solo/thievesguild
	antag_datum = /datum/antagonist/thievesguild

/datum/round_event_control/antagonist/solo/thievesguild/canSpawnEvent(players_amt, gamemode, fake_check)
	// Check each base condition individually
	if(SSgamemode.current_storyteller?.disable_distribution || SSgamemode.halted_storyteller)
		return FALSE
	
	if(event_group && !GLOB.event_groups[event_group].can_run())
		return FALSE
	
	if(roundstart && (!SSgamemode.can_run_roundstart || (SSgamemode.ran_roundstart && !fake_check && !SSgamemode.current_storyteller?.ignores_roundstart)))
		return FALSE
	
	if(occurrences >= max_occurrences)
		return FALSE
	
	if(earliest_start >= world.time-SSticker.round_start_time)
		return FALSE
	
	if(wizardevent != SSevents.wizardmode)
		return FALSE
	
	if(players_amt < min_players)
		return FALSE
	
	if(length(todreq) && !(GLOB.tod in todreq))
		return FALSE
	
	if(length(allowed_storytellers))
		if(!(SSgamemode.current_storyteller.type in allowed_storytellers))
			return FALSE
	
	if(req_omen)
		if(!GLOB.badomens.len)
			return FALSE
	
	if(!name)
		return FALSE
	
	var/list/candidates = get_candidates()
	
	// Allow the event to run if there's at least 1 candidate, even if fewer than desired
	if(length(candidates) < 1)
		return FALSE
	
	return TRUE

/datum/round_event_control/antagonist/solo/thievesguild/get_candidates()
	var/list/candidates = ..()
	return candidates

/datum/round_event/antagonist/solo/thievesguild
	var/leader = FALSE

/datum/round_event/antagonist/solo/thievesguild/setup()
	var/datum/round_event_control/antagonist/solo/cast_control = control
	antag_count = cast_control.get_antag_amount()
	
	antag_flag = cast_control.antag_flag
	antag_datum = cast_control.antag_datum
	restricted_roles = cast_control.restricted_roles
	prompted_picking = cast_control.prompted_picking
	
	var/list/possible_candidates = cast_control.get_candidates()
	
	var/list/candidates = list()
	if(cast_control == SSgamemode.current_roundstart_event && length(SSgamemode.roundstart_antag_minds))
		log_storyteller("Running roundstart antagonist assignment, event: [src], roundstart_antag_minds: [english_list(SSgamemode.roundstart_antag_minds)]")
		for(var/datum/mind/antag_mind in SSgamemode.roundstart_antag_minds)
			if(!antag_mind.current)
				log_storyteller("Roundstart antagonist setup error: antag_mind([antag_mind]) in roundstart_antag_minds without a set mob")
				continue
			candidates += antag_mind.current
			SSgamemode.roundstart_antag_minds -= antag_mind
			log_storyteller("Roundstart antag_mind, [antag_mind]")

	//guh
	var/list/cliented_list = list()
	for(var/mob/living/mob as anything in possible_candidates)
		cliented_list += mob.client

	while(length(possible_candidates) && length(candidates) < antag_count) //both of these pick_n_take from weighted_candidates so this should be fine
		var/mob/picked_ckey = pick_n_take(possible_candidates)
		var/client/picked_client = picked_ckey.client
		if(QDELETED(picked_client))
			continue
		var/mob/picked_mob = picked_client.mob
		picked_mob?.mind?.picking = TRUE
		log_storyteller("Picked antag event mob: [picked_mob], special role: [picked_mob.mind?.special_role ? picked_mob.mind.special_role : "none"]")
		candidates |= picked_mob

	var/list/picked_mobs = list()
	for(var/i in 1 to antag_count)
		if(!length(candidates))
			message_admins("A roleset event got fewer antags then its antag_count and may not function correctly.")
			break

		var/mob/candidate = pick_n_take(candidates)
		log_storyteller("Antag event spawned mob: [candidate], special role: [candidate.mind?.special_role ? candidate.mind.special_role : "none"]")

		if(!candidate.mind)
			candidate.mind = new /datum/mind(candidate.key)

		setup_minds += candidate.mind
		candidate.mind.special_role = antag_flag
		candidate.mind.restricted_roles = restricted_roles
		picked_mobs += WEAKREF(candidate.client)
	
	setup = TRUE
	if(LAZYLEN(extra_spawned_events))
		var/event_type = pickweight(extra_spawned_events)
		if(!event_type)
			return
		var/datum/round_event_control/triggered_event = locate(event_type) in SSgamemode.control
		//wait a second to avoid any potential omnitraitor bs
		addtimer(CALLBACK(triggered_event, TYPE_PROC_REF(/datum/round_event_control, runEvent), FALSE), 1 SECONDS)

/datum/round_event/antagonist/solo/thievesguild/start()
	// Check if we have any candidates
	if(!setup_minds || !setup_minds.len)
		return
	
	// Check if the antagonist datum is valid
	if(!antag_datum)
		return
	
	for(var/datum/mind/antag_mind as anything in setup_minds)
		// Check if the mind already has this antagonist
		if(antag_mind.has_antag_datum(antag_datum))
			continue
		
		// Check if the antagonist can be owned by this mind
		var/datum/antagonist/test_antag = new antag_datum()
		if(!test_antag.can_be_owned(antag_mind))
			qdel(test_antag)
			continue
		qdel(test_antag)
		
		// Attempt to add the antagonist datum
		antag_mind.add_antag_datum(antag_datum) 
