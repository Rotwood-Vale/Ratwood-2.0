/datum/coven/necra
	name = "Necra"
	desc = "The Coven of the Undermaiden, who judges souls in the afterlife's Trials of the Forgotten. Vampires who channel Necra walk a grim irony - as undead, they've escaped her realm, yet wield her power over death and rebirth. They despise necromancy, seeing it as imprisoning souls that should pass to Necra's judgment."
	power_type = /datum/coven_power/necra
	max_level = 4
	icon_state = "necra"
	is_god_coven = TRUE

/datum/coven_power/necra

// Level 1 - Death's Embrace
/datum/coven_power/necra/deaths_embrace
	name = "Death's Embrace"
	desc = "Touch a living being and drain their life force, healing yourself while hastening their journey to Necra's realm."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 2
	cooldown_length = 60 SECONDS

/datum/coven_power/necra/deaths_embrace/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!isliving(target))
		to_chat(user, span_warning("I can only drain the living."))
		return FALSE
	
	var/mob/living/victim = target
	user.visible_message(span_danger("[user] touches [victim] with a deathly cold hand!"))
	
	var/drain = 30
	victim.adjustBruteLoss(drain)
	
	user.adjustBruteLoss(-drain/2)
	user.blood_volume = min(user.blood_volume + drain, BLOOD_VOLUME_MAXIMUM)
	
	to_chat(user, span_notice("I feel Necra's cold embrace strengthen me..."))
	to_chat(victim, span_userdanger("An icy chill spreads through my body!"))
	
	playsound(get_turf(user), 'sound/magic/churn.ogg', 50, TRUE)
	return TRUE

// Level 2 - Grave Whispers
/datum/coven_power/necra/grave_whispers
	name = "Grave Whispers"
	desc = "Commune with the restless dead in an area, learning secrets and potentially summoning minor spirits to aid you."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 5
	cooldown_length = 120 SECONDS

/datum/coven_power/necra/grave_whispers/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	user.visible_message(span_warning("[user] whispers to the dead..."))
	to_chat(user, span_notice("The voices of the departed echo in my mind..."))
	
	playsound(get_turf(user), 'sound/magic/churn.ogg', 100, TRUE)
	
	// Frighten nearby mortals
	for(var/mob/living/L in view(range, user))
		if(L == user)
			continue
		to_chat(L, span_userdanger("Ghostly whispers fill my ears!"))
	
	return TRUE

// Level 3 - Undying Resilience
/datum/coven_power/necra/undying_resilience
	name = "Undying Resilience"
	desc = "Channel Necra's domain over death to temporarily become nearly unkillable. Wounds close and broken bones mend as you refuse death's call."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 180 SECONDS
	var/resilience_duration = 30 SECONDS

/datum/coven_power/necra/undying_resilience/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_userdanger("Death itself rejects me!"))
	user.visible_message(span_danger("[user]'s wounds begin to close unnaturally!"))
	
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "undying_resilience")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "undying_resilience")
	ADD_TRAIT(user, TRAIT_NOSTINK, "undying_resilience")
	
	user.regenerate_limbs()
	user.adjustBruteLoss(-100)
	user.adjustFireLoss(-100)
	
	addtimer(CALLBACK(src, PROC_REF(remove_resilience), user), resilience_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/necra/undying_resilience/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		remove_resilience(user)
		return
	
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)

/datum/coven_power/necra/undying_resilience/proc/remove_resilience(mob/living/carbon/human/user)
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "undying_resilience")
		REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "undying_resilience")
		REMOVE_TRAIT(user, TRAIT_NOSTINK, "undying_resilience")
		to_chat(user, span_warning("My undying resilience fades..."))

// Level 4 - Reaper's Harvest
/datum/coven_power/necra/reapers_harvest
	name = "Reaper's Harvest"
	desc = "Become Necra's reaper, draining life from all nearby mortals to strengthen yourself. Death follows in your wake."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/harvest_duration = 50 SECONDS

/datum/coven_power/necra/reapers_harvest/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I AM THE HARBINGER OF DEATH!"))
	user.visible_message(span_danger("[user] becomes wreathed in necrotic energy!"))
	
	user.set_light(6, 4, "#00ff00")
	ADD_TRAIT(user, TRAIT_SOUL_EXAMINE, "reapers_harvest")
	
	addtimer(CALLBACK(src, PROC_REF(end_harvest), user), harvest_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/necra/reapers_harvest/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_harvest(user)
		return
	
	for(var/mob/living/L in view(4, user))
		if(L == user)
			continue
		
		L.adjustBruteLoss(8)
		to_chat(L, span_userdanger("My life force is being drained!"))
		
		user.adjustBruteLoss(-5)
		user.blood_volume = min(user.blood_volume + 10, BLOOD_VOLUME_MAXIMUM)

/datum/coven_power/necra/reapers_harvest/proc/end_harvest(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_SOUL_EXAMINE, "reapers_harvest")
		user.set_light(0)
		to_chat(user, span_warning("The reaper's harvest ends..."))
