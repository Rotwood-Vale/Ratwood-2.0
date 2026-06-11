// why does this use a component, it should be on the heart beast type, this is dumb
/datum/component/chimeric_heart_beast
	var/obj/structure/roguemachine/chimeric_heart_beast/heart_beast
	var/base_blood_output = 1
	var/blood_output = 1
	var/blood_pool = 0
	var/max_blood_pool = 20000
	var/happiness = 0
	// True by default, some quirks can make the beast dissatisfied.
	var/satisfied = TRUE
	var/max_happiness = 1000
	var/tech_points = 0
	var/language_tier = 1
	var/max_language_tier = 4
	var/current_language_progress = 0
	var/max_language_progress = 1000

	var/datum/flesh_task/current_task
	var/datum/flesh_task/next_task
	var/last_task_time = 0
	var/task_cooldown = 20 SECONDS

	var/mob/living/current_listener
	var/listener_timeout_time = 0
	var/last_happiness_decay = 0
	var/happiness_decay_interval = 30 SECONDS
	var/last_environment_process = 0
	var/environment_process_interval = 3 SECONDS

	// The first list here is just used to keep track of all active quirks, should we wish to be able to disable any later
	var/list/active_quirks = list()
	var/list/language_quirks = list()
	var/list/behavior_quirks = list()
	var/list/environment_quirks = list()
	var/list/item_interaction_quirks = list()

	var/task_presentation_time = 0 // When the current task was last presented to the listener
	var/response_time_threshold = 10 SECONDS // 10 second threshold for patient/impatient quirks

	var/obj/structure/stone_rack/linked_rack

/datum/component/chimeric_heart_beast/Initialize()
	. = ..()
	if(!istype(parent, /obj/structure/roguemachine/chimeric_heart_beast))
		return COMPONENT_INCOMPATIBLE

	heart_beast = parent
	START_PROCESSING(SSobj, src)

	last_happiness_decay = world.time

	RegisterSignal(heart_beast, COMSIG_HEART_BEAST_HEAR, PROC_REF(on_hear))
	RegisterSignal(heart_beast, COMSIG_ATOM_ATTACK_HAND, PROC_REF(on_interact))
	RegisterSignal(heart_beast, COMSIG_PARENT_ATTACKBY, PROC_REF(on_item_interact))

	initialize_quirks()
	setup_heartbeast_turfs()
	addtimer(CALLBACK(src, PROC_REF(link_to_racks)), 5 SECONDS)

/datum/component/chimeric_heart_beast/proc/setup_heartbeast_turfs()
	var/turf/center_turf = get_turf(heart_beast)

	var/turf/top_left = locate(center_turf.x - 1, center_turf.y + 2, center_turf.z)
	var/turf/top_center = locate(center_turf.x, center_turf.y + 2, center_turf.z)
	var/turf/top_right = locate(center_turf.x + 1, center_turf.y + 2, center_turf.z)
	var/turf/mid_left = locate(center_turf.x - 1, center_turf.y + 1, center_turf.z)
	var/turf/mid_center = locate(center_turf.x, center_turf.y + 1, center_turf.z)
	var/turf/mid_right = locate(center_turf.x + 1, center_turf.y + 1, center_turf.z)

	var/list/dense_turfs = list(top_left, top_center, top_right, mid_left, mid_center, mid_right)
	for(var/turf/T in dense_turfs)
		if(T)
			T.density = TRUE
			T.opacity = FALSE

	heart_beast.dense_turfs = dense_turfs

/datum/component/chimeric_heart_beast/proc/initialize_quirks()
	if(!heart_beast.quirks)
		return

	for(var/datum/flesh_quirk/quirk in heart_beast.quirks)
		active_quirks[quirk.type] = quirk

		if(quirk.quirk_type & QUIRK_LANGUAGE)
			language_quirks += quirk
		if(quirk.quirk_type & QUIRK_BEHAVIOR)
			behavior_quirks += quirk
		if(quirk.quirk_type & QUIRK_ENVIRONMENT)
			environment_quirks += quirk
		if(quirk.quirk_type & QUIRK_INTERACT)
			item_interaction_quirks += quirk

