/datum/examine_effect/proc/trigger(mob/user)
	return

/datum/examine_effect/proc/get_examine_line(mob/user)
	return

/obj/item/proc/quality_examine_suffix()
	if(!has_item_quality)
		return null
	var/qpct = round(ITEM_QUALITY_MULT(item_quality) * 100)
	var/word
	var/style = "info"
	switch(item_quality)
		if(ITEM_QUALITY_LOOTED)
			word = "scavenged"
			style = "warning"
		if(ITEM_QUALITY_RUINED)
			word = "ruined"
			style = "warning"
		if(ITEM_QUALITY_AWFUL)
			word = "awful"
			style = "warning"
		if(ITEM_QUALITY_CRUDE)
			word = "crude"
			style = "warning"
		if(ITEM_QUALITY_ROUGH)
			word = "rough"
		if(ITEM_QUALITY_STANDARD)
			word = "standard"
		if(ITEM_QUALITY_FINE)
			word = "fine"
		if(ITEM_QUALITY_FLAWLESS)
			word = "flawless"
			style = "green"
		if(ITEM_QUALITY_MASTERWORK)
			word = "masterwork"
			style = "green"
	if(!word)
		return null
	return list("text" = "Quality: <b>[capitalize(word)]</b> ([qpct]% value)", "style" = style)

/obj/item/examine(mob/user) //This might be spammy. Remove?
	. = ..()

	. += integrity_check()

	var/real_value = get_real_price()
	if(real_value > 0)
		if(HAS_TRAIT(user, TRAIT_SEEPRICES) || simpleton_price)
			. += span_info("Value: [real_value] mammon")

		else if(HAS_TRAIT(user, TRAIT_SEEPRICES_SHITTY))
			//you can get up to 50% of the value if you have shitty see prices
			var/static/fumbling_seed = text2num(GLOB.rogue_round_id)
			var/fumbled_value = max(1, round(real_value + (real_value * clamp(noise_hash(real_value, fumbling_seed) - 0.25, -0.25, 0.25)), 1))
			. += span_info("Value: [fumbled_value] mammon... <i>I think</i>")

	if(smeltresult)
		var/obj/item/smelted = smeltresult
		. += span_info("Smelts into [smelted.name].")

	if(nudist_approved)
		if(HAS_TRAIT(user, TRAIT_NUDE_SLEEPER))
			. += span_smallnotice("I can tolerate having this on when I sleep.")
		else if(HAS_TRAIT(user, TRAIT_NUDIST))
			. += span_smallnotice("I can tolerate wearing this.")

	var/list/quality_data = quality_examine_suffix()
	if(quality_data)
		switch(quality_data["style"])
			if("warning")
				. += span_warning("[quality_data["text"]].")
			if("green")
				. += span_green("[quality_data["text"]].")
			else
				. += span_info("[quality_data["text"]].")

	var/list/seals = list()
	if(atc_sealed)
		seals += "ATC seal"
	if(unmintable)
		seals += "town-property stamp"
	if(length(seals))
		. += span_info("Marked with [english_list(seals)] - the navigator will not take it.")
	else if(was_crafted)
		. += span_info("It appears to be crafted by the hand of a local artisan.")
	else if(is_carved)
		. += span_info("It is a carved item.")
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
		return span_warning("It's broken.")
	switch(int_percent)
		if(1 to 15)
			result = span_warning("It's nearly broken.")
		if(16 to 30)
			result = span_warning("It's severely damaged.")
		if(31 to 80)
			result = span_warning("It's damaged.")
		if(80 to 99)
			result = span_warning("It's a little damaged.")
	return result

/obj/item/clothing/integrity_check(elaborate = FALSE)
	if(obj_broken)
		return span_warning("It's broken.")

	var/eff_maxint = max_integrity - (max_integrity * integrity_failure)
	var/eff_currint = max(obj_integrity - (max_integrity * integrity_failure), 0)
	var/ratio =	(eff_currint / eff_maxint)
	var/percent = round((ratio * 100), 1)
	var/result
	if(percent < 100)
		switch(percent)
			if(1 to 15)
				result = span_warning("It's nearly broken.")
			if(16 to 30)
				result = span_warning("It's severely damaged.")
			if(31 to 80)
				result = span_warning("It's damaged.")
			if(80 to 99)
				result = span_warning("It's a little damaged.")
	return result

