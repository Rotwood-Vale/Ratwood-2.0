// Khan's Death's Grasp spell

// Define the movespeed modifier ID
#define MOVESPEED_ID_KHAN_CHAIN "khan_chain"

/obj/effect/proc_holder/spell/invoked/deathsgrasp
	name = "Death's Grasp"
	desc = "Throw a spectral chain at a target, binding them to you. The chain can be broken by distance, obstacles, or resistance."
	range = 7
	associated_skill = /datum/skill/combat/maces
	recharge_time = 6 SECONDS
	cast_without_targets = FALSE
	sound = null // We'll play custom sounds in cast()

/obj/effect/proc_holder/spell/invoked/deathsgrasp/cast(list/targets, mob/living/carbon/human/user)
	// Only the Khan antagonist should have this spell
	if(!user.mind?.has_antag_datum(/datum/antagonist/khan_sahnuzal))
		revert_cast()
		return FALSE

	var/mob/living/carbon/human/M = user

	// Check if we have any active chains
	if(M.mind?.khan_chain_targets && length(M.mind.khan_chain_targets) > 0)
		// Pull all chained targets
		var/list/valid_chains = list()
		for(var/mob/living/carbon/human/victim in M.mind.khan_chain_targets)
			if(!victim || QDELETED(victim) || victim.stat == DEAD)
				continue
			// Check if this chain is locked (enough time has passed)
			if(world.time < M.mind.khan_chain_lock_times[victim])
				continue
			// Check if still in range and LOS
			if(get_dist(M, victim) <= 8 && can_see(M, victim, 8))
				valid_chains += victim
		
		if(length(valid_chains) == 0)
			to_chat(M, span_warning("No chains are locked tight enough to pull yet!"))
			return FALSE
		
		// Pull all valid chains
		pull_chained_targets(M, valid_chains)
		return TRUE

	// No active chain, cast new one
	var/mob/living/carbon/human/target = null
	if(LAZYLEN(targets))
		target = targets[1]

	if(!target || !istype(target) || target.stat == DEAD)
		to_chat(M, span_warning("I need a valid target!"))
		revert_cast()
		return FALSE

	if(target == M)
		to_chat(M, span_warning("I cannot chain myself!"))
		revert_cast()
		return FALSE
	
	// Check if already chained
	if(M.mind?.khan_chain_targets && (target in M.mind.khan_chain_targets))
		to_chat(M, span_warning("[target] is already chained!"))
		revert_cast()
		return FALSE

	if(get_dist(M, target) > range)
		to_chat(M, span_warning("Too far!"))
		revert_cast()
		return FALSE

	if(!can_see(M, target, range))
		to_chat(M, span_warning("I need line of sight!"))
		revert_cast()
		return FALSE

	// Windup with sound
	var/windup_time = rand(15, 20) * 0.1 SECONDS // 1.5 to 2 seconds
	var/windup_sound = pick('sound/shuz/deathg/oncast1.ogg', 'sound/shuz/deathg/oncast2.ogg', 
	                        'sound/shuz/deathg/oncast3.ogg', 'sound/shuz/deathg/oncast4.ogg')
	playsound(get_turf(M), windup_sound, 100, TRUE)
	// Play voice line
	var/windup_vo = pick('sound/shuz/deathg/oncastvo1.ogg', 'sound/shuz/deathg/oncastvo2.ogg',
	                     'sound/shuz/deathg/oncastvo3.ogg', 'sound/shuz/deathg/oncastvo4.ogg')
	playsound(get_turf(M), windup_vo, 100, TRUE)

	M.visible_message(span_danger("[M] winds up to throw a spectral chain!"), 
	                  span_notice("You prepare to throw the chain..."))

	if(!do_after(M, windup_time, target = M))
		to_chat(M, span_warning("The cast was interrupted!"))
		return FALSE

	// Check target is still valid after windup
	if(QDELETED(target) || target.stat == DEAD || get_dist(M, target) > range || !can_see(M, target, range))
		to_chat(M, span_warning("The target is no longer valid!"))
		return FALSE

	// Successfully cast - play hit sound
	var/hit_sound = pick('sound/shuz/deathg/onhit1.ogg', 'sound/shuz/deathg/onhit2.ogg',
	                     'sound/shuz/deathg/onhit3.ogg', 'sound/shuz/deathg/onhit4.ogg')
	playsound(get_turf(target), hit_sound, 100, TRUE)
	// Play oncast sound on successful chain
	var/success_sound = pick('sound/shuz/deathg/oncast1.ogg', 'sound/shuz/deathg/oncast2.ogg',
	                         'sound/shuz/deathg/oncast3.ogg', 'sound/shuz/deathg/oncast4.ogg')
	playsound(get_turf(target), success_sound, 100, TRUE)

	// Create the chain beam
	var/datum/beam/chain = M.Beam(target, icon_state="chain", time=999999, maxdistance=8)
	
	// Initialize lists if needed
	if(!M.mind.khan_chain_targets)
		M.mind.khan_chain_targets = list()
	if(!M.mind.khan_chain_beams)
		M.mind.khan_chain_beams = list()
	if(!M.mind.khan_chain_lock_times)
		M.mind.khan_chain_lock_times = list()
	
	// Store chain data
	M.mind.khan_chain_targets += target
	M.mind.khan_chain_beams[target] = chain
	target.mind?.khan_chained_by = M
	
	// Set timer for when pull will be available (8-15 seconds)
	var/lock_time = rand(8, 15) SECONDS
	M.mind.khan_chain_lock_times[target] = world.time + lock_time

	// Apply speed reduction
	target.add_movespeed_modifier(MOVESPEED_ID_KHAN_CHAIN, TRUE, 100, override=TRUE, multiplicative_slowdown=5)

	M.visible_message(span_danger("A spectral chain flies from [M] and wraps around [target]!"),
	                  span_notice("Your chain catches [target]!"))
	to_chat(target, span_userdanger("A spectral chain wraps around you!"))

	// Start the chain lock timer warning
	chain_lock_warning(M, target)

	// Start the chain monitoring process
	monitor_chain(M, target, chain)

	return TRUE

