/datum/component/hunting_blocker
	/// Cooldown before another depth 0 track can be started
	COOLDOWN_DECLARE(hunt_cooldown)

/datum/component/hunting_blocker/Initialize()
	if(!ishuman(parent))
		return COMPONENT_INCOMPATIBLE

/datum/component/hunting_blocker/proc/can_start_hunt()
	if(!COOLDOWN_FINISHED(src, hunt_cooldown))
		var/time_left = DisplayTimeText(COOLDOWN_TIMELEFT(src, hunt_cooldown))
		to_chat(parent, span_warning("You've recently disturbed a fresh trail. You need to wait [time_left] before you can scout another new one."))
		return FALSE
	return TRUE

/datum/component/hunting_blocker/proc/register_hunt()
	COOLDOWN_START(src, hunt_cooldown, 90 SECONDS)
