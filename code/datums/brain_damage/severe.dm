//Severe traumas, when my brain gets abused way too much.
//These range from very annoying to completely debilitating.
//They cannot be cured with chemicals, and require brain surgery to solve.

/datum/brain_trauma/severe
	resilience = TRAUMA_RESILIENCE_SURGERY

/datum/brain_trauma/severe/mute
	name = "缄默症"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我忘记该如何说话了！")
	lose_text = span_notice("我突然想起该怎么说话了。")

/datum/brain_trauma/severe/mute/on_gain()
	ADD_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/mute/on_lose()
	REMOVE_TRAIT(owner, TRAIT_MUTE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/aphasia
	name = "失语症"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我很难在脑海里组织出词句……")
	lose_text = span_notice("我突然想起语言该如何运作了。")
	var/datum/language_holder/prev_language
	var/datum/language_holder/mob_language

/datum/brain_trauma/severe/aphasia/on_gain()
	mob_language = owner.get_language_holder()
	prev_language = mob_language.copy()
	mob_language.remove_all_languages()
	mob_language.grant_language(/datum/language/aphasia)
	..()

/datum/brain_trauma/severe/aphasia/on_lose()
	mob_language.remove_language(/datum/language/aphasia)
	mob_language.copy_known_languages_from(prev_language) //this will also preserve languages learned during the trauma
	QDEL_NULL(prev_language)
	mob_language = null
	..()

/datum/brain_trauma/severe/blindness
	name = "脑性失明"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我看不见了！")
	lose_text = span_notice("我的视力恢复了。")

/datum/brain_trauma/severe/blindness/on_gain()
	owner.become_blind(TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/blindness/on_lose()
	owner.cure_blind(TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/paralysis
	name = "瘫痪"
	desc = ""
	scan_desc = ""
	gain_text = ""
	lose_text = ""
	var/paralysis_type
	var/list/paralysis_traits = list()
	//for descriptions

/datum/brain_trauma/severe/paralysis/New(specific_type)
	if(specific_type)
		paralysis_type = specific_type
	if(!paralysis_type)
		paralysis_type = pick("full","left","right","arms","legs","r_arm","l_arm","r_leg","l_leg")
	var/subject
	switch(paralysis_type)
		if("full")
			subject = "我的身体"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("left")
			subject = "我身体的左半边"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_L_LEG)
		if("right")
			subject = "我身体的右半边"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM, TRAIT_PARALYSIS_R_LEG)
		if("arms")
			subject = "我的双臂"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM, TRAIT_PARALYSIS_R_ARM)
		if("legs")
			subject = "我的双腿"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG, TRAIT_PARALYSIS_R_LEG)
		if("r_arm")
			subject = "我的右臂"
			paralysis_traits = list(TRAIT_PARALYSIS_R_ARM)
		if("l_arm")
			subject = "我的左臂"
			paralysis_traits = list(TRAIT_PARALYSIS_L_ARM)
		if("r_leg")
			subject = "我的右腿"
			paralysis_traits = list(TRAIT_PARALYSIS_R_LEG)
		if("l_leg")
			subject = "我的左腿"
			paralysis_traits = list(TRAIT_PARALYSIS_L_LEG)

	gain_text = span_warning("我再也感觉不到[subject]了！")
	lose_text = span_notice("我又能感觉到[subject]了！")

/datum/brain_trauma/severe/paralysis/on_gain()
	..()
	for(var/X in paralysis_traits)
		ADD_TRAIT(owner, X, "trauma_paralysis")
	owner.update_disabled_bodyparts()

/datum/brain_trauma/severe/paralysis/on_lose()
	..()
	for(var/X in paralysis_traits)
		REMOVE_TRAIT(owner, X, "trauma_paralysis")
	owner.update_disabled_bodyparts()

/datum/brain_trauma/severe/paralysis/paraplegic
	random_gain = FALSE
	paralysis_type = "legs"
	resilience = TRAUMA_RESILIENCE_ABSOLUTE

/datum/brain_trauma/severe/narcolepsy
	name = "嗜睡症"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我总是有种昏昏欲睡的感觉……")
	lose_text = span_notice("我又感到清醒而警觉了。")

/datum/brain_trauma/severe/narcolepsy/on_life()
	..()
	if(owner.IsSleeping())
		return
	var/sleep_chance = 1
	if(owner.m_intent == MOVE_INTENT_RUN)
		sleep_chance += 2
	if(owner.drowsyness)
		sleep_chance += 3
	if(prob(sleep_chance))
		to_chat(owner, span_warning("我睡着了。"))
		owner.Sleeping(60)
	else if(!owner.drowsyness && prob(sleep_chance * 2))
		to_chat(owner, span_warning("我好累……"))
		owner.drowsyness += 10

