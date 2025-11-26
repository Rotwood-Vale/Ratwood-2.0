/datum/coven/divine_coven
	name = "Divine Miracles"
	desc = "The ancient pacts between vampire and god were forged in the chaos after PSYDON's fall. The Diecian Council of Saints - the Ten children of PSYDON - saw in the Naledi vampires a tragic reflection: cursed beings sustained by corrupted divine essence, forever mourning the light their hubris defiled. Some among the Ten offered redemption through service. Channel your patron deity's power through the Sanguine Noctis flowing in your veins."
	icon_state = "daimonion"
	experience_needed = 20

/datum/coven_power/divine
	name = "Divine Coven"
	desc = "Channel the power of The Ten."

/datum/coven_power/divine/divine_touch
	name = "Divine Touch"
	desc = "Channel your patron's blessing to heal yourself, but suffer a thematic affliction as penance."
	level = 1
	research_cost = 0
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 90 SECONDS

/datum/coven_power/divine/divine_touch/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	var/patron_type = owner.patron?.type
	
	// Apply self-heal miracle AND buff
	owner.apply_status_effect(/datum/status_effect/buff/healing/long_healing, 0.4, FALSE, owner)
	owner.apply_status_effect(/datum/status_effect/buff/divine_touch)
	
	owner.visible_message(span_notice("[owner] channels divine power..."))
	to_chat(owner, span_notice("I channel [owner.patron?.name || "divine"] power through my cursed blood."))
	
	// Apply patron-specific debuff
	switch(patron_type)
		if(/datum/patron/divine/astrata)
			to_chat(owner, span_warning("Holy flames sear my flesh!"))
			owner.adjust_fire_stacks(2)
			owner.ignite_mob()
			
		if(/datum/patron/divine/noc)
			to_chat(owner, span_warning("Lunar madness clouds my mind!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/dendor)
			to_chat(owner, span_warning("Wild fury exhausts me!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/eora)
			to_chat(owner, span_warning("Comforting warmth makes me drowsy..."))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/abyssor)
			to_chat(owner, span_warning("The ocean's pressure bears down on me!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/ravox)
			to_chat(owner, span_warning("Battle madness drains my vitality!"))
			owner.adjustBruteLoss(10)
			
		if(/datum/patron/divine/necra)
			to_chat(owner, span_warning("Death's touch weakens me!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/xylix)
			to_chat(owner, span_warning("Chaos scrambles my thoughts!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/pestra)
			to_chat(owner, span_warning("Plague toxins course through me!"))
			owner.adjustToxLoss(10)
			
		if(/datum/patron/divine/malum)
			to_chat(owner, span_warning("Forge flames burn within!"))
			owner.adjust_fire_stacks(2)
			owner.ignite_mob()
		else
			to_chat(owner, span_warning("Divine power demands a toll..."))
			owner.stamina_add(75)
	
	playsound(get_turf(owner), 'sound/magic/ENDVRE.ogg', 50, TRUE)
	return TRUE

/datum/coven_power/divine/divine_blessing
	name = "Divine Blessing"
	desc = "Bestow your patron's blessing upon an ally, suffering greater affliction yourself."
	level = 2
	research_cost = 1
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_HUMAN
	range = 5
	cooldown_length = 180 SECONDS

/datum/coven_power/divine/divine_blessing/activate(atom/target)
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
	ally.apply_status_effect(/datum/status_effect/buff/divine_blessing)
	
	// Apply stronger patron-specific debuff to owner
	switch(patron_type)
		if(/datum/patron/divine/astrata)
			owner.visible_message(span_notice("[owner] channels solar radiance into [ally]!"))
			to_chat(ally, span_notice("Holy light fills me!"))
			to_chat(owner, span_userdanger("Searing flames consume me!"))
			owner.adjust_fire_stacks(4)
			owner.ignite_mob()
			
		if(/datum/patron/divine/noc)
			owner.visible_message(span_notice("[owner] channels lunar grace into [ally]!"))
			to_chat(ally, span_notice("Moonlight empowers me!"))
			to_chat(owner, span_userdanger("Madness overtakes my thoughts!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/dendor)
			owner.visible_message(span_notice("[owner] channels primal vitality into [ally]!"))
			to_chat(ally, span_notice("Wild power surges through me!"))
			to_chat(owner, span_userdanger("Savage exhaustion overwhelms me!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/eora)
			owner.visible_message(span_notice("[owner] channels hearth warmth into [ally]!"))
			to_chat(ally, span_notice("I feel wrapped in warmth and love!"))
			to_chat(owner, span_userdanger("Deep weariness washes over me!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/abyssor)
			owner.visible_message(span_notice("[owner] channels the depths into [ally]!"))
			to_chat(ally, span_notice("Ocean power flows through me!"))
			to_chat(owner, span_userdanger("The abyss crushes me!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/ravox)
			owner.visible_message(span_notice("[owner] channels battle fury into [ally]!"))
			to_chat(ally, span_notice("Righteous fury empowers me!"))
			to_chat(owner, span_userdanger("My blood boils with wrath!"))
			owner.adjustBruteLoss(20)
			
		if(/datum/patron/divine/necra)
			owner.visible_message(span_notice("[owner] channels death's blessing into [ally]!"))
			to_chat(ally, span_notice("Death's power fills me!"))
			to_chat(owner, span_userdanger("Life drains from me!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/xylix)
			owner.visible_message(span_notice("[owner] channels chaos into [ally]!"))
			to_chat(ally, span_notice("Chaotic power surges through me!"))
			to_chat(owner, span_userdanger("Madness consumes me!"))
			owner.stamina_add(75)
			
		if(/datum/patron/divine/pestra)
			owner.visible_message(span_notice("[owner] channels pestilence into [ally]!"))
			to_chat(ally, span_notice("Plague strengthens me!"))
			to_chat(owner, span_userdanger("Disease ravages me!"))
			owner.adjustToxLoss(20)
			
		if(/datum/patron/divine/malum)
			owner.visible_message(span_notice("[owner] channels forge-fire into [ally]!"))
			to_chat(ally, span_notice("The forge empowers me!"))
			to_chat(owner, span_userdanger("Flames sear my flesh!"))
			owner.adjust_fire_stacks(4)
			owner.ignite_mob()
	
	playsound(get_turf(ally), 'sound/magic/ENDVRE.ogg', 50, TRUE)
	return TRUE

/datum/coven_power/divine/divine_wrath
	name = "Divine Wrath"
	desc = "Call upon your patron's power to empower Divine allies and weaken Inhumen enemies."
	level = 3
	research_cost = 2
	check_flags = COVEN_CHECK_CAPABLE
	target_type = TARGET_TURF
	range = 7
	cooldown_length = 90 SECONDS

/datum/coven_power/divine/divine_wrath/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	var/turf/T = get_turf(target)
	
	for(var/mob/living/carbon/human/L in view(7, T))
		if(L == owner)
			continue
			
		// Debuff enemies (Inhumen worshipers)
		if(istype(L.patron, /datum/patron/inhumen))
			to_chat(L, span_userdanger("Divine power oppresses me!"))
			L.apply_status_effect(/datum/status_effect/debuff/call_to_arms)
		else if(istype(L.patron, /datum/patron/old_god))
			continue
		else if(istype(L.patron, /datum/patron/divine))
			to_chat(L, span_notice("Divine power empowers me!"))
			L.apply_status_effect(/datum/status_effect/buff/divine_wrath)
	
	return TRUE

/datum/coven_power/divine/divine_avatar
	name = "Divine Avatar"
	desc = "Temporarily embody your patron's essence, gaining their power."
	level = 4
	research_cost = 3
	check_flags = COVEN_CHECK_CAPABLE
	target_type = NONE
	range = 0
	cooldown_length = 240 SECONDS

/datum/coven_power/divine/divine_avatar/activate(atom/target)
	. = ..()
	if(!.)
		return FALSE
	
	if(!owner)
		return FALSE
	
	to_chat(owner, span_userdanger("I channel divine power!"))
	owner.visible_message(span_danger("[owner] becomes shrouded in divine energy!"))
	owner.apply_status_effect(/datum/status_effect/buff/divine_avatar)
	
	return TRUE
