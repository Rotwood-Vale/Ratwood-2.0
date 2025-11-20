/datum/coven/baotha
	name = "Baotha"
	desc = "The Coven of the Lady of Debauchery, Eora's fallen twin - the last snow elf kept as a drug-addled prisoner for centuries until her captivity became her joy. Vampires of this coven don't seek to harm, but to help others feel the time of their lives through pleasure, addiction, and depravity. A single Baothan can destroy a settlement overnight with charm and moondust."
	power_type = /datum/coven_power/baotha
	max_level = 4
	icon_state = "baotha"
	is_god_coven = TRUE

/datum/coven_power/baotha

// Level 1 - Euphoric Touch
/datum/coven_power/baotha/euphoric_touch
	name = "Euphoric Touch"
	desc = "Touch a victim and flood them with overwhelming pleasure, rendering them helpless. The sweetest trap."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 2
	cooldown_length = 60 SECONDS
	vitae_cost = 30

/datum/coven_power/baotha/euphoric_touch/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!ishuman(target))
		to_chat(user, span_warning("I can only affect mortals."))
		return FALSE
	
	var/mob/living/carbon/human/victim = target
	user.visible_message(span_warning("[user] touches [victim] with an intoxicating caress!"))
	
	victim.Knockdown(40)
	victim.confused = max(victim.confused, 50)
	victim.drowsyness = max(victim.drowsyness, 40)
	victim.add_stress(/datum/stressevent/drunk)
	
	to_chat(victim, span_userdanger("Overwhelming euphoria floods through me!"))
	
	// Apply temporary high effect
	victim.apply_status_effect(/datum/status_effect/buff/drunk)
	
	playsound(get_turf(user), 'sound/misc/notice (2).ogg', 50, TRUE)
	return TRUE

// Level 2 - Addictive Presence
/datum/coven_power/baotha/addictive_presence
	name = "Addictive Presence"
	desc = "Emanate an aura of intoxication that leaves mortals craving your presence. They become addicted to you."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 120 SECONDS
	vitae_cost = 50
	var/presence_duration = 60 SECONDS

/datum/coven_power/baotha/addictive_presence/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("I become intoxicatingly alluring..."))
	user.visible_message(span_warning("An intoxicating aura surrounds [user]!"))
	
	ADD_TRAIT(user, TRAIT_DEPRAVED, "addictive_presence")
	user.set_light(4, 3, "#ff00aa")
	
	addtimer(CALLBACK(src, PROC_REF(remove_presence), user), presence_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/baotha/addictive_presence/process()
	if(!owner || owner.stat == DEAD)
		remove_presence(owner)
		return
	
	for(var/mob/living/L in view(4, owner))
		if(L == owner)
			continue
		L.confused = max(L.confused, 10)
		L.drowsyness = max(L.drowsyness, 5)
		to_chat(L, span_warning("I'm drawn to [owner]..."))

/datum/coven_power/baotha/addictive_presence/proc/remove_presence(mob/living/carbon/human/user)
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_DEPRAVED, "addictive_presence")
		user.set_light(0)
		to_chat(user, span_warning("The addictive presence fades..."))

// Level 3 - Heartbreak Curse
/datum/coven_power/baotha/heartbreak_curse
	name = "Heartbreak Curse"
	desc = "Inflict devastating emotional anguish upon a victim, breaking their will and leaving them in despair. Love's cruelest weapon."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 5
	cooldown_length = 90 SECONDS
	vitae_cost = 70

/datum/coven_power/baotha/heartbreak_curse/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!ishuman(target))
		to_chat(user, span_warning("I can only break mortal hearts."))
		return FALSE
	
	var/mob/living/carbon/human/victim = target
	user.visible_message(span_danger("[user] points at [victim] and they collapse in anguish!"))
	
	victim.Knockdown(60)
	victim.adjustBruteLoss(30)
	victim.adjustOxyLoss(20)
	
	to_chat(victim, span_userdanger("UNBEARABLE HEARTBREAK CONSUMES ME!"))
	
	playsound(get_turf(victim), 'sound/vo/female/gen/agony (1).ogg', 100, TRUE)
	return TRUE

// Level 4 - Ecstasy and Agony
/datum/coven_power/baotha/ecstasy_and_agony
	name = "Ecstasy and Agony"
	desc = "Become the avatar of hedonism, radiating pleasure and pain in equal measure. Those near you experience the highest highs and lowest lows."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	vitae_cost = 100
	var/ecstasy_duration = 45 SECONDS

/datum/coven_power/baotha/ecstasy_and_agony/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("I AM PLEASURE! I AM PAIN! I AM BAOTHA'S CHOSEN!"))
	user.visible_message(span_danger("[user] becomes wreathed in intoxicating energy!"))
	
	user.set_light(7, 5, "#ff00ff")
	ADD_TRAIT(user, TRAIT_DEPRAVED, "ecstasy_and_agony")
	ADD_TRAIT(user, TRAIT_CRACKHEAD, "ecstasy_and_agony")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "ecstasy_and_agony")
	
	addtimer(CALLBACK(src, PROC_REF(end_ecstasy), user), ecstasy_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/baotha/ecstasy_and_agony/process()
	if(!owner || owner.stat == DEAD)
		end_ecstasy(owner)
		return
	
	owner.adjustBruteLoss(-10)
	owner.adjustFireLoss(-10)
	
	for(var/mob/living/L in view(5, owner))
		if(L == owner)
			continue
		
		// Random pleasure or pain
		if(prob(50))
			L.adjustBruteLoss(-10)
			L.drowsyness = max(L.drowsyness, 10)
			to_chat(L, span_notice("Ecstasy washes over me..."))
		else
			L.adjustBruteLoss(15)
			to_chat(L, span_userdanger("Agony tears through me!"))
		
		L.confused = max(L.confused, 20)

/datum/coven_power/baotha/ecstasy_and_agony/proc/end_ecstasy(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_DEPRAVED, "ecstasy_and_agony")
		REMOVE_TRAIT(user, TRAIT_CRACKHEAD, "ecstasy_and_agony")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "ecstasy_and_agony")
		user.set_light(0)
		to_chat(user, span_warning("The ecstasy and agony fade..."))
