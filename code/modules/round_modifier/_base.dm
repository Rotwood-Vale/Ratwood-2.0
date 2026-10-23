
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
	var/list/job_slots
	var/list/weather_weights
	var/tier = 0 // 0 = not an antag modifier
	var/min_candidates = 1

/datum/round_modifier/proc/count_optin_candidates()
	var/list/ready_optin = list()
	for(var/mob/dead/new_player/P as anything in GLOB.new_player_list)
		if(!P.client || P.ready != PLAYER_READY_TO_PLAY || !SSgamemode.is_opted_in(P.ckey))
			continue
		ready_optin += P
	// jobs: count opted-in players with the job's antag flag switched on (flag name == job title)
	var/jobs_count = 0
	for(var/mob/dead/new_player/P as anything in ready_optin)
		for(var/job_title in job_slots)
			if((job_title in P.client.prefs.be_special) && !is_banned_from(P.ckey, job_title))
				jobs_count++
				break
	// events: count opted-in players who have this event's antag flag enabled (mirrors SSgamemode.get_candidates)
	var/events_count = length(ready_optin) // fallback when there are no villain_events
	if(length(villain_events))
		events_count = null
		for(var/event_type in villain_events)
			var/datum/round_event_control/antagonist/solo/E = locate(event_type) in SSgamemode.control
			if(!E || !E.antag_flag)
				continue
			var/n = 0
			for(var/mob/dead/new_player/P as anything in ready_optin)
				if(E.antag_flag in P.client.prefs.be_special)
					n++
			events_count = isnull(events_count) ? n : min(events_count, n) // combos need every event covered
		if(isnull(events_count))
			events_count = 0
	if(length(job_slots) && length(villain_events))
		return min(jobs_count, events_count)
	if(length(job_slots))
		return jobs_count
	if(length(villain_events))
		return events_count
	return length(ready_optin)

/datum/round_modifier/adventure
	name = "Adventure"
	desc = "Wanderers flock to these lands."
	min_chaos = 99
	job_slots = list("Adventurer" = 20)

/*
/datum/round_modifier/lightsout
	name = "Lights Out"
	desc = "Hope you have flint!"
	weight = 2
	trigger_events = list(/datum/round_event_control/lightsout/forced)
*/
