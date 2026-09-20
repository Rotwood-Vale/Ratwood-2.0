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


	// originally i wanted to give new imperial a discerning effect like the radio has, but i found out, that's just too much effort for me.
	// im still intermediate at coding, so ill just make the native speakers just speak imperial but evolved.

	syllables = list(
		// remnants of old Imperial
		"im", "per", "pra", "pro", "ter", "ver",
		"cor", "con", "dom", "est", "eri", "val",
		"qua", "re", "ri", "ta", "te", "us",
		"um", "or", "ar", "en",

		// contracted / evolved Imperial
		"ven", "var", "ren", "tor", "tra", "vor",
		"kar", "dar", "mar", "ser", "vel", "lan",
		"tal", "ran", "den", "sen", "kan", "kor",

		// loan sounds absorbed over time
		"ka", "ko", "ve", "va", "na", "no",
		"za", "ra", "da", "ya", "shi", "ki",
		"gra", "dra", "ska", "vos", "kir", "mor"
	)

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


/proc/setup_timesoldier_languages(mob/living/carbon/human/H)
	if(!H)
		return

	if(!H.mind)
		return

	// languages a player actually knows live on the mind holder.
	var/datum/language_holder/L = H.mind.get_language_holder()

	// we shouldn't know old imperial. we're a soldier, not an archivist.
	L.remove_language(
		/datum/language/common,
		source = LANGUAGE_SOURCE_ALL
	)

	// we know new imperial, for obvious raisins.
	L.grant_language(
		/datum/language/new_imperial,
		source = LANGUAGE_SOURCE_GENERIC
	)

	// make it their default immediately to avoid the bug where you can't select it.
	L.selected_default_language = /datum/language/new_imperial

	// normal human tongues have a whitelist of languages they can physically speak.
	// give THIS tongue New Imperial without modifying the global/static whitelist.
	var/obj/item/organ/tongue/T = H.getorganslot(ORGAN_SLOT_TONGUE)

	if(T)
		if(T.languages_possible)
			T.languages_possible = T.languages_possible.Copy()
		else
			T.languages_possible = list()

		T.languages_possible[/datum/language/new_imperial] = TRUE
