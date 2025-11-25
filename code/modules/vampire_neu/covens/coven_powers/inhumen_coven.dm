/datum/coven/inhumen_coven
	name = "Inhumen Pacts"
	desc = "When PSYDON fell, four mortals seized comet shards and ascended through profane means. Zizo the God-Head - architect of PSYDON's murder and first to weaponize the Sanguine Noctis, creating the Hollowed vampires as tools of the Rot. Graggar, Baotha, and Matthios followed, each offering their own dark gifts to those vampires - Purist or Hollowed - who swear fealty. The Inhumen see vampirism not as curse, but as evolution."
	icon_state = "daimonion_z"
	power_type = /datum/coven_power/inhumen
	is_god_coven = TRUE
	experience_needed = 20

/datum/coven_power/inhumen
	name = "Inhumen Coven"
	desc = "Channel the power of the Inhumen pantheon."

/datum/coven_power/inhumen/inhumen_touch
	name = "Inhumen Touch"
	desc = "Channel your patron's dark blessing to heal yourself, but suffer a thematic affliction as tribute."
	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 90 SECONDS

/datum/coven_power/inhumen/inhumen_touch/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	var/patron_type = owner.patron?.type
	
	// Apply self-heal miracle AND buff
	owner.apply_status_effect(/datum/status_effect/buff/healing/long_healing, 0.4, FALSE, owner)
	owner.apply_status_effect(/datum/status_effect/buff/inhumen_touch)
	
	// Apply patron-specific debuff
	switch(patron_type)
		if(/datum/patron/inhumen/zizo)
			owner.visible_message(span_notice("[owner] reeks of decay..."))
			to_chat(owner, span_warning("Rot consumes my flesh!"))
			owner.adjustToxLoss(12)
			
		if(/datum/patron/inhumen/graggar)
			owner.visible_message(span_notice("[owner] pulses with savage power..."))
			to_chat(owner, span_warning("Battle-lust wounds me!"))
			owner.adjustBruteLoss(12)
			
		if(/datum/patron/inhumen/matthios)
			owner.visible_message(span_notice("[owner] fades into shadow..."))
			to_chat(owner, span_warning("Shadows drain my strength!"))
			owner.stamina_add(75)
			
		if(/datum/patron/inhumen/baotha)
			owner.visible_message(span_notice("[owner] radiates alluring energy..."))
			to_chat(owner, span_warning("Desire exhausts me!"))
			owner.stamina_add(75)
	
	playsound(get_turf(owner), 'sound/magic/ENDVRE.ogg', 50, TRUE)
	return TRUE

/datum/coven_power/inhumen/inhumen_blessing
	name = "Inhumen Blessing"
	desc = "Bestow your patron's dark blessing upon an ally, suffering greater affliction yourself."
	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 5
	cooldown_length = 180 SECONDS

/datum/coven_power/inhumen/inhumen_blessing/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	if(!ishuman(target))
		to_chat(owner, span_warning("I can only bless the living."))
		return FALSE
	
	var/mob/living/carbon/human/ally = target
	var/patron_type = owner.patron?.type
	
	// Apply healing to ally AND buff
	ally.apply_status_effect(/datum/status_effect/buff/healing/long_healing, 0.4, FALSE, owner)
	ally.apply_status_effect(/datum/status_effect/buff/inhumen_blessing)
	
	// Apply stronger patron-specific debuff to owner
	switch(patron_type)
		if(/datum/patron/inhumen/zizo)
			owner.visible_message(span_notice("[owner] channels rot into [ally]!"))
			to_chat(ally, span_notice("Decay empowers me!"))
			to_chat(owner, span_userdanger("Rot consumes me!"))
			owner.adjustToxLoss(25)
			
		if(/datum/patron/inhumen/graggar)
			owner.visible_message(span_notice("[owner] channels war-fury into [ally]!"))
			to_chat(ally, span_notice("Savage power fills me!"))
			to_chat(owner, span_userdanger("Conquest tears at me!"))
			owner.adjustBruteLoss(25)
			
		if(/datum/patron/inhumen/matthios)
			owner.visible_message(span_notice("[owner] channels shadow into [ally]!"))
			to_chat(ally, span_notice("Darkness empowers me!"))
			to_chat(owner, span_userdanger("Shadows sap my vitality!"))
			owner.stamina_add(75)
			
		if(/datum/patron/inhumen/baotha)
			owner.visible_message(span_notice("[owner] channels passion into [ally]!"))
			to_chat(ally, span_notice("Desire empowers me!"))
			to_chat(owner, span_userdanger("Overwhelming passion weakens me!"))
			owner.stamina_add(75)
	
	playsound(get_turf(ally), 'sound/magic/ENDVRE.ogg', 50, TRUE)
	return TRUE

/datum/coven_power/inhumen/inhumen_wrath
	name = "Inhumen Wrath"
	desc = "Call upon your patron's power to empower Inhumen allies and weaken Divine enemies."
	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 7
	cooldown_length = 90 SECONDS

/datum/coven_power/inhumen/inhumen_wrath/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	var/turf/T = get_turf(target)
	
	for(var/mob/living/carbon/human/L in view(7, T))
		if(L == owner)
			continue
			
		// Debuff enemies (Divine worshipers)
		if(istype(L.patron, /datum/patron/divine))
			to_chat(L, span_userdanger("Inhumen power oppresses me!"))
			L.apply_status_effect(/datum/status_effect/debuff/call_to_arms)
		// Psydon followers unaffected
		else if(istype(L.patron, /datum/patron/old_god))
			continue
		// Buff Inhumen allies
		else if(istype(L.patron, /datum/patron/inhumen))
			to_chat(L, span_notice("Inhumen power empowers me!"))
			L.apply_status_effect(/datum/status_effect/buff/inhumen_wrath)
	
	return TRUE

/datum/coven_power/inhumen/inhumen_avatar
	name = "Inhumen Avatar"
	desc = "Temporarily embody your patron's essence, gaining their power."
	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS

/datum/coven_power/inhumen/inhumen_avatar/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	to_chat(owner, span_userdanger("I channel inhumen power!"))
	owner.visible_message(span_danger("[owner] becomes shrouded in dark energy!"))
	owner.apply_status_effect(/datum/status_effect/buff/inhumen_avatar)
	
	return TRUE
