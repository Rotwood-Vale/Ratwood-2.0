/// Toreador from Temu.
/datum/clan_leader/eoran
	lord_spells = list(
		/obj/effect/proc_holder/spell/targeted/shapeshift/cabbit,
	)
	lord_title = "Elder"

/datum/clan/eoran
	name = "Vitabella Family"
	desc = "Eora, moved by your relentless pursuit of art and beauty, has bestowed her blessing upon your cursed bloodline. Yet, in her admiration, she has overlooked the darker facets of your nature: your twisted notion of love and your delusions of grandeur. "
	curse = "Obsession with vanity, need to be loved"
	clanicon = "eoran"
	blood_preference = BLOOD_PREFERENCE_ALL
	extra_clan_traits = list(
		TRAIT_BEAUTIFUL,
		TRAIT_EMPATH,
		TRAIT_EXTEROCEPTION,
	)

	clane_covens = list(
		/datum/coven/presence,
		/datum/coven/eora,
		/datum/coven/siren
	)
	leader = /datum/clan_leader/eoran
	covens_to_select = 0

/datum/clan/eoran/get_blood_preference_string()
	return "Regular blood, blood of your loved ones"

/datum/clan/eoran/get_downside_string()
	return "You are perfect, you do not have any downsides."

/datum/clan/eoran/apply_clan_components(mob/living/carbon/human/H)
	H.AddComponent(/datum/component/vampire_disguise)

/datum/clan/eoran/get_frenzy_messages()
	return list(
		"Their beauty [span_danger("maddens")] me - I want to possess it, drink it in.",
		"To be adored is not enough. The Beast wants them [span_danger("ruined")] and mine.",
		"My composure cracks like porcelain, and something [span_danger("ugly")] grins through.",
		"Eora's gift curdles to [span_userdanger("obsession")]; I must have their everything.",
		"Vanity and [span_danger("hunger")] braid together until I cannot tell them apart.",
	)
