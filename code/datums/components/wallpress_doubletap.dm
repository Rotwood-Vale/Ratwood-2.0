#define WALLPRESS_DOUBLETAP_WINDOW (0.5 SECONDS)

/**
 * Double-tapping a direction away from an adjacent wall while the movement lock is held backs the mob
 * against it, leaning with their back to the wall.
 */
/datum/component/wallpress_doubletap
	var/last_tap_dir = NONE
	COOLDOWN_DECLARE(doubletap_window)

/datum/component/wallpress_doubletap/Initialize()
	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/wallpress_doubletap/RegisterWithParent()
	RegisterSignal(parent, COMSIG_MOB_MOVEMENT_LOCKED_KEY_PRESSED, PROC_REF(on_movement_key_pressed))

/datum/component/wallpress_doubletap/UnregisterFromParent()
	UnregisterSignal(parent, COMSIG_MOB_MOVEMENT_LOCKED_KEY_PRESSED)

/datum/component/wallpress_doubletap/proc/on_movement_key_pressed(mob/living/source, direction)
	SIGNAL_HANDLER
	if(source.is_wallpressed() || !(direction in GLOB.cardinals))
		return
	if((last_tap_dir != direction) || COOLDOWN_FINISHED(src, doubletap_window))
		last_tap_dir = direction
		COOLDOWN_START(src, doubletap_window, WALLPRESS_DOUBLETAP_WINDOW)
		return
	last_tap_dir = NONE
	COOLDOWN_RESET(src, doubletap_window)
	var/turf/target = get_step(source, REVERSE_DIR(direction))
	var/atom/leanable = target?.get_wallpress_atom()
	leanable?.wallpress(source)

#undef WALLPRESS_DOUBLETAP_WINDOW
