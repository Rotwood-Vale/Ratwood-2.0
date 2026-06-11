//Mild traumas are the most common; they are generally minor annoyances.
//They can be cured with mannitol and patience, although brain surgery still works.
//Most of the old brain damage effects have been transferred to the dumbness trauma.

/datum/brain_trauma/mild

/datum/brain_trauma/mild/hallucinations
	name = "幻觉"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我感觉自己正逐渐失去对现实的把握……")
	lose_text = span_notice("我重新感觉脚踏实地了。")

/datum/brain_trauma/mild/hallucinations/on_life()
	owner.hallucination = min(owner.hallucination + 10, 50)
	..()

/datum/brain_trauma/mild/hallucinations/on_lose()
	owner.hallucination = 0
	..()

/datum/brain_trauma/mild/stuttering
	name = "口吃"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("清晰说话变得越来越困难了。")
	lose_text = span_notice("我重新能掌控自己的言语了。")

/datum/brain_trauma/mild/stuttering/on_life()
	owner.stuttering = min(owner.stuttering + 5, 25)
	..()

/datum/brain_trauma/mild/stuttering/on_lose()
	owner.stuttering = 0
	..()

/datum/brain_trauma/mild/dumbness
	name = "痴愚"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我感觉自己变笨了。")
	lose_text = span_notice("我又感觉自己聪明起来了。")

/datum/brain_trauma/mild/dumbness/on_gain()
	ADD_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/dumbness/on_life()
	owner.derpspeech = min(owner.derpspeech + 5, 25)
	if(prob(3))
		owner.emote("drool")
	else if(owner.stat == CONSCIOUS && prob(3))
		owner.say(pick_list_replacements(BRAIN_DAMAGE_FILE, "brain_damage"), forced = "brain damage")
	..()

/datum/brain_trauma/mild/dumbness/on_lose()
	REMOVE_TRAIT(owner, TRAIT_DUMB, TRAUMA_TRAIT)
	owner.derpspeech = 0
	..()

/datum/brain_trauma/mild/speech_impediment
	name = "语言障碍"
	desc = ""
	scan_desc = ""
	gain_text = span_danger("我似乎再也无法组织出连贯的思绪了！")
	lose_text = span_danger("我的思绪清晰了一些。")

/datum/brain_trauma/mild/speech_impediment/on_gain()
	ADD_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/speech_impediment/on_lose()
	REMOVE_TRAIT(owner, TRAIT_UNINTELLIGIBLE_SPEECH, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/mild/concussion
	name = "脑震荡"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我头好痛！")
	lose_text = span_notice("脑中的压迫感开始消退了。")

/datum/brain_trauma/mild/concussion/on_life()
	if(prob(5))
		switch(rand(1,11))
			if(1)
				owner.vomit()
			if(2,3)
				owner.dizziness += 10
			if(4,5)
				owner.confused += 10
				owner.blur_eyes(10)
			if(6 to 9)
				owner.slurring += 30
			if(10)
				to_chat(owner, span_notice("我一时间忘了自己刚才在做什么。"))
				owner.Stun(20)
			if(11)
				to_chat(owner, span_warning("我昏过去了。"))
				owner.Unconscious(80)

	..()

/datum/brain_trauma/mild/healthy
	name = "失病识症"
	desc = ""
	scan_desc = ""
	gain_text = span_notice("我感觉好极了！")
	lose_text = span_warning("我不再觉得自己完美健康了。")

/datum/brain_trauma/mild/healthy/on_gain()
	owner.set_screwyhud(SCREWYHUD_HEALTHY)
	..()

/datum/brain_trauma/mild/healthy/on_life()
	owner.set_screwyhud(SCREWYHUD_HEALTHY) //just in case of hallucinations
	owner.adjustStaminaLoss(-5) //no pain, no fatigue
	..()

/datum/brain_trauma/mild/healthy/on_lose()
	owner.set_screwyhud(SCREWYHUD_NONE)
	..()

/datum/brain_trauma/mild/muscle_weakness
	name = "肌无力"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我的肌肉虚弱得有些反常。")
	lose_text = span_notice("我重新能控制自己的肌肉了。")

/datum/brain_trauma/mild/muscle_weakness/on_life()
	var/fall_chance = 1
	if(owner.m_intent == MOVE_INTENT_RUN)
		fall_chance += 2
	if(prob(fall_chance) && (owner.mobility_flags & MOBILITY_STAND))
		to_chat(owner, span_warning("我的腿突然发软了！"))
		owner.Paralyze(35)

	else if(owner.get_active_held_item())
		var/drop_chance = 1
		var/obj/item/I = owner.get_active_held_item()
		drop_chance += I.w_class
		if(prob(drop_chance) && owner.dropItemToGround(I))
			to_chat(owner, span_warning("我把[I]掉到了地上！"))

	else if(prob(3))
		to_chat(owner, span_warning("我的肌肉突然一阵无力！"))
		owner.adjustStaminaLoss(50)
	..()

/datum/brain_trauma/mild/muscle_spasms
	name = "肌肉痉挛"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我的肌肉虚弱得有些反常。")
	lose_text = span_notice("我重新能控制自己的肌肉了。")

/datum/brain_trauma/mild/muscle_spasms/on_gain()
	owner.apply_status_effect(STATUS_EFFECT_SPASMS)
	..()

/datum/brain_trauma/mild/muscle_spasms/on_lose()
	owner.remove_status_effect(STATUS_EFFECT_SPASMS)
	..()

/datum/brain_trauma/mild/nervous_cough
	name = "神经性咳嗽"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我的喉咙痒得停不下来……")
	lose_text = span_notice("我的喉咙终于不痒了。")

/datum/brain_trauma/mild/nervous_cough/on_life()
	if(prob(12) && !HAS_TRAIT(owner, TRAIT_SOOTHED_THROAT))
		if(prob(5))
			to_chat(owner, "<span notice='warning'>[pick("我突然剧烈咳嗽起来！", "我根本止不住咳嗽！")]</span>")
			owner.Immobilize(20)
			owner.emote("cough")
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, emote), "cough"), 6)
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob, emote), "cough"), 12)
		owner.emote("cough")
	..()

