/datum/round_event_control/antagonist/solo/hag
	name = "Hag"
	tags = list(
		TAG_COMBAT,
		TAG_HAUNTED,
		TAG_VILLIAN,
	)
	roundstart = TRUE
	antag_flag = ROLE_HAG
	shared_occurence_type = SHARED_HIGH_THREAT

	denominator = 60

	base_antags = 1
	maximum_antags = 1

	weight = 10
	max_occurrences = 1

	earliest_start = 0 SECONDS

	typepath = /datum/round_event/antagonist/solo/hag
	antag_datum = /datum/antagonist/hag

	restricted_roles = DEFAULT_ANTAG_BLACKLISTED_ROLES

/datum/round_event/antagonist/solo/hag
