/datum/species
	var/amtfail = 0

/datum/species/proc/get_accent_list(mob/living/carbon/human/H, type, convert_HTML = TRUE)
	switch(H.char_accent)
		if("No accent")
			return
		if("Dwarf accent")
			return strings("dwarfcleaner_replacement.json", type, convert_HTML = TRUE)
		if("Dwarf Gibberish accent")
			return strings("dwarf_replacement.json", type, convert_HTML = TRUE)
		if("Dark Elf accent")
			return strings("french_replacement.json", type, convert_HTML = TRUE)
		if("Elf accent")
			return strings("russian_replacement.json", type, convert_HTML = TRUE)
		if("Grenzelhoft accent")
			return strings("german_replacement.json", type, convert_HTML = TRUE)
		if("North Etruscan accent")
			return strings("italian_replacement.json", type, convert_HTML = TRUE)
		if("Hammerhold accent")
			return strings("Anglish.json", type, convert_HTML = TRUE)
		if("Assimar accent")
			return strings("proper_replacement.json", type, convert_HTML = TRUE)
		if("Lizard accent")
			return strings("brazillian_replacement.json", type, convert_HTML = TRUE)
		if("Lupian accent")
			return strings("polish_replacement.json", type, convert_HTML = TRUE)
		if("Tiefling accent")
			return strings("spanish_replacement.json", type, convert_HTML = TRUE)
		if("Half Orc accent")
			return strings("middlespeak.json", type, convert_HTML = TRUE)
		if("Urban Orc accent")
			return strings("norf_replacement.json", type, convert_HTML = TRUE)
		if("Hissy accent")
			return strings("hissy_replacement.json", type, convert_HTML = TRUE)
		if("Inzectoid accent")
			return strings("inzectoid_replacement.json", type, convert_HTML = TRUE)
		if("Feline accent")
			return strings("feline_replacement.json", type, convert_HTML = TRUE)
		if("Slopes accent")
			return strings("welsh_replacement.json", type, convert_HTML = TRUE)
		if("Saut al-Atash accent")
			return
		if("Valley accent")
			return strings("valley_replacement.json", type, convert_HTML = TRUE)
		if("Kazengun accent")
			return strings("kazengun_replacement.json", type, convert_HTML = TRUE)
		if("Xinyi accent")
			return strings("xinyi_replacement.json", type, convert_HTML = TRUE)
		if("Pui-Maen accent")
			return strings("puimaen_replacement.json", type, convert_HTML = TRUE)
		if("Avar accent")
			return strings("russian_replacement.json", type, convert_HTML = TRUE)
		if("Pirate accent")
			return strings("axian_replacement.json", type, convert_HTML = TRUE)

/datum/species/proc/get_accent(mob/living/carbon/human/H)
	return get_accent_list(H,"full")

/datum/species/proc/get_accent_multiword(mob/living/carbon/human/H)
	return get_accent_list(H,"multiword")

/datum/species/proc/get_accent_any(mob/living/carbon/human/H) //determines if accent replaces in-word text
	return get_accent_list(H,"syllable")

/datum/species/proc/get_accent_start(mob/living/carbon/human/H)
	return get_accent_list(H,"start")

/datum/species/proc/get_accent_end(mob/living/carbon/human/H)
	return get_accent_list(H,"end")

#define REGEX_FULLWORD 1
#define REGEX_STARTWORD 2
#define REGEX_ENDWORD 3
#define REGEX_ANY 4

/datum/species/proc/handle_speech(datum/source, mob/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]

	//message = treat_message_accent(message, strings("accent_universal.json", "universal"), REGEX_FULLWORD)

	message = treat_message_accent(message, get_accent_multiword(source), REGEX_FULLWORD)
	message = treat_message_accent_fullword(message, strings("accent_universal.json", "universal", convert_HTML = TRUE), get_accent(source))
	message = treat_message_accent(message, get_accent_start(source), REGEX_STARTWORD)
	message = treat_message_accent(message, get_accent_end(source), REGEX_ENDWORD)
	message = treat_message_accent(message, get_accent_any(source), REGEX_ANY)

	message = autopunct_bare(message)

	speech_args[SPEECH_MESSAGE] = trim(message)

