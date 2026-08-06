/datum/threat_region/azure_basin
	region_name = THREAT_REGION_AZURE_BASIN
	latent_ambush = DANGER_LOW_FLOOR
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DANGEROUS_LIMIT
	lowpop_tick = 1
	highpop_tick = 1

/datum/threat_region/azure_grove
	region_name = THREAT_REGION_AZURE_GROVE
	latent_ambush = DANGER_MODERATE_FLOOR
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DANGEROUS_LIMIT
	lowpop_tick = 1
	highpop_tick = 2

/datum/threat_region/terrorbog
	region_name = THREAT_REGION_TERRORBOG
	latent_ambush = DANGER_DIRE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	lowpop_tick = 1
	highpop_tick = 2

/datum/threat_region/azure_coast
	region_name = THREAT_REGION_AZUREAN_COAST
	latent_ambush = DANGER_DANGEROUS_FLOOR
	min_ambush = DANGER_MODERATE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	lowpop_tick = 1
	highpop_tick = 2

/datum/threat_region/mount_decap
	region_name = THREAT_REGION_MOUNT_DECAP
	latent_ambush = DANGER_DANGEROUS_FLOOR
	min_ambush = DANGER_MODERATE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	lowpop_tick = 1
	highpop_tick = 2

// --- Quest surface (AP Quest 2 port) ---
// Tuning mirrors Emerald Summit's economy-take-2 values for the equivalent regions.

/datum/threat_region/azure_basin
	allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY)
	tp_budget_multiplier = 0.75
	kill_target_floor = 4
	evergreen_target = 3
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 60,
		QUEST_FACTION_SEA_GOBLIN = 40,
		QUEST_FACTION_HIGHWAYMAN = 5,
	)

/datum/threat_region/azure_grove
	kill_target_floor = 5
	evergreen_target = 3
	delivery_reward_multiplier = 1.5
	faction_weights = list(
		QUEST_FACTION_FOREST_GOBLIN = 40,
		QUEST_FACTION_HIGHWAYMAN = 30,
		QUEST_FACTION_STRAY_DEADITE = 20,
		QUEST_FACTION_WILD_BEAST = 10,
	)

/datum/threat_region/terrorbog
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN, QUEST_TOWNER_MINER_OREVEIN)
	tp_budget_multiplier = 1.5
	kill_target_floor = 4
	evergreen_target = 3
	delivery_reward_multiplier = 2.0
	faction_weights = list(
		QUEST_FACTION_MIRESPIDER = 50,
		QUEST_FACTION_BOGMAN = 40,
		QUEST_FACTION_DROW = 30,
		QUEST_FACTION_MOON_GOBLIN = 25,
		QUEST_FACTION_BOG_DEADITE = 20,
		QUEST_FACTION_BOG_TROLL = 10,
		QUEST_FACTION_LICH_DEADITE = 10,
		QUEST_FACTION_MINOTAUR = 10,
		QUEST_FACTION_FOREST_GOBLIN = 5,
	)

/datum/threat_region/azure_coast
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN, QUEST_TOWNER_MINER_OREVEIN)
	tp_budget_multiplier = 1.2
	kill_target_floor = 3
	delivery_reward_multiplier = 1.8
	faction_weights = list(
		QUEST_FACTION_ORC = 30,
		QUEST_FACTION_SEA_GOBLIN = 25,
		QUEST_FACTION_GRONNMAN = 20,
		QUEST_FACTION_BLEAKISLE_REAVER = 15,
		QUEST_FACTION_HIGHWAYMAN = 10,
	)

/datum/threat_region/mount_decap
	allowed_quest_types = list(QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_RECOVERY, QUEST_TOWNER_SMITH_CARAVAN, QUEST_TOWNER_MINER_OREVEIN)
	tp_budget_multiplier = 1.5
	kill_target_floor = 3
	delivery_reward_multiplier = 2.0
	faction_weights = list(
		QUEST_FACTION_HELL_GOBLIN = 25,
		QUEST_FACTION_TARICHEA_DEADITE = 20,
		QUEST_FACTION_MOUNT_REAVER = 20,
		QUEST_FACTION_MOUNTAIN_TROLL = 15,
		QUEST_FACTION_MINOTAUR = 10,
		QUEST_FACTION_GREAT_BEAST = 5,
		QUEST_FACTION_MADMAN = 5,
	)
