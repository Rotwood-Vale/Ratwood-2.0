//Major: Vampire, Vampire & Werewolf, Werewolfs, Lich, Vampirelord, High Bandits,Peasant rebels, Rogue Count
//Moderate: Dreamwalker, Medium bandit, High wretch, High gnoll, Assassin, Possessed
//Minor: Thieves guild, Aspirant, Maniac

/datum/round_modifier/medium_bandits
	name = "Medium Bandits"
	desc = "The free men have come."
	cost = 2
	weight = 30
	min_chaos = 2
	incompatible = list(/datum/round_modifier/high_bandits)
	job_slots = list("Bandit" = 7)
	tier = 2

/datum/round_modifier/medium_gnolls
	name = "Medium Gnolls"
	desc = "A pack of bloodbeasts."
	cost = 2
	min_chaos = 1
	incompatible = list(/datum/round_modifier/high_gnolls)
	job_slots = list("Gnoll" = 4)
	tier = 2

/datum/round_modifier/high_gnolls
	name = "High Gnolls"
	desc = "The bloodbeasts swarm! The GORESTAR laughs!"
	cost = 4
	min_chaos = 2
	incompatible = list( /datum/round_modifier/medium_gnolls)
	job_slots = list("Gnoll" = 6)
	tier = 2

/datum/round_modifier/high_wretches
	name = "High Wretches"
	desc = "Heresy spreads like a plague in the hearts of men!"
	cost = 4
	min_chaos = 3
	job_slots = list("Wretch" = 6)
	tier = 2

/datum/round_modifier/high_bandits
	name = "High Bandits"
	desc = "The free men have come in force."
	cost = 4
	weight = 15
	min_chaos = 3
	incompatible = list(/datum/round_modifier/medium_bandits)
	job_slots = list("Bandit" = 12)
	tier = 3

/datum/round_modifier/werewolf
	name = "Verevolf"
	desc = "Men don the skin of wolves in darkling night."
	cost = 6
	weight = 5
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/werewolf)
	tier = 3

/datum/round_modifier/werewolf_and_vampire
	name = "Verevolf and vampires"
	desc = "A battle, between the forces of the night for supremacy."
	cost = 8
	weight = 5
	min_chaos = 3
	villain_events = list(/datum/round_event_control/antagonist/solo/werewolf,/datum/round_event_control/antagonist/solo/masquerade)
	tier = 3

/datum/round_modifier/vampire
	name = "Vampyres"
	desc = "Astrata's cursed spawn blights the land!"
	cost = 4
	min_chaos = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/masquerade)
	tier = 3
/datum/round_modifier/vampirelord
	name = "Vampyre Lord"
	desc = "Hail! Hail! Kneel before the bastard tyrant!"
	cost = 8
	weight = 5
	min_chaos = 3
	villain_events = list(/datum/round_event_control/antagonist/solo/vampires)
	tier = 3

/datum/round_modifier/assassin
	name = "Assassins"
	desc = "Ware! Knives in the dark!"
	cost = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/assassins)
	tier = 2

/datum/round_modifier/thievesguild
	name = "Thieves guild"
	desc = "Plenty of things that can go missing around town!"
	cost = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/thievesguild)
	tier = 1

/datum/round_modifier/aspirant
	name = "Plotting Coup"
	desc = "It's time for a regime change!"
	cost = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/aspirants)
	tier = 1
	min_candidates = 2

/datum/round_modifier/rebel
	name = "Rebellion"
	desc = "The lowborn think to rule themselves!"
	cost = 2
	min_chaos = 1
	villain_events = list(/datum/round_event_control/antagonist/solo/rebel)
	tier = 3

/datum/round_modifier/dreamwalker
	name = "Dreamwalker"
	desc = "Abyssor stirs in his slumber."
	cost = 2
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/dreamwalker)
	tier = 2

/datum/round_modifier/lich
	name = "Lich"
	desc = "The dead march forward in lockstep!"
	cost = 6
	weight = 6
	min_chaos = 3
	villain_events = list(/datum/round_event_control/antagonist/solo/lich)
	tier = 3
