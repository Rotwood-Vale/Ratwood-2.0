/datum/flesh_quirk
	var/name = "基础怪癖"
	var/description = "一种行为怪癖"
	var/list/conflicting_quirks = list()
	var/rarity = 10 // Higher = more common
	var/quirk_type = QUIRK_LANGUAGE
	var/color = "#ffffff"
	var/required_item
	var/calibration_required = 4

/datum/flesh_quirk/proc/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	return null

/datum/flesh_quirk/proc/apply_behavior_quirk(score, mob/speaker, message, datum/component/chimeric_heart_beast/beast)
	return null

/datum/flesh_quirk/proc/apply_environment_quirk(list/visible_turfs, datum/component/chimeric_heart_beast/beast)
	return null

/datum/flesh_quirk/proc/apply_item_interaction_quirk(obj/item/I, mob/user, datum/component/chimeric_heart_beast/beast)
	return null

/datum/flesh_quirk/obedient
	name = "顺从"
	description = "被人吼叫时反而会回应得更好。"
	conflicting_quirks = list(/datum/flesh_quirk/stubborn, /datum/flesh_quirk/timid, /datum/flesh_quirk/curious)
	quirk_type = QUIRK_LANGUAGE
	color = "#8b4513"
	required_item = /obj/item/alch/taraxacum

/datum/flesh_quirk/obedient/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	var/list/effects = list()
	var/last_char = copytext(message, -1)

	effects["punctuation_override"] = "!"

	if(last_char != "!")
		effects["score_penalty"] = 25
		effects["happiness_multiplier"] = 0

	return effects

/datum/flesh_quirk/curious
	name = "好奇"
	description = "期待别人用带有疑问的语气来引导它。"
	conflicting_quirks = list(/datum/flesh_quirk/timid, /datum/flesh_quirk/obedient)
	rarity = 5
	quirk_type = QUIRK_LANGUAGE
	color = "#ffd700"
	required_item = /obj/item/alch/euphrasia

/datum/flesh_quirk/curious/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	var/list/effects = list()
	var/last_char = copytext(message, -1)

	effects["punctuation_override"] = "?"

	if(last_char != "?")
		effects["score_penalty"] = 25
		effects["happiness_multiplier"] = 0

	return effects

/datum/flesh_quirk/impatient
	name = "急躁"
	description = "偏好迅速回应，延迟会让它烦躁。与其互动后需在10秒内作答。"
	conflicting_quirks = list(/datum/flesh_quirk/patient)
	quirk_type = QUIRK_LANGUAGE
	color = "#ff4500"
	required_item = /obj/item/alch/urtica

/datum/flesh_quirk/impatient/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	var/list/effects = list()

	if(response_time > beast.response_time_threshold)
		effects["score_penalty"] = 25
		effects["happiness_multiplier"] = 0.5

	return effects

/datum/flesh_quirk/royal
	name = "尊贵"
	description = "要求别人用特定称谓称呼它，否则可能被冒犯。可能的称谓有：陛下、伟大者、主人、霸主、尊上。对低智心兽无效。"
	quirk_type = QUIRK_LANGUAGE
	rarity = 5
	color = "#daa520"
	required_item = /obj/item/alch/rosa

/datum/flesh_quirk/royal/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	var/list/effects = list()

	// Royal quirk only manifests at tier 2 and above
	if(beast.language_tier < 2)
		return effects

	var/obj/structure/roguemachine/chimeric_heart_beast/heart_beast = beast.heart_beast
	var/royal_title = heart_beast.royal_title

	var/has_title = findtext(LOWER_TEXT(message), LOWER_TEXT(royal_title))
	if(!has_title)
		effects["score_penalty"] = 25
		effects["happiness_multiplier"] = 0

		var/feedback_chance = beast.language_tier * 25
		// Tier-appropriate feedback
		if(prob(feedback_chance))
			switch(beast.language_tier)
				if(2)
					heart_beast.visible_message(span_warning("[heart_beast]显得被冒犯了！"))
				if(3)
					heart_beast.visible_message(span_warning("[heart_beast]看起来受到了极大的冒犯！"))
				if(4)
					heart_beast.visible_message(span_cultlarge("[heart_beast]散发出不悦的气息！"))

	return effects

/datum/flesh_quirk/discharge
	name = "分泌"
	description = "情绪激动时会喷出彩色分泌物。"
	quirk_type = QUIRK_BEHAVIOR
	color = "#9370db"
	required_item = /obj/item/alch/manabloompowder
	calibration_required = 3

