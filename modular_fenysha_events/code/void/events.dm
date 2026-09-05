/datum/cinematic/void_consume_stars 
	id = "void_consume_stars"
	cleanup_time = 3 SECONDS

/datum/cinematic/void_consume_stars/content()
	screen.icon_state = null
	cinematic_sound(sound('modular_fenysha_events/sound/streets_sound.ogg'))
	flick("streets_up",screen)
	sleep(65)
	cinematic_sound(sound('modular_fenysha_events/sound/rising_tenstion.ogg'))
	flick("void_consume_sky",screen)
	sleep(80)
	special()
	screen.icon_state = "void_out"

/datum/cinematic/void_consume_stars/special()
	SSoutdoor_effects.admin_lighting_override = TRUE
	SSoutdoor_effects.admin_lighting_color = "#6A35A8"

	for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
		if(!SP)
			continue

		animate(
			SP,
			color = "#6A35A8",
			time = 3 SECONDS,
			easing = SINE_EASING,
			flags = ANIMATION_END_NOW
		)



/client/proc/void_out_cinematic()
	set category = "Fun"
	set name = "Run event cinematic"
	set desc = "Chose on the void out cinematics and run it "
	
	
	if(!check_rights(R_FUN))
		return
	var/list/possible_cinematics = list(
		"Stars dafe down", 
		"Void capsule open", 
		"Eyesh in the sky",
		"Void ship crash", 
	)
	var/chosed = tgui_input_list(usr, "Chose cinematic", "Void out", possible_cinematics)
	
	if(!chosed)
		return

	switch(chosed)
		if("Stars dafe down")
			Cinematic("void_consume_stars", world)
		if("Void capsule open")
			return
		if("Eyesh in the sky")
			return
		if("Void ship crash")
			return
	message_admins("[key_name_admin(usr)], play void out cinematic [chosed].")


/**
 * Some overrides for SSoutdoor to control map ligthing
 */
/datum/controller/subsystem/outdoor_effects
	var/admin_time_override = FALSE
	var/datum/time_of_day/admin_time_step

	var/admin_lighting_override = FALSE
	var/admin_lighting_color



/datum/controller/subsystem/outdoor_effects/get_time_of_day()
	if(admin_time_override && admin_time_step)
		current_step_datum = admin_time_step

		if(!picked_color)
			picked_color = pick(admin_time_step.color)

		next_step_datum = null
		next_day = FALSE

		if(!last_color)
			last_color = picked_color

		return

	if(current_step_datum)
		last_color = picked_color

	var/time = station_time()
	var/datum/time_of_day/new_step = null

	for(var/i in 1 to length(time_cycle_steps))
		if(time >= time_cycle_steps[i].start)
			new_step = time_cycle_steps[i]
			next_step_datum = i == length(time_cycle_steps) ? time_cycle_steps[1] : time_cycle_steps[i + 1]

	if(!new_step)
		new_step = time_cycle_steps[length(time_cycle_steps)]
		next_step_datum = time_cycle_steps[1]

	current_step_datum = new_step
	picked_color = pick(current_step_datum.color)

	if(next_step_datum.start <= current_step_datum.start)
		next_day = TRUE

	if(!last_color)
		last_color = picked_color


/datum/controller/subsystem/outdoor_effects/check_cycle()
	if(admin_time_override)
		return FALSE

	if(!next_step_datum)
		get_time_of_day()
		return TRUE

	if(station_time() > next_step_datum.start)
		if(next_day)
			return FALSE

		get_time_of_day()
		return TRUE
	else if(next_day)
		next_day = FALSE

	return FALSE


/datum/controller/subsystem/outdoor_effects/proc/get_effective_lighting_color()
	if(admin_lighting_override && admin_lighting_color)
		return admin_lighting_color

	return picked_color



/datum/controller/subsystem/outdoor_effects/proc/admin_set_time(datum/time_of_day/new_time, freeze = TRUE)
	if(!new_time)
		return

	admin_time_step = new_time
	admin_time_override = freeze

	current_step_datum = new_time
	picked_color = pick(new_time.color)
	last_color = picked_color

	for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in sunlighting_planes)
		if(SP)
			SP.color = picked_color