// Pull all chained targets intelligently - or at least as best as we can.
/obj/effect/proc_holder/spell/invoked/deathsgrasp/proc/pull_chained_targets(mob/living/carbon/human/caster, list/victims)
	if(!length(victims))
		return
	
	// Play success voice line once
	var/succ_pick = rand(1, 4)
	switch(succ_pick)
		if(1)
			playsound(get_turf(caster), 'sound/shuz/deathg/succ1.ogg', 100, TRUE)
			caster.say("Face me!")
		if(2)
			playsound(get_turf(caster), 'sound/shuz/deathg/succ2.ogg', 100, TRUE)
			caster.say("You cannot run...")
		if(3)
			playsound(get_turf(caster), 'sound/shuz/deathg/succ3.ogg', 100, TRUE)
			caster.say("No quarter!")
		if(4)
			playsound(get_turf(caster), 'sound/shuz/deathg/succ4.ogg', 100, TRUE)
			caster.say("Are you a coward?")
	
	playsound(get_turf(caster), 'sound/shuz/deathg/oncast3.ogg', 80, TRUE)
	
	// Get available positions around Khan, prioritizing front (based on dir) at 1 tile distance
	var/list/preferred_positions = list()
	var/list/front_directions = list()
	var/list/side_directions = list()
	var/list/back_directions = list()
	
	// Categorize directions based on Khan's facing
	switch(caster.dir)
		if(NORTH)
			front_directions = list(NORTH, NORTHEAST, NORTHWEST)
			side_directions = list(EAST, WEST)
			back_directions = list(SOUTH, SOUTHEAST, SOUTHWEST)
		if(SOUTH)
			front_directions = list(SOUTH, SOUTHEAST, SOUTHWEST)
			side_directions = list(EAST, WEST)
			back_directions = list(NORTH, NORTHEAST, NORTHWEST)
		if(EAST)
			front_directions = list(EAST, NORTHEAST, SOUTHEAST)
			side_directions = list(NORTH, SOUTH)
			back_directions = list(WEST, NORTHWEST, SOUTHWEST)
		if(WEST)
			front_directions = list(WEST, NORTHWEST, SOUTHWEST)
			side_directions = list(NORTH, SOUTH)
			back_directions = list(EAST, NORTHEAST, SOUTHEAST)
	
	// Check front positions first (prioritize), then sides, then back as last resort
	for(var/direction in front_directions)
		var/turf/T = get_step(caster, direction)
		if(T && isturf(T) && !T.density)
			var/blocked = FALSE
			for(var/obj/O in T)
				if(O.density)
					blocked = TRUE
					break
			if(!blocked)
				preferred_positions += T
	
	for(var/direction in side_directions)
		var/turf/T = get_step(caster, direction)
		if(T && isturf(T) && !T.density)
			var/blocked = FALSE
			for(var/obj/O in T)
				if(O.density)
					blocked = TRUE
					break
			if(!blocked)
				preferred_positions += T
	
	// Only use back positions if absolutely necessary
	if(length(preferred_positions) == 0)
		for(var/direction in back_directions)
			var/turf/T = get_step(caster, direction)
			if(T && isturf(T) && !T.density)
				var/blocked = FALSE
				for(var/obj/O in T)
					if(O.density)
						blocked = TRUE
						break
				if(!blocked)
					preferred_positions += T
	
	// If no preferred positions available at all, just use Khan's front
	if(length(preferred_positions) == 0)
		var/turf/T = get_step(caster, caster.dir)
		if(T && isturf(T))
			preferred_positions += T
	
	// Pull each victim to a unique position if possible
	var/position_index = 0
	for(var/mob/living/carbon/human/victim in victims)
		var/turf/target_turf = null
		
		// Try to get a unique position
		if(position_index < length(preferred_positions))
			target_turf = preferred_positions[position_index + 1]
			position_index++
		else if(length(preferred_positions) > 0)
			// Reuse positions if we have more victims than positions
			target_turf = pick(preferred_positions)
		else
			// Last resort: Khan's front tile
			target_turf = get_step(caster, caster.dir)
		
		// Move victim to target position (always 1 tile away)
		if(target_turf && isturf(target_turf))
			victim.forceMove(target_turf)
			victim.Knockdown(0.5 SECONDS)
			to_chat(victim, span_danger("[caster] yanks you closer with the chain!"))
	
	to_chat(caster, span_notice("You pull your chained victims closer!"))
	
	// Break all chains after successful pull
	for(var/mob/living/carbon/human/victim in victims)
		break_chain(caster, victim, "pull")

