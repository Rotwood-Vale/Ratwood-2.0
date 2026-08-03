/datum/round_modifier
	var/name
	var/desc
	var/cost = 1
	var/weight = 10
	var/min_chaos = 1
	var/max_chaos = 3
	var/hidden = FALSE
	var/list/incompatible
	var/list/villain_events
	var/list/trigger_events
	var/wretch_slots = 0
	var/bandit_slots = 0
	var/gnoll_slots = 0
	var/adventurer_slots = 0
	var/list/weather_weights

/datum/round_modifier/adventure
	name = "Adventure"
	desc = "Wanderers flock to these lands."
	min_chaos = 99
	adventurer_slots = 20

/datum/round_modifier/nowretch
	name = "No Villains"
	desc = "The land is peaceful, and its inhabitants calm."
	min_chaos = 99
	wretch_slots = -9

/datum/round_modifier/lesswretch
	name = "Low Wretches"
	desc = "The land is almost clean of heresy."
	min_chaos = 99
	wretch_slots = -4

/*
/datum/round_modifier/lightsout
	name = "Lights Out"
	desc = "Hope you have flint!"
	weight = 2
	trigger_events = list(/datum/round_event_control/lightsout/forced)
*/
