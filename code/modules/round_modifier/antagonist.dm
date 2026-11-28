/datum/round_modifier/low_bandits
	name = "Low Bandits"
	desc = "Some free men have come."
	public_text = "<b>Bandits</b> - Some free men have come."
	cost = 1
	min_chaos = 1
	max_chaos = 2 // at chaos 3 the band is always medium or high
	job_slots = list("Bandit" = 4)

/datum/round_modifier/medium_bandits
	name = "Medium Bandits"
	desc = "The free men have come."
	public_text = "<b>Bandits</b> - Some free men have come."
	cost = 2
	weight = 30
	min_chaos = 2
	incompatible = list(/datum/round_modifier/low_bandits)
	job_slots = list("Bandit" = 7)

/datum/round_modifier/low_gnolls
	name = "Low Gnolls"
	desc = "The dregs of a bloodbeast pack."
	public_text = "<b>Gnolls</b> - Some bloodbeasts prowl the land."
	cost = 1
	job_slots = list("Gnoll" = 2)

/datum/round_modifier/medium_gnolls
	name = "Medium Gnolls"
	desc = "A pack of bloodbeasts."
	public_text = "<b>Gnolls</b> - Some bloodbeasts prowl the land."
	cost = 2
	min_chaos = 1
	weight = 20
	incompatible = list(/datum/round_modifier/low_gnolls)
	job_slots = list("Gnoll" = 4)

/datum/round_modifier/high_gnolls
	name = "High Gnolls"
	desc = "The bloodbeasts swarm! The GORESTAR laughs!"
	public_text = "<b>Gnolls</b> - Some bloodbeasts prowl the land."
	cost = 4
	min_chaos = 2
	incompatible = list(/datum/round_modifier/low_gnolls, /datum/round_modifier/medium_gnolls)
	job_slots = list("Gnoll" = 6)

/datum/round_modifier/high_wretches
	name = "High Wretches"
	desc = "Heresy spreads like a plague in the hearts of men!"
	public_text = "<b>Wretches</b> - Wretched heretics walk among us."
	cost = 4
	min_chaos = 3
	job_slots = list("Wretch" = 5)

/datum/round_modifier/high_bandits
	name = "High Bandits"
	desc = "The free men have come in force."
	public_text = "<b>Bandits</b> - Some free men have come."
	cost = 4
	weight = 60 // about half of chaos 3 rounds; the rest get medium
	min_chaos = 3
	incompatible = list(/datum/round_modifier/medium_bandits, /datum/round_modifier/low_bandits)
	job_slots = list("Bandit" = 10)

/*
/datum/round_modifier/werewolf
	name = "Verevolf"
	desc = "Men don the skin of wolves in darkling night."
	cost = 6
	weight = 5
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/werewolf)
*/

/datum/round_modifier/vampire
	name = "Vampyres"
	desc = "Astrata's cursed spawn blights the land!"
	hidden = TRUE // not a queued role: players are never told
	cost = 4
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/masquerade)

/datum/round_modifier/vampirelord
	name = "Vampyre Lord"
	desc = "Hail! Hail! Kneel before the bastard tyrant!"
	hidden = TRUE // not a queued role: players are never told
	cost = 8
	weight = 5
	min_chaos = 3
	villain_events = list(/datum/round_event_control/antagonist/solo/vampires)

/datum/round_modifier/assassin
	name = "Assassins"
	desc = "Ware! Knives in the dark!"
	hidden = TRUE // not a queued role: players are never told
	cost = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/assassins)

/*
/datum/round_modifier/rebel
	name = "Rebellion"
	desc = "The lowborn think to rule themselves!"
	cost = 2
	min_chaos = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/rebel)
*/

/datum/round_modifier/dreamwalker
	name = "Dreamwalker"
	desc = "Abyssor stirs in his slumber."
	hidden = TRUE // not a queued role: players are never told
	cost = 2
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/dreamwalker)

/datum/round_modifier/zizocult
	name = "Cultists"
	desc = "Vile heretics steal the power of gods!"
	hidden = TRUE // not a queued role: players are never told
	cost = 5
	min_chaos = 2
	weight = 20
	incompatible = list(/datum/round_modifier/high_wretches, /datum/round_modifier/vampire, /datum/round_modifier/vampirelord)
	villain_events = list(/datum/round_event_control/antagonist/solo/zizo_cult)

/*
/datum/round_modifier/lich
	name = "Lich"
	desc = "The dead march forward in lockstep!"
	cost = 6
	weight = 6
	min_chaos = 3
	villain_events = list(/datum/round_event_control/antagonist/solo/lich)
*/