/datum/component/chimeric_heart_beast/proc/has_quirk(quirk_type)
	return active_quirks[quirk_type] != null

/datum/component/chimeric_heart_beast/proc/get_quirk(quirk_type_path)
	if(active_quirks)
		return active_quirks[quirk_type_path]
	return null

/datum/component/chimeric_heart_beast/proc/apply_language_quirks(mob/speaker, message, response_time)
	var/list/penalties = list()
	penalties["score_penalty"] = 0
	penalties["score_bonus"] = 0
	penalties["happiness_multiplier"] = 1
	penalties["blood_multiplier"] = 1
	penalties["tech_multiplier"] = 1
	penalties["punctuation_override"] = 0

	if(!language_quirks.len)
		return penalties

	// Use default values, but apply differences for each language quirk that acts up
	for(var/datum/flesh_quirk/quirk in language_quirks)
		var/list/quirk_effects = quirk.apply_language_quirk(speaker, message, response_time, src)
		if(quirk_effects)
			penalties["score_penalty"] += quirk_effects["score_penalty"]
			penalties["score_bonus"] += quirk_effects["score_bonus"]
			penalties["happiness_multiplier"] *= (quirk_effects["happiness_multiplier"])
			penalties["blood_multiplier"] *= (quirk_effects["blood_multiplier"])
			penalties["tech_multiplier"] *= (quirk_effects["tech_multiplier"])
			if(quirk_effects["punctuation_override"])
				penalties["punctuation_override"] = quirk_effects["punctuation_override"]
	return penalties

/datum/component/chimeric_heart_beast/proc/trigger_behavior_quirks(score, mob/speaker, message)
	if(!behavior_quirks.len)
		return score

	for(var/datum/flesh_quirk/quirk in behavior_quirks)
		score = quirk.apply_behavior_quirk(score, speaker, message, src)
	return score

/datum/component/chimeric_heart_beast/proc/trigger_discharge_effect()
	var/list/valid_turfs = list()
	for(var/turf/T in view(7, heart_beast))
		if(!T.density)
			valid_turfs += T

	if(!valid_turfs.len)
		return

	heart_beast.visible_message(span_warning("[heart_beast]浑身一颤，喷出一团五彩分泌物！"))

	var/num_projectiles = rand(3, 6)
	for(var/i = 1 to num_projectiles)
		if(!valid_turfs.len)
			break

		spawn(rand(1, 5) SECONDS)
			var/turf/target_turf = pick(valid_turfs)
			valid_turfs -= target_turf
			playsound(heart_beast, 'sound/misc/machinevomit.ogg', 75, TRUE)
			create_discharge_projectile(target_turf)

/datum/component/chimeric_heart_beast/proc/process_environment_quirks()
	if(!environment_quirks.len)
		return

	var/list/visible_turfs = list()
	for(var/turf/T in view(7, heart_beast))
		if(can_see(heart_beast, T, 7))
			visible_turfs += T

	for(var/datum/flesh_quirk/quirk in environment_quirks)
		quirk.apply_environment_quirk(visible_turfs, src)

/datum/component/chimeric_heart_beast/Destroy()
	STOP_PROCESSING(SSobj, src)
	UnregisterSignal(heart_beast, list(COMSIG_HEART_BEAST_HEAR, COMSIG_ATOM_ATTACK_HAND))
	. = ..()

/datum/component/chimeric_heart_beast/proc/update_blood_output()
	blood_output = 1 + 2 * (happiness / max_happiness)

/datum/component/chimeric_heart_beast/process(delta_time)
	blood_pool = min(blood_pool + blood_output * delta_time, max_blood_pool)
	update_blood_overlay()

	if(!current_task && world.time > last_task_time + task_cooldown)
		generate_new_task()

	if(world.time > last_happiness_decay + happiness_decay_interval)
		decay_happiness()
		last_happiness_decay = world.time

	if(current_listener && world.time > listener_timeout_time)
		clear_listener()

	if(world.time > last_environment_process + environment_process_interval)
		process_environment_quirks()
		last_environment_process = world.time

/datum/component/chimeric_heart_beast/proc/decay_happiness()
	happiness = max(happiness - (max_happiness * 0.05), 0)

	if(happiness <= 20 && prob(20))
		heart_beast.visible_message(span_warning("[heart_beast]显得有些不满……"))

