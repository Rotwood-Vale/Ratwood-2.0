/datum/coven/abyssor
	name = "Abyssor"
	desc = "The Coven of the Pure Tide, the eternally sleeping god whose dreams calm the oceans and birth the city beneath the waves. Vampires of this coven walk in Abyssor's dreams, channeling the serene depths and spawning dream-fiends from their warped visions. They seek either purity through cleansing rituals or the awakening of the sleeping god."
	power_type = /datum/coven_power/abyssor
	max_level = 4
	icon_state = "abyssor"
	is_god_coven = TRUE

/datum/coven_power/abyssor

// Level 1 - Tidal Grasp
/datum/coven_power/abyssor/tidal_grasp
	name = "Tidal Grasp"
	desc = "Summon water to drag and drown your victims, pulling them helplessly as the tide does. The depths call to all."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 5
	cooldown_length = 60 SECONDS

/datum/coven_power/abyssor/tidal_grasp/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!isliving(target))
		to_chat(user, span_warning("I can only grasp the living."))
		return FALSE
	
	var/mob/living/victim = target
	user.visible_message(span_danger("Water surges around [victim], dragging them!"))
	
	victim.throw_at(get_step_towards(victim, user), 5, 2)
	victim.Knockdown(30)
	victim.adjustOxyLoss(20)
	to_chat(victim, span_userdanger("The tide drags me under!"))
	
	playsound(get_turf(victim), 'sound/magic/churn.ogg', 100, TRUE)
	return TRUE

// Level 2 - Dreamer's Veil
/datum/coven_power/abyssor/dreamers_veil
	name = "Dreamer's Veil"
	desc = "Cloud the minds of nearby mortals with visions from the deep, confusing and disorienting them. Reality becomes as fluid as water."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 3
	cooldown_length = 90 SECONDS

/datum/coven_power/abyssor/dreamers_veil/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	user.visible_message(span_warning("Reality warps around [user]!"))
	playsound(get_turf(user), 'sound/magic/timestop.ogg', 100, TRUE)
	
	for(var/mob/living/L in view(range, user))
		if(L == user)
			continue
		L.confused = max(L.confused, 60)
		L.drowsyness = max(L.drowsyness, 30)
		to_chat(L, span_userdanger("Nightmarish visions cloud my mind!"))
	
	return TRUE

// Level 3 - Abyssal Resilience
/datum/coven_power/abyssor/abyssal_resilience
	name = "Abyssal Resilience"
	desc = "Adopt the ancient endurance of Abyssor, becoming as unstoppable as the tide and as eternal as the sea."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 150 SECONDS
	var/resilience_duration = 60 SECONDS

/datum/coven_power/abyssor/abyssal_resilience/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("The ancient depths strengthen me..."))
	user.visible_message(span_warning("[user]'s form becomes fluid and resilient!"))
	
	ADD_TRAIT(user, TRAIT_ABYSSOR_SWIM, "abyssal_resilience")
	ADD_TRAIT(user, TRAIT_SEA_DRINKER, "abyssal_resilience")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "abyssal_resilience")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "abyssal_resilience")
	
	addtimer(CALLBACK(src, PROC_REF(remove_resilience), user), resilience_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/abyssor/abyssal_resilience/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		STOP_PROCESSING(SSobj, src)
		return
	
	user.adjustBruteLoss(-8)
	user.adjustFireLoss(-8)
	user.adjustOxyLoss(-20)

/datum/coven_power/abyssor/abyssal_resilience/proc/remove_resilience(mob/living/carbon/human/user)
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_ABYSSOR_SWIM, "abyssal_resilience")
		REMOVE_TRAIT(user, TRAIT_SEA_DRINKER, "abyssal_resilience")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "abyssal_resilience")
		REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "abyssal_resilience")
		to_chat(user, span_warning("The abyssal resilience fades..."))

// Level 4 - Primordial Awakening
/datum/coven_power/abyssor/primordial_awakening
	name = "Primordial Awakening"
	desc = "Awaken as Abyssor's avatar, commanding the primal waters and unleashing devastating tidal forces upon your enemies."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/awakening_duration = 50 SECONDS

/datum/coven_power/abyssor/primordial_awakening/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("THE DEPTHS AWAKEN WITHIN ME!"))
	user.visible_message(span_danger("[user] becomes wreathed in primordial waters!"))
	
	user.set_light(7, 5, "#0044ff")
	ADD_TRAIT(user, TRAIT_ABYSSOR_SWIM, "primordial_awakening")
	ADD_TRAIT(user, TRAIT_SEA_DRINKER, "primordial_awakening")
	ADD_TRAIT(user, TRAIT_NOSOFTCRIT, "primordial_awakening")
	ADD_TRAIT(user, TRAIT_NOHARDCRIT, "primordial_awakening")
	
	addtimer(CALLBACK(src, PROC_REF(end_awakening), user), awakening_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/abyssor/primordial_awakening/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_awakening(user)
		return
	
	user.adjustBruteLoss(-10)
	user.adjustFireLoss(-10)
	user.adjustOxyLoss(-30)
	
	for(var/mob/living/L in view(5, user))
		if(L == user)
			continue
		L.adjustOxyLoss(10)
		L.Knockdown(10)
		to_chat(L, span_userdanger("The primordial tide overwhelms me!"))

/datum/coven_power/abyssor/primordial_awakening/proc/end_awakening(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_ABYSSOR_SWIM, "primordial_awakening")
		REMOVE_TRAIT(user, TRAIT_SEA_DRINKER, "primordial_awakening")
		REMOVE_TRAIT(user, TRAIT_NOSOFTCRIT, "primordial_awakening")
		REMOVE_TRAIT(user, TRAIT_NOHARDCRIT, "primordial_awakening")
		user.set_light(0)
		to_chat(user, span_warning("The primordial awakening subsides..."))
