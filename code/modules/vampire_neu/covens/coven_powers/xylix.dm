/datum/coven/xylix
	name = "Xylix"
	desc = "The Coven of the Trickster, the mad god who stole the knowledge of Fate from Noc's vault and created the Fluvians by shattering a moth across the world. Vampires of this coven share Xylix's one true tenet: absolute freedom. They are chaotic jesters who twist fate, despise slavery, and play divine pranks with reality itself."
	power_type = /datum/coven_power/xylix
	max_level = 4
	icon_state = "xylix"
	is_god_coven = TRUE

/datum/coven_power/xylix

// Level 1 - Jester's Gambit
/datum/coven_power/xylix/jesters_gambit
	name = "Jester's Gambit"
	desc = "Twist fate itself, causing a random effect that could benefit you or your target. Xylix loves a good game!"
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 3
	cooldown_length = 45 SECONDS

/datum/coven_power/xylix/jesters_gambit/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	user.visible_message(span_warning("[user] snaps their fingers and reality shifts!"))
	playsound(get_turf(user), 'sound/magic/swap.ogg', 50, TRUE)
	
	var/effect = rand(1, 5)
	switch(effect)
		if(1) // Heal target
			if(isliving(target))
				var/mob/living/L = target
				L.adjustBruteLoss(-30)
				to_chat(L, span_notice("Fortune smiles upon me!"))
		if(2) // Harm target
			if(isliving(target))
				var/mob/living/L = target
				L.adjustBruteLoss(30)
				to_chat(L, span_userdanger("Misfortune strikes me!"))
		if(3) // Teleport target
			if(isliving(target))
				var/mob/living/L = target
				var/turf/T = find_safe_turf()
				if(T)
					L.forceMove(T)
					to_chat(L, span_warning("I'm elsewhere!"))
		if(4) // Confuse target
			if(isliving(target))
				var/mob/living/L = target
				L.confused = max(L.confused, 40)
		if(6) // Spawn coins
			for(var/i in 1 to 5)
				new /obj/item/roguecoin/gold(get_turf(target))
			to_chat(user, span_notice("Fortune rains down!"))
	
	return TRUE

// Level 2 - Mocking Illusion
/datum/coven_power/xylix/mocking_illusion
	name = "Mocking Illusion"
	desc = "Create illusory duplicates of yourself that confuse and distract enemies. The Laughing God's favorite trick."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 90 SECONDS

/datum/coven_power/xylix/mocking_illusion/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	user.visible_message(span_warning("[user] multiplies before your eyes!"))
	to_chat(user, span_notice("Illusions dance around me!"))
	
	playsound(get_turf(user), 'sound/magic/swap.ogg', 100, TRUE)
	return TRUE

// Level 3 - Fortune's Favor
/datum/coven_power/xylix/fortunes_favor
	name = "Fortune's Favor"
	desc = "Bask in Xylix's luck, granting yourself uncanny dodging ability and critical strikes. When fortune favors, none can stand against you."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 120 SECONDS
	var/favor_duration = 45 SECONDS

/datum/coven_power/xylix/fortunes_favor/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("Fortune favors the bold!"))
	user.visible_message(span_warning("An aura of luck surrounds [user]!"))
	
	ADD_TRAIT(user, TRAIT_XYLIX, "fortunes_favor")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "fortunes_favor")
	
	addtimer(CALLBACK(src, PROC_REF(remove_favor), user), favor_duration)
	return TRUE

/datum/coven_power/xylix/fortunes_favor/proc/remove_favor(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_XYLIX, "fortunes_favor")
	REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "fortunes_favor")
	to_chat(user, span_warning("Fortune's favor fades..."))

// Level 4 - Chaos Incarnate
/datum/coven_power/xylix/chaos_incarnate
	name = "Chaos Incarnate"
	desc = "Become the embodiment of chaos itself, warping reality around you with unpredictable and devastating effects. The ultimate jest!"
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/chaos_duration = 50 SECONDS

/datum/coven_power/xylix/chaos_incarnate/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I AM THE JEST! I AM CHAOS!"))
	user.visible_message(span_danger("Reality warps chaotically around [user]!"))
	
	user.set_light(7, 5, "#ff00ff")
	ADD_TRAIT(user, TRAIT_XYLIX, "chaos_incarnate")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "chaos_incarnate")
	
	addtimer(CALLBACK(src, PROC_REF(end_chaos), user), chaos_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/xylix/chaos_incarnate/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_chaos(user)
		return
	
	// Random chaotic effects
	for(var/mob/living/L in view(5, user))
		if(L == user)
			continue
		
		var/effect = rand(1, 5)
		switch(effect)
			if(1)
				L.adjustBruteLoss(15)
			if(2)
				L.Knockdown(20)
			if(3)
				L.confused = max(L.confused, 30)
			if(4)
				L.adjustFireLoss(10)
			if(5)
				L.adjustOxyLoss(10)
		
		to_chat(L, span_userdanger("Chaos assaults me!"))

/datum/coven_power/xylix/chaos_incarnate/proc/end_chaos(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_XYLIX, "chaos_incarnate")
		REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "chaos_incarnate")
		user.set_light(0)
		to_chat(user, span_warning("The chaos subsides..."))
