/datum/controller/subsystem/gamemode
	var/list/rolled_villain_events = list()
	var/list/queued_villains = list()

/datum/controller/subsystem/gamemode/proc/count_queued_villains(job_title)
	. = 0
	for(var/ckey in queued_villains)
		if(queued_villains[ckey] == job_title)
			.++

/datum/controller/subsystem/gamemode/proc/open_villain_signups()
	if(current_storyteller)
		current_storyteller.guarantees_roundstart_roleset = FALSE
		current_storyteller.roundstart_prob = 0
	for(var/datum/round_event_control/event as anything in rolled_villain_events)
		TriggerEvent(event, TRUE)
	rolled_villain_events = list()
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		var/job_title = queued_villains[player.ckey]
		if(!job_title || !player.client || player.spawning)
			continue
		player.AttemptLateSpawn(job_title)
	queued_villains = list()

/mob/dead/new_player/proc/VillainChoices()
	var/list/dat = list()

	if(!SSgamemode.modifiers_rolled)
		dat += "Wait."
	else
		dat += "<b>Greater Villains:</b><br>"
		if(!length(SSgamemode.rolled_villain_events))
			dat += "None.<br>"
		for(var/datum/round_event_control/antagonist/event in SSgamemode.rolled_villain_events)
			var/slots = 1
			if(istype(event, /datum/round_event_control/antagonist/solo))
				var/datum/round_event_control/antagonist/solo/solo_event = event
				slots = solo_event.get_antag_amount()
			dat += "<b>[event.name]</b> ([slots] slots)<br>"
		if(length(SSgamemode.rolled_villain_events))
			dat += "<i>These roll at roundstart from your antag preferences.</i><br>"

		dat += "<br><b>Lesser Villains:</b><br>"
		var/found = FALSE
		for(var/job_title in GLOB.villain_positions)
			var/datum/job/J = SSjob.GetJob(job_title)
			if(!J || !J.total_positions)
				continue
			found = TRUE
			if(SSticker.current_state <= GAME_STATE_PREGAME)
				var/pref_label = "NEVER"
				var/pref_color = "red"
				var/next_level = 3
				switch(client.prefs.job_preferences[J.title])
					if(JP_HIGH)
						pref_label = "High"
						pref_color = "slateblue"
						next_level = 4
					if(JP_MEDIUM)
						pref_label = "Medium"
						pref_color = "green"
						next_level = 1
					if(JP_LOW)
						pref_label = "Low"
						pref_color = "orange"
						next_level = 2
				dat += "<b>[J.title]</b> ([J.total_positions] slots) - <a href='byond://?src=[REF(src)];villain_pref=[J.title];level=[next_level]'><font color=[pref_color]>[pref_label]</font></a><br>"
			else
				dat += "<a href='byond://?src=[REF(src)];SelectedJob=[J.title]'>[J.title] ([J.current_positions]/[J.total_positions])</a><br>"

		if(!found)
			dat += "No villain roles this round."

	var/datum/browser/popup = new(src, "villainchoices", "Villains", 340, 400)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE)
