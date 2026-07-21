/datum/round_modifier/low_wretches
	name = "Low Wretches"
	desc = "The VALE is mostly clean of heresy."
	weight = 15
	max_chaos = 1
	wretch_slots = 3

/datum/round_modifier/medium_wretches
	name = "Medium Wretches"
	desc = "Middling amount of heresy in the VALE."
	cost = 3
	weight = 12
	min_chaos = 2
	wretch_slots = 5

/datum/round_modifier/medium_bandits
	name = "Medium Bandits"
	desc = "Middling amount of banditry in the VALE."
	cost = 3
	weight = 12
	min_chaos = 2
	bandit_slots = 5

/datum/round_modifier/low_gnolls
	name = "Low Gnolls"
	desc = "Just a couple gnolls."
	cost = 2
	min_chaos = 2
	gnoll_slots = 2

/datum/round_modifier/high_gnolls
	name = "High Gnolls"
	desc = "Graggar! Lots of gnolls!"
	cost = 3
	min_chaos = 3
	incompatible = list(/datum/round_modifier/low_gnolls)
	gnoll_slots = 5

/datum/round_modifier/high_wretches
	name = "High Wretches"
	desc = "Lots of heresy in the VALE!"
	cost = 5
	weight = 10
	min_chaos = 3
	wretch_slots = 10

/datum/round_modifier/high_bandits
	name = "High Bandits"
	desc = "Lots of bandits!"
	cost = 5
	weight = 8
	min_chaos = 3
	incompatible = list(/datum/round_modifier/medium_bandits)
	bandit_slots = 10

/datum/round_modifier/vampire
	name = "Night Beest"
	desc = "Vampyres!"
	cost = 6
	weight = 8
	min_chaos = 2
	villain_events = list(/datum/round_event_control/antagonist/solo/vampires)
