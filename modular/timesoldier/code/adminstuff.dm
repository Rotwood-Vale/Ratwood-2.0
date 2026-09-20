#define TIMESOLDIER_TEMPERANCE "Temperance"
#define TIMESOLDIER_INTERWAR "awuff button" // to be removed

#define TIMESOLDIER_SPAWN_CKEY "Ckey"
#define TIMESOLDIER_SPAWN_GHOST "Ghost"
#define TIMESOLDIER_SPAWN_SELF "Self"
#define TIMESOLDIER_SPAWN_OFFER "Offer to Ghosts"
#define TIMESOLDIER_SPAWN_CANCEL "Cancel"

/client/proc/timesoldier_start_broadcast()
	set category = "-GameMaster-"
	set name = "Future Broadcast - Start"
	set desc = "Begin a transmission throuh all Time Soldier radios."

	if(!check_rights(R_FUN))
		return
	
	var/list/voice_options = list(
		FUTURE_VOICE_MALE,
		FUTURE_VOICE_MALE_GENERIC,
		FUTURE_VOICE_FEMALE
	)

	var/list/language_options = list(
		FUTURE_LANGUAGE_IMPERIAL,
		FUTURE_LANGUAGE_NEW_IMPERIAL
	)

	var/selected_language = input(usr, "Select the Broadcast Language", "WHAT ARE WE SAYING?") as null|anything in language_options
	if(!selected_language)
		return

	var/selected_voice = input(usr, "Select The Voice Type.", "GIVE ME A VOICE") as null|anything in voice_options
	if(!selected_voice)
		return
	
	var/radios_found = 0

	for(var/obj/item/timesoldier/radio/R in world)
		R.start_broadcast(selected_voice, selected_language)
		radios_found++
	
	if(!radios_found)
		to_chat(usr, span_warning("There are no field transceivers in the world! Cancelling..."))
		return
	
	log_admin("[key_name(usr)] begun a Future Broadcast using the [selected_voice] voice in [selected_language].")
	message_admins(span_adminnotice("[key_name_admin(usr)] started a Future Broadcast using the [selected_voice] voice in [selected_language]."))


/client/proc/timesoldier_broadcast_message()
	set category = "-GameMaster-"
	set name = "Future Broadcast - Message"
	set desc = "Send a message through active Time Soldier radios."

	if(!check_rights(R_FUN))
		return

	var/message = input(usr, "What do we transmit?", "YOUR MESSAGE,MILORD") as text|null
	if(!message)
		return
	
	var/radios_found = 0
	var/radios_active = 0

	for(var/obj/item/timesoldier/radio/R in world)
		radios_found++

		if(!R.broadcasting)	
			continue
		
		R.receive_broadcast(message)
		radios_active++
	
	if(!radios_found)
		to_chat(usr, span_warning("There are no field transceivers in the world! Cancelling..."))
		return
	
	if(!radios_active)
		to_chat(usr, span_warning("The field transceivers are not currently broadcasting. Turn them on!"))
		return
	
	log_admin("[key_name(usr)] sent a Future Broadcast: \"[message]\"")
	message_admins(span_adminnotice("[key_name_admin(usr)] sent a Future Broadcast: \"[message]\""))


/client/proc/timesoldier_end_broadcast()
	set category = "-GameMaster-"
	set name = "Future Broadcast - End"
	set desc = "End the current Time Soldier radio transmission."

	if(!check_rights(R_FUN))
		return
	
	var/radios_found = 0
	var/radios_active = 0
	for(var/obj/item/timesoldier/radio/R in world)
		radios_found++

		if(!R.broadcasting)
			continue

		R.end_broadcast()
		radios_active++

	if(!radios_found)
		to_chat(usr, span_warning("There are no field transceivers in the world! Cancelling..."))
		return

	if(!radios_active)
		to_chat(usr, span_warning("The field transceivers are not currently broadcasting. Turn them on!"))
		return

	log_admin("[key_name(usr)] ended the Future Broadcast.")
	message_admins(span_adminnotice("[key_name_admin(usr)] ended the Future Broadcast."))


// i dont want to edit the core admin modules to register the verbs from here and want to keep it modular, so i'll just do it here

// REGISTRAR ====  === = == == =

/datum/timesoldier_admin_verb_registrar

/datum/timesoldier_admin_verb_registrar/New()
	. = ..()

	GLOB.admin_verbs_fun += list(
		/client/proc/timesoldier_start_broadcast,
		/client/proc/timesoldier_broadcast_message,
		/client/proc/timesoldier_end_broadcast,
		/client/proc/timesoldier_spawn
	)

GLOBAL_DATUM_INIT(timesoldier_admin_verb_registrar, /datum/timesoldier_admin_verb_registrar, new)


// TIME SOLDIER SPAWNING ===========


