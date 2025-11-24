/datum/coven/old_god_coven
	name = "Psydonian Legacy"
	desc = "The Purist vampires carry PSYDON's corrupted Argentum in their veins - the dying god's essence transformed into Sanguine Noctis. Some Purists reject the Ten's pity and the Inhumen's promises, seeking instead to commune with the source: the slumbering All-Father Himself. Through the divine blood that sustains them, these vampires tap into PSYDON's original creative power, unburdened by pantheon politics."
	icon_state = "daimonion"
	power_type = /datum/coven_power/old_god
	is_god_coven = TRUE

/datum/coven_power/old_god
	name = "Old God Coven"
	desc = "Channel the power of Psydon, the Allfather."

/datum/coven_power/old_god/ancient_touch
	name = "Ancient Touch"
	desc = "Channel Psydon's ancient power to heal yourself, but suffer exhaustion as payment."
	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 90 SECONDS

/datum/coven_power/old_god/ancient_touch/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	// Apply self-heal miracle AND buff
	owner.apply_status_effect(/datum/status_effect/buff/healing/long_healing, 2, FALSE)
	owner.apply_status_effect(/datum/status_effect/buff/ancient_touch)
	
	owner.visible_message(span_notice("[owner] channels ancient power..."))
	to_chat(owner, span_warning("The weight of aeons bears down on me!"))
	owner.stamina_add(75)
	
	playsound(get_turf(owner), 'sound/magic/ENDVRE.ogg', 50, TRUE)
	return TRUE

/datum/coven_power/old_god/ancient_blessing
	name = "Ancient Blessing"
	desc = "Bestow Psydon's ancient power upon an ally, suffering greater exhaustion yourself."
	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 5
	cooldown_length = 180 SECONDS

/datum/coven_power/old_god/ancient_blessing/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	if(!ishuman(target))
		to_chat(owner, span_warning("I can only bless the living."))
		return FALSE
	
	var/mob/living/carbon/human/ally = target
	
	// Apply healing to ally AND buff
	ally.apply_status_effect(/datum/status_effect/buff/healing/long_healing, 3, FALSE)
	ally.apply_status_effect(/datum/status_effect/buff/ancient_blessing)
	
	owner.visible_message(span_notice("[owner] channels ancient power into [ally]!"))
	to_chat(ally, span_notice("Ancient power flows through me!"))
	to_chat(owner, span_userdanger("The burden of ages crushes me!"))
	owner.stamina_add(75)
	
	playsound(get_turf(ally), 'sound/magic/ENDVRE.ogg', 50, TRUE)
	return TRUE

/datum/coven_power/old_god/ancient_wrath
	name = "Ancient Wrath"
	desc = "Call upon Psydon's ancient power to empower Psydonian allies. Psydon cares not for the feuds of newer gods."
	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 7
	cooldown_length = 90 SECONDS

/datum/coven_power/old_god/ancient_wrath/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	var/turf/T = get_turf(target)
	
	for(var/mob/living/carbon/human/L in view(7, T))
		if(L == owner)
			continue
			
		// Psydon only buffs his own followers
		if(istype(L.patron, /datum/patron/old_god))
			to_chat(L, span_notice("Ancient power empowers me!"))
			L.apply_status_effect(/datum/status_effect/buff/old_god_wrath)
	
	return TRUE

/datum/coven_power/old_god/ancient_avatar
	name = "Ancient Avatar"
	desc = "Temporarily embody Psydon's ancient essence, gaining his enduring power."
	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS

/datum/coven_power/old_god/ancient_avatar/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	to_chat(owner, span_userdanger("I am Psydon's vessel!"))
	owner.visible_message(span_danger("[owner] becomes shrouded in ancient power!"))
	owner.apply_status_effect(/datum/status_effect/buff/old_god_avatar)
	
	return TRUE
