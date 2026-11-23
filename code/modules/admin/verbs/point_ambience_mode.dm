/**
 * Edits point ambience load settings at runtime and logs each change.
 *
 * The menu repeats until cancelled and displays current values. Configuration supplies startup
 * defaults. Acoustic wall and door policies remain available through variable editing.
 */
/client/proc/point_ambience_mode()
	set category = "Debug"
	set name = "Point Ambience Mode"
	if(!check_rights(R_DEBUG))
		return
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	while(TRUE)
		var/interval = ambience.move_service_interval
		var/running = ambience.move_service_interval_running_override
		var/steps = ambience.move_service_steps
		var/cap = ambience.max_services_per_tick
		var/door_period = ambience.door_recheck ? ambience.door_recheck_period : 0
		var/list/entries = list(
			"Mode: [point_ambience_mode_name(ambience.mode)]" = "mode",
			"Move interval: [interval] ds" = "interval",
			"Running override: [running ? "[running] ds" : "none"]" = "running",
			"Steps: [steps ? steps : "off"]" = "steps",
			"Speed cutoff: [ambience.speed_cutoff ? "on" : "off"]" = "cutoff",
			"Services per tick: [cap ? cap : "no cap"]" = "cap",
			"Queue: [ambience.use_queue ? "on" : "off"]" = "queue",
			"Standing skip: [ambience.standing_skip] ds" = "skip",
			"Door re-check: [door_period ? "every [door_period] ds" : "off"]" = "doors",
			"Reset all but the mode to config" = "reset",
		)
		var/not_live = (ambience.mode == POINT_AMBIENCE_LIVE) ? "" : " Point ambience is not live, so these take effect when it is."
		var/pick = input(src, "Point ambience load settings. Pick one to change it, cancel when done.[not_live]", "Point Ambience Mode") as null|anything in entries
		if(!pick)
			return
		switch(entries[pick])
			if("mode")
				if(ambience.mode == POINT_AMBIENCE_FALLBACK)
					to_chat(src, span_warning("Point ambience is running on FALLBACK LOOPS, set by POINT_AMBIENCE_MODE at boot. This verb cannot return to them, so leaving them lasts until the next round."))
				var/choice = input(src, "Live serves every client the nearest sources per step and per tick. Off is silent. Fallback loops are a boot-time choice and are not offered: switching into them on a running round gives every source a plain looping sound at once and delays everything else in SSsound_loops.", "Point Ambience Mode", point_ambience_mode_name(ambience.mode)) as null|anything in list("Live", "Off")
				var/new_mode = (choice == "Live") ? POINT_AMBIENCE_LIVE : POINT_AMBIENCE_OFF
				if(!choice || new_mode == ambience.mode)
					continue
				point_ambience_setting_changed("mode", point_ambience_mode_name(ambience.mode), choice)
				ambience.set_mode(new_mode)
			if("interval")
				var/binds = steps ? " Steps is [steps], so a natural mover is served by step count sooner and this binds only for one stepping slower than [round(interval / steps, 0.1)] ds a step." : " Steps is off, so this sets the spacing for everyone moving."
				var/value = point_ambience_number("Longest time in deciseconds between two move-hook services of one client. 0 serves on every step.[binds]", "Move Interval", interval)
				if(!isnull(value))
					point_ambience_setting_changed("move interval", interval, value)
					ambience.move_service_interval = value
			if("running")
				var/binds = steps ? " Steps is [steps], so a natural runner is served by step count sooner and this binds only for one stepping slower than [round((running ? running : interval) / steps, 0.1)] ds a step." : ""
				var/value = point_ambience_number("Replaces the move interval for a client on run intent. 0 means no override, so runners use the move interval, not that they are uncapped. Does nothing while the move interval is 0, which turns the gate off for everyone.[binds]", "Running Override", running)
				if(!isnull(value))
					point_ambience_setting_changed("running override", running, value)
					ambience.move_service_interval_running_override = value
			if("steps")
				var/value = point_ambience_number("Most steps a client covers between move-hook services at a natural pace, walking or running. It only shortens the two intervals, which stay as caps, and 0 leaves them alone. Under an interval of 12, 2 serves a speed 10 walker every 6 ds instead of every 12, twice the services.", "Steps", steps)
				if(!isnull(value))
					point_ambience_setting_changed("steps", steps, value)
					ambience.move_service_steps = value
			if("cutoff")
				var/value = point_ambience_toggle("A client stepping faster than a natural speed 15 run, from a drug, a power, a shapeshift or a fast mount, hears no point ambience while moving. A torch in their own hand keeps playing. Off serves them like anyone else.", "Speed Cutoff", ambience.speed_cutoff)
				if(!isnull(value))
					point_ambience_setting_changed("speed cutoff", ambience.speed_cutoff ? "on" : "off", value ? "on" : "off")
					ambience.speed_cutoff = value
			if("cap")
				var/value = point_ambience_number("Ceiling on move-hook services in one tick across every client. With the queue on it is the drain's budget and the rest wait for the next tick. Inline, excess steps are refused, and a gate also refuses once the tick is half spent. 0 turns off both. At 20 ticks a second, 8 allows up to 160 services a second, enough for 48 walkers each served on every step.", "Services Per Tick", cap)
				if(!isnull(value))
					point_ambience_setting_changed("services per tick", cap, value)
					ambience.max_services_per_tick = value
			if("queue")
				// fire() drains existing marks even when queueing is disabled. Only new movement
				// runs inline
				var/value = point_ambience_toggle("On: a step marks the client, and the subsystem serves everyone marked on its next fire, oldest first, up to the cap and inside its own tick budget. Off: each step is served inline inside Move(), at the end of a tick after everything else has spent its share, where the only rail refuses services once the tick is half spent. Off makes a loaded server worse, not cheaper.", "Queue", ambience.use_queue)
				if(!isnull(value))
					point_ambience_setting_changed("queue", ambience.use_queue ? "on" : "off", value ? "on" : "off")
					ambience.use_queue = value
			if("skip")
				var/value = point_ambience_number("Deciseconds within which the once-a-second walk passes over a client a step already served. A walker served by movement would otherwise be walked again at a tile they are about to leave. 0 never skips. The price is the catch-up after stopping: the worst case becomes this plus one second.", "Standing Skip", ambience.standing_skip)
				if(!isnull(value))
					point_ambience_setting_changed("standing skip", ambience.standing_skip, value)
					ambience.standing_skip = value
			if("doors")
				var/value = point_ambience_number("Deciseconds between gathers of the listeners near a door that opened or shut, who are then served again, so someone standing still hears the change. 0 turns it off, and they keep what they heard until they step. A door worked back and forth is gathered once a period, so a shorter one reacts sooner and costs more. Measured with one listener: about 24 us a gather plus 72 us for each listener served again.", "Door Re-check", door_period)
				if(!isnull(value))
					point_ambience_setting_changed("door re-check", door_period, value)
					ambience.door_recheck = value > 0
					if(value)
						ambience.door_recheck_period = value
					else
						ambience.changed_doors.Cut()
			if("reset")
				var/confirm = input(src, "Reset every setting but the mode to its config value, and the door re-check to its default?", "Reset Point Ambience") as null|anything in list("Reset", "Cancel")
				if(confirm == "Reset")
					point_ambience_reset_settings()

