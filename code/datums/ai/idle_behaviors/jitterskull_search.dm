// Idle visuals and SFX when jitterskull has no target; complements find_target without replacing it

/datum/idle_behavior/jitterskull_search
	/// Minimum time without a target before enabling search visuals
	var/search_debounce = 30
	/// Cooldown for announcing search text (deciseconds). Increase to reduce spam.
	var/announce_cooldown = 300

/datum/idle_behavior/jitterskull_search/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/rogue/jitterskull/skull = controller.pawn
	if(!istype(skull))
		return
	if(skull.is_stalking || skull.is_guarding || skull.is_feasting || skull.stat == DEAD)
		return
	// Occasional idle chatter
	if(world.time >= skull.next_idle_chatter_time)
		if(prob(60))
			var/chatter = pick('sound/mobs/jitter_chatter1.ogg','sound/mobs/jitter_chatter2.ogg','sound/mobs/jitter_chatter3.ogg','sound/mobs/jitter_chatter4.ogg')
			playsound(skull, chatter, 50, FALSE)
		skull.next_idle_chatter_time = world.time + rand(30, 80)
	var/mob/living/current = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	// If we have a valid target, ensure normal alpha and reset timers
	if(current && !QDELETED(current) && current.stat != DEAD)
		if(skull.is_searching)
			skull.is_searching = FALSE
			skull.alpha = skull.original_alpha
		skull.no_target_since = 0
		return
	// No target: turn on search visuals after a short debounce and occasionally narrate
	if(!skull.no_target_since)
		skull.no_target_since = world.time
	if(world.time >= skull.no_target_since + search_debounce)
		if(!skull.is_searching)
			skull.is_searching = TRUE
			if(skull.alpha != 25)
				skull.alpha = 25
		if(world.time >= skull.next_search_announce_time)
			skull.visible_message(span_notice("[skull] searches for its next prey."))
			skull.next_search_announce_time = world.time + announce_cooldown
	return
