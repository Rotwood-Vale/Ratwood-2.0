/datum/examine_effect/proc/trigger(mob/user)
	return

/datum/examine_effect/proc/get_examine_line(mob/user)
	return

/obj/item/examine(mob/user) //This might be spammy. Remove?
	. = ..()

	. += integrity_check()

	var/real_value = get_real_price()
	if(real_value > 0)
		if(HAS_TRAIT(user, TRAIT_SEEPRICES) || simpleton_price)
			. += span_info("价值：[real_value] 玛门")

		else if(HAS_TRAIT(user, TRAIT_SEEPRICES_SHITTY))
			//you can get up to 50% of the value if you have shitty see prices
			var/static/fumbling_seed = text2num(GLOB.rogue_round_id)
			var/fumbled_value = max(1, round(real_value + (real_value * clamp(noise_hash(real_value, fumbling_seed) - 0.25, -0.25, 0.25)), 1))
			. += span_info("价值：[fumbled_value] 玛门...<i>大概</i>")

	if(smeltresult)
		var/obj/item/smelted = smeltresult
		. += span_info("可被冶炼成[smelted.name]。")
	
	if(nudist_approved)
		if(HAS_TRAIT(user, TRAIT_NUDE_SLEEPER))
			. += span_smallnotice("穿着这个睡觉我也能接受。")
		else if(HAS_TRAIT(user, TRAIT_NUDIST))
			. += span_smallnotice("穿这个我倒是不介意。")

	for(var/datum/examine_effect/E in examine_effects)
		E.trigger(user)

/obj/item/proc/integrity_check(elaborate = FALSE)
	if(!max_integrity)
		return
	if(obj_integrity == max_integrity)
		return

	var/int_percent = round(((obj_integrity / max_integrity) * 100), 1)
	var/result

	if(obj_broken)
		return span_warning("它完全损坏了。")
	switch(int_percent)
		if(1 to 15)
			result = span_warning("它快要散架了。")
		if(16 to 30)
			result = span_warning("它严重损坏了。")
		if(31 to 80)
			result = span_warning("它受损了。")
		if(80 to 99)
			result = span_warning("它有一点损坏。")
	return result

/obj/item/clothing/integrity_check(elaborate = FALSE)
	if(obj_broken)
		return span_warning("它完全损坏了。")

	var/eff_maxint = max_integrity - (max_integrity * integrity_failure)
	var/eff_currint = max(obj_integrity - (max_integrity * integrity_failure), 0)
	var/ratio =	(eff_currint / eff_maxint)
	var/percent = round((ratio * 100), 1)
	var/result
	if(percent < 100)
		switch(percent)
			if(1 to 15)
				result = span_warning("它快要散架了。")
			if(16 to 30)
				result = span_warning("它严重损坏了。")
			if(31 to 80)
				result = span_warning("它受损了。")
			if(80 to 99)
				result = span_warning("它有一点损坏。")
	return result
	
