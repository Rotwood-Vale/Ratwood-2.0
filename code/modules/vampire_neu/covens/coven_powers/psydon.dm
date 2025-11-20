/datum/coven/psydon
	name = "Psydon"
	desc = "The Coven of the One, the creator-god who arrived on a silver comet and shaped all life on Grimoria. Struck down by Zizo 200 years ago, his faithful refuse to accept his death, believing he merely slumbers. Vampires of this coven walk the ultimate paradox - undead channeling the creator of life itself, wielding his compassion and perseverance against the darkness."
	power_type = /datum/coven_power/psydon
	max_level = 4
	icon_state = "psydon"
	is_god_coven = TRUE

/datum/coven_power/psydon

// Level 1 - Life's Paradox
/datum/coven_power/psydon/lifes_paradox
	name = "Life's Paradox"
	desc = "Channel Psydon's creative force to heal yourself and allies, a vampire wielding the power of life itself."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 60 SECONDS

/datum/coven_power/psydon/lifes_paradox/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!isliving(target))
		to_chat(user, span_warning("I can only heal the living and unliving."))
		return FALSE
	
	var/mob/living/victim = target
	user.visible_message(span_notice("[user] channels golden life energy into [victim]!"))
	
	victim.adjustBruteLoss(-50)
	victim.adjustFireLoss(-50)
	victim.adjustOxyLoss(-50)
	victim.adjustToxLoss(-25)
	
	to_chat(victim, span_notice("Life energy flows through me!"))
	playsound(get_turf(victim), 'sound/magic/churn.ogg', 100, TRUE)
	
	return TRUE

// Level 2 - Compassion's Shield
/datum/coven_power/psydon/compassions_shield
	name = "Compassion's Shield"
	desc = "Protect yourself and allies with Psydon's compassion, granting resistance to harm and stress. The Old God's mercy endures."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 5
	cooldown_length = 120 SECONDS

/datum/coven_power/psydon/compassions_shield/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	user.visible_message(span_notice("A golden shield erupts around [user]!"))
	playsound(get_turf(user), 'sound/magic/churn.ogg', 100, TRUE)
	
	for(var/mob/living/L in view(range, user))
		ADD_TRAIT(L, TRAIT_CRITICAL_RESISTANCE, "compassions_shield")
		ADD_TRAIT(L, TRAIT_PSYDONIAN_GRIT, "compassions_shield")
		to_chat(L, span_notice("Psydon's compassion shields me!"))
		
		addtimer(CALLBACK(src, PROC_REF(remove_shield), L), 45 SECONDS)
	
	return TRUE

/datum/coven_power/psydon/compassions_shield/proc/remove_shield(mob/living/L)
	REMOVE_TRAIT(L, TRAIT_CRITICAL_RESISTANCE, "compassions_shield")
	REMOVE_TRAIT(L, TRAIT_PSYDONIAN_GRIT, "compassions_shield")
	to_chat(L, span_warning("The compassionate shield fades..."))

// Level 3 - Perseverance
/datum/coven_power/psydon/perseverance
	name = "Perseverance"
	desc = "Channel Psydon's enduring will, refusing to fall no matter the wounds. The Old God who was struck down yet endures."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 150 SECONDS
	var/perseverance_duration = 60 SECONDS

/datum/coven_power/psydon/perseverance/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_userdanger("I SHALL ENDURE!"))
	user.visible_message(span_warning("[user] becomes wreathed in golden determination!"))
	
	ADD_TRAIT(user, TRAIT_PSYDONIAN_GRIT, "perseverance")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "perseverance")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "perseverance")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "perseverance")
	
	addtimer(CALLBACK(src, PROC_REF(remove_perseverance), user), perseverance_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/psydon/perseverance/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		remove_perseverance(user)
		return
	
	user.adjustBruteLoss(-15)
	user.adjustFireLoss(-15)
	user.adjustOxyLoss(-30)

/datum/coven_power/psydon/perseverance/proc/remove_perseverance(mob/living/carbon/human/user)
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_PSYDONIAN_GRIT, "perseverance")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "perseverance")
		REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "perseverance")
		REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "perseverance")
		to_chat(user, span_warning("My perseverance wanes..."))

// Level 4 - Creator's Apotheosis
/datum/coven_power/psydon/creators_apotheosis
	name = "Creator's Apotheosis"
	desc = "Become one with Psydon's creative essence, radiating life energy that heals allies and harms those who oppose creation. The ultimate paradox - undeath channeling life."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/apotheosis_duration = 50 SECONDS

/datum/coven_power/psydon/creators_apotheosis/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I AM CREATION! I AM LIFE! PSYDON ENDURES THROUGH ME!"))
	user.visible_message(span_danger("[user] becomes wreathed in radiant golden energy!"))
	
	user.set_light(8, 6, "#ffdd00")
	ADD_TRAIT(user, TRAIT_PSYDONIAN_GRIT, "creators_apotheosis")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "creators_apotheosis")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "creators_apotheosis")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "creators_apotheosis")
	
	addtimer(CALLBACK(src, PROC_REF(end_apotheosis), user), apotheosis_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/psydon/creators_apotheosis/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_apotheosis(user)
		return
	
	user.adjustBruteLoss(-15)
	user.adjustFireLoss(-15)
	user.adjustOxyLoss(-30)
	user.adjustToxLoss(-15)
	
	for(var/mob/living/L in view(6, user))
		if(L == user)
			continue
		
		// Heal allies, harm enemies
		if(L.faction == user.faction)
			L.adjustBruteLoss(-10)
			L.adjustFireLoss(-10)
			to_chat(L, span_notice("The creator's energy heals me!"))
		else
			L.adjustBruteLoss(10)
			to_chat(L, span_userdanger("The creator's power burns me!"))

/datum/coven_power/psydon/creators_apotheosis/proc/end_apotheosis(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_PSYDONIAN_GRIT, "creators_apotheosis")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "creators_apotheosis")
		REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "creators_apotheosis")
		REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "creators_apotheosis")
		user.set_light(0)
		to_chat(user, span_warning("The creator's apotheosis fades..."))
