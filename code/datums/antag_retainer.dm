///this is basically a datum that stores all antags in them it also lets us interact easily with antags through events
/datum/antag_retainer
	//Major antag types
	var/list/vampires = list()
	var/list/death_knights = list()
	var/list/werewolves = list()
	var/list/liches = list()
	var/list/bandits = list()
	var/list/dreamwalkers = list()

	//Minor antag types
	var/list/wretches = list()
	var/list/aspirants = list()
	var/list/assassins = list()

	var/head_rebel_decree = FALSE

	///vampire stuff
	var/mob/living/carbon/human/vampire_lord
	var/king_submitted = FALSE
	var/ascended = FALSE

	///delf stuff
	var/delf_contribute = 0
	var/delf_goal = 1

	///bandit stuff
	var/bandit_goal = 1
	var/bandit_contribute = 0

/proc/vampire_werewolf()
	var/vampyr = 0
	var/wwoelf = 0
	for(var/mob/living/carbon/human/player in GLOB.human_list)
		if(player.mind)
			if(player.stat != DEAD)
				if(isbrain(player)) //also technically dead
					continue
				if(is_in_roguetown(player))
					var/datum/antagonist/D = player.mind.has_antag_datum(/datum/antagonist/werewolf)
					if(D && D.increase_votepwr)
						wwoelf++
						continue
					D = player.mind.has_antag_datum(/datum/antagonist/vampire)
					if(D && D.increase_votepwr)
						vampyr++
						continue
	if(vampyr)
		if(!wwoelf)
			return "vampire"
	if(wwoelf)
		if(!vampyr)
			return "werewolf"


var/global/list/found_lords = list() 

/proc/reset_found_lords()
	found_lords.Cut()

/proc/cleanup_found_lords()
	// Only clean up if we have a functional living lord (meaning the crisis is over)
	var/has_functional_lord = FALSE
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.mind && (H.mind.assigned_role == "Grand Duke" || H.mind.assigned_role == "Grand Duchess"))
			if(H.stat != DEAD && !isbrain(H) && H.get_bodypart(BODY_ZONE_HEAD))
				has_functional_lord = TRUE
				break
	
	if(has_functional_lord)
		var/list/valid_ckeys = list()
		for(var/mob/living/carbon/human/H in GLOB.human_list)
			if(H.ckey)
				valid_ckeys += H.ckey
		
		for(var/ckey in found_lords)
			if(ckey && !(ckey in valid_ckeys))
				found_lords -= ckey

/proc/check_for_lord(forced = FALSE)
	if(!SSticker.next_lord_check || world.time < SSticker.next_lord_check)
		return
	SSticker.next_lord_check = world.time + 1 MINUTES
	
	var/living_lord_found = FALSE
	
	// Check for living lords and track all lords
	for(var/mob/living/carbon/human/H in GLOB.human_list)
		if(H.mind && (H.mind.assigned_role == "Grand Duke" || H.mind.assigned_role == "Grand Duchess"))
			if(H.ckey)
				found_lords[H.ckey] = TRUE
			
			// Check if the lord is actually functional
			if(H.stat != DEAD && !isbrain(H) && H.get_bodypart(BODY_ZONE_HEAD))
				living_lord_found = TRUE
				if(hasomen(OMEN_NOLORD))
					removeomen(OMEN_NOLORD)
				break
	
	// Check for dead/missing lords if no living ones found and omen doesn't exist
	if(!living_lord_found && found_lords.len > 0 && !hasomen(OMEN_NOLORD))
		for(var/ckey in found_lords)
			var/mob/living/carbon/human/dead_lord = locate(ckey) in GLOB.human_list
			if(!dead_lord || dead_lord.stat == DEAD || dead_lord.stat == 3 || !dead_lord.get_bodypart(BODY_ZONE_HEAD))
				// Found a dead/missing lord, handle missing lord logic
				if(!SSticker.missing_lord_time)
					SSticker.missing_lord_time = world.time
				
				if(forced || (world.time > SSticker.missing_lord_time + 10 MINUTES))
					SSticker.missing_lord_time = world.time
					addomen(OMEN_NOLORD)
					// Announce the omen to players
					var/datum/round_event_control/R = new()
					R.badomen(OMEN_NOLORD)
				break
	
	cleanup_found_lords()
	return living_lord_found

/proc/age_check(client/C)
	if(get_remaining_days(C) == 0)
		return 1	//Available in 0 days = available right now = player is old enough to play.
	return 0

/proc/get_remaining_days(client/C)
	if(!C)
		return 0
	if(!CONFIG_GET(flag/use_age_restriction_for_jobs))
		return 0
	if(!isnum(C.player_age))
		return 0 //This is only a number if the db connection is established, otherwise it is text: "Requires database", meaning these restrictions cannot be enforced
	if(!isnum(0))
		return 0

	return max(0, 0 - C.player_age)
