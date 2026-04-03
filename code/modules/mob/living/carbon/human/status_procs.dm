
/mob/living/carbon/human/Stun(amount, updating = TRUE, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/Knockdown(amount, updating = TRUE, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src,amount)
	return ..()

/mob/living/carbon/human/Paralyze(amount, updating = TRUE, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Immobilize(amount, updating = TRUE, ignore_canstun = FALSE)
	amount = dna.species.spec_stun(src, amount)
	return ..()

/mob/living/carbon/human/Unconscious(amount, updating = 1, ignore_canstun = 0)
	amount = dna.species.spec_stun(src,amount)
	if(HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
		amount *= rand(1.25, 1.3)
	return ..()

/mob/living/carbon/human/Sleeping(amount, updating = 1, ignore_canstun = 0)
	if(HAS_TRAIT(src, TRAIT_HEAVY_SLEEPER))
		amount *= rand(1.25, 1.3)
	return ..()

/mob/living/carbon/human/cure_husk(list/sources)
	. = ..()
	if(.)
		update_hair()

/mob/living/carbon/human/become_husk(source)
	. = ..()
	if(.)
		update_hair()

/mob/living/carbon/human/set_drugginess(amount)
	..()
//	if(!amount)
//		remove_language(/datum/language/beachbum)

/mob/living/carbon/human/adjust_drugginess(amount)
	..()
//	if(!dna.check_mutation(STONER))
//		if(druggy)
//			grant_language(/datum/language/beachbum)
//		else
//			remove_language(/datum/language/beachbum)

/mob/living/carbon/human/proc/get_temp_modifier()
	var/modifier = 0

	// Map-specific adjustments
	if(SSmapping.config.map_name == "Rockhill")	//rockhill temperatures are moderate and wet climate
	// Time-of-day adjustments
		if(time_flags & TIME_OF_DAY_BIT_DAY)
			modifier += 20
		else if(time_flags & TIME_OF_DAY_BIT_NIGHT)
			modifier -= 20

	else if(SSmapping.config.map_name == "Desert Town")	//desert map has wild temperature swings
		if(time_flags & TIME_OF_DAY_BIT_DAY)
			modifier += 100							//300+100 is 400, in the middle of the 'hot' temperature range
		else if(time_flags & TIME_OF_DAY_BIT_NIGHT)
			modifier -= 100							//300-100 is 200, in the middle of the 'cold' temperature range

	else if(SSmapping.config.map_name == "Dun World")//Dunworld is colder then the other two maps
		if(time_flags & TIME_OF_DAY_BIT_DAY)
			modifier += 0							//No bonus for day time temperatures
		else if(time_flags & TIME_OF_DAY_BIT_NIGHT)
			modifier -= 60							//300-60 is 240, just enough for cold temperature outside, but not cold enough to cause hypothermia on water and other problems
	return modifier
