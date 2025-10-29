/datum/round_event_control/antagonist/solo/golden_court
    name = "Golden Rosa Court"
    tags = list(
        TAG_VILLIAN,
		TAG_COMBAT,
    )
    roundstart = TRUE
    antag_flag = ROLE_GOLDEN_AGENT
    shared_occurence_type = SHARED_MAJOR_THREAT

    restricted_roles = list(
        "Grand Duke",
        "Grand Duchess",
        "Knight Captain",
        "Bishop",
        "Inquisitor",
        "Marshal",
        "Templar",
        "Knight"
    )

    base_antags = 1
    maximum_antags = 6
    denominator = 60

    min_players = 25
    weight = 5


    earliest_start = 0 SECONDS

    typepath = /datum/round_event/antagonist/solo/golden_court
    antag_datum = /datum/antagonist/golden

/datum/round_event/antagonist/solo/golden_court