/// Puts every setting the config seeds, the mode aside, back to its config value, logging each change
/client/proc/point_ambience_reset_settings()
	var/datum/controller/subsystem/point_ambience/ambience = SSpoint_ambience
	var/value = CONFIG_GET(number/point_ambience_move_interval)
	point_ambience_setting_changed("move interval", ambience.move_service_interval, value)
	ambience.move_service_interval = value
	value = CONFIG_GET(number/point_ambience_move_interval_running_override)
	point_ambience_setting_changed("running override", ambience.move_service_interval_running_override, value)
	ambience.move_service_interval_running_override = value
	value = CONFIG_GET(number/point_ambience_move_steps)
	point_ambience_setting_changed("steps", ambience.move_service_steps, value)
	ambience.move_service_steps = value
	value = !!CONFIG_GET(number/point_ambience_speed_cutoff)
	point_ambience_setting_changed("speed cutoff", ambience.speed_cutoff ? "on" : "off", value ? "on" : "off")
	ambience.speed_cutoff = value
	value = CONFIG_GET(number/point_ambience_max_services_per_tick)
	point_ambience_setting_changed("services per tick", ambience.max_services_per_tick, value)
	ambience.max_services_per_tick = value
	value = !!CONFIG_GET(number/point_ambience_queue)
	point_ambience_setting_changed("queue", ambience.use_queue ? "on" : "off", value ? "on" : "off")
	ambience.use_queue = value
	value = CONFIG_GET(number/point_ambience_standing_skip)
	point_ambience_setting_changed("standing skip", ambience.standing_skip, value)
	ambience.standing_skip = value
	// Reset configured acoustic settings too, invalidating their previous results
	value = CONFIG_GET(number/point_ambience_falloff_hardness)
	if(value != ambience.falloff_hardness)
		point_ambience_setting_changed("falloff hardness", ambience.falloff_hardness, value)
		ambience.set_falloff_hardness(value)
	value = !!CONFIG_GET(number/point_ambience_pan_depth_floor)
	if(value != !!ambience.pan_depth_floor)
		point_ambience_setting_changed("pan depth floor", ambience.pan_depth_floor ? "on" : "off", value ? "on" : "off")
		ambience.pan_depth_floor = value
		ambience.invalidate_listener_cache()
	// No config entry, so the default in the code
	value = initial(ambience.door_recheck) ? initial(ambience.door_recheck_period) : 0
	point_ambience_setting_changed("door re-check", ambience.door_recheck ? ambience.door_recheck_period : 0, value)
	ambience.door_recheck = initial(ambience.door_recheck)
	ambience.door_recheck_period = initial(ambience.door_recheck_period)

/// A whole number of at least 0, or null when cancelled
/client/proc/point_ambience_number(message, title, current)
	var/value = input(src, message, title, current) as null|num
	return isnull(value) ? null : max(0, round(value))

/// TRUE or FALSE, or null when cancelled. A list rather than alert(), which has no cancel
/client/proc/point_ambience_toggle(message, title, current)
	var/choice = input(src, message, title, current ? "On" : "Off") as null|anything in list("On", "Off")
	return isnull(choice) ? null : (choice == "On")

/// One admin message and log line per setting that actually changed
/client/proc/point_ambience_setting_changed(setting, old_value, new_value)
	if(old_value == new_value)
		return
	var/summary = "set point ambience [setting] from [old_value] to [new_value]"
	message_admins("[key_name_admin(src)] [summary].")
	log_admin("[key_name(src)] [summary].")

/proc/point_ambience_mode_name(mode)
	switch(mode)
		if(POINT_AMBIENCE_LIVE)
			return "Live"
		if(POINT_AMBIENCE_OFF)
			return "Off"
		if(POINT_AMBIENCE_FALLBACK)
			return "Fallback loops"
	return "unknown"
