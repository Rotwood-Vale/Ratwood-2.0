#define ANTAG_DEPLETED_RATIO 0.5
/datum/controller/subsystem/gamemode
	var/list/rolled_villain_events = list()
	var/list/queued_villains = list()
	var/antag_window_open = FALSE
	var/antag_window_closed = FALSE
	var/antag_optin_required = FALSE // stays FALSE if the window never opened (force-start), so everyone counts as in
	var/list/antag_optins = list()
	var/list/antag_popup_shown = list()
	var/list/antag_checkpoints = list(1 HOURS, 2 HOURS)
	var/next_antag_checkpoint = 1
	var/antag_baseline_taken = FALSE
	var/list/antag_baselines = list() // modifier -> alive count at baseline
	var/list/antag_unfilled = list(0, 0, 0) // roundstart quota slots that never filled, index = ANTAG_TIER_*


/datum/controller/subsystem/gamemode/proc/is_opted_in(ckey)
	if(!antag_optin_required)
		return TRUE
	return antag_optins[ckey]

/datum/controller/subsystem/gamemode/proc/open_antag_window()
	if(antag_window_open)
		return
	antag_window_open = TRUE
	antag_optin_required = TRUE
	to_chat(world, span_boldnotice("The antagonist draw is open! Use the Villains button in the lobby to opt in. It closes when the round starts."))
	for(var/mob/dead/new_player/P as anything in GLOB.new_player_list)
		if(P.client)
			antag_popup_shown[P.ckey] = TRUE
			P.AlertAntagWindow()

/datum/controller/subsystem/gamemode/proc/close_antag_window()
	if(antag_window_closed)
		return
	antag_window_closed = TRUE
	for(var/client/C as anything in GLOB.clients)
		C << browse(null, "window=villainchoices") // round is starting, shut everyone's popup
	roll_antag_modifiers()
	var/list/slot_report = list()
	for(var/job_title in GLOB.villain_positions)
		var/datum/job/J = SSjob.GetJob(job_title)
		if(J)
			slot_report += "[job_title] [J.spawn_positions]"
	message_admins("Villain slots: [slot_report.Join(", ")]")
	
/datum/controller/subsystem/gamemode/proc/count_queued_villains(job_title)
	. = 0
	for(var/ckey in queued_villains)
		if(queued_villains[ckey] == job_title)
			.++

/datum/controller/subsystem/gamemode/proc/open_villain_signups()
	if(current_storyteller)
		current_storyteller.guarantees_roundstart_roleset = FALSE
		current_storyteller.roundstart_prob = 0
	roundstart_draw_active = TRUE
	addtimer(VARSET_CALLBACK(src, roundstart_draw_active, FALSE), 30 SECONDS) // in case event setup() runs deferred; shrink if TriggerEvent is synchronous for you
	for(var/datum/round_event_control/event as anything in rolled_villain_events)
		TriggerEvent(event, TRUE)
	rolled_villain_events = list()
	for(var/datum/round_modifier/M in active_modifiers)
		for(var/event_type in M.trigger_events)
			var/datum/round_event_control/event = locate(event_type) in control
			if(event)
				TriggerEvent(event, TRUE)
	for(var/mob/dead/new_player/player as anything in GLOB.new_player_list)
		var/job_title = queued_villains[player.ckey]
		if(!job_title || !player.client || player.spawning)
			continue
		to_chat(player, span_boldwarning("You have been chosen for villainy as a [job_title]!"))
		player.AttemptLateSpawn(job_title)
	queued_villains = list()
	addtimer(CALLBACK(src, PROC_REF(capture_antag_baseline)), 3 MINUTES) // after events and queued villains have spawned

/datum/controller/subsystem/gamemode/proc/capture_antag_baseline()
	if(antag_baseline_taken)
		return
	antag_baseline_taken = TRUE
	for(var/datum/round_modifier/M as anything in active_modifiers)
		if(M.tier)
			antag_baselines[M] = M.count_alive()

