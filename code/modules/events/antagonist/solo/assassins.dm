/datum/round_event_control/antagonist/solo/assassins
	name = "Assassins"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
		TAG_BLOOD
	)
	roundstart = TRUE
	antag_flag = ROLE_ASSASSIN
	shared_occurence_type = SHARED_MINOR_THREAT

	restricted_roles = list(
		"Grand Duke",
		"Grand Duchess",
		"Consort",
		"Dungeoneer",
		"Sergeant",
		"Man at Arms",
		"Marshal",
		"Merchant",
		"Bishop",
		"Acolyte",
		"Martyr",
		"Templar",
		"Councillor",
		"Prince",
		"Princess",
		"Hand",
		"Steward",
		"Head Physician",
		"Town Crier",
		"Captain",
		"Knight Captain",
		"Watch Captain",
		"Master Warden",
		"Archivist",
		"Knight",
		"Court Magician",
		"Inquisitor",
		"Orthodoxist",
		"Absolver",
		"Warden",
		"Squire",
		"Veteran",
		"Apothecary"
	)

	base_antags = 1
	maximum_antags = 2

	earliest_start = 0 SECONDS
	max_occurrences = 2

	weight = 10

	typepath = /datum/round_event/antagonist/solo/assassins
	antag_datum = /datum/antagonist/assassin

/datum/round_event/antagonist/solo/assassins/start()
	var/datum/job/assassin_job = SSjob.GetJob("Assassin")
	assassin_job.total_positions = length(setup_minds)
	for(var/datum/mind/antag_mind as anything in setup_minds)
		var/datum/job/original_job = SSjob.GetJob(antag_mind.assigned_role)
		antag_mind.current.unequip_everything()
		SSjob.AssignRole(antag_mind.current, "Assassin")
		if(original_job)
			if(original_job.total_positions == 1)
				original_job.current_positions = max(original_job.current_positions, 1)
			else
				original_job.current_positions += 1
		SSmapping.retainer.assassins |= antag_mind.current
		antag_mind.add_antag_datum(/datum/antagonist/assassin)

		SSrole_class_handler.setup_class_handler(antag_mind.current, list(CTAG_ASSASSIN = 20))
		antag_mind.current:advsetup = TRUE
		antag_mind.current.hud_used?.set_advclass()

	SSrole_class_handler.assassins_in_round = TRUE

/datum/round_event_control/antagonist/solo/assassins/get_candidates()
	var/list/candidates = ..()
	for(var/mob/living/candidate as anything in candidates.Copy())
		if(!candidate.mind?.antag_datums)
			continue
		for(var/datum/antagonist/antag_datum as anything in candidate.mind.antag_datums)
			if(!(antag_datum.antag_flags & FLAG_FAKE_ANTAG))
				candidates -= candidate
				break
	return candidates

/datum/round_event_control/antagonist/solo/assassins/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return
	var/list/candidates = get_candidates()

	if(length(candidates) < 1)
		return FALSE

	return TRUE