// Handle the chain lock warning after timer
/obj/effect/proc_holder/spell/invoked/deathsgrasp/proc/chain_lock_warning(mob/living/carbon/human/caster, mob/living/carbon/human/victim)
	set waitfor = FALSE
	
	var/lock_time = caster.mind.khan_chain_lock_times[victim] - world.time
	if(lock_time <= 0)
		return
	
	sleep(lock_time)
	
	// Check if chain still exists
	if(!caster?.mind?.khan_chain_targets || !(victim in caster.mind.khan_chain_targets))
		return
	
	// Play warning sound and show message
	playsound(get_turf(caster), 'sound/shuz/deathg/onhit3.ogg', 100, TRUE)
	playsound(get_turf(victim), 'sound/shuz/deathg/onhit3.ogg', 100, TRUE)
	
	to_chat(caster, span_boldannounce(span_userdanger("The chain locks tightly around [victim]! You can now pull them!")))
	to_chat(victim, span_boldannounce(span_userdanger("The chain locks tightly around you!")))
	
	caster.visible_message(span_danger("The spectral chain tightens around [victim]!"))

// Monitor chain for breaking conditions
/obj/effect/proc_holder/spell/invoked/deathsgrasp/proc/monitor_chain(mob/living/carbon/human/caster, mob/living/carbon/human/victim, datum/beam/chain)
	set waitfor = FALSE
	
	var/max_distance = rand(6, 8)
	
	while(caster && victim && !QDELETED(caster) && !QDELETED(victim))
		sleep(2) // Check every 0.2 seconds
		
		// Check if either is dead
		if(caster.stat == DEAD || victim.stat == DEAD)
			break_chain(caster, victim, "death")
			return
		
		// Check if victim moved too far
		var/dist = get_dist(caster, victim)
		if(dist > max_distance)
			break_chain(caster, victim, "distance")
			return
		
		// Check line of sight
		if(!can_see(caster, victim, max_distance))
			break_chain(caster, victim, "obstacle")
			return
		
		// Check if chain data still exists
		if(!caster.mind?.khan_chain_targets || !(victim in caster.mind.khan_chain_targets))
			return

