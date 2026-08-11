/// Adds the attacker to the tracked list for attacker count
/mob/living/carbon/human/proc/process_tempo_attack(mob/living/carbon/attacker)
	if(!iscarbon(attacker) || !attacker.mind || attacker == src)
		return // No self-tempo or PvE tempo
	if(length(tempo_attackers) >= TEMPO_CAP && !(attacker in tempo_attackers))
		return //This list auto-culls so we don't need to flood it. If you're fighting 7 dudes at the same time you've got other problems.

	var/newtime
	var/att_count = length(tempo_attackers)
	switch(att_count)
		if(0 to TEMPO_ONE)
			newtime = world.time + TEMPO_DELAY_ONE
		if(TEMPO_TWO)
			newtime = world.time + TEMPO_DELAY_TWO
		if(TEMPO_MAX to TEMPO_CAP)
			newtime = world.time + TEMPO_DELAY_MAX
	tempo_attackers[attacker] = newtime
	next_tempo_cull = world.time + TEMPO_CULL_DELAY	//We reset the autocull timer on a hit from a valid person.
	manage_tempo()

/// Changes your tempo level based on the amount of players attacking you
/mob/living/carbon/human/proc/manage_tempo()
	var/newcount
	newcount = length(tempo_attackers)
	switch(newcount)
		if(TEMPO_MAX to TEMPO_CAP)
			apply_status_effect(/datum/status_effect/buff/tempo_three)
			remove_status_effect(/datum/status_effect/buff/tempo_two)
			remove_status_effect(/datum/status_effect/buff/tempo_one)
		if(TEMPO_TWO)
			apply_status_effect(/datum/status_effect/buff/tempo_two)
			remove_status_effect(/datum/status_effect/buff/tempo_three)
			remove_status_effect(/datum/status_effect/buff/tempo_one)
		if(TEMPO_ONE)
			apply_status_effect(/datum/status_effect/buff/tempo_one)
			remove_status_effect(/datum/status_effect/buff/tempo_three)
			remove_status_effect(/datum/status_effect/buff/tempo_two)
		if(0 to (TEMPO_ONE - 1))
			remove_status_effect(/datum/status_effect/buff/tempo_one)
			remove_status_effect(/datum/status_effect/buff/tempo_two)
			remove_status_effect(/datum/status_effect/buff/tempo_three)

/mob/living/carbon/human/proc/cull_tempo_list()
	list_clear_nulls(tempo_attackers)	//I pray this never returns TRUE
	for(var/mob in tempo_attackers)
		if(tempo_attackers[mob] < world.time)
			tempo_attackers.Remove(mob)
	manage_tempo()

/mob/living/carbon/human/proc/clear_tempo_all()
	if(length(tempo_attackers))
		LAZYCLEARLIST(tempo_attackers)
		to_chat(src, span_info("My muscles relax. My tempo is gone."))
		manage_tempo()

/mob/living/proc/get_tempo_bonus(id)
	switch(id)
		//Bonus CDR for rclicks
		if(TEMPO_TAG_RCLICK_CD_BONUS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 2 SECONDS
			else if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 4 SECONDS
			else if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 7 SECONDS
		//Bonus parry CDR. Note that default is 1.2 SECONDS
		if(TEMPO_TAG_PARRYCD_BONUS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.2 SECONDS
			else if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.4 SECONDS
			else if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.6 SECONDS
		//Modifier for how much integ damage the weapon we parry with takes. Multiplier.
		if(TEMPO_TAG_DEF_INTEGFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.75
			else if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.66
			else if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.62
		//Modifier for how much LESS sharpness we lose with the weapon we parry. Flat number.
		if(TEMPO_TAG_DEF_SHARPNESSFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 1
			else if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 2
			else if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 3 //No default sharpness lost at max Tempo.
		//Whether we can parry without seeing the enemy
		if(TEMPO_TAG_NOLOS_PARRY)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			else if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return TRUE
			else if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return TRUE
			else
				return FALSE
		//How much less armor integ we lose on hit. Multiplier. (0 to 1)
		if(TEMPO_TAG_ARMOR_INTEGFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.8
			else if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.7
			else if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.6
		//How much stamloss we take away from dodging. Flat number.
		if(TEMPO_TAG_STAMLOSS_DODGE)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 1
			else if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 1
			else if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 2
		//How much stamloss we take away from parrying. Flat number.
		if(TEMPO_TAG_STAMLOSS_PARRY)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 1
			else if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 2
			else if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 3
