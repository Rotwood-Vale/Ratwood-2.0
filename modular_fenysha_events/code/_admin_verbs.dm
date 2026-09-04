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
))

/client/add_admin_verbs()
	. = ..()
	if(holder?.rank?.rights & R_FUN)
		verbs += GLOB.fenysha_fun_verbs

/client/remove_admin_verbs()
	. = ..()
	verbs -= GLOB.fenysha_fun_verbs
