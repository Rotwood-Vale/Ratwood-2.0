/datum/coven/graggar
	name = "Graggar"
	desc = "The Coven of the Gorebound Star, the fallen champion of Ravox who challenged his god and lost. Corrupted by a comet shard into a floating deformed head, Graggar drives all who gaze upon him into mind-crushing rage. Vampires of this coven are cannibalistic madmen who conquer, slaughter, and devour in his name - war for war's sake alone."
	power_type = /datum/coven_power/graggar
	max_level = 4
	icon_state = "graggar"
	is_god_coven = TRUE

/datum/coven_power/graggar

// Level 1 - Bloodrage
/datum/coven_power/graggar/bloodrage
	name = "Bloodrage"
	desc = "Enter a savage rage that increases damage and grants immunity to pain. The beast of conquest awakens."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 90 SECONDS
	var/rage_duration = 45 SECONDS

/datum/coven_power/graggar/bloodrage/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_userdanger("BLOODRAGE CONSUMES ME!"))
	user.visible_message(span_danger("[user] roars with savage fury!"))
	
	ADD_TRAIT(user, TRAIT_HORDE, "bloodrage")
	ADD_TRAIT(user, TRAIT_NOMOOD, "bloodrage")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "bloodrage")
	ADD_TRAIT(user, TRAIT_SHARPER_BLADES, "bloodrage")
	
	user.cmode_music = 'sound/music/combat_weird.ogg'
	
	addtimer(CALLBACK(src, PROC_REF(remove_rage), user), rage_duration)
	return TRUE

/datum/coven_power/graggar/bloodrage/proc/remove_rage(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_HORDE, "bloodrage")
	REMOVE_TRAIT(user, TRAIT_NOMOOD, "bloodrage")
	REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "bloodrage")
	REMOVE_TRAIT(user, TRAIT_SHARPER_BLADES, "bloodrage")
	to_chat(user, span_warning("The bloodrage subsides..."))

// Level 2 - Chain Breaker
/datum/coven_power/graggar/chain_breaker
	name = "Chain Breaker"
	desc = "Shatter restraints and bonds, freeing yourself and nearby allies. No chains can hold the conqueror."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 4
	cooldown_length = 120 SECONDS

/datum/coven_power/graggar/chain_breaker/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	user.visible_message(span_danger("[user] shatters all bonds!"))
	playsound(get_turf(user), 'sound/foley/breaksound.ogg', 100, TRUE)
	
	for(var/mob/living/L in view(range, user))
		L.SetKnockdown(0)
		L.SetStun(0)
		L.SetImmobilized(0)
		L.SetParalyzed(0)
		
		to_chat(L, span_notice("All restraints are shattered!"))
	
	return TRUE

// Level 3 - Feast of Conquest
/datum/coven_power/graggar/feast_of_conquest
	name = "Feast of Conquest"
	desc = "Consume the organs of fallen enemies to gain immense strength and vitality. The ultimate trophy of victory."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 7
	cooldown_length = 60 SECONDS

/datum/coven_power/graggar/feast_of_conquest/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!ishuman(target))
		to_chat(user, span_warning("I can only feast upon mortal flesh."))
		return FALSE
	
	var/mob/living/carbon/human/victim = target
	if(victim.stat != DEAD)
		to_chat(user, span_warning("They must be dead for me to feast!"))
		return FALSE
	
	user.visible_message(span_danger("[user] tears into [victim] and devours their organs!"))
	
	user.adjustBruteLoss(-60)
	user.adjustFireLoss(-60)
	user.adjustStaminaLoss(-100)
	user.blood_volume = BLOOD_VOLUME_MAXIMUM
	
	ADD_TRAIT(user, TRAIT_ORGAN_EATER, "feast_of_conquest")
	ADD_TRAIT(user, TRAIT_HORDE, "feast_of_conquest_buff")
	
	to_chat(user, span_userdanger("The feast empowers me!"))
	playsound(get_turf(user), 'sound/misc/eat.ogg', 100, TRUE)
	
	addtimer(CALLBACK(src, PROC_REF(remove_feast_buff), user), 120 SECONDS)
	
	// Destroy the body
	victim.gib()
	
	return TRUE

/datum/coven_power/graggar/feast_of_conquest/proc/remove_feast_buff(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_HORDE, "feast_of_conquest_buff")

// Level 4 - God of War
/datum/coven_power/graggar/god_of_war
	name = "God of War"
	desc = "Ascend as Graggar's avatar of conquest, becoming an unstoppable force of destruction that grows stronger with each kill."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/king_duration = 50 SECONDS
	var/kill_count = 0

/datum/coven_power/graggar/god_of_war/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	kill_count = 0
	to_chat(user, span_userdanger("I AM THE GOD OF WAR! BLOOD FOR GRAGGAR!"))
	user.visible_message(span_danger("[user] becomes wreathed in crimson war-fury!"))
	
	user.set_light(8, 6, "#aa0000")
	ADD_TRAIT(user, TRAIT_HORDE, "god_of_war")
	ADD_TRAIT(user, TRAIT_ORGAN_EATER, "god_of_war")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "god_of_war")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "god_of_war")
	ADD_TRAIT(user, TRAIT_NOMOOD, "god_of_war")
	ADD_TRAIT(user, TRAIT_SHARPER_BLADES, "god_of_war")
	
	RegisterSignal(user, COMSIG_LIVING_DEATH, PROC_REF(on_kill))
	
	addtimer(CALLBACK(src, PROC_REF(end_war), user), king_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/graggar/god_of_war/proc/on_kill(mob/living/carbon/human/user, mob/living/victim)
	kill_count++
	to_chat(user, span_userdanger("BLOOD FOR GRAGGAR! [kill_count] SLAIN!"))
	user.adjustBruteLoss(-40)
	user.blood_volume = min(user.blood_volume + 50, BLOOD_VOLUME_MAXIMUM)

/datum/coven_power/graggar/god_of_war/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_war(user)
		return
	
	user.adjustBruteLoss(-8)
	user.adjustFireLoss(-8)
	
	// Terrify nearby enemies
	for(var/mob/living/L in view(6, user))
		if(L == user)
			continue
		to_chat(L, span_warning("The god of war fills me with terror!"))

/datum/coven_power/graggar/god_of_war/proc/end_war(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		UnregisterSignal(user, COMSIG_LIVING_DEATH)
		REMOVE_TRAIT(user, TRAIT_HORDE, "god_of_war")
		REMOVE_TRAIT(user, TRAIT_ORGAN_EATER, "god_of_war")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "god_of_war")
		REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "god_of_war")
		REMOVE_TRAIT(user, TRAIT_NOMOOD, "god_of_war")
		REMOVE_TRAIT(user, TRAIT_SHARPER_BLADES, "god_of_war")
		user.set_light(0)
		to_chat(user, span_warning("The god of war fades... [kill_count] enemies fell before me."))