/datum/controller/subsystem/outdoor_effects/transition_sunlight_color(
	atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP
)
	if(!SP)
		return

	if(!next_step_datum && !admin_lighting_override)
		get_time_of_day()

	var/target_color = get_effective_lighting_color()

	if(!target_color)
		return

	var/timeDiff = 1 SECONDS

	if(next_step_datum && !admin_lighting_override)
		timeDiff = min(
			(1 HOURS / SSticker.station_time_rate_multiplier),
			daytimeDiff(station_time(), next_step_datum.start)
		)

	animate(
		SP,
		color = target_color,
		time = timeDiff,
		easing = SINE_EASING
	)




/client/proc/outdoor_set_time()
	set category = "Fun"
	set name = "Outdoor: Set Time"
	set desc = "Set and lock the outdoor lighting to a specific time of day."

	if(!check_rights(R_FUN))
		return

	var/list/time_options = list(
		"Absolute Darkness"
	)

	for(var/datum/time_of_day/step in SSoutdoor_effects.time_cycle_steps)
		time_options += step.name

	var/chosen = tgui_input_list(
		usr,
		"Choose time of day",
		"Outdoor Effects",
		time_options
	)

	if(!chosen)
		return

	// Absolute darkness is a special lighting override.
	if(chosen == "Absolute Darkness")
		var/datum/time_of_day/daytime_step

		for(var/datum/time_of_day/step in SSoutdoor_effects.time_cycle_steps)
			if(step.name == "Daytime")
				daytime_step = step
				break

		if(daytime_step)
			SSoutdoor_effects.admin_set_time(daytime_step, TRUE)

		SSoutdoor_effects.admin_lighting_override = TRUE
		SSoutdoor_effects.admin_lighting_color = "#000000"

		for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
			if(!SP)
				continue

			animate(
				SP,
				color = "#000000",
				time = 3 SECONDS,
				easing = SINE_EASING,
				flags = ANIMATION_END_NOW
			)

		message_admins("[key_name_admin(usr)] set outdoor lighting to absolute darkness.")
		return

	// Normal time of day.
	for(var/datum/time_of_day/step in SSoutdoor_effects.time_cycle_steps)
		if(step.name != chosen)
			continue

		SSoutdoor_effects.admin_lighting_override = FALSE
		SSoutdoor_effects.admin_lighting_color = null

		SSoutdoor_effects.admin_set_time(step, TRUE)
		break

	message_admins("[key_name_admin(usr)] set outdoor time to [chosen] and locked it.")


/client/proc/outdoor_set_lighting()
	set category = "Fun"
	set name = "Outdoor: Set Lighting"
	set desc = "Smoothly change the global outdoor lighting."

	if(!check_rights(R_FUN))
		return

	var/list/lighting_options = list(
		"Normal",
		"Blackout",
		"White",
		"Red",
		"Blue",
		"Purple",
		"Green"
	)

	var/chosen = tgui_input_list(
		usr,
		"Choose lighting state",
		"Outdoor Lighting",
		lighting_options
	)

	if(!chosen)
		return

	switch(chosen)
		if("Normal")
			SSoutdoor_effects.admin_lighting_override = FALSE
			SSoutdoor_effects.admin_lighting_color = null

			for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
				if(!SP)
					continue

				animate(
					SP,
					color = SSoutdoor_effects.picked_color,
					time = 3 SECONDS,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW
				)

		if("Blackout")
			SSoutdoor_effects.admin_lighting_override = TRUE
			SSoutdoor_effects.admin_lighting_color = "#000000"

			for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
				if(!SP)
					continue

				animate(
					SP,
					color = "#000000",
					time = 3 SECONDS,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW
				)

		if("White")
			SSoutdoor_effects.admin_lighting_override = TRUE
			SSoutdoor_effects.admin_lighting_color = "#FFFFFF"

			for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
				if(!SP)
					continue

				animate(
					SP,
					color = "#FFFFFF",
					time = 3 SECONDS,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW
				)

		if("Red")
			SSoutdoor_effects.admin_lighting_override = TRUE
			SSoutdoor_effects.admin_lighting_color = "#AA3030"

			for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
				if(!SP)
					continue

				animate(
					SP,
					color = "#AA3030",
					time = 3 SECONDS,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW
				)

		if("Blue")
			SSoutdoor_effects.admin_lighting_override = TRUE
			SSoutdoor_effects.admin_lighting_color = "#3048AA"

			for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
				if(!SP)
					continue

				animate(
					SP,
					color = "#3048AA",
					time = 3 SECONDS,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW
				)

		if("Purple")
			SSoutdoor_effects.admin_lighting_override = TRUE
			SSoutdoor_effects.admin_lighting_color = "#6A35A8"

			for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
				if(!SP)
					continue

				animate(
					SP,
					color = "#6A35A8",
					time = 3 SECONDS,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW
				)

		if("Green")
			SSoutdoor_effects.admin_lighting_override = TRUE
			SSoutdoor_effects.admin_lighting_color = "#3A9A55"

			for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
				if(!SP)
					continue

				animate(
					SP,
					color = "#3A9A55",
					time = 3 SECONDS,
					easing = SINE_EASING,
					flags = ANIMATION_END_NOW
				)

	message_admins("[key_name_admin(usr)] changed outdoor lighting to [chosen].")




