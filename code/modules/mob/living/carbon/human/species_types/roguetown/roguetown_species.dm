/datum/species
	var/amtfail = 0

/proc/get_accent_list_for_name(accent_name, type, convert_HTML = TRUE)
	switch(accent_name)
		if("无口音")
			return
		if("矮人口音")
			return strings("dwarfcleaner_replacement.json", type, convert_HTML = TRUE)
		if("矮人呓语口音")
			return strings("dwarf_replacement.json", type, convert_HTML = TRUE)
		if("黑暗精灵口音")
			return strings("french_replacement.json", type, convert_HTML = TRUE)
		if("精灵口音")
			return strings("russian_replacement.json", type, convert_HTML = TRUE)
		if("格伦泽尔霍夫特口音")
			return strings("german_replacement.json", type, convert_HTML = TRUE)
		if("北伊特鲁斯卡口音")
			return strings("italian_replacement.json", type, convert_HTML = TRUE)
		if("铁锤堡口音")
			return strings("Anglish.json", type, convert_HTML = TRUE)
		if("亚斯玛尔口音")
			return strings("proper_replacement.json", type, convert_HTML = TRUE)
		if("蜥蜴人口音")
			return strings("brazillian_replacement.json", type, convert_HTML = TRUE)
		if("卢皮安口音")
			return strings("polish_replacement.json", type, convert_HTML = TRUE)
		if("提夫林口音")
			return strings("spanish_replacement.json", type, convert_HTML = TRUE)
		if("半兽人口音")
			return strings("middlespeak.json", type, convert_HTML = TRUE)
		if("城镇兽人口音")
			return strings("norf_replacement.json", type, convert_HTML = TRUE)
		if("嘶声口音")
			return strings("hissy_replacement.json", type, convert_HTML = TRUE)
		if("Inzectoid口音")
			return strings("inzectoid_replacement.json", type, convert_HTML = TRUE)
		if("猫科口音")
			return strings("feline_replacement.json", type, convert_HTML = TRUE)
		if("Slopes口音")
			return strings("welsh_replacement.json", type, convert_HTML = TRUE)
		if("索特·阿尔-阿塔什口音")
			return
		if("豪侠腔")
			return strings("gallant_replacement.json", type, convert_HTML = TRUE)
		if("风郡口音")
			return strings("kazengun_replacement.json", type, convert_HTML = TRUE)
		if("信义口音")
			return strings("xinyi_replacement.json", type, convert_HTML = TRUE)
		if("普伊-梅恩口音")
			return strings("puimaen_replacement.json", type, convert_HTML = TRUE)
		if("阿瓦尔口音")
			return strings("russian_replacement.json", type, convert_HTML = TRUE)
		if("海盗腔")
			return strings("axian_replacement.json", type, convert_HTML = TRUE)
		if("下城区口音")
			return strings("poor_replacement.json", type, convert_HTML = TRUE)

/datum/species/proc/get_accent_list(mob/living/carbon/human/H, type, convert_HTML = TRUE)
	return get_accent_list_for_name(H.char_accent, type, convert_HTML)

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


/*
	Lets a player speak a name or foreign word exactly as they typed it by putting \[brackets\]
	around it. For each word or phrase in brackets, we save the original text and leave a
	numbered marker, like "<#1#>", where it was. The accent code doesn't touch the markers
	because they have no letters in them, so afterward accent_escape_restore puts the saved
	text back in place of each marker.
*/
/proc/accent_escape_extract(message, list/escapes)
	// A message starting with '*' is an emote, so skip
	if(!message || message[1] == "*")
		return message
	// This finds one \[insert whatever here\] at a time. Static so it is built once instead of on every call.
	var/static/regex/escape_regex = regex(@"\[([^\]]*)\]?")

	// Search from the start each time, since we rebuild the message whenever we pull one out. Each pass removes an opening bracket, so this always finishes.
	while(escape_regex.Find(message, 1))
		// Save the text that was inside the brackets.
		escapes += (escape_regex.group[1] || "")
		// Swap the \[word\] out for a numbered marker. The number is its place in the escapes list.
		message = copytext(message, 1, escape_regex.index) + "<#[escapes.len]#>" + copytext(message, escape_regex.index + length(escape_regex.match))
	return message

/*
	The other half of accent_escape_extract: puts each saved word back in place of its
	"<#N#>" marker, so the brackets are gone and the original words come back unchanged. Runs
	after the accent code so nothing changes the text
	we bring back.
*/
/proc/accent_escape_restore(message, list/escapes)
	if(!message)
		return message
	// Put each saved word back where its marker is. A player shouldn't be able to fake a marker
	for(var/i in 1 to escapes.len)
		message = replacetext(message, "<#[i]#>", escapes[i])
	return message