/mob/dead/new_player/proc/VillainChoices()
	var/list/dat = list()
	if(!SSgamemode.antag_window_open || SSgamemode.antag_window_closed)
		dat += "The antagonist draw is not open."
	else
		var/optin = SSgamemode.is_opted_in(ckey)
		dat += "<b>Antagonists are being drawn.</b><br>"
		dat += "In the draw: <b>[optin ? "YES" : "NO"]</b> - <a href='byond://?src=[REF(src)];antag_optin=[optin ? 0 : 1]'>[optin ? "Opt out" : "Opt in"]</a><br><br>"
		dat += "<b>Your antagonist roles:</b><br>"
		SSgamemode.build_draw_roles()
		for(var/flag in SSgamemode.draw_flags)
			if(is_banned_from(ckey, flag))
				dat += "[capitalize(flag)] - <font color=red>BANNED</font><br>"
				continue
			var/on = (flag in client.prefs.be_special)
			dat += "[capitalize(flag)] - <a href='byond://?src=[REF(src)];antag_flag=[url_encode(flag)]'><font color=[on ? "green" : "red"]>[on ? "ON" : "OFF"]</font></a><br>"
		dat += "<br><i>Only players who opt in can be drawn, and only for roles switched on.</i>"
	var/datum/browser/popup = new(src, "villainchoices", "Villains", 340, 480)
	popup.add_stylesheet("playeroptions", 'html/browser/playeroptions.css')
	popup.set_content(jointext(dat, ""))
	popup.open(FALSE)

/datum/controller/subsystem/gamemode/proc/get_antag_flags()
	var/list/flags = list()
	for(var/T in typesof(/datum/round_event_control/antagonist/solo))
		var/datum/round_event_control/antagonist/solo/E = T
		var/f = initial(E.antag_flag)
		if(f)
			flags |= f
	return flags

// this menu allows players 2 boost their stats to wretch tier (+12 weight) & choose between DE / Heavy Armor
/mob/living/carbon/human/var/datum/antag_setup/antag_setup

/datum/antag_setup
	var/mob/living/carbon/human/user
	var/list/stats = list()
	var/list/defaults = list()
	var/chosen_trait
	var/budget = 12
	var/static/list/stat_keys = list(STATKEY_STR, STATKEY_PER, STATKEY_INT, STATKEY_CON, STATKEY_WIL, STATKEY_SPD)

/datum/antag_setup/New(mob/living/carbon/human/H)
	user = H
	H.antag_setup = src
	var/waited = 0
	while(!H.advjob)
		sleep(1 SECONDS)
		waited += 1 SECONDS
		if(QDELETED(H) || waited > 60 SECONDS)
			qdel(src)
			return
	for(var/key in stat_keys)
		stats[key] = H.get_stat_level(key)
		defaults[key] = stats[key]
	open_menu()

/datum/antag_setup/proc/statweight(key)
	if(key == STATKEY_STR || key == STATKEY_SPD)
		return 2
	return 1

/datum/antag_setup/proc/statspent()
	. = 0
	for(var/key in stat_keys)
		. += (stats[key] - defaults[key]) * statweight(key)

/datum/antag_setup/proc/open_menu()
	var/contents = "Points remaining: [budget - statspent()]</center><BR>"
	contents += "--------------<BR>"
	for(var/key in stat_keys)
		contents += "<b>[capitalize(key)]</b> ([statweight(key)]x): [stats[key]] "
		contents += "<a href='?src=[REF(src)];raise=[key]'>\[+\]</a> "
		contents += "<a href='?src=[REF(src)];lower=[key]'>\[-\]</a><BR>"
	contents += "--------------<BR>"
	contents += "<b>Choose a trait:</b><BR>"
	contents += "<a href='?src=[REF(src)];trait=dodge'>Dodge Expert</a><BR>"
	contents += "<a href='?src=[REF(src)];trait=heavy'>Heavy Armor</a><BR>"
	contents += "Chosen: [chosen_trait]<BR>"
	contents += "--------------<BR>"
	contents += "<center><a href='?src=[REF(src)];confirm=1'>\[CONFIRM\]</a></center>"
	var/datum/browser/popup = new(user, "antagsetup", "Take Up Arms", 300, 420)
	popup.set_content(contents)
	popup.open(FALSE)

/datum/antag_setup/Topic(href, href_list)
	if(usr != user)
		return
	if(href_list["raise"])
		var/key = href_list["raise"]
		if(stats[key] < 20 && (budget - statspent()) >= statweight(key))
			stats[key] += 1
		open_menu()
	if(href_list["lower"])
		var/key = href_list["lower"]
		if(stats[key] > defaults[key])
			stats[key] -= 1
		open_menu()
	if(href_list["trait"])
		if(href_list["trait"] == "dodge")
			chosen_trait = TRAIT_DODGEEXPERT
		if(href_list["trait"] == "heavy")
			chosen_trait = TRAIT_HEAVYARMOR
		open_menu()
	if(href_list["confirm"])
		if(!chosen_trait)
			to_chat(user, span_warning("Choose a trait."))
			return
		for(var/key in stat_keys)
			var/diff = stats[key] - defaults[key]
			if(diff)
				user.change_stat(key, diff)
		ADD_TRAIT(user, chosen_trait, TRAIT_GENERIC)
		user.antag_setup = null
		user << browse(null, "window=antagsetup")
		qdel(src)

