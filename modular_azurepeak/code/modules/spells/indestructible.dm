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
	var/damage_threshold = 500
	
	// Create shield visual effect above head
	var/obj/effect/temp_visual/khan_shield_icon/shield_icon = new(get_turf(H))
	shield_icon.loc = null
	H.vis_contents += shield_icon
	
	// Apply shield overlay to the Khan
	var/mutable_appearance/shield_overlay = mutable_appearance('icons/effects/effects.dmi', "shield-grey")
	shield_overlay.layer = ABOVE_MOB_LAYER
	H.add_overlay(shield_overlay)
	
	to_chat(H, span_boldnotice("I begin channeling divine protection..."))
	
	// 15 second windup with damage checks
	var/windup_time = 15 SECONDS
	var/check_interval = 5 // Check every 0.5 seconds
	var/checks_needed = windup_time / check_interval
	
	for(var/i = 1, i <= checks_needed, i++)
		sleep(check_interval)
		
		// Check if dead or unconscious
		if(H.stat >= UNCONSCIOUS)
			to_chat(H, span_warning("My channeling is interrupted!"))
			H.mind.khan_indestructible_active = FALSE
			H.vis_contents -= shield_icon
			qdel(shield_icon)
			H.cut_overlay(shield_overlay)
			return TRUE
		
		// Check damage taken
		var/damage_taken = starting_health - H.health
		if(damage_taken >= damage_threshold)
			to_chat(H, span_userdanger("The backlash of interrupted channeling overwhelms me!"))
			H.mind.khan_indestructible_active = FALSE
			H.vis_contents -= shield_icon
			qdel(shield_icon)
			H.cut_overlay(shield_overlay)
			H.Paralyze(50) // 5 second stun
			return TRUE
	
	// Successfully completed channel - heal for 500
	H.adjustBruteLoss(-500)
	H.adjustFireLoss(-500)
	to_chat(H, span_boldnotice("Divine power courses through me, mending my wounds!"))
	playsound(get_turf(H), 'sound/magic/churn.ogg', 100, TRUE)
	
	// Clean up
	H.mind.khan_indestructible_active = FALSE
	H.vis_contents -= shield_icon
	qdel(shield_icon)
	H.cut_overlay(shield_overlay)
	
	return TRUE

// Visual effect for the shield icon above Khan's head
/obj/effect/temp_visual/khan_shield_icon
	icon = 'icons/mob/actions.dmi'
	icon_state = "parry"
	layer = GHOST_LAYER
	pixel_y = 32
	duration = 16 SECONDS
	
/obj/effect/temp_visual/khan_shield_icon/Initialize()
	. = ..()
	// Animate the shield forming from bottom to top over 15 seconds
	// Start fully clipped at bottom
	var/matrix/M = matrix()
	M.Translate(0, -32)
	transform = M
	alpha = 100
	
	// Animate to full position
	animate(src, transform = null, alpha = 255, time = 150, easing = LINEAR_EASING)