/datum/flesh_quirk/discharge/apply_behavior_quirk(score, mob/speaker, message, datum/component/chimeric_heart_beast/beast)
	if(beast.happiness >= beast.max_happiness * 0.75)
		return score

	var/happiness_percentage = (1 - (beast.happiness / beast.max_happiness))
	var/discharge_chance = calculate_discharge_chance(beast.language_tier, score, happiness_percentage)

	if(prob(discharge_chance))
		beast.trigger_discharge_effect()
	return score

/datum/flesh_quirk/discharge/proc/calculate_discharge_chance(language_tier, score, happiness_percentage)
	var/base_chance = 0

	switch(language_tier)
		if(1)
			base_chance = 60
		if(2)
			base_chance = 40
		if(3)
			base_chance = 25
		if(4)
			base_chance = 15

	// 26% at 74% happiness. up to 100% at 0% happiness.
	base_chance *= happiness_percentage
	// 1 at 0 or 100, 0 at 50
	var/score_modifier = 1 - (abs(score - 50) / 50)
	// Up to 200%
	base_chance *= (1 + score_modifier)

	return base_chance

/datum/flesh_quirk/repetitive
	name = "重复"
	description = "常会连续两次重复相近的话题，之后才可能中断。"
	quirk_type = QUIRK_BEHAVIOR
	color = "#808080"
	required_item = /obj/item/alch/paris

/datum/flesh_quirk/repetitive/apply_behavior_quirk(score, mob/speaker, message, datum/component/chimeric_heart_beast/beast)
	if(prob(75) && !beast.next_task)
		beast.next_task = beast.current_task
	return score

/datum/flesh_quirk/timid
	name = "胆怯"
	description = "很容易被吼叫吓到，对这种语气的回应更差。"
	conflicting_quirks = list(/datum/flesh_quirk/royal, /datum/flesh_quirk/obedient, /datum/flesh_quirk/curious)
	quirk_type = QUIRK_LANGUAGE
	color = "#add8e6"
	required_item = /obj/item/alch/valeriana

/datum/flesh_quirk/timid/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	var/list/effects = list()
	var/last_char = copytext(message, -1)

	//Honestly, they're happy if you say nothing at all :)
	effects["punctuation_override"] = " "

	if(last_char == "!")
		effects["score_penalty"] = 25
		effects["happiness_multiplier"] = 0
	else
		// Any other form of punctuation is good
		effects["score_bonus"] = 20

	return effects

/datum/flesh_quirk/ambitious
	name = "雄心勃勃"
	description = "对有头衔或权势的人回应更好，也可能被冒犯。对低智心兽无效。"
	rarity = 1
	quirk_type = QUIRK_LANGUAGE
	color = "#b22222"
	required_item = /obj/item/alch/salvia

/datum/flesh_quirk/ambitious/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	// Too tired for this, but allow wearing a crown or circlet for this later.
	var/list/effects = list()

	if(beast.language_tier < 2)
		return effects

	if(!HAS_TRAIT(speaker, TRAIT_NOBLE))
		effects["score_penalty"] = 25
		effects["happiness_multiplier"] = 0.75
		var/feedback_chance = beast.language_tier * 20
		if(prob(feedback_chance))
			switch(beast.language_tier)
				if(3)
					beast.heart_beast.visible_message(span_warning("[beast.heart_beast]发出轻蔑的冷笑！"))
				if(4)
					beast.heart_beast.visible_message(span_cultlarge("[beast.heart_beast]轻蔑地嗤了一声！"))

	return effects

/datum/flesh_quirk/forgetful
	name = "健忘"
	description = "它可能会忘记你的回答，不管答得多好都给出负面结果。智力越高越不容易触发，5个词以内的回答不会被忘。"
	quirk_type = QUIRK_LANGUAGE
	var/forget_chance = 25
	color = "#d3d3d3"
	required_item = /obj/item/alch/matricaria

/datum/flesh_quirk/forgetful/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	var/list/effects = list()

	var/word_count = length(splittext(message, " "))
	if(word_count < 6)
		return effects

	var/actual_chance = calculate_forget_chance(beast.language_tier, beast.happiness, beast.max_happiness)

	if(prob(actual_chance))
		forget_current_interaction(beast)
		effects["happiness_multiplier"] = 0
		effects["blood_multiplier"] = 0
		effects["tech_multiplier"] = 0
		effects["score_penalty"] = 100
	return effects

/datum/flesh_quirk/forgetful/proc/calculate_forget_chance(language_tier, happiness, max_happiness)
	var/chance = forget_chance

	switch(language_tier)
		if(2)
			chance *= 0.75
		if(3)
			chance *= 0.5
		if(4)
			chance *= 0.25

	var/happiness_percent = (happiness / max_happiness) * 100
	if(happiness_percent < 25)
		chance *= 1.5
	else if(happiness_percent > 75)
		chance *= 0.75

	return chance