/datum/brain_trauma/severe/monophobia
	name = "孤独恐惧症"
	desc = ""
	scan_desc = ""
	gain_text = ""
	lose_text = span_notice("我觉得自己一个人时也能安然无恙了。")
	var/stress = 0

/datum/brain_trauma/severe/monophobia/on_gain()
	..()
	if(check_alone())
		to_chat(owner, span_warning("我觉得好孤单……"))
	else
		to_chat(owner, span_notice("只要身边还有人，我就会觉得安心。"))

/datum/brain_trauma/severe/monophobia/on_life()
	..()
	if(check_alone())
		stress = min(stress + 0.5, 100)
		if(stress > 10 && (prob(5)))
			stress_reaction()
	else
		stress = max(stress - 4, 0)

/datum/brain_trauma/severe/monophobia/proc/check_alone()
	if(HAS_TRAIT(owner, TRAIT_BLIND))
		return TRUE
	for(var/mob/M in oview(owner, 7))
		if(!isliving(M)) //ghosts ain't people
			continue
		if((istype(M, /mob/living/simple_animal/pet)) || M.ckey)
			return FALSE
	return TRUE

/datum/brain_trauma/severe/monophobia/proc/stress_reaction()
	if(owner.stat != CONSCIOUS)
		return

	var/high_stress = (stress > 60) //things get psychosomatic from here on
	switch(rand(1,6))
		if(1)
			if(!high_stress)
				to_chat(owner, span_warning("我觉得恶心……"))
			else
				to_chat(owner, span_warning("一想到自己孤身一人，我就恶心得难受！"))
			addtimer(CALLBACK(owner, TYPE_PROC_REF(/mob/living/carbon, vomit), high_stress), 50) //blood vomit if high stress
		if(2)
			if(!high_stress)
				to_chat(owner, span_warning("我抖个不停……"))
				owner.dizziness += 20
				owner.confused += 20
				owner.Jitter(20)
			else
				to_chat(owner, span_warning("我又虚弱又害怕！要是我不是独自一人就好了……"))
				owner.dizziness += 20
				owner.confused += 20
				owner.Jitter(20)
				owner.adjustStaminaLoss(50)

		if(3, 4)
			if(!high_stress)
				to_chat(owner, span_warning("我觉得好孤单……"))
			else
				to_chat(owner, span_warning("我快被孤独逼疯了！"))
				owner.hallucination += 30

		if(5)
			if(!high_stress)
				to_chat(owner, span_warning("我的心猛地漏跳了一拍。"))
				owner.adjustOxyLoss(8)
			else
				if(prob(15) && ishuman(owner))
					var/mob/living/carbon/human/H = owner
					H.set_heartattack(TRUE)
					to_chat(H, span_danger("我的心口传来一阵刺痛！"))
				else
					to_chat(owner, span_danger("我感觉心脏在胸腔里一阵猛颤……"))
					owner.adjustOxyLoss(8)
		else
			return

/datum/brain_trauma/severe/discoordination
	name = "运动失调"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我几乎控制不住自己的手了！")
	lose_text = span_notice("我又重新掌控住自己的双手了。")

/datum/brain_trauma/severe/discoordination/on_gain()
	ADD_TRAIT(owner, TRAIT_MONKEYLIKE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/discoordination/on_lose()
	REMOVE_TRAIT(owner, TRAIT_MONKEYLIKE, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/pacifism
	name = "创伤性非暴力倾向"
	desc = ""
	scan_desc = ""
	gain_text = span_notice("我感到一种异样的平和。")
	lose_text = span_notice("我不再被某种力量驱使着不去伤害别人了。")

/datum/brain_trauma/severe/pacifism/on_gain()
	ADD_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/pacifism/on_lose()
	REMOVE_TRAIT(owner, TRAIT_PACIFISM, TRAUMA_TRAIT)
	..()

/datum/brain_trauma/severe/hypnotic_stupor
	name = "催眠性恍惚"
	desc = ""
	scan_desc = ""
	gain_text = span_warning("我感觉有些恍惚。")
	lose_text = span_notice("我感觉脑中的迷雾终于散去了。")

/datum/brain_trauma/severe/hypnotic_stupor/on_lose() //hypnosis must be cleared separately, but brain surgery should get rid of both anyway
	..()
	owner.remove_status_effect(/datum/status_effect/trance)

/datum/brain_trauma/severe/hypnotic_stupor/on_life()
	..()
	if(prob(1) && !owner.has_status_effect(/datum/status_effect/trance))
		owner.apply_status_effect(/datum/status_effect/trance, rand(100,300), FALSE)
