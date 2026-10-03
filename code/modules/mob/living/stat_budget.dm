GLOBAL_LIST_INIT(budget_stats, list(STATKEY_STR, STATKEY_PER, STATKEY_INT, STATKEY_CON, STATKEY_WIL, STATKEY_SPD))
GLOBAL_LIST_INIT(stat_pref_levels, list("++" = 2, "+" = 1, "-" = 0, "--" = -0.5))

// the weights choose where 'spare' points go, Generally.
GLOBAL_LIST_INIT(stat_weight_mults, list(STATKEY_STR = 1.3, STATKEY_PER = 1.1, STATKEY_INT = 1.15, STATKEY_CON = 1.1, STATKEY_WIL = 1.15, STATKEY_SPD = 1.25))
// the costs are based off my own analysis of the stats. I think it's good ??
GLOBAL_LIST_INIT(stat_cost_factors, list(STATKEY_STR = 1.5, STATKEY_PER = 1, STATKEY_INT = 1.25, STATKEY_CON = 1, STATKEY_WIL = 1, STATKEY_SPD = 1.5))
GLOBAL_LIST_INIT(stat_pref_symbols, list("++" = "++", "+" = "+", "-" = "=", "--" = "-"))

GLOBAL_LIST_INIT(stat_pref_costs, list("++" = 1, "+" = 1, "-" = 0, "--" = 0))

/proc/stat_pref_points_used(list/stat_prefs)
	var/used = 0
	for(var/stat in stat_prefs)
		used += GLOB.stat_pref_costs[stat_prefs[stat]]
	return used

// attributes are more expensive when stacked.
/proc/stat_level_cost(stat, level)
	var/cost = 3
	if(level <= STAT_COST_CHEAP_MAX)
		cost = 1
	else if(level <= STAT_COST_MID_MAX)
		cost = 2
	return cost * GLOB.stat_cost_factors[stat]

/proc/stat_cap_shift(stat, list/favored_stats)
	return LAZYACCESS(favored_stats, stat) || 0

/proc/stat_role_weight(stat, list/favored_stats)
	switch(LAZYACCESS(favored_stats, stat))
		if(STAT_VERY_FAVORED)
			return STAT_WEIGHT_VERY_FAVORED
		if(STAT_FAVORED)
			return STAT_WEIGHT_FAVORED
		if(STAT_DISFAVORED)
			return STAT_WEIGHT_DISFAVORED
		if(STAT_VERY_DISFAVORED)
			return STAT_WEIGHT_VERY_DISFAVORED
	return STAT_WEIGHT_NEUTRAL

// the ALGORITHM ! it spends points to bring everything up 2 baseline / pref / favored, & then spends what's leftover according to weight.
/proc/calculate_role_stats(list/stat_prefs, budget, list/favored_stats)
	var/list/values = list()
	var/list/caps = list()
	var/list/baselines = list()
	var/list/weights = list()
	var/list/spent = list()
	for(var/stat in GLOB.budget_stats)
		var/pick = "-"
		if(stat_prefs && stat_prefs[stat])
			pick = stat_prefs[stat]
		var/shift = stat_cap_shift(stat, favored_stats)
		values[stat] = 8
		caps[stat] = STAT_BASE_MAX + shift
		baselines[stat] = STAT_BASELINE + min(shift, 0)
		if(pick == "--" && shift > 0)
			caps[stat]--
		else if(pick == "--")
			caps[stat] = 8
			baselines[stat] = 8
		weights[stat] = (max(STAT_MIN_WEIGHT, stat_role_weight(stat, favored_stats) + GLOB.stat_pref_levels[pick]) ** STAT_FOCUS) * GLOB.stat_weight_mults[stat]
		spent[stat] = 0
	var/progress = TRUE
	while(progress && budget > 0)
		progress = FALSE
		for(var/stat in GLOB.budget_stats)
			if(values[stat] >= baselines[stat] || stat_level_cost(stat, values[stat] + 1) > budget)
				continue
			budget -= stat_level_cost(stat, values[stat] + 1)
			values[stat]++
			progress = TRUE
	while(budget > 0)
		var/total_weight = 0
		var/virtual_budget = budget
		var/list/open = list()
		for(var/stat in GLOB.budget_stats)
			if(values[stat] >= caps[stat])
				continue
			open += stat
			total_weight += weights[stat]
			virtual_budget += spent[stat]
		var/best
		var/best_deficit
		for(var/stat in open)
			if(stat_level_cost(stat, values[stat] + 1) > budget)
				continue
			var/deficit = virtual_budget * weights[stat] / total_weight - spent[stat]
			if(isnull(best) || deficit > best_deficit)
				best = stat
				best_deficit = deficit
		if(isnull(best))
			break
		var/cost = stat_level_cost(best, values[best] + 1)
		values[best]++
		spent[best] += cost
		budget -= cost
	return values

/mob/living/carbon/human/proc/apply_role_stats(budget, list/favored_stats)
	var/list/values = calculate_role_stats(stat_prefs, budget, favored_stats)
	if(isnull(flat))
		flat = dna.species.race_bonus
	var/list/age_bonuses = GLOB.age_stat_bonuses[age]
	for(var/stat in values)
		var/bonus = flat[stat] + LAZYACCESS(age_bonuses, stat)
		var/ceiling = max(values[stat], STAT_BASE_MAX + stat_cap_shift(stat, favored_stats) + STAT_MODIFIER_OVERCAP)
		change_stat(stat, min(values[stat] + bonus, ceiling) - 10 - bonus)
