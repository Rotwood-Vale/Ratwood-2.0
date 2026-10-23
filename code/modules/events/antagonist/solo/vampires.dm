/datum/round_event_control/antagonist/solo/vampires
	name = "Vampires"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_NBEAST
	shared_occurence_type = SHARED_HIGH_THREAT

	weight = 4
	max_occurrences = 1

	denominator = 80

	base_antags = 1
	maximum_antags = 2

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/vampire
	antag_datum = /datum/antagonist/vampire

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/vampire
	var/leader = FALSE

/datum/round_event/antagonist/solo/vampire/add_datum_to_mind(datum/mind/antag_mind)
	var/mob/living/carbon/human/body = antag_mind.current
	if(!leader)
		if(istype(body))
			body.convert_to_antag_job()
		var/datum/antagonist/vampire/lord/lorde = new /datum/antagonist/vampire/lord()
		antag_mind.add_antag_datum(lorde)
		leader = TRUE
		return
	if(!antag_mind.has_antag_datum(antag_datum))
		if(istype(body))
			body.convert_to_antag_job()
		var/datum/antagonist/vampire/servante = new /datum/antagonist/vampire(forced_clan = null, generation = GENERATION_ANCILLAE)
		antag_mind.add_antag_datum(servante)
