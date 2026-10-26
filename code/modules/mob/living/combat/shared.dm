/mob/living/proc/ancestor_reroll(prob2defend)
	if(!HAS_TRAIT(src, TRAIT_ANCESTOR_GUARDIAN) || mob_timers["ancestor_reroll"] == GLOB.dayspassed)
		return FALSE
	mob_timers["ancestor_reroll"] = GLOB.dayspassed
	if(!prob(prob2defend))
		return FALSE
	visible_message(span_warning("[src]'s movements are supernaturally quick!"), span_notice("Ancestors guide my hand!"))
	return TRUE

/mob/living/carbon/human/proc/calculate_sentinel_bonus()
	if(STAINT > 10)
		var/fakeint = STAINT
		if(length(status_effects))
			for(var/datum/status_effect/status as anything in status_effects)
				if(length(status.effectedstats) && status.effectedstats["intelligence"] > 0)
					fakeint -= status.effectedstats["intelligence"]
		if(fakeint > 10)
			var/bonus = round(((fakeint - 10) / 2)) * 10
			if(bonus > 0)
				if(HAS_TRAIT(src, TRAIT_HEAVYARMOR) || HAS_TRAIT(src, TRAIT_MEDIUMARMOR) || HAS_TRAIT(src, TRAIT_DODGEEXPERT) || HAS_TRAIT(src, TRAIT_CRITICAL_RESISTANCE))
					bonus = clamp(bonus, 0, 25)
				else
					bonus = clamp(bonus, 0, 50)//20-21 INT
			return bonus
		else
			return 0
	else
		return 0

/// Gets the "true" value of a stat on a human mob by eliminating all status effect modifiers that affect that stat.
/mob/living/proc/get_true_stat(stat)
	var/fakestat = get_stat(stat)
	if(status_effects.len)
		for(var/S in status_effects)
			var/datum/status_effect/status = S
			if(status.effectedstats.len)
				if(status.effectedstats[stat])
					if(status.effectedstats[stat] > 0)
						fakestat -= status.effectedstats[stat]
	return fakestat

/mob/living/proc/get_tempo_bonus(id)
	switch(id)
		//Bonus CDR for rclicks
		if(TEMPO_TAG_RCLICK_CD_BONUS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 5 SECONDS
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 10 SECONDS
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 15 SECONDS
		//Bonus parry CDR. Note that default is 1.2 SECONDS
		if(TEMPO_TAG_PARRYCD_BONUS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.2 SECONDS
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.4 SECONDS
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.6 SECONDS
			else
				return 0
		//Modifier for how much integ damage the weapon we parry with takes. Multiplier.
		if(TEMPO_TAG_DEF_INTEGFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.75
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.5
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.25
		//Modifier for how much LESS sharpness we lose with the weapon we parry. Flat number.
		if(TEMPO_TAG_DEF_SHARPNESSFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 1
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 2
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 3	//No default sharpness lost at max Tempo.
		//Whether we can parry without seeing the enemy
		if(TEMPO_TAG_NOLOS_PARRY)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return TRUE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return TRUE
			else
				return FALSE
		//Whether we care about our attacker being in our FOV when dodging.
		if(TEMPO_TAG_NOLOS_DODGE)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return TRUE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return TRUE
			else
				return FALSE
		//How much less armor integ we lose on hit. Multiplier. (0 to 1)
		if(TEMPO_TAG_ARMOR_INTEGFACTOR)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 0.8
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 0.7
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 0.6
		//How much stamloss we take away from dodging. Flat number.
		if(TEMPO_TAG_STAMLOSS_DODGE)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 4
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 6
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 8
		//How much stamloss we take away from parrying. Flat number.
		if(TEMPO_TAG_STAMLOSS_PARRY)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return 1
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return 2
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return 3
		//Whether our baiters / feinters have to be in FOV of us.
		if(TEMPO_TAG_FEINTBAIT_FOV)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return TRUE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return TRUE
		//Whether we lose max dodge and increase our dodge delay after a dodge.
		if(TEMPO_TAG_DODGE_LOSS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return TEMPO_DODGE_LOSS_LESS
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return TEMPO_DODGE_LOSS_NONE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return TEMPO_DODGE_LOSS_NONE
			else
				return TEMPO_DODGE_LOSS_NORMAL
		//Whether we can get binded.
		if(TEMPO_TAG_BINDABLE)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return FALSE
			else
				return TRUE
		//Whether we can lose our equipment at all when its integrity breaks.
		if(TEMPO_TAG_EQUIPTOSS)
			if(has_status_effect(/datum/status_effect/buff/tempo_one))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_two))
				return FALSE
			if(has_status_effect(/datum/status_effect/buff/tempo_three))
				return FALSE
			else
				return TRUE

/// Weapon faced and zone aimed at, for dodge and parry logs. Built at the log site, so misses cost nothing.
/proc/defense_log_note(mob/user)
	var/obj/item/attacker_weapon = user?.used_intent?.masteritem
	return "[attacker_weapon ? "(against [attacker_weapon]) " : ""](AIMED: [uppertext(parse_zone(user?.zone_selected))])"
