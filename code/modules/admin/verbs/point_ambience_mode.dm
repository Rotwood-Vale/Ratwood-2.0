/// Switches SSpoint_ambience between its modes and sets every move-service knob, live. The
/// POINT_AMBIENCE_* config entries seed the same values at boot and document what each one costs.
/// POINT_AMBIENCE_CROSS_FLOOR is deliberately not here: it changes what players hear, not load.
/client/proc/point_ambience_mode()
	set category = "Debug"
	set name = "Point Ambience Mode"
	if(!check_rights(R_DEBUG))
		return
	var/static/list/mode_names = list(
		"Live" = POINT_AMBIENCE_LIVE,
		// Fallback is deliberately NOT offered HERE, though POINT_AMBIENCE_MODE can still select it
		// at boot. Entering it on a running server gives every source a plain looping sound at once,
		// which at this map's counts is upward of 1800 TIMER_CLIENT_TIME entries in a linearly
		// scanned list: it delays every other timer in SSsound_loops and is heard as weather
		// stuttering. Chosen before a round is a different thing from flipped underneath one.
		"Off" = POINT_AMBIENCE_OFF,
		// Reaches the settings below without touching the mode. It matters most on a round booted
		// into fallback, which is not in this list: without this, picking anything at all is a
		// one-way door out of fallback, so an admin could not adjust the interval without ending it.
		"Keep current" = POINT_AMBIENCE_MODE_UNCHANGED,
	)
	var/current
	for(var/name in mode_names)
		if(mode_names[name] == SSpoint_ambience.mode)
			current = name
	// Nothing matched, so the config booted this round on fallback loops. Default to changing
	// nothing, and say so, because the list above cannot get back there: leaving is one click and
	// returning needs a restart.
	if(!current)
		current = "Keep current"
		to_chat(src, span_warning("Point ambience is running on FALLBACK LOOPS, set by POINT_AMBIENCE_MODE at boot. This verb cannot switch back to it. Leaving it now means plain loops stay gone until the next round."))
	var/choice = input(src, "Live serves every client the nearest sources per step and per tick. Off is silent. Fallback loops are set by config at boot and are not offered here, because switching into them on a running server gives every source a plain looping sound at once and delays everything else in SSsound_loops.\n\nFirst of six prompts. Cancel here leaves the verb entirely; pick \"Keep current\" to change nothing and go on to the five move-service settings. Fallback is all or nothing; a single category cannot be moved onto plain loops.", "Point Ambience Mode, 1 of 6", current) as null|anything in mode_names
	if(!choice)
		return
	var/chosen_mode = mode_names[choice]
	if(chosen_mode != POINT_AMBIENCE_MODE_UNCHANGED)
		SSpoint_ambience.set_mode(chosen_mode)
	// Neither setting below is read outside live mode: the move hook returns before the interval,
	// and torches get no fallback loop whichever way handhelds are set. Both are still worth
	// setting here, since they take hold the moment live resumes.
	var/effective_mode = SSpoint_ambience.mode
	var/inert = (effective_mode == POINT_AMBIENCE_LIVE) ? "" : "\n\nThe current mode does not read this. It takes effect when you switch back to Live."
	var/interval = input(src, "Minimum deciseconds between move-hook services of one client. 0 serves on every step; 5 caps a walker at two a second and removes about half their services.[inert]", "Move Service Interval", SSpoint_ambience.move_service_interval) as null|num
	if(!isnull(interval))
		SSpoint_ambience.move_service_interval = max(0, interval)
	var/running = input(src, "Replaces the interval above for a client who is RUNNING, who covers more ground between services. At speed 15 an interval of 5 puts one service every four tiles, a whole sconce's range in one jump; 3 keeps it to two tiles. 0 means NO OVERRIDE, so runners use the value above — it does not mean runners are uncapped.[inert]", "Move Service Interval, Running", SSpoint_ambience.move_service_interval_running_override) as null|num
	if(!isnull(running))
		SSpoint_ambience.move_service_interval_running_override = max(0, running)
	var/cap = input(src, "Ceiling on move-hook services in one tick, across every client. 0 is none, and also turns off the tick-usage gate beside it. At 150 players it is a rail rather than a knob: 8 is about twice the mean with a third of them walking, and binds only when most of the server moves at once. A step over the cap is deferred a tick with the queue on, refused with it off, and the once-a-second walk catches either. See POINT_AMBIENCE_MAX_SERVICES_PER_TICK in config.txt for the arithmetic.[inert]", "Move Services Per Tick", SSpoint_ambience.max_services_per_tick) as null|num
	if(!isnull(cap))
		SSpoint_ambience.max_services_per_tick = max(0, cap)
	// Turning it off strands nobody: fire() drains whatever is still marked whether or not the queue
	// is on, so the set empties on the next tick and only new steps take the inline path.
	var/queue_now = SSpoint_ambience.use_queue ? "On" : "Off"
	var/queue_choice = alert(src, "Queue: a step marks the client and the tick serves everyone marked back to back, up to the cap, instead of servicing inline inside Move(). A service run straight after another costs several times less than one run on its own, so a full tick of movers pays that cost once. Off is the inline path with the cap and tick gate. Currently [queue_now].[inert]", "Move Service Queue", "On", "Off", "Keep current")
	if(queue_choice == "On")
		SSpoint_ambience.use_queue = TRUE
	else if(queue_choice == "Off")
		SSpoint_ambience.use_queue = FALSE
	var/skip = input(src, "Deciseconds within which the once-a-second walk passes over a client a step already served. A walker is served every other step and would be walked again every second at a tile they are about to leave. 0 never skips. 5 matches the interval and skips a walker about four times in five; 3 about half. The price is the catch-up after stopping: the worst case becomes this plus one second.[inert]", "Standing Walk Skip", SSpoint_ambience.standing_skip) as null|num
	if(!isnull(skip))
		SSpoint_ambience.standing_skip = max(0, skip)
	var/summary = "set point ambience to [chosen_mode == POINT_AMBIENCE_MODE_UNCHANGED ? "[SSpoint_ambience.mode == POINT_AMBIENCE_FALLBACK ? "Fallback" : "its current mode"] (unchanged)" : choice], move interval [SSpoint_ambience.move_service_interval][SSpoint_ambience.move_service_interval_running_override ? " ([SSpoint_ambience.move_service_interval_running_override] running)" : ""], cap [SSpoint_ambience.max_services_per_tick] a tick, queue [SSpoint_ambience.use_queue ? "on" : "off"], standing skip [SSpoint_ambience.standing_skip]"
	message_admins("[key_name_admin(src)] [summary].")
	log_admin("[key_name(src)] [summary].")
