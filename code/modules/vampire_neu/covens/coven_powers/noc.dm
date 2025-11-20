/datum/coven/noc
	name = "Noc"
	desc = "The Coven of the Father of Secrets, Astrata's twin who compiled all knowledge into his vault at the Celestial Throne. Vampires of this coven are night-scholars who wield arcane secrets from Noc's endless library, their power waxing under moonlight."
	power_type = /datum/coven_power/noc
	max_level = 4
	icon_state = "noc"
	is_god_coven = TRUE

/datum/coven_power/noc

// Level 1 - Moonlit Veil
/datum/coven_power/noc/moonlit_veil
	name = "Moonlit Veil"
	desc = "Cloak yourself in moonlight, becoming partially invisible and harder to detect. Perfect for stalking prey under the night sky."
	level = 1
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 120 SECONDS
	var/veil_duration = 60 SECONDS

/datum/coven_power/noc/moonlit_veil/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	to_chat(user, span_notice("I wrap myself in the moon's pale light..."))
	user.alpha = 100
	
	addtimer(CALLBACK(src, PROC_REF(remove_veil), user), veil_duration)
	return TRUE

/datum/coven_power/noc/moonlit_veil/proc/remove_veil(mob/living/carbon/human/user)
	user.alpha = 255
	to_chat(user, span_warning("The moonlit veil dissipates..."))

// Level 2 - Scholar's Insight
/datum/coven_power/noc/scholars_insight
	name = "Scholar's Insight"
	desc = "Peer into the memories and knowledge of a victim, learning their secrets and skills temporarily. The wisdom of the night reveals all."
	level = 2
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 5
	cooldown_length = 180 SECONDS

/datum/coven_power/noc/scholars_insight/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!ishuman(target))
		to_chat(user, span_warning("I can only peer into the minds of mortals."))
		return FALSE
	
	var/mob/living/carbon/human/victim = target
	user.visible_message(span_warning("[user] stares deeply into [victim]'s eyes..."))
	
	// Learn their skills temporarily
	to_chat(user, span_notice("Knowledge floods into my mind from [victim]!"))
	to_chat(victim, span_userdanger("My mind feels violated!"))
	
	victim.confused = max(victim.confused, 20)
	
	addtimer(CALLBACK(src, PROC_REF(remove_insight), user), 120 SECONDS)
	return TRUE

/datum/coven_power/noc/scholars_insight/proc/remove_insight(mob/living/carbon/human/user)
	to_chat(user, span_warning("The borrowed knowledge fades from my mind..."))

// Level 3 - Lunar Eclipse
/datum/coven_power/noc/lunar_eclipse
	name = "Lunar Eclipse"
	desc = "Shroud an area in supernatural darkness, blinding all within and empowering your own vision. The moon devours the light."
	level = 3
	research_cost = 4
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 4
	cooldown_length = 90 SECONDS

/datum/coven_power/noc/lunar_eclipse/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	user.visible_message(span_danger("Darkness erupts from [user], consuming all light!"))
	playsound(get_turf(user), 'sound/magic/vlightning.ogg', 100, TRUE)
	
	var/turf/T = get_turf(target)
	new /obj/effect/temp_visual/dir_setting/ninja/shadow(T)
	
	for(var/mob/living/L in view(4, T))
		if(L == user)
			continue
		to_chat(L, span_userdanger("Absolute darkness swallows everything!"))
	
	ADD_TRAIT(user, TRAIT_DARKVISION, "lunar_eclipse")
	addtimer(CALLBACK(src, PROC_REF(remove_eclipse), user), 30 SECONDS)
	
	return TRUE

/datum/coven_power/noc/lunar_eclipse/proc/remove_eclipse(mob/living/carbon/human/user)
	REMOVE_TRAIT(user, TRAIT_DARKVISION, "lunar_eclipse")

// Level 4 - Arcane Apotheosis
/datum/coven_power/noc/arcane_apotheosis
	name = "Arcane Apotheosis"
	desc = "Become a living conduit of arcane power, casting devastating magical bolts at your enemies while knowledge flows through you like moonlight."
	level = 4
	research_cost = 5
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS
	var/night_duration = 50 SECONDS

/datum/coven_power/noc/arcane_apotheosis/activate(mob/living/carbon/human/user, atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(active)
		return FALSE
	
	active = TRUE
	to_chat(user, span_userdanger("The arcane mysteries flow through me!"))
	user.visible_message(span_danger("[user] crackles with eldritch energy!"))
	
	user.set_light(5, 3, "#8800ff")
	ADD_TRAIT(user, TRAIT_NIGHT_OWL, "arcane_apotheosis")
	
	addtimer(CALLBACK(src, PROC_REF(end_apotheosis), user), night_duration)
	START_PROCESSING(SSobj, src)
	return TRUE

/datum/coven_power/noc/arcane_apotheosis/process()
	var/mob/living/carbon/human/user = owner
	if(!user || user.stat == DEAD)
		end_apotheosis(user)
		return
	
	// Fire arcane bolts at nearby enemies
	var/list/targets = list()
	for(var/mob/living/L in view(7, user))
		if(L == user)
			continue
		targets += L
	
	if(targets.len)
		var/mob/living/victim = pick(targets)
		user.visible_message(span_danger("Arcane energy lances from [user] toward [victim]!"))
		victim.adjustFireLoss(15)

/datum/coven_power/noc/arcane_apotheosis/proc/end_apotheosis(mob/living/carbon/human/user)
	active = FALSE
	STOP_PROCESSING(SSobj, src)
	
	if(user)
		REMOVE_TRAIT(user, TRAIT_NIGHT_OWL, "arcane_apotheosis")
		user.set_light(0)
		to_chat(user, span_warning("The arcane apotheosis fades..."))