/datum/flesh_quirk/forgetful/proc/forget_current_interaction(datum/component/chimeric_heart_beast/beast)
	if(!beast.current_task)
		return

	if(prob(beast.language_tier * 25))
		switch(beast.language_tier)
			if(1)
				beast.heart_beast.say("什么……？")
			if(2)
				beast.heart_beast.say("我忘了……")
			if(3)
				beast.heart_beast.say("我的思绪散开了……")
			if(4)
				beast.heart_beast.say("我们对话的线索从我手中溜走了……")

	beast.current_task = null
	beast.clear_listener()

	// The next task will come very swiftly
	beast.last_task_time = world.time - (beast.task_cooldown * 0.75)

/datum/flesh_quirk/affectionate
	name = "依恋"
	description = "希望你在回答时紧紧站在它身边。"
	quirk_type = QUIRK_LANGUAGE
	color = "#ff69b4"
	required_item = /obj/item/alch/calendula

/datum/flesh_quirk/affectionate/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	var/list/effects = list()
	var/distance = get_dist(beast.heart_beast, speaker)

	if(distance > 1)
		effects["score_penalty"] = 25
		effects["happiness_multiplier"] = 0

	return effects

/datum/flesh_quirk/territorial
	name = "护地"
	description = "可能攻击任何靠近的人。新鲜屠宰的肉能让它平静下来。"
	quirk_type = QUIRK_ENVIRONMENT
	var/last_attack_time = 0
	var/attack_cooldown = 0
	var/saw_meat = FALSE
	var/base_attack_time = 4 SECONDS
	color = "#8b0000"
	required_item = /obj/item/alch/atropa
	calibration_required = 3

/datum/flesh_quirk/territorial/apply_environment_quirk(list/visible_turfs, datum/component/chimeric_heart_beast/beast)
	// Check cooldown
	if(world.time < last_attack_time + attack_cooldown)
		return

	if(beast.heart_beast.recently_fed)
		attack_cooldown = 600 SECONDS
		last_attack_time = world.time
		beast.heart_beast.recently_fed = FALSE
		base_attack_time = initial(base_attack_time)
		return

	// Calculate happiness percentage (1-100)
	var/happiness_percent = round((beast.happiness / beast.max_happiness) * 100)

	if(happiness_percent >= 75)
		return

	var/attack_prob = 100 - happiness_percent
	// Look for mobs within 2 tiles in visible turfs
	var/attack_triggered = FALSE
	for(var/turf/T in visible_turfs)
		if(get_dist(beast.heart_beast, T) > 2)
			continue

		for(var/mob/living/L in T)
			if(L.stat == DEAD)
				if(!iscarbon(L))
					L.gib()
					beast.heart_beast.visible_message(span_danger("[beast.heart_beast]把[L]撕成了碎片！它看起来……无比满足。"))
					beast.heart_beast.recently_fed = TRUE
				continue
			var/has_meat = FALSE
			if(!saw_meat)
				for(var/obj/item/I in L.held_items)
					if(istype(I, /obj/item/reagent_containers/food/snacks/rogue/meat))
						if(I.item_flags & FRESH_FOOD_ITEM)
							has_meat = TRUE
							break
						else
							beast.heart_beast.visible_message(span_infection("巨兽用一根触须碰了碰那块肉，随即缩了回去。也许它还不够新鲜？"))

				if(has_meat)
					attack_cooldown = 20 SECONDS
					last_attack_time = world.time
					attack_triggered = TRUE
					saw_meat = TRUE
					break

			// Calculate attack probability based on unhappiness
			if(prob(attack_prob))
				trigger_territorial_attack(L, beast, TRUE)
				attack_triggered = TRUE
				break

		if(attack_triggered)
			break

/datum/flesh_quirk/territorial/proc/trigger_territorial_attack(mob/living/target, datum/component/chimeric_heart_beast/beast, grace_period = FALSE)
	beast.heart_beast.visible_message(span_userdanger("[beast.heart_beast]的触须猛地抽向[target]！"))
	playsound(beast.heart_beast, 'sound/misc/murderbeast.ogg', 100, FALSE)
	var/happiness_percent = round((beast.happiness / beast.max_happiness) * 100)
	var/attack_prob = 100 - happiness_percent
	var/attack_prob_fraction = attack_prob / 100
	var/cooldown_lower_limit = round(30 * attack_prob_fraction)
	var/cooldown_upper_limit = cooldown_lower_limit * 2
	var/cooldown = (rand(cooldown_lower_limit, cooldown_upper_limit) SECONDS)
	if(grace_period)
		spawn(base_attack_time)
			if(get_dist(beast.heart_beast, target) > 2)
				beast.heart_beast.visible_message(span_infection("[beast.heart_beast]的触须险些够到[target]！真是惊险……"))
				base_attack_time = max(5, base_attack_time - 10)
				return
			target.apply_status_effect(/datum/status_effect/territorial_rage, beast.heart_beast)
			saw_meat = FALSE
			last_attack_time = world.time
			attack_cooldown = cooldown
			base_attack_time = initial(base_attack_time)
	else
		target.apply_status_effect(/datum/status_effect/territorial_rage, beast.heart_beast)
		saw_meat = FALSE
		last_attack_time = world.time
		attack_cooldown = cooldown
		base_attack_time = initial(base_attack_time)