/proc/get_value_from_accent(key, list/accent_list)
	if (!key)
		return
	if (!accent_list)
		return
	var/value = accent_list[key]
	if (!value)
		value = accent_list[lowertext(key)]
	if (!value)
		value = accent_list[uppertext(key)]
	if (!value)
		value = accent_list[capitalize(key)]
	return value

/*
	full word replacement proc for accents that only iterates through each word in the chat message instead of every entry in the json
	takes both universal accent and the selected accent and applies them both at once
*/
/proc/treat_message_accent_fullword(message, list/universal, list/accent_list)
	if(!message)
		return
	if(!accent_list && !universal)
		return message
	if(message[1] == "*")
		return message
	message = "[message]"
	var/list/message_words = splittext_char(message, regex("\[^(&#39;|\\w)\]+"))
	for (var/key in message_words)
		var/value = get_value_from_accent(key, accent_list)
		if (!value)
			value = get_value_from_accent(key, universal)
		if (!value)
			continue
		if (islist(value))
			value = pick(value)
		message = replacetextEx(message, regex("\\b[uppertext(key)]\\b|\\A[uppertext(key)]\\b|\\b[uppertext(key)]\\Z|\\A[uppertext(key)]\\Z", "(\\w+)/g"), uppertext(value))
		message = replacetextEx(message, regex("\\b[capitalize(key)]\\b|\\A[capitalize(key)]\\b|\\b[capitalize(key)]\\Z|\\A[capitalize(key)]\\Z", "(\\w+)/g"), capitalize(value))
		message = replacetextEx(message, regex("\\b[key]\\b|\\A[key]\\b|\\b[key]\\Z|\\A[key]\\Z", "(\\w+)/g"), value)
	return message

/proc/treat_message_accent(message, list/accent_list, chosen_regex)
	if(!message)
		return
	if(!accent_list)
		return message
	if(message[1] == "*")
		return message
	message = "[message]"
	for(var/key in accent_list)
		var/value = accent_list[key]
		if(islist(value))
			value = pick(value)

		switch(chosen_regex)
			if(REGEX_FULLWORD)
				// Full word regex (full world replacements)
				message = replacetextEx(message, regex("\\b[uppertext(key)]\\b|\\A[uppertext(key)]\\b|\\b[uppertext(key)]\\Z|\\A[uppertext(key)]\\Z", "(\\w+)/g"), uppertext(value))
				message = replacetextEx(message, regex("\\b[capitalize(key)]\\b|\\A[capitalize(key)]\\b|\\b[capitalize(key)]\\Z|\\A[capitalize(key)]\\Z", "(\\w+)/g"), capitalize(value))
				message = replacetextEx(message, regex("\\b[key]\\b|\\A[key]\\b|\\b[key]\\Z|\\A[key]\\Z", "(\\w+)/g"), value)
			if(REGEX_STARTWORD)
				// Start word regex (Some words that get different endings)
				message = replacetextEx(message, regex("\\b[uppertext(key)]|\\A[uppertext(key)]", "(\\w+)/g"), uppertext(value))
				message = replacetextEx(message, regex("\\b[capitalize(key)]|\\A[capitalize(key)]", "(\\w+)/g"), capitalize(value))
				message = replacetextEx(message, regex("\\b[key]|\\A[key]", "(\\w+)/g"), value)
			if(REGEX_ENDWORD)
				// End of word regex (Replaces last letters of words)
				message = replacetextEx(message, regex("[uppertext(key)]\\b|[uppertext(key)]\\Z", "(\\w+)/g"), uppertext(value))
				message = replacetextEx(message, regex("[key]\\b|[key]\\Z", "(\\w+)/g"), value)
			if(REGEX_ANY)
				// Any regex (syllables)
				// Careful about use of syllables as they will continually reapply to themselves, potentially canceling each other out
				message = replacetextEx(message, uppertext(key), uppertext(value))
				message = replacetextEx(message, key, value)

	return message

#undef REGEX_FULLWORD
#undef REGEX_STARTWORD
#undef REGEX_ENDWORD
#undef REGEX_ANY
