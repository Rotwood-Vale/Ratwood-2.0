/****************************************************
 * Ratworld combat helpers: race, melee, magic
 ****************************************************/

// Basic race tags used for enchant race damage bonuses

/mob/living/proc/ratworld_get_race_tag()
	// Default: no specific race tag
	return null

/mob/living/carbon/human/ratworld_get_race_tag()
	// Prefer species id/name if available, fall back to job-based heuristics later if needed
	if(dna && dna.species)
		// Species types we care about should provide an id string in species.id if used
		if(dna.species.id)
			return lowertext("[dna.species.id]")
		// Fallback: use type path name
		return lowertext("[dna.species.type]")
	return null

// Race damage multiplier based on enchant totals on attacker
// attacker: mob doing damage, target: mob receiving damage
// Returns a scalar multiplier to apply to outgoing damage.

/mob/living/proc/ratworld_get_race_damage_mult(mob/living/attacker)
	// By default, no bonus
	return 1

/mob/living/carbon/human/ratworld_get_race_damage_mult(mob/living/attacker)
	if(!attacker)
		return 1
	// Determine target race tag
	var/tag = ratworld_get_race_tag()
	if(!tag)
		return 1

	// Get attacker's aggregated race bonuses (percent values)
	var/undead_bonus = attacker.rw_undead_dmg_pct_total
	var/demon_bonus = attacker.rw_demon_dmg_pct_total
	var/goblin_bonus = attacker.rw_goblin_dmg_pct_total

	var/bonus_pct = 0
	if(findtext(tag, "undead"))
		bonus_pct = undead_bonus
	else if(findtext(tag, "demon"))
		bonus_pct = demon_bonus
	else if(findtext(tag, "goblin"))
		bonus_pct = goblin_bonus

	if(!bonus_pct)
		return 1

	// Cap vs minded vs unminded targets
	var/is_minded = mind != null
	var/max_vs_minded = 100
	var/max_vs_unminded_undead_demon = 450
	var/max_vs_unminded_goblin = 800

	if(is_minded)
		bonus_pct = min(bonus_pct, max_vs_minded)
	else
		if(findtext(tag, "goblin"))
			bonus_pct = min(bonus_pct, max_vs_unminded_goblin)
		else
			bonus_pct = min(bonus_pct, max_vs_unminded_undead_demon)

	return 1 + (bonus_pct / 100)

// Central Ratworld melee damage helper.
// Called from melee attack code to compute final brute and true brute components
// based on base damage, attacker enchants, race bonuses, and armor damage bonus.

/proc/ratworld_compute_melee_damage(mob/living/attacker, mob/living/target, base_brute, obj/item/weapon)
	var/normal = base_brute
	var/true = 0

	if(!attacker || !target || base_brute <= 0)
		return list("normal" = normal, "true" = true, "armor_bonus_pct" = 0)

	// First: physical power and true physical conversion
	var/list/phys_parts = ratworld_split_phys_damage(attacker, base_brute)
	normal = phys_parts["normal"]
	true = phys_parts["true"]

	// Apply race multiplier to both components
	var/race_mult = target.ratworld_get_race_damage_mult(attacker)
	if(race_mult != 1)
		normal *= race_mult
		true *= race_mult

	// Armor durability bonus from enchantments (percent)
	var/armor_bonus_pct = attacker.rw_armor_dmg_bonus_pct_total
	if(armor_bonus_pct < 0)
		armor_bonus_pct = 0

	return list("normal" = normal, "true" = true, "armor_bonus_pct" = armor_bonus_pct)

// Magic damage helper for spells/projectiles that are magical in nature.
// Returns final magic multiplier and true magic percentage to split by caller.

/proc/ratworld_compute_magic_damage(mob/living/attacker, mob/living/target, base_damage)
	if(!attacker || !target || base_damage <= 0)
		return list("mult" = 1, "true_pct" = 0)

	// Outgoing magic multiplier (power + penetration vs defense)
	var/mult = ratworld_compute_magic_multiplier(attacker, target)
	if(mult < 0)
		mult = 0

	// True magic portion from attacker enchants
	var/true_pct = ratworld_get_true_magic_pct(attacker)
	if(true_pct < 0)
		true_pct = 0

	return list("mult" = mult, "true_pct" = true_pct)
