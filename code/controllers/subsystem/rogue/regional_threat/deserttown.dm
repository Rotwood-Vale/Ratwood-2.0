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
	// Default kill/evergreen set plus the smith caravan - the towner posting rides the
	// caravan roads out of Al-Ashur, and its ambush factions (highwaymen) live here.
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN)
	tp_budget_multiplier = 1.0
	// Two regions carry this whole map, so per-region targets run about triple the
	// per-region numbers of the five and seven region maps. Totals land at dun_world's
	// scale (18 kill + 6 evergreen here vs their 19 + 9).
	kill_target_floor = 9
	evergreen_target = 6
	faction_weights = list(
		QUEST_FACTION_HIGHWAYMAN = 40,
		QUEST_FACTION_ORC = 25,
		QUEST_FACTION_STRAY_DEADITE = 20,
		QUEST_FACTION_GREAT_BEAST = 10,
		QUEST_FACTION_MADMAN = 5,
	)

/datum/threat_region/desert_deep
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY, QUEST_TOWNER_MINER_OREVEIN)
	tp_budget_multiplier = 1.5
	blockade_travel_fee = BLOCKADE_TRAVEL_FEE_MOUNTAIN
	kill_target_floor = 9
	delivery_reward_multiplier = 2.0
	faction_weights = list(
		QUEST_FACTION_EARTH_ELEMENTAL = 30,
		QUEST_FACTION_ORC = 25,
		QUEST_FACTION_TARICHEA_DEADITE = 20,
		QUEST_FACTION_GREAT_BEAST = 15,
		QUEST_FACTION_MADMAN = 10,
	)
