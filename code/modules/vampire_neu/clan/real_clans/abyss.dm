/// Baali from aliexpress
/datum/clan/abyss
	name = "Children of the Abyss"
	desc = "The Children of the Abyss are a bloodline of vampires that worship the demons of old. Because of their affinity with the unholy, they are extremely vulnerable to the Church."
	curse = "Fear of the Religion."
	clanicon = "daimonion"
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/demonic,
	)
	covens_to_select = 0

/datum/clan/abyss/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	. = ..()
	H.faction |= "Abyss"
	H.AddElement(/datum/element/holy_weakness)

/datum/clan/abyss/on_lose(mob/living/carbon/human/vampire)
	. = ..()
	vampire.faction -= "Abyss"
	vampire.RemoveElement(/datum/element/holy_weakness)

/datum/clan/abyss/get_downside_string()
	return "burn in sunlight, and in the presence of the Ten"

/datum/clan/abyss/get_frenzy_messages()
	return list(
		"The demons of old whisper, and their only counsel is [span_danger("blood")].",
		"Something [span_danger("ancient")] uncoils in my chest, unholy and starving.",
		"The dark I worship reaches back through me, and it means to [span_danger("feed")].",
		"My patrons stir in the abyss - they would have me [span_userdanger("rend and drink")].",
		"Faith and reason [span_danger("burn away")]. Only black appetite is left.",
	)
