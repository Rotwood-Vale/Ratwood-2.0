/datum/clan_leader/abyss
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/gaseousform //Strongest form of shapeshifting, evens out with being unable to go into the church at all without burning up.
	)
	lord_verbs = list(
		/mob/living/carbon/human/proc/punish_spawn
	)
	lord_traits = list(TRAIT_HEAVYARMOR, TRAIT_INFINITE_ENERGY, TRAIT_DETACHED, TRAIT_NOMOOD, TRAIT_STRENGTH_UNCAPPED) //their lord is most afflicted by daemonic influence. Emotionless almost.
	lord_title = "Heresiarch" //cult-like heirachy
	//no extra vitae, you have gas form + moodless off-the-bat... get it?

/// Baali from aliexpress, sort of ish.
/datum/clan/abyss
	name = "Children of the Abyss"
	desc = "The Children of the Abyss are a bloodline of infernal-harmonised vampires rumored to originate from a long-bygone experiment gone wrong by an ancient cult in the north. Because of their affinity with the unholy and daemonic, they are extremely vulnerable to the Divine."
	curse = "Spurned by the Ten, lack of emotion."
	clanicon = "daimonion"
	clane_covens = list(
		/datum/coven/obfuscate,
		/datum/coven/presence,
		/datum/coven/demonic,
	)
	clane_traits = list(
		TRAIT_STRONGBITE,
		TRAIT_VAMPBITE,
		TRAIT_NOHUNGER,
		TRAIT_NOBREATH,
		TRAIT_NOPAIN,
		TRAIT_TOXIMMUNE,
		TRAIT_STEELHEARTED,
		TRAIT_NOSLEEP,
		TRAIT_NOSLEEP,
		TRAIT_VAMPMANSION,
		TRAIT_VAMP_DREAMS,
		TRAIT_DEATHSIGHT, //Unique clan-wide boon, you can tell when/where people die..
		TRAIT_DARKVISION,
		TRAIT_LIMBATTACHMENT,
		TRAIT_SILVER_WEAK,
	)
	covens_to_select = 0

/datum/clan/abyss/on_gain(mob/living/carbon/human/H, is_vampire = TRUE)
	. = ..()
	H.faction |= "Abyss"
	H.AddElement(/datum/element/holy_weakness)

/datum/clan/abyss/get_downside_string()
	return "burn in sunlight, and in the presence of the Ten"
