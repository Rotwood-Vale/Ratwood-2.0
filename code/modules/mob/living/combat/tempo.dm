/// Adds the attacker to the tracked list for attacker count
/mob/living/carbon/human/proc/process_tempo_attack(mob/living/carbon/attacker)
	//if(!iscarbon(attacker) || !attacker.mind || attacker == src)
	//	return // No self-tempo or PvE tempo
	var/datum/weakref/attacker_ref = WEAKREF(attacker)

	var/tempo_length = length(tempo_attackers)
	var/newtime
	switch(tempo_length)
		if(0 to TEMPO_ONE)
			newtime = TEMPO_DELAY_ONE
		if(TEMPO_TWO)
			newtime = TEMPO_DELAY_TWO
		if(TEMPO_MAX to TEMPO_CAP)
			newtime = TEMPO_DELAY_MAX

	if(length(tempo_attackers) >= TEMPO_CAP && !(attacker_ref in tempo_attackers)) // Lets remove the first attacker from the list to place in our new one
		deltimer(tempo_attackers[1])
		popleft(tempo_attackers)

	if(attacker_ref in tempo_attackers) // Refresh our timer
		deltimer(tempo_attackers[attacker_ref])

	tempo_attackers[attacker_ref] += addtimer(CALLBACK(src, PROC_REF(drop_from_attackers), attacker_ref), newtime, TIMER_STOPPABLE)
	manage_tempo()

/// Simply removes the attacker from the tempo list
/mob/living/carbon/human/proc/drop_from_attackers(datum/weakref/old_attacker_ref)
	list_clear_nulls(tempo_attackers)
	tempo_attackers -= old_attacker_ref
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
