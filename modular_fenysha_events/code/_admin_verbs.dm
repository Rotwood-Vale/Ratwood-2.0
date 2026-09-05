/**
 * Module-wide admin verb registration.
 *
 * add_admin_verbs and remove_admin_verbs can only be overridden once each, so
 * every verb this module adds is granted here rather than from its own file.
 */

/// Verbs this module grants to holders of R_FUN.
GLOBAL_LIST_INIT(fenysha_fun_verbs, list(
	/client/proc/fenysha_mandelbrot,
	/client/proc/fenysha_shockwave,
	/client/proc/fenysha_shockwave_settings,
	/client/proc/void_out_cinematic, 
	/client/proc/outdoor_set_time, 
	/client/proc/outdoor_freeze_time,
	/client/proc/outdoor_set_lighting, 
	/client/proc/outdoor_unfreeze_time, 
	/client/proc/outdoor_light_flash, 
	/client/proc/outdoor_strobe,
	/client/proc/fenysha_narrate_direct,
	/client/proc/fenysha_narrate_local,
	/client/proc/fenysha_narrate_global,
))

/client/add_admin_verbs()
	. = ..()
	if(holder?.rank?.rights & R_FUN)
		verbs += GLOB.fenysha_fun_verbs

/client/remove_admin_verbs()
	. = ..()
	verbs -= GLOB.fenysha_fun_verbs
