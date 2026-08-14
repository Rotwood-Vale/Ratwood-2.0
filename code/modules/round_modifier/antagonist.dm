/datum/round_modifier/low_bandits
	name = "Low Bandits"
	desc = "Some free men have come."
	cost = 1
	min_chaos = 1
	job_slots = list("Bandit" = 4)

/datum/round_modifier/medium_bandits
	name = "Medium Bandits"
	desc = "The free men have come."
	cost = 2
	weight = 30
	min_chaos = 2
	incompatible = list(/datum/round_modifier/low_bandits)
	job_slots = list("Bandit" = 7)

/datum/round_modifier/low_gnolls
	name = "Low Gnolls"
	desc = "The dregs of a bloodbeast pack."
	cost = 1
	weight = 20
	job_slots = list("Gnoll" = 2)

/datum/round_modifier/medium_gnolls
	name = "Medium Gnolls"
	desc = "A pack of bloodbeasts."
	cost = 2
	min_chaos = 1
	incompatible = list(/datum/round_modifier/low_gnolls)
	job_slots = list("Gnoll" = 4)

/datum/round_modifier/high_gnolls
	name = "High Gnolls"
	desc = "The bloodbeasts swarm! The GORESTAR laughs!"
	cost = 4
	min_chaos = 2
	incompatible = list(/datum/round_modifier/low_gnolls, /datum/round_modifier/medium_gnolls)
	job_slots = list("Gnoll" = 6)

/datum/round_modifier/high_wretches
	name = "High Wretches"
	desc = "Heresy spreads like a plague in the hearts of men!"
	cost = 4
	min_chaos = 3
	job_slots = list("Wretch" = 5)

/datum/round_modifier/high_bandits
	name = "High Bandits"
	desc = "The free men have come in force."
	cost = 4
	weight = 15
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
	cost = 4
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/masquerade)

/datum/round_modifier/vampirelord
	name = "Vampyre Lord"
	desc = "Hail! Hail! Kneel before the bastard tyrant!"
	cost = 8
	weight = 5
	min_chaos = 3
	villain_events = list(/datum/round_event_control/antagonist/solo/vampires)

/datum/round_modifier/assassin
	name = "Assassins"
	desc = "Ware! Knives in the dark!"
	cost = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/assassins)

/datum/round_modifier/rebel
	name = "Rebellion"
	desc = "The lowborn think to rule themselves!"
	cost = 2
	min_chaos = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/rebel)

/datum/round_modifier/dreamwalker
	name = "Dreamwalker"
	desc = "Abyssor stirs in his slumber."
	cost = 2
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/dreamwalker)
