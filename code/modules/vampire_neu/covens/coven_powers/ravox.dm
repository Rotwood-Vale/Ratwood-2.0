/datum/coven/ravox
	name = "Ravox"
	desc = "The Coven of Glorious Justice, following the god who challenged Astrata's tyranny and forced true law upon the world. Vampires of this coven are paradoxical warriors - monsters who hunt monsters, wielding Ravox's righteous fury to bring justice through blood and battle."
	power_type = /datum/coven_power/ravox
	max_level = 4
	icon_state = "ravox"
	is_god_coven = TRUE

/datum/coven_power/ravox

// Level 1 - Warrior's Fury
/datum/coven_power/ravox/warriors_fury
	name = "Warrior's Fury"
	desc = "Enter a battle trance that increases your damage and resistance to pain. Through strife, glory!"
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 90 SECONDS
	var/fury_duration = 45 SECONDS

/datum/coven_power/ravox/warriors_fury/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_userdanger("Battle fury surges through my veins!"))
	user.visible_message(span_danger("[user]'s eyes burn with martial fury!"))
	
	ADD_TRAIT(user, TRAIT_SHARPER_BLADES, "warriors_fury")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "warriors_fury")
	
	addtimer(CALLBACK(src, PROC_REF(remove_fury), user), fury_duration)
	return TRUE

/datum/coven_power/ravox/warriors_fury/proc/remove_fury(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_SHARPER_BLADES, "warriors_fury")
	REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "warriors_fury")
	to_chat(user, span_warning("The battle fury subsides..."))

// Level 2 - Challenge of Blood
/datum/coven_power/ravox/challenge_of_blood
	name = "Challenge of Blood"
	desc = "Issue a supernatural challenge to a foe, compelling them to face you in single combat. Cowards who flee are cursed."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 5
	cooldown_length = 120 SECONDS

/datum/coven_power/ravox/challenge_of_blood/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!isliving(target))
		to_chat(user, span_warning("I can only challenge the living."))
		return FALSE
	
	var/mob/living/victim = target
	user.visible_message(span_danger("[user] points at [victim] and roars a challenge!"))
	to_chat(victim, span_userdanger("[user] has challenged me to mortal combat!"))
	
	victim.faction |= "ravox_[user.real_name]"
	
	// Victim takes damage if they flee
	RegisterSignal(victim, COMSIG_MOVABLE_MOVED, PROC_REF(check_flee), user)
	addtimer(CALLBACK(src, PROC_REF(end_challenge), victim, user), 60 SECONDS)
	
	return TRUE

/datum/coven_power/ravox/challenge_of_blood/proc/check_flee(mob/living/victim, atom/oldloc, atom/newloc, mob/living/carbon/human/challenger)
	var/old_dist = get_dist(oldloc, challenger)
	var/new_dist = get_dist(newloc, challenger)
	
	if(new_dist > old_dist && new_dist > 3)
		to_chat(victim, span_userdanger("The gods punish my cowardice!"))
		victim.adjustBruteLoss(20)
		victim.Immobilize(30)

/datum/coven_power/ravox/challenge_of_blood/proc/end_challenge(mob/living/victim, mob/living/carbon/human/challenger)
	UnregisterSignal(victim, COMSIG_MOVABLE_MOVED)

// Level 3 - Glorious Persistence
/datum/coven_power/ravox/glorious_persistence
	name = "Glorious Persistence"
	desc = "The more you are wounded in battle, the stronger you become. Pain is temporary, glory is eternal."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 150 SECONDS
	var/persistence_duration = 60 SECONDS

/datum/coven_power/ravox/glorious_persistence/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_userdanger("Through persistence, GLORY!"))
	user.visible_message(span_danger("[user] refuses to fall!"))
	
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "glorious_persistence")
	ADD_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "glorious_persistence")
	
	addtimer(CALLBACK(src, PROC_REF(remove_persistence), user), persistence_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/ravox/glorious_persistence/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		remove_persistence(user)
		return
	
	// Get stronger as wounded
	var/health_percent = (user.health / user.maxHealth) * 100
	if(health_percent < 50)
		user.adjustBruteLoss(-5) // Slow heal
		
	if(health_percent < 25)
		// Very wounded = very strong
		ADD_TRAIT(user, TRAIT_SHARPER_BLADES, "glorious_persistence_bonus")
	else
		REMOVE_TRAIT(user, TRAIT_SHARPER_BLADES, "glorious_persistence_bonus")

/datum/coven_power/ravox/glorious_persistence/proc/remove_persistence(mob/living/carbon/human/user)
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "glorious_persistence")
		REMOVE_TRAIT(user, TRAIT_CRITICAL_RESISTANCE, "glorious_persistence")
		REMOVE_TRAIT(user, TRAIT_SHARPER_BLADES, "glorious_persistence_bonus")
		to_chat(user, span_warning("My glorious persistence fades..."))

// Level 4 - Avatar of War
/datum/coven_power/ravox/avatar_of_war
	name = "Avatar of War"
	desc = "Become Ravox's avatar of battle, radiating an aura of warfare that empowers allies and terrifies enemies. You become an unstoppable force of martial prowess."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/avatar_duration = 50 SECONDS

/datum/coven_power/ravox/avatar_of_war/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I AM WAR INCARNATE!"))
	user.visible_message(span_danger("[user] becomes wreathed in crimson battle-aura!"))
	
	user.set_light(7, 5, "#ff0000")
	ADD_TRAIT(user, TRAIT_SHARPER_BLADES, "avatar_of_war")
	ADD_TRAIT(user, TRAIT_JUSTICARSIGHT, "avatar_of_war")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "avatar_of_war")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "avatar_of_war")
	
	addtimer(CALLBACK(src, PROC_REF(end_avatar), user), avatar_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/ravox/avatar_of_war/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_avatar(user)
		return
	
	// Terrify nearby enemies
	for(var/mob/living/L in view(5, user))
		if(L == user)
			continue
		to_chat(L, span_warning("The avatar of war fills me with dread!"))

/datum/coven_power/ravox/avatar_of_war/proc/end_avatar(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_SHARPER_BLADES, "avatar_of_war")
		REMOVE_TRAIT(user, TRAIT_JUSTICARSIGHT, "avatar_of_war")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "avatar_of_war")
		REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "avatar_of_war")
		user.set_light(0)
		to_chat(user, span_warning("The avatar of war fades..."))