// Break the chain
/obj/effect/proc_holder/spell/invoked/deathsgrasp/proc/break_chain(mob/living/carbon/human/caster, mob/living/carbon/human/victim, reason)
	// Play break sound
	var/break_sound = pick('sound/shuz/deathg/break1.ogg', 'sound/shuz/deathg/break2.ogg', 'sound/shuz/deathg/break3.ogg')
	playsound(get_turf(caster), break_sound, 80, TRUE)
	
	// End beam
	if(caster?.mind?.khan_chain_beams && caster.mind.khan_chain_beams[victim])
		var/datum/beam/chain = caster.mind.khan_chain_beams[victim]
		chain.End()
	
	// Remove speed modifier
	if(victim && !QDELETED(victim))
		victim.remove_movespeed_modifier(MOVESPEED_ID_KHAN_CHAIN)
	
	// Clear data
	if(caster?.mind)
		if(caster.mind.khan_chain_targets)
			caster.mind.khan_chain_targets -= victim
		if(caster.mind.khan_chain_beams)
			caster.mind.khan_chain_beams -= victim
		if(caster.mind.khan_chain_lock_times)
			caster.mind.khan_chain_lock_times -= victim
	if(victim?.mind)
		victim.mind.khan_chained_by = null
	
	// Messages based on reason
	switch(reason)
		if("distance")
			caster.visible_message(span_danger("The chain stretches too far and snaps!"))
		if("obstacle")
			caster.visible_message(span_danger("The chain breaks as [victim] moves behind cover!"))
		if("resist")
			caster.visible_message(span_danger("[victim] breaks free from the chain!"))
			to_chat(victim, span_notice("You break free from the chain!"))
		if("death")
			caster.visible_message(span_danger("The chain dissipates..."))
		if("pull")
			// Silent break after pull - no message needed

// Add resist handler - called from the player's resist action
/mob/living/carbon/human/proc/try_resist_khan_chain()
	if(!mind?.khan_chained_by)
		return FALSE
	
	var/mob/living/carbon/human/khan = mind.khan_chained_by
	if(!khan || QDELETED(khan))
		return FALSE
	
	// Strength check - higher strength = better chance
	var/strength = STASTR
	var/break_chance = min((strength - 10) * 10, 70) // 10 STR = 0%, 20 STR = 70% cap
	
	if(prob(break_chance))
		// Successfully break free
		var/obj/effect/proc_holder/spell/invoked/deathsgrasp/spell = locate() in khan.mind.spell_list
		if(spell)
			spell.break_chain(khan, src, "resist")
		return TRUE
	else
		to_chat(src, span_warning("You struggle against the chain but cannot break free!"))
		visible_message(span_danger("[src] struggles against the spectral chain!"))
		return TRUE // Return true so resist was attempted