/datum/component/chimeric_heart_beast/proc/update_blood_overlay()
	var/blood_percent = blood_pool / max_blood_pool
	heart_beast.cut_overlays()

	var/chunk = round(blood_percent * 5) // This gives us 0-5
	if(chunk >= 1)
		heart_beast.add_overlay(mutable_appearance('icons/obj/structures/heart_beast.dmi', "blood_[chunk]"))

/datum/component/chimeric_heart_beast/proc/generate_new_task()
	if(next_task)
		current_task = next_task
		next_task = null
	else
		current_task = new /datum/flesh_task/knowledge(language_tier, heart_beast)
	last_task_time = world.time

	heart_beast.say(current_task.question)
	playsound(heart_beast, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)

/datum/component/chimeric_heart_beast/proc/on_interact(datum/source, mob/user)
	SIGNAL_HANDLER

	if(current_task && satisfied)
		heart_beast.say(current_task.question)
		playsound(heart_beast, 'sound/misc/machinetalk.ogg', 100, FALSE, -1)
		set_current_listener(user)
		heart_beast.visible_message(span_warning("[heart_beast]的触须专注地朝[user]伸了过去！"))
	else if (!satisfied)
		playsound(heart_beast, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		heart_beast.visible_message(span_warning("[heart_beast]现在脾气太差，不想学习……也许它得先要点别的东西。"))
	else if (!current_task)
		playsound(heart_beast, 'sound/misc/machineno.ogg', 100, FALSE, -1)
		heart_beast.visible_message(span_warning("[heart_beast]看起来累了，挥动触须把你赶开。"))

/datum/component/chimeric_heart_beast/proc/on_item_interact(datum/source, obj/item/I, mob/user)
	SIGNAL_HANDLER

	if(istype(I, /obj/item/heart_blood_canister))
		spawn(0)
			try_fill_blood_container(I, user, (max_blood_pool / 10), /obj/item/heart_blood_canister/filled)
		return
	else if(istype(I, /obj/item/heart_blood_vial))
		spawn(0)
			try_fill_blood_container(I, user, (max_blood_pool / 30), /obj/item/heart_blood_vial/filled)
		return

	if(!item_interaction_quirks.len)
		return

	for(var/datum/flesh_quirk/quirk in item_interaction_quirks)
		quirk.apply_item_interaction_quirk(I, user, src)

/datum/component/chimeric_heart_beast/proc/try_fill_blood_container(obj/item/empty_container, mob/user, amount, filled_type)
	if(blood_pool < amount)
		to_chat(user, span_warning("血池储量太低，无法装满[empty_container]。"))
		return FALSE

	to_chat(user, span_info("你开始用血池里的血液灌装[empty_container]。"))

	if(do_after(user, 5 SECONDS))
		if(blood_pool >= amount)
			blood_pool -= amount
			qdel(empty_container)
			var/obj/item/newcan = new filled_type (user.loc)
			user.put_in_hands(newcan)
			return TRUE
		else
			to_chat(user, span_warning("你在灌装[empty_container]时，血池已经见底了。"))
			return FALSE
	to_chat(user, span_warning("你停止了灌装[empty_container]。"))
	return FALSE

/datum/component/chimeric_heart_beast/proc/set_current_listener(mob/user)
	current_listener = user
	listener_timeout_time = world.time + 1 MINUTES
	task_presentation_time = world.time

/datum/component/chimeric_heart_beast/proc/clear_listener()
	current_listener = null
	listener_timeout_time = 0
	heart_beast.visible_message(span_notice("[heart_beast]的触须缩了回去，不再专注于任何人。"))

/datum/component/chimeric_heart_beast/proc/on_hear(datum/source, mob/speaker, raw_message)
	SIGNAL_HANDLER

	// Only process if we have a current task and this is our designated listener
	if(!current_task)
		return
	if(speaker != current_listener)
		return

	// Check if this might be an answer to our question
	evaluate_answer(raw_message, speaker)

/datum/component/chimeric_heart_beast/proc/evaluate_answer(message, mob/speaker)
	var/datum/flesh_task/knowledge/task = current_task
	if(!istype(task))
		return

	var/response_time = world.time - task_presentation_time
	var/list/quirk_effects = apply_language_quirks(speaker, message, response_time)

	var/score = 0
	var/word_count = length(splittext(message, " "))
	var/last_char = copytext(message, -1)

	// Check word count
	if(word_count >= task.min_words && word_count <= task.max_words)
		score += 30

	// Check punctuation
	var/expected_punctuation = quirk_effects["punctuation_override"] ? quirk_effects["punctuation_override"] : task.preferred_punctuation
	if(last_char == expected_punctuation)
		score += 20

	// Check for keywords (up to 2)
	var/keywords_found = 0
	for(var/keyword in task.answer_keywords)
		if(findtext(LOWER_TEXT(message), LOWER_TEXT(keyword)))
			keywords_found++
			if(keywords_found >= 2)
				break
	score += min(keywords_found, 2) * 25

	// If our quirks act up for whatever reason, reduce our score by a flat amount
	if(quirk_effects["score_penalty"])
		score = max(score - quirk_effects["score_penalty"], 0)
	else if(quirk_effects["score_bonus"])
		score = min(score + quirk_effects["score_bonus"], 100)

	score = trigger_behavior_quirks(score, speaker, message)

	// Determine success
	linked_rack.advance_calibration()
	if(score >= 20) // Passing score
		complete_task(score, speaker, quirk_effects)
	else
		fail_task(score, speaker)

/datum/component/chimeric_heart_beast/proc/complete_task(score, mob/speaker, list/quirk_effects)
	var/reward_multiplier = score / 100

	// Calculate rewards
	var/blood_reward = (max_blood_pool / 10) * reward_multiplier * (quirk_effects["blood_multiplier"] || 1)
	// 20 - 40 - 80 - 160 Under perfect circumstances
	var/rack_multiplier = linked_rack.update_rack_stats()
	var/tech_reward = (20 * (2 ** (language_tier - 1))) * reward_multiplier * ((quirk_effects["tech_multiplier"] || 1) * rack_multiplier)
	var/happiness_reward = (max_happiness / 4) * reward_multiplier * (quirk_effects["happiness_multiplier"] || 1)
	// 2 perfect answers, or 4 mediocre ones, 8 serviceable answers
	var/language_progress_reward = (max_language_progress / 2) * reward_multiplier

	// Apply rewards
	blood_pool = min(blood_pool + blood_reward, max_blood_pool)
	tech_points += tech_reward
	happiness = min(happiness + happiness_reward, max_happiness)
	current_language_progress = min(current_language_progress + language_progress_reward, max_language_progress)
	update_blood_output()
	upgrade_language_tier()

	var/feedback_message = get_tier_feedback("success", score)
	heart_beast.say(feedback_message)
	playsound(heart_beast, 'sound/misc/machineyes.ogg', 100, FALSE, -1)

	current_task = null
	clear_listener()

/datum/component/chimeric_heart_beast/proc/fail_task(score, mob/speaker)
	var/happiness_penalty = max_happiness * 0.05

	// Apply penalties
	happiness = max(happiness - happiness_penalty, 0)
	update_blood_output()

	var/feedback_message = get_tier_feedback("failure", score)
	heart_beast.say(feedback_message)
	playsound(heart_beast, 'sound/misc/machineno.ogg', 100, FALSE, -1)

	// Clear listener but keep task
	clear_listener()

/datum/component/chimeric_heart_beast/proc/upgrade_language_tier()
	if(current_language_progress >= max_language_progress && language_tier != max_language_tier)
		language_tier++
		heart_beast.visible_message(span_notice("[heart_beast]似乎因新获得的理解而共鸣起来！"))
		playsound(heart_beast, 'sound/misc/machinelong.ogg', 100, FALSE, -1)
		current_language_progress = 0

/datum/component/chimeric_heart_beast/proc/get_tier_feedback(type, score)
	var/list/success_responses = list()
	var/list/failure_responses = list()

	//25% increased chance per language tier to give extra feedback on how good answers are.
	if(prob(language_tier * 25))
		switch(score)
			if(0 to 49)
				heart_beast.visible_message(span_warning("[heart_beast]看起来只是勉强满意。"))
			if(50 to 74)
				heart_beast.visible_message(span_notice("[heart_beast]轻轻搏动着，似乎很满意。"))
			if(75 to 100)
				heart_beast.visible_message(span_cult("[heart_beast]强烈地搏动着，显得无比满足！"))

	switch(language_tier)
		if(1)
			success_responses = list(
				"懂……",
				"知道……是……",
				"规律……好……",
				"理解……流动……"
			)
			failure_responses = list(
				"坏……规律……",
				"不……知道……",
				"错……形状……",
				"混乱……呃噜噜……"
			)
		if(2)
			success_responses = list(
				"理解在流动……",
				"知识已接受。",
				"规律清晰起来了。",
				"是的……我明白了……"
			)
			failure_responses = list(
				"无法理解……",
				"含义溜走了……",
				"规律不清晰。",
				"不对……"
			)
		if(3)
			success_responses = list(
				"理解优雅地流过。",
				"我怀着感激接受了你的知识。",
				"这规律变得清晰而美妙。",
				"我完全理解你的意思。"
			)
			failure_responses = list(
				"你的意思对我而言仍然晦涩。",
				"这规律仍无法清晰成形。",
				"我无法从中提取理解。",
				"这个回答缺乏连贯性。"
			)
		if(4)
			success_responses = list(
				"理解的本质以完美的清晰度流过我。",
				"我怀着感激接受你的智慧，并将其融入自身。",
				"存在的宏大纹理在我们共享的意识前变得清晰。",
				"凭借这份知识，我们正接近思想与目的的真正统一。"
			)
			failure_responses = list(
				"即便在我们更高的状态下，这个回答仍未能传达有意义的理解。",
				"尽管我们彼此相连，这规律仍令人沮丧地晦暗不明。",
				"这个回答缺少与我们此等共鸣层次相称的连贯性。",
				"我无法将这碎裂的思绪纳入我们的共同理解。"
			)

	if(type == "success")
		return pick(success_responses)
	else
		return pick(failure_responses)

// Task datums
/datum/flesh_task
	var/question
	var/min_words = 1
	var/max_words = 50
	var/preferred_punctuation = "?"
	var/list/answer_keywords = list()

/datum/flesh_task/knowledge
	var/datum/flesh_concept/concept

/datum/flesh_task/knowledge/New(language_tier, obj/structure/roguemachine/chimeric_heart_beast/heart_beast)
	. = ..()
	var/list/possible_concepts = list()
	for(var/datum/flesh_trait/trait in heart_beast.traits)
		possible_concepts += trait.liked_concepts

	if(possible_concepts.len)
		var/concept_type = pick(possible_concepts)
		concept = new concept_type()
	else
		// Fallback just in case
		concept = pick(new /datum/flesh_concept/identity(), new /datum/flesh_concept/unity())

	answer_keywords = concept.answer_keywords.Copy()
	question = pick(concept.tier_questions[language_tier])

	// Adjust parameters based on traits
	for(var/datum/flesh_trait/trait in heart_beast.traits)
		if(trait.preferred_approaches["min_words"])
			min_words = trait.preferred_approaches["min_words"]
		if(trait.preferred_approaches["max_words"])
			max_words = trait.preferred_approaches["max_words"]
		if(trait.preferred_approaches["punctuation"])
			preferred_punctuation = trait.preferred_approaches["punctuation"]

/datum/component/chimeric_heart_beast/proc/link_to_racks()
	if(!heart_beast || !heart_beast.loc)
		return

	//Range() might be better, but I couldn't find racks through walls so we're doing it this way
	var/search_range = 7
	var/center_x = heart_beast.x
	var/center_y = heart_beast.y
	var/center_z = heart_beast.z

	var/x1 = center_x - search_range
	var/y1 = center_y - search_range
	var/x2 = center_x + search_range
	var/y2 = center_y + search_range

	for(var/i in x1 to x2)
		for(var/j in y1 to y2)
			var/turf/T = locate(i, j, center_z)
			if(!T)
				continue
			var/obj/structure/stone_rack/rack = locate(/obj/structure/stone_rack) in T.contents
			if(rack)
				if(!rack.heart_component)
					linked_rack = rack
					rack.heart_component = src
					return
