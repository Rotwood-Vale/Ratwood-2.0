/datum/coven/matthios
	name = "Matthios"
	desc = "The Coven of the Many-Faced, an Ascendant with no true form - merry highwayman, beggar god, and dragon-father to kobolds all at once. Vampires of this coven prove anyone with faith can manifest divinity. They are thieves and revolutionaries who rob from nobles, murder the wealthy, and seek true freedom for the downtrodden."
	power_type = /datum/coven_power/matthios
	max_level = 4
	icon_state = "matthios"
	is_god_coven = TRUE

/datum/coven_power/matthios

// Level 1 - Coin's Curse
/datum/coven_power/matthios/coins_curse
	name = "Coin's Curse"
	desc = "Curse a victim's wealth, causing their gold to burn them and their fortune to turn to ash. The price of greed."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 2
	cooldown_length = 60 SECONDS

/datum/coven_power/matthios/coins_curse/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!ishuman(target))
		to_chat(user, span_warning("I can only curse mortals."))
		return FALSE
	
	var/mob/living/carbon/human/victim = target
	user.visible_message(span_danger("[user] curses [victim]'s wealth!"))
	
	var/mammon_found = 0
	for(var/obj/item/roguecoin/C in victim.contents)
		mammon_found += C.get_real_price()
		qdel(C)
	
	if(mammon_found > 0)
		victim.adjustFireLoss(mammon_found / 10)
		to_chat(victim, span_userdanger("My wealth burns me!"))
		playsound(get_turf(victim), 'sound/items/firelight.ogg', 50, TRUE)
	else
		to_chat(user, span_warning("They have no wealth to curse!"))
	
	return TRUE

// Level 2 - Thief's Fortune
/datum/coven_power/matthios/thiefs_fortune
	name = "Thief's Fortune"
	desc = "Steal the vitality and strength of your victims, redistributing their life force to yourself. From the unworthy to the deserving."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 3
	cooldown_length = 90 SECONDS

/datum/coven_power/matthios/thiefs_fortune/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!isliving(target))
		to_chat(user, span_warning("I can only steal from the living."))
		return FALSE
	
	var/mob/living/victim = target
	user.visible_message(span_danger("[user] drains [victim]'s vitality!"))
	
	var/drain = 40
	victim.adjustBruteLoss(drain)
	victim.adjustStaminaLoss(50)
	to_chat(victim, span_userdanger("My strength is stolen!"))
	
	user.adjustBruteLoss(-drain)
	user.adjustStaminaLoss(-50)
	user.blood_volume = min(user.blood_volume + drain, BLOOD_VOLUME_MAXIMUM)
	to_chat(user, span_notice("Their vitality flows into me!"))
	
	playsound(get_turf(user), 'sound/magic/churn.ogg', 50, TRUE)
	return TRUE

// Level 3 - Alchemical Transmutation
/datum/coven_power/matthios/alchemical_transmutation
	name = "Alchemical Transmutation"
	desc = "Transform your blood into alchemical potency, granting enhanced regeneration and resistance to toxins. The fire-stealer's gift."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 120 SECONDS
	var/transmutation_duration = 60 SECONDS

/datum/coven_power/matthios/alchemical_transmutation/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("My blood becomes alchemical gold!"))
	user.visible_message(span_warning("[user]'s veins glow with golden light!"))
	
	ADD_TRAIT(user, TRAIT_COMMIE, "alchemical_transmutation")
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, "alchemical_transmutation")
	ADD_TRAIT(user, TRAIT_SEEPRICES_SHITTY, "alchemical_transmutation")
	
	addtimer(CALLBACK(src, PROC_REF(remove_transmutation), user), transmutation_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/matthios/alchemical_transmutation/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		remove_transmutation(user)
		return
	
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)
	user.adjustToxLoss(-10)

/datum/coven_power/matthios/alchemical_transmutation/proc/remove_transmutation(mob/living/carbon/human/user)
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_COMMIE, "alchemical_transmutation")
		REMOVE_TRAIT(user, TRAIT_TOXIMMUNE, "alchemical_transmutation")
		REMOVE_TRAIT(user, TRAIT_SEEPRICES_SHITTY, "alchemical_transmutation")
		to_chat(user, span_warning("The alchemical transmutation fades..."))

// Level 4 - Master of Exchange
/datum/coven_power/matthios/master_of_exchange
	name = "Master of Exchange"
	desc = "Become the avatar of exchange, redistributing health, wealth, and fortune itself. What is theirs becomes yours."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/smith_duration = 50 SECONDS

/datum/coven_power/matthios/master_of_exchange/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I AM THE EXCHANGE! ALL WEALTH FLOWS THROUGH ME!"))
	user.visible_message(span_danger("[user] becomes wreathed in golden energy!"))
	
	user.set_light(7, 5, "#ffaa00")
	ADD_TRAIT(user, TRAIT_COMMIE, "master_of_exchange")
	ADD_TRAIT(user, TRAIT_MATTHIOS_EYES, "master_of_exchange")
	ADD_TRAIT(user, TRAIT_SEEPRICES_SHITTY, "master_of_exchange")
	ADD_TRAIT(user, TRAIT_TOXIMMUNE, "master_of_exchange")
	
	addtimer(CALLBACK(src, PROC_REF(end_exchange), user), smith_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/matthios/master_of_exchange/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_exchange(user)
		return
	
	user.adjustBruteLoss(-12)
	user.adjustFireLoss(-12)
	user.adjustToxLoss(-12)
	
	for(var/mob/living/L in view(5, user))
		if(L == user)
			continue
		
		var/drain = 10
		L.adjustBruteLoss(drain)
		L.adjustStaminaLoss(20)
		to_chat(L, span_userdanger("The master of exchange drains me!"))
		
		user.blood_volume = min(user.blood_volume + drain, BLOOD_VOLUME_MAXIMUM)

/datum/coven_power/matthios/master_of_exchange/proc/end_exchange(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_COMMIE, "master_of_exchange")
		REMOVE_TRAIT(user, TRAIT_MATTHIOS_EYES, "master_of_exchange")
		REMOVE_TRAIT(user, TRAIT_SEEPRICES_SHITTY, "master_of_exchange")
		REMOVE_TRAIT(user, TRAIT_TOXIMMUNE, "master_of_exchange")
		user.set_light(0)
		to_chat(user, span_warning("The master of exchange fades..."))
