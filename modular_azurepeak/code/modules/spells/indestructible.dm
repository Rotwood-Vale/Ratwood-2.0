// Khan's Indestructible spell

/obj/effect/proc_holder/spell/invoked/indestructible
	name = "Indestructible"
	desc = "Channel divine power to heal yourself. Taking significant damage will interrupt this and stun you."
	range = -1
	recharge_time = 30 SECONDS
	cast_without_targets = TRUE
	invocation_type = "none"
	releasedrain = 0
	chargedrain = 0
	chargetime = 0
	sound = null

/obj/effect/proc_holder/spell/invoked/indestructible/cast(list/targets, mob/living/carbon/human/user)
	// Only the Khan antagonist should have this spell
	if(!user.mind?.has_antag_datum(/datum/antagonist/khan_sahnuzal))
		revert_cast()
		return FALSE
	
	var/mob/living/carbon/human/H = user
	
	// Check if already channeling
	if(H.mind.khan_indestructible_active)
		to_chat(H, span_warning("I am already channeling!"))
		revert_cast()
		return FALSE
	
	// Mark as active
	H.mind.khan_indestructible_active = TRUE
	
	// Track damage taken during channel
	var/starting_health = H.health
	var/damage_threshold = 250
	
	// Create shield visual effect above head using the riposte/guard icon - lower position
	var/atom/shield_icon = H.play_overhead_indicator_flick('icons/mob/mob_effects.dmi', "eff_riposte", 60, GHOST_LAYER, null, 48, 0)
	
	// Apply shield overlay to the Khan
	var/mutable_appearance/shield_overlay = mutable_appearance('icons/effects/effects.dmi', "shield-grey")
	shield_overlay.layer = ABOVE_MOB_LAYER
	H.add_overlay(shield_overlay)
	
	// Animate the shield icon to gradually reveal from bottom to top (stationary, revealed like sliding paper up)
	if(shield_icon)
		// Start with icon invisible by scaling Y to 0 (collapsed from bottom)
		var/matrix/M = matrix()
		M.Scale(1.2, 0.01)  // X scaled to 1.2, Y collapsed to nearly 0
		shield_icon.transform = M
		shield_icon.alpha = 255  // Keep it visible
		// Gradually scale Y from 0 to 1.2 over 6 seconds (reveals from bottom to top)
		var/matrix/M_final = matrix()
		M_final.Scale(1.2, 1.2)  // Final size
		animate(shield_icon, transform = M_final, time = 60, easing = LINEAR_EASING)
	
	playsound(get_turf(H), pick('sound/shuz/indes/vo1c.ogg','sound/shuz/indes/vo2c.ogg','sound/shuz/indes/vo3c.ogg','sound/shuz/indes/vo4c.ogg'), 100, TRUE)
	sleep(7)
	playsound(get_turf(H), pick('sound/shuz/indes/oncast1.ogg','sound/shuz/indes/oncast2.ogg','sound/shuz/indes/oncast3.ogg'), 100, TRUE)
	playsound(get_turf(H), 'sound/shuz/indes/oncastfoley.ogg', 100, TRUE)
	
	// Play background ambience during ability
	playsound(get_turf(H), 'sound/shuz/indes/bgx.ogg', 50, TRUE)
	
	to_chat(H, span_boldnotice("I begin channeling divine protection..."))
	H.visible_message(span_danger("[H] begins reaping the life essence of the battlefield!"), span_boldnotice("I reap the life essence from those who fall around me..."))
	H.visible_message(span_warning("The channeling can be interrupted with enough damage!"))
	
	// 6 second windup with damage checks
	var/windup_time = 6 SECONDS
	var/check_interval = 5 // Check every 0.5 seconds
	var/checks_needed = windup_time / check_interval
	
	for(var/i = 1, i <= checks_needed, i++)
		sleep(check_interval)
		
		// Check if dead or unconscious
		if(H.stat >= UNCONSCIOUS)
			to_chat(H, span_warning("My channeling is interrupted!"))
			H.mind.khan_indestructible_active = FALSE
			if(shield_icon)
				qdel(shield_icon)
			H.cut_overlay(shield_overlay)
			return TRUE
		
		// Check damage taken
		var/damage_taken = starting_health - H.health
		if(damage_taken >= damage_threshold)
			to_chat(H, span_userdanger("The backlash of interrupted channeling overwhelms me!"))
			H.visible_message(span_danger("[H]'s channeling is violently disrupted!"), span_userdanger("My channeling fails! The backlash strikes me down!"))
			H.mind.khan_indestructible_active = FALSE
			if(shield_icon)
				qdel(shield_icon)
			H.cut_overlay(shield_overlay)
			// Play break sounds
			playsound(get_turf(H), pick('sound/shuz/indes/break1.ogg','sound/shuz/indes/break2.ogg','sound/shuz/indes/break3.ogg'), 100, TRUE)
			H.Paralyze(50) // 5 second stun
			return TRUE
	
	// Successfully completed channel - heal for 150
	H.adjustBruteLoss(-150)
	H.adjustFireLoss(-150)
	to_chat(H, span_boldnotice("Divine power courses through me, mending my wounds!"))
	H.visible_message(span_boldannounce("[H] completes the dark ritual, vitality flowing into [H.p_them()]!"), span_boldnotice("Success! The life essence restores me!"))
	
	// Play success sounds and matching voice lines
	playsound(get_turf(H), 'sound/shuz/indes/success.ogg', 100, TRUE)
	var/voice_line = pick('sound/shuz/indes/succvo1.ogg','sound/shuz/indes/succvo2.ogg','sound/shuz/indes/succvo3.ogg','sound/shuz/indes/succvo4.ogg','sound/shuz/indes/succvo5.ogg','sound/shuz/indes/succvo6.ogg')
	playsound(get_turf(H), voice_line, 100, TRUE)
	
	// Automatic Khan messages based on voice line
	switch(voice_line)
		if('sound/shuz/indes/succvo1.ogg')
			H.say("The blood of life!", forced = "spell")
		if('sound/shuz/indes/succvo2.ogg')
			H.say("The Gods bless me!", forced = "spell")
		if('sound/shuz/indes/succvo3.ogg')
			H.say("Goood....", forced = "spell")
		if('sound/shuz/indes/succvo4.ogg', 'sound/shuz/indes/succvo5.ogg', 'sound/shuz/indes/succvo6.ogg')
			H.emote("me", 1, "laughs mockingly.", TRUE)
	
	// Clean up
	H.mind.khan_indestructible_active = FALSE
	if(shield_icon)
		qdel(shield_icon)
	H.cut_overlay(shield_overlay)
	
	return TRUE
