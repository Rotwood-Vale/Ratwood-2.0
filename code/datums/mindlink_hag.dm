/datum/mindlink/coven
	var/list/mob/living/members = list()

/datum/mindlink/coven/New(list/mob/living/new_members)
	src.members = new_members
	for(var/mob/living/M in members)
		RegisterSignal(M, COMSIG_MOB_SAY, PROC_REF(handle_speech))

/datum/mindlink/coven/Destroy()
	for(var/mob/living/M in members)
		UnregisterSignal(M, COMSIG_MOB_SAY)
	members.Cut()
	return ..()

/datum/mindlink/coven/proc/handle_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(!message || !active)
		return

	if(findtext(message, ",mst", 1, 5))
		for(var/mob/living/M in members)
			if(M)
				to_chat(M, span_notice("The coven web is severed by [speaker]."))
		speech_args[SPEECH_MESSAGE] = null
		GLOB.mindlinks -= src
		qdel(src)
		return

	if(findtext(message, ",y", 1, 3))
		message = trim(copytext(message, 3))
		if(!message)
			speech_args[SPEECH_MESSAGE] = null
			return

		var/radio_message = span_centcomradio(message)
		var/formatted = "The voice of [speaker] echoes, \"<i>[capitalize(message)]</i>\"."

		for(var/mob/living/M in members)
			if(!M)
				continue
			M.playsound_local(M, 'sound/magic/mindlink.ogg', 75, TRUE)
			if(M == speaker)
				to_chat(M, span_purple("My voice threads through the coven web: \"[radio_message]\""))
			else
				to_chat(M, span_purple(formatted))

		speaker.log_talk(message, LOG_SAY, tag = "Coven Link")
		speech_args[SPEECH_MESSAGE] = null
