/datum/threat_region/desert_near
	region_name = THREAT_REGION_DESERT_NEAR
	latent_ambush = DANGER_MODERATE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DANGEROUS_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 1

/datum/threat_region/desert_deep
	region_name = THREAT_REGION_DESERT_DEEP
	latent_ambush = DANGER_DIRE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 2

// --- Quest surface (AP Quest 2 port) ---

/datum/threat_region/desert_near
	tp_budget_multiplier = 1.0
	kill_target_floor = 3
	evergreen_target = 2
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 40,
		QUEST_FACTION_ORC = 25,
		QUEST_FACTION_STRAY_DEADITE = 20,
		QUEST_FACTION_GREAT_BEAST = 10,
		QUEST_FACTION_MADMAN = 5,
	)

/datum/threat_region/desert_deep
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY)
	tp_budget_multiplier = 1.5
	kill_target_floor = 3
	delivery_reward_multiplier = 2.0
	faction_weights = list(
		QUEST_FACTION_EARTH_ELEMENTAL = 30,
		QUEST_FACTION_ORC = 25,
		QUEST_FACTION_TARICHEA_DEADITE = 20,
		QUEST_FACTION_GREAT_BEAST = 15,
		QUEST_FACTION_MADMAN = 10,
	)
