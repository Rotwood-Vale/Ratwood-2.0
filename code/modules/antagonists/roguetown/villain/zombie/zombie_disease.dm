/datum/status_effect/zombie_infection
	id = "zombie_infection"
	alert_type = /atom/movable/screen/alert/status_effect/zombie_infection
	/// Time until transformation completes
	var/transformation_time
	var/message_cooldown_time
	var/message_cooldown_amount = 20 SECONDS
	/// Whether this infection came from a living host (Aka, did we die and get infected that way?)
	var/infected_wake = FALSE
	// Doesn't hurt making this a static list.
	var/static/list/infection_messages = list(
		"我能感觉到腐朽正沿着喉咙深处缓缓爬上来。嘴里灌满了油腻而带着铜腥味的味道。",
		"我的皮肤又冷又湿。我能感觉到血管正像寒钢一样一点点硬化。",
		"一种深沉的饥饿正在啃噬我的胃。没有任何东西能填满它。",
		"我眼中的世界有那么一瞬间褪去了所有色彩。",
		"我一直听见低语声。是她在呼唤我吗？",
		"我的关节因为一种怪异的僵硬而隐隐作痛。每动一下都疼。",
		"我的心智正在崩裂，我到底是谁？",
		"我能感觉到自己的脉搏正在放慢。我从未如此平静过。",
		"一股怪异的麻木感正在四肢蔓延开来，我明明在流血，却不知道伤口究竟在哪。",
		"我能闻到自己身上的血肉气味，那味道腐臭难闻。"
	)

/datum/status_effect/zombie_infection/on_creation(mob/living/new_owner, time_to_transform = 5 MINUTES, from_infected_wake = "wound")
	. = ..()
	transformation_time = world.time + time_to_transform
	message_cooldown_time = world.time + message_cooldown_amount
	infected_wake = from_infected_wake

/datum/status_effect/zombie_infection/tick()
	if(world.time > message_cooldown_time)
		var/warning_message = pick(infection_messages)
		if(prob(10))
			to_chat(owner, span_userdanger("[warning_message]"))
		else
			to_chat(owner, span_danger("[warning_message]"))
		message_cooldown_time = world.time + message_cooldown_amount
	if(world.time > transformation_time)
		var/mob/living/carbon/human/H = owner
		if(!iscarbon(H))
			owner.remove_status_effect(/datum/status_effect/zombie_infection)

		if(H.stat == DEAD || infected_wake)
			H.zombie_check_can_convert()
			var/datum/antagonist/zombie/zombie_antag = H.mind?.has_antag_datum(/datum/antagonist/zombie)
			if(zombie_antag && !zombie_antag.has_turned)
				zombie_antag.wake_zombie(infected_wake)
				owner.remove_status_effect(/datum/status_effect/zombie_infection)

/datum/status_effect/zombie_infection/on_apply()
	. = ..()
	var/warning_message = pick(infection_messages)
	if(prob(10))
		to_chat(owner, span_userdanger("[warning_message]"))
	else
		to_chat(owner, span_danger("[warning_message]"))
	var/mob/living/carbon/human/H = owner
	if(!iscarbon(H))
		owner.remove_status_effect(/datum/status_effect/zombie_infection)
	H.vomit(1, blood = TRUE, stun = FALSE)
	return TRUE

/atom/movable/screen/alert/status_effect/zombie_infection
	name = "僵尸感染"
	desc = "你感觉一股寒意正在体内扩散。你正在变成那些东西中的一员！"
	icon_state = "zombie"

// Updated proc to use status effect
/mob/living/carbon/human/proc/attempt_zombie_infection(mob/living/carbon/human/source, infection_type, wake_delay = 0)
	var/datum/antagonist/zombie/zombie_antag = source?.mind?.has_antag_datum(/datum/antagonist/zombie)
	if(!zombie_antag || !zombie_antag.has_turned)
		return FALSE

	if(mind?.has_antag_datum(/datum/antagonist/zombie))
		return FALSE

	// Apply status effect with timer
	apply_status_effect(
		/datum/status_effect/zombie_infection, 
		wake_delay, 
		infection_type == "wound"
	)

	switch(infection_type)
		if("bite")
			to_chat(src, span_danger("一股不断扩散的寒意正渗入我的身体。我感觉糟透了……真的糟透了……"))
		if("wound")
			flash_fullscreen("redflash3")
			to_chat(src, span_danger("噢！好痛。我感觉糟透了……真的糟透了……"))

	return TRUE
