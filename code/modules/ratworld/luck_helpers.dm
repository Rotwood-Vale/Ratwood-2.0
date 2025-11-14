/****************************************************
 * Ratworld luck helpers
 ****************************************************/

// Returns total luck percent from enchants for this mob
/mob/living/proc/ratworld_get_luck_total()
	return src.rw_luck_pct_total

// Generic helper to bias a 0..1 float roll toward high values using luck
// luck_pct: total luck (e.g. 350 = 350%)
// base_roll: initial 0..1 roll
/proc/ratworld_bias_roll_with_luck(luck_pct, base_roll)
	if(luck_pct <= 0 || base_roll <= 0 || base_roll >= 1)
		return base_roll
	var/luck_factor = min(luck_pct / 100, 3.5) // 350% => 3.5
	// Simple easing: move roll toward 1.0 by up to luck_factor * 0.1
	// so 350% luck gives up to 35% shift upward
	var/shift = luck_factor * 0.1
	return clamp(base_roll + (1 - base_roll) * shift, 0, 1)

// Helper for enchant rolls: given min/max, roll and bias toward max using luck
/proc/ratworld_roll_enchant_value_with_luck(luck_pct, min_value, max_value)
	if(max_value <= min_value)
		return min_value
	var/base = rand()
	var/biased = ratworld_bias_roll_with_luck(luck_pct, base)
	return round(min_value + (max_value - min_value) * biased)

// Helper for crafting rarity rolls: returns a 0..1 quality value (higher is rarer)
/proc/ratworld_roll_crafting_quality_with_luck(luck_pct)
	var/base = rand()
	return ratworld_bias_roll_with_luck(luck_pct, base)
