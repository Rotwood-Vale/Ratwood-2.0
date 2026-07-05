GLOBAL_LIST_EMPTY(mindlinks)

/datum/mindlink
	var/mob/living/owner
	var/mob/living/target
	var/active = TRUE

/datum/mindlink/New(mob/living/owner, mob/living/target)
	src.owner = owner
	src.target = target
	
	RegisterSignal(owner, COMSIG_MOB_SAY, PROC_REF(handle_speech))
	RegisterSignal(target, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mindlink/Destroy()
	UnregisterSignal(owner, COMSIG_MOB_SAY)
	UnregisterSignal(target, COMSIG_MOB_SAY)
	owner = null
	target = null
	return ..()

/datum/mindlink/proc/handle_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER
	if(!active)
		return
	
	var/message = speech_args[SPEECH_MESSAGE]
	if(!message)
		return
	
	if(findtext(message, ",mst", 1, 5))
		var/mob/living/recipient = (speaker == owner ? target : owner)
		to_chat(recipient, span_notice("The bond is broken by one of the parties."))
		to_chat(speaker, span_notice("The bond is broken by one of the parties."))
		active = FALSE
		GLOB.mindlinks -= src
		speech_args[SPEECH_MESSAGE] = null
		qdel(src)
		return

	// Parity channel is ,y. Keep ,m as legacy alias.
	if(findtext(message, ",y", 1, 3) || findtext(message, ",m", 1, 3))
		message = trim(copytext(message, 3))
		if(!message)
			speech_args[SPEECH_MESSAGE] = null
			return
		var/mob/living/recipient = (speaker == owner ? target : owner)
		var/radio_message = span_centcomradio("[message]")
		to_chat(speaker, span_purple("My voice threads across the bond: \"[radio_message]\""))
		to_chat(recipient, span_purple("The voice of [speaker] echoes, \"<i>[capitalize(radio_message)]</i>\"."))
		speaker.log_talk(message, LOG_SAY, tag = "Mindlink")
		speech_args[SPEECH_MESSAGE] = null
