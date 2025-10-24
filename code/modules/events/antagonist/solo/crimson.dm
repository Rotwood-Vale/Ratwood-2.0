/datum/round_event_control/antagonist/solo/crimson_agents
    name = "Crimson Agents"
    tags = list(
        TAG_VILLIAN,
    )
    // Midround injection that selects from alive players who opted into Crimson Agent in prefs
    roundstart = FALSE
    antag_flag = ROLE_CRIMSON_AGENT
    shared_occurence_type = SHARED_MINOR_THREAT

    // How many to spawn based on pop
    base_antags = 1
    maximum_antags = 6
    denominator = 30

    // Basic gating/weight
    min_players = 12
    weight = 10

    earliest_start = 5 MINUTES

    typepath = /datum/round_event/antagonist/solo/crimson_agents
    antag_datum = /datum/antagonist/crimson

    // Optionally restrict certain high-importance roles from being selected; keep empty for now
    // restricted_roles = list("Grand Duke", "Grand Duchess", "Knight Captain", "Bishop", "Inquisitor", "Marshal")


/datum/round_event/antagonist/solo/crimson_agents
    // No custom setup/start needed; base class handles candidate selection respecting preferences
    // and applies the Crimson antagonist datum