/datum/flesh_quirk/mimic
	name = "模仿"
	description = "倾向于复述并广播他人的话。"
	rarity = 1
	quirk_type = QUIRK_BEHAVIOR
	var/base_mimic_chance = 4
	var/current_mimic_chance = 20
	var/next_mimic_time
	var/mimic_cooldown = 20 MINUTES
	color = "#00ffff"
	required_item = /obj/item/alch/artemisia

/datum/flesh_quirk/mimic/apply_behavior_quirk(score, mob/speaker, message, datum/component/chimeric_heart_beast/beast)
	if(world.time < next_mimic_time)
		return score

	if(score < 20)
		return score

	if(prob(current_mimic_chance))
		trigger_mimic_announcement(message, speaker, beast)
		next_mimic_time = world.time + mimic_cooldown
		current_mimic_chance = base_mimic_chance
	else
		current_mimic_chance += base_mimic_chance

	return score

/datum/flesh_quirk/mimic/proc/trigger_mimic_announcement(message, mob/speaker, datum/component/chimeric_heart_beast/beast)
	var/announcement_text = generate_mimic_text(message, speaker, beast)
	var/speaker_name = speaker ? speaker.real_name : "未知"
	minor_announce(html_decode(announcement_text), "[speaker_name]", TRUE)
	playsound(beast.heart_beast, 'sound/misc/machinelong.ogg', 100, FALSE, -1)

//Splitting this up into a bunch of procs to avoid tons of confusing loops
/datum/flesh_quirk/mimic/proc/generate_mimic_text(message, mob/speaker, datum/component/chimeric_heart_beast/beast)
	switch(beast.language_tier)
		if(1)
			return garble_text(message, 40)
		if(2)
			return garble_text(message, 25)
		if(3)
			return garble_text(message, 10)
		if(4)
			return message

/datum/flesh_quirk/mimic/proc/garble_text(message, garbling_chance)
	var/list/words = splittext(message, " ")
	var/list/garbled_words = list()

	for(var/word in words)
		if(prob(garbling_chance))
			var/garbled_word = garble_word(word)
			garbled_words += garbled_word
		else
			garbled_words += word
	return jointext(garbled_words, " ")

/datum/flesh_quirk/mimic/proc/garble_word(word)
	// Not doing super short words
	if(length(word) <= 2)
		return word
	var/list/chars = splittext(word, "")
	var/swap_count = max(1, round(length(word) * 0.3))

	for(var/i = 1 to swap_count)
		var/pos1 = rand(1, length(word))
		var/pos2 = rand(1, length(word))
		if(pos1 != pos2)
			var/temp = chars[pos1]
			chars[pos1] = chars[pos2]
			chars[pos2] = temp

	return jointext(chars, "")

/datum/flesh_quirk/stubborn
	name = "固执"
	description = "常会否定那些不够相近的回答，而且通常会连续发生两次。"
	conflicting_quirks = list(/datum/flesh_quirk/obedient)
	quirk_type = QUIRK_LANGUAGE
	var/last_successful_score = null
	color = "#2f4f4f"
	required_item = /obj/item/alch/symphitum

/datum/flesh_quirk/stubborn/apply_behavior_quirk(score, mob/speaker, datum/component/chimeric_heart_beast/beast)
	if(last_successful_score)
		var/score_difference = abs(score - last_successful_score)
		if(score_difference > 25)
			score -= 25
		last_successful_score = null
	else
		last_successful_score = score
	return score

/datum/flesh_quirk/patient
	name = "耐心"
	description = "希望你在互动后至少等待10秒，再回答问题。"
	conflicting_quirks = list(/datum/flesh_quirk/impatient)
	quirk_type = QUIRK_LANGUAGE
	rarity = 5
	color = "#006400"
	required_item = /obj/item/alch/hypericum

/datum/flesh_quirk/patient/apply_language_quirk(mob/speaker, message, response_time, datum/component/chimeric_heart_beast/beast)
	var/list/effects = list()

	if(response_time < beast.response_time_threshold)
		effects["score_penalty"] = 25
		effects["happiness_multiplier"] = 0

	return effects
