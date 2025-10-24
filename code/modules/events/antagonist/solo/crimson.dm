/datum/round_event_control/antagonist/solo/crimson_agents
    name = "Crimson Agents"
    tags = list(
        TAG_VILLIAN,
		TAG_COMBAT,
    )
    roundstart = TRUE
    antag_flag = ROLE_CRIMSON_AGENT
    shared_occurence_type = SHARED_MINOR_THREAT


    restricted_roles = list(
        "Grand Duke",
        "Grand Duchess",
        "Knight Captain",
        "Bishop",
        "Inquisitor",
        "Marshal",
        "Templar",
    )

    base_antags = 1
    maximum_antags = 6
    denominator = 30

    min_players = 12
    weight = 10


    earliest_start = 0 SECONDS

    typepath = /datum/round_event/antagonist/solo/crimson_agents
    antag_datum = /datum/antagonist/crimson

/datum/round_event/antagonist/solo/crimson_agents

