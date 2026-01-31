/obj/effect/proc_holder/spell/invoked/stampede
	name = "Stampede"
	desc = "Charge forward with unstoppable force, trampling all in your path."
	overlay_state = "raiseskele"
	antimagic_allowed = TRUE
	recharge_time = 15 SECONDS
	range = 0
	cast_without_targets = TRUE
	sound = null
	var/charging = FALSE

/obj/effect/proc_holder/spell/invoked/stampede/cast(list/targets, mob/living/carbon/human/user)
	if(charging)
		to_chat(user, span_warning("You are already charging!"))
		return FALSE
	
	if(!istype(user))
		return FALSE
	
	charging = TRUE
	
	// Wind-up phase with telegraph
	var/charge_dir = user.dir
	var/turf/telegraph_loc = get_step(user, charge_dir)
	
	// Create warning effect
	if(telegraph_loc)
		new /obj/effect/temp_visual/stampede_warning(telegraph_loc)
	
	// Play wind-up message
	user.visible_message(
		span_danger("[user] prepares to charge!"),
		span_userdanger("You prepare to charge forward!")
	)
	
	// Brief wind-up time
	sleep(1 SECONDS)
	
	if(!user || user.stat != CONSCIOUS)
		charging = FALSE
		return FALSE
	
	// Start the charge
	do_stampede_charge(user, charge_dir)
	
	charging = FALSE
	return TRUE

/obj/effect/proc_holder/spell/invoked/stampede/proc/do_stampede_charge(mob/living/carbon/human/user, charge_dir)
	var/charge_distance = 5 // Charge 5 tiles forward
	var/stomps_played = 0
	
	for(var/i = 1 to charge_distance)
		if(!user || user.stat != CONSCIOUS)
			return
		
		var/turf/next_turf = get_step(user, charge_dir)
		if(!next_turf)
			break
		
		// Check if we can move there
		if(next_turf.density)
			// Hit a wall
			user.visible_message(span_danger("[user] crashes into \the [next_turf]!"))
			playsound(user, 'sound/combat/hits/blunt/genblunt (1).ogg', 100, TRUE)
			break
		
		// Move forward
		user.forceMove(next_turf)
		
		// Play stomp sound
		var/stomp_num = (stomps_played % 4) + 1
		playsound(user, "sound/shuz/stamp/stomp[stomp_num].ogg", 80, FALSE)
		stomps_played++
		
		// Hit all mobs on this tile
		for(var/mob/living/L in next_turf)
			if(L == user)
				continue
			if(L.stat == DEAD)
				continue
			
			stampede_hit(user, L, charge_dir)
		
		// Brief delay between steps
		sleep(0.15 SECONDS)
	
	user.visible_message(span_danger("[user]'s charge comes to a halt."))

/obj/effect/proc_holder/spell/invoked/stampede/proc/stampede_hit(mob/living/carbon/human/charger, mob/living/victim, charge_dir)
	// Knock them down
	victim.Knockdown(30) // 3 seconds
	
	// Apply damage to chest
	if(iscarbon(victim))
		var/mob/living/carbon/C = victim
		var/obj/item/bodypart/chest = C.get_bodypart(BODY_ZONE_CHEST)
		if(chest)
			chest.receive_damage(70, 0, 0, BODYPART_ORGANIC)
	else
		victim.adjustBruteLoss(70)
	
	// Drain all stamina
	victim.adjustStaminaLoss(200)
	
	// Knock them back 3 tiles
	var/knockback_dist = 3
	for(var/i = 1 to knockback_dist)
		var/turf/target_turf = get_step(victim, charge_dir)
		if(!target_turf || target_turf.density)
			break
		victim.forceMove(target_turf)
		sleep(0.1 SECONDS)
	
	// Visual and audio feedback
	victim.visible_message(
		span_danger("[victim] is trampled by [charger]'s stampede!"),
		span_userdanger("You are trampled by [charger]'s stampede!")
	)
	playsound(victim, 'sound/combat/hits/blunt/genblunt (2).ogg', 80, TRUE)

// Warning visual effect
/obj/effect/temp_visual/stampede_warning
	icon = 'icons/effects/effects.dmi'
	icon_state = "at_shield2" // Using a visible effect icon
	duration = 1 SECONDS
	layer = ABOVE_MOB_LAYER
	
/obj/effect/temp_visual/stampede_warning/Initialize()
	. = ..()
	// Make it red and attention-grabbing
	color = "#FF0000"
	// Pulse animation
	animate(src, alpha = 100, time = 5, loop = -1)
	animate(alpha = 255, time = 5)
