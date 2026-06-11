/datum/brain_trauma/hypnosis
	name = "催眠"
	desc = ""
	scan_desc = ""
	gain_text = ""
	lose_text = ""
	resilience = TRAUMA_RESILIENCE_SURGERY

	var/hypnotic_phrase = ""
	var/regex/target_phrase

/datum/brain_trauma/hypnosis/New(phrase)
	if(!phrase)
		qdel(src)
	hypnotic_phrase = phrase
	try
		target_phrase = new("(\\b[hypnotic_phrase]\\b)","ig")
	catch(var/exception/e)
		stack_trace("[e] on [e.file]:[e.line]")
		qdel(src)
	..()

/datum/brain_trauma/hypnosis/on_gain()
	message_admins("[ADMIN_LOOKUPFLW(owner)] was hypnotized with the phrase '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] was hypnotized with the phrase '[hypnotic_phrase]'.")
	to_chat(owner, span_reallybighypnophrase("[hypnotic_phrase]"))
	to_chat(owner, "<span class='notice'>[pick("我感觉自己的思绪正聚焦到这句话上……无论如何也无法将它从脑海中驱散。",\
												"我的头隐隐作痛，可我满脑子只剩下这句话。它一定至关重要。",\
												"我感觉心智的一部分正在反复默念着这句话。我必须遵从这些话语。",\
												"不知为何，这听起来……是对的。我感觉自己应该遵从这些话语。",\
												"这句话不断在我脑海中回响。我发现自己完全被它迷住了。")]</span>")
	to_chat(owner, "<span class='boldwarning'>我被这句话催眠了。我必须遵从这些话语。若它不是清晰明确的命令，\
										我可以自由理解该如何执行，只要我的行动始终把这些话语视作最高优先级。</span>")
	var/atom/movable/screen/alert/hypnosis/hypno_alert = owner.throw_alert("hypnosis", /atom/movable/screen/alert/hypnosis)
	hypno_alert.desc = ""
	..()

/datum/brain_trauma/hypnosis/on_lose()
	message_admins("[ADMIN_LOOKUPFLW(owner)] is no longer hypnotized with the phrase '[hypnotic_phrase]'.")
	log_game("[key_name(owner)] is no longer hypnotized with the phrase '[hypnotic_phrase]'.")
	to_chat(owner, span_danger("我突然从催眠中清醒了过来。短语“[hypnotic_phrase]”对我而言不再重要了。"))
	owner.clear_alert("hypnosis")
	..()

/datum/brain_trauma/hypnosis/on_life()
	..()
	if(prob(2))
		switch(rand(1,2))
			if(1)
				to_chat(owner, "<i>...[LOWER_TEXT(hypnotic_phrase)]...</i>")
			if(2)
				new /datum/hallucination/chat(owner, TRUE, FALSE, span_hypnophrase("[hypnotic_phrase]"))

/datum/brain_trauma/hypnosis/handle_hearing(datum/source, list/hearing_args)
	hearing_args[HEARING_MESSAGE] = target_phrase.Replace(hearing_args[HEARING_MESSAGE], span_hypnophrase("$1"))
