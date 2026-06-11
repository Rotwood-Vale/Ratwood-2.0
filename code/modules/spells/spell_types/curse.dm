GLOBAL_VAR_INIT(curse_of_madness_triggered, FALSE)

/proc/curse_of_madness(mob/user, message)
	if(user) //in this case either someone holding a spellbook or a badmin
		to_chat(user, span_warning("我已送出一则附带信息“[message]”的疯狂诅咒！"))
		message_admins("[ADMIN_LOOKUPFLW(user)] sent a curse of madness with the message \"[message]\"!")
		log_game("[key_name(user)] sent a curse of madness with the message \"[message]\"!")

	GLOB.curse_of_madness_triggered = message // So latejoiners are also afflicted.

	deadchat_broadcast("<span class='name'>疯狂诅咒</span> 已降临此地，那可怖的秘密击碎了他们的心智：\"<span class='big hypnophrase'>[message]</span>\"")

	for(var/mob/living/carbon/human/H in GLOB.player_list)
		if(H.stat == DEAD)
			continue
		var/turf/T = get_turf(H)
		if(T && !is_station_level(T.z))
			continue
		if(H.anti_magic_check(TRUE, FALSE, TRUE))
			to_chat(H, span_notice("我有那么一瞬间感到异样，但很快便过去了。"))
			continue
		give_madness(H, message)

/proc/give_madness(mob/living/carbon/human/H, message)
	H.playsound_local(H,'sound/blank.ogg',40,1)
	to_chat(H, span_reallybighypnophrase("[message]"))
	to_chat(H, span_warning("我的心智崩裂了！"))
	switch(rand(1,10))
		if(1 to 3)
			H.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_LOBOTOMY)
			H.gain_trauma_type(BRAIN_TRAUMA_MILD, TRAUMA_RESILIENCE_LOBOTOMY)
		if(4 to 6)
			H.gain_trauma_type(BRAIN_TRAUMA_SEVERE, TRAUMA_RESILIENCE_LOBOTOMY)
		if(7 to 8)
			H.gain_trauma_type(BRAIN_TRAUMA_MAGIC, TRAUMA_RESILIENCE_LOBOTOMY)
		if(9 to 10)
			H.gain_trauma_type(BRAIN_TRAUMA_SPECIAL, TRAUMA_RESILIENCE_LOBOTOMY)
