/datum/mindlink_coven
	var/list/mob/living/members = list()
	var/datum/mind/hag_mind
	var/active = TRUE

/datum/mindlink_coven/New(list/mob/living/new_members, datum/mind/new_hag_mind)
	src.hag_mind = new_hag_mind
	if(islist(new_members))
		for(var/mob/living/M in new_members)
			if(!M || (M in members))
				continue
			members += M
			register_member(M)

/datum/mindlink_coven/Destroy()
	for(var/mob/living/M in members)
		unregister_member(M)
	members.Cut()
	hag_mind = null
	return ..()

/datum/mindlink_coven/proc/register_member(mob/living/member)
	if(!member)
		return
	RegisterSignal(member, COMSIG_MOB_SAY, PROC_REF(handle_coven_speech))
	RegisterSignal(member, COMSIG_LIVING_DEATH, PROC_REF(handle_member_death))

/datum/mindlink_coven/proc/unregister_member(mob/living/member)
	if(!member)
		return
	UnregisterSignal(member, COMSIG_MOB_SAY)
	UnregisterSignal(member, COMSIG_LIVING_DEATH)

/datum/mindlink_coven/proc/add_member(mob/living/member)
	if(!member || (member in members))
		return FALSE
	members += member
	register_member(member)
	return TRUE

/datum/mindlink_coven/proc/remove_member(mob/living/member)
	if(!member || !(member in members))
		return FALSE
	unregister_member(member)
	members -= member
	if(!length(members))
		GLOB.mindlinks -= src
		qdel(src)
	return TRUE

/datum/mindlink_coven/proc/find_member_by_name(target_name)
	if(!target_name)
		return null
	for(var/mob/living/member in members)
		if(!member)
			continue
		if(lowertext(member.real_name) == lowertext(target_name))
			return member
	return null

/datum/mindlink_coven/proc/broadcast_notice(message)
	if(!message)
		return
	for(var/mob/living/M in members)
		if(M)
			to_chat(M, span_boldnotice(message))

/datum/mindlink_coven/proc/notify_hag(message)
	if(!message)
		return
	var/mob/living/hag_body = hag_mind?.current
	if(hag_body)
		to_chat(hag_body, span_warning(message))

/datum/mindlink_coven/proc/handle_member_death(mob/living/dead_member, gibbed)
	SIGNAL_HANDLER

	if(!active || !dead_member)
		return
	if(dead_member == hag_mind?.current)
		return
	if(!remove_member(dead_member))
		return
	notify_hag("Your coven grows weaker, [dead_member.real_name]'s soul has slipped from their mortal form.")

/datum/mindlink_coven/proc/handle_coven_speech(mob/living/speaker, list/speech_args)
	SIGNAL_HANDLER

	var/message = speech_args[SPEECH_MESSAGE]
	if(!message || !active)
		return

	if(findtext(message, ",mst", 1, 5))
		speech_args[SPEECH_MESSAGE] = null
		if(!hag_mind || speaker.mind != hag_mind)
			to_chat(speaker, span_warning("Only the Mossmother may cast a soul out of the coven web."))
			return

		var/target_name = trim(copytext(message, 5))
		if(!target_name)
			to_chat(speaker, span_warning("Speak a full name after ,mst to cast someone out."))
			return

		var/mob/living/target = find_member_by_name(target_name)
		if(!target)
			to_chat(speaker, span_warning("No coven soul answers to '[target_name]'."))
			return
		if(target == hag_mind.current)
			to_chat(speaker, span_warning("The Mossmother cannot cast herself out of her own coven."))
			return

		if(remove_member(target))
			broadcast_notice("The Mossmother casts [target.real_name] out of the coven.")
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
			M.playsound_local(M, 'sound/magic/message.ogg', 75, TRUE)
			if(M == speaker)
				to_chat(M, span_purple("My voice threads through the coven web: \"[radio_message]\""))
			else
				to_chat(M, span_purple(formatted))

		speaker.log_talk(message, LOG_SAY, tag = "Coven Link")
		speech_args[SPEECH_MESSAGE] = null