/client/proc/outdoor_freeze_time()
	set category = "Fun"
	set name = "Outdoor: Freeze Time"
	set desc = "Freeze the current outdoor time of day."

	if(!check_rights(R_FUN))
		return

	if(!SSoutdoor_effects.current_step_datum)
		SSoutdoor_effects.get_time_of_day()

	SSoutdoor_effects.admin_time_step = SSoutdoor_effects.current_step_datum
	SSoutdoor_effects.admin_time_override = TRUE

	message_admins("[key_name_admin(usr)] froze outdoor time at [SSoutdoor_effects.admin_time_step.name].")

/client/proc/outdoor_unfreeze_time()
	set category = "Fun"
	set name = "Outdoor: Unfreeze Time"
	set desc = "Return outdoor lighting control to the normal station time."

	if(!check_rights(R_FUN))
		return

	SSoutdoor_effects.admin_time_override = FALSE
	SSoutdoor_effects.admin_time_step = null

	// Immediately synchronize with the actual station time.
	SSoutdoor_effects.get_time_of_day()

	for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
		if(SP)
			SSoutdoor_effects.transition_sunlight_color(SP)

	message_admins("[key_name_admin(usr)] unfroze outdoor time.")


/proc/outdoor_light_flash(
	duration = 2,
	return_duration = 5,
	flash_color = "#FFFFFF"
)
	if(!SSoutdoor_effects?.sunlighting_planes)
		return

	var/restore_color = SSoutdoor_effects.get_effective_lighting_color()

	if(!restore_color)
		restore_color = "#FFFFFF"

	for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
		if(!SP)
			continue

		// Interrupt whatever lighting animation is currently running.
		animate(SP, flags = ANIMATION_END_NOW)

		animate(
			SP,
			color = flash_color,
			time = duration,
			easing = SINE_EASING
		)

		animate(
			color = restore_color,
			time = return_duration,
			easing = SINE_EASING
		)


/proc/outdoor_light_strobe(
	flashes = 3,
	flash_duration = 10,
	return_duration = 1,
	flash_color = "#FFFFFF"
)
	if(!SSoutdoor_effects?.sunlighting_planes)
		return

	var/restore_color = SSoutdoor_effects.get_effective_lighting_color()

	if(!restore_color)
		restore_color = "#FFFFFF"

	for(var/atom/movable/screen/fullscreen/lighting_backdrop/sunlight/SP in SSoutdoor_effects.sunlighting_planes)
		if(!SP)
			continue

		animate(SP, flags = ANIMATION_END_NOW)

		for(var/i in 1 to flashes)
			animate(
				SP,
				color = flash_color,
				time = flash_duration,
				easing = SINE_EASING
			)

			animate(
				color = restore_color,
				time = return_duration,
				easing = SINE_EASING
			)



/client/proc/outdoor_light_flash()
	set category = "Fun"
	set name = "Outdoor: Light Flash"
	set desc = "Create a bright flash in the outdoor lighting."

	if(!check_rights(R_FUN))
		return

	outdoor_light_flash()

	message_admins("[key_name_admin(usr)] triggered an outdoor light flash.")

/client/proc/outdoor_strobe()
	set category = "Fun"
	set name = "Outdoor: Light Strobe"
	set desc = "Create several rapid flashes in the outdoor lighting."

	if(!check_rights(R_FUN))
		return

	outdoor_light_strobe()

	message_admins("[key_name_admin(usr)] triggered an outdoor light strobe.")

