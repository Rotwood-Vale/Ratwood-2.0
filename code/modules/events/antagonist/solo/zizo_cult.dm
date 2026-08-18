/datum/round_event_control/antagonist/solo/zizo_cult
	name = "Zizo Cult"
	tags = list(
		TAG_COMBAT,
		TAG_VILLIAN,
		TAG_MAGIC
	)
	roundstart = FALSE
	antag_flag = ROLE_ZIZOIDCULTIST
	shared_occurence_type = SHARED_HIGH_THREAT

	base_antags = 1
	maximum_antags = 4

	earliest_start = 0 SECONDS

	weight = 0

	restricted_roles = list(
		"Grand Duke",
		"Grand Duchess",
		"Consort",
		"Prince",
		"Princess",
		"Hand",
		"Captain",
		"Bishop",
		"Acolyte",
		"Martyr",
		"Templar",
		"Inquisitor",
		"Orthodoxist",
		"Absolver",
		"Archivist",
		"Court Magician",
	)

	typepath = /datum/round_event/antagonist/solo/zizo_cult
	antag_datum = /datum/antagonist/zizocultist

/datum/round_event/antagonist/solo/zizo_cult/start()
	var/leader_assigned = FALSE
	for(var/datum/mind/antag_mind as anything in setup_minds)
		if(!leader_assigned)
			antag_mind.add_antag_datum(/datum/antagonist/zizocultist/leader)
			leader_assigned = TRUE
		else
			antag_mind.add_antag_datum(/datum/antagonist/zizocultist)