/client/proc/timesoldier_spawn()
	set category = "-GameMaster-"
	set name = "Spawn Time Soldier"
	set desc = "Spawn a Time Soldier beneath your admin ghost."

	if(!check_rights(R_FUN))
		return

	if(!isobserver(mob))
		to_chat(src, span_warning("I need to be an admin ghost to use this.")) // sorry bud no bussing.
		return

	var/turf/spawn_turf = get_turf(mob)

	if(!spawn_turf)
		to_chat(src, span_warning("I couldn't find a valid turf beneath myself.")) // somehow.
		return


	// what flavor we feelin
	var/list/soldier_types = list(
		TIMESOLDIER_TEMPERANCE,
		TIMESOLDIER_INTERWAR
	)

	var/selected_type

	while(TRUE)
		selected_type = input(
			src,
			"What kind of Time Soldier should be spawned?",
			"TIME SOLDIER"
		) as null|anything in soldier_types

		// Cancelled the window.
		if(!selected_type)
			return

		// the illusion of choice.
		if(selected_type == TIMESOLDIER_INTERWAR)
			switch(rand(1, 3))
				if(1)
					src << sound('sound/vo/mobs/vw/awuff.ogg')
				if(2)
					src << sound('sound/vo/mobs/vw/awuff2.ogg')
				if(3)
					src << sound('sound/vo/mobs/vw/awuff3.ogg')

			continue

		// Temperance selected.
		if(selected_type == TIMESOLDIER_TEMPERANCE)
			break

	// How are we giving control of them?
	var/list/spawn_options = list(
		TIMESOLDIER_SPAWN_CKEY,
		TIMESOLDIER_SPAWN_GHOST,
		TIMESOLDIER_SPAWN_SELF,
		TIMESOLDIER_SPAWN_OFFER,
		TIMESOLDIER_SPAWN_CANCEL
	)

	var/spawn_method = input(
		src,
		"How should the [selected_type] Time Soldier be controlled?",
		"TIME SOLDIER"
	) as null|anything in spawn_options

	if(!spawn_method || spawn_method == TIMESOLDIER_SPAWN_CANCEL)
		return


	var/client/target_client


	switch(spawn_method)

		// SPECIFIC CKEY


		if(TIMESOLDIER_SPAWN_CKEY)

			var/target_ckey = ckey(input(
				src,
				"Enter the ckey of the player who should control the Time Soldier.",
				"TIME SOLDIER"
			) as text|null)

			if(!target_ckey)
				return

			target_client = GLOB.directory[target_ckey]

			if(!target_client)
				to_chat(src, span_warning("I couldn't find an online client with the ckey '[target_ckey]'."))
				return


		// PICK FROM CURRENT GHOSTS

		if(TIMESOLDIER_SPAWN_GHOST)

			var/list/ghost_options = list()

			for(var/mob/dead/observer/G in GLOB.player_list)
				if(!G.client || !G.ckey)
					continue

				ghost_options["[G.ckey]"] = G.client

			if(!length(ghost_options))
				to_chat(src, span_warning("There are no ghosts available."))
				return

			var/selected_ghost = input(
				src,
				"Which ghost should control the Time Soldier?",
				"TIME SOLDIER"
			) as null|anything in ghost_options

			if(!selected_ghost)
				return

			target_client = ghost_options[selected_ghost]


		// ADMIN THEMSELF

		if(TIMESOLDIER_SPAWN_SELF)

			target_client = src


		// OFFER TO ALL GHOSTS

		if(TIMESOLDIER_SPAWN_OFFER)

			var/list/mob/dead/observer/candidates = pollGhostCandidates(
				"Time and space raptures. A Naledi Timelord has opened the way. Will you come back from the future, to embark on a mission?",
				null,
				null,
				FALSE,
				100
			)

			if(!length(candidates))
				to_chat(src, span_warning("Nobody volunteered to play the Time Soldier."))
				return

			var/mob/dead/observer/chosen_ghost = pick(candidates)

			if(!chosen_ghost?.client)
				to_chat(src, span_warning("The selected volunteer is no longer available."))
				return

			target_client = chosen_ghost.client


	if(!target_client)
		return


	// make sure they didn't disconnect while we were clicking through menus.
	if(QDELETED(target_client))
		to_chat(src, span_warning("That client is no longer available."))
		return


	var/mob/living/carbon/human/H = create_time_soldier(
		target_client,
		spawn_turf,
		selected_type
	)

	if(!H)
		to_chat(src, span_warning("Failed to create the Time Soldier."))
		return


	log_admin("[key_name(src)] spawned [key_name(H)] as a [selected_type] Time Soldier at [AREACOORD(H)].")
	message_admins(span_adminnotice("[key_name_admin(src)] spawned [ADMIN_LOOKUPFLW(H)] as a [selected_type] Time Soldier at [ADMIN_VERBOSEJMP(H)]."))


/proc/create_time_soldier(
	client/player,
	turf/spawn_turf,
	soldier_type
)
	if(!player)
		return

	if(!player.key)
		return

	if(!player.prefs)
		return

	if(!spawn_turf)
		return

	var/player_key = player.key

	// completely ordinary human.
	var/mob/living/carbon/human/H = new(spawn_turf)

	// build the human from this client's currently selected character.
	player.prefs.copy_to(H)
	H.dna.update_dna_identity()

	// equipment, stats, skills, languages, etc.
	apply_time_soldier_setup(H, soldier_type)

	// hand control over only after the body is completely prepared.
	H.key = player_key

	H.remove_language(/datum/language/common, source = LANGUAGE_SOURCE_ALL) // you know what would be really really funny...
	H.grant_language(/datum/language/new_imperial) // has to placed here otherwise we can't speak new imperial!

	return H


/proc/apply_time_soldier_setup(mob/living/carbon/human/H, soldier_type)
	if(!H)
		return



	switch(soldier_type)
		if(TIMESOLDIER_TEMPERANCE)
			apply_timesoldier_temperance(H)

