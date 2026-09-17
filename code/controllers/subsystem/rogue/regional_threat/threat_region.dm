/datum/threat_region
	var/region_name = "Generic Region Scream At Coder"
	var/latent_ambush = DANGER_SAFE_FLOOR
	var/min_ambush = DANGER_SAFE_FLOOR
	var/max_ambush = DANGER_DIRE_LIMIT
	var/fixed_ambush = FALSE // Some region like Underdark cannot be reduced in danger
	var/lowpop_tick = 1 // How much ambush to tick up every iteration <= 30 pop
	var/highpop_tick = 2 // How much ambush to tick up every iteration > 30 pop
	var/last_natural_ambush_time = 0
	var/last_induced_ambush_time = 0 // Time between now and the previous ambush triggered by horn
	// --- Quest surface (AP Quest 2 port) ---
	// Grafted onto the absolute-threshold ambush model; the danger/ambush economy is untouched.
	/// Quest types this region will host. Default (set in New) is the full kill+evergreen set;
	/// set per region to restrict (e.g. a dangerous region that won't host trivial kill-easy quests).
	var/list/allowed_quest_types
	var/kill_target_floor = 2
	var/evergreen_target = 0
	// Mammons the region have stolen, for recovery
	var/banditry_hoard = 0
	var/datum/weakref/active_hoard_recovery_ref
	var/tp_budget_multiplier = 1.0
	/// Multiplier on the threat-scaled bonus paid to retrieval/courier quests. Independent of
	/// tp_budget_multiplier so reward and combat scaling tune separately.
	var/delivery_reward_multiplier = 1.0
	/// Faction-id -> weight, for kill/blockade faction selection. Set per-region on the
	/// /datum/threat_region subtypes; a kill quest's preview() picks a faction from this table.
	var/list/faction_weights = list()
	/// Flat mammon added to a blockade writ's reward for the journey out to this region.
	/// Waves stay flat in TP; only the payout reflects distance.
	var/blockade_travel_fee = 0

// Ratwood regions are typed subtypes with vars set at definition, so New() only
// fills quest-surface defaults a subtype left unset.
/datum/threat_region/New()
	. = ..()
	if(!allowed_quest_types)
		allowed_quest_types = list(QUEST_KILL_EASY, QUEST_CLEAR_OUT, QUEST_RAID, QUEST_BOUNTY, QUEST_COURIER, QUEST_RETRIEVAL, QUEST_RECOVERY, QUEST_NOTORIOUS_BOUNTY)

/datum/threat_region/proc/has_active_blockade()
	for(var/datum/blockade/B as anything in GLOB.active_blockades)
		if(B.threat_region_name == region_name)
			return TRUE
	return FALSE

/// Scales a per-region kill-quest target off live population, clamped to this region's floor..floor+offset.
/datum/threat_region/proc/get_kill_target(pop)
	var/scaled = round(pop * QUEST_KILL_FRACTION)
	return clamp(scaled, kill_target_floor, kill_target_floor + QUEST_KILL_CEILING_OFFSET)

/datum/threat_region/proc/allows_quest_type(quest_type)
	return (quest_type in allowed_quest_types)

/// Fill ratio (0..1) of this region's current threat vs its ceiling; used to weight quest placement.
/datum/threat_region/proc/get_threat_weight()
	if(!max_ambush || latent_ambush <= 0)
		return 0
	return latent_ambush / max_ambush

/datum/threat_region/proc/reduce_latent_ambush(amount)
	if(fixed_ambush)
		return
	if(latent_ambush - amount < min_ambush)
		latent_ambush = min_ambush
	else
		latent_ambush -= amount

/datum/threat_region/proc/increase_latent_ambush(amount)
	if(fixed_ambush)
		return
	if(latent_ambush + amount > max_ambush)
		latent_ambush = max_ambush
	else
		latent_ambush += amount

// Special proc because danger level is dependent on the number of latent ambush
/datum/threat_region/proc/get_danger_level()
	if(latent_ambush <= DANGER_SAFE_LIMIT)
		return DANGER_LEVEL_SAFE
	else if(latent_ambush <= DANGER_LOW_LIMIT)
		return DANGER_LEVEL_LOW
	else if(latent_ambush <= DANGER_MODERATE_LIMIT)
		return DANGER_LEVEL_MODERATE
	else if(latent_ambush <= DANGER_DANGEROUS_LIMIT)
		return DANGER_LEVEL_DANGEROUS
	else if(latent_ambush <= DANGER_DIRE_LIMIT)
		return DANGER_LEVEL_BLEAK
	else
		return DANGER_LEVEL_SAFE

/datum/threat_region/proc/get_danger_color()
	switch(get_danger_level())
		if(DANGER_LEVEL_SAFE)
			return "#00FF00"
		if(DANGER_LEVEL_LOW)
			return "#FFFF00"
		if(DANGER_LEVEL_MODERATE)
			return "#FFA500"
		if(DANGER_LEVEL_DANGEROUS)
			return "#FF0000"
		if(DANGER_LEVEL_BLEAK)
			return "#800080"
		else
			return "#FFFFFF"


/datum/threat_region/proc/get_ic_description()
	var/list/result = list()
	if(!length(faction_weights) || latent_ambush <= 0)
		return result
	var/total_bands = round(latent_ambush / THREAT_POINTS_PER_BAND)
	if(total_bands <= 0)
		return result
	var/weight_sum = 0
	for(var/id in faction_weights)
		weight_sum += faction_weights[id]
	if(!weight_sum)
		return result
	var/list/shares = list()
	for(var/id in faction_weights)
		var/datum/quest_faction/F = get_quest_faction(id)
		if(!F)
			continue
		var/bands = round(total_bands * faction_weights[id] / weight_sum)
		if(bands <= 0)
			continue
		shares[F] = bands
	sortTim(shares, /proc/cmp_numeric_dsc, associative = TRUE)
	for(var/datum/quest_faction/F as anything in shares)
		result += F.describe_group_count(shares[F])
	return result
