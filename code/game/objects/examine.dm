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

	var/derived_cat = get_derived_category(type)
	var/display_cat = derived_cat
	if(derived_cat)
		var/bucket = get_navigator_bucket_for_item(src, derived_cat)
		if(bucket && bucket != NAVIGATOR_BUCKET_REFUSED_FOOD && bucket != NAVIGATOR_BUCKET_REFUSED_BULK)
			display_cat = bucket
	var/cat_tag = display_cat ? "<b>[display_cat]</b>" : ""

	// The price traits gate ONLY the mammon value - category and quality are always shown.
	var/value_line = "Value: Unknown"
	if(HAS_TRAIT(user, TRAIT_SEEPRICES) || simpleton_price || isobserver(user))
		var/appraised_value = appraise_price()
		if(appraised_value > 0)
			value_line = "Value: [appraised_value] mammon"
	else if(HAS_TRAIT(user, TRAIT_SEEPRICES_SHITTY))
		var/real_value = appraise_price()
		if(real_value > 0)
			var/static/fumbling_seed = text2num(GLOB.rogue_round_id)
			var/fumbled_value = max(1, round(real_value + (real_value * clamp(noise_hash(real_value, fumbling_seed) - 0.25, -0.25, 0.25)), 1))
			value_line = "Value: ~[fumbled_value] mammon (uncertain)"
	// Category always rides along with the value line.
	. += span_info("[value_line][cat_tag ? " - [cat_tag]" : ""].")
	
	var/list/quality_data = quality_examine_suffix()
	if(quality_data)
		switch(quality_data["style"])
			if("warning")
				. += span_warning("[quality_data["text"]].")
			if("green")
				. += span_green("[quality_data["text"]].")
			else
				. += span_info("[quality_data["text"]].")

	if(smeltresult)
		var/obj/item/smelted = smeltresult
		. += span_info("Smelts into [smelted.name].")

	if(nudist_approved)
		if(HAS_TRAIT(user, TRAIT_NUDE_SLEEPER))
			. += span_smallnotice("I can tolerate having this on when I sleep.")
		else if(HAS_TRAIT(user, TRAIT_NUDIST))
			. += span_smallnotice("I can tolerate wearing this.")


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
	if(!runes || !runes.len)
		setup_alchemical_runes()

	if(user && user.mind && runes && runes.len)
		var/alch_skill = user.get_skill_level(/datum/skill/craft/alchemy)

		if(runes[ALCH_RUNE_RAINBOW])
			var/lvl = runes[ALCH_RUNE_RAINBOW]
			var/lvl_roman = "I"
			if(lvl == 2) lvl_roman = "II"
			if(lvl == 3) lvl_roman = "III"

			var/rainbow_word = "<span style='color:#ff3333;text-shadow:0 0 3px #ff3333;'>R</span>" \
			                 + "<span style='color:#ff9933;text-shadow:0 0 3px #ff9933;'>a</span>" \
			                 + "<span style='color:#ffff33;text-shadow:0 0 3px #ffff33;'>i</span>" \
			                 + "<span style='color:#33ff33;text-shadow:0 0 3px #33ff33;'>n</span>" \
			                 + "<span style='color:#33ccff;text-shadow:0 0 3px #33ccff;'>b</span>" \
			                 + "<span style='color:#cc33ff;text-shadow:0 0 3px #cc33ff;'>o</span>" \
			                 + "<span style='color:#ff33cc;text-shadow:0 0 3px #ff33cc;'>w</span>"

			. += "<span style='color: #ffd700;'>It shimmers with a prismatic, iridescent glow ([rainbow_word] <span style='color:#ffffff;font-weight:bold;text-shadow:0 0 4px #ff00ff;'>Rune [lvl_roman]</span>)!</span>"

		else if(HAS_TRAIT(user, TRAIT_LEGENDARY_ALCHEMIST) || alch_skill >= SKILL_LEVEL_EXPERT)
			var/list/rune_strings = list()
			if(runes[ALCH_RUNE_RED])
				rune_strings += "<span style='color: #ff4d4d; font-weight: bold;'>[runes[ALCH_RUNE_RED]] Red</span>"
			if(runes[ALCH_RUNE_GREEN])
				rune_strings += "<span style='color: #5cd65c; font-weight: bold;'>[runes[ALCH_RUNE_GREEN]] Green</span>"
			if(runes[ALCH_RUNE_BLUE])
				rune_strings += "<span style='color: #4da6ff; font-weight: bold;'>[runes[ALCH_RUNE_BLUE]] Blue</span>"

			if(rune_strings.len)
				. += span_notice("Alchemical Composition: [english_list(rune_strings)].")

		else if(alch_skill >= SKILL_LEVEL_JOURNEYMAN)
			var/list/present_colors = list()
			var/max_amt = 0
			var/dominant_color = null

			for(var/r in runes)
				if(runes[r] > 0)
					present_colors += r
					if(runes[r] > max_amt)
						max_amt = runes[r]
						dominant_color = r

			if(present_colors.len == 1)
				if(dominant_color == ALCH_RUNE_RED)
					. += span_notice("It faintly pulses with pure vital warmth (Red essence).")
				else if(dominant_color == ALCH_RUNE_GREEN)
					. += span_notice("It smells purely of rich natural juices (Green essence).")
				else if(dominant_color == ALCH_RUNE_BLUE)
					. += span_notice("It carries an unmistakable arcane resonance (Blue essence).")

			else if(present_colors.len > 1)
				var/tied_count = 0
				for(var/r in present_colors)
					if(runes[r] == max_amt)
						tied_count++

				if(tied_count > 1)
					. += span_notice("It possesses a harmonious equilibrium of opposing alchemical essences.")
				else
					var/dom_text = ""
					if(dominant_color == ALCH_RUNE_RED) dom_text = "vital warmth"
					if(dominant_color == ALCH_RUNE_GREEN) dom_text = "natural juices"
					if(dominant_color == ALCH_RUNE_BLUE) dom_text = "arcane energy"
					
					. += span_notice("It contains a complex blend of essences, with a lingering note of [dom_text].")

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

