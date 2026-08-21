/datum/threat_region/byos_jungle
	region_name = THREAT_REGION_ISLAND
	latent_ambush = DANGER_MODERATE_LIMIT
	min_ambush = DANGER_SAFE_FLOOR
	max_ambush = DANGER_DANGEROUS_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 1

/datum/threat_region/byos_island
	region_name = THREAT_REGION_JUNGLE
	latent_ambush = DANGER_DIRE_LIMIT
	min_ambush = DANGER_MODERATE_FLOOR
	max_ambush = DANGER_DIRE_LIMIT
	fixed_ambush = FALSE
	lowpop_tick = 1
	highpop_tick = 2

// --- Quest surface (AP Quest 2 port) ---

/datum/threat_region/byos_jungle
	tp_budget_multiplier = 1.0
	kill_target_floor = 3
	evergreen_target = 2
	faction_weights = list(
		QUEST_FACTION_WILD_BEAST = 40,
		QUEST_FACTION_FOREST_GOBLIN = 30,
		QUEST_FACTION_BOGMAN = 20,
		QUEST_FACTION_GREAT_BEAST = 10,
	)

/datum/threat_region/byos_island
	tp_budget_multiplier = 1.2
	kill_target_floor = 3
	delivery_reward_multiplier = 1.5
	faction_weights = list(
		QUEST_FACTION_SEA_GOBLIN = 40,
		QUEST_FACTION_BLEAKISLE_REAVER = 30,
		QUEST_FACTION_ORC = 20,
		QUEST_FACTION_GRONNMAN = 10,
	)
