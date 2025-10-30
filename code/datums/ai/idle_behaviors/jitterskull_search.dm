// Idle visuals and SFX when jitterskull has no target; complements find_target without replacing it

/datum/idle_behavior/jitterskull_search
	/// Minimum time without a target before enabling search visuals
	var/search_debounce = 3 SECONDS
	/// Cooldown for announcing search text
	var/announce_cooldown = 5 SECONDS

/datum/idle_behavior/jitterskull_search/perform_idle_behavior(delta_time, datum/ai_controller/controller)
	. = ..()
	var/mob/living/simple_animal/hostile/rogue/jitterskull/J = controller.pawn
	if(!istype(J))
		return
	if(J.is_stalking || J.is_guarding || J.is_feasting || J.is_dying || J.stat == DEAD)
		return
	// Occasional idle chatter
	if(world.time >= J.next_idle_chatter_time)
		if(prob(60))
			var/chatter = pick('sound/mobs/jitter_chatter1.ogg','sound/mobs/jitter_chatter2.ogg','sound/mobs/jitter_chatter3.ogg','sound/mobs/jitter_chatter4.ogg')
			playsound(J, chatter, 50, FALSE)
		J.next_idle_chatter_time = world.time + rand(30, 80)
	var/atom/current = controller.blackboard[BB_BASIC_MOB_CURRENT_TARGET]
	// If we have a valid target, ensure normal alpha and reset timers
	if(current && !QDELETED(current) && !(isliving(current) && current:stat == DEAD))
		if(J.is_searching)
			J.is_searching = FALSE
			J.alpha = J.original_alpha
		J.no_target_since = 0
		return
	// No target: turn on search visuals after a short debounce and occasionally narrate
	if(!J.no_target_since)
		J.no_target_since = world.time
	if(world.time >= J.no_target_since + search_debounce)
		if(!J.is_searching)
			J.is_searching = TRUE
			if(J.alpha != 25)
				J.alpha = 25
		if(world.time >= J.next_search_announce_time)
			J.visible_message(span_notice("The Jitterskull searches for its next prey."))
			J.next_search_announce_time = world.time + announce_cooldown
	return
