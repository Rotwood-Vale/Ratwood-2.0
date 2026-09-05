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

/datum/cinematic/void_capsules_open
	id = "void_capsules_open"
	cleanup_time = 1 SECONDS

/datum/cinematic/void_capsules_open/content()
	screen.icon_state = null
	flick("capsules_open",screen)
	sleep(30)
	cinematic_sound(sound('modular_fenysha_events/sound/capsule_open.ogg'))
	sleep(20)
	special()

/datum/cinematic/void_capsules_open/special()
	for(var/obj/structure/void_capsule/capsule in world)
		capsule.open()


/datum/cinematic/eyes_in_the_sky
	id = "eyes_in_the_sky"
	cleanup_time = 0 SECONDS

/datum/cinematic/eyes_in_the_sky/content()
	screen.icon_state = null
	cinematic_sound(sound('modular_fenysha_events/sound/streets_sound.ogg'))
	flick("streets_up",screen)
	sleep(65)
	cinematic_sound(sound('modular_fenysha_events/sound/eyes_in_the_sky.ogg'))
	flick("eyes_in_the_sky", screen)
	sleep(60)
	special()


/datum/cinematic/eyes_in_the_sky/special()
	for(var/mob/living/living in GLOB.player_list)
		if(istype(living) && !living.stat == DEAD)
			living.apply_status_effect(/datum/status_effect/fractal_screen)
			living.apply_status_effect(/datum/status_effect/fractal_maptext)



/datum/cinematic/void_ship_crash
	id = "void_ship_crash"
	cleanup_time = 0 SECONDS

	/**
	 * Absolute z-level the ship comes down on.
	 *
	 * Map specific, and there is no reliable way to derive it: Rockhill loads
	 * five levels of its own plus five more from other_z, and map_config gives
	 * ZTRAIT_STATION to all of them, so "the first station level" is not the
	 * surface. On Rockhill the surface is z3 and z2 down is underground.
	 */
	var/crash_z = 3
	/// Linked levels the wave carries through, up and down from the crash.
	var/crash_z_reach = 4

/datum/cinematic/void_ship_crash/content()
	screen.icon_state = null
	cinematic_sound(sound('modular_fenysha_events/sound/void_ship_land.ogg'))
	flick("void_ship_descend",screen)

	sleep(75)

	flick("void_ship_shot",screen)
	sleep(10)
	cinematic_sound(sound('modular_fenysha_events/sound/beam_attack.ogg'))
	sleep(35)

	cinematic_sound(sound('modular_fenysha_events/sound/void_ship_damage.ogg'))
	flick("void_ship_explosion",screen)
	sleep(30)
	cinematic_sound(sound('modular_fenysha_events/sound/glass_crack.ogg'))
	sleep(30)
	cinematic_sound(sound('modular_fenysha_events/sound/void_ship_destroy.ogg'))
	sleep(158)
	special()

/datum/cinematic/void_ship_crash/special()
	var/list/levels = SSmapping.levels_by_trait(ZTRAIT_STATION)
	if(!length(levels))
		return

	// world.maxz is no good here either - SSmapping adds its own
	// "Transit/Reserved" level on top, and centring the blast there put it on
	// an empty reservation that links to nothing.
	var/landing_z = (crash_z in levels) ? crash_z : levels[1]

	var/turf/epicenter = locate(
		round(world.maxx * 0.5),
		round(world.maxy * 0.5),
		landing_z
	)
	if(!epicenter)
		return

	// From the centre, the furthest corner is half the map diagonal away. That
	// is the smallest radius that genuinely leaves nothing out.
	var/radius = round(sqrt(world.maxx * world.maxx + world.maxy * world.maxy) * 0.5) + 1

	// The front advances `speed` tiles per tick, so a map-sized radius at the
	// default of 2 would take the better part of a minute to finish arriving.
	// Scale it so the wave crosses the map in about two seconds and reads as a
	// single impact closing the cinematic.
	var/speed = max(2, round(radius / 20))

	message_admins("Void ship crash shockwave: z[landing_z], radius [radius], speed [speed], reaching [crash_z_reach] levels each way from [epicenter.x],[epicenter.y] [ADMIN_JMP(epicenter)]")

	shockwave(
		epicenter,
		radius,
		1,
		speed,
		FALSE,
		null,
		crash_z_reach,
		list(
			"amplitude base" = 80,
			"amplitude gain" = 80,
			// The default only distorts within 30 tiles of the epicentre, which
			// on a map this size is nobody - the blast is centred on the middle
			// of the level. Everything the wave reaches should see it.
			"range tiles" = radius,
		),
		list(
			/*
			 * Walls stop attenuating this one.
			 *
			 * The energy model is per sector: a wall that fails to break keeps
			 * only `wall hold` of that direction's energy. Underground the crash
			 * is boxed in by rock on every side, and stone needs 1800 damage
			 * against the 600 this deals - so every sector meets a wall it
			 * cannot break, loses 65% of its energy, and the wave is gone within
			 * three tiles. Correct for a normal blast, wrong for the one moment
			 * the whole map is supposed to feel.
			 */
			"wall hold" = 1,
			"wall absorb scale" = 1000000,
		)
	)


/client/proc/void_out_cinematic()
	set category = "Fun"
	set name = "Run event cinematic"
	set desc = "Choose one of the void out cinematics and run it "


	if(!check_rights(R_FUN))
		return
	var/list/possible_cinematics = list(
		"Stars fade down",
		"Void capsule open",
		"Eyes in the sky",
		"Void ship crash",
	)
	var/chosen = tgui_input_list(usr, "Choose cinematic", "Void out", possible_cinematics)

	if(!chosen)
		return

	switch(chosen)
		if("Stars fade down")
			Cinematic("void_consume_stars", world)
		if("Void capsule open")
			Cinematic("void_capsules_open", world)
		if("Eyes in the sky")
			Cinematic("eyes_in_the_sky", world)
		if("Void ship crash")
			Cinematic("void_ship_crash", world)
	message_admins("[key_name_admin(usr)], played void out cinematic [chosen].")


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

