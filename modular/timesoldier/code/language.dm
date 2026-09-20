/datum/language/new_imperial
	name = "New Imperial"
	desc = "After decades of Imperial being spoken freely with many, many people, it has evolved to incorporate a lot of common words from other languages. Old Imperial speakers can discern it, if they try hard enough."
	key = "?"
	default_priority = 0
	icon_state = "galcom"
	speech_verb = "says"
	whisper_verb = "whispers"
	exclaim_verb = "yells"
	ask_verb = "asks"


/datum/language/new_imperial/proc/translate_for(mob/living/hearer, message)
	if(!isliving(hearer))
		return "\[The speech is completely unintelligible.\]"

	var/mob/living/L = hearer
	// if we know new imperial, then we obviously understand it. duh.
	if(L.has_language(/datum/language/new_imperial))
		return message

	if(!ishuman(L))
		return "\[The speech is completely unintelligible.\]" // this probably makes it so druids never understand it. deserved. animals are dumb!!!

	var/mob/living/carbon/human/H = hearer

	if(H.STAINT <= 10)
		return "\[The words are completely unfamiliar.\]" // dumbass.

	if(H.STAINT < 14)
		return partial_comprehension(message, prob(35) ? 2: 1) // sometimes you can tell one word out. sometimes two.

	if(H.STAINT < 17)
		return partial_comprehension(message, prob(35) ? 3 : 2) // sometimes you can tell two words out, sometimes three!

	return message // if we're super smart (17+ int), we understand it all.

/datum/language/new_imperial/proc/partial_comprehension(message, word_count)
	var/list/words = splittext(message, " ")

	if(!length(words))
		return "\[The words sound vaguely familiar..\]"

	var/list/discerned = list()

	while(length(discerned) < word_count && length(words))
		var/word = pick(words)
		words -= word

		word = replacetext(word, ".", "")
		word = replacetext(word, ",", "")
		word = replacetext(word, "!", "")
		word = replacetext(word, "?", "")
		word = replacetext(word, "\"", "")

		if(length(word) < 3)
			continue
		discerned += capitalize(word)
	
	if(!length(discerned))
		return "\[The speech sounds strangely familiar, but I cannot make anything out..\]"

	if(length(discerned) == 1)
		return "\[Something about...[discerned[1]]?\]"

	if(length(discerned) == 2)
		return "\[Something about... [discerned[1]]... and [discerned[2]]?\]"

	return "\[Something about... [discerned[1]]... [discerned[2]]... and [discerned[3]]?\]"
