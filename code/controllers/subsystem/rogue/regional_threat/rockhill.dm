/datum/threat_region/rockhill_basin
	region_name = THREAT_REGION_ROCKHILL_BASIN
	latent_ambush = DANGER_MODERATE_FLOOR
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DANGEROUS_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 1


/datum/threat_region/rockhill_bog_north
	region_name = THREAT_REGION_ROCKHILL_BOG_NORTH
	latent_ambush = DANGER_MODERATE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 1


/datum/threat_region/rockhill_bog_west
	region_name = THREAT_REGION_ROCKHILL_BOG_WEST
	latent_ambush = DANGER_MODERATE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 1


/datum/threat_region/rockhill_bog_south
	region_name = THREAT_REGION_ROCKHILL_BOG_SOUTH
	latent_ambush = DANGER_MODERATE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 1


/datum/threat_region/rockhill_bog_sunkmire
	region_name = THREAT_REGION_ROCKHILL_BOG_SUNKMIRE
	latent_ambush = DANGER_DIRE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 2


/datum/threat_region/rockhill_woods_north
	region_name = THREAT_REGION_ROCKHILL_WOODS_NORTH
	latent_ambush = DANGER_MODERATE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DANGEROUS_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 1


/datum/threat_region/rockhill_woods_south
	region_name = THREAT_REGION_ROCKHILL_WOODS_SOUTH
	latent_ambush = DANGER_MODERATE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 1

// --- Quest surface (AP Quest 2 port) ---
// Basin and woods follow the tame-region tuning; the bogs follow Terrorbog.

/datum/threat_region/rockhill_basin
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	tp_budget_multiplier = 0.75
	kill_target_floor = 4
	evergreen_target = 3
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 50,
		QUEST_FACTION_HIGHWAYMAN = 25,
		QUEST_FACTION_WILD_BEAST = 15,
	)

/datum/threat_region/rockhill_woods_north
	// Default kill/evergreen set plus the smith caravan - the towner posting rides the
	// wooded roads here, and pick_region_for_quest only offers regions that allow it.
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN)
	kill_target_floor = 4
	evergreen_target = 2
	delivery_reward_multiplier = 1.5
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 40,
		QUEST_FACTION_HIGHWAYMAN = 30,
		QUEST_FACTION_STRAY_DEADITE = 20,
		QUEST_FACTION_WILD_BEAST = 10,
	)

/datum/threat_region/rockhill_woods_south
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN)
	kill_target_floor = 4
	evergreen_target = 2
	delivery_reward_multiplier = 1.5
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 35,
		QUEST_FACTION_HIGHWAYMAN = 25,
		QUEST_FACTION_STRAY_DEADITE = 20,
		QUEST_FACTION_GREAT_BEAST = 10,
	)

/datum/threat_region/rockhill_bog_north
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN, QUEST_TOWNER_MINER_OREVEIN)
	tp_budget_multiplier = 1.2
	blockade_travel_fee = BLOCKADE_TRAVEL_FEE_COAST
	kill_target_floor = 3
	evergreen_target = 2
	delivery_reward_multiplier = 1.8
	faction_weights = list(
		QUEST_FACTION_BOGMAN = 40,
		QUEST_FACTION_MIRESPIDER = 30,
		QUEST_FACTION_BOG_DEADITE = 20,
		QUEST_FACTION_BOG_TROLL = 10,
	)

/datum/threat_region/rockhill_bog_west
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN, QUEST_TOWNER_MINER_OREVEIN)
	tp_budget_multiplier = 1.2
	blockade_travel_fee = BLOCKADE_TRAVEL_FEE_COAST
	kill_target_floor = 3
	evergreen_target = 2
	delivery_reward_multiplier = 1.8
	faction_weights = list(
		QUEST_FACTION_MIRESPIDER = 40,
		QUEST_FACTION_BOGMAN = 30,
		QUEST_FACTION_MOON_GOBLIN = 20,
		QUEST_FACTION_BOG_DEADITE = 10,
	)

/datum/threat_region/rockhill_bog_south
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN, QUEST_TOWNER_MINER_OREVEIN)
	tp_budget_multiplier = 1.2
	blockade_travel_fee = BLOCKADE_TRAVEL_FEE_COAST
	kill_target_floor = 3
	evergreen_target = 2
	delivery_reward_multiplier = 1.8
	faction_weights = list(
		QUEST_FACTION_BOGMAN = 40,
		QUEST_FACTION_BOG_DEADITE = 30,
		QUEST_FACTION_MIRESPIDER = 20,
		QUEST_FACTION_LICH_DEADITE = 10,
	)

/datum/threat_region/rockhill_bog_sunkmire
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN, QUEST_TOWNER_MINER_OREVEIN)
	tp_budget_multiplier = 1.5
	blockade_travel_fee = BLOCKADE_TRAVEL_FEE_MOUNTAIN
	kill_target_floor = 3
	delivery_reward_multiplier = 2.0
	faction_weights = list(
		QUEST_FACTION_MIRESPIDER = 40,
		QUEST_FACTION_DROW = 30,
		QUEST_FACTION_BOG_TROLL = 15,
		QUEST_FACTION_LICH_DEADITE = 15,
		QUEST_FACTION_MINOTAUR = 10,
	)