/*
	It takes the speaker's five accent word lists and applies each kind of replacement in turn.
	autopunct and do_trim are on for speech, while the emote quote path turns them off so the quoted words are
	left exactly as typed.
*/
/proc/apply_accent_pipeline(message, list/multiword, list/fullword, list/startword, list/endword, list/syllable, autopunct = TRUE, do_trim = TRUE)
	// Only pull out \[\] if the message actually has one, so we skip making the list when there is nothing to escape.
	var/list/accent_escapes
	if(message && findtext(message, "\["))
		accent_escapes = list()
		message = accent_escape_extract(message, accent_escapes)
	// Replace whole words that are made up of more than one word.
	message = treat_message_accent(message, multiword, REGEX_FULLWORD)
	// One pass over each word, applying the shared universal list and this accent's whole-word list at once.
	message = treat_message_accent_fullword(message, strings("accent_universal.json", "universal", convert_HTML = TRUE), fullword)
	// Replace the start of words.
	message = treat_message_accent(message, startword, REGEX_STARTWORD)
	// Replace the end of words.
	message = treat_message_accent(message, endword, REGEX_ENDWORD)
	// Replace letters or syllables anywhere inside words.
	message = treat_message_accent(message, syllable, REGEX_ANY)

	if(autopunct)
		message = autopunct_bare(message)
	if(do_trim)
		message = trim(message)

	// Put the escaped words back last so they stay exactly as typed 
	if(accent_escapes)
		message = accent_escape_restore(message, accent_escapes)
	return message

/*
	The emote version of the say escape brackets, working the other way around where it applies the
	speaker's accent ONLY to text inside "quotes" in a me/subtle emote and
	leaves the rest of the emote alone.
*/
/proc/accent_emote_quotes(message, mob/living/carbon/human/H)
	// Stop early for non-humans or messages with no quotes to handle.
	if(!message || !ishuman(H))
		return message
	if(!findtext(message, "\"") && !findtext(message, "&#34;") && !findtext(message, "&quot;"))
		return message
	var/accent = H.char_accent

	// Look up the speaker's five accent word lists once.
	var/list/multiword = get_accent_list_for_name(accent, "multiword")
	var/list/fullword = get_accent_list_for_name(accent, "full")
	var/list/startword = get_accent_list_for_name(accent, "start")
	var/list/endword = get_accent_list_for_name(accent, "end")
	var/list/syllable = get_accent_list_for_name(accent, "syllable")

	// Built once. Matches an opening quote in any of its three forms
	var/static/regex/quote_regex = regex(@{"(&#34;|&quot;|")([\S\s\n]*?)(&#34;|&quot;|")"})
	var/search_pos = 1

	while(quote_regex.Find(message, search_pos))
		var/match_at = quote_regex.index
		var/match_len = length(quote_regex.match)
		var/open_quote = quote_regex.group[1]
		var/inner_text = quote_regex.group[2]
		var/close_quote = quote_regex.group[3]
		// Accent only the text inside the quotes.
		var/accented = apply_accent_pipeline(inner_text, multiword, fullword, startword, endword, syllable, autopunct = FALSE, do_trim = FALSE)
		// Keep the same quote marks that were matched, whichever form they arrived in.
		var/rebuilt = "[open_quote][accented][close_quote]"
		// Put the accented text (with its quotes) back into the message.
		message = copytext(message, 1, match_at) + rebuilt + copytext(message, match_at + match_len)

		// Move past what we just wrote so we don't scan it again.
		search_pos = match_at + length(rebuilt)
	return message


/proc/apply_accent_preview(accent_name, message)
	if(accent_name == "No accent" || accent_name == "Saut al-Atash accent" || accent_name == "Posh accent")
		return null
	var/list/multiword = get_accent_list_for_name(accent_name, "multiword")
	var/list/fullword = get_accent_list_for_name(accent_name, "full")
	var/list/startword = get_accent_list_for_name(accent_name, "start")
	var/list/endword = get_accent_list_for_name(accent_name, "end")
	var/list/syllable = get_accent_list_for_name(accent_name, "syllable")
	return apply_accent_pipeline(message, multiword, fullword, startword, endword, syllable)


/datum/species/proc/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	var/list/multiword = get_accent_multiword(source)
	var/list/fullword = get_accent(source)
	var/list/startword = get_accent_start(source)
	var/list/endword = get_accent_end(source)
	var/list/syllable = get_accent_any(source)
	speech_args[SPEECH_MESSAGE] = apply_accent_pipeline(message, multiword, fullword, startword, endword, syllable)

/proc/get_value_from_accent(key, list/accent_list)
	if (!key)
		return
	if (!accent_list)
		return
	var/value = accent_list[key]
	if (!value)
		value = accent_list[LOWER_TEXT(key)]
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
