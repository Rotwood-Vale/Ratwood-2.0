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
		"Archivist",
		"Knight",
		"Court Magician",
		"Inquisitor",
		"Orthodoxist",
		"Absolver",
		"Warden",
		"Squire",
		"Veteran",
		"Apothecary",
		"Knight Captain",
		"Wretch",
		"Bandit"
	)

	base_antags = 2
	maximum_antags = 4

	earliest_start = 0 SECONDS
	max_occurrences = 2

	weight = 10

	typepath = /datum/round_event/antagonist/solo/assassins
	antag_datum = /datum/antagonist/assassin

/datum/round_event/antagonist/solo/assassins/start()
	for(var/datum/mind/antag_mind as anything in setup_minds)
		SSmapping.retainer.assassins |= antag_mind.current
		antag_mind.add_antag_datum(/datum/antagonist/assassin)
	SSrole_class_handler.assassins_in_round = TRUE

/datum/round_event_control/antagonist/solo/assassins/canSpawnEvent(players_amt, gamemode, fake_check)
	. = ..()
	if(!.)
		return
	var/list/candidates = get_candidates()

	if(length(candidates) < 1)
		return FALSE

	return TRUE
