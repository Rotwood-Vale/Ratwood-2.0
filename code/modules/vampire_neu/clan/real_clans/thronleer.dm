
/datum/clan_leader/thronleer
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_title = "Elder"
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_STRENGTH_UNCAPPED)
	vitae_bonus = 500

/datum/clan/thronleer
	name = "House Thronleer"
	desc = "House Thronleer is a secretive, tradition‑bound clan that favors ritual, subtlety, and guile."
	curse = "Weakness of the soul."
	clanicon = "bloodheal"
	blood_preference = BLOOD_PREFERENCE_FANCY
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/demonic,
	)
	leader = /datum/clan_leader/thronleer
	covens_to_select = 0

/datum/clan/thronleer/get_blood_preference_string()
	return "prepared blood"

/datum/clan/thronleer/get_downside_string()
	return "weak in fights"

/datum/clan/thronleer/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)

/datum/clan/thronleer/get_frenzy_messages()
	return list(
		"My weak soul buckles, and the [span_danger("Beast")] pours through every crack.",
		"Ritual and restraint [span_danger("desert")] me. Only the raw thirst remains.",
		"The composure my House prizes slips through my fingers like [span_danger("water")].",
		"Something base and starving [span_userdanger("wears my face")] now.",
		"Tradition cannot hold this - the [span_danger("hunger")] is older than any House.",
	)
