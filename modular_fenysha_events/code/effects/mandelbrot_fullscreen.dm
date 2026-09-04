/// Fullscreen category the mandelbrot overlay occupies.
#define MANDELBROT_FULLSCREEN "mandelbrot"

/// Peak scale the breathing animation swells to.
#define MANDELBROT_PULSE_SCALE 1.06

/atom/movable/screen/fullscreen/mandelbrot
	icon = 'modular_fenysha_events/icons/effects/mandelbrot.dmi'
	icon_state = "mandelbrot"
	alpha = 0
	show_when_dead = TRUE
	/// Half a breath, in ticks. Zero disables the pulse entirely.
	var/pulse_time = 3 SECONDS

/atom/movable/screen/fullscreen/mandelbrot/update_for_view(client_view)
	. = ..()
	start_pulse()

/// Restarts the breathing animation around whatever transform the view fixup left us.
/atom/movable/screen/fullscreen/mandelbrot/proc/start_pulse()
	if(!pulse_time)
		return
	var/matrix/settled = matrix(transform)
	var/matrix/swelled = matrix(transform)
	swelled.Scale(MANDELBROT_PULSE_SCALE)
	animate(src, transform = swelled, time = pulse_time, loop = -1, easing = SINE_EASING, flags = ANIMATION_PARALLEL)
	animate(transform = settled, time = pulse_time, easing = SINE_EASING)

/**
 * Fades the mandelbrot overlay in on this mob.
 *
 * Arguments:
 * * target_alpha - opacity to settle at, 0 to 255.
 * * fade - fade-in duration in ticks. Zero snaps straight to target_alpha.
 * * screen_type - screen subtype, for callers that define their own.
 * * blend - blend mode. BLEND_ADD reads as a glow rather than a wash.
 */
/mob/proc/overlay_mandelbrot(target_alpha = 140, fade = 2 SECONDS, screen_type = /atom/movable/screen/fullscreen/mandelbrot, blend = BLEND_DEFAULT)
	var/atom/movable/screen/fullscreen/mandelbrot/screen = overlay_fullscreen(MANDELBROT_FULLSCREEN, screen_type)
	if(!istype(screen))
		return
	// Always reassign: overlay_fullscreen reuses a screen of the same type, so a
	// blend from an earlier call would otherwise stick.
	screen.blend_mode = blend
	target_alpha = clamp(target_alpha, 0, 255)
	if(fade)
		animate(screen, alpha = target_alpha, time = fade, flags = ANIMATION_PARALLEL)
	else
		screen.alpha = target_alpha
	return screen

/// Fades the mandelbrot overlay out and drops it.
/mob/proc/clear_mandelbrot(fade = 2 SECONDS)
	clear_fullscreen(MANDELBROT_FULLSCREEN, fade)

/client/proc/fenysha_mandelbrot()
	set category = "Fun"
	set name = "Mandelbrot Overlay"
	set desc = "Fades the looping mandelbrot overlay in or out."
	if(!check_rights(R_FUN))
		return

	var/choice = alert(usr, "Show the mandelbrot overlay to who?", "Mandelbrot Overlay", "Me", "Everyone", "Clear All")
	if(!choice)
		return

	if(choice == "Clear All")
		for(var/mob/player as anything in GLOB.player_list)
			player.clear_mandelbrot()
		return

	var/target_alpha = input(usr, "Opacity, 0 to 255.", "Mandelbrot Overlay", 140) as num|null
	if(isnull(target_alpha))
		return

	var/blend = (alert(usr, "Blend additively?", "Mandelbrot Overlay", "No", "Yes") == "Yes") ? BLEND_ADD : BLEND_DEFAULT

	if(choice == "Me")
		mob?.overlay_mandelbrot(target_alpha, blend = blend)
		return

	for(var/mob/player as anything in GLOB.player_list)
		player.overlay_mandelbrot(target_alpha, blend = blend)

#undef MANDELBROT_PULSE_SCALE
