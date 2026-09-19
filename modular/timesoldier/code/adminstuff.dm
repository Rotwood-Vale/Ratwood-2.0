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

	var/selected_voice = input(usr, "Select The Voice Type.", "GIVE ME A VOICE") as null|anything in voice_options
	if(!selected_voice)
		return
	
	var/radios_found = 0

	for(var/obj/item/timesoldier/radio/R in world)
		R.start_broadcast(selected_voice)
		radios_found++
	
	if(!radios_found)
		to_chat(usr, span_warning("There are no field transceivers in the world! Cancelling..."))
		return
	
	log_admin("[key_name(usr)] begun a Future Broadcast using the [selected_voice] voice.")
	message_admins(span_adminnotice("[key_name_admin(usr)] started a Future Broadcast using the [selected_voice] voice."))


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

/datum/timesoldier_admin_verb_registrar

/datum/timesoldier_admin_verb_registrar/New()
	. = ..()

	GLOB.admin_verbs_fun += list(
		/client/proc/timesoldier_start_broadcast,
		/client/proc/timesoldier_broadcast_message,
		/client/proc/timesoldier_end_broadcast
	)

GLOBAL_DATUM_INIT(timesoldier_admin_verb_registrar, /datum/timesoldier_admin_verb_registrar, new)
