/// Checks if a mob being attacked is able to block or dodge an attack
/mob/living/proc/checkdefense(datum/intent/intenty, mob/living/attacker)
	testing("begin defense")
	if(!intenty || !attacker)
		CRASH("/mob/living/checkdefense called without passing a intent or attacker.")
	if(!cmode)
		return FALSE
	if(stat)
		return FALSE
	if(!mob_can_parry && !mob_can_dodge) //mob can do neither of these
		return FALSE
	if(attacker == src)
		return FALSE
	if(!(mobility_flags & MOBILITY_MOVE))
		return FALSE

	if(client && used_intent)
		if(client.charging && used_intent.tranged && !used_intent.tshield)
			return FALSE

	switch(d_intent)
		if(INTENT_PARRY)
			return attempt_parry(intenty, attacker)
		if(INTENT_DODGE)
			return attempt_dodge(intenty, attacker)