/datum/brain_trauma/mild/expressive_aphasia
	name = "表达性失语"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我开始无法掌握复杂词汇了。")
	lose_text = span_notice("我感觉自己的词汇能力恢复正常了。")

	var/static/list/common_words = world.file2list("strings/1000_most_common.txt")

/datum/brain_trauma/mild/expressive_aphasia/handle_speech(datum/source, list/speech_args)
	var/message = speech_args[SPEECH_MESSAGE]
	if(message)
		var/list/message_split = splittext(message, " ")
		var/list/new_message = list()

		for(var/word in message_split)
			var/suffix = copytext(word,-1)

			// Check if we have a suffix and break it out of the word
			if(suffix in list("." , "," , ";" , "!" , ":" , "?"))
				word = copytext(word,1,-1)
			else
				suffix = ""

			word = html_decode(word)

			if(LOWER_TEXT(word) in common_words)
				new_message += word + suffix
			else
				if(prob(30) && message_split.len > 2)
					new_message += pick("uh","erm")
					break
				else
					var/list/charlist = string2charlist(word) // Stupid shit code
					shuffle_inplace(charlist)
					charlist.len = round(charlist.len * 0.5,1)
					new_message += html_encode(jointext(charlist,"")) + suffix

		message = jointext(new_message, " ")

	speech_args[SPEECH_MESSAGE] = trim(message)

/datum/brain_trauma/mild/mind_echo
	name = "心念回响"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我感到自己的思绪正泛起微弱回响……")
	lose_text = span_notice("那微弱的回响消散了。")
	var/list/hear_dejavu = list()
	var/list/speak_dejavu = list()

/datum/brain_trauma/mild/mind_echo/handle_hearing(datum/source, list/hearing_args)
	if(owner == hearing_args[HEARING_SPEAKER])
		return
	if(hear_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(hear_dejavu)
			var/static/regex/quoted_spoken_message = regex("\".+\"", "gi")
			hearing_args[HEARING_MESSAGE] = quoted_spoken_message.Replace(hearing_args[HEARING_MESSAGE], "\"[deja_vu]\"") //Quotes included to avoid cases where someone says part of their name
			return
	if(hear_dejavu.len >= 15)
		if(prob(50))
			popleft(hear_dejavu) //Remove the oldest
			hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]
	else
		hear_dejavu += hearing_args[HEARING_RAW_MESSAGE]

/datum/brain_trauma/mild/mind_echo/handle_speech(datum/source, list/speech_args)
	if(speak_dejavu.len >= 5)
		if(prob(25))
			var/deja_vu = pick_n_take(speak_dejavu)
			speech_args[SPEECH_MESSAGE] = deja_vu
			return
	if(speak_dejavu.len >= 15)
		if(prob(50))
			popleft(speak_dejavu) //Remove the oldest
			speak_dejavu += speech_args[SPEECH_MESSAGE]
	else
		speak_dejavu += speech_args[SPEECH_MESSAGE]
