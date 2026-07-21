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
	var/list/weather_weights

/datum/round_modifier/lightsout
	name = "Lights Out"
	desc = "Hope you have flint!"
	trigger_events = list(/datum/round_event_control/lightsout/forced)
