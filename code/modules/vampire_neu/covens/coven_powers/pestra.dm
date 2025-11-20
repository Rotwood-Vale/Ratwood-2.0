/datum/coven/pestra
	name = "Pestra"
	desc = "The Coven of the Panacea, the corvid Aasimar who brought medicine to mortals yet became obsessed with decay and disease. Vampires of this coven share her disturbing fascination - studying the Rot, consuming rotted flesh, and wielding plague as both weapon and path to understanding. They are healers and plague-bearers in one."
	power_type = /datum/coven_power/pestra
	max_level = 4
	icon_state = "pestra"
	is_god_coven = TRUE

/datum/coven_power/pestra

// Level 1 - Plague Touch
/datum/coven_power/pestra/plague_touch
	name = "Plague Touch"
	desc = "Infect a victim with a wasting disease that weakens them over time. Pestra's blessing and curse intertwined."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 2
	cooldown_length = 60 SECONDS

/datum/coven_power/pestra/plague_touch/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!ishuman(target))
		to_chat(user, span_warning("I can only inflict disease upon mortals."))
		return FALSE
	
	var/mob/living/carbon/human/victim = target
	user.visible_message(span_danger("[user] touches [victim] with a diseased hand!"))
	
	victim.adjustToxLoss(20)
	to_chat(victim, span_userdanger("I feel terribly ill!"))
	return TRUE

// Level 2 - Pestilent Aura
/datum/coven_power/pestra/pestilent_aura
	name = "Pestilent Aura"
	desc = "Emanate an aura of disease that sickens all nearby mortals while slowly healing yourself. Decay sustains you."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 120 SECONDS
	var/aura_duration = 45 SECONDS

/datum/coven_power/pestra/pestilent_aura/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("I radiate Pestra's blessing..."))
	user.visible_message(span_warning("A miasmic aura surrounds [user]!"))
	
	ADD_TRAIT(user, TRAIT_ROT_EATER, "pestilent_aura")
	user.set_light(4, 3, "#00aa00")
	
	addtimer(CALLBACK(src, PROC_REF(remove_aura), user), aura_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/pestra/pestilent_aura/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		remove_aura(user)
		return
	
	for(var/mob/living/L in view(3, user))
		if(L == user)
			continue
		L.adjustToxLoss(3)
		to_chat(L, span_warning("The pestilent aura makes me sick..."))
	
	user.adjustBruteLoss(-5)

/datum/coven_power/pestra/pestilent_aura/proc/remove_aura(mob/living/carbon/human/user)
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_ROT_EATER, "pestilent_aura")
		user.set_light(0)
		to_chat(user, span_warning("The pestilent aura fades..."))

// Level 3 - Flesh Knitting
/datum/coven_power/pestra/flesh_knitting
	name = "Flesh Knitting"
	desc = "Channel Pestra's medicinal arts to rapidly heal wounds and even reattach severed limbs. From decay comes renewal."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 2
	cooldown_length = 90 SECONDS

/datum/coven_power/pestra/flesh_knitting/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!ishuman(target))
		to_chat(user, span_warning("I can only mend mortal flesh."))
		return FALSE
	
	var/mob/living/carbon/human/patient = target
	user.visible_message(span_notice("[user] channels healing energy into [patient]!"))
	
	patient.adjustBruteLoss(-60)
	patient.adjustFireLoss(-60)
	patient.adjustToxLoss(-30)
	patient.regenerate_limbs()
	patient.regenerate_organs()
	
	to_chat(patient, span_notice("My wounds close with unnatural speed!"))
	playsound(get_turf(patient), 'sound/magic/churn.ogg', 100, TRUE)
	
	return TRUE

// Level 4 - Master of Plague
/datum/coven_power/pestra/master_of_plague
	name = "Master of Plague"
	desc = "Become Pestra's plague bearer, spreading disease while being immune to all ailments yourself. You are both cure and contagion."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/plague_duration = 50 SECONDS

/datum/coven_power/pestra/master_of_plague/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I AM PLAGUE! I AM CURE!"))
	user.visible_message(span_danger("[user] becomes wreathed in pestilent energy!"))
	
	user.set_light(7, 5, "#00ff00")
	ADD_TRAIT(user, TRAIT_ROT_EATER, "master_of_plague")
	ADD_TRAIT(user, TRAIT_EMPATH, "master_of_plague")
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, "master_of_plague")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "master_of_plague")
	
	addtimer(CALLBACK(src, PROC_REF(end_plague), user), plague_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/pestra/master_of_plague/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_plague(user)
		return
	
	user.adjustBruteLoss(-8)
	user.adjustFireLoss(-8)
	user.adjustToxLoss(-8)
	
	for(var/mob/living/L in view(5, user))
		if(L == user)
			continue
		L.adjustToxLoss(8)
		to_chat(L, span_userdanger("The plague master's presence withers me!"))

/datum/coven_power/pestra/master_of_plague/proc/end_plague(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_ROT_EATER, "master_of_plague")
		REMOVE_TRAIT(user, TRAIT_EMPATH, "master_of_plague")
		REMOVE_TRAIT(user, TRAIT_TOXIMMUNE, "master_of_plague")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "master_of_plague")
		user.set_light(0)
		to_chat(user, span_warning("The plague mastery fades..."))
