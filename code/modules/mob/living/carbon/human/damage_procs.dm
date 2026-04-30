/mob/living/carbon/human/apply_damage(damage = 0,damagetype = BRUTE, def_zone = null, blocked = FALSE, forced = FALSE, spread_damage = FALSE, burn_flag = BURN_FLAG_NONE)
	// depending on the species, it will run the corresponding apply_damage code there
	if(dna)
		return dna.species.apply_damage(damage, damagetype, def_zone, blocked, src, forced, spread_damage, burn_flag)
