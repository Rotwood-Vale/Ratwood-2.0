#define VILLAIN_SIGNUP_TIME 5 MINUTES

/datum/controller/subsystem/gamemode
	var/villain_signup_ends = 0
	var/list/villain_signups = list()
	var/list/rolled_villain_events = list()

/datum/controller/subsystem/gamemode/proc/open_villain_signups()
	villain_signup_ends = world.time + VILLAIN_SIGNUP_TIME
	addtimer(CALLBACK(src, PROC_REF(run_villain_events)), VILLAIN_SIGNUP_TIME)
	to_chat(world, span_boldwarning("Assault the VALE!!! Open the VILLAINS menu in your character window to ready up. You have [DisplayTimeText(VILLAIN_SIGNUP_TIME)]."))

/datum/controller/subsystem/gamemode/proc/run_villain_events()
	villain_signup_ends = 0
	for(var/datum/round_event_control/event as anything in rolled_villain_events)
		TriggerEvent(event)
	//latespawn
	for(var/job_title in GLOB.villain_positions)
		var/list/hopefuls = list()
		for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
			if(player.client && !player.spawning && villain_signups[player.ckey] == job_title)
				hopefuls += player
		shuffle_inplace(hopefuls)
		for(var/mob/dead/new_player/player as anything in hopefuls)
			if(player.IsJobUnavailable(job_title, TRUE) != JOB_AVAILABLE)
				to_chat(player, span_warning("No [job_title] slot was left for you."))
				continue
			player.AttemptLateSpawn(job_title)
	rolled_villain_events = list()
	villain_signups = list()

/mob/dead/new_player/proc/VillainChoices()
	var/list/dat = list()
	var/signups_open = (SSgamemode.villain_signup_ends && world.time < SSgamemode.villain_signup_ends)

	if(signups_open)
		var/timeleft = round((SSgamemode.villain_signup_ends - world.time) / 10)
		dat += "<div class='notice' style='font-style: normal; font-size: 14px'>Villains are chosen in [DisplayTimeText(timeleft SECONDS)]</div>"
		dat += "<br><b>Greater Villains:</b><br>"
		if(!length(SSgamemode.rolled_villain_events))
			dat += "None.<br>"
		for(var/datum/round_event_control/antagonist/event in SSgamemode.rolled_villain_events)
			var/slots = 1
			if(istype(event, /datum/round_event_control/antagonist/solo))
				var/datum/round_event_control/antagonist/solo/solo_event = event
				slots = solo_event.get_antag_amount()
			if(SSgamemode.villain_signups[ckey] == event)
				dat += "<b>[event.name]</b> ([slots] slots) - <b>READY</b> <a href='byond://?src=[REF(src)];villain_withdraw=1'>WITHDRAW</a><br>"
			else
				dat += "<b>[event.name]</b> ([slots] slots) - <a href='byond://?src=[REF(src)];villain_ready=[REF(event)]'><font color='red'>READY</font></a><br>"
	else
		dat += "<div class='notice' style='font-style: normal; font-size: 14px'>Villains have been chosen.</div>"

	dat += "<br><b>Lesser Villains:</b><br>"
	var/found = FALSE
	for(var/job in GLOB.villain_positions)
		var/datum/job/J = SSjob.name_occupations[job]
		if(!J || IsJobUnavailable(J.title, TRUE) != JOB_AVAILABLE)
			continue
		found = TRUE
		if(signups_open)
			if(SSgamemode.villain_signups[ckey] == J.title)
				dat += "<b>[J.title]</b> ([J.total_positions] slots) - <b>READY</b> <a href='byond://?src=[REF(src)];villain_withdraw=1'>WITHDRAW</a><br>"
			else
				dat += "<b>[J.title]</b> ([J.total_positions] slots) - <a href='byond://?src=[REF(src)];villain_ready_job=[J.title]'><font color='red'>READY</font></a><br>"
		else
			dat += "<a href='byond://?src=[REF(src)];SelectedJob=[J.title]'>[J.title] ([J.current_positions]/[J.total_positions])</a><br>"
	if(!found)
		dat += "No villain roles are open right now."

	var/datum/browser/popup = new(src, "villainchoices", "Villains", 340, 400)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE)
